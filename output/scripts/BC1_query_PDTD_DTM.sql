-- ============================================================================
-- BC1 — Báo cáo RLOS APPLICATION
-- Tái hiện câu lệnh báo cáo từ tầng PDTD_DTM, đối chiếu SRS BC1 + lld/BC1.csv
-- (review 2026-10-04 / 2026-10-12 / 2026-10-26 / 2026-10-27)
--
-- Tham số: v_batch_date (= PROCESSED_DATE người dùng chọn, mặc định T-1)
--          v_branch_code (tùy chọn, NULL = tất cả chi nhánh)
--
-- Grain báo cáo: 1 dòng / hồ sơ (WI_NAME) tại DAYID = v_batch_date trên
-- FCT_RLOS_APPLICATION (driving table, PK DAYID+WI_NAME).
--
-- Fan-out đã xử lý bằng CTE pre-aggregate trước khi LEFT JOIN vào driving
-- table (tránh nhân dòng báo cáo):
--   - FCT_RLOS_CUSTOMER      : 1 hồ sơ x N giấy tờ applicant
--   - FCT_RLOS_COREPAYER     : 1 hồ sơ x 0..4 corepayer x N giấy tờ
--   - FCT_RLOS_COLLATERAL    : 1 hồ sơ x N tài sản đảm bảo (4 loại UNION)
--   - FCT_RLOS_APPLICATION_SECONDPRODUCT : 1 hồ sơ x N sản phẩm phụ
-- ============================================================================

WITH

-- ---------------------------------------------------------------------------
-- 1 dòng đại diện/hồ sơ cho applicant chính: ưu tiên giấy tờ TCC/CC trước
-- (cùng tiêu chí pivot dùng cho ADD_ID), tránh fan-out các cột applicant-grain
-- (CUSTOMER_NAME, DATE_OF_BIRTH, GENDER, địa chỉ, hôn nhân, học vấn...).
-- ---------------------------------------------------------------------------
cust_main AS (
    SELECT
        c.*,
        ROW_NUMBER() OVER (
            PARTITION BY c.WI_NAME
            ORDER BY CASE WHEN c.ID_TYPE IN ('TCC','CC') THEN 0 ELSE 1 END, c.ID_TYPE
        ) AS rn
    FROM PDTD_DTM.FCT_RLOS_CUSTOMER c
    WHERE c.DAYID = v_batch_date
),

-- ADD_ID / ADD_ID_OTHER: nối chuỗi nhiều giấy tờ cùng hồ sơ theo nhóm ID_TYPE
cust_add_id AS (
    SELECT
        WI_NAME,
        LISTAGG(CASE WHEN ID_TYPE IN ('TCC','CC') THEN ID_NUMBER END, ';')
            WITHIN GROUP (ORDER BY ID_TYPE)                              AS ADD_ID,
        LISTAGG(CASE WHEN ID_TYPE NOT IN ('TCC','CC') THEN ID_NUMBER END, ';')
            WITHIN GROUP (ORDER BY ID_TYPE)                              AS ADD_ID_OTHER
    FROM PDTD_DTM.FCT_RLOS_CUSTOMER
    WHERE DAYID = v_batch_date
    GROUP BY WI_NAME
),

-- ---------------------------------------------------------------------------
-- Corepayer: LISTAGG tên + giấy tờ của toàn bộ corepayer cùng hồ sơ
-- (HLD chưa chốt cách LISTAGG — thiết kế tại đây theo cùng pattern ADD_ID)
-- ---------------------------------------------------------------------------
corepayer_agg AS (
    SELECT
        WI_NAME,
        LISTAGG(DISTINCT FULL_NAME, ';') WITHIN GROUP (ORDER BY FULL_NAME)          AS CO_REPAYER,
        LISTAGG(CASE WHEN ID_TYPE IN ('TCC','CC') THEN ID_NUMBER END, ';')
            WITHIN GROUP (ORDER BY ID_TYPE)                                        AS ADD_ID_COREPAYER,
        LISTAGG(CASE WHEN ID_TYPE NOT IN ('TCC','CC') THEN ID_NUMBER END, ';')
            WITHIN GROUP (ORDER BY ID_TYPE)                                        AS ADD_ID_OTHER_COREPAYER
    FROM PDTD_DTM.FCT_RLOS_COREPAYER
    WHERE DAYID = v_batch_date
    GROUP BY WI_NAME
),

