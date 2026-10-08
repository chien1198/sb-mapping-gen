-- ============================================================
-- STG_DTM_STG_FCT_CLOS_APPLICATION.sql
-- ============================================================
CREATE TABLE STG_DTM.STG_FCT_CLOS_APPLICATION (
    DAYID                         DATE                NOT NULL,
    APPLICATION_SK                NUMBER              NOT NULL,
    WORKSTEP_DECISION_SK          NUMBER              NOT NULL,
    PRODUCT_SK                    NUMBER              NOT NULL,
    COMPANY_SK                    NUMBER              NOT NULL,
    CUSTOMER_SK                   NUMBER              NOT NULL,
    WI_NAME                       NVARCHAR2(63)       NOT NULL,
    PROCESSED_DATE                DATE                ,
    PROPOSED_AMT                  NUMBER(20,2)        ,
    CREDIT_LIMIT_APPROVAL         NUMBER(20,2)        ,
    CREDIT_LIMIT_COMMITTEE        NUMBER(20,2)        ,
    APPROVED_AMT_FINAL            NUMBER(20,2)        ,
    APPROVED_TERM                 NUMBER(5)           ,
    INTEREST_RATE_PCT             NUMBER(8,4)         ,
    CURRENCY_CODE                 NVARCHAR2(100)        ,
    APPLICATION_LINK_INFO         NVARCHAR2(512)       ,
    UNDERWRITERMAKER_USERMAKE     VARCHAR2(100)       ,
    UNDERWRITERCHECKER_USERMAKE   VARCHAR2(100)       ,
    APPROVAL_USERMAKE             VARCHAR2(100)       ,
    LG_REQ                        NVARCHAR2(100)        ,
    FI_REQ                        NVARCHAR2(100)        ,
    PHONE_REQ                     NVARCHAR2(100)        ,
    CHANGE_REQUEST                NVARCHAR2(150)       ,
    CHANGE_TYPE                   NVARCHAR2(500)       ,

  CONSTRAINT STG_FCT_CLOS_APPLICATION_PK PRIMARY KEY (WI_NAME, DAYID) USING INDEX LOCAL
)
PARTITION BY RANGE (DAYID)
INTERVAL (NUMTODSINTERVAL(1, 'DAY'))
(
    PARTITION STG_FCT_CLOS_APPLICATION_P0 VALUES LESS THAN (
        TO_DATE(' 2008-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')
    )
);

COMMIT;
