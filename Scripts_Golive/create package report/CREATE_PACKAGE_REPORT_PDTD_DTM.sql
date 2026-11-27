CREATE OR REPLACE PACKAGE PDTD_DTM.PKG_REPORT AS
  -- BC1 - Bao cao RLOS APPLICATION
  FUNCTION BC1_RLOS_APPLICATION(p_date_from DATE, p_date_to DATE) RETURN CLOB SQL_MACRO(TABLE);

  -- BC2 - Bao cao CLOS APPLICATION
  FUNCTION BC2_CLOS_APPLICATION(p_date_from DATE, p_date_to DATE) RETURN CLOB SQL_MACRO(TABLE);

  -- BC3 - Bao cao Thong tin phe duyet (CLOS + RLOS)
  FUNCTION BC3_APPROVAL_INFO(p_date_from DATE, p_date_to DATE) RETURN CLOB SQL_MACRO(TABLE);

  -- BC4 - Bao cao Tuan Chuyen vien Tham dinh (CLOS + RLOS)
  FUNCTION BC4_UW_WEEKLY(p_date_from DATE, p_date_to DATE) RETURN CLOB SQL_MACRO(TABLE);

  -- BC5 - Bao cao SLA - TAT (CLOS + RLOS)
  FUNCTION BC5_SLA_TAT(p_date_from DATE, p_date_to DATE) RETURN CLOB SQL_MACRO(TABLE);

  -- BC6 - Bao cao NGOAI LE CLOS
  FUNCTION BC6_CLOS_DEVIATION(p_date_from DATE, p_date_to DATE) RETURN CLOB SQL_MACRO(TABLE);

  -- BC6 - Bao cao NGOAI LE RLOS
  FUNCTION BC6_RLOS_DEVIATION(p_date_from DATE, p_date_to DATE) RETURN CLOB SQL_MACRO(TABLE);

  -- BC7 - Bao cao EXCEPTION - FTR (CLOS + RLOS)
  FUNCTION BC7_EXCEPTION_FTR(p_date_from DATE, p_date_to DATE) RETURN CLOB SQL_MACRO(TABLE);

  -- BC8 - Bao cao RETURN (CLOS + RLOS)
  FUNCTION BC8_RETURN(p_date_from DATE, p_date_to DATE) RETURN CLOB SQL_MACRO(TABLE);

  -- BC9 - Bao cao KPI, phan nguon CLOS (1 dong / ho so)
  FUNCTION BC9_CLOS(p_date_from DATE, p_date_to DATE) RETURN CLOB SQL_MACRO(TABLE);

  -- BC9 - Bao cao KPI, phan KPI Khoi (1 dong)
  FUNCTION BC9_KPI_KHOI(p_date_from DATE, p_date_to DATE) RETURN CLOB SQL_MACRO(TABLE);

  -- BC9 - Bao cao KPI, phan nguon RLOS (1 dong / ho so)
  FUNCTION BC9_RLOS(p_date_from DATE, p_date_to DATE) RETURN CLOB SQL_MACRO(TABLE);

  -- BC10 - Bao cao Giai ngan / Qua han KHCN
  FUNCTION BC10_RLOS_DISBURSEMENT(p_date_from DATE, p_date_to DATE) RETURN CLOB SQL_MACRO(TABLE);

  -- BC11 - Bao cao Giai ngan / Qua han KHDN
  FUNCTION BC11_CLOS_DISBURSEMENT(p_date_from DATE, p_date_to DATE) RETURN CLOB SQL_MACRO(TABLE);
END PKG_REPORT;
/

