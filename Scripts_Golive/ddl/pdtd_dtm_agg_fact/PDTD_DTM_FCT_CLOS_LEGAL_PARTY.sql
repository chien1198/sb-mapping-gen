-- ============================================================
-- PDTD_DTM_FCT_CLOS_LEGAL_PARTY.sql
-- ============================================================
CREATE TABLE PDTD_DTM.FCT_CLOS_LEGAL_PARTY (
    DAYID                         DATE                NOT NULL,
    LEGAL_PARTY_BK                VARCHAR2(64)        NOT NULL,
    CUSTOMER_SK                   NUMBER              NOT NULL,
    APPLICATION_SK                NUMBER              NOT NULL,
    WI_NAME                       NVARCHAR2(100)       NOT NULL,
    ID_NUMBER                     NVARCHAR2(100)       NOT NULL,
    FULL_NAME                     NVARCHAR2(200)       ,
    OBJ_TYPE                      NVARCHAR2(100)       ,
    LEGAL_DOC                     NVARCHAR2(100)       ,
    LEGAL_TYPE                    VARCHAR2(50)        ,

	CONSTRAINT FCT_CLOS_LEGAL_PARTY_PK PRIMARY KEY (LEGAL_PARTY_BK, DAYID) USING INDEX LOCAL
)
PARTITION BY RANGE (DAYID)
INTERVAL (NUMTODSINTERVAL(1, 'DAY'))
(
    PARTITION FCT_CLOS_LEGAL_PARTY_P0 VALUES LESS THAN (
        TO_DATE(' 2008-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')
    )
);

COMMIT;
