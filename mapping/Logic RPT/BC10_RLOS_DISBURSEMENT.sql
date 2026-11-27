/* BC10 - Bao cao Giai ngan / Qua han KHCN */
SELECT *
FROM   PDTD_DTM.PKG_REPORT.BC10_RLOS_DISBURSEMENT(
           TO_DATE(SUBSTR('@{p_date_from}{2026-11-26}', 1, 10), 'YYYY-MM-DD'),
           TO_DATE(SUBSTR('@{p_date_to}{2026-11-26}',   1, 10), 'YYYY-MM-DD'))
ORDER BY CONTRACT
