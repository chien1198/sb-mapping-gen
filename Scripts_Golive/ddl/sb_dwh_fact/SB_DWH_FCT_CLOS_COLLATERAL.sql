-- ============================================================
-- SB_DWH_FCT_CLOS_COLLATERAL.sql
-- ============================================================
--===========================================================================
CREATE TABLE SB_DWH.FCT_CLOS_COLLATERAL (
    DAYID                         DATE                NOT NULL,
    COLLATERAL_BK                 VARCHAR2(64)        NOT NULL,
    APPLICATION_SK                NUMBER              NOT NULL,
    COLLATERAL_TYPE_CODE          NVARCHAR2(100)       NOT NULL,
    WI_NAME                       NVARCHAR2(100)       NOT NULL,
    DESCRIPTION                   CLOB      ,
    OWNER_NAME                    NVARCHAR2(100)       ,
    COLL_MGMT_METHOD              CLOB      ,
    APPRAISED_VALUE               NUMBER(20,2)        ,
    LOAN_RATE_LTV                 NUMBER(5,2)         ,

	CONSTRAINT FCT_CLOS_COLLATERAL_PK PRIMARY KEY (COLLATERAL_BK, DAYID) USING INDEX LOCAL
)
PARTITION BY RANGE (DAYID)
INTERVAL (NUMTODSINTERVAL(1, 'DAY'))
(
    PARTITION FCT_CLOS_COLLATERAL_P0 VALUES LESS THAN (
        TO_DATE(' 2008-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')
    )
);

COMMIT;
