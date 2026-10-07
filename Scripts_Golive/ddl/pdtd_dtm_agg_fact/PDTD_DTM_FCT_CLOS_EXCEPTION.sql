-- ============================================================
-- PDTD_DTM_FCT_CLOS_EXCEPTION.sql
-- ============================================================
CREATE TABLE PDTD_DTM.FCT_CLOS_EXCEPTION (
    DAYID                         DATE                NOT NULL,
    EXCEPTION_BK                  VARCHAR2(64)        NOT NULL,
    APPLICATION_SK                NUMBER              NOT NULL,
    EXCEPTION_SK                  NUMBER              NOT NULL,
    USER_SK                       NUMBER              NOT NULL,
    CUSTOMER_SK                   NUMBER              NOT NULL,
    WI_NAME                       VARCHAR2(100)       NOT NULL,
    EXCEPTION_CATEGORY            VARCHAR2(500)       NOT NULL,
    RAISED_BY                     VARCHAR2(100)       NOT NULL,
    RAISED_DATE_TIME              TIMESTAMP           NOT NULL,
    EXCEPTION_NAME                VARCHAR2(500)       ,
    EXCEPTION_REMARKS             VARCHAR2(4000)      ,
    RCTYPE                        VARCHAR2(20)        ,
    PHAN_LOAI_DDE                 VARCHAR2(100)       ,
    CHECK_FTR                     VARCHAR2(20)        ,
    FIRST_WORKSTEP_RETURN         VARCHAR2(200)       ,

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
