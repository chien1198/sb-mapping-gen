/* =====================================================================
   BC1 - Bao cao RLOS APPLICATION (PDTD_DTM, Oracle 19c)
   Nguon thiet ke: extract/srs_report/BC1.md + lld/BC1.csv + lld/pdtd_dtm/*
   Tham so:
     :p_report_date   DATE      Ngay bao cao (PROCESSED_DATE), mac dinh T-1 (TRUNC(SYSDATE) - 1)
     :p_branch_code   VARCHAR2  Ma chi nhanh, NULL = tat ca chi nhanh
   Grain: 1 dong / ho so (WI_NAME).
   FCT_RLOS_APPLICATION la full snapshot theo DAYID; PROCESSED_DATE la thuoc tinh co dinh
   cua ho so -> loc DAYID = PROCESSED_DATE = :p_report_date (cung mau BC9).
   ===================================================================== */
WITH
p AS (
    SELECT TRUNC(:p_report_date) AS rpt_date FROM DUAL
),
-- Tap ho so cua ngay bao cao (+ loc chi nhanh)
app AS (
    SELECT a.*
    FROM   PDTD_DTM.FCT_RLOS_APPLICATION a
    JOIN   p ON a.DAYID = p.rpt_date
            AND a.PROCESSED_DATE >= p.rpt_date
            AND a.PROCESSED_DATE <  p.rpt_date + 1
    LEFT JOIN PDTD_DTM.DIM_LOS_COMPANY c ON c.DIMENSION_KEY = a.COMPANY_SK
    WHERE  (:p_branch_code IS NULL OR c.BRANCH_CODE = :p_branch_code)
),
-- Applicant: 1 dong dai dien / ho so (uu tien giay to TCC/CC) - tranh fan-out
cust_rep AS (
    SELECT *
    FROM (
        SELECT cu.*,
               ROW_NUMBER() OVER (
                   PARTITION BY cu.WI_NAME
                   ORDER BY CASE WHEN cu.ID_TYPE IN ('TCC','CC') THEN 0 ELSE 1 END, cu.ID_TYPE
               ) AS RN
        FROM   PDTD_DTM.FCT_RLOS_CUSTOMER cu
        JOIN   app ON app.DAYID = cu.DAYID AND app.WI_NAME = cu.WI_NAME
    )
    WHERE RN = 1
),
-- Applicant: gop so giay to (ADD_ID / ADD_ID_OTHER)
cust_id AS (
    SELECT cu.WI_NAME,
           LISTAGG(DISTINCT CASE WHEN cu.ID_TYPE IN ('TCC','CC') THEN cu.ID_NUMBER END, ';')
               WITHIN GROUP (ORDER BY CASE WHEN cu.ID_TYPE IN ('TCC','CC') THEN cu.ID_NUMBER END) AS ADD_ID,
           LISTAGG(DISTINCT CASE WHEN cu.ID_TYPE NOT IN ('TCC','CC') THEN cu.ID_NUMBER END, ';')
               WITHIN GROUP (ORDER BY CASE WHEN cu.ID_TYPE NOT IN ('TCC','CC') THEN cu.ID_NUMBER END) AS ADD_ID_OTHER
    FROM   PDTD_DTM.FCT_RLOS_CUSTOMER cu
    JOIN   app ON app.DAYID = cu.DAYID AND app.WI_NAME = cu.WI_NAME
    GROUP  BY cu.WI_NAME
),
-- Nguoi dong tra no
corep AS (
    SELECT cp.WI_NAME,
           LISTAGG(DISTINCT cp.FULL_NAME, ';')
               WITHIN GROUP (ORDER BY cp.FULL_NAME) AS CO_REPAYER,
           LISTAGG(DISTINCT CASE WHEN cp.ID_TYPE IN ('TCC','CC') THEN cp.ID_NUMBER END, ';')
               WITHIN GROUP (ORDER BY CASE WHEN cp.ID_TYPE IN ('TCC','CC') THEN cp.ID_NUMBER END) AS ADD_ID_COREPAYER,
           LISTAGG(DISTINCT CASE WHEN cp.ID_TYPE NOT IN ('TCC','CC') THEN cp.ID_NUMBER END, ';')
               WITHIN GROUP (ORDER BY CASE WHEN cp.ID_TYPE NOT IN ('TCC','CC') THEN cp.ID_NUMBER END) AS ADD_ID_OTHER_COREPAYER
    FROM   PDTD_DTM.FCT_RLOS_COREPAYER cp
    JOIN   app ON app.DAYID = cp.DAYID AND app.WI_NAME = cp.WI_NAME
    GROUP  BY cp.WI_NAME
),
-- Tai san bao dam
col AS (
    SELECT cl.WI_NAME,
           MAX(CASE WHEN UPPER(cl.COLLATERAL_TYPE_CODE) = 'REALESTATE' THEN 1 ELSE 0 END) AS HAS_BDS,
           MAX(CASE WHEN UPPER(cl.COLLATERAL_TYPE_CODE) = 'TRANSPORT'  THEN 1 ELSE 0 END) AS HAS_PTVT,
           MAX(CASE WHEN UPPER(cl.COLLATERAL_TYPE_CODE) = 'VALPAPER'   THEN 1 ELSE 0 END) AS HAS_GTCG,
           LISTAGG(DISTINCT CASE WHEN UPPER(cl.COLLATERAL_TYPE_CODE) = 'REALESTATE' THEN cl.OWNER_NAME END, ';')
               WITHIN GROUP (ORDER BY CASE WHEN UPPER(cl.COLLATERAL_TYPE_CODE) = 'REALESTATE' THEN cl.OWNER_NAME END) AS OWNERSHIP,
           LISTAGG(DISTINCT CASE WHEN UPPER(cl.COLLATERAL_TYPE_CODE) = 'REALESTATE' THEN cl.CERTIFICATE_NO END, ';')
               WITHIN GROUP (ORDER BY CASE WHEN UPPER(cl.COLLATERAL_TYPE_CODE) = 'REALESTATE' THEN cl.CERTIFICATE_NO END) AS GCN_REAL_ESTATE,
           LISTAGG(DISTINCT CASE WHEN UPPER(cl.COLLATERAL_TYPE_CODE) <> 'REALESTATE' THEN cl.CERTIFICATE_NO END, ';')
               WITHIN GROUP (ORDER BY CASE WHEN UPPER(cl.COLLATERAL_TYPE_CODE) <> 'REALESTATE' THEN cl.CERTIFICATE_NO END) AS GCN_OTHER,
           LISTAGG(DISTINCT cl.REL_TO_CUSTOMER, ';')
               WITHIN GROUP (ORDER BY cl.REL_TO_CUSTOMER) AS TSBD_RELATIONSHIP
    FROM   PDTD_DTM.FCT_RLOS_COLLATERAL cl
    JOIN   app ON app.DAYID = cl.DAYID AND app.WI_NAME = cl.WI_NAME
    GROUP  BY cl.WI_NAME
),
-- San pham phu (SPP_AMOUNT / SPP_TERM gop cung thu tu SUB_PRODUCT_LINE de khop nhau)
spp AS (
    SELECT sp.WI_NAME,
           LISTAGG(sp.SUB_PRODUCT_LINE, ';')
               WITHIN GROUP (ORDER BY sp.SUB_PRODUCT_LINE, sp.SUB_PRODUCT_BK) AS SAN_PHAM_PHU,
           LISTAGG(TO_CHAR(sp.SPP_AMOUNT), ';')
               WITHIN GROUP (ORDER BY sp.SUB_PRODUCT_LINE, sp.SUB_PRODUCT_BK) AS SPP_AMOUNT,
           LISTAGG(TO_CHAR(sp.SPP_TERM), ';')
               WITHIN GROUP (ORDER BY sp.SUB_PRODUCT_LINE, sp.SUB_PRODUCT_BK) AS SPP_TERM
    FROM   PDTD_DTM.FCT_RLOS_APPLICATION_SECONDPRODUCT sp
    JOIN   app ON app.DAYID = sp.DAYID AND app.WI_NAME = sp.WI_NAME
    GROUP  BY sp.WI_NAME
)
SELECT
    -- Phan loai ho so
    a.BUSINESS_FLOW                                         AS BI_FLOW,
    d.STREAM,
    a.CHANGE_REQUEST,
    a.CHANGE_TYPE,
    ct.DETAIL_CHANGE_TYPE_NAME                              AS CHANGE_TYPE_DETAIL,
    CASE WHEN cr.CUS_SEGMENT LIKE '%xanh' OR cr.CUS_SEGMENT LIKE '%XANH' THEN 'XANH'
         WHEN cr.CUS_SEGMENT = 'CBNV' THEN 'CBNV'
         ELSE 'THUONG' END                                  AS BI_CUS_SEGMENT,
    -- Thong tin chung
    a.WI_NAME                                               AS WINAME,
    a.PROCESSED_DATE,
    a.CREATION_DATE,
    a.APPLICATION_STATUS                                    AS BI_APPSTATUS,
    -- Khach hang
    cr.FULL_NAME                                            AS CUSTOMER_NAME,
    ci.ADD_ID,
    ci.ADD_ID_OTHER,
    t24c.CUSTOMER                                           AS CUSTOMER_ID,
    cr.DATE_OF_BIRTH,
    cr.GENDER,
    cr.PERM_ADDRESS                                         AS PERMANENT_RESIDENCE_ADDRESS,
    cr.CITY_NAME                                            AS CURRENT_RESIDENTIAL_CITY,
    cr.DISTRICT_NAME                                        AS CURRENT_RESIDENTIAL_DISTRICT,
    cr.CURR_WARD                                            AS CURRENT_RESIDENTIAL_WARD,
    cr.CURR_HOUSE_NO || ', ' || cr.CURR_WARD || ', ' || cr.DISTRICT_NAME || ', ' || cr.CITY_NAME
                                                            AS CURRENT_RESIDENTIAL_ADDRESS,
    cr.MARRIAGE_STATUS,
    cr.EDUCATION_LEVEL,
    cr.VEHICLE                                              AS VEHICLES,
    col.OWNERSHIP,
    -- Nguoi dong tra no
    cp.CO_REPAYER,
    cp.ADD_ID_COREPAYER,
    cp.ADD_ID_OTHER_COREPAYER,
    -- CRO / don vi kinh doanh
    d.CREATE_EMPLOYEE_CODE                                  AS EMPLOYEE_CODE,
    d.CREATE_EMPLOYEE_NAME                                  AS EMPLOYEE_NAME,
    d.ZONE,
    c.BRANCH_CODE,
    c.BRANCH_NAME,
    c.COMPANY_CODE,
    c.COMPANY_NAME,
    d.APP_GRP,
    -- San pham
    a.PRODUCTLINE_CODE                                      AS PRODUCT_LINE,
    pr.SUB_PRODUCT_NAME                                     AS SUB_PRODUCT,
    d.IS_SEC_PRODUCT                                        AS SECONDARY_PRODUCTLINE,
    spp.SAN_PHAM_PHU,
    -- Workstep (da carry-forward san tai FCT)
    a.LAST_WORKSTEP,
    a.PRE_WORKSTEP_CODE                                     AS PRE_WORKSTEP,
    a.LAST_ENTRYDATE,
    a.LAST_EXITDATE,
    a.LAST_REMARKS,
    a.LAST_REMARK_DDE,
    a.DECISION_CODE                                         AS LAST_DECISION,
    a.UNDERWRITERMAKER_USERMAKE                             AS UNDERWRITERMAKER_TAKERESPON,
    a.UNDERWRITERCHECKER_USERMAKE                           AS UNDERWRITERCHECKER_TAKERESPON,
    a.APPROVAL_USERMAKE                                     AS APPROVAL_TAKERESPON,
    -- Tai san bao dam
    CASE WHEN col.HAS_BDS  = 1 THEN 'YES' ELSE 'NO' END     AS TSBD_BDS,
    CASE WHEN col.HAS_PTVT = 1 THEN 'YES' ELSE 'NO' END     AS TSBD_PTVT,
    CASE WHEN col.HAS_GTCG = 1 THEN 'YES' ELSE 'NO' END     AS TSBD_GTCG,
    col.GCN_REAL_ESTATE,
    col.GCN_OTHER,
    col.TSBD_RELATIONSHIP,
    -- Dac diem ho so
    d.DEVIATION_FLAG                                        AS DEVIATION,
    d.POLICY,
    d.CAMPAIGN,
    d.PROOF_OF_INCOME,                                      -- da map CASE tai PDTD_DTM.DIM_RLOS_APPLICATION
    SUBSTR(REGEXP_REPLACE(
          CASE WHEN d.SALARYFLAG     = 'Yes' THEN 'Lương / ' END
       || CASE WHEN d.CARFLAG        = 'Yes' THEN 'Cho thuê phương tiện / ' END
       || CASE WHEN d.HOUSEFLAG      = 'Yes' THEN 'Cho thuê nhà / ' END
       || CASE WHEN d.ENTERPRISSEFLAG = 'Yes' THEN 'Lợi nhuận doanh nghiệp / ' END
       || CASE WHEN d.DIVINGFLAG     = 'Yes' THEN 'Cổ tức / ' END
       || CASE WHEN d.FAIMILYFLAG    = 'Yes' THEN 'Kinh doanh hộ gia đình / ' END
       || CASE WHEN d.NONLICFLAG     = 'Yes' THEN 'Kinh doanh không ĐKKD / ' END
       || CASE WHEN d.WAGESFLAG      = 'Yes' THEN 'Tiền công / ' END
       || CASE WHEN d.PENSIONFLAG    = 'Yes' THEN 'Lương hưu/phụ cấp / ' END
       || CASE WHEN d.OTHERFLAG      = 'Yes' THEN 'Nguồn thu khác / ' END
       , ' / $', ''), 1, 200)                               AS REPAYMENT_SOURCE,
    d.TOTAL_INCOME,
    d.LOAN_TO_VALUE,
    -- The tin dung
    card.K_TYPE,
    promo.PROMOTION_DESC                                    AS PROMOTION_ID,
    mc.HOME_ADDRESS,
    -- Khoan vay phe duyet
    a.APPROVED_AMT_FINAL                                    AS LOAN_AMOUNT,
    a.APPROVED_TERM                                         AS LOAN_TERM,
    d.INTEREST_RATE_PCT                                     AS INTEREST_RATE,
    -- Moc thoi gian
    a.MIN_UWM,
    a.MIN_APP,
    a.LAST_APPROVAL_DATE,
    a.CANCEL_USER_DATE                                      AS CAN_USER_DATE,
    a.AUTO_CANCEL_DATE                                      AS AUTO_CAN_DATE,
    a.FLAG_AUTO_CANCEL                                      AS FLAG_AUTO_CAN,
    a.LAST_CAN_REMARKS,
    -- User theo buoc
    a.BRANCH_USER,
    a.DDE_USER,
    a.QC_USER                                               AS QUALITY_CHECKER,
    a.UND_MAKER_USER                                        AS UND_MAKER,
    a.UND_CHECKER_USER                                      AS UND_CHECKER,
    a.PHV_USER,
    a.APPROVER_USER                                         AS BI_APPROVER,
    d.LOAN_OBJECTIVE,
    spp.SPP_AMOUNT,
    spp.SPP_TERM
