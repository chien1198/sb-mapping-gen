-- ============================================================
-- STG_DTM_STG_FCT_CLOS_DEVIATION.sql
-- ============================================================
CREATE TABLE STG_DTM.STG_FCT_CLOS_DEVIATION (
    DAYID                         DATE                NOT NULL,
    DEVIATION_BK                  VARCHAR2(64)        NOT NULL,
    APPLICATION_SK                NUMBER              NOT NULL,
    WI_NAME                       NVARCHAR2(63)       NOT NULL,
    DEVIATION_TYPE_CODE           NVARCHAR2(100)       ,
    DEV_PROPOSAL                  CLOB      ,
    AS_REGULAR                    CLOB      ,
    PROCESSED_DATE                DATE                ,

  CONSTRAINT STG_FCT_CLOS_DEVIATION_PK PRIMARY KEY (DEVIATION_BK, DAYID) USING INDEX LOCAL
)
PARTITION BY RANGE (DAYID)
INTERVAL (NUMTODSINTERVAL(1, 'DAY'))
(
    PARTITION STG_FCT_CLOS_DEVIATION_P0 VALUES LESS THAN (
        TO_DATE(' 2008-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')
    )
);

COMMIT;
