-- ============================================================
-- PDTD_DTM_AGG_LOS_KPI_APPLICATION_UPDATE_20261116.sql
-- UPDATE DDL tren DEV cho PDTD_DTM.AGG_LOS_KPI_APPLICATION (16/11/2026):
--   them cot FIRST_DISBURSED_DATE (DATE, NULL) - ngay du lieu dau tien he thong ghi nhan ho so co hop dong
--   giai ngan tren T24 (STG_FCT_LOAN / STG_FCT_MD). Mau A first-only, carry-forward qua bang PREV
--   (COALESCE(p.FIRST_DISBURSED_DATE, CASE WHEN co hop dong THEN v_batch_date END)).
--   Phuc vu SLGN_RLOS / SLGN_CLOS cua AGG_LOS_KPI_YTD_DAILY (xem LLD).
--   Cot nay duoc them o CUOI bang (sau TIME_UPDATE) de CREATE va ALTER cho cung thu tu cot.
-- ============================================================

ALTER TABLE PDTD_DTM.AGG_LOS_KPI_APPLICATION ADD (
    FIRST_DISBURSED_DATE          DATE
);
