-- ============================================================
-- PDTD_DTM_FCT_CLOS_APPLICATION.sql
-- ============================================================
CREATE TABLE PDTD_DTM.FCT_CLOS_APPLICATION (
    DAYID                         DATE                NOT NULL,
    APPLICATION_SK                NUMBER              NOT NULL,
    WORKSTEP_DECISION_SK          NUMBER              NOT NULL,
    PRODUCT_SK                    NUMBER              NOT NULL,
    COMPANY_SK                    NUMBER              NOT NULL,
    CUSTOMER_SK                   NUMBER              NOT NULL,
    T24_CUSTOMER_SK               NUMBER              ,
    WI_NAME                       VARCHAR2(100)       NOT NULL,
    RI_USER                       VARCHAR2(100)       ,
    BRANCH_USER                   VARCHAR2(100)       ,
    DDE_USER                      VARCHAR2(100)       ,
    QC_USER                       VARCHAR2(100)       ,
    UND_MAKER_USER                VARCHAR2(100)       ,
    UND_CHECKER_USER              VARCHAR2(100)       ,
    PHV_USER                      VARCHAR2(100)       ,
    FA_USER                       VARCHAR2(100)       ,
    APPROVER_USER                 VARCHAR2(100)       ,
    COMMITTEE_USER                VARCHAR2(100)       ,
    HOS_USER                      VARCHAR2(100)       ,
    PROCESSED_DATE                DATE                ,
    LAST_APPROVAL_DATE            DATE                ,
    MIN_UWM                       TIMESTAMP           ,
    MIN_APP                       TIMESTAMP           ,
    CANCEL_DATE                   DATE                ,
    LAST_ENTRYDATE                TIMESTAMP           ,
    LAST_EXITDATE                 TIMESTAMP           ,
    PRE_WORKSTEP_CODE             VARCHAR2(200)       ,
    LAST_REMARKS                  VARCHAR2(4000)      ,
    PROPOSED_AMT                  NUMBER(20,2)        ,
    CREDIT_LIMIT_APPROVAL         NUMBER(20,2)        ,
    CREDIT_LIMIT_COMMITTEE        NUMBER(20,2)        ,
    APPROVED_AMT_FINAL            NUMBER(20,2)        ,
    APPROVED_TERM                 NUMBER(5)           ,
    INTEREST_RATE_PCT             NUMBER(8,4)         ,
    CURRENCY_CODE                 VARCHAR2(10)        ,
    APPLICATION_LINK_INFO         VARCHAR2(200)       ,
    UNDERWRITERMAKER_USERMAKE     VARCHAR2(100)       ,
    UNDERWRITERCHECKER_USERMAKE   VARCHAR2(100)       ,
    APPROVAL_USERMAKE             VARCHAR2(100)       ,
    LG_REQ                        VARCHAR2(10)        ,
    FI_REQ                        VARCHAR2(10)        ,
    PHONE_REQ                     VARCHAR2(10)        ,
    LAST_WORKSTEP                 VARCHAR2(50)        ,
    BUSINESS_FLOW                 VARCHAR2(50)        ,
    REF_PRODUCT                   VARCHAR2(200)       ,
    SLA_CREDIT_OFFICER            NUMBER(10,2)        ,
    SLA_MARKER                    NUMBER(10,2)        ,
    SLA_CHECKER                   NUMBER(10,2)        ,
    SLA_CREDIT_APPROVER           NUMBER(10,2)        ,
    LEGAL_REPRESENTATIVE          VARCHAR2(1000)      ,
    ADD_ID_REPRESENTATIVE         VARCHAR2(1000)      ,
    APPLICATION_STATUS            VARCHAR2(50)        ,
    FLAG_AUTO_CANCEL              VARCHAR2(10)        ,
    APPROVAL_TYPE                 VARCHAR2(200)       ,
    CHANGE_REQUEST                VARCHAR2(200)       ,
    CHANGE_TYPE                   VARCHAR2(500)       ,

	CONSTRAINT FCT_CLOS_APPLICATION_PK PRIMARY KEY (WI_NAME, DAYID) USING INDEX LOCAL
)
PARTITION BY RANGE (DAYID)
INTERVAL (NUMTODSINTERVAL(1, 'DAY'))
(
    PARTITION FCT_CLOS_APPLICATION_P0 VALUES LESS THAN (
        TO_DATE(' 2008-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')
    )
);

COMMIT;
