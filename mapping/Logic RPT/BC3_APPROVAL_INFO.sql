/* BC3 - Bao cao Thong tin phe duyet (CLOS + RLOS) */
SELECT *
FROM   PDTD_DTM.PKG_REPORT.BC3_APPROVAL_INFO(
           TO_DATE(SUBSTR('@{p_date_from}{2026-11-26}', 1, 10), 'YYYY-MM-DD'),
           TO_DATE(SUBSTR('@{p_date_to}{2026-11-26}',   1, 10), 'YYYY-MM-DD'))
ORDER BY SYSTEMNAME, WINAME, ENTRYDATE, DESCRIPTION
