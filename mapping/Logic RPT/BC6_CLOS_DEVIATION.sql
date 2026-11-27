/* BC6 - Bao cao NGOAI LE CLOS */
SELECT *
FROM   PDTD_DTM.PKG_REPORT.BC6_CLOS_DEVIATION(
           TO_DATE(SUBSTR('@{p_date_from}{2026-11-26}', 1, 10), 'YYYY-MM-DD'),
           TO_DATE(SUBSTR('@{p_date_to}{2026-11-26}',   1, 10), 'YYYY-MM-DD'))
ORDER BY WI_NAME
