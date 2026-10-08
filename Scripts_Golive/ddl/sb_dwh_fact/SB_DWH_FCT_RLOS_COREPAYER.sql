-- ============================================================
-- SB_DWH_FCT_RLOS_COREPAYER.sql
-- ============================================================
-- ===========================================================================
-- DROP TABLE SB_DWH.FCT_RLOS_COREPAYER
CREATE TABLE SB_DWH.FCT_RLOS_COREPAYER (
    DAYID                         DATE                NOT NULL,
    COREPAYER_BK                  VARCHAR2(64)        NOT NULL,
    APPLICATION_SK                NUMBER              NOT NULL,
    WI_NAME                       NVARCHAR2(100)       ,
    REL_TO_APPLICANT              NVARCHAR2(100)       ,
    ID_NO_CO                      NVARCHAR2(50)       ,
    ID_TYPE                       NVARCHAR2(50)        ,
    ID_NUMBER                     NVARCHAR2(100)       ,
    FULL_NAME                     NVARCHAR2(150)       ,
    DATE_OF_BIRTH                 DATE                ,
    NATIONALITY                   NVARCHAR2(100)       ,
    TITLE                         NVARCHAR2(30)        ,
    HOUSEHOLD                     NVARCHAR2(100)       ,
    PHONE_1                       NVARCHAR2(100)        ,
    PHONE_2                       NVARCHAR2(100)        ,
    HOME_PHONE                    NVARCHAR2(100)        ,

	CONSTRAINT FCT_RLOS_COREPAYER_PK PRIMARY KEY (COREPAYER_BK, DAYID) USING INDEX LOCAL
)
PARTITION BY RANGE (DAYID)
INTERVAL (NUMTODSINTERVAL(1, 'DAY'))
(
    PARTITION FCT_RLOS_COREPAYER_P0 VALUES LESS THAN (
        TO_DATE(' 2008-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')
    )
);

COMMIT;
