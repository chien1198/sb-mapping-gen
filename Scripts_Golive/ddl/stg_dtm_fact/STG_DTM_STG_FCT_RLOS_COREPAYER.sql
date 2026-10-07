-- ============================================================
-- STG_DTM_STG_FCT_RLOS_COREPAYER.sql
-- ============================================================
-- ===========================================================================
-- TANG STG (vung chia): bang chi giu lat cat 1 ngay roi day sang PDTD_DTM.
-- Da giu nguyen partition INTERVAL 1 DAY + PK LOCAL cho dong bo 2 tang kia,
-- nhung neu job la truncate-load moi ngay thi can danh gia lai: partition tren
-- bang chi chua 1 ngay gan nhu khong co tac dung, va PK constraint lam cham load.
-- ===========================================================================
-- DROP TABLE STG_DTM.STG_FCT_RLOS_COREPAYER
CREATE TABLE STG_DTM.STG_FCT_RLOS_COREPAYER (
    DAYID                         DATE                NOT NULL,
    COREPAYER_BK                  VARCHAR2(64)        NOT NULL,
    APPLICATION_SK                NUMBER              NOT NULL,
    WI_NAME                       VARCHAR2(100)       ,
    REL_TO_APPLICANT              VARCHAR2(200)       ,
    ID_NO_CO                      VARCHAR2(100)       ,
    ID_TYPE                       VARCHAR2(50)        ,
    ID_NUMBER                     VARCHAR2(100)       ,
    FULL_NAME                     VARCHAR2(200)       ,
    DATE_OF_BIRTH                 DATE                ,
    NATIONALITY                   VARCHAR2(100)       ,
    TITLE                         VARCHAR2(30)        ,
    HOUSEHOLD                     VARCHAR2(100)       ,
    PHONE_1                       VARCHAR2(50)        ,
    PHONE_2                       VARCHAR2(50)        ,
    HOME_PHONE                    VARCHAR2(50)        ,

  CONSTRAINT STG_FCT_RLOS_COREPAYER_PK PRIMARY KEY (COREPAYER_BK, DAYID) USING INDEX LOCAL
)
PARTITION BY RANGE (DAYID)
INTERVAL (NUMTODSINTERVAL(1, 'DAY'))
(
    PARTITION STG_FCT_RLOS_COREPAYER_P0 VALUES LESS THAN (
        TO_DATE(' 2008-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')
    )
);

COMMIT;