FROM       app a
LEFT JOIN  PDTD_DTM.DIM_RLOS_APPLICATION      d     ON d.DIMENSION_KEY     = a.APPLICATION_SK
LEFT JOIN  PDTD_DTM.DIM_LOS_COMPANY           c     ON c.DIMENSION_KEY     = a.COMPANY_SK
LEFT JOIN  PDTD_DTM.DIM_RLOS_PRODUCT          pr    ON pr.DIMENSION_KEY    = a.SUB_PRODUCT_SK
LEFT JOIN  PDTD_DTM.DIM_RLOS_CHANGE_TYPE      ct    ON ct.DIMENSION_KEY    = a.CHANGE_TYPE_SK
LEFT JOIN  PDTD_DTM.DIM_RLOS_CARD_PROMOTION   promo ON promo.DIMENSION_KEY = a.CARD_PROMOTION_SK
LEFT JOIN  PDTD_DTM.DIM_T24_CARD              card  ON card.DIMENSION_KEY  = a.T24_CARD_SK
LEFT JOIN  PDTD_DTM.DIM_T24_SEAB_MAIN_CARD    mc    ON mc.DIMENSION_KEY    = a.T24_SEAB_MAIN_CARD_SK
LEFT JOIN  cust_rep                           cr    ON cr.WI_NAME          = a.WI_NAME
LEFT JOIN  PDTD_DTM.DIM_T24_CUSTOMER          t24c  ON t24c.DIMENSION_KEY  = cr.T24_CUSTOMER_SK
LEFT JOIN  cust_id                            ci    ON ci.WI_NAME          = a.WI_NAME
LEFT JOIN  corep                              cp    ON cp.WI_NAME          = a.WI_NAME
LEFT JOIN  col                                      ON col.WI_NAME         = a.WI_NAME
LEFT JOIN  spp                                      ON spp.WI_NAME         = a.WI_NAME
ORDER BY   a.WI_NAME;
