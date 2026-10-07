-- ============================================================
-- PDTD_DTM_AGG_LOS_KPI_USER_YEAR.sql
-- ============================================================
-- ===========================================================================
-- NOTE - CAN CHECK LAI: bang KHONG co cot DAYID -> KHONG partition duoc
--
-- PK hien tai : (USER_YEAR_BK)
-- Khac biet   : 18 bang FCT_/AGG_ con lai deu partition RANGE (DAYID)
--               INTERVAL 1 DAY va PK dung USING INDEX LOCAL. Bang nay
--               khong co DAYID nen de bang thuong, PK dung USING INDEX.
--
-- Can xac nhan: bang la registry luy ke theo nam (1 dong = 1 user x 1 nam),
--               khong phai anh chup theo ngay - dung la khong can DAYID?
--               Neu dung thi co nen doi tien to AGG_ -> REF_ cho dung ban chat?
-- ===========================================================================
-- DROP TABLE PDTD_DTM.AGG_LOS_KPI_USER_YEAR
CREATE TABLE PDTD_DTM.AGG_LOS_KPI_USER_YEAR (
    USER_YEAR_BK                  VARCHAR2(64)        NOT NULL,
    KPI_YEAR                      NUMBER(4)           NOT NULL,
    USERNAME                      VARCHAR2(100)       NOT NULL,
    FIRST_ELIGIBLE_TS             TIMESTAMP           NOT NULL,

	CONSTRAINT AGG_LOS_KPI_USER_YEAR_PK PRIMARY KEY (USER_YEAR_BK) USING INDEX
);

COMMIT;
