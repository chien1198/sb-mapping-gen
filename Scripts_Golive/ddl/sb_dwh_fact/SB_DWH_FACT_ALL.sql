-- ============================================================
-- SB_DWH_FCT_CLOS_APPLICATION.sql
-- ============================================================
CREATE TABLE SB_DWH.FCT_CLOS_APPLICATION (
    DAYID                         DATE                NOT NULL,
    APPLICATION_SK                NUMBER              NOT NULL,
    WORKSTEP_DECISION_SK          NUMBER              NOT NULL,
    PRODUCT_SK                    NUMBER              NOT NULL,
    COMPANY_SK                    NUMBER              NOT NULL,
    CUSTOMER_SK                   NUMBER              NOT NULL,
    WI_NAME                       VARCHAR2(100)       NOT NULL,
    PROCESSED_DATE                DATE                ,
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

-- ============================================================
-- SB_DWH_FCT_CLOS_COLLATERAL.sql
-- ============================================================
--===========================================================================
CREATE TABLE SB_DWH.FCT_CLOS_COLLATERAL (
    DAYID                         DATE                NOT NULL,
    COLLATERAL_BK                 VARCHAR2(64)        NOT NULL,
    APPLICATION_SK                NUMBER              NOT NULL,
    COLLATERAL_TYPE_CODE          VARCHAR2(500)       NOT NULL,
    WI_NAME                       VARCHAR2(100)       NOT NULL,
    DESCRIPTION                   VARCHAR2(4000)      ,
    OWNER_NAME                    VARCHAR2(200)       ,
    COLL_MGMT_METHOD              VARCHAR2(4000)      ,
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

-- ============================================================
-- SB_DWH_FCT_CLOS_DEVIATION.sql
-- ============================================================
-- ===========================================================================
-- NOTE - CAN CHECK LAI: PK co 3 cot, nhieu hon mau <bang>_BK + DAYID
--
-- PK hien tai : (DEVIATION_BK, WI_NAME, DAYID)
--===========================================================================
CREATE TABLE SB_DWH.FCT_CLOS_DEVIATION (
    DAYID                         DATE                NOT NULL,
    DEVIATION_BK                  VARCHAR2(64)        NOT NULL,
    APPLICATION_SK                NUMBER              NOT NULL,
    WI_NAME                       VARCHAR2(100)       NOT NULL,
    DEVIATION_TYPE_CODE           VARCHAR2(300)       ,
    DEV_PROPOSAL                  VARCHAR2(4000)      ,
    AS_REGULAR                    VARCHAR2(4000)      ,
    PROCESSED_DATE                DATE                ,

	CONSTRAINT FCT_CLOS_DEVIATION_PK PRIMARY KEY (DEVIATION_BK, WI_NAME, DAYID) USING INDEX LOCAL
)
PARTITION BY RANGE (DAYID)
INTERVAL (NUMTODSINTERVAL(1, 'DAY'))
(
    PARTITION FCT_CLOS_DEVIATION_P0 VALUES LESS THAN (
        TO_DATE(' 2008-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')
    )
);

COMMIT;

-- ============================================================
-- SB_DWH_FCT_CLOS_EXCEPTION.sql
-- ============================================================
CREATE TABLE SB_DWH.FCT_CLOS_EXCEPTION (
    DAYID                         DATE                NOT NULL,
    EXCEPTION_BK                  VARCHAR2(64)        NOT NULL,
    APPLICATION_SK                NUMBER              NOT NULL,
    EXCEPTION_SK                  NUMBER              NOT NULL,
    USER_SK                       NUMBER              NOT NULL,
    CUSTOMER_SK                   NUMBER              NOT NULL,
    WI_NAME                       VARCHAR2(100)       NOT NULL,
    EXCEPTION_CATEGORY            VARCHAR2(500)       NOT NULL,
    RAISED_BY                     VARCHAR2(100)       NOT NULL,
    RAISED_DATE_TIME              TIMESTAMP           NOT NULL,
    EXCEPTION_NAME                VARCHAR2(500)       ,
    EXCEPTION_REMARKS             VARCHAR2(4000)      ,
    RCTYPE                        VARCHAR2(20)        ,

	CONSTRAINT FCT_CLOS_EXCEPTION_PK PRIMARY KEY (EXCEPTION_BK, DAYID) USING INDEX LOCAL
)
PARTITION BY RANGE (DAYID)
INTERVAL (NUMTODSINTERVAL(1, 'DAY'))
(
    PARTITION FCT_CLOS_EXCEPTION_P0 VALUES LESS THAN (
        TO_DATE(' 2008-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')
    )
);

COMMIT;

-- ============================================================
-- SB_DWH_FCT_CLOS_LEGAL_PARTY.sql
-- ============================================================
CREATE TABLE SB_DWH.FCT_CLOS_LEGAL_PARTY (
    DAYID                         DATE                NOT NULL,
    LEGAL_PARTY_BK                VARCHAR2(64)        NOT NULL,
    CUSTOMER_SK                   NUMBER              NOT NULL,
    APPLICATION_SK                NUMBER              NOT NULL,
    WI_NAME                       VARCHAR2(100)       NOT NULL,
    ID_NUMBER                     VARCHAR2(100)       NOT NULL,
    FULL_NAME                     VARCHAR2(200)       ,
    OBJ_TYPE                      VARCHAR2(100)       ,
    LEGAL_DOC                     VARCHAR2(100)       ,

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

-- ============================================================
-- SB_DWH_FCT_CLOS_WORKSTEP_EVENT.sql
-- ============================================================
CREATE TABLE SB_DWH.FCT_CLOS_WORKSTEP_EVENT (
    DAYID                         DATE                NOT NULL,
    WORKSTEP_EVENT_BK             VARCHAR2(64)        NOT NULL,
    WORKSTEP_DECISION_SK          NUMBER              NOT NULL,
    USER_SK                       NUMBER              NOT NULL,
    APPLICATION_SK                NUMBER              NOT NULL,
    CUSTOMER_SK                   NUMBER              NOT NULL,
    WI_NAME                       VARCHAR2(100)       NOT NULL,
    WORKSTEP_CODE                 VARCHAR2(200)       NOT NULL,
    ENTRYDATE                     TIMESTAMP           NOT NULL,
    EXITDATE                      TIMESTAMP           ,
    USERNAME                      VARCHAR2(100)       ,
    REMARKS                       VARCHAR2(4000)      ,
    TAT_SOURCE_SEC                NUMBER(12)          ,
    TAT_CALENDAR_HOUR             NUMBER(18,6)        ,
    TAT_WORKING_HOUR              NUMBER(18,6)        ,
    TAT_CPC_HOUR                  NUMBER(18,6)        ,
    EVENT_SEQ_ASC                 NUMBER(5)           ,
    PROCESSED_DATE                DATE                ,
    WF_PROCESSNAME                VARCHAR2(50)        ,
    WF_ACTIVITYNAME               VARCHAR2(200)       ,
    WF_CREATEDBY                  VARCHAR2(50)        ,
    FIRST_APPROVED_DATE           DATE                ,

	CONSTRAINT FCT_CLOS_WORKSTEP_EVENT_PK PRIMARY KEY (WORKSTEP_EVENT_BK, DAYID) USING INDEX LOCAL
)
PARTITION BY RANGE (DAYID)
INTERVAL (NUMTODSINTERVAL(1, 'DAY'))
(
    PARTITION FCT_CLOS_WORKSTEP_EVENT_P0 VALUES LESS THAN (
        TO_DATE(' 2008-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')
    )
);

COMMIT;

-- ============================================================
-- SB_DWH_FCT_RLOS_APPLICATION_SECONDPRODUCT.sql
-- ============================================================
CREATE TABLE SB_DWH.FCT_RLOS_APPLICATION_SECONDPRODUCT (
    DAYID                         DATE                NOT NULL,
    SUB_PRODUCT_BK                VARCHAR2(64)        NOT NULL,
    APPLICATION_SK                NUMBER              NOT NULL,
    SECONDPRODUCT_SK              NUMBER              NOT NULL,
    WI_NAME                       VARCHAR2(100)       ,
    SUB_PRODUCT_LINE              VARCHAR2(200)       ,
    SPP_AMOUNT                    NUMBER(20,2)        ,
    SPP_TERM                      NUMBER(5)           ,
    CARD_TYPE_CODE                VARCHAR2(100)       ,

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
    WI_NAME                       VARCHAR2(100)       NOT NULL,
    PROCESSED_DATE                DATE                ,
    CREATION_DATE                 DATE                ,
    APPROVED_AMT_FINAL            NUMBER(20,2)        ,
    APPROVED_TERM                 NUMBER(5)           ,
    CURRENCY_CODE                 VARCHAR2(10)        ,
    UNDERWRITERMAKER_USERMAKE     VARCHAR2(100)       ,
    UNDERWRITERCHECKER_USERMAKE   VARCHAR2(100)       ,
    APPROVAL_USERMAKE             VARCHAR2(100)       ,
    CHANGE_REQUEST                VARCHAR2(200)       ,
    CHANGE_TYPE                   VARCHAR2(500)       ,

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

-- ============================================================
-- SB_DWH_FCT_RLOS_COLLATERAL.sql
-- ============================================================
-- DROP TABLE SB_DWH.FCT_RLOS_COLLATERAL
CREATE TABLE SB_DWH.FCT_RLOS_COLLATERAL (
    DAYID                         DATE                NOT NULL,
    COLLATERAL_BK                 VARCHAR2(64)        NOT NULL,
    APPLICATION_SK                NUMBER              NOT NULL,
    WI_NAME                       VARCHAR2(100)       NOT NULL,
    COLLATERAL_TYPE_CODE          VARCHAR2(100)       ,
    CERTIFICATE_NO                VARCHAR2(500)       ,
    DESCRIPTION                   VARCHAR2(4000)      ,
    OWNER_NAME                    VARCHAR2(200)       ,
    REL_TO_CUSTOMER               VARCHAR2(200)       ,
    USING_PURPOSE                 VARCHAR2(255)       ,
    VEHICLE_TYPE                  VARCHAR2(100)       ,
    BRAND                         VARCHAR2(200)       ,
    CONTROL_POSTER                VARCHAR2(100)       ,
    VALPAPER_TYPE                 VARCHAR2(100)       ,
    NUMBERSIGN                    VARCHAR2(200)       ,
    IS_ASSET_FORMED               VARCHAR2(10)        ,
    IS_FORMED_FROM_LOAN           VARCHAR2(100)       ,
    APPRAISED_VALUE               NUMBER(20,2)        ,
    LOAN_RATE_LTV                 NUMBER(5,2)         ,
    TYPES_OF_COLLATERALS          VARCHAR2(500)       

	CONSTRAINT FCT_RLOS_COLLATERAL_PK PRIMARY KEY (COLLATERAL_BK, DAYID) USING INDEX LOCAL
)
PARTITION BY RANGE (DAYID)
INTERVAL (NUMTODSINTERVAL(1, 'DAY'))
(
    PARTITION FCT_RLOS_COLLATERAL_P0 VALUES LESS THAN (
        TO_DATE(' 2008-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')
    )
);

COMMIT;

-- ============================================================
-- SB_DWH_FCT_RLOS_COREPAYER.sql
-- ============================================================
-- ===========================================================================
-- DROP TABLE SB_DWH.FCT_RLOS_COREPAYER
CREATE TABLE SB_DWH.FCT_RLOS_COREPAYER (
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

	CONSTRAINT FCT_RLOS_COREPAYER_PK PRIMARY KEY (COREPAYER_BK, DAYID) USING INDEX LOCAL
)
PARTITION BY RANGE (DAYID)
INTERVAL (NUMTODSINTERVAL(1, 'DAY'))
(
    PARTITION FCT_RLOS_COREPAYER_P0 VALUES LESS THAN (
        TO_DATE(' 2008-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')
    )
);

COMMIT;

-- ============================================================
-- SB_DWH_FCT_RLOS_CUSTOMER.sql
-- ============================================================
-- ===========================================================================
-- DROP TABLE SB_DWH.FCT_RLOS_CUSTOMER
CREATE TABLE SB_DWH.FCT_RLOS_CUSTOMER (
    DAYID                         DATE                NOT NULL,
    CUSTOMER_BK                   VARCHAR2(64)        NOT NULL,
    APPLICATION_SK                NUMBER              NOT NULL,
    T24_CUSTOMER_SK               NUMBER              NOT NULL,
    WI_NAME                       VARCHAR2(100)       ,
    ID_TYPE                       VARCHAR2(50)        ,
    ID_NUMBER                     VARCHAR2(100)       ,
    ISSUE_DATE                    DATE                ,
    EXPIRY_DATE                   DATE                ,
    ISSUE_PLACE                   VARCHAR2(200)       ,
    ISSUE_DATE_VISA               DATE                ,
    EXPIRY_DATE_VISA              DATE                ,
    CUST_CLASS                    VARCHAR2(200)       ,
    IS_FETCH                      VARCHAR2(200)       ,
    CIF                           VARCHAR2(50)        ,
    FULL_NAME                     VARCHAR2(200)       ,
    DATE_OF_BIRTH                 DATE                ,
    GENDER                        VARCHAR2(20)        ,
    NATIONALITY                   VARCHAR2(100)       ,
    TITLE                         VARCHAR2(50)        ,
    HOME_PHONE                    VARCHAR2(50)        ,
    PHONE_1                       VARCHAR2(50)        ,
    PHONE_2                       VARCHAR2(50)        ,
    MARRIAGE_STATUS               VARCHAR2(100)       ,
    EDUCATION_LEVEL               VARCHAR2(100)       ,
    VEHICLE                       VARCHAR2(100)       ,
    PERM_ADDRESS                  VARCHAR2(500)       ,
    CURR_HOUSE_NO                 VARCHAR2(200)       ,
    CURR_WARD                     VARCHAR2(100)       ,
    CITY_CODE                     VARCHAR2(50)        ,
    CITY_NAME                     VARCHAR2(200)       ,
    CITY_NAME_VN                  VARCHAR2(200)       ,
    DISTRICT_CODE                 VARCHAR2(50)        ,
    DISTRICT_NAME                 VARCHAR2(200)       ,
    DISTRICT_NAME_VN              VARCHAR2(200)       ,
    CUS_SEGMENT                   VARCHAR2(100)       ,

	CONSTRAINT FCT_RLOS_CUSTOMER_PK PRIMARY KEY (CUSTOMER_BK, DAYID) USING INDEX LOCAL
)
PARTITION BY RANGE (DAYID)
INTERVAL (NUMTODSINTERVAL(1, 'DAY'))
(
    PARTITION FCT_RLOS_CUSTOMER_P0 VALUES LESS THAN (
        TO_DATE(' 2008-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')
    )
);

COMMIT;

-- ============================================================
-- SB_DWH_FCT_RLOS_DEVIATION.sql
-- ============================================================
-- DROP TABLE SB_DWH.FCT_RLOS_DEVIATION
CREATE TABLE SB_DWH.FCT_RLOS_DEVIATION (
    DAYID                         DATE                NOT NULL,
    DEVIATION_BK                  VARCHAR2(64)        NOT NULL,
    APPLICATION_SK                NUMBER              NOT NULL,
    WI_NAME                       VARCHAR2(100)       NOT NULL,
    CHECKING_CONDITION            VARCHAR2(500)       ,
    CHECKING_RESULT               VARCHAR2(200)       ,
    DEVIATION_REASON              VARCHAR2(4000)      ,
    PROCESSED_DATE                DATE  ,              

	CONSTRAINT FCT_RLOS_DEVIATION_PK PRIMARY KEY (DEVIATION_BK, DAYID) USING INDEX LOCAL
)
PARTITION BY RANGE (DAYID)
INTERVAL (NUMTODSINTERVAL(1, 'DAY'))
(
    PARTITION FCT_RLOS_DEVIATION_P0 VALUES LESS THAN (
        TO_DATE(' 2008-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')
    )
);

COMMIT;

-- ============================================================
-- SB_DWH_FCT_RLOS_EXCEPTION.sql
-- ============================================================
-- ===========================================================================
-- DROP TABLE SB_DWH.FCT_RLOS_EXCEPTION
CREATE TABLE SB_DWH.FCT_RLOS_EXCEPTION (
    DAYID                         DATE                NOT NULL,
    EXCEPTION_BK                  VARCHAR2(64)        NOT NULL,
    APPLICATION_SK                NUMBER              NOT NULL,
    EXCEPTION_SK                  NUMBER              NOT NULL,
    USER_SK                       NUMBER              NOT NULL,
    WI_NAME                       VARCHAR2(100)       NOT NULL,
    EXCEPTION_CATEGORY            VARCHAR2(500)       NOT NULL,
    RAISED_BY                     VARCHAR2(100)       NOT NULL,
    RAISED_DATE_TIME              TIMESTAMP           NOT NULL,
    EXCEPTION_NAME                VARCHAR2(500)       ,
    EXCEPTION_REMARKS             VARCHAR2(4000)      ,
    RCTYPE                        VARCHAR2(20)        ,
    SUB_PRODUCT                   VARCHAR2(255)       ,

	CONSTRAINT FCT_RLOS_EXCEPTION_PK PRIMARY KEY (EXCEPTION_BK, DAYID) USING INDEX LOCAL
)
PARTITION BY RANGE (DAYID)
INTERVAL (NUMTODSINTERVAL(1, 'DAY'))
(
    PARTITION FCT_RLOS_EXCEPTION_P0 VALUES LESS THAN (
        TO_DATE(' 2008-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')
    )
);

COMMIT;

-- ============================================================
-- SB_DWH_FCT_RLOS_WORKSTEP_EVENT.sql
-- ============================================================
-- ===========================================================================
-- DROP TABLE SB_DWH.FCT_RLOS_WORKSTEP_EVENT
CREATE TABLE SB_DWH.FCT_RLOS_WORKSTEP_EVENT (
    DAYID                         DATE                NOT NULL,
    WORKSTEP_EVENT_BK             VARCHAR2(64)        NOT NULL,
    WORKSTEP_DECISION_SK          NUMBER              NOT NULL,
    USER_SK                       NUMBER              NOT NULL,
    APPLICATION_SK                NUMBER              NOT NULL,
    WI_NAME                       VARCHAR2(100)       NOT NULL,
    WORKSTEP_CODE                 VARCHAR2(200)       NOT NULL,
    ENTRYDATE                     TIMESTAMP           NOT NULL,
    EXITDATE                      TIMESTAMP           ,
    USERNAME                      VARCHAR2(100)       ,
    REMARKS                       VARCHAR2(4000)      ,
    REASON_CODE                   VARCHAR2(50)        ,
    REASON_DESC                   VARCHAR2(500)       ,
    TAT_SOURCE_SEC                NUMBER(12)          ,
    TAT_CALENDAR_HOUR             NUMBER(18,6)        ,
    TAT_WORKING_HOUR              NUMBER(18,6)        ,
    TAT_CPC_HOUR                  NUMBER(18,6)        ,
    EVENT_SEQ_ASC                 NUMBER(5)           ,
    PROCESSED_DATE                DATE                ,
    WF_PROCESSNAME                VARCHAR2(50)        ,
    WF_ACTIVITYNAME               VARCHAR2(200)       ,
    WF_CREATEDBY                  VARCHAR2(50)        ,

	CONSTRAINT FCT_RLOS_WORKSTEP_EVENT_PK PRIMARY KEY (WORKSTEP_EVENT_BK, DAYID) USING INDEX LOCAL
)
PARTITION BY RANGE (DAYID)
INTERVAL (NUMTODSINTERVAL(1, 'DAY'))
(
    PARTITION FCT_RLOS_WORKSTEP_EVENT_P0 VALUES LESS THAN (
        TO_DATE(' 2008-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')
    )
);

COMMIT;
