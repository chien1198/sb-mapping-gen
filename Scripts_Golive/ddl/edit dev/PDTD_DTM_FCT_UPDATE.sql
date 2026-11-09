-- ============================================================
-- PDTD_DTM_FCT_UPDATE.sql
-- UPDATE DDL tren DEV cho 6 bang FCT cua PDTD_DTM:
--   FCT_CLOS_APPLICATION     : bo cot CREDIT_LIMIT_COMMITTEE;
--                              them MIN_APP_EXITDATE, FIRST_DDE_SUBMIT_DATE, FIRST_WORKSTEP_RETURN
--   FCT_RLOS_APPLICATION     : bo cot CANCEL_DATE;
--                              them MIN_APP_EXITDATE, FIRST_DDE_SUBMIT_DATE, FIRST_WORKSTEP_RETURN
--   FCT_CLOS_EXCEPTION       : WORKSTEP_CODE NOT NULL; PK (DAYID, EXCEPTION_BK, WORKSTEP_CODE);
--                              bo cot EXCEPTION_SK, DECISION_CODE
--   FCT_RLOS_EXCEPTION       : WORKSTEP_CODE NOT NULL; PK (DAYID, EXCEPTION_BK, WORKSTEP_CODE)
--   FCT_CLOS_WORKSTEP_EVENT  : bo cot APPROVAL_FLAG
--   FCT_RLOS_WORKSTEP_EVENT  : bo cot APPROVAL_FLAG
-- Phan 1: DROP TABLE. Phan 2: CREATE TABLE. Phan 3: GRANT SELECT cho U_RISK_DTM_FSSC.
-- CHU Y: chay script nay se XOA SACH DU LIEU hien co trong 6 bang tren
-- (DROP TABLE). Can chay lai ETL de nap lai du lieu. Rieng 2 bang APPLICATION:
-- cac cot carry-forward (HAS_*_FLAG, MIN_*, FIRST_*, *_USER, LAST_*...) doc tu
-- snapshot ngay truoc cua chinh bang nay, nen phai chay lai ETL lan luot tung ngay
-- tu ngay bat dau thi moi dung lai duoc gia tri lich su.
-- ============================================================

-- ================================================================
-- 1. DROP TABLE
-- ================================================================
DROP TABLE PDTD_DTM.FCT_CLOS_APPLICATION;
DROP TABLE PDTD_DTM.FCT_CLOS_EXCEPTION;
DROP TABLE PDTD_DTM.FCT_CLOS_WORKSTEP_EVENT;
DROP TABLE PDTD_DTM.FCT_RLOS_APPLICATION;
DROP TABLE PDTD_DTM.FCT_RLOS_EXCEPTION;
DROP TABLE PDTD_DTM.FCT_RLOS_WORKSTEP_EVENT;

