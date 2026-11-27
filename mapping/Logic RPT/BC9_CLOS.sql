/* BC9 - Bao cao KPI, phan nguon CLOS (1 dong / ho so) */
SELECT *
FROM   PDTD_DTM.PKG_REPORT.BC9_CLOS(
           TO_DATE(SUBSTR('@{p_date_from}{2026-11-26}', 1, 10), 'YYYY-MM-DD'),
           TO_DATE(SUBSTR('@{p_date_to}{2026-11-26}',   1, 10), 'YYYY-MM-DD'))
ORDER BY WI_NAME
