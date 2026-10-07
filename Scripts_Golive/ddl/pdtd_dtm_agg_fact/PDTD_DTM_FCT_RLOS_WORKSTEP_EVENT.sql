-- ============================================================
-- PDTD_DTM_FCT_RLOS_WORKSTEP_EVENT.sql
-- ============================================================
-- ===========================================================================
-- DROP TABLE PDTD_DTM.FCT_RLOS_WORKSTEP_EVENT
CREATE TABLE PDTD_DTM.FCT_RLOS_WORKSTEP_EVENT (
    DAYID                         DATE                NOT NULL,
    WORKSTEP_EVENT_BK             VARCHAR2(64)        NOT NULL,
    WORKSTEP_DECISION_SK          NUMBER              NOT NULL,
    USER_SK                       NUMBER              NOT NULL,
    APPLICATION_SK                NUMBER              NOT NULL,
    WI_NAME                       VARCHAR2(100)       NOT NULL,
    WORKSTEP_CODE                 VARCHAR2(200)       NOT NULL,
    ENTRYDATE                     TIMESTAMP           NOT NULL,
    EXITDATE                      TIMESTAMP           ,
    USERNAME                      VARCHAR2(100)       ,
    REMARKS                       VARCHAR2(4000)      ,
    REASON_CODE                   VARCHAR2(50)        ,
    REASON_DESC                   VARCHAR2(500)       ,
    TAT_SOURCE_SEC                NUMBER(12)          ,
    TAT_CALENDAR_HOUR             NUMBER(18,6)        ,
    TAT_WORKING_HOUR              NUMBER(18,6)        ,
    TAT_CPC_HOUR                  NUMBER(18,6)        ,
    EVENT_SEQ_ASC                 NUMBER(5)           ,
    PROCESSED_DATE                DATE                ,
    WF_PROCESSNAME                VARCHAR2(50)        ,
    WF_ACTIVITYNAME               VARCHAR2(200)       ,
    WF_CREATEDBY                  VARCHAR2(50)        ,
    APPROVAL_FLAG                 VARCHAR2(50)        ,
    WORKSTEP_FLAG                 VARCHAR2(200)       ,

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
