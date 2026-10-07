-- ============================================================
-- PDTD_DTM_AGG_LOS_KPI_APPLICATION.sql
-- ============================================================
-- ===========================================================================
-- DROP TABLE PDTD_DTM.AGG_LOS_KPI_APPLICATION
CREATE TABLE PDTD_DTM.AGG_LOS_KPI_APPLICATION (
    DAYID                         DATE                NOT NULL,
    DATASOURCE                    VARCHAR2(10)        NOT NULL,
    APPLICATION_BK                VARCHAR2(64)        NOT NULL,
    APPLICATION_SK                NUMBER              NOT NULL,
    PRODUCT_SK                    NUMBER              NOT NULL,
    COMPANY_SK                    NUMBER              NOT NULL,
    WI_NAME                       VARCHAR2(100)       NOT NULL,
    PROCESSED_DATE                DATE                ,
    VOLUME                        NUMBER(5,2)         ,
    POINT                         NUMBER(12,4)        ,
    QUY_DOI                       NUMBER(12,4)        ,
    TAT_APPLICATION_HOUR          NUMBER(18,6)        ,
    TSBD_G2                       VARCHAR2(10)        ,
    INCOM_3                       VARCHAR2(10)        ,
    BUSINESS_INCOM                VARCHAR2(10)        ,
    DEVIATION_G2                  VARCHAR2(10)        ,
    DEVIATION_G3                  VARCHAR2(10)        ,
    IS_TEST_ACCOUNT               VARCHAR2(1)         NOT NULL,
    APPLICATION_LINK_INFO         VARCHAR2(200)       ,

	CONSTRAINT AGG_LOS_KPI_APPLICATION_PK PRIMARY KEY (APPLICATION_BK, DAYID) USING INDEX LOCAL
)
PARTITION BY RANGE (DAYID)
INTERVAL (NUMTODSINTERVAL(1, 'DAY'))
(
    PARTITION AGG_LOS_KPI_APPLICATION_P0 VALUES LESS THAN (
        TO_DATE(' 2008-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')
    )
);

COMMIT;
