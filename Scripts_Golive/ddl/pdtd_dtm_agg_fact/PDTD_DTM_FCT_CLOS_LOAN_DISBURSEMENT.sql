-- ============================================================
-- PDTD_DTM_FCT_CLOS_LOAN_DISBURSEMENT.sql
-- ============================================================
CREATE TABLE PDTD_DTM.FCT_CLOS_LOAN_DISBURSEMENT (
    DAYID                         DATE                NOT NULL,
    CONTRACT                      VARCHAR2(100)       NOT NULL,
    CUSTOMER_SK                   NUMBER              NOT NULL,
    T24_COMPANY_SK                NUMBER              NOT NULL,
    CONTRACT_SK                   NUMBER              NOT NULL,
    SEAB_PRODUCTS_DE_SK           NUMBER              NOT NULL,
    APPLICATION_SK                NUMBER              NOT NULL,
    SEAB_LOS_ID                   VARCHAR2(100)       ,
    ZONE                          VARCHAR2(50)        ,
    DISBURSEMENT_AMT              NUMBER(20,2)        ,
    CUR_BALANCE                   NUMBER(20,2)        ,
    NO_DAYS_OVERDUE               NUMBER(6)           ,
    CUR_BUCKET                    NUMBER(2)           ,
    LIMIT_REFERENCE               VARCHAR2(100)       ,
    CUST_GROUP                    VARCHAR2(100)       ,
    LOANCASEID                    VARCHAR2(100)       ,
    APPROVAL_WINAME_LOS           VARCHAR2(100)       ,
    APPROVAL_DATE                 DATE                ,

	CONSTRAINT FCT_CLOS_LOAN_DISBURSEMENT_PK PRIMARY KEY (CONTRACT, DAYID) USING INDEX LOCAL
)
PARTITION BY RANGE (DAYID)
INTERVAL (NUMTODSINTERVAL(1, 'DAY'))
(
    PARTITION FCT_CLOS_LOAN_DISBURSEMENT_P0 VALUES LESS THAN (
        TO_DATE(' 2008-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')
    )
);

COMMIT;