CREATE OR REPLACE PACKAGE BODY PDTD_DTM.PKG_REPORT AS

  /* =====================================================================
     BC1 - Bao cao RLOS APPLICATION
     Tham so:
       p_date_from     DATE      Tu ngay (PROCESSED_DATE), mac dinh T-1 (TRUNC(SYSDATE) - 1)
       p_date_to       DATE      Den ngay (PROCESSED_DATE), mac dinh T-1; ngay du lieu (DAYID) = p_date_to
     Grain: 1 dong / (ho so x nguoi dong tra no x san pham phu x tai san bao dam).
       - Nguoi dong tra no (corep), san pham phu (FCT_RLOS_APPLICATION_SECONDPRODUCT) va tai san bao dam
         (FCT_RLOS_COLLATERAL) len nhieu dong, khong gop; ho so khong co nhom nao van ra 1 dong (LEFT JOIN).
       - Co TSBD_BDS / PTVT / GTCG tinh theo ho so (khong theo dong tai san).
       - Giay to applicant (ADD_ID / ADD_ID_OTHER) gop ';' 1 dong / ho so.
     FCT_RLOS_APPLICATION la full snapshot lich su theo DAYID -> loc DAYID = p_date_to (trang thai ho so
     tai ngay den) va PROCESSED_DATE trong [p_date_from, p_date_to] (cung mau BC9).
     ===================================================================== */
  FUNCTION BC1_RLOS_APPLICATION(p_date_from DATE, p_date_to DATE)
    RETURN CLOB SQL_MACRO(TABLE) IS
  BEGIN
    RETURN TO_CLOB(q'[
WITH
p AS (
    SELECT TRUNC(p_date_from) AS d_from,
           TRUNC(p_date_to)   AS d_to
    FROM   DUAL
),
-- Tap ho so co PROCESSED_DATE trong khoang bao cao
app AS (
    SELECT a.*
    FROM   PDTD_DTM.FCT_RLOS_APPLICATION a
    JOIN   p ON a.DAYID = p.d_to
            AND a.PROCESSED_DATE >= p.d_from
            AND a.PROCESSED_DATE <  p.d_to + 1
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
-- Nguoi dong tra no: 1 dong / nguoi (ID_NO_CO = Corep1-4); chi gop giay to cua cung 1 nguoi
corep AS (
    SELECT cp.WI_NAME,
           cp.ID_NO_CO,
           MAX(cp.FULL_NAME) AS CO_REPAYER,
           LISTAGG(DISTINCT CASE WHEN cp.ID_TYPE IN ('TCC','CC') THEN cp.ID_NUMBER END, ';')
               WITHIN GROUP (ORDER BY CASE WHEN cp.ID_TYPE IN ('TCC','CC') THEN cp.ID_NUMBER END) AS ADD_ID_COREPAYER,
           LISTAGG(DISTINCT CASE WHEN cp.ID_TYPE NOT IN ('TCC','CC') THEN cp.ID_NUMBER END, ';')
               WITHIN GROUP (ORDER BY CASE WHEN cp.ID_TYPE NOT IN ('TCC','CC') THEN cp.ID_NUMBER END) AS ADD_ID_OTHER_COREPAYER
    FROM   PDTD_DTM.FCT_RLOS_COREPAYER cp
    JOIN   app ON app.DAYID = cp.DAYID AND app.WI_NAME = cp.WI_NAME
    GROUP  BY cp.WI_NAME, cp.ID_NO_CO
),
-- Tai san bao dam: chi gop CO theo ho so (TSBD_BDS / PTVT / GTCG); thong tin tung tai san len nhieu dong (join cl)
col AS (
    SELECT cl.WI_NAME,
           MAX(CASE WHEN UPPER(cl.COLLATERAL_TYPE_CODE) = 'REALESTATE' THEN 1 ELSE 0 END) AS HAS_BDS,
           MAX(CASE WHEN UPPER(cl.COLLATERAL_TYPE_CODE) = 'TRANSPORT'  THEN 1 ELSE 0 END) AS HAS_PTVT,
           MAX(CASE WHEN UPPER(cl.COLLATERAL_TYPE_CODE) = 'VALPAPER'   THEN 1 ELSE 0 END) AS HAS_GTCG
    FROM   PDTD_DTM.FCT_RLOS_COLLATERAL cl
    JOIN   app ON app.DAYID = cl.DAYID AND app.WI_NAME = cl.WI_NAME
    GROUP  BY cl.WI_NAME
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
    CASE WHEN UPPER(cl.COLLATERAL_TYPE_CODE) = 'REALESTATE' THEN cl.OWNER_NAME END AS OWNERSHIP,
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
    sp.SUB_PRODUCT_LINE                                     AS SAN_PHAM_PHU,
    -- Workstep (da carry-forward san tai FCT)
    a.LAST_WORKSTEP,
    a.PRE_WORKSTEP_CODE                                     AS PRE_WORKSTEP,
    a.LAST_ENTRYDATE,
    a.LAST_EXITDATE,
    a.LAST_REMARKS,
    a.LAST_REMARK_DDE,
    a.LAST_DECISION                                         AS LAST_DECISION,
    a.UNDERWRITERMAKER_USERMAKE                             AS UNDERWRITERMAKER_TAKERESPON,
    a.UNDERWRITERCHECKER_USERMAKE                           AS UNDERWRITERCHECKER_TAKERESPON,
    a.APPROVAL_USERMAKE                                     AS APPROVAL_TAKERESPON,
    -- Tai san bao dam
    CASE WHEN col.HAS_BDS  = 1 THEN 'YES' ELSE 'NO' END     AS TSBD_BDS,
    CASE WHEN col.HAS_PTVT = 1 THEN 'YES' ELSE 'NO' END     AS TSBD_PTVT,
    CASE WHEN col.HAS_GTCG = 1 THEN 'YES' ELSE 'NO' END     AS TSBD_GTCG,
    CASE WHEN UPPER(cl.COLLATERAL_TYPE_CODE) =  'REALESTATE' THEN cl.CERTIFICATE_NO END AS GCN_REAL_ESTATE,
    CASE WHEN UPPER(cl.COLLATERAL_TYPE_CODE) <> 'REALESTATE' THEN cl.CERTIFICATE_NO END AS GCN_OTHER,
    cl.REL_TO_CUSTOMER                                      AS TSBD_RELATIONSHIP,
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
    sp.SPP_AMOUNT,
    sp.SPP_TERM
FROM      app a
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
LEFT JOIN  PDTD_DTM.FCT_RLOS_COLLATERAL      cl    ON cl.WI_NAME          = a.WI_NAME
                                                   AND cl.DAYID           = a.DAYID
LEFT JOIN  PDTD_DTM.FCT_RLOS_APPLICATION_SECONDPRODUCT sp ON sp.WI_NAME    = a.WI_NAME
                                                         AND sp.DAYID      = a.DAYID
ORDER BY   a.WI_NAME, cp.ID_NO_CO, sp.SUB_PRODUCT_BK, cl.COLLATERAL_BK
]');
  END BC1_RLOS_APPLICATION;

  /* =====================================================================
     BC2 - Bao cao CLOS APPLICATION
     Tham so:
       p_date_from     DATE      Tu ngay (PROCESSED_DATE), mac dinh T-1 (TRUNC(SYSDATE) - 1)
       p_date_to       DATE      Den ngay (PROCESSED_DATE), mac dinh T-1; ngay du lieu (DAYID) = p_date_to
     Grain: 1 dong / (ho so x ngoai le). Ho so khong co ngoai le van ra 1 dong (LEFT JOIN).
       - DEV_PROPOSAL (FCT_CLOS_DEVIATION) len nhieu dong, khong gop.
       - 9 co TSDB_* gop theo ho so (MAX), 1 dong / ho so.
     FCT_CLOS_APPLICATION la full snapshot lich su theo DAYID -> loc DAYID = p_date_to (trang thai ho so
     tai ngay den) va PROCESSED_DATE trong [p_date_from, p_date_to] (cung mau BC1).
     ===================================================================== */
  FUNCTION BC2_CLOS_APPLICATION(p_date_from DATE, p_date_to DATE)
    RETURN CLOB SQL_MACRO(TABLE) IS
  BEGIN
    RETURN TO_CLOB(q'[
WITH
p AS (
    SELECT TRUNC(p_date_from) AS d_from,
           TRUNC(p_date_to)   AS d_to
    FROM   DUAL
),
-- Tap ho so co PROCESSED_DATE trong khoang bao cao
app AS (
    SELECT a.*
    FROM   PDTD_DTM.FCT_CLOS_APPLICATION a
    JOIN   p ON a.DAYID = p.d_to
            AND a.PROCESSED_DATE >= p.d_from
            AND a.PROCESSED_DATE <  p.d_to + 1
),
-- Tai san bao dam: gop co theo ho so (COLLATERAL_TYPE_CODE = COLLTYPE goc, tieng Viet khong dau)
coll AS (
    SELECT cl.WI_NAME,
           MAX(CASE WHEN cl.COLLATERAL_TYPE_CODE IS NOT NULL THEN 1 ELSE 0 END)                                   AS HAS_NHOM_0,
           MAX(CASE WHEN cl.COLLATERAL_TYPE_CODE = 'PHUONGTIEN VTAI'             THEN 1 ELSE 0 END)              AS HAS_PTVT,
           MAX(CASE WHEN cl.COLLATERAL_TYPE_CODE = 'BAT DONG SAN'                THEN 1 ELSE 0 END)              AS HAS_BDS,
           MAX(CASE WHEN cl.COLLATERAL_TYPE_CODE = 'TAI SAN KHAC - MMTB,DCSX'    THEN 1 ELSE 0 END)              AS HAS_MMTB,
           MAX(CASE WHEN cl.COLLATERAL_TYPE_CODE = 'TAI SAN KHAC - QUYEN DOI NO' THEN 1 ELSE 0 END)              AS HAS_KPT,
           MAX(CASE WHEN cl.COLLATERAL_TYPE_CODE IN ('HH LA LINHKIEN','HH LA NLSX','HH TM THANHPHAM') THEN 1 ELSE 0 END) AS HAS_HTK,
           MAX(CASE WHEN cl.COLLATERAL_TYPE_CODE = 'KHÔNG CÓ TÀI SẢN'            THEN 1 ELSE 0 END)              AS HAS_TIN_CHAP,
           MAX(CASE WHEN cl.COLLATERAL_TYPE_CODE = 'TIN CHAP THEO QUY DINH'      THEN 1 ELSE 0 END)              AS HAS_TIN_CHAP_TQD,
           MAX(CASE WHEN cl.COLLATERAL_TYPE_CODE = 'TR.PHIEU TIN PH'             THEN 1 ELSE 0 END)              AS HAS_CP_TP
    FROM   PDTD_DTM.FCT_CLOS_COLLATERAL cl
    JOIN   app ON app.DAYID = cl.DAYID AND app.WI_NAME = cl.WI_NAME
    GROUP  BY cl.WI_NAME
)
SELECT
    -- Phan loai ho so
    a.BUSINESS_FLOW                                         AS BI_FLOW,
    a.CHANGE_REQUEST,
    a.CHANGE_TYPE,
    a.APPROVAL_TYPE,
    -- Thong tin chung
    a.WI_NAME                                               AS WINAME,
    a.PROCESSED_DATE,
    da.CREATION_DATE,
    a.APPLICATION_STATUS                                    AS BI_APPSTATUS,
    -- Khach hang
    dc.INDUSTRY_LVL1_CODE                                   AS INDUSTRY_GROUP,
    dc.INDUSTRY_LVL2_CODE                                   AS INDUSTRY_CLASS,
    dc.INDUSTRY_LVL3_CODE                                   AS INDUSTRY,
    da.CREDIT_PROFILE                                       AS CAP_TIN_DUNG,
    dc.CUSTOMER_NAME,
    dc.CUSTOMER_CODE                                        AS ID_NUMBER,
    t24.CUSTOMER                                            AS CUSTOMER_ID,
    dc.CUST_GROUP,
    a.LEGAL_REPRESENTATIVE,
    a.ADD_ID_REPRESENTATIVE,
    -- CRO / don vi kinh doanh
    da.CREATE_EMPLOYEE_CODE                                 AS EMPLOYEE_CODE,
    da.CREATE_EMPLOYEE_NAME                                 AS EMPLOYEE_NAME,
    da.ZONE,
    co.BRANCH_CODE,
    co.BRANCH_NAME,
    co.COMPANY_CODE,
    co.COMPANY_NAME,
    da.APP_GRP,
    -- San pham
    da.PRODUCT_LINE,
    da.SUB_PRODUCT,
    -- Workstep (da carry-forward san tai FCT)
    a.LAST_WORKSTEP,
    a.PRE_WORKSTEP_CODE                                     AS PRE_WORKSTEP,
    a.LAST_ENTRYDATE,
    a.LAST_EXITDATE,
    a.LAST_REMARKS,
    a.LAST_DECISION                                         AS LAST_DECISION,
    a.UNDERWRITERMAKER_USERMAKE                             AS UNDERWRITERMAKER_TAKERESPON,
    a.UNDERWRITERCHECKER_USERMAKE                           AS UNDERWRITERCHECKER_TAKERESPON,
    a.APPROVAL_USERMAKE                                     AS APPROVAL_TAKERESPON,
    -- Khoan vay
    a.PROPOSED_AMT                                          AS ST_YEUCAU,
    a.CREDIT_LIMIT_APPROVAL                                 AS ST_PHEDUYET,
    a.CURRENCY_CODE                                         AS CURRENCY,
    a.APPROVED_TERM                                         AS CREDIT_TERM,
    a.INTEREST_RATE_PCT                                     AS INTEREST_RATE,
    -- Tai san bao dam (co theo ho so)
    CASE WHEN coll.HAS_NHOM_0       = 1 THEN 'YES' ELSE 'NO' END AS TSDB_NHOM_0,
    CASE WHEN coll.HAS_PTVT         = 1 THEN 'YES' ELSE 'NO' END AS TSDB_PTVT,
    CASE WHEN coll.HAS_BDS          = 1 THEN 'YES' ELSE 'NO' END AS TSDB_BDS,
    CASE WHEN coll.HAS_MMTB         = 1 THEN 'YES' ELSE 'NO' END AS TSDB_MMTB,
    CASE WHEN coll.HAS_KPT          = 1 THEN 'YES' ELSE 'NO' END AS TSDB_KPT,
    CASE WHEN coll.HAS_HTK          = 1 THEN 'YES' ELSE 'NO' END AS TSDB_HTK,
    CASE WHEN coll.HAS_TIN_CHAP     = 1 THEN 'YES' ELSE 'NO' END AS TSDB_TIN_CHAP,
    CASE WHEN coll.HAS_TIN_CHAP_TQD = 1 THEN 'YES' ELSE 'NO' END AS TIN_CHAP_TQD,
    CASE WHEN coll.HAS_CP_TP        = 1 THEN 'YES' ELSE 'NO' END AS TSDB_CP_TP,
    -- Ngoai le (nhieu dong / ho so)
    dev.DEV_PROPOSAL,
    -- Moc thoi gian
    a.MIN_UWM,
    a.MIN_APP,
    a.FLAG_AUTO_CANCEL                                      AS FLAG_AUTO_CAN,
    a.LAST_APPROVAL_DATE,
    a.CANCEL_DATE                                           AS BI_CAN_DATE,
    -- User theo buoc
    a.RI_USER,
    a.BRANCH_USER,
    a.DDE_USER,
    a.QC_USER                                               AS QUALITY_CHECKER,
    a.PHV_USER,
    a.FA_USER,
    a.UND_MAKER_USER                                        AS UND_MAKER,
    a.UND_CHECKER_USER                                      AS UND_CHECKER,
    a.APPROVER_USER                                         AS BI_APPROVER,
    a.COMMITTEE_USER                                        AS BI_COMMITTEE,
    a.HOS_USER                                              AS BI_HOS_USER
FROM       app a
LEFT JOIN  PDTD_DTM.DIM_CLOS_APPLICATION      da    ON da.DIMENSION_KEY    = a.APPLICATION_SK
LEFT JOIN  PDTD_DTM.DIM_CLOS_CUSTOMER         dc    ON dc.DIMENSION_KEY    = a.CUSTOMER_SK
LEFT JOIN  PDTD_DTM.DIM_LOS_COMPANY           co    ON co.DIMENSION_KEY    = a.COMPANY_SK
LEFT JOIN  PDTD_DTM.DIM_T24_CUSTOMER          t24   ON t24.DIMENSION_KEY   = a.T24_CUSTOMER_SK
LEFT JOIN  coll                                     ON coll.WI_NAME        = a.WI_NAME
LEFT JOIN  PDTD_DTM.FCT_CLOS_DEVIATION        dev   ON dev.WI_NAME         = a.WI_NAME
                                                   AND dev.DAYID           = a.DAYID
ORDER BY   a.WI_NAME, dev.DEVIATION_BK
]');
  END BC2_CLOS_APPLICATION;

  /* =====================================================================
     BC3 - Bao cao Thong tin phe duyet (CLOS + RLOS)
     Tham so:
       p_date_from     DATE      Tu ngay (EXITDATE cua buoc phe duyet), mac dinh T-1
       p_date_to       DATE      Den ngay (EXITDATE cua buoc phe duyet), mac dinh T-1; ngay du lieu cua cac bang snapshot (DAYID) = p_date_to
     Grain: 1 dong / (su kien phe duyet x tai san bao dam). Ho so khong co tai san van ra 1 dong.
     Su kien phe duyet: WORKSTEP IN (CreditApproval, CreditCommittee) va DECISION thuoc nhom ket thuc
     phe duyet (so sanh khong phan biet hoa thuong), EXITDATE nam trong [p_date_from, p_date_to].
     FCT_*_WORKSTEP_EVENT (lat cat ngay phat sinh): loc DAYID trong [p_date_from, p_date_to]; ghi nhieu
     phien ban / su kien (moi DAYID 1 dong) -> chi lay phien ban moi nhat cua tung WORKSTEP_EVENT_BK den p_date_to.
     Cac bang snapshot (FCT_*_APPLICATION, FCT_*_COLLATERAL, FCT_RLOS_CUSTOMER): loc DAYID = p_date_to.
     Hai nhanh CLOS / RLOS ghep bang UNION ALL; cot khac kieu ep ve NVARCHAR2.
     ===================================================================== */
  FUNCTION BC3_APPROVAL_INFO(p_date_from DATE, p_date_to DATE)
    RETURN CLOB SQL_MACRO(TABLE) IS
  BEGIN
    RETURN TO_CLOB(q'[
WITH
p AS (
    SELECT TRUNC(p_date_from) AS d_from,
           TRUNC(p_date_to)   AS d_to
    FROM   DUAL
),
-- CLOS: su kien phe duyet ket thuc trong khoang bao cao (+ so tien/ky han tu snapshot ho so tai p_date_to)
clos_ev AS (
    SELECT e.*,
           a.APPROVED_AMT_FINAL,
           a.CURRENCY_CODE,
           a.APPROVED_TERM
    FROM   PDTD_DTM.FCT_CLOS_WORKSTEP_EVENT e
    JOIN   p ON e.DAYID BETWEEN p.d_from AND p.d_to
            AND e.EXITDATE >= p.d_from
            AND e.EXITDATE <  p.d_to + 1
    LEFT JOIN PDTD_DTM.FCT_CLOS_APPLICATION a ON a.WI_NAME = e.WI_NAME AND a.DAYID = p.d_to
    WHERE  e.WORKSTEP_CODE IN ('CreditApproval','CreditCommittee')
      AND  UPPER(e.DECISION_CODE) IN ('SUBMIT','REJECT','SEND TO HOSUPPORT','SEND TO POSTSANCTION')
      AND  NOT EXISTS (SELECT 1
                       FROM   PDTD_DTM.FCT_CLOS_WORKSTEP_EVENT nv
                       WHERE  nv.WORKSTEP_EVENT_BK = e.WORKSTEP_EVENT_BK
                         AND  nv.DAYID > e.DAYID
                         AND  nv.DAYID <= p.d_to)
),
-- RLOS: tuong tu
rlos_ev AS (
    SELECT e.*,
           a.APPROVED_AMT_FINAL,
           a.CURRENCY_CODE,
           a.APPROVED_TERM
    FROM   PDTD_DTM.FCT_RLOS_WORKSTEP_EVENT e
    JOIN   p ON e.DAYID BETWEEN p.d_from AND p.d_to
            AND e.EXITDATE >= p.d_from
            AND e.EXITDATE <  p.d_to + 1
    LEFT JOIN PDTD_DTM.FCT_RLOS_APPLICATION a ON a.WI_NAME = e.WI_NAME AND a.DAYID = p.d_to
    WHERE  e.WORKSTEP_CODE IN ('CreditApproval','CreditCommittee')
      AND  UPPER(e.DECISION_CODE) IN ('SUBMIT','REJECT','SEND TO HOSUPPORT','SEND TO POSTSANCTION')
      AND  NOT EXISTS (SELECT 1
                       FROM   PDTD_DTM.FCT_RLOS_WORKSTEP_EVENT nv
                       WHERE  nv.WORKSTEP_EVENT_BK = e.WORKSTEP_EVENT_BK
                         AND  nv.DAYID > e.DAYID
                         AND  nv.DAYID <= p.d_to)
),
-- RLOS: ten khach hang theo SRS (APPLICANT_GENERAL.FULL_NAME) -> FCT_RLOS_CUSTOMER, 1 dong dai dien / ho so (uu tien giay to TCC/CC)
rlos_cust AS (
    SELECT WI_NAME, FULL_NAME
    FROM (
        SELECT cu.WI_NAME, cu.FULL_NAME,
               ROW_NUMBER() OVER (
                   PARTITION BY cu.WI_NAME
                   ORDER BY CASE WHEN cu.ID_TYPE IN ('TCC','CC') THEN 0 ELSE 1 END, cu.ID_TYPE
               ) AS RN
        FROM   PDTD_DTM.FCT_RLOS_CUSTOMER cu
        JOIN   p ON cu.DAYID = p.d_to
        JOIN   rlos_ev ev ON ev.WI_NAME = cu.WI_NAME
    )
    WHERE RN = 1
)
-- ===== Nhanh CLOS =====
SELECT
    'CLOS'                                                  AS SYSTEMNAME,
    da.STREAM,
    ev.WI_NAME                                              AS WINAME,
    dc.CUSTOMER_NAME,
    ev.WORKSTEP_CODE                                        AS WORKSTEP,
    ev.DECISION_CODE                                        AS DECISION,
    CASE WHEN ev.WORKSTEP_CODE = 'CreditApproval'  THEN ev.USERNAME END AS BI_APPROVER,
    CASE WHEN ev.WORKSTEP_CODE = 'CreditCommittee' THEN ev.USERNAME END AS BI_COMMITTEE,
    ev.ENTRYDATE,
    ev.EXITDATE,
    ev.REMARKS,
    ev.APPROVED_AMT_FINAL                                   AS CREDIT_LIMIT,
    ev.CURRENCY_CODE                                        AS CURRENCY,
    ev.APPROVED_TERM                                        AS CREDIT_TERM,
    cl.COLLATERAL_TYPE_CODE                                 AS TYPES_OF_COLLATERALS,
    cl.APPRAISED_VALUE,
    cl.DESCRIPTION,
    cl.OWNER_NAME                                           AS OWNER,
    cl.LOAN_RATE_LTV                                        AS LTV,
    cl.COLL_MGMT_METHOD                                     AS COLLATERA_MANAGEMENT
FROM       clos_ev ev
CROSS JOIN p
LEFT JOIN  PDTD_DTM.DIM_CLOS_APPLICATION  da ON da.DIMENSION_KEY = ev.APPLICATION_SK
LEFT JOIN  PDTD_DTM.DIM_CLOS_CUSTOMER     dc ON dc.DIMENSION_KEY = ev.CUSTOMER_SK
LEFT JOIN  PDTD_DTM.FCT_CLOS_COLLATERAL   cl ON cl.WI_NAME = ev.WI_NAME AND cl.DAYID = p.d_to
UNION ALL
-- ===== Nhanh RLOS =====
SELECT
    'RLOS'                                                  AS SYSTEMNAME,
    da.STREAM,
    ev.WI_NAME                                              AS WINAME,
    cu.FULL_NAME                                            AS CUSTOMER_NAME,
    ev.WORKSTEP_CODE                                        AS WORKSTEP,
    ev.DECISION_CODE                                        AS DECISION,
    CASE WHEN ev.WORKSTEP_CODE = 'CreditApproval'  THEN ev.USERNAME END AS BI_APPROVER,
    CASE WHEN ev.WORKSTEP_CODE = 'CreditCommittee' THEN ev.USERNAME END AS BI_COMMITTEE,
    ev.ENTRYDATE,
    ev.EXITDATE,
    ev.REMARKS,
    ev.APPROVED_AMT_FINAL                                   AS CREDIT_LIMIT,
    TO_NCHAR(ev.CURRENCY_CODE)                              AS CURRENCY,
    TO_NCHAR(ev.APPROVED_TERM)                              AS CREDIT_TERM,
    cl.TYPES_OF_COLLATERALS,
    TO_NCHAR(cl.APPRAISED_VALUE)                            AS APPRAISED_VALUE,
    cl.DESCRIPTION,
    cl.OWNER_NAME                                           AS OWNER,
    TO_NCHAR(cl.LOAN_RATE_LTV)                              AS LTV,
    CAST(NULL AS VARCHAR2(4000))                            AS COLLATERA_MANAGEMENT
FROM       rlos_ev ev
CROSS JOIN p
LEFT JOIN  PDTD_DTM.DIM_RLOS_APPLICATION  da ON da.DIMENSION_KEY = ev.APPLICATION_SK
LEFT JOIN  rlos_cust                      cu ON cu.WI_NAME = ev.WI_NAME
LEFT JOIN  PDTD_DTM.FCT_RLOS_COLLATERAL   cl ON cl.WI_NAME = ev.WI_NAME AND cl.DAYID = p.d_to
ORDER BY   SYSTEMNAME, WINAME, ENTRYDATE, DESCRIPTION
]');
  END BC3_APPROVAL_INFO;

  /* =====================================================================
     BC4 - Bao cao Tuan Chuyen vien Tham dinh (CLOS + RLOS)
     Tham so:
       p_date_from     DATE      Tu ngay (REPORT_DATE = PROCESSED_DATE), mac dinh T-1
       p_date_to       DATE      Den ngay (REPORT_DATE = PROCESSED_DATE), mac dinh T-1; ngay du lieu cua bang snapshot (DAYID) = p_date_to
     Grain: 1 dong / ho so (moi nhanh CLOS, RLOS), ke ca ho so co PROCESSED_DATE o nhieu ngay trong khoang.
       - Pham vi: ho so da co buoc tham dinh (FCT_*_APPLICATION.HAS_UWM_FLAG = 'Y' tai DAYID = p_date_to), co dong
         su kien DAYID trong [p_date_from, p_date_to] va PROCESSED_DATE trong [p_date_from, p_date_to].
       - REPORT_DATE = ngay PROCESSED_DATE moi nhat cua ho so trong khoang; MAX(PROCESSED_DATE) gop cac phien ban
         su kien trong khoang ve 1 dong / ho so nen o buoc xac dinh pham vi khong loc phien ban moi nhat.
       - WORKSTEP / UND_MAKER / REMARKS: dong su kien UnderwriterMaker moi nhat.
       - ENTRYDATE / EXITDATE: MIN / MAX tai UnderwriterMaker + UnderwriterChecker.
       - FLAG cap ho so (thu tu uu tien 5 nhanh cua SRS): nhanh theo quyet dinh (da phe duyet / CVTD chot / chuyen-tra lai)
         lay tu moi dong su kien; nhanh theo trang thai workflow (chua PD / dang-phai xu ly) chi lay tu dong moi nhat
         cua ho so, vi dong cu giu WF_ACTIVITYNAME luc ghi.
     REPORT_WEEK tinh truc tiep tu REPORT_DATE (khong dung DIM_DATE): Thu 2 - Chu nhat, dinh dang YYYYMMDD-YYYYMMDD.
     FCT_*_WORKSTEP_EVENT (lat cat ngay phat sinh): CTE *_scope loc DAYID trong [p_date_from, p_date_to];
     CTE *_hist doc toan bo lich su cua ho so nen CHI chan tren DAYID <= p_date_to (khong chan duoi, vi cac buoc
     cua ho so co the phat sinh truoc p_date_from) va chi lay phien ban moi nhat cua tung WORKSTEP_EVENT_BK.
     Bang snapshot (FCT_*_APPLICATION, FCT_RLOS_CUSTOMER): loc DAYID = p_date_to.
     ===================================================================== */
  FUNCTION BC4_UW_WEEKLY(p_date_from DATE, p_date_to DATE)
    RETURN CLOB SQL_MACRO(TABLE) IS
  BEGIN
    RETURN TO_CLOB(q'[
WITH
p AS (
    SELECT TRUNC(p_date_from) AS d_from,
           TRUNC(p_date_to)   AS d_to
    FROM   DUAL
),
-- ===== CLOS =====
-- Ho so trong pham vi khoang bao cao
clos_scope AS (
    SELECT e.WI_NAME,
           a.CUSTOMER_SK,
           TRUNC(MAX(e.PROCESSED_DATE)) AS REPORT_DATE
    FROM   PDTD_DTM.FCT_CLOS_WORKSTEP_EVENT e
    JOIN   p ON e.DAYID BETWEEN p.d_from AND p.d_to
            AND e.PROCESSED_DATE >= p.d_from
            AND e.PROCESSED_DATE <  p.d_to + 1
    JOIN   PDTD_DTM.FCT_CLOS_APPLICATION a ON a.WI_NAME = e.WI_NAME AND a.DAYID = p.d_to AND a.HAS_UWM_FLAG = 'Y'
    GROUP  BY e.WI_NAME, a.CUSTOMER_SK
),
-- Lich su su kien cua ho so (phien ban moi nhat cua tung su kien, den p_date_to)
clos_hist AS (
    SELECT e.*
    FROM   PDTD_DTM.FCT_CLOS_WORKSTEP_EVENT e
    JOIN   clos_scope s ON s.WI_NAME = e.WI_NAME
    JOIN   p ON e.DAYID <= p.d_to
    WHERE  NOT EXISTS (SELECT 1
                       FROM   PDTD_DTM.FCT_CLOS_WORKSTEP_EVENT nv
                       WHERE  nv.WORKSTEP_EVENT_BK = e.WORKSTEP_EVENT_BK
                         AND  nv.DAYID > e.DAYID
                         AND  nv.DAYID <= p.d_to)
),
-- Dong su kien UnderwriterMaker moi nhat / ho so
clos_uw AS (
    SELECT h.WI_NAME,
           MAX(h.WORKSTEP_CODE) KEEP (DENSE_RANK FIRST ORDER BY h.ENTRYDATE DESC, h.EXITDATE DESC NULLS FIRST) AS WORKSTEP,
           MAX(h.USERNAME)      KEEP (DENSE_RANK FIRST ORDER BY h.ENTRYDATE DESC, h.EXITDATE DESC NULLS FIRST) AS UND_MAKER,
           MAX(h.REMARKS)       KEEP (DENSE_RANK FIRST ORDER BY h.ENTRYDATE DESC, h.EXITDATE DESC NULLS FIRST) AS REMARKS
    FROM   clos_hist h
    WHERE  h.WORKSTEP_CODE = 'UnderwriterMaker'
    GROUP  BY h.WI_NAME
),
-- Moc thoi gian tham dinh + hang (rank) trang thai cap ho so
clos_agg AS (
    SELECT h.WI_NAME,
           MIN(CASE WHEN h.WORKSTEP_CODE IN ('UnderwriterMaker','UnderwriterChecker') THEN h.ENTRYDATE END) AS ENTRYDATE,
           MAX(CASE WHEN h.WORKSTEP_CODE IN ('UnderwriterMaker','UnderwriterChecker') THEN h.EXITDATE  END) AS EXITDATE,
           -- Co trang thai cap ho so: nhanh theo QUYET DINH (1,3,5) lay tu moi dong; nhanh theo TRANG THAI workflow (2,4)
           -- chi lay tu dong moi nhat (DAYID, ENTRYDATE lon nhat) vi dong cu giu WF_ACTIVITYNAME luc ghi
           LEAST(
               NVL(MIN(CASE h.WORKSTEP_FLAG
                            WHEN 'Hồ sơ đã chuyển sang bước cấp PD và đã được phê duyệt' THEN 1
                            WHEN 'Hồ sơ CVTĐ đã xử lý và chốt trạng thái tại bước của CVTĐ' THEN 3
                            WHEN 'Hồ sơ CVTĐ đã xử lý nhưng chuyển/trả lại các bộ phận để bổ sung/làm rõ' THEN 5 END), 9),
               NVL(MAX(CASE h.WORKSTEP_FLAG
                            WHEN 'Hồ sơ đã chuyển sang bước của cấp phê duyệt nhưng chưa PD' THEN 2
                            WHEN 'Hồ sơ CVTĐ đang/phải xử lý' THEN 4 END)
                       KEEP (DENSE_RANK LAST ORDER BY h.DAYID, h.ENTRYDATE), 9)
           ) AS FLAG_RANK
    FROM   clos_hist h
    GROUP  BY h.WI_NAME
),
-- ===== RLOS =====
rlos_scope AS (
    SELECT e.WI_NAME,
           TRUNC(MAX(e.PROCESSED_DATE)) AS REPORT_DATE
    FROM   PDTD_DTM.FCT_RLOS_WORKSTEP_EVENT e
    JOIN   p ON e.DAYID BETWEEN p.d_from AND p.d_to
            AND e.PROCESSED_DATE >= p.d_from
            AND e.PROCESSED_DATE <  p.d_to + 1
    JOIN   PDTD_DTM.FCT_RLOS_APPLICATION a ON a.WI_NAME = e.WI_NAME AND a.DAYID = p.d_to AND a.HAS_UWM_FLAG = 'Y'
    GROUP  BY e.WI_NAME
),
rlos_hist AS (
    SELECT e.*
    FROM   PDTD_DTM.FCT_RLOS_WORKSTEP_EVENT e
    JOIN   rlos_scope s ON s.WI_NAME = e.WI_NAME
    JOIN   p ON e.DAYID <= p.d_to
    WHERE  NOT EXISTS (SELECT 1
                       FROM   PDTD_DTM.FCT_RLOS_WORKSTEP_EVENT nv
                       WHERE  nv.WORKSTEP_EVENT_BK = e.WORKSTEP_EVENT_BK
                         AND  nv.DAYID > e.DAYID
                         AND  nv.DAYID <= p.d_to)
),
rlos_uw AS (
    SELECT h.WI_NAME,
           MAX(h.WORKSTEP_CODE) KEEP (DENSE_RANK FIRST ORDER BY h.ENTRYDATE DESC, h.EXITDATE DESC NULLS FIRST) AS WORKSTEP,
           MAX(h.USERNAME)      KEEP (DENSE_RANK FIRST ORDER BY h.ENTRYDATE DESC, h.EXITDATE DESC NULLS FIRST) AS UND_MAKER,
           MAX(h.REMARKS)       KEEP (DENSE_RANK FIRST ORDER BY h.ENTRYDATE DESC, h.EXITDATE DESC NULLS FIRST) AS REMARKS
    FROM   rlos_hist h
    WHERE  h.WORKSTEP_CODE = 'UnderwriterMaker'
    GROUP  BY h.WI_NAME
),
rlos_agg AS (
    SELECT h.WI_NAME,
           MIN(CASE WHEN h.WORKSTEP_CODE IN ('UnderwriterMaker','UnderwriterChecker') THEN h.ENTRYDATE END) AS ENTRYDATE,
           MAX(CASE WHEN h.WORKSTEP_CODE IN ('UnderwriterMaker','UnderwriterChecker') THEN h.EXITDATE  END) AS EXITDATE,
           -- Co trang thai cap ho so: nhanh theo QUYET DINH (1,3,5) lay tu moi dong; nhanh theo TRANG THAI workflow (2,4)
           -- chi lay tu dong moi nhat (DAYID, ENTRYDATE lon nhat) vi dong cu giu WF_ACTIVITYNAME luc ghi
           LEAST(
               NVL(MIN(CASE h.WORKSTEP_FLAG
                            WHEN 'Hồ sơ đã chuyển sang bước cấp PD và đã được phê duyệt' THEN 1
                            WHEN 'Hồ sơ CVTĐ đã xử lý và chốt trạng thái tại bước của CVTĐ' THEN 3
                            WHEN 'Hồ sơ CVTĐ đã xử lý nhưng chuyển/trả lại các bộ phận để bổ sung/làm rõ' THEN 5 END), 9),
               NVL(MAX(CASE h.WORKSTEP_FLAG
                            WHEN 'Hồ sơ đã chuyển sang bước của cấp phê duyệt nhưng chưa PD' THEN 2
                            WHEN 'Hồ sơ CVTĐ đang/phải xử lý' THEN 4 END)
                       KEEP (DENSE_RANK LAST ORDER BY h.DAYID, h.ENTRYDATE), 9)
           ) AS FLAG_RANK
    FROM   rlos_hist h
    GROUP  BY h.WI_NAME
),
-- RLOS: ten khach hang theo SRS (APPLICANT_GENERAL.FULL_NAME) -> FCT_RLOS_CUSTOMER, 1 dong dai dien / ho so (uu tien giay to TCC/CC)
rlos_cust AS (
    SELECT WI_NAME, FULL_NAME
    FROM (
        SELECT cu.WI_NAME, cu.FULL_NAME,
               ROW_NUMBER() OVER (
                   PARTITION BY cu.WI_NAME
                   ORDER BY CASE WHEN cu.ID_TYPE IN ('TCC','CC') THEN 0 ELSE 1 END, cu.ID_TYPE
               ) AS RN
        FROM   PDTD_DTM.FCT_RLOS_CUSTOMER cu
        JOIN   p ON cu.DAYID = p.d_to
        JOIN   rlos_scope s ON s.WI_NAME = cu.WI_NAME
    )
    WHERE RN = 1
)
-- ===== Nhanh CLOS =====
SELECT
    TO_CHAR(TRUNC(s.REPORT_DATE, 'IW'), 'YYYYMMDD') || '-' || TO_CHAR(TRUNC(s.REPORT_DATE, 'IW') + 6, 'YYYYMMDD') AS REPORT_WEEK,
    s.REPORT_DATE,
    'CLOS'                                                  AS SYSTEMNAME,
    s.WI_NAME                                               AS WINAME,
    dc.CUSTOMER_NAME,
    u.WORKSTEP,
    u.UND_MAKER,
    g.ENTRYDATE,
    g.EXITDATE,
    CASE g.FLAG_RANK
         WHEN 1 THEN 'Hồ sơ đã chuyển sang bước cấp PD và đã được phê duyệt'
         WHEN 2 THEN 'Hồ sơ đã chuyển sang bước của cấp phê duyệt nhưng chưa PD'
         WHEN 3 THEN 'Hồ sơ CVTĐ đã xử lý và chốt trạng thái tại bước của CVTĐ'
         WHEN 4 THEN 'Hồ sơ CVTĐ đang/phải xử lý'
         WHEN 5 THEN 'Hồ sơ CVTĐ đã xử lý nhưng chuyển/trả lại các bộ phận để bổ sung/làm rõ'
    END                                                     AS FLAG,
    u.REMARKS
FROM       clos_scope s
JOIN       clos_uw  u  ON u.WI_NAME = s.WI_NAME
LEFT JOIN  clos_agg g  ON g.WI_NAME = s.WI_NAME
LEFT JOIN  PDTD_DTM.DIM_CLOS_CUSTOMER dc ON dc.DIMENSION_KEY = s.CUSTOMER_SK
UNION ALL
-- ===== Nhanh RLOS =====
SELECT
    TO_CHAR(TRUNC(s.REPORT_DATE, 'IW'), 'YYYYMMDD') || '-' || TO_CHAR(TRUNC(s.REPORT_DATE, 'IW') + 6, 'YYYYMMDD') AS REPORT_WEEK,
    s.REPORT_DATE,
    'RLOS'                                                  AS SYSTEMNAME,
    s.WI_NAME                                               AS WINAME,
    cu.FULL_NAME                                            AS CUSTOMER_NAME,
    u.WORKSTEP,
    u.UND_MAKER,
    g.ENTRYDATE,
    g.EXITDATE,
    CASE g.FLAG_RANK
         WHEN 1 THEN 'Hồ sơ đã chuyển sang bước cấp PD và đã được phê duyệt'
         WHEN 2 THEN 'Hồ sơ đã chuyển sang bước của cấp phê duyệt nhưng chưa PD'
         WHEN 3 THEN 'Hồ sơ CVTĐ đã xử lý và chốt trạng thái tại bước của CVTĐ'
         WHEN 4 THEN 'Hồ sơ CVTĐ đang/phải xử lý'
         WHEN 5 THEN 'Hồ sơ CVTĐ đã xử lý nhưng chuyển/trả lại các bộ phận để bổ sung/làm rõ'
    END                                                     AS FLAG,
    u.REMARKS
FROM       rlos_scope s
JOIN       rlos_uw  u  ON u.WI_NAME = s.WI_NAME
LEFT JOIN  rlos_agg g  ON g.WI_NAME = s.WI_NAME
LEFT JOIN  rlos_cust cu ON cu.WI_NAME = s.WI_NAME
ORDER BY   SYSTEMNAME, WINAME
]');
  END BC4_UW_WEEKLY;

  /* =====================================================================
     BC5 - Bao cao SLA - TAT (CLOS + RLOS)
     Tham so:
       p_date_from     DATE      Tu ngay (PROCESSED_DATE), mac dinh T-1
       p_date_to       DATE      Den ngay (PROCESSED_DATE), mac dinh T-1; ngay du lieu cua bang snapshot (DAYID) = p_date_to (giu nguyen)
     Grain: toi da 2 dong / ho so (moi nhanh CLOS, RLOS); cot BI_FLAG_APPROVAL phan biet:
       - 'First Approval' (1) ho so DA phe duyet lan 1: doc bang tinh san PDTD_DTM.AGG_LOS_SLA_TAT_APPROVAL (1 dong/ho so, chi lan duyet dau, append-only),
                              loc PROCESSED_DATE trong khoang, KHONG can loc DAYID vi bang chi chua ho so da Approved/Rejected (nguoi dung chot 2026-11-25;
                              chi khi chay lai cho p_date_to qua khu ma ho so duoc he thong thay duyet SAU ngay do thi phan live con 'Processing' trong khi bang da co dong 'Approved');
                          (2) ho so CHUA phe duyet (MIN_APP_EXITDATE IS NULL): tinh truc tiep tu FCT_*_APPLICATION + FCT_*_WORKSTEP_EVENT, BI_APPSTATUS = APPLICATION_STATUS
                              (Processing/Cancelled), TAT cac buoc den hien tai. Ho so chi o BranchSupport co PROCESSED_DATE NULL nen khong len bao cao.
       - 'From Second Approval': ho so da phe duyet lan 1 va co event buoc PDTD (ke ca PhoneVerification) SAU do (quay lai PDTD); tinh truc tiep, PD lan 3 tro di gop chung.
           PROCESSED_DATE = FCT.PROCESSED_DATE (ngay phe duyet gan nhat), TAT = cac buoc SAU lan phe duyet dau (event co NVL(EXITDATE, ENTRYDATE) > MIN_APP_EXITDATE).
           BI_APPSTATUS: 'Processing' neu buoc cuoi (LAST_WORKSTEP) thuoc PDTD va LAST_ENTRYDATE >= PROCESSED_DATE (ho so dang o buoc PDTD sau lan phe duyet gan nhat: da bi tra lai / cho phe duyet lai);
                         con lai = APPLICATION_STATUS (Approved/Rejected, hoac 'Cancelled' khi ho so da duyet roi bi huy tai buoc PDTD - FCT_*_APPLICATION da xu ly san, review 2026-11-25).
     Phan live (tinh truc tiep):
       - FCT_*_APPLICATION co DAYID = p_date_to va PROCESSED_DATE trong [p_date_from, p_date_to].
       - STEPnn_* / TAT_*: SUM theo buoc cua TAT_CALENDAR_HOUR / TAT_WORKING_HOUR / TAT_CPC_HOUR tren FCT_*_WORKSTEP_EVENT (LLD da tinh san; buoc dang treo
         dong bang den het ngay dau tien), lam tron 2 chu so.
       - FCT_*_WORKSTEP_EVENT ghi nhieu phien ban / su kien (moi DAYID 1 dong) -> chi lay phien ban moi nhat cua tung WORKSTEP_EVENT_BK den p_date_to.
         Day la lich su cac buoc de cong TAT nen CHI chan tren DAYID <= p_date_to, KHONG chan duoi theo p_date_from.
       - SLA_DE / SLA_QC / QD_DDE / QD_QC: tra PDTD_DTM.REF_SLA_NLTT luc truy van
         (RLOS: PRODUCT_LINE = DIM_RLOS_PRODUCT.PRODUCTLINE_NAME; CLOS: NEW_CHANGE_REQUEST = CHANGE_REQUEST, PRODUCT_LINE = DIM_CLOS_PRODUCT.PRODUCTLINE_NAME
         (noi theo PRODUCTLINE_SK, lay ten moi nhat cua layer Product Line), SUB_PRODUCT: dong khop SUB_PRODUCT cua ho so THANG dong mac dinh SUB_PRODUCT NULL
         (COALESCE; cung quy uoc FCT_CLOS_APPLICATION.REF_PRODUCT/SLA_*) — seed REF_SLA_NLTT co nhom co ca 2 dong nen join theo chu SRS se nhan dong; nguoi dung da chot quy tac nay 2026-11-25, ngoai chu SRS).
       - Ten truong SLA_*_RESUTL giu dung chinh ta cua SRS.
     ===================================================================== */
  FUNCTION BC5_SLA_TAT(p_date_from DATE, p_date_to DATE)
    RETURN CLOB SQL_MACRO(TABLE) IS
  BEGIN
    RETURN TO_CLOB(q'[
WITH
p AS (
    SELECT TRUNC(p_date_from) AS d_from,
           TRUNC(p_date_to)   AS d_to
    FROM   DUAL
),
-- ===== CLOS =====
clos_app AS (
    SELECT a.*
    FROM   PDTD_DTM.FCT_CLOS_APPLICATION a
    JOIN   p ON a.DAYID = p.d_to
            AND a.PROCESSED_DATE >= p.d_from
            AND a.PROCESSED_DATE <  p.d_to + 1
),
-- Su kien cac buoc tinh TAT (phien ban moi nhat cua tung su kien, den p_date_to)
clos_ev AS (
    SELECT e.WI_NAME, e.WORKSTEP_CODE, e.DECISION_CODE, e.ENTRYDATE, e.EXITDATE,
           e.TAT_CALENDAR_HOUR, e.TAT_WORKING_HOUR, e.TAT_CPC_HOUR
    FROM   PDTD_DTM.FCT_CLOS_WORKSTEP_EVENT e
    JOIN   clos_app a ON a.WI_NAME = e.WI_NAME
    JOIN   p ON e.DAYID <= p.d_to
    WHERE  e.WORKSTEP_CODE IN ('BranchSupport','DetailDataEntry','CLOS_DetailDataEntry','DataInputerChecker','CLOS_DataInputerChecker','UnderwriterMaker','UnderwriterChecker','PhoneVerification','CreditApproval','CreditCommittee')
      AND  (a.MIN_APP_EXITDATE IS NULL OR NVL(e.EXITDATE, e.ENTRYDATE) > a.MIN_APP_EXITDATE)   -- da duyet lan 1: chi event SAU lan duyet dau
      AND  NOT EXISTS (SELECT 1
                       FROM   PDTD_DTM.FCT_CLOS_WORKSTEP_EVENT nv
                       WHERE  nv.WORKSTEP_EVENT_BK = e.WORKSTEP_EVENT_BK
                         AND  nv.DAYID > e.DAYID
                         AND  nv.DAYID <= p.d_to)
),
clos_agg AS (
    SELECT a.WI_NAME,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE = 'BranchSupport' THEN e.TAT_CALENDAR_HOUR END), 0), 2)  AS STEP01_BRANCH_CL_TAT,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE = 'BranchSupport' THEN e.TAT_WORKING_HOUR END), 0), 2)  AS STEP01_BRANCH_WK_TAT,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE = 'BranchSupport' THEN e.TAT_CPC_HOUR END), 0), 2)  AS STEP01_BRANCH_TAT_CPC,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE IN ('DetailDataEntry','CLOS_DetailDataEntry') THEN e.TAT_CALENDAR_HOUR END), 0), 2)  AS STEP02_DDE_CL_TAT,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE IN ('DetailDataEntry','CLOS_DetailDataEntry') THEN e.TAT_WORKING_HOUR END), 0), 2)  AS STEP02_DDE_WK_TAT,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE IN ('DetailDataEntry','CLOS_DetailDataEntry') THEN e.TAT_CPC_HOUR END), 0), 2)  AS STEP02_DDE_TAT_CPC,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE IN ('DataInputerChecker','CLOS_DataInputerChecker') THEN e.TAT_CALENDAR_HOUR END), 0), 2)  AS STEP03_QUALITY_CHECKER_CL_TAT,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE IN ('DataInputerChecker','CLOS_DataInputerChecker') THEN e.TAT_WORKING_HOUR END), 0), 2)  AS STEP03_QUALITY_CHECKER_WK_TAT,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE IN ('DataInputerChecker','CLOS_DataInputerChecker') THEN e.TAT_CPC_HOUR END), 0), 2)  AS STEP03_QUALITY_CHECKER_TAT_CPC,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE = 'UnderwriterMaker' THEN e.TAT_CALENDAR_HOUR END), 0), 2)  AS STEP04_UNDMAKER_CL_TAT,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE = 'UnderwriterMaker' THEN e.TAT_WORKING_HOUR END), 0), 2)  AS STEP04_UNDMAKER_WK_TAT,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE = 'UnderwriterMaker' THEN e.TAT_CPC_HOUR END), 0), 2)  AS STEP04_UNDMAKER_TAT_CPC,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE = 'UnderwriterChecker' THEN e.TAT_CALENDAR_HOUR END), 0), 2)  AS STEP04_UNDCHECKER_CL_TAT,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE = 'UnderwriterChecker' THEN e.TAT_WORKING_HOUR END), 0), 2)  AS STEP04_UNDCHECKER_WK_TAT,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE = 'UnderwriterChecker' THEN e.TAT_CPC_HOUR END), 0), 2)  AS STEP04_UNDCHECKER_TAT_CPC,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE IN ('UnderwriterMaker','UnderwriterChecker') THEN e.TAT_CPC_HOUR END), 0), 2)  AS STEP04_UND_TAT_CPC,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE = 'CreditApproval' THEN e.TAT_CALENDAR_HOUR END), 0), 2)  AS STEP07_APPROVER_CL_TAT,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE = 'CreditApproval' THEN e.TAT_WORKING_HOUR END), 0), 2)  AS STEP07_APPROVER_WK_TAT,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE = 'CreditApproval' THEN e.TAT_CPC_HOUR END), 0), 2)  AS STEP07_APPROVER_TAT_CPC,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE = 'CreditCommittee' THEN e.TAT_CALENDAR_HOUR END), 0), 2)  AS STEP07_COMMITTEE_CL_TAT,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE = 'CreditCommittee' THEN e.TAT_WORKING_HOUR END), 0), 2)  AS STEP07_COMMITTEE_WK_TAT,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE IN ('UnderwriterMaker','UnderwriterChecker') THEN e.TAT_CALENDAR_HOUR END), 0), 2)  AS TAT_PHONG_CL_TAT,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE IN ('UnderwriterMaker','UnderwriterChecker') THEN e.TAT_WORKING_HOUR END), 0), 2)  AS TAT_PHONG_WK_TAT,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE IN ('UnderwriterMaker','UnderwriterChecker','CreditApproval','CreditCommittee') THEN e.TAT_CALENDAR_HOUR END), 0), 2)  AS TAT_KHOI_PDTD_CL_TAT,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE IN ('UnderwriterMaker','UnderwriterChecker','CreditApproval','CreditCommittee') THEN e.TAT_WORKING_HOUR END), 0), 2)  AS TAT_KHOI_PDTD_WK_TAT,
           -- PDTD_EVT_CNT: co event buoc PDTD sau lan duyet dau -> ho so da duyet moi co dong 'From Second Approval'
           COUNT(CASE WHEN e.WORKSTEP_CODE IN ('DetailDataEntry','CLOS_DetailDataEntry','DataInputerChecker','CLOS_DataInputerChecker','UnderwriterMaker','UnderwriterChecker','PhoneVerification','CreditApproval','CreditCommittee') THEN 1 END)                                        AS PDTD_EVT_CNT,
           MIN(CASE WHEN e.WORKSTEP_CODE IN ('DetailDataEntry','CLOS_DetailDataEntry') THEN e.ENTRYDATE END)                   AS ENTRYDATE_DDE,
           MAX(CASE WHEN e.WORKSTEP_CODE IN ('DetailDataEntry','CLOS_DetailDataEntry') THEN e.EXITDATE  END)                   AS EXITDATE_DDE
    FROM   clos_app a
    LEFT JOIN clos_ev e ON e.WI_NAME = a.WI_NAME
    GROUP  BY a.WI_NAME
),
-- Tra REF_SLA_NLTT nhanh CLOS: dong khop SUB_PRODUCT cu the THANG dong mac dinh (SUB_PRODUCT NULL) - tranh nhan dong
clos_ref AS (
    SELECT a.WI_NAME,
           COALESCE(fs.SLA_DE_RESULT, fd.SLA_DE_RESULT) AS SLA_DE_RESULT,
           COALESCE(fs.SLA_QC_RESULT, fd.SLA_QC_RESULT) AS SLA_QC_RESULT,
           COALESCE(fs.QD_DDE,        fd.QD_DDE)        AS QD_DDE,
           COALESCE(fs.QD_QC,         fd.QD_QC)         AS QD_QC
    FROM   clos_app a
    LEFT JOIN PDTD_DTM.DIM_CLOS_APPLICATION da ON da.DIMENSION_KEY = a.APPLICATION_SK
    LEFT JOIN (SELECT PRODUCTLINE_SK,
                      MAX(PRODUCTLINE_NAME) KEEP (DENSE_RANK LAST
                          ORDER BY NVL(PRODUCTLINE_EFF_DATE, DATE '1900-01-01'),
                                   NVL(PRODUCTLINE_EXP_DATE, DATE '9999-12-31')) AS PRODUCTLINE_NAME
               FROM   PDTD_DTM.DIM_CLOS_PRODUCT
               GROUP  BY PRODUCTLINE_SK) pr ON pr.PRODUCTLINE_SK = a.PRODUCTLINE_SK
    LEFT JOIN PDTD_DTM.REF_SLA_NLTT fs ON fs.SYSTEMNAME = 'CLOS'
                                      AND fs.NEW_CHANGE_REQUEST = a.CHANGE_REQUEST
                                      AND fs.PRODUCT_LINE = pr.PRODUCTLINE_NAME
                                      AND fs.SUB_PRODUCT = da.SUB_PRODUCT
    LEFT JOIN PDTD_DTM.REF_SLA_NLTT fd ON fd.SYSTEMNAME = 'CLOS'
                                      AND fd.NEW_CHANGE_REQUEST = a.CHANGE_REQUEST
                                      AND fd.PRODUCT_LINE = pr.PRODUCTLINE_NAME
                                      AND fd.SUB_PRODUCT IS NULL
),
-- ===== RLOS =====
rlos_app AS (
    SELECT a.*
    FROM   PDTD_DTM.FCT_RLOS_APPLICATION a
    JOIN   p ON a.DAYID = p.d_to
            AND a.PROCESSED_DATE >= p.d_from
            AND a.PROCESSED_DATE <  p.d_to + 1
),
-- Su kien cac buoc tinh TAT (phien ban moi nhat cua tung su kien, den p_date_to)
rlos_ev AS (
    SELECT e.WI_NAME, e.WORKSTEP_CODE, e.DECISION_CODE, e.ENTRYDATE, e.EXITDATE,
           e.TAT_CALENDAR_HOUR, e.TAT_WORKING_HOUR, e.TAT_CPC_HOUR
    FROM   PDTD_DTM.FCT_RLOS_WORKSTEP_EVENT e
    JOIN   rlos_app a ON a.WI_NAME = e.WI_NAME
    JOIN   p ON e.DAYID <= p.d_to
    WHERE  e.WORKSTEP_CODE IN ('BranchSupport','DetailDataEntry','DataInputerChecker','UnderwriterMaker','UnderwriterChecker','PhoneVerification','CreditApproval','CreditCommittee')
      AND  (a.MIN_APP_EXITDATE IS NULL OR NVL(e.EXITDATE, e.ENTRYDATE) > a.MIN_APP_EXITDATE)   -- da duyet lan 1: chi event SAU lan duyet dau
      AND  NOT EXISTS (SELECT 1
                       FROM   PDTD_DTM.FCT_RLOS_WORKSTEP_EVENT nv
                       WHERE  nv.WORKSTEP_EVENT_BK = e.WORKSTEP_EVENT_BK
                         AND  nv.DAYID > e.DAYID
                         AND  nv.DAYID <= p.d_to)
),
rlos_agg AS (
    SELECT a.WI_NAME,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE = 'BranchSupport' THEN e.TAT_CALENDAR_HOUR END), 0), 2)  AS STEP01_BRANCH_CL_TAT,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE = 'BranchSupport' THEN e.TAT_WORKING_HOUR END), 0), 2)  AS STEP01_BRANCH_WK_TAT,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE = 'BranchSupport' THEN e.TAT_CPC_HOUR END), 0), 2)  AS STEP01_BRANCH_TAT_CPC,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE = 'DetailDataEntry' THEN e.TAT_CALENDAR_HOUR END), 0), 2)  AS STEP02_DDE_CL_TAT,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE = 'DetailDataEntry' THEN e.TAT_WORKING_HOUR END), 0), 2)  AS STEP02_DDE_WK_TAT,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE = 'DetailDataEntry' THEN e.TAT_CPC_HOUR END), 0), 2)  AS STEP02_DDE_TAT_CPC,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE = 'DataInputerChecker' THEN e.TAT_CALENDAR_HOUR END), 0), 2)  AS STEP03_QUALITY_CHECKER_CL_TAT,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE = 'DataInputerChecker' THEN e.TAT_WORKING_HOUR END), 0), 2)  AS STEP03_QUALITY_CHECKER_WK_TAT,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE = 'DataInputerChecker' THEN e.TAT_CPC_HOUR END), 0), 2)  AS STEP03_QUALITY_CHECKER_TAT_CPC,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE = 'UnderwriterMaker' THEN e.TAT_CALENDAR_HOUR END), 0), 2)  AS STEP04_UNDMAKER_CL_TAT,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE = 'UnderwriterMaker' THEN e.TAT_WORKING_HOUR END), 0), 2)  AS STEP04_UNDMAKER_WK_TAT,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE = 'UnderwriterMaker' THEN e.TAT_CPC_HOUR END), 0), 2)  AS STEP04_UNDMAKER_TAT_CPC,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE = 'UnderwriterChecker' THEN e.TAT_CALENDAR_HOUR END), 0), 2)  AS STEP04_UNDCHECKER_CL_TAT,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE = 'UnderwriterChecker' THEN e.TAT_WORKING_HOUR END), 0), 2)  AS STEP04_UNDCHECKER_WK_TAT,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE = 'UnderwriterChecker' THEN e.TAT_CPC_HOUR END), 0), 2)  AS STEP04_UNDCHECKER_TAT_CPC,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE IN ('UnderwriterMaker','UnderwriterChecker') THEN e.TAT_CPC_HOUR END), 0), 2)  AS STEP04_UND_TAT_CPC,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE = 'CreditApproval' THEN e.TAT_CALENDAR_HOUR END), 0), 2)  AS STEP07_APPROVER_CL_TAT,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE = 'CreditApproval' THEN e.TAT_WORKING_HOUR END), 0), 2)  AS STEP07_APPROVER_WK_TAT,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE = 'CreditApproval' THEN e.TAT_CPC_HOUR END), 0), 2)  AS STEP07_APPROVER_TAT_CPC,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE = 'CreditCommittee' THEN e.TAT_CALENDAR_HOUR END), 0), 2)  AS STEP07_COMMITTEE_CL_TAT,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE = 'CreditCommittee' THEN e.TAT_WORKING_HOUR END), 0), 2)  AS STEP07_COMMITTEE_WK_TAT,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE IN ('UnderwriterMaker','UnderwriterChecker') THEN e.TAT_CALENDAR_HOUR END), 0), 2)  AS TAT_PHONG_CL_TAT,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE IN ('UnderwriterMaker','UnderwriterChecker') THEN e.TAT_WORKING_HOUR END), 0), 2)  AS TAT_PHONG_WK_TAT,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE IN ('UnderwriterMaker','UnderwriterChecker') THEN e.TAT_CALENDAR_HOUR END), 0)
             + CASE WHEN COUNT(CASE WHEN e.WORKSTEP_CODE = 'CreditCommittee' THEN 1 END) = 0
                    THEN NVL(SUM(CASE WHEN e.WORKSTEP_CODE = 'CreditApproval' THEN e.TAT_CALENDAR_HOUR END), 0) ELSE 0 END, 2)  AS TAT_KHOI_PDTD_CL_TAT,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE IN ('UnderwriterMaker','UnderwriterChecker') THEN e.TAT_WORKING_HOUR END), 0)
             + CASE WHEN COUNT(CASE WHEN e.WORKSTEP_CODE = 'CreditCommittee' THEN 1 END) = 0
                    THEN NVL(SUM(CASE WHEN e.WORKSTEP_CODE = 'CreditApproval' THEN e.TAT_WORKING_HOUR END), 0) ELSE 0 END, 2)  AS TAT_KHOI_PDTD_WK_TAT,
           -- PDTD_EVT_CNT: co event buoc PDTD sau lan duyet dau -> ho so da duyet moi co dong 'From Second Approval'
           COUNT(CASE WHEN e.WORKSTEP_CODE IN ('DetailDataEntry','DataInputerChecker','UnderwriterMaker','UnderwriterChecker','PhoneVerification','CreditApproval','CreditCommittee') THEN 1 END)                                        AS PDTD_EVT_CNT,
           MIN(CASE WHEN e.WORKSTEP_CODE = 'DetailDataEntry' THEN e.ENTRYDATE END)                   AS ENTRYDATE_DDE,
           MAX(CASE WHEN e.WORKSTEP_CODE = 'DetailDataEntry' THEN e.EXITDATE  END)                   AS EXITDATE_DDE
    FROM   rlos_app a
    LEFT JOIN rlos_ev e ON e.WI_NAME = a.WI_NAME
    GROUP  BY a.WI_NAME
)
-- ===== Phan 1: lan phe duyet dau da tinh san (PDTD_DTM.AGG_LOS_SLA_TAT_APPROVAL), loc PROCESSED_DATE, KHONG loc DAYID =====
SELECT
    t.SYSTEMNAME,
    t.PROCESSED_DATE,
    t.WI_NAME AS WINAME,
    t.BI_APPSTATUS,
    t.STEP01_BRANCH_CL_TAT,
    t.STEP01_BRANCH_WK_TAT,
    t.STEP01_BRANCH_TAT_CPC,
    t.STEP02_DDE_CL_TAT,
    t.STEP02_DDE_WK_TAT,
    t.STEP02_DDE_TAT_CPC,
    t.STEP03_QUALITY_CHECKER_CL_TAT,
    t.STEP03_QUALITY_CHECKER_WK_TAT,
    t.STEP03_QUALITY_CHECKER_TAT_CPC,
    t.STEP04_UNDMAKER_CL_TAT,
    t.STEP04_UNDMAKER_WK_TAT,
    t.STEP04_UNDMAKER_TAT_CPC,
    t.STEP04_UNDCHECKER_CL_TAT,
    t.STEP04_UNDCHECKER_WK_TAT,
    t.STEP04_UNDCHECKER_TAT_CPC,
    t.STEP04_UND_TAT_CPC,
    t.STEP07_APPROVER_CL_TAT,
    t.STEP07_APPROVER_WK_TAT,
    t.STEP07_APPROVER_TAT_CPC,
    t.STEP07_COMMITTEE_CL_TAT,
    t.STEP07_COMMITTEE_WK_TAT,
    t.REF_PRODUCT,
    t.SLA_CREDIT_OFFICER,
    t.SLA_CREDIT_APPROVER,
    t.SLA_MARKER,
    t.SLA_CHECKER,
    t.SLA_MARKER_RESUTL,
    t.SLA_CHECKER_RESUTL,
    t.SLA_CO_RESUTL,
    t.SLA_APPROVER_RESULT,
    t.SLA_CO_APPROVER_RESULT,
    t.TAT_PHONG_CL_TAT,
    t.TAT_PHONG_WK_TAT,
    t.TAT_KHOI_PDTD_CL_TAT,
    t.TAT_KHOI_PDTD_WK_TAT,
    'First Approval' AS BI_FLAG_APPROVAL,
    t.ENTRYDATE_DDE,
    t.EXITDATE_DDE,
    t.SLA_DE,
    t.SLA_QC,
    t.SLA_DE_RESULT,
    t.SLA_QC_RESULT,
    t.SLA_DE_TOTAL_RESULT,
    t.QD_DDE,
    t.QD_QC
