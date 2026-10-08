-- ============================================================
-- SB_DWH_FCT_CLOS_EXCEPTION.sql
-- ============================================================
CREATE TABLE SB_DWH.FCT_CLOS_EXCEPTION (
    DAYID                         DATE                NOT NULL,
    EXCEPTION_BK                  VARCHAR2(64)        NOT NULL,
    APPLICATION_SK                NUMBER              NOT NULL,
    EXCEPTION_SK                  NUMBER              NOT NULL,
    USER_SK                       NUMBER              NOT NULL,
    CUSTOMER_SK                   NUMBER              NOT NULL,
    WI_NAME                       NVARCHAR2(256)       NOT NULL,
    EXCEPTION_CATEGORY            NVARCHAR2(200)       NOT NULL,
    RAISED_BY                     NVARCHAR2(200)       NOT NULL,
    RAISED_DATE_TIME              TIMESTAMP           NOT NULL,
    EXCEPTION_NAME                NVARCHAR2(200)       ,
    EXCEPTION_REMARKS             NVARCHAR2(200)      ,
    RCTYPE                        NVARCHAR2(100)        ,

	CONSTRAINT FCT_CLOS_EXCEPTION_PK PRIMARY KEY (EXCEPTION_BK, DAYID) USING INDEX LOCAL
)
PARTITION BY RANGE (DAYID)
INTERVAL (NUMTODSINTERVAL(1, 'DAY'))
(
    PARTITION FCT_CLOS_EXCEPTION_P0 VALUES LESS THAN (
        TO_DATE(' 2008-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')
    )
);

COMMIT;
