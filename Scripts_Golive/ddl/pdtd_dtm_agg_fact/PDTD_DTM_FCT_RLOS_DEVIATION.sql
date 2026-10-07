-- ============================================================
-- PDTD_DTM_FCT_RLOS_DEVIATION.sql
-- ============================================================
-- DROP TABLE PDTD_DTM.FCT_RLOS_DEVIATION
CREATE TABLE PDTD_DTM.FCT_RLOS_DEVIATION (
    DAYID                         DATE                NOT NULL,
    DEVIATION_BK                  VARCHAR2(64)        NOT NULL,
    APPLICATION_SK                NUMBER              NOT NULL,
    WI_NAME                       VARCHAR2(100)       NOT NULL,
    CHECKING_CONDITION            VARCHAR2(500)       ,
    CHECKING_RESULT               VARCHAR2(200)       ,
    DEVIATION_REASON              VARCHAR2(4000)      ,
    PROCESSED_DATE                DATE                ,

	CONSTRAINT FCT_RLOS_DEVIATION_PK PRIMARY KEY (DEVIATION_BK, DAYID) USING INDEX LOCAL
)
PARTITION BY RANGE (DAYID)
INTERVAL (NUMTODSINTERVAL(1, 'DAY'))
(
    PARTITION FCT_RLOS_DEVIATION_P0 VALUES LESS THAN (
        TO_DATE(' 2008-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')
    )
);

COMMIT;