FROM       PDTD_DTM.AGG_LOS_SLA_TAT_APPROVAL t
JOIN       p ON t.PROCESSED_DATE >= p.d_from AND t.PROCESSED_DATE < p.d_to + 1
UNION ALL
-- ===== Phan 2: tinh truc tiep, nhanh CLOS (ho so chua duyet + dong 'From Second Approval') =====
SELECT
    'CLOS'                                                  AS SYSTEMNAME,
    a.PROCESSED_DATE,
    a.WI_NAME                                               AS WINAME,
    CASE WHEN a.MIN_APP_EXITDATE IS NULL THEN a.APPLICATION_STATUS
         WHEN a.LAST_WORKSTEP IN ('DetailDataEntry','CLOS_DetailDataEntry','DataInputerChecker','CLOS_DataInputerChecker','UnderwriterMaker','UnderwriterChecker','PhoneVerification','CreditApproval','CreditCommittee') AND a.LAST_ENTRYDATE >= a.PROCESSED_DATE THEN 'Processing'   -- ho so dang o buoc PDTD sau lan duyet gan nhat; 'Cancelled' da co san trong APPLICATION_STATUS
         ELSE a.APPLICATION_STATUS END                       AS BI_APPSTATUS,
    g.STEP01_BRANCH_CL_TAT,
    g.STEP01_BRANCH_WK_TAT,
    g.STEP01_BRANCH_TAT_CPC,
    g.STEP02_DDE_CL_TAT,
    g.STEP02_DDE_WK_TAT,
    g.STEP02_DDE_TAT_CPC,
    g.STEP03_QUALITY_CHECKER_CL_TAT,
    g.STEP03_QUALITY_CHECKER_WK_TAT,
    g.STEP03_QUALITY_CHECKER_TAT_CPC,
    g.STEP04_UNDMAKER_CL_TAT,
    g.STEP04_UNDMAKER_WK_TAT,
    g.STEP04_UNDMAKER_TAT_CPC,
    g.STEP04_UNDCHECKER_CL_TAT,
    g.STEP04_UNDCHECKER_WK_TAT,
    g.STEP04_UNDCHECKER_TAT_CPC,
    g.STEP04_UND_TAT_CPC,
    g.STEP07_APPROVER_CL_TAT,
    g.STEP07_APPROVER_WK_TAT,
    g.STEP07_APPROVER_TAT_CPC,
    g.STEP07_COMMITTEE_CL_TAT,
    g.STEP07_COMMITTEE_WK_TAT,
    a.REF_PRODUCT,
    a.SLA_CREDIT_OFFICER,
    a.SLA_CREDIT_APPROVER,
    a.SLA_MARKER,
    a.SLA_CHECKER,
    CASE WHEN g.STEP04_UNDMAKER_TAT_CPC > a.SLA_MARKER THEN 'KHONG DAT'
         WHEN g.STEP04_UNDMAKER_TAT_CPC <= a.SLA_MARKER THEN 'DAT' END                    AS SLA_MARKER_RESUTL,
    CASE WHEN g.STEP04_UNDCHECKER_TAT_CPC > a.SLA_CHECKER THEN 'KHONG DAT'
         WHEN g.STEP04_UNDCHECKER_TAT_CPC <= a.SLA_CHECKER THEN 'DAT' END                    AS SLA_CHECKER_RESUTL,
    CASE WHEN g.STEP04_UND_TAT_CPC > a.SLA_CREDIT_OFFICER THEN 'KHONG DAT'
         WHEN g.STEP04_UND_TAT_CPC <= a.SLA_CREDIT_OFFICER THEN 'DAT' END                    AS SLA_CO_RESUTL,
    CASE WHEN g.STEP07_APPROVER_TAT_CPC > a.SLA_CREDIT_APPROVER THEN 'KHONG DAT'
         WHEN g.STEP07_APPROVER_TAT_CPC <= a.SLA_CREDIT_APPROVER THEN 'DAT' END                    AS SLA_APPROVER_RESULT,
    CASE WHEN (g.STEP04_UND_TAT_CPC + g.STEP07_APPROVER_TAT_CPC) > (a.SLA_CREDIT_OFFICER + a.SLA_CREDIT_APPROVER) THEN 'KHONG DAT'
         WHEN (g.STEP04_UND_TAT_CPC + g.STEP07_APPROVER_TAT_CPC) <= (a.SLA_CREDIT_OFFICER + a.SLA_CREDIT_APPROVER) THEN 'DAT' END                    AS SLA_CO_APPROVER_RESULT,
    g.TAT_PHONG_CL_TAT,
    g.TAT_PHONG_WK_TAT,
    g.TAT_KHOI_PDTD_CL_TAT,
    g.TAT_KHOI_PDTD_WK_TAT,
    CASE WHEN a.MIN_APP_EXITDATE IS NULL THEN 'First Approval' ELSE 'From Second Approval' END   AS BI_FLAG_APPROVAL,
    g.ENTRYDATE_DDE,
    g.EXITDATE_DDE,
    f.SLA_DE_RESULT                                         AS SLA_DE,
    f.SLA_QC_RESULT                                         AS SLA_QC,
    CASE WHEN g.STEP02_DDE_TAT_CPC > f.SLA_DE_RESULT THEN 'KHONG DAT'
         WHEN g.STEP02_DDE_TAT_CPC <= f.SLA_DE_RESULT THEN 'DAT' END                    AS SLA_DE_RESULT,
    CASE WHEN g.STEP03_QUALITY_CHECKER_TAT_CPC > f.SLA_QC_RESULT THEN 'KHONG DAT'
         WHEN g.STEP03_QUALITY_CHECKER_TAT_CPC <= f.SLA_QC_RESULT THEN 'DAT' END                    AS SLA_QC_RESULT,
    CASE WHEN (g.STEP02_DDE_TAT_CPC + g.STEP03_QUALITY_CHECKER_TAT_CPC) > (f.SLA_DE_RESULT + f.SLA_QC_RESULT) THEN 'KHONG DAT'
         WHEN (g.STEP02_DDE_TAT_CPC + g.STEP03_QUALITY_CHECKER_TAT_CPC) <= (f.SLA_DE_RESULT + f.SLA_QC_RESULT) THEN 'DAT' END                    AS SLA_DE_TOTAL_RESULT,
    f.QD_DDE,
    f.QD_QC
