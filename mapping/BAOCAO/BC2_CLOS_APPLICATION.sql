/* =====================================================================
   BC2 - Bao cao CLOS APPLICATION (PDTD_DTM, Oracle 19c)
   Nguon thiet ke: extract/srs_report/BC2.md + lld/pdtd_dtm/* (skill gen-report)
   Tham so:
     :p_date_from     DATE      Tu ngay (PROCESSED_DATE), mac dinh T-1 (TRUNC(SYSDATE) - 1)
     :p_date_to       DATE      Den ngay (PROCESSED_DATE), mac dinh T-1; ngay du lieu (DAYID) = :p_date_to
   Grain: 1 dong / (ho so x ngoai le). Ho so khong co ngoai le van ra 1 dong (LEFT JOIN).
     - DEV_PROPOSAL (FCT_CLOS_DEVIATION) len nhieu dong, khong gop.
     - 9 co TSDB_* gop theo ho so (MAX), 1 dong / ho so.
   FCT_CLOS_APPLICATION la full snapshot lich su theo DAYID -> loc DAYID = :p_date_to (trang thai ho so
   tai ngay den) va PROCESSED_DATE trong [:p_date_from, :p_date_to] (cung mau BC1).
   ===================================================================== */
WITH
p AS (
    SELECT TRUNC(:p_date_from) AS d_from,
           TRUNC(:p_date_to)   AS d_to
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
ORDER BY   a.WI_NAME, dev.DEVIATION_BK;
