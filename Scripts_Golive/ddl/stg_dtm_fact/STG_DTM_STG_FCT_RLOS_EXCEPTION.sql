-- ============================================================
-- STG_DTM_STG_FCT_RLOS_EXCEPTION.sql
-- ============================================================
-- ===========================================================================
-- TANG STG (vung chia): bang chi giu lat cat 1 ngay roi day sang PDTD_DTM.
-- Da giu nguyen partition INTERVAL 1 DAY + PK LOCAL cho dong bo 2 tang kia,
-- nhung neu job la truncate-load moi ngay thi can danh gia lai: partition tren
-- bang chi chua 1 ngay gan nhu khong co tac dung, va PK constraint lam cham load.
-- ===========================================================================
-- DROP TABLE STG_DTM.STG_FCT_RLOS_EXCEPTION
CREATE TABLE STG_DTM.STG_FCT_RLOS_EXCEPTION (
    DAYID                         DATE                NOT NULL,
    EXCEPTION_BK                  VARCHAR2(64)        NOT NULL,
    APPLICATION_SK                NUMBER              NOT NULL,
    EXCEPTION_SK                  NUMBER              NOT NULL,
    USER_SK                       NUMBER              NOT NULL,
    WI_NAME                       VARCHAR2(100)       NOT NULL,
    EXCEPTION_CATEGORY            VARCHAR2(500)       NOT NULL,
    RAISED_BY                     VARCHAR2(100)       NOT NULL,
    RAISED_DATE_TIME              TIMESTAMP           NOT NULL,
    EXCEPTION_NAME                VARCHAR2(500)       ,
    EXCEPTION_REMARKS             VARCHAR2(4000)      ,
    RCTYPE                        VARCHAR2(20)        ,
    SUB_PRODUCT                   VARCHAR2(255)       ,

  CONSTRAINT STG_FCT_RLOS_EXCEPTION_PK PRIMARY KEY (EXCEPTION_BK, DAYID) USING INDEX LOCAL
)
PARTITION BY RANGE (DAYID)
INTERVAL (NUMTODSINTERVAL(1, 'DAY'))
(
    PARTITION STG_FCT_RLOS_EXCEPTION_P0 VALUES LESS THAN (
        TO_DATE(' 2008-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')
    )
);

COMMIT;
