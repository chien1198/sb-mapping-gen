/* =====================================================================
   BC6 - Bao cao NGOAI LE RLOS (PDTD_DTM, Oracle 19c)
   Nguon thiet ke: extract/srs_report/BC6.md (muc "Nguon RLOS") + lld/pdtd_dtm/* (skill gen-report)
   Tham so:
     :p_report_date   DATE      Ngay bao cao (PROCESSED_DATE), mac dinh T-1
     :p_branch_code   VARCHAR2  Ma chi nhanh, NULL = tat ca chi nhanh
   Grain: 1 dong / dong ngoai le (FCT_RLOS_DEVIATION), khong gop.
   Pham vi: dong ngoai le co DAYID = ngay bao cao va PROCESSED_DATE trong ngay bao cao
   (PROCESSED_DATE tinh san tai SB_DWH theo 3 muc uu tien cua SRS). Loc chi nhanh qua
   FCT_RLOS_APPLICATION.COMPANY_SK tai cung DAYID.
   BC6 RLOS va BC6 CLOS co bo cot khac nhau nen la 2 cau lenh rieng.
   ===================================================================== */
SELECT
    d.WI_NAME,
    d.CHECKING_RESULT,
    d.CHECKING_CONDITION,
    d.DEVIATION_REASON                                      AS REASON,
    d.PROCESSED_DATE
FROM       PDTD_DTM.FCT_RLOS_DEVIATION d
JOIN       (SELECT TRUNC(:p_report_date) AS rpt_date FROM DUAL) p
           ON d.DAYID = p.rpt_date
          AND d.PROCESSED_DATE >= p.rpt_date
          AND d.PROCESSED_DATE <  p.rpt_date + 1
LEFT JOIN  PDTD_DTM.FCT_RLOS_APPLICATION a  ON a.WI_NAME = d.WI_NAME AND a.DAYID = d.DAYID
LEFT JOIN  PDTD_DTM.DIM_LOS_COMPANY     co ON co.DIMENSION_KEY = a.COMPANY_SK
WHERE      (:p_branch_code IS NULL OR co.BRANCH_CODE = :p_branch_code)
ORDER BY   d.WI_NAME, d.DEVIATION_BK;