-- ================================================================
-- 2. CREATE TABLE
-- ================================================================
-- FCT_CLOS_APPLICATION
CREATE TABLE PDTD_DTM.FCT_CLOS_APPLICATION (
    DAYID                         DATE                NOT NULL,
    APPLICATION_SK                NUMBER,
    WORKSTEP_DECISION_SK          NUMBER,
    WORKSTEP_CODE                 VARCHAR2(200)       ,
    DECISION_CODE                 VARCHAR2(200)       ,
    PRODUCTLINE_SK                NUMBER,
    PRODUCTLINE_CODE              VARCHAR2(100)       ,
    SUB_PRODUCT_SK                NUMBER,
    SUB_PRODUCT_CODE              VARCHAR2(100)       ,
    COMPANY_SK                    NUMBER,
    COMPANY_CODE                  VARCHAR2(50)        ,
    CUSTOMER_SK                   NUMBER,
    CUSTOMER_CODE                 VARCHAR2(100)       ,
    T24_CUSTOMER_SK               NUMBER              ,
    T24_CUSTOMER_CODE             VARCHAR2(50)        ,
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
    APPROVED_AMT_FINAL            NUMBER(20,2)        ,
    APPROVED_TERM                 NVARCHAR2(100)      ,
    INTEREST_RATE_PCT             NVARCHAR2(500)      ,
    CURRENCY_CODE                 NVARCHAR2(100)      ,
    APPLICATION_LINK_INFO         VARCHAR2(200)       ,
    UNDERWRITERMAKER_USERMAKE     VARCHAR2(100)       ,
    UNDERWRITERCHECKER_USERMAKE   VARCHAR2(100)       ,
    APPROVAL_USERMAKE             VARCHAR2(100)       ,
    LG_REQ                        NVARCHAR2(100)      ,
    FI_REQ                        NVARCHAR2(100)      ,
    PHONE_REQ                     NVARCHAR2(100)      ,
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
    HAS_DDE_FLAG                  VARCHAR2(1)         ,
    HAS_UWM_FLAG                  VARCHAR2(1)         ,
    HAS_UWC_FLAG                  VARCHAR2(1)         ,
    HAS_APPROVAL_FLAG             VARCHAR2(1)         ,
    HAS_FINAL_APPROVAL_FLAG       VARCHAR2(1)         ,
    HAS_CANCELLED_FLAG            VARCHAR2(1)         ,
    TIME_UPDATE                   TIMESTAMP           ,
    MIN_APP_EXITDATE              TIMESTAMP           ,
    FIRST_DDE_SUBMIT_DATE         TIMESTAMP           ,
    FIRST_WORKSTEP_RETURN         VARCHAR2(200)       ,

	CONSTRAINT FCT_CLOS_APPLICATION_PK PRIMARY KEY (WI_NAME, DAYID) USING INDEX LOCAL
)
PARTITION BY RANGE (DAYID)
INTERVAL (NUMTODSINTERVAL(1, 'DAY'))
(
    PARTITION FCT_CLOS_APPLICATION_P0 VALUES LESS THAN (
        TO_DATE(' 2008-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')
    )
);

-- FCT_CLOS_EXCEPTION
CREATE TABLE PDTD_DTM.FCT_CLOS_EXCEPTION (
    DAYID                         DATE                NOT NULL,
    EXCEPTION_BK                  VARCHAR2(64)        NOT NULL,
    APPLICATION_SK                NUMBER,
    WORKSTEP_CODE                 VARCHAR2(200)       NOT NULL,
    USER_SK                       NUMBER,
    USERNAME                      VARCHAR2(150)       ,
    CUSTOMER_SK                   NUMBER,
    CUSTOMER_CODE                 VARCHAR2(100)       ,
    WI_NAME                       VARCHAR2(100)       NOT NULL,
    EXCEPTION_CATEGORY            VARCHAR2(500)       ,
    RAISED_BY                     VARCHAR2(100)       NOT NULL,
    RAISED_DATE_TIME              TIMESTAMP           NOT NULL,
    EXCEPTION_NAME                VARCHAR2(500)       ,
    EXCEPTION_REMARKS             VARCHAR2(4000)      ,
    RCTYPE                        VARCHAR2(20)        ,
    CHECK_FTR                     VARCHAR2(20)        ,
    FIRST_WORKSTEP_RETURN         VARCHAR2(200)       ,
    PHAN_LOAI_DDE                 VARCHAR2(100)       ,
    TIME_UPDATE                   TIMESTAMP           ,

	CONSTRAINT FCT_CLOS_EXCEPTION_PK PRIMARY KEY (DAYID, EXCEPTION_BK, WORKSTEP_CODE) USING INDEX LOCAL
)
PARTITION BY RANGE (DAYID)
INTERVAL (NUMTODSINTERVAL(1, 'DAY'))
(
    PARTITION FCT_CLOS_EXCEPTION_P0 VALUES LESS THAN (
        TO_DATE(' 2008-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')
    )
);

