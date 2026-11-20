/* =====================================================================
   BC9 - Bao cao KPI, phan nguon CLOS (1 dong / ho so; PDTD_DTM, Oracle 19c)
   Nguon thiet ke: extract/srs_report/BC9.md (muc "Nguon CLOS") + lld/pdtd_dtm/* (skill gen-report)
   Tham so:
     :p_date_from     DATE      Tu ngay (PROCESSED_DATE), mac dinh T-1
     :p_date_to       DATE      Den ngay (PROCESSED_DATE), mac dinh T-1; ngay du lieu (DAYID) = :p_date_to
   Grain: 1 dong / ho so. Doc truc tiep AGG_LOS_KPI_APPLICATION (DATASOURCE = 'CLOS'),
   cac cot VOLUME / POINT / QUY_DOI da tinh san tai LLD, khong tinh lai.
   Pham vi: AGG co DAYID = :p_date_to, PROCESSED_DATE trong [:p_date_from, :p_date_to], ho so da phe duyet /
   tu choi / huy (FCT_CLOS_APPLICATION.APPLICATION_STATUS). Khong loai tai khoan test o phan nay.
   ===================================================================== */
SELECT
    k.PROCESSED_DATE,
    k.WI_NAME,
    k.VOLUME,
    k.POINT,
    k.QUY_DOI
FROM       PDTD_DTM.AGG_LOS_KPI_APPLICATION k
JOIN       (SELECT TRUNC(:p_date_from) AS d_from, TRUNC(:p_date_to) AS d_to FROM DUAL) p
           ON k.DAYID = p.d_to
          AND k.PROCESSED_DATE >= p.d_from
          AND k.PROCESSED_DATE <  p.d_to + 1
JOIN       PDTD_DTM.FCT_CLOS_APPLICATION a
           ON a.WI_NAME = k.WI_NAME AND a.DAYID = k.DAYID
          AND a.APPLICATION_STATUS IN ('Approved', 'Rejected', 'Cancelled')
WHERE      k.DATASOURCE = 'CLOS'
ORDER BY   k.WI_NAME;