FROM       clos_app a
JOIN       clos_agg g ON g.WI_NAME = a.WI_NAME
LEFT JOIN  clos_ref f ON f.WI_NAME = a.WI_NAME
WHERE      (a.MIN_APP_EXITDATE IS NULL OR g.PDTD_EVT_CNT > 0)   -- chua duyet: dong First; da duyet: chi khi quay lai PDTD (dong Second)
UNION ALL
-- ===== Phan 2: tinh truc tiep, nhanh RLOS (ho so chua duyet + dong 'From Second Approval') =====
SELECT
    'RLOS'                                                  AS SYSTEMNAME,
    a.PROCESSED_DATE,
    a.WI_NAME                                               AS WINAME,
    CASE WHEN a.MIN_APP_EXITDATE IS NULL THEN a.APPLICATION_STATUS
         WHEN a.LAST_WORKSTEP IN ('DetailDataEntry','DataInputerChecker','UnderwriterMaker','UnderwriterChecker','PhoneVerification','CreditApproval','CreditCommittee') AND a.LAST_ENTRYDATE >= a.PROCESSED_DATE THEN 'Processing'   -- ho so dang o buoc PDTD sau lan duyet gan nhat; 'Cancelled' da co san trong APPLICATION_STATUS
         ELSE a.APPLICATION_STATUS END                       AS BI_APPSTATUS,
    g.STEP01_BRANCH_CL_TAT,
    g.STEP01_BRANCH_WK_TAT,
    g.STEP01_BRANCH_TAT_CPC,
    g.STEP02_DDE_CL_TAT,
    g.STEP02_DDE_WK_TAT,
    g.STEP02_DDE_TAT_CPC,
    g.STEP03_QUALITY_CHECKER_CL_TAT,
    g.STEP03_QUALITY_CHECKER_WK_TAT,
    g.STEP03_QUALITY_CHECKER_TAT_CPC,
    g.STEP04_UNDMAKER_CL_TAT,
    g.STEP04_UNDMAKER_WK_TAT,
    g.STEP04_UNDMAKER_TAT_CPC,
    g.STEP04_UNDCHECKER_CL_TAT,
    g.STEP04_UNDCHECKER_WK_TAT,
    g.STEP04_UNDCHECKER_TAT_CPC,
    g.STEP04_UND_TAT_CPC,
    g.STEP07_APPROVER_CL_TAT,
    g.STEP07_APPROVER_WK_TAT,
    g.STEP07_APPROVER_TAT_CPC,
    g.STEP07_COMMITTEE_CL_TAT,
    g.STEP07_COMMITTEE_WK_TAT,
    a.REF_PRODUCT,
    a.SLA_CREDIT_OFFICER,
    a.SLA_CREDIT_APPROVER,
    a.SLA_MARKER,
    a.SLA_CHECKER,
    CASE WHEN g.STEP04_UNDMAKER_TAT_CPC > a.SLA_MARKER THEN 'KHONG DAT'
         WHEN g.STEP04_UNDMAKER_TAT_CPC <= a.SLA_MARKER THEN 'DAT' END                    AS SLA_MARKER_RESUTL,
    CASE WHEN g.STEP04_UNDCHECKER_TAT_CPC > a.SLA_CHECKER THEN 'KHONG DAT'
         WHEN g.STEP04_UNDCHECKER_TAT_CPC <= a.SLA_CHECKER THEN 'DAT' END                    AS SLA_CHECKER_RESUTL,
    CASE WHEN g.STEP04_UND_TAT_CPC > a.SLA_CREDIT_OFFICER THEN 'KHONG DAT'
         WHEN g.STEP04_UND_TAT_CPC <= a.SLA_CREDIT_OFFICER THEN 'DAT' END                    AS SLA_CO_RESUTL,
    CASE WHEN g.STEP07_APPROVER_TAT_CPC > a.SLA_CREDIT_APPROVER THEN 'KHONG DAT'
         WHEN g.STEP07_APPROVER_TAT_CPC <= a.SLA_CREDIT_APPROVER THEN 'DAT' END                    AS SLA_APPROVER_RESULT,
    CASE WHEN (g.STEP04_UND_TAT_CPC + g.STEP07_APPROVER_TAT_CPC) > (a.SLA_CREDIT_OFFICER + a.SLA_CREDIT_APPROVER) THEN 'KHONG DAT'
         WHEN (g.STEP04_UND_TAT_CPC + g.STEP07_APPROVER_TAT_CPC) <= (a.SLA_CREDIT_OFFICER + a.SLA_CREDIT_APPROVER) THEN 'DAT' END                    AS SLA_CO_APPROVER_RESULT,
    g.TAT_PHONG_CL_TAT,
    g.TAT_PHONG_WK_TAT,
    g.TAT_KHOI_PDTD_CL_TAT,
    g.TAT_KHOI_PDTD_WK_TAT,
    CASE WHEN a.MIN_APP_EXITDATE IS NULL THEN 'First Approval' ELSE 'From Second Approval' END   AS BI_FLAG_APPROVAL,
    g.ENTRYDATE_DDE,
    g.EXITDATE_DDE,
    f.SLA_DE_RESULT                                         AS SLA_DE,
    f.SLA_QC_RESULT                                         AS SLA_QC,
    CASE WHEN g.STEP02_DDE_TAT_CPC > f.SLA_DE_RESULT THEN 'KHONG DAT'
         WHEN g.STEP02_DDE_TAT_CPC <= f.SLA_DE_RESULT THEN 'DAT' END                    AS SLA_DE_RESULT,
    CASE WHEN g.STEP03_QUALITY_CHECKER_TAT_CPC > f.SLA_QC_RESULT THEN 'KHONG DAT'
         WHEN g.STEP03_QUALITY_CHECKER_TAT_CPC <= f.SLA_QC_RESULT THEN 'DAT' END                    AS SLA_QC_RESULT,
    CASE WHEN (g.STEP02_DDE_TAT_CPC + g.STEP03_QUALITY_CHECKER_TAT_CPC) > (f.SLA_DE_RESULT + f.SLA_QC_RESULT) THEN 'KHONG DAT'
         WHEN (g.STEP02_DDE_TAT_CPC + g.STEP03_QUALITY_CHECKER_TAT_CPC) <= (f.SLA_DE_RESULT + f.SLA_QC_RESULT) THEN 'DAT' END                    AS SLA_DE_TOTAL_RESULT,
    f.QD_DDE,
    f.QD_QC