-- FCT_CLOS_WORKSTEP_EVENT
CREATE TABLE PDTD_DTM.FCT_CLOS_WORKSTEP_EVENT (
    DAYID                         DATE                NOT NULL,
    WORKSTEP_EVENT_BK             VARCHAR2(64)        NOT NULL,
    WORKSTEP_DECISION_SK          NUMBER,
    WORKSTEP_CODE                 VARCHAR2(200),
    DECISION_CODE                 VARCHAR2(200)       ,
    APPLICATION_SK                NUMBER,
    WI_NAME                       VARCHAR2(100)       NOT NULL,
    CUSTOMER_SK                   NUMBER,
    CUSTOMER_CODE                 VARCHAR2(100)       ,
    USER_SK                       NUMBER,
    ENTRYDATE                     TIMESTAMP,
    EXITDATE                      TIMESTAMP           ,
    USERNAME                      VARCHAR2(100)       ,
    REMARKS                       VARCHAR2(4000)      ,
    TAT_SOURCE_SEC                NUMBER(12)          ,
    TAT_CALENDAR_HOUR             NUMBER(18,6)        ,
    TAT_WORKING_HOUR              NUMBER(18,6)        ,
    TAT_CPC_HOUR                  NUMBER(18,6)        ,
    PROCESSED_DATE                DATE                ,
    WF_PROCESSNAME                VARCHAR2(50)        ,
    WF_ACTIVITYNAME               VARCHAR2(200)       ,
    WF_CREATEDBY                  VARCHAR2(50)        ,
    APPROVED_DATE           DATE                ,
    WORKSTEP_FLAG                 VARCHAR2(200)       ,
    UNDERWRITERMAKER_USERMAKE     VARCHAR2(100)       ,
    UNDERWRITERCHECKER_USERMAKE   VARCHAR2(100)       ,
    APPROVAL_USERMAKE             VARCHAR2(100)       ,
    TIME_UPDATE                   TIMESTAMP           ,

	CONSTRAINT FCT_CLOS_WORKSTEP_EVENT_PK PRIMARY KEY (WORKSTEP_EVENT_BK, DAYID) USING INDEX LOCAL
)
PARTITION BY RANGE (DAYID)
INTERVAL (NUMTODSINTERVAL(1, 'DAY'))
(
    PARTITION FCT_CLOS_WORKSTEP_EVENT_P0 VALUES LESS THAN (
        TO_DATE(' 2008-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')
    )
);

