-- ============================================================
-- STG_DTM_STG_FCT_RLOS_COLLATERAL.sql
-- ============================================================
-- DROP TABLE STG_DTM.STG_FCT_RLOS_COLLATERAL
CREATE TABLE STG_DTM.STG_FCT_RLOS_COLLATERAL (
    DAYID                         DATE                NOT NULL,
    COLLATERAL_BK                 VARCHAR2(64)        NOT NULL,
    APPLICATION_SK                NUMBER              NOT NULL,
    WI_NAME                       NVARCHAR2(256)       NOT NULL,
    COLLATERAL_TYPE_CODE          VARCHAR2(100)       ,
    CERTIFICATE_NO                NVARCHAR2(200)       ,
    DESCRIPTION                   VARCHAR2(4000)      ,
    OWNER_NAME                    VARCHAR2(200)       ,
    REL_TO_CUSTOMER               VARCHAR2(200)       ,
    USING_PURPOSE                 NVARCHAR2(255)       ,
    VEHICLE_TYPE                  NVARCHAR2(200)       ,
    BRAND                         NVARCHAR2(256)       ,
    CONTROL_POSTER                NVARCHAR2(256)       ,
    VALPAPER_TYPE                 NVARCHAR2(200)       ,
    NUMBERSIGN                    NVARCHAR2(256)       ,
    IS_ASSET_FORMED               NVARCHAR2(200)        ,
    IS_FORMED_FROM_LOAN           VARCHAR2(100)       ,
    APPRAISED_VALUE               NUMBER(20,2)        ,
    LOAN_RATE_LTV                 NUMBER(5,2)         ,
    TYPES_OF_COLLATERALS          VARCHAR2(500)       , 

  CONSTRAINT STG_FCT_RLOS_COLLATERAL_PK PRIMARY KEY (COLLATERAL_BK, DAYID) USING INDEX LOCAL
)
PARTITION BY RANGE (DAYID)
INTERVAL (NUMTODSINTERVAL(1, 'DAY'))
(
    PARTITION STG_FCT_RLOS_COLLATERAL_P0 VALUES LESS THAN (
        TO_DATE(' 2008-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')
    )
);

COMMIT;