-- ---------------------------------------------------------------------------
-- Collateral: gộp theo COLLATERAL_TYPE_CODE, tránh fan-out N tài sản/hồ sơ
-- ---------------------------------------------------------------------------
collateral_agg AS (
    SELECT
        WI_NAME,
        CASE WHEN COUNT(CASE WHEN COLLATERAL_TYPE_CODE = 'REALESTATE' THEN 1 END) > 0
             THEN 'YES' ELSE 'NO' END                                               AS TSBD_BDS,
        CASE WHEN COUNT(CASE WHEN COLLATERAL_TYPE_CODE = 'TRANSPORT' THEN 1 END) > 0
             THEN 'YES' ELSE 'NO' END                                               AS TSBD_PTVT,
        CASE WHEN COUNT(CASE WHEN NUMBERSIGN IS NOT NULL THEN 1 END) > 0
             THEN 'YES' ELSE 'NO' END                                               AS TSBD_GTCG,
        LISTAGG(CASE WHEN COLLATERAL_TYPE_CODE = 'REALESTATE' THEN CERTIFICATE_NO END, ';')
            WITHIN GROUP (ORDER BY CERTIFICATE_NO)                                  AS GCN_REAL_ESTATE,
        LISTAGG(CASE WHEN COLLATERAL_TYPE_CODE <> 'REALESTATE' THEN CERTIFICATE_NO END, ';')
            WITHIN GROUP (ORDER BY CERTIFICATE_NO)                                  AS GCN_OTHER,
        LISTAGG(DISTINCT OWNER_NAME, ';') WITHIN GROUP (ORDER BY OWNER_NAME)        AS OWNERSHIP,
        LISTAGG(DISTINCT REL_TO_CUSTOMER, ';') WITHIN GROUP (ORDER BY REL_TO_CUSTOMER) AS TSBD_RELATIONSHIP
    FROM PDTD_DTM.FCT_RLOS_COLLATERAL
    WHERE DAYID = v_batch_date
    GROUP BY WI_NAME
),

-- ---------------------------------------------------------------------------
-- Sản phẩm phụ: SAN_PHAM_PHU/SPP_AMOUNT/SPP_TERM — 1 dòng/loại thường gặp,
-- riêng thẻ tín dụng phụ có thể nhiều dòng/hồ sơ -> gộp LISTAGG an toàn
-- ---------------------------------------------------------------------------
secondproduct_agg AS (
    SELECT
        WI_NAME,
        LISTAGG(SUB_PRODUCT_LINE, ';') WITHIN GROUP (ORDER BY SUB_PRODUCT_LINE)     AS SAN_PHAM_PHU,
        LISTAGG(TO_CHAR(SPP_AMOUNT), ';') WITHIN GROUP (ORDER BY SUB_PRODUCT_LINE)  AS SPP_AMOUNT,
        LISTAGG(TO_CHAR(SPP_TERM), ';') WITHIN GROUP (ORDER BY SUB_PRODUCT_LINE)    AS SPP_TERM
    FROM PDTD_DTM.FCT_RLOS_APPLICATION_SECONDPRODUCT
    WHERE DAYID = v_batch_date
    GROUP BY WI_NAME
)

