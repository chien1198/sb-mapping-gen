-- ============================================================
-- PDTD_DTM_AGG_LOS_KPI_YTD_DAILY.sql
-- ============================================================
-- ===========================================================================
-- NOTE - CAN CHECK LAI: PK chi co DAYID
--
-- PK hien tai : (DAYID)
-- Mau chuan   : (<bang>_BK, DAYID)
--
-- Can xac nhan: grain la 1 dong/1 ngay cho toan khoi (RLOS va CLOS la cac
--               nhom cot song song tren cung 1 dong) nen DAYID du lam PK.
--               Dung la khong tach dong theo he/don vi?
-- ===========================================================================
-- DROP TABLE PDTD_DTM.AGG_LOS_KPI_YTD_DAILY
CREATE TABLE PDTD_DTM.AGG_LOS_KPI_YTD_DAILY (
    DAYID                         DATE                NOT NULL,
    SLHS_RLOS                     NUMBER(12)          ,
    SLHS_RLOS_WTD                 NUMBER(14)          ,
    SLHS_RLOS_MTD                 NUMBER(14)          ,
    SLHS_RLOS_QTD                 NUMBER(14)          ,
    SLHS_RLOS_YTD                 NUMBER(14)          ,
    SLGN_RLOS                     NUMBER(12)          ,
    SLGN_RLOS_WTD                 NUMBER(14)          ,
    SLGN_RLOS_MTD                 NUMBER(14)          ,
    SLGN_RLOS_QTD                 NUMBER(14)          ,
    SLGN_RLOS_YTD                 NUMBER(14)          ,
    SLHS_CLOS                     NUMBER(12)          ,
    SLHS_CLOS_WTD                 NUMBER(14)          ,
    SLHS_CLOS_MTD                 NUMBER(14)          ,
    SLHS_CLOS_QTD                 NUMBER(14)          ,
    SLHS_CLOS_YTD                 NUMBER(14)          ,
    SLGN_CLOS                     NUMBER(12)          ,
    SLGN_CLOS_WTD                 NUMBER(14)          ,
    SLGN_CLOS_MTD                 NUMBER(14)          ,
    SLGN_CLOS_QTD                 NUMBER(14)          ,
    SLGN_CLOS_YTD                 NUMBER(14)          ,
    TAT_RLOS_SEC_SUM_HOUR         NUMBER(18,6)        ,
    TAT_RLOS_SEC_SUM_HOUR_WTD     NUMBER(20,6)        ,
    TAT_RLOS_SEC_SUM_HOUR_MTD     NUMBER(20,6)        ,
    TAT_RLOS_SEC_SUM_HOUR_QTD     NUMBER(20,6)        ,
    TAT_RLOS_SEC_SUM_HOUR_YTD     NUMBER(20,6)        ,
    TAT_RLOS_SEC_CASE_CNT         NUMBER(12)          ,
    TAT_RLOS_SEC_CASE_CNT_WTD     NUMBER(14)          ,
    TAT_RLOS_SEC_CASE_CNT_MTD     NUMBER(14)          ,
    TAT_RLOS_SEC_CASE_CNT_QTD     NUMBER(14)          ,
    TAT_RLOS_SEC_CASE_CNT_YTD     NUMBER(14)          ,
    TAT_RLOS_UNSEC_SUM_HOUR       NUMBER(18,6)        ,
    TAT_RLOS_UNSEC_SUM_HOUR_WTD   NUMBER(20,6)        ,
    TAT_RLOS_UNSEC_SUM_HOUR_MTD   NUMBER(20,6)        ,
    TAT_RLOS_UNSEC_SUM_HOUR_QTD   NUMBER(20,6)        ,
    TAT_RLOS_UNSEC_SUM_HOUR_YTD   NUMBER(20,6)        ,
    TAT_RLOS_UNSEC_CASE_CNT       NUMBER(12)          ,
    TAT_RLOS_UNSEC_CASE_CNT_WTD   NUMBER(14)          ,
    TAT_RLOS_UNSEC_CASE_CNT_MTD   NUMBER(14)          ,
    TAT_RLOS_UNSEC_CASE_CNT_QTD   NUMBER(14)          ,
    TAT_RLOS_UNSEC_CASE_CNT_YTD   NUMBER(14)          ,
    TAT_CLOS_SUM_HOUR             NUMBER(18,6)        ,
    TAT_CLOS_SUM_HOUR_WTD         NUMBER(20,6)        ,
    TAT_CLOS_SUM_HOUR_MTD         NUMBER(20,6)        ,
    TAT_CLOS_SUM_HOUR_QTD         NUMBER(20,6)        ,
    TAT_CLOS_SUM_HOUR_YTD         NUMBER(20,6)        ,
    TAT_CLOS_CASE_CNT             NUMBER(12)          ,
    TAT_CLOS_CASE_CNT_WTD         NUMBER(14)          ,
    TAT_CLOS_CASE_CNT_MTD         NUMBER(14)          ,
    TAT_CLOS_CASE_CNT_QTD         NUMBER(14)          ,
    TAT_CLOS_CASE_CNT_YTD         NUMBER(14)          ,
    QUY_DOI_RLOS                  NUMBER(14,4)        ,
    QUY_DOI_RLOS_WTD              NUMBER(16,4)        ,
    QUY_DOI_RLOS_MTD              NUMBER(16,4)        ,
    QUY_DOI_RLOS_QTD              NUMBER(16,4)        ,
    QUY_DOI_RLOS_YTD              NUMBER(16,4)        ,
    QUY_DOI_CLOS                  NUMBER(14,4)        ,
    QUY_DOI_CLOS_WTD              NUMBER(16,4)        ,
    QUY_DOI_CLOS_MTD              NUMBER(16,4)        ,
    QUY_DOI_CLOS_QTD              NUMBER(16,4)        ,
    QUY_DOI_CLOS_YTD              NUMBER(16,4)        ,
    USER_CNT                      NUMBER(8)           ,
    USER_CNT_WTD                  NUMBER(8)           ,
    USER_CNT_MTD                  NUMBER(8)           ,
    USER_CNT_QTD                  NUMBER(8)           ,
    USER_CNT_YTD                  NUMBER(8)           ,

	CONSTRAINT AGG_LOS_KPI_YTD_DAILY_PK PRIMARY KEY (DAYID) USING INDEX LOCAL
)
PARTITION BY RANGE (DAYID)
INTERVAL (NUMTODSINTERVAL(1, 'DAY'))
(
    PARTITION AGG_LOS_KPI_YTD_DAILY_P0 VALUES LESS THAN (
        TO_DATE(' 2008-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')
    )
);

COMMIT;
