-- ============================================================
-- SB_DWH_FCT_RLOS_APPLICATION.sql
-- ============================================================
CREATE TABLE SB_DWH.FCT_RLOS_APPLICATION (
    DAYID                         DATE                NOT NULL,
    APPLICATION_SK                NUMBER              NOT NULL,
    WORKSTEP_DECISION_SK          NUMBER              NOT NULL,
    PRODUCT_SK                    NUMBER              NOT NULL,
    COMPANY_SK                    NUMBER              NOT NULL,
    CHANGE_TYPE_SK                NUMBER              NOT NULL,
    CARD_PROMOTION_SK             NUMBER              NOT NULL,
    WI_NAME                       NVARCHAR2(70)       NOT NULL,
    PROCESSED_DATE                DATE                ,
    CREATION_DATE                 DATE                ,
    APPROVED_AMT_FINAL            NUMBER(20,2)        ,
    APPROVED_TERM                 NUMBER(5)           ,
    CURRENCY_CODE                 NVARCHAR2(100)        ,
    UNDERWRITERMAKER_USERMAKE     VARCHAR2(100)       ,
    UNDERWRITERCHECKER_USERMAKE   VARCHAR2(100)       ,
    APPROVAL_USERMAKE             VARCHAR2(100)       ,
    CHANGE_REQUEST                NVARCHAR2(50)       ,
    CHANGE_TYPE                   NVARCHAR2(255)       ,

	CONSTRAINT FCT_RLOS_APPLICATION_PK PRIMARY KEY (WI_NAME, DAYID) USING INDEX LOCAL
)
PARTITION BY RANGE (DAYID)
INTERVAL (NUMTODSINTERVAL(1, 'DAY'))
(
    PARTITION FCT_RLOS_APPLICATION_P0 VALUES LESS THAN (
        TO_DATE(' 2008-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')
    )
);

COMMIT;
