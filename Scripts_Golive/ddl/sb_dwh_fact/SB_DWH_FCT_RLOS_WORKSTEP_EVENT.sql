-- ============================================================
-- SB_DWH_FCT_RLOS_WORKSTEP_EVENT.sql
-- ============================================================
-- ===========================================================================
-- DROP TABLE SB_DWH.FCT_RLOS_WORKSTEP_EVENT
CREATE TABLE SB_DWH.FCT_RLOS_WORKSTEP_EVENT (
    DAYID                         DATE                NOT NULL,
    WORKSTEP_EVENT_BK             VARCHAR2(64)        NOT NULL,
    WORKSTEP_DECISION_SK          NUMBER              NOT NULL,
    USER_SK                       NUMBER              NOT NULL,
    APPLICATION_SK                NUMBER              NOT NULL,
    WI_NAME                       NVARCHAR2(70)       NOT NULL,
    WORKSTEP_CODE                 NVARCHAR2(100)       NOT NULL,
    ENTRYDATE                     TIMESTAMP           NOT NULL,
    EXITDATE                      TIMESTAMP           ,
    USERNAME                      NVARCHAR2(150)       ,
    REMARKS                       NVARCHAR2(4000)      ,
    REASON_CODE                   NVARCHAR2(50)        ,
    REASON_DESC                   NVARCHAR2(500)       ,
    TAT_SOURCE_SEC                NUMBER(12)          ,
    TAT_CALENDAR_HOUR             NUMBER(18,6)        ,
    TAT_WORKING_HOUR              NUMBER(18,6)        ,
    TAT_CPC_HOUR                  NUMBER(18,6)        ,
    EVENT_SEQ_ASC                 NUMBER(5)           ,
    PROCESSED_DATE                DATE                ,
    WF_PROCESSNAME                NVARCHAR2(30)        ,
    WF_ACTIVITYNAME               NVARCHAR2(30)       ,
    WF_CREATEDBY                  VARCHAR2(50)        ,

	CONSTRAINT FCT_RLOS_WORKSTEP_EVENT_PK PRIMARY KEY (WORKSTEP_EVENT_BK, DAYID) USING INDEX LOCAL
)
PARTITION BY RANGE (DAYID)
INTERVAL (NUMTODSINTERVAL(1, 'DAY'))
(
    PARTITION FCT_RLOS_WORKSTEP_EVENT_P0 VALUES LESS THAN (
        TO_DATE(' 2008-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')
    )
);

COMMIT;