-- FCT_RLOS_APPLICATION
CREATE TABLE PDTD_DTM.FCT_RLOS_APPLICATION (
    DAYID                         DATE                NOT NULL,
    APPLICATION_SK                NUMBER,
    WORKSTEP_DECISION_SK          NUMBER,
    WORKSTEP_CODE                 VARCHAR2(200)       ,
    DECISION_CODE                 VARCHAR2(200)       ,
    SUB_PRODUCT_SK                NUMBER,
    PRODUCTLINE_CODE              VARCHAR2(100)       ,
    SUB_PRODUCT_CODE              VARCHAR2(100)       ,
    COMPANY_SK                    NUMBER,
    COMPANY_CODE                  VARCHAR2(50)        ,
    CHANGE_TYPE_SK                NUMBER,
    CHANGE_TYPE_CODE              VARCHAR2(100)       ,
    DETAIL_CHANGE_TYPE_CODE       VARCHAR2(100)       ,
    CARD_PROMOTION_SK             NUMBER,
    PROMOTION_CODE                VARCHAR2(50)        ,
    T24_CARD_SK                   NUMBER,
    T24_SEAB_MAIN_CARD_SK         NUMBER,
    WI_NAME                       VARCHAR2(100)       NOT NULL,
    USER_SK                       NUMBER,
    BRANCH_USER                   VARCHAR2(100)       ,
    DDE_USER                      VARCHAR2(100)       ,
    QC_USER                       VARCHAR2(100)       ,
    UND_MAKER_USER                VARCHAR2(100)       ,
    UND_CHECKER_USER              VARCHAR2(100)       ,
    PHV_USER                      VARCHAR2(100)       ,
    APPROVER_USER                 VARCHAR2(100)       ,
    PROCESSED_DATE                DATE                ,
    CREATION_DATE                 DATE                ,
    LAST_APPROVAL_DATE            DATE                ,
    MIN_UWM                       TIMESTAMP           ,
    MIN_APP                       TIMESTAMP           ,
    CANCEL_USER_DATE              DATE                ,
    LAST_ENTRYDATE                TIMESTAMP           ,
    LAST_EXITDATE                 TIMESTAMP           ,
    PRE_WORKSTEP_CODE             VARCHAR2(200)       ,
    LAST_REMARKS                  VARCHAR2(4000)      ,
    LAST_REMARK_DDE               VARCHAR2(4000)      ,
    LAST_CAN_REMARKS              VARCHAR2(4000)      ,
    APPROVED_AMT_FINAL            NUMBER(25,2)        ,
    APPROVED_TERM                 NUMBER(15)           ,
    CURRENCY_CODE                 VARCHAR2(10)        ,
    UNDERWRITERMAKER_USERMAKE     VARCHAR2(100)       ,
    UNDERWRITERCHECKER_USERMAKE   VARCHAR2(100)       ,
    APPROVAL_USERMAKE             VARCHAR2(100)       ,
    CHANGE_REQUEST                VARCHAR2(200)       ,
    CHANGE_TYPE                   VARCHAR2(500)       ,
    APPLICATION_STATUS            VARCHAR2(50)        ,
    AUTO_CANCEL_DATE              DATE                ,
    FLAG_AUTO_CANCEL              VARCHAR2(10)        ,
    LAST_WORKSTEP                 VARCHAR2(50)        ,
    BUSINESS_FLOW                 VARCHAR2(50)        ,
    DEVIATION_G3                  VARCHAR2(10)        ,
    REF_PRODUCT                   VARCHAR2(200)       ,
    SLA_CREDIT_OFFICER            NUMBER(10,2)        ,
    SLA_MARKER                    NUMBER(10,2)        ,
    SLA_CHECKER                   NUMBER(10,2)        ,
    SLA_CREDIT_APPROVER           NUMBER(10,2)        ,
    HAS_DDE_FLAG                  VARCHAR2(1)         ,
    HAS_UWM_FLAG                  VARCHAR2(1)         ,
    HAS_UWC_FLAG                  VARCHAR2(1)         ,
    HAS_APPROVAL_FLAG             VARCHAR2(1)         ,
    HAS_FINAL_APPROVAL_FLAG       VARCHAR2(1)         ,
    HAS_CANCELLED_FLAG            VARCHAR2(1)         ,
    TIME_UPDATE                   TIMESTAMP           ,
    MIN_APP_EXITDATE              TIMESTAMP           ,
    FIRST_DDE_SUBMIT_DATE         TIMESTAMP           ,
    FIRST_WORKSTEP_RETURN         VARCHAR2(200)       ,

	CONSTRAINT FCT_RLOS_APPLICATION_PK PRIMARY KEY (WI_NAME, DAYID) USING INDEX LOCAL
)
PARTITION BY RANGE (DAYID)
INTERVAL (NUMTODSINTERVAL(1, 'DAY'))
(
    PARTITION FCT_RLOS_APPLICATION_P0 VALUES LESS THAN (
        TO_DATE(' 2008-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')
    )
);

-- FCT_RLOS_EXCEPTION
CREATE TABLE PDTD_DTM.FCT_RLOS_EXCEPTION (
    DAYID                         DATE                NOT NULL,
    EXCEPTION_BK                  VARCHAR2(64)        NOT NULL,
    APPLICATION_SK                NUMBER,
    WORKSTEP_CODE                 VARCHAR2(200)       NOT NULL,
    USER_SK                       NUMBER,
    USERNAME                      VARCHAR2(150)       ,
    WI_NAME                       VARCHAR2(100)       NOT NULL,
    EXCEPTION_CATEGORY            VARCHAR2(500)       ,
    RAISED_BY                     VARCHAR2(100)       NOT NULL,
    RAISED_DATE_TIME              TIMESTAMP           NOT NULL,
    EXCEPTION_NAME                VARCHAR2(500)       ,
    EXCEPTION_REMARKS             VARCHAR2(4000)      ,
    RCTYPE                        VARCHAR2(20)        ,
    SUB_PRODUCT                   VARCHAR2(255)       ,
    CHECK_FTR                     VARCHAR2(20)        ,
    FIRST_WORKSTEP_RETURN         VARCHAR2(200)       ,
    PHAN_LOAI_DDE                 VARCHAR2(100)       ,
    TIME_UPDATE                   TIMESTAMP           ,

	CONSTRAINT FCT_RLOS_EXCEPTION_PK PRIMARY KEY (DAYID, EXCEPTION_BK, WORKSTEP_CODE) USING INDEX LOCAL
)
PARTITION BY RANGE (DAYID)
INTERVAL (NUMTODSINTERVAL(1, 'DAY'))
(
    PARTITION FCT_RLOS_EXCEPTION_P0 VALUES LESS THAN (
        TO_DATE(' 2008-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')
    )
);

