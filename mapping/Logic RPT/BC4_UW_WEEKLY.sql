/* BC4 - Bao cao Tuan Chuyen vien Tham dinh (CLOS + RLOS) */
SELECT *
FROM   PDTD_DTM.PKG_REPORT.BC4_UW_WEEKLY(
           TO_DATE(SUBSTR('@{p_date_from}{2026-11-26}', 1, 10), 'YYYY-MM-DD'),
           TO_DATE(SUBSTR('@{p_date_to}{2026-11-26}',   1, 10), 'YYYY-MM-DD'))
ORDER BY SYSTEMNAME, WINAME
