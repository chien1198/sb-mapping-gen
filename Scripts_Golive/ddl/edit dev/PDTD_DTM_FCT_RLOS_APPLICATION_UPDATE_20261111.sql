-- ============================================================
-- PDTD_DTM_FCT_RLOS_APPLICATION_UPDATE_20261111.sql
-- UPDATE DDL tren DEV cho bang PDTD_DTM.FCT_RLOS_APPLICATION (11/11/2026):
--   them cot BS_OPEN_ENTRYDATE
--     ENTRYDATE cua luot BranchSupport moi nhat chua xu ly
--     (EXITDATE va DECISION_CODE deu NULL); cot carry-forward trung gian
--     phuc vu tinh AUTO_CANCEL_DATE, khong dua len bao cao.
-- ============================================================

ALTER TABLE PDTD_DTM.FCT_RLOS_APPLICATION ADD (
    BS_OPEN_ENTRYDATE             TIMESTAMP
);
