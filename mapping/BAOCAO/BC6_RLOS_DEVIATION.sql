/* =====================================================================
   BC6 - Bao cao NGOAI LE RLOS (PDTD_DTM, Oracle 19c)
   Nguon thiet ke: extract/srs_report/BC6.md (muc "Nguon RLOS") + lld/pdtd_dtm/* (skill gen-report)
   Tham so:
     :p_date_from     DATE      Tu ngay (PROCESSED_DATE), mac dinh T-1
     :p_date_to       DATE      Den ngay (PROCESSED_DATE), mac dinh T-1; ngay du lieu (DAYID) = :p_date_to
   Grain: 1 dong / dong ngoai le (FCT_RLOS_DEVIATION), khong gop.
   Pham vi: dong ngoai le co DAYID = :p_date_to (snapshot lich su) va PROCESSED_DATE trong
   [:p_date_from, :p_date_to]
   (PROCESSED_DATE tinh san tai SB_DWH theo 3 muc uu tien cua SRS).
   BC6 RLOS va BC6 CLOS co bo cot khac nhau nen la 2 cau lenh rieng.
   ===================================================================== */
SELECT
    d.WI_NAME,
    d.CHECKING_RESULT,
    d.CHECKING_CONDITION,
    d.DEVIATION_REASON                                      AS REASON,
    d.PROCESSED_DATE
FROM       PDTD_DTM.FCT_RLOS_DEVIATION d
JOIN       (SELECT TRUNC(:p_date_from) AS d_from, TRUNC(:p_date_to) AS d_to FROM DUAL) p
           ON d.DAYID = p.d_to
          AND d.PROCESSED_DATE >= p.d_from
          AND d.PROCESSED_DATE <  p.d_to + 1
ORDER BY   d.WI_NAME, d.DEVIATION_BK;
