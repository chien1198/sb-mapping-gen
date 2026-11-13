/* =====================================================================
   BC9 - Bao cao KPI, phan nguon RLOS (1 dong / ho so; PDTD_DTM, Oracle 19c)
   Nguon thiet ke: extract/srs_report/BC9.md (muc "Nguon RLOS") + lld/pdtd_dtm/* (skill gen-report)
   Tham so:
     :p_report_date   DATE      Ngay bao cao (PROCESSED_DATE), mac dinh T-1
     :p_branch_code   VARCHAR2  Ma chi nhanh, NULL = tat ca chi nhanh
   Grain: 1 dong / ho so. Doc truc tiep AGG_LOS_KPI_APPLICATION (DATASOURCE = 'RLOS'),
   cac cot VOLUME / POINT / QUY_DOI / TSBD_G2 / INCOM_3 / BUSINESS_INCOM / DEVIATION_G2 / DEVIATION_G3 da tinh san tai LLD, khong tinh lai.
   Pham vi: AGG co DAYID = ngay bao cao, PROCESSED_DATE trong ngay bao cao, ho so da phe duyet /
   tu choi / huy (FCT_RLOS_APPLICATION.APPLICATION_STATUS). Khong loai tai khoan test o phan nay.
   Loc chi nhanh qua FCT_RLOS_APPLICATION.COMPANY_SK.
   ===================================================================== */
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
JOIN       (SELECT TRUNC(:p_report_date) AS rpt_date FROM DUAL) p
           ON k.DAYID = p.rpt_date
          AND k.PROCESSED_DATE >= p.rpt_date
          AND k.PROCESSED_DATE <  p.rpt_date + 1
JOIN       PDTD_DTM.FCT_RLOS_APPLICATION a
           ON a.WI_NAME = k.WI_NAME AND a.DAYID = k.DAYID
          AND a.APPLICATION_STATUS IN ('Approved', 'Rejected', 'Cancelled')
LEFT JOIN  PDTD_DTM.DIM_LOS_COMPANY co ON co.DIMENSION_KEY = a.COMPANY_SK
WHERE      k.DATASOURCE = 'RLOS'
  AND      (:p_branch_code IS NULL OR co.BRANCH_CODE = :p_branch_code)
ORDER BY   k.WI_NAME;