-- ============================================================================
-- Truy vấn chính — driving table FCT_RLOS_APPLICATION (grain 1 hồ sơ/ngày)
-- ============================================================================
SELECT
    fa.BUSINESS_FLOW                                           AS BI_FLOW,                 -- (1)
    dap.STREAM                                                 AS STREAM,                  -- (2)
    fa.CHANGE_REQUEST                                          AS CHANGE_REQUEST,          -- (3)
    fa.CHANGE_TYPE                                              AS CHANGE_TYPE,             -- (4)
    dct.DETAIL_CHANGE_TYPE_NAME                                 AS CHANGE_TYPE_DETAIL,      -- (5)
    CASE
        WHEN UPPER(cm.CUS_SEGMENT) LIKE '%XANH%' THEN 'XANH'
        WHEN cm.CUS_SEGMENT = 'CBNV'            THEN 'CBNV'
        ELSE 'THUONG'
    END                                                         AS BI_CUS_SEGMENT,         -- (6)
    fa.WI_NAME                                                  AS WINAME,                 -- (7)
    fa.PROCESSED_DATE                                           AS PROCESSED_DATE,         -- (8)
    fa.CREATION_DATE                                            AS CREATION_DATE,          -- (9)
    fa.APPLICATION_STATUS                                       AS BI_APPSTATUS,           -- (10)
    cm.FULL_NAME                                                AS CUSTOMER_NAME,          -- (11)
    cid.ADD_ID                                                  AS ADD_ID,                 -- (12)
    cid.ADD_ID_OTHER                                            AS ADD_ID_OTHER,           -- (13)
    t24c.CUSTOMER_ID                                            AS CUSTOMER_ID,            -- (14)
    cm.DATE_OF_BIRTH                                            AS DATE_OF_BIRTH,          -- (15)
    cm.GENDER                                                   AS GENDER,                 -- (16)
    cm.PERM_ADDRESS                                             AS PERMANENT_RESIDENCE_ADDRESS, -- (17)
    cm.CITY_NAME                                                AS CURRENT_RESIDENTIAL_CITY,    -- (18)
    cm.DISTRICT_NAME                                            AS CURRENT_RESIDENTIAL_DISTRICT,-- (19)
    cm.CURR_WARD                                                AS CURRENT_RESIDENTIAL_WARD,    -- (20)
    cm.CURR_HOUSE_NO || ', ' || cm.CURR_WARD || ', ' ||
        cm.DISTRICT_NAME || ', ' || cm.CITY_NAME                AS CURRENT_RESIDENTIAL_ADDRESS,  -- (21)
    cm.MARRIAGE_STATUS                                          AS MARRIAGE_STATUS,        -- (22)
    cm.EDUCATION_LEVEL                                          AS EDUCATION_LEVEL,        -- (23)
    cm.VEHICLE                                                  AS VEHICLES,               -- (24)
    coll.OWNERSHIP                                               AS OWNERSHIP,              -- (25)
    corep.CO_REPAYER                                            AS CO_REPAYER,             -- (26)
    corep.ADD_ID_COREPAYER                                      AS ADD_ID_COREPAYER,       -- (27)
    corep.ADD_ID_OTHER_COREPAYER                                AS ADD_ID_OTHER_COREPAYER, -- (28)
    dap.CREATE_EMPLOYEE_CODE                                    AS EMPLOYEE_CODE,          -- (29)
    dap.CREATE_EMPLOYEE_NAME                                    AS EMPLOYEE_NAME,          -- (30)
    dap.ZONE                                                    AS ZONE,                   -- (31)
    dco.BRANCH_CODE                                             AS BRANCH_CODE,            -- (32)
    dco.BRANCH_NAME                                             AS BRANCH_NAME,            -- (33)
    dco.COMPANY_CODE                                            AS COMPANY_CODE,           -- (34)
    dco.COMPANY_NAME                                            AS COMPANY_NAME,           -- (35)
    dap.APP_GRP                                                 AS APP_GRP,                -- (36)
    dpr.PRODUCTLINE_CODE                                        AS PRODUCT_LINE,           -- (37)
    dpr.SUB_PRODUCT_NAME                                        AS SUB_PRODUCT,            -- (38)
    dap.IS_SEC_PRODUCT                                          AS SECONDARY_PRODUCTLINE,  -- (39)
    spp.SAN_PHAM_PHU                                            AS SAN_PHAM_PHU,           -- (40)
    fa.LAST_WORKSTEP                                            AS LAST_WORKSTEP,          -- (41)
    fa.PRE_WORKSTEP_CODE                                        AS PRE_WORKSTEP,           -- (42)
    fa.LAST_ENTRYDATE                                           AS LAST_ENTRYDATE,         -- (43)
    fa.LAST_EXITDATE                                            AS LAST_EXITDATE,          -- (44)
    fa.LAST_REMARKS                                             AS LAST_REMARKS,           -- (45)
    fa.LAST_REMARK_DDE                                          AS LAST_REMARK_DDE,        -- (46)
    dwd.DECISION_CODE                                           AS LAST_DECISION,          -- (47)
    fa.UNDERWRITERMAKER_USERMAKE                                AS UNDERWRITERMAKER_TAKERESPON,   -- (48)
    fa.UNDERWRITERCHECKER_USERMAKE                              AS UNDERWRITERCHECKER_TAKERESPON, -- (49)
    fa.APPROVAL_USERMAKE                                        AS APPROVAL_TAKERESPON,    -- (50)
    coll.TSBD_BDS                                               AS TSBD_BDS,               -- (51)
    coll.TSBD_PTVT                                              AS TSBD_PTVT,              -- (52)
    coll.TSBD_GTCG                                              AS TSBD_GTCG,              -- (53)
    coll.GCN_REAL_ESTATE                                        AS GCN_REAL_ESTATE,        -- (54)
    coll.GCN_OTHER                                               AS GCN_OTHER,              -- (55)
    coll.TSBD_RELATIONSHIP                                       AS TSBD_RELATIONSHIP,      -- (57, STT 56 PROPERTY_FORMED không có trong SRS BC1 gốc)
    dap.DEVIATION_FLAG                                          AS DEVIATION,              -- (58)
    dap.POLICY                                                  AS POLICY,                 -- (59)
    dap.CAMPAIGN                                                AS CAMPAIGN,               -- (60)
    dap.PROOF_OF_INCOME                                         AS PROOF_OF_INCOME,        -- (61)
    SUBSTR(
        REGEXP_REPLACE(
               CASE WHEN dap.SALARYFLAG      = 'Yes' THEN 'Lương / ' END
            || CASE WHEN dap.CARFLAG         = 'Yes' THEN 'Cho thuê phương tiện / ' END
            || CASE WHEN dap.HOUSEFLAG       = 'Yes' THEN 'Cho thuê nhà / ' END
            || CASE WHEN dap.ENTERPRISSEFLAG = 'Yes' THEN 'Lợi nhuận doanh nghiệp / ' END
            || CASE WHEN dap.DIVINGFLAG      = 'Yes' THEN 'Cổ tức / ' END
            || CASE WHEN dap.FAIMILYFLAG     = 'Yes' THEN 'Kinh doanh hộ gia đình / ' END
            || CASE WHEN dap.NONLICFLAG      = 'Yes' THEN 'Kinh doanh không ĐKKD / ' END
            || CASE WHEN dap.WAGESFLAG       = 'Yes' THEN 'Tiền công / ' END
            || CASE WHEN dap.PENSIONFLAG     = 'Yes' THEN 'Lương hưu/phụ cấp / ' END
            || CASE WHEN dap.OTHERFLAG       = 'Yes' THEN 'Nguồn thu khác / ' END,
            ' / $', ''
        ), 1, 200
    )                                                            AS REPAYMENT_SOURCE,      -- (62)
    dap.TOTAL_INCOME                                            AS TOTAL_INCOME,           -- (63)
    dap.LOAN_TO_VALUE                                           AS LOAN_TO_VALUE,          -- (64)
    t24card.K_TYPE                                              AS K_TYPE,                 -- (65)
    dcp.PROMOTION_DESC                                          AS PROMOTION_ID,           -- (66)
    t24seab.HOME_ADDRESS                                        AS HOME_ADDRESS,           -- (67)
    fa.APPROVED_AMT_FINAL                                       AS LOAN_AMOUNT,            -- (68)
    fa.APPROVED_TERM                                            AS LOAN_TERM,              -- (69)
    dap.INTEREST_RATE_PCT                                       AS INTEREST_RATE,          -- (70)
    fa.MIN_UWM                                                   AS MIN_UWM,                -- (71)
    fa.MIN_APP                                                   AS MIN_APP,                -- (72)
    fa.LAST_APPROVAL_DATE                                       AS LAST_APPROVAL_DATE,     -- (73)
    fa.CANCEL_USER_DATE                                         AS CAN_USER_DATE,          -- (74)
    fa.AUTO_CANCEL_DATE                                         AS AUTO_CAN_DATE,          -- (75)
    fa.FLAG_AUTO_CANCEL                                         AS FLAG_AUTO_CAN,          -- (76)
    fa.LAST_CAN_REMARKS                                         AS LAST_CAN_REMARKS,       -- (77)
    fa.BRANCH_USER                                               AS BRANCH_USER,            -- (78)
    fa.DDE_USER                                                  AS DDE_USER,               -- (79)
    fa.QC_USER                                                   AS QUALITY_CHECKER,        -- (80)
    fa.UND_MAKER_USER                                           AS UND_MAKER,              -- (81)
    fa.UND_CHECKER_USER                                         AS UND_CHECKER,            -- (82)
    fa.PHV_USER                                                  AS PHV_USER,               -- (83)
    fa.APPROVER_USER                                            AS BI_APPROVER,            -- (84)
    dap.LOAN_OBJECTIVE                                          AS LOAN_OBJECTIVE,         -- (85)
    spp.SPP_AMOUNT                                              AS SPP_AMOUNT,             -- (86)
    spp.SPP_TERM                                                AS SPP_TERM                -- (87)

