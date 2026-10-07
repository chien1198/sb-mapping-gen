-- ============================================================
-- STG_DTM_STG_FCT_CLOS_LEGAL_PARTY.sql
-- ============================================================
CREATE TABLE STG_DTM.STG_FCT_CLOS_LEGAL_PARTY (
    DAYID                         DATE                NOT NULL,
    LEGAL_PARTY_BK                VARCHAR2(64)        NOT NULL,
    CUSTOMER_SK                   NUMBER              NOT NULL,
    APPLICATION_SK                NUMBER              NOT NULL,
    WI_NAME                       VARCHAR2(100)       NOT NULL,
    ID_NUMBER                     VARCHAR2(100)       NOT NULL,
    FULL_NAME                     VARCHAR2(200)       ,
    OBJ_TYPE                      VARCHAR2(100)       ,
    LEGAL_DOC                     VARCHAR2(100)       ,

  CONSTRAINT STG_FCT_CLOS_LEGAL_PARTY_PK PRIMARY KEY (LEGAL_PARTY_BK, DAYID) USING INDEX LOCAL
)
PARTITION BY RANGE (DAYID)
INTERVAL (NUMTODSINTERVAL(1, 'DAY'))
(
    PARTITION STG_FCT_CLOS_LEGAL_PARTY_P0 VALUES LESS THAN (
        TO_DATE(' 2008-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')
    )
);

COMMIT;
