/* BC9 - Bao cao KPI, phan KPI Khoi (1 dong) */
SELECT *
FROM   PDTD_DTM.PKG_REPORT.BC9_KPI_KHOI(
           TO_DATE(SUBSTR('@{p_date_from}{2026-11-26}', 1, 10), 'YYYY-MM-DD'),
           TO_DATE(SUBSTR('@{p_date_to}{2026-11-26}',   1, 10), 'YYYY-MM-DD'))