-- FCT_RLOS_WORKSTEP_EVENT
CREATE TABLE PDTD_DTM.FCT_RLOS_WORKSTEP_EVENT (
    DAYID                         DATE                NOT NULL,
    WORKSTEP_EVENT_BK             VARCHAR2(64)        NOT NULL,
    WORKSTEP_DECISION_SK          NUMBER,
    WORKSTEP_CODE                 VARCHAR2(200),
    DECISION_CODE                 VARCHAR2(200)       ,
    APPLICATION_SK                NUMBER,
    WI_NAME                       VARCHAR2(100)       NOT NULL,
    USER_SK                       NUMBER,
    ENTRYDATE                     TIMESTAMP,
    EXITDATE                      TIMESTAMP           ,
    USERNAME                      VARCHAR2(100)       ,
    REMARKS                       VARCHAR2(4000)      ,
    REASON_CODE                   VARCHAR2(50)        ,
    REASON_DESC                   VARCHAR2(500)       ,
    TAT_SOURCE_SEC                NUMBER(12)          ,
    TAT_CALENDAR_HOUR             NUMBER(18,6)        ,
    TAT_WORKING_HOUR              NUMBER(18,6)        ,
    TAT_CPC_HOUR                  NUMBER(18,6)        ,
    PROCESSED_DATE                DATE                ,
    WF_PROCESSNAME                VARCHAR2(50)        ,
    WF_ACTIVITYNAME               VARCHAR2(200)       ,
    WF_CREATEDBY                  VARCHAR2(50)        ,
    WORKSTEP_FLAG                 VARCHAR2(200)       ,
    UNDERWRITERMAKER_USERMAKE     VARCHAR2(100)       ,
    UNDERWRITERCHECKER_USERMAKE   VARCHAR2(100)       ,
    APPROVAL_USERMAKE             VARCHAR2(100)       ,
    TIME_UPDATE                   TIMESTAMP           ,

	CONSTRAINT FCT_RLOS_WORKSTEP_EVENT_PK PRIMARY KEY (WORKSTEP_EVENT_BK, DAYID) USING INDEX LOCAL
)
PARTITION BY RANGE (DAYID)
INTERVAL (NUMTODSINTERVAL(1, 'DAY'))
(
    PARTITION FCT_RLOS_WORKSTEP_EVENT_P0 VALUES LESS THAN (
        TO_DATE(' 2008-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')
    )
);

-- ================================================================
-- 3. GRANT
-- ================================================================
GRANT SELECT ON PDTD_DTM.FCT_CLOS_APPLICATION TO U_RISK_DTM_FSSC;
GRANT SELECT ON PDTD_DTM.FCT_CLOS_EXCEPTION TO U_RISK_DTM_FSSC;
GRANT SELECT ON PDTD_DTM.FCT_CLOS_WORKSTEP_EVENT TO U_RISK_DTM_FSSC;
GRANT SELECT ON PDTD_DTM.FCT_RLOS_APPLICATION TO U_RISK_DTM_FSSC;
GRANT SELECT ON PDTD_DTM.FCT_RLOS_EXCEPTION TO U_RISK_DTM_FSSC;
GRANT SELECT ON PDTD_DTM.FCT_RLOS_WORKSTEP_EVENT TO U_RISK_DTM_FSSC;
