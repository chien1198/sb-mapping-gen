-- ============================================================
-- SB_DWH_FCT_RLOS_APPLICATION_SECONDPRODUCT.sql
-- ============================================================
CREATE TABLE SB_DWH.FCT_RLOS_APPLICATION_SECONDPRODUCT (
    DAYID                         DATE                NOT NULL,
    SUB_PRODUCT_BK                VARCHAR2(64)        NOT NULL,
    APPLICATION_SK                NUMBER              NOT NULL,
    SECONDPRODUCT_SK              NUMBER              NOT NULL,
    WI_NAME                       NVARCHAR2(100)       ,
    SUB_PRODUCT_LINE              NVARCHAR2(100)       ,
    SPP_AMOUNT                    NUMBER(20,2)        ,
    SPP_TERM                      NUMBER(5)           ,
    CARD_TYPE_CODE                NVARCHAR2(100)       ,

	CONSTRAINT FCT_RLOS_APPLICATION_SECONDPRODUCT_PK PRIMARY KEY (SUB_PRODUCT_BK, DAYID) USING INDEX LOCAL
)
PARTITION BY RANGE (DAYID)
INTERVAL (NUMTODSINTERVAL(1, 'DAY'))
(
    PARTITION FCT_RLOS_APPLICATION_SECONDPRODUCT_P0 VALUES LESS THAN (
        TO_DATE(' 2008-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')
    )
);

COMMIT;
