/* =====================================================================
   BC10 - Bao cao Giai ngan / Qua han KHCN (PDTD_DTM, Oracle 19c)
   Nguon thiet ke: extract/srs_report/BC10.md + lld/pdtd_dtm/* (skill gen-report)
   Tham so:
     :p_report_date   DATE      Ngay bao cao (DAYID), mac dinh T-1
     :p_branch_code   VARCHAR2  Ma chi nhanh (T24), NULL = tat ca chi nhanh
   Grain: 1 dong / hop dong (FCT_RLOS_LOAN_DISBURSEMENT, PK DAYID + T24_CONTRACT), snapshot theo DAYID.
   Loc khach hang SEAB_CU_SEGMENT IN ('14','21') da ap dung tai ETL fact (LLD), khong loc lai.
   ZONE, DISBURSEMENT_AMT, CUR_BALANCE, NO_DAYS_OVERDUE, CUR_BUCKET, APPROVAL_DATE da tinh san tai LLD.
   Loc chi nhanh qua DIM_T24_COMPANY.BRANCH_CODE.
   ===================================================================== */
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
JOIN       (SELECT TRUNC(:p_report_date) AS rpt_date FROM DUAL) p ON f.DAYID = p.rpt_date
LEFT JOIN  PDTD_DTM.DIM_T24_CUSTOMER          cu ON cu.DIMENSION_KEY = f.T24_CUSTOMER_SK
LEFT JOIN  PDTD_DTM.DIM_T24_COMPANY           co ON co.DIMENSION_KEY = f.T24_COMPANY_SK
LEFT JOIN  PDTD_DTM.DIM_T24_LOAN              ln ON ln.DIMENSION_KEY = f.T24_CONTRACT_SK
LEFT JOIN  PDTD_DTM.DIM_T24_SEAB_PRODUCTS_DE  pr ON pr.DIMENSION_KEY = f.T24_SEAB_PRODUCTS_DE_SK
WHERE      (:p_branch_code IS NULL OR co.BRANCH_CODE = :p_branch_code)
ORDER BY   f.T24_CONTRACT;