FROM PDTD_DTM.FCT_RLOS_APPLICATION fa

-- ---- DIM 1:1 theo SK đã resolve sẵn (không gây fan-out) ----
LEFT JOIN PDTD_DTM.DIM_RLOS_APPLICATION dap
       ON dap.DIMENSION_KEY = fa.APPLICATION_SK
LEFT JOIN PDTD_DTM.DIM_RLOS_CHANGE_TYPE dct
       ON dct.DIMENSION_KEY = fa.CHANGE_TYPE_SK
LEFT JOIN PDTD_DTM.DIM_RLOS_WORKSTEP_DECISION dwd
       ON dwd.DIMENSION_KEY = fa.WORKSTEP_DECISION_SK
LEFT JOIN PDTD_DTM.DIM_RLOS_PRODUCT dpr
       ON dpr.DIMENSION_KEY = fa.SUB_PRODUCT_SK
LEFT JOIN PDTD_DTM.DIM_LOS_COMPANY dco
       ON dco.DIMENSION_KEY = fa.COMPANY_SK
LEFT JOIN PDTD_DTM.DIM_RLOS_CARD_PROMOTION dcp
       ON dcp.DIMENSION_KEY = fa.CARD_PROMOTION_SK
LEFT JOIN PDTD_DTM.DIM_T24_CARD t24card
       ON t24card.DIMENSION_KEY = fa.T24_CARD_SK
LEFT JOIN PDTD_DTM.DIM_T24_SEAB_MAIN_CARD t24seab
       ON t24seab.DIMENSION_KEY = fa.T24_SEAB_MAIN_CARD_SK

-- ---- CTE pre-aggregate theo WI_NAME (đã xử lý fan-out) ----
LEFT JOIN cust_main cm
       ON cm.WI_NAME = fa.WI_NAME AND cm.rn = 1
LEFT JOIN cust_add_id cid
       ON cid.WI_NAME = fa.WI_NAME
LEFT JOIN PDTD_DTM.DIM_T24_CUSTOMER t24c
       ON t24c.DIMENSION_KEY = cm.T24_CUSTOMER_SK
LEFT JOIN corepayer_agg corep
       ON corep.WI_NAME = fa.WI_NAME
LEFT JOIN collateral_agg coll
       ON coll.WI_NAME = fa.WI_NAME
LEFT JOIN secondproduct_agg spp
       ON spp.WI_NAME = fa.WI_NAME

WHERE fa.DAYID = v_batch_date
  AND (v_branch_code IS NULL OR dco.BRANCH_CODE = v_branch_code)
ORDER BY fa.WI_NAME;