FROM       rlos_app a
JOIN       rlos_agg g ON g.WI_NAME = a.WI_NAME
LEFT JOIN  PDTD_DTM.DIM_RLOS_PRODUCT     pr ON pr.DIMENSION_KEY = a.SUB_PRODUCT_SK
LEFT JOIN  PDTD_DTM.REF_SLA_NLTT         f  ON f.SYSTEMNAME = 'RLOS'
                                           AND f.PRODUCT_LINE = pr.PRODUCTLINE_NAME
WHERE      (a.MIN_APP_EXITDATE IS NULL OR g.PDTD_EVT_CNT > 0)
ORDER BY   SYSTEMNAME, WINAME, BI_FLAG_APPROVAL
]');
  END BC5_SLA_TAT;

  /* =====================================================================
     BC6 - Bao cao NGOAI LE CLOS
     Tham so:
       p_date_from     DATE      Tu ngay (PROCESSED_DATE), mac dinh T-1
       p_date_to       DATE      Den ngay (PROCESSED_DATE), mac dinh T-1; ngay du lieu (DAYID) = p_date_to
     Grain: 1 dong / dong ngoai le (FCT_CLOS_DEVIATION), khong gop.
     Pham vi: dong ngoai le co DAYID = p_date_to (snapshot lich su) va PROCESSED_DATE trong
     [p_date_from, p_date_to]
     (PROCESSED_DATE tinh san tai SB_DWH theo 3 muc uu tien cua SRS).
     BC6 CLOS va BC6 RLOS co bo cot khac nhau nen la 2 cau lenh rieng.
     ===================================================================== */
  FUNCTION BC6_CLOS_DEVIATION(p_date_from DATE, p_date_to DATE)
    RETURN CLOB SQL_MACRO(TABLE) IS
  BEGIN
    RETURN TO_CLOB(q'[
SELECT
    d.WI_NAME,
    d.DEVIATION_TYPE_CODE                                   AS DEVIATION_TYPE,
    d.DEV_PROPOSAL,
    d.PROCESSED_DATE
FROM       PDTD_DTM.FCT_CLOS_DEVIATION d
JOIN       (SELECT TRUNC(p_date_from) AS d_from, TRUNC(p_date_to) AS d_to FROM DUAL) p
           ON d.DAYID = p.d_to
          AND d.PROCESSED_DATE >= p.d_from
          AND d.PROCESSED_DATE <  p.d_to + 1
ORDER BY   d.WI_NAME, d.DEVIATION_BK
]');
  END BC6_CLOS_DEVIATION;

  /* =====================================================================
     BC6 - Bao cao NGOAI LE RLOS
     Tham so:
       p_date_from     DATE      Tu ngay (PROCESSED_DATE), mac dinh T-1
       p_date_to       DATE      Den ngay (PROCESSED_DATE), mac dinh T-1; ngay du lieu (DAYID) = p_date_to
     Grain: 1 dong / dong ngoai le (FCT_RLOS_DEVIATION), khong gop.
     Pham vi: dong ngoai le co DAYID = p_date_to (snapshot lich su) va PROCESSED_DATE trong
     [p_date_from, p_date_to]
     (PROCESSED_DATE tinh san tai SB_DWH theo 3 muc uu tien cua SRS).
     BC6 RLOS va BC6 CLOS co bo cot khac nhau nen la 2 cau lenh rieng.
     ===================================================================== */
  FUNCTION BC6_RLOS_DEVIATION(p_date_from DATE, p_date_to DATE)
    RETURN CLOB SQL_MACRO(TABLE) IS
  BEGIN
    RETURN TO_CLOB(q'[
SELECT
    d.WI_NAME,
    d.CHECKING_RESULT,
    d.CHECKING_CONDITION,
    d.DEVIATION_REASON                                      AS REASON,
    d.PROCESSED_DATE
FROM       PDTD_DTM.FCT_RLOS_DEVIATION d
JOIN       (SELECT TRUNC(p_date_from) AS d_from, TRUNC(p_date_to) AS d_to FROM DUAL) p
           ON d.DAYID = p.d_to
          AND d.PROCESSED_DATE >= p.d_from
          AND d.PROCESSED_DATE <  p.d_to + 1
ORDER BY   d.WI_NAME, d.DEVIATION_BK
]');
  END BC6_RLOS_DEVIATION;

  /* =====================================================================
     BC7 - Bao cao EXCEPTION - FTR (CLOS + RLOS)
     Tham so:
       p_date_from     DATE      Tu ngay (PROCESSED_DATE = ngay phat sinh exception), mac dinh T-1
       p_date_to       DATE      Den ngay (PROCESSED_DATE = ngay phat sinh exception), mac dinh T-1; ngay du lieu (DAYID) = p_date_to
     Grain: 1 dong / (exception x buoc) - dung grain FCT_*_EXCEPTION (DAYID, EXCEPTION_BK, WORKSTEP_CODE).
     Pham vi: FCT_*_EXCEPTION co DAYID = p_date_to (snapshot day du lich su) va RAISED_DATE_TIME trong
     [p_date_from, p_date_to].
     ACTIVITYNAME = WORKSTEP_CODE (LLD da tinh: tra DIM_*_EXCEPTION, sau lan DetailDataEntry+Submit dau tien,
     mac dinh 'DEFAULT'). CHECK_FTR / FIRST_WORKSTEP_RETURN / PHAN_LOAI_DDE da tinh san tai LLD.
     PROCESSED_DATE = TRUNC(RAISED_DATE_TIME) cho ca 2 nhanh.
     Hai nhanh CLOS / RLOS cung bo cot, ghep bang UNION ALL.
     ===================================================================== */
  FUNCTION BC7_EXCEPTION_FTR(p_date_from DATE, p_date_to DATE)
    RETURN CLOB SQL_MACRO(TABLE) IS
  BEGIN
    RETURN TO_CLOB(q'[
WITH
p AS (
    SELECT TRUNC(p_date_from) AS d_from,
           TRUNC(p_date_to)   AS d_to
    FROM   DUAL
)
-- ===== Nhanh CLOS =====
SELECT
    TRUNC(e.RAISED_DATE_TIME)                               AS PROCESSED_DATE,
    e.WI_NAME,
    e.WORKSTEP_CODE                                         AS ACTIVITYNAME,
    e.EXCEPTION_CATEGORY,
    e.EXCEPTION_NAME,
    e.EXCEPTION_REMARKS,
    e.RAISED_BY,
    e.RAISED_DATE_TIME,
    CASE WHEN INSTR(e.EXCEPTION_CATEGORY, ':') > 0
         THEN REGEXP_SUBSTR(e.EXCEPTION_CATEGORY, '^[^:]+') END AS EXCEPTION_CODE,
    da.LOANCASEID,
    e.CHECK_FTR,
    e.FIRST_WORKSTEP_RETURN,
    e.PHAN_LOAI_DDE
FROM       PDTD_DTM.FCT_CLOS_EXCEPTION e
JOIN       p ON e.DAYID = p.d_to
          AND e.RAISED_DATE_TIME >= p.d_from
          AND e.RAISED_DATE_TIME <  p.d_to + 1
LEFT JOIN  PDTD_DTM.DIM_CLOS_APPLICATION  da ON da.DIMENSION_KEY = e.APPLICATION_SK
UNION ALL
-- ===== Nhanh RLOS =====
SELECT
    TRUNC(e.RAISED_DATE_TIME)                               AS PROCESSED_DATE,
    e.WI_NAME,
    e.WORKSTEP_CODE                                         AS ACTIVITYNAME,
    e.EXCEPTION_CATEGORY,
    e.EXCEPTION_NAME,
    e.EXCEPTION_REMARKS,
    e.RAISED_BY,
    e.RAISED_DATE_TIME,
    CASE WHEN INSTR(e.EXCEPTION_CATEGORY, ':') > 0
         THEN REGEXP_SUBSTR(e.EXCEPTION_CATEGORY, '^[^:]+') END AS EXCEPTION_CODE,
    da.LOANCASEID,
    e.CHECK_FTR,
    e.FIRST_WORKSTEP_RETURN,
    e.PHAN_LOAI_DDE
FROM       PDTD_DTM.FCT_RLOS_EXCEPTION e
JOIN       p ON e.DAYID = p.d_to
          AND e.RAISED_DATE_TIME >= p.d_from
          AND e.RAISED_DATE_TIME <  p.d_to + 1
LEFT JOIN  PDTD_DTM.DIM_RLOS_APPLICATION  da ON da.DIMENSION_KEY = e.APPLICATION_SK
ORDER BY   WI_NAME, RAISED_DATE_TIME, ACTIVITYNAME
]');
  END BC7_EXCEPTION_FTR;

  /* =====================================================================
     BC8 - Bao cao RETURN (CLOS + RLOS)
     Tham so:
       p_date_from     DATE      Tu ngay (PROCESSED_DATE = ngay ket thuc su kien), mac dinh T-1
       p_date_to       DATE      Den ngay (PROCESSED_DATE = ngay ket thuc su kien), mac dinh T-1; ngay du lieu cua bang snapshot (DAYID) = p_date_to
     Grain: 1 dong / su kien tra ve (FCT_*_WORKSTEP_EVENT co WORKSTEP thuoc 6 buoc va DECISION thuoc nhom
     tra ve / huy, EXITDATE trong [p_date_from, p_date_to]); 3 cot SL_RETURN_* la so luy ke cua ho so tai p_date_to.
     FCT_*_WORKSTEP_EVENT (lat cat ngay phat sinh): loc DAYID trong [p_date_from, p_date_to]; ghi nhieu phien ban /
     su kien (moi DAYID 1 dong) -> chi lay phien ban moi nhat cua tung WORKSTEP_EVENT_BK den p_date_to.
     SL_RETURN_NHAPLIEU / THAMDINH / PHEDUYET = RETURN_CNT_DATAENTRY / UNDERWRITING / APPROVAL tren
     FCT_*_APPLICATION (cot cong don mau C, review 2026-11-13; snapshot loc DAYID = p_date_to) - khong dem lai tren bang su kien.
     PROCESSED_DATE = TRUNC(EXITDATE).
     Hai nhanh CLOS / RLOS cung bo cot, ghep bang UNION ALL.
     ===================================================================== */
  FUNCTION BC8_RETURN(p_date_from DATE, p_date_to DATE)
    RETURN CLOB SQL_MACRO(TABLE) IS
  BEGIN
    RETURN TO_CLOB(q'[
WITH
p AS (
    SELECT TRUNC(p_date_from) AS d_from,
           TRUNC(p_date_to)   AS d_to
    FROM   DUAL
)
-- ===== Nhanh CLOS =====
SELECT
    TRUNC(e.EXITDATE)                                       AS PROCESSED_DATE,
    e.WI_NAME,
    e.WORKSTEP_CODE                                         AS WORKSTEP,
    e.DECISION_CODE                                         AS DECISION,
    e.EXITDATE,
    a.RETURN_CNT_DATAENTRY                                  AS SL_RETURN_NHAPLIEU,
    a.RETURN_CNT_UNDERWRITING                               AS SL_RETURN_THAMDINH,
    a.RETURN_CNT_APPROVAL                                   AS SL_RETURN_PHEDUYET
FROM       PDTD_DTM.FCT_CLOS_WORKSTEP_EVENT e
JOIN       p ON e.DAYID BETWEEN p.d_from AND p.d_to
            AND e.EXITDATE >= p.d_from
            AND e.EXITDATE <  p.d_to + 1
JOIN       PDTD_DTM.FCT_CLOS_APPLICATION a ON a.WI_NAME = e.WI_NAME AND a.DAYID = p.d_to
WHERE      e.WORKSTEP_CODE IN ('DetailDataEntry','DataInputerChecker','UnderwriterMaker',
                               'UnderwriterChecker','CreditApproval','CreditCommittee')
  AND      e.DECISION_CODE IN ('Send_Back','Send_Back to DDE','Send Back DataInputerChecker',
                               'Send Back to DataInputerChecker','Additional_Doc_Required','Cancel','Reject')
  AND      NOT EXISTS (SELECT 1
                       FROM   PDTD_DTM.FCT_CLOS_WORKSTEP_EVENT nv
                       WHERE  nv.WORKSTEP_EVENT_BK = e.WORKSTEP_EVENT_BK
                         AND  nv.DAYID > e.DAYID
                         AND  nv.DAYID <= p.d_to)
UNION ALL
-- ===== Nhanh RLOS =====
SELECT
    TRUNC(e.EXITDATE)                                       AS PROCESSED_DATE,
    e.WI_NAME,
    e.WORKSTEP_CODE                                         AS WORKSTEP,
    e.DECISION_CODE                                         AS DECISION,
    e.EXITDATE,
    a.RETURN_CNT_DATAENTRY                                  AS SL_RETURN_NHAPLIEU,
    a.RETURN_CNT_UNDERWRITING                               AS SL_RETURN_THAMDINH,
    a.RETURN_CNT_APPROVAL                                   AS SL_RETURN_PHEDUYET
FROM       PDTD_DTM.FCT_RLOS_WORKSTEP_EVENT e
JOIN       p ON e.DAYID BETWEEN p.d_from AND p.d_to
            AND e.EXITDATE >= p.d_from
            AND e.EXITDATE <  p.d_to + 1
JOIN       PDTD_DTM.FCT_RLOS_APPLICATION a ON a.WI_NAME = e.WI_NAME AND a.DAYID = p.d_to
WHERE      e.WORKSTEP_CODE IN ('DetailDataEntry','DataInputerChecker','UnderwriterMaker',
                               'UnderwriterChecker','CreditApproval','CreditCommittee')
  AND      e.DECISION_CODE IN ('Send_Back','Send_Back to DDE','Send Back DataInputerChecker',
                               'Send Back to DataInputerChecker','Additional_Doc_Required','Cancel','Reject')
  AND      NOT EXISTS (SELECT 1
                       FROM   PDTD_DTM.FCT_RLOS_WORKSTEP_EVENT nv
                       WHERE  nv.WORKSTEP_EVENT_BK = e.WORKSTEP_EVENT_BK
                         AND  nv.DAYID > e.DAYID
                         AND  nv.DAYID <= p.d_to)
ORDER BY   WI_NAME, EXITDATE
]');
  END BC8_RETURN;

  /* =====================================================================
     BC9 - Bao cao KPI, phan nguon CLOS (1 dong / ho so)
     Tham so:
       p_date_from     DATE      Tu ngay (PROCESSED_DATE), mac dinh T-1
       p_date_to       DATE      Den ngay (PROCESSED_DATE), mac dinh T-1; ngay du lieu (DAYID) = p_date_to
     Grain: 1 dong / ho so. Doc truc tiep AGG_LOS_KPI_APPLICATION (DATASOURCE = 'CLOS'),
     cac cot VOLUME / POINT / QUY_DOI da tinh san tai LLD, khong tinh lai.
     Pham vi: AGG co DAYID = p_date_to, PROCESSED_DATE trong [p_date_from, p_date_to], ho so da phe duyet /
     tu choi / huy (FCT_CLOS_APPLICATION.APPLICATION_STATUS). Khong loai tai khoan test o phan nay.
     ===================================================================== */
  FUNCTION BC9_CLOS(p_date_from DATE, p_date_to DATE)
    RETURN CLOB SQL_MACRO(TABLE) IS
  BEGIN
    RETURN TO_CLOB(q'[
SELECT
    k.PROCESSED_DATE,
    k.WI_NAME,
    k.VOLUME,
    k.POINT,
    k.QUY_DOI
FROM       PDTD_DTM.AGG_LOS_KPI_APPLICATION k
JOIN       (SELECT TRUNC(p_date_from) AS d_from, TRUNC(p_date_to) AS d_to FROM DUAL) p
           ON k.DAYID = p.d_to
          AND k.PROCESSED_DATE >= p.d_from
          AND k.PROCESSED_DATE <  p.d_to + 1
JOIN       PDTD_DTM.FCT_CLOS_APPLICATION a
           ON a.WI_NAME = k.WI_NAME AND a.DAYID = k.DAYID
          AND a.APPLICATION_STATUS IN ('Approved', 'Rejected', 'Cancelled')
WHERE      k.DATASOURCE = 'CLOS'
ORDER BY   k.WI_NAME
]');
  END BC9_CLOS;

  /* =====================================================================
     BC9 - Bao cao KPI, phan KPI Khoi (1 dong)
     Tham so:
       p_date_to   DATE   Ngay du lieu (DAYID), mac dinh T-1 (TRUNC(SYSDATE) - 1)
     Bang AGG_LOS_KPI_YTD_DAILY luy ke tu 1/1 den DAYID nen chi can p_date_to (khong co p_date_from).
     Doc cac cot luy ke nam (_YTD) cua AGG_LOS_KPI_YTD_DAILY tai DAYID = p_date_to; bang tong hop khong co chieu
     chi nhanh nen KHONG ap dung loc chi nhanh o phan nay (da chap nhan). Cac chi tieu da loai tai khoan test,
     3 don vi VN0010401 / VN0010101 / VN0010002 va chi tinh luong BL / KHCN_HO ngay tai bang tong hop.
     TAT_RLOS = trung binh cong cua TAT trung binh nhom UNSEC va nhom SEC; TY_LE_GN = SLGN * 100 / SLHS.
     ===================================================================== */
  FUNCTION BC9_KPI_KHOI(p_date_from DATE, p_date_to DATE)
    RETURN CLOB SQL_MACRO(TABLE) IS
  BEGIN
    RETURN TO_CLOB(q'[
WITH
p AS (
    SELECT TRUNC(p_date_to) AS data_day FROM DUAL
),
y AS (
    SELECT p.data_day,
           d.SLHS_RLOS_YTD, d.SLGN_RLOS_YTD, d.SLHS_CLOS_YTD, d.SLGN_CLOS_YTD,
           d.QUY_DOI_RLOS_YTD, d.QUY_DOI_CLOS_YTD, d.USER_CNT_YTD,
           d.TAT_RLOS_UNSEC_SUM_HOUR_YTD / NULLIF(d.TAT_RLOS_UNSEC_CASE_CNT_YTD, 0) AS AVG_TAT_UNSEC,
           d.TAT_RLOS_SEC_SUM_HOUR_YTD   / NULLIF(d.TAT_RLOS_SEC_CASE_CNT_YTD, 0)   AS AVG_TAT_SEC,
           d.TAT_CLOS_SUM_HOUR_YTD       / NULLIF(d.TAT_CLOS_CASE_CNT_YTD, 0)       AS AVG_TAT_CLOS
    FROM   p
    JOIN   PDTD_DTM.AGG_LOS_KPI_YTD_DAILY d ON d.DAYID = p.data_day
)
SELECT
    'Ngày ' || TO_CHAR(y.data_day, 'DD') || ' tháng ' || TO_CHAR(y.data_day, 'MM')   AS YEAR_MONTH,
    (y.AVG_TAT_UNSEC + y.AVG_TAT_SEC) / 2                                           AS TAT_RLOS,
    y.AVG_TAT_CLOS                                                                  AS TAT_CLOS,
    ((y.AVG_TAT_UNSEC + y.AVG_TAT_SEC) / 2 + y.AVG_TAT_CLOS) / 2                    AS TAT_TB,
    y.QUY_DOI_RLOS_YTD                                                              AS QUY_DOI_RLOS,
    y.QUY_DOI_CLOS_YTD                                                              AS QUY_DOI_CLOS,
    y.USER_CNT_YTD                                                                  AS NHAN_SU,
    (y.QUY_DOI_RLOS_YTD + y.QUY_DOI_CLOS_YTD) / NULLIF(y.USER_CNT_YTD, 0)           AS NSLD,
    y.SLHS_RLOS_YTD                                                                 AS SLHS_RLOS,
    y.SLGN_RLOS_YTD                                                                 AS SLGN_RLOS,
    y.SLGN_RLOS_YTD * 100 / NULLIF(y.SLHS_RLOS_YTD, 0)                              AS TY_LE_GN_RLOS,
    y.SLHS_CLOS_YTD                                                                 AS SLHS_CLOS,
    y.SLGN_CLOS_YTD                                                                 AS SLGN_CLOS,
    y.SLGN_CLOS_YTD * 100 / NULLIF(y.SLHS_CLOS_YTD, 0)                              AS TY_LE_GN_CLOS,
    y.SLHS_RLOS_YTD + y.SLHS_CLOS_YTD                                               AS SLHS_TONG,
    y.SLGN_RLOS_YTD + y.SLGN_CLOS_YTD                                               AS SLGN_TONG,
    (y.SLGN_RLOS_YTD + y.SLGN_CLOS_YTD) * 100
        / NULLIF(y.SLHS_RLOS_YTD + y.SLHS_CLOS_YTD, 0)                              AS TY_LE_GN_TONG
FROM   y
]');
  END BC9_KPI_KHOI;

  /* =====================================================================
     BC9 - Bao cao KPI, phan nguon RLOS (1 dong / ho so)
     Tham so:
       p_date_from     DATE      Tu ngay (PROCESSED_DATE), mac dinh T-1
       p_date_to       DATE      Den ngay (PROCESSED_DATE), mac dinh T-1; ngay du lieu (DAYID) = p_date_to
     Grain: 1 dong / ho so. Doc truc tiep AGG_LOS_KPI_APPLICATION (DATASOURCE = 'RLOS'),
     cac cot VOLUME / POINT / QUY_DOI / TSBD_G2 / INCOM_3 / BUSINESS_INCOM / DEVIATION_G2 / DEVIATION_G3 da tinh san tai LLD, khong tinh lai.
     Pham vi: AGG co DAYID = p_date_to, PROCESSED_DATE trong [p_date_from, p_date_to], ho so da phe duyet /
     tu choi / huy (FCT_RLOS_APPLICATION.APPLICATION_STATUS). Khong loai tai khoan test o phan nay.
     ===================================================================== */
  FUNCTION BC9_RLOS(p_date_from DATE, p_date_to DATE)
    RETURN CLOB SQL_MACRO(TABLE) IS
  BEGIN
    RETURN TO_CLOB(q'[
SELECT
    k.PROCESSED_DATE,
    k.WI_NAME,
    k.VOLUME,
    k.POINT,
    k.QUY_DOI,
    k.TSBD_G2,
    k.INCOM_3,
    k.BUSINESS_INCOM,
    k.DEVIATION_G2,
    k.DEVIATION_G3
FROM       PDTD_DTM.AGG_LOS_KPI_APPLICATION k
JOIN       (SELECT TRUNC(p_date_from) AS d_from, TRUNC(p_date_to) AS d_to FROM DUAL) p
           ON k.DAYID = p.d_to
          AND k.PROCESSED_DATE >= p.d_from
          AND k.PROCESSED_DATE <  p.d_to + 1
JOIN       PDTD_DTM.FCT_RLOS_APPLICATION a
           ON a.WI_NAME = k.WI_NAME AND a.DAYID = k.DAYID
          AND a.APPLICATION_STATUS IN ('Approved', 'Rejected', 'Cancelled')
WHERE      k.DATASOURCE = 'RLOS'
ORDER BY   k.WI_NAME
]');
  END BC9_RLOS;

  /* =====================================================================
     BC10 - Bao cao Giai ngan / Qua han KHCN
     Tham so:
       p_date_from     DATE      Tu ngay (VALUE_DATE = ngay giai ngan), mac dinh T-1
       p_date_to       DATE      Den ngay (VALUE_DATE = ngay giai ngan), mac dinh T-1; ngay du lieu cua bang snapshot (DAYID) = p_date_to
     Grain: 1 dong / hop dong (FCT_RLOS_LOAN_DISBURSEMENT, PK DAYID + T24_CONTRACT), snapshot theo DAYID;
     loc DAYID = p_date_to (trang thai hop dong tai ngay den: CUR_BALANCE, NO_DAYS_OVERDUE, CUR_BUCKET) va
     DIM_T24_LOAN.VALUE_DATE trong [p_date_from, p_date_to]; cot DAYID luon = p_date_to.
     Loc khach hang SEAB_CU_SEGMENT IN ('14','21') da ap dung tai ETL fact (LLD), khong loc lai.
     ZONE, DISBURSEMENT_AMT, CUR_BALANCE, NO_DAYS_OVERDUE, CUR_BUCKET, APPROVAL_DATE da tinh san tai LLD.
     ===================================================================== */
  FUNCTION BC10_RLOS_DISBURSEMENT(p_date_from DATE, p_date_to DATE)
    RETURN CLOB SQL_MACRO(TABLE) IS
  BEGIN
    RETURN TO_CLOB(q'[
SELECT
    f.DAYID,
    f.T24_CUSTOMER_CODE                                     AS CUSTOMER_ID,
    cu.SHORT_NAME,
    co.BRANCH_NAME,
    co.COMPANY_NAME_VN                                      AS COMPANY_NAME,
    f.ZONE,
    f.T24_CONTRACT                                          AS CONTRACT,
    ln.VALUE_DATE,
    ln.MATURITY_DATE,
    ln.REC_STATUS                                           AS STATUS,
    f.DISBURSEMENT_AMT                                      AS DISBURSEMENT_AMT_T24,
    f.CUR_BALANCE,
    f.NO_DAYS_OVERDUE,
    f.CUR_BUCKET,
    pr.SEAB_PRODUCTS_DE_NAME                                AS PRODUCT_T24,
    f.SEAB_LOS_ID,
    f.APPROVAL_DATE,
    ln.CONTRACT_REF,
    ln.REF_VALUE_DATE
FROM       PDTD_DTM.FCT_RLOS_LOAN_DISBURSEMENT f
LEFT JOIN  PDTD_DTM.DIM_T24_CUSTOMER          cu ON cu.DIMENSION_KEY = f.T24_CUSTOMER_SK
LEFT JOIN  PDTD_DTM.DIM_T24_COMPANY           co ON co.DIMENSION_KEY = f.T24_COMPANY_SK
LEFT JOIN  PDTD_DTM.DIM_T24_LOAN              ln ON ln.DIMENSION_KEY = f.T24_CONTRACT_SK
LEFT JOIN  PDTD_DTM.DIM_T24_SEAB_PRODUCTS_DE  pr ON pr.DIMENSION_KEY = f.T24_SEAB_PRODUCTS_DE_SK
WHERE      f.DAYID        =  TRUNC(p_date_to)
  AND      ln.VALUE_DATE  >= TRUNC(p_date_from)
  AND      ln.VALUE_DATE  <  TRUNC(p_date_to) + 1
ORDER BY   f.T24_CONTRACT
]');
  END BC10_RLOS_DISBURSEMENT;

  /* =====================================================================
     BC11 - Bao cao Giai ngan / Qua han KHDN
     Tham so:
       p_date_from     DATE      Tu ngay (VALUE_DATE = ngay giai ngan), mac dinh T-1
       p_date_to       DATE      Den ngay (VALUE_DATE = ngay giai ngan), mac dinh T-1; ngay du lieu cua bang snapshot (DAYID) = p_date_to
     Grain: 1 dong / hop dong (FCT_CLOS_LOAN_DISBURSEMENT, PK DAYID + T24_CONTRACT), snapshot theo DAYID;
     loc DAYID = p_date_to (trang thai hop dong tai ngay den: CUR_BALANCE, NO_DAYS_OVERDUE, CUR_BUCKET) va
     DIM_T24_LOAN.VALUE_DATE trong [p_date_from, p_date_to]; cot DAYID luon = p_date_to.
     Loc khach hang SEAB_CU_SEGMENT NOT IN ('14','21') da ap dung tai ETL fact (LLD), khong loc lai.
     ZONE, CUST_GROUP, DISBURSEMENT_AMT, CUR_BALANCE, NO_DAYS_OVERDUE, CUR_BUCKET, LIMIT_REFERENCE,
     LOANCASEID, APPROVAL_WINAME_LOS, APPROVAL_DATE da tinh san tai LLD.
     ===================================================================== */
  FUNCTION BC11_CLOS_DISBURSEMENT(p_date_from DATE, p_date_to DATE)
    RETURN CLOB SQL_MACRO(TABLE) IS
  BEGIN
    RETURN TO_CLOB(q'[
SELECT
    f.DAYID,
    f.T24_CUSTOMER_CODE                                     AS CUSTOMER_ID,
    cu.SHORT_NAME,
    f.CUST_GROUP,
    co.BRANCH_NAME,
    co.COMPANY_NAME_VN                                      AS COMPANY_NAME,
    f.ZONE,
    f.T24_CONTRACT                                          AS CONTRACT,
    ln.VALUE_DATE,
    ln.MATURITY_DATE,
    ln.REC_STATUS                                           AS STATUS,
    f.DISBURSEMENT_AMT                                      AS DISBURSEMENT_AMT_T24,
    f.CUR_BALANCE,
    f.NO_DAYS_OVERDUE,
    f.CUR_BUCKET,
    pr.SEAB_PRODUCTS_DE_NAME                                AS PRODUCT_T24,
    f.SEAB_LOS_ID,
    ln.CONTRACT_REF,
    ln.REF_VALUE_DATE,
    f.LIMIT_REFERENCE,
    f.LOANCASEID,
    f.APPROVAL_WINAME_LOS,
    f.APPROVAL_DATE
FROM       PDTD_DTM.FCT_CLOS_LOAN_DISBURSEMENT f
LEFT JOIN  PDTD_DTM.DIM_T24_CUSTOMER          cu ON cu.DIMENSION_KEY = f.T24_CUSTOMER_SK
LEFT JOIN  PDTD_DTM.DIM_T24_COMPANY           co ON co.DIMENSION_KEY = f.T24_COMPANY_SK
LEFT JOIN  PDTD_DTM.DIM_T24_LOAN              ln ON ln.DIMENSION_KEY = f.T24_CONTRACT_SK
LEFT JOIN  PDTD_DTM.DIM_T24_SEAB_PRODUCTS_DE  pr ON pr.DIMENSION_KEY = f.T24_SEAB_PRODUCTS_DE_SK
WHERE      f.DAYID        =  TRUNC(p_date_to)
  AND      ln.VALUE_DATE  >= TRUNC(p_date_from)
  AND      ln.VALUE_DATE  <  TRUNC(p_date_to) + 1
ORDER BY   f.T24_CONTRACT
]');
  END BC11_CLOS_DISBURSEMENT;

END PKG_REPORT;
/
