/* =====================================================================
   BC6 - Bao cao NGOAI LE CLOS (PDTD_DTM, Oracle 19c)
   Nguon thiet ke: extract/srs_report/BC6.md (muc "Nguon CLOS") + lld/pdtd_dtm/* (skill gen-report)
   Tham so:
     :p_report_date   DATE      Ngay bao cao (PROCESSED_DATE), mac dinh T-1
     :p_branch_code   VARCHAR2  Ma chi nhanh, NULL = tat ca chi nhanh
   Grain: 1 dong / dong ngoai le (FCT_CLOS_DEVIATION), khong gop.
   Pham vi: dong ngoai le co DAYID = ngay bao cao va PROCESSED_DATE trong ngay bao cao
   (PROCESSED_DATE tinh san tai SB_DWH theo 3 muc uu tien cua SRS). Loc chi nhanh qua
   FCT_CLOS_APPLICATION.COMPANY_SK tai cung DAYID.
   BC6 CLOS va BC6 RLOS co bo cot khac nhau nen la 2 cau lenh rieng.
   ===================================================================== */
SELECT
    d.WI_NAME,
    d.DEVIATION_TYPE_CODE                                   AS DEVIATION_TYPE,
    d.DEV_PROPOSAL,
    d.PROCESSED_DATE
FROM       PDTD_DTM.FCT_CLOS_DEVIATION d
JOIN       (SELECT TRUNC(:p_report_date) AS rpt_date FROM DUAL) p
           ON d.DAYID = p.rpt_date
          AND d.PROCESSED_DATE >= p.rpt_date
          AND d.PROCESSED_DATE <  p.rpt_date + 1
LEFT JOIN  PDTD_DTM.FCT_CLOS_APPLICATION a  ON a.WI_NAME = d.WI_NAME AND a.DAYID = d.DAYID
LEFT JOIN  PDTD_DTM.DIM_LOS_COMPANY     co ON co.DIMENSION_KEY = a.COMPANY_SK
WHERE      (:p_branch_code IS NULL OR co.BRANCH_CODE = :p_branch_code)
ORDER BY   d.WI_NAME, d.DEVIATION_BK;
