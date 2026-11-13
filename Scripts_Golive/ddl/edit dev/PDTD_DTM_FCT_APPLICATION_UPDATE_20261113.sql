-- ============================================================
-- PDTD_DTM_FCT_APPLICATION_UPDATE_20261113.sql
-- UPDATE DDL tren DEV cho PDTD_DTM.FCT_CLOS_APPLICATION va FCT_RLOS_APPLICATION (13/11/2026):
--   them 3 cot dem luy ke phuc vu BC8 (SL_RETURN_*), cong don mau C:
--     RETURN_CNT_DATAENTRY     so lan return tai Nhap lieu    (BC8.SL_RETURN_NHAPLIEU)
--     RETURN_CNT_UNDERWRITING  so lan return tai Tham dinh    (BC8.SL_RETURN_THAMDINH)
--     RETURN_CNT_APPROVAL      so lan return tai Phe duyet    (BC8.SL_RETURN_PHEDUYET)
--   Gia tri = NVL(PREV, 0) + so su kien return phat sinh lan dau trong lat cat ngay batch (xem LLD).
--   Ho so da co truoc ngay go-live: cot NULL den khi nap lich su (ETL dung NVL(...,0)).
-- ============================================================

ALTER TABLE PDTD_DTM.FCT_CLOS_APPLICATION ADD (
    RETURN_CNT_DATAENTRY          NUMBER(5),
    RETURN_CNT_UNDERWRITING       NUMBER(5),
    RETURN_CNT_APPROVAL           NUMBER(5)
);

ALTER TABLE PDTD_DTM.FCT_RLOS_APPLICATION ADD (
    RETURN_CNT_DATAENTRY          NUMBER(5),
    RETURN_CNT_UNDERWRITING       NUMBER(5),
    RETURN_CNT_APPROVAL           NUMBER(5)
);
