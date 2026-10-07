-- ============================================================
-- PDTD_DTM_AGG_LOS_KPI_APPLICATION.sql
-- ============================================================
-- ===========================================================================
-- DROP TABLE PDTD_DTM.AGG_LOS_KPI_APPLICATION
CREATE TABLE PDTD_DTM.AGG_LOS_KPI_APPLICATION (
    DAYID                         DATE                NOT NULL,
    DATASOURCE                    VARCHAR2(10)        NOT NULL,
    APPLICATION_BK                VARCHAR2(64)        NOT NULL,
    APPLICATION_SK                NUMBER              NOT NULL,
    PRODUCT_SK                    NUMBER              NOT NULL,
    COMPANY_SK                    NUMBER              NOT NULL,
    WI_NAME                       VARCHAR2(100)       NOT NULL,
    PROCESSED_DATE                DATE                ,
    VOLUME                        NUMBER(5,2)         ,
    POINT                         NUMBER(12,4)        ,
    QUY_DOI                       NUMBER(12,4)        ,
    TAT_APPLICATION_HOUR          NUMBER(18,6)        ,
    TSBD_G2                       VARCHAR2(10)        ,
    INCOM_3                       VARCHAR2(10)        ,
    BUSINESS_INCOM                VARCHAR2(10)        ,
    DEVIATION_G2                  VARCHAR2(10)        ,
    DEVIATION_G3                  VARCHAR2(10)        ,
    IS_TEST_ACCOUNT               VARCHAR2(1)         NOT NULL,
    APPLICATION_LINK_INFO         VARCHAR2(200)       ,

	CONSTRAINT AGG_LOS_KPI_APPLICATION_PK PRIMARY KEY (APPLICATION_BK, DAYID) USING INDEX LOCAL
)
PARTITION BY RANGE (DAYID)
INTERVAL (NUMTODSINTERVAL(1, 'DAY'))
(
    PARTITION AGG_LOS_KPI_APPLICATION_P0 VALUES LESS THAN (
        TO_DATE(' 2008-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')
    )
);

COMMIT;

-- ============================================================
-- PDTD_DTM_AGG_LOS_KPI_USER_YEAR.sql
-- ============================================================
-- ===========================================================================
-- NOTE - CAN CHECK LAI: bang KHONG co cot DAYID -> KHONG partition duoc
--
-- PK hien tai : (USER_YEAR_BK)
-- Khac biet   : 18 bang FCT_/AGG_ con lai deu partition RANGE (DAYID)
--               INTERVAL 1 DAY va PK dung USING INDEX LOCAL. Bang nay
--               khong co DAYID nen de bang thuong, PK dung USING INDEX.
--
-- Can xac nhan: bang la registry luy ke theo nam (1 dong = 1 user x 1 nam),
--               khong phai anh chup theo ngay - dung la khong can DAYID?
--               Neu dung thi co nen doi tien to AGG_ -> REF_ cho dung ban chat?
-- ===========================================================================
-- DROP TABLE PDTD_DTM.AGG_LOS_KPI_USER_YEAR
CREATE TABLE PDTD_DTM.AGG_LOS_KPI_USER_YEAR (
    USER_YEAR_BK                  VARCHAR2(64)        NOT NULL,
    KPI_YEAR                      NUMBER(4)           NOT NULL,
    USERNAME                      VARCHAR2(100)       NOT NULL,
    FIRST_ELIGIBLE_TS             TIMESTAMP           NOT NULL,

	CONSTRAINT AGG_LOS_KPI_USER_YEAR_PK PRIMARY KEY (USER_YEAR_BK) USING INDEX
);

COMMIT;

-- ============================================================
-- PDTD_DTM_AGG_LOS_KPI_YTD_DAILY.sql
-- ============================================================
-- ===========================================================================
-- NOTE - CAN CHECK LAI: PK chi co DAYID
--
-- PK hien tai : (DAYID)
-- Mau chuan   : (<bang>_BK, DAYID)
--
-- Can xac nhan: grain la 1 dong/1 ngay cho toan khoi (RLOS va CLOS la cac
--               nhom cot song song tren cung 1 dong) nen DAYID du lam PK.
--               Dung la khong tach dong theo he/don vi?
-- ===========================================================================
-- DROP TABLE PDTD_DTM.AGG_LOS_KPI_YTD_DAILY
CREATE TABLE PDTD_DTM.AGG_LOS_KPI_YTD_DAILY (
    DAYID                         DATE                NOT NULL,
    SLHS_RLOS                     NUMBER(12)          ,
    SLHS_RLOS_WTD                 NUMBER(14)          ,
    SLHS_RLOS_MTD                 NUMBER(14)          ,
    SLHS_RLOS_QTD                 NUMBER(14)          ,
    SLHS_RLOS_YTD                 NUMBER(14)          ,
    SLGN_RLOS                     NUMBER(12)          ,
    SLGN_RLOS_WTD                 NUMBER(14)          ,
    SLGN_RLOS_MTD                 NUMBER(14)          ,
    SLGN_RLOS_QTD                 NUMBER(14)          ,
    SLGN_RLOS_YTD                 NUMBER(14)          ,
    SLHS_CLOS                     NUMBER(12)          ,
    SLHS_CLOS_WTD                 NUMBER(14)          ,
    SLHS_CLOS_MTD                 NUMBER(14)          ,
    SLHS_CLOS_QTD                 NUMBER(14)          ,
    SLHS_CLOS_YTD                 NUMBER(14)          ,
    SLGN_CLOS                     NUMBER(12)          ,
    SLGN_CLOS_WTD                 NUMBER(14)          ,
    SLGN_CLOS_MTD                 NUMBER(14)          ,
    SLGN_CLOS_QTD                 NUMBER(14)          ,
    SLGN_CLOS_YTD                 NUMBER(14)          ,
    TAT_RLOS_SEC_SUM_HOUR         NUMBER(18,6)        ,
    TAT_RLOS_SEC_SUM_HOUR_WTD     NUMBER(20,6)        ,
    TAT_RLOS_SEC_SUM_HOUR_MTD     NUMBER(20,6)        ,
    TAT_RLOS_SEC_SUM_HOUR_QTD     NUMBER(20,6)        ,
    TAT_RLOS_SEC_SUM_HOUR_YTD     NUMBER(20,6)        ,
    TAT_RLOS_SEC_CASE_CNT         NUMBER(12)          ,
    TAT_RLOS_SEC_CASE_CNT_WTD     NUMBER(14)          ,
    TAT_RLOS_SEC_CASE_CNT_MTD     NUMBER(14)          ,
    TAT_RLOS_SEC_CASE_CNT_QTD     NUMBER(14)          ,
    TAT_RLOS_SEC_CASE_CNT_YTD     NUMBER(14)          ,
    TAT_RLOS_UNSEC_SUM_HOUR       NUMBER(18,6)        ,
    TAT_RLOS_UNSEC_SUM_HOUR_WTD   NUMBER(20,6)        ,
    TAT_RLOS_UNSEC_SUM_HOUR_MTD   NUMBER(20,6)        ,
    TAT_RLOS_UNSEC_SUM_HOUR_QTD   NUMBER(20,6)        ,
    TAT_RLOS_UNSEC_SUM_HOUR_YTD   NUMBER(20,6)        ,
    TAT_RLOS_UNSEC_CASE_CNT       NUMBER(12)          ,
    TAT_RLOS_UNSEC_CASE_CNT_WTD   NUMBER(14)          ,
    TAT_RLOS_UNSEC_CASE_CNT_MTD   NUMBER(14)          ,
    TAT_RLOS_UNSEC_CASE_CNT_QTD   NUMBER(14)          ,
    TAT_RLOS_UNSEC_CASE_CNT_YTD   NUMBER(14)          ,
    TAT_CLOS_SUM_HOUR             NUMBER(18,6)        ,
    TAT_CLOS_SUM_HOUR_WTD         NUMBER(20,6)        ,
    TAT_CLOS_SUM_HOUR_MTD         NUMBER(20,6)        ,
    TAT_CLOS_SUM_HOUR_QTD         NUMBER(20,6)        ,
    TAT_CLOS_SUM_HOUR_YTD         NUMBER(20,6)        ,
    TAT_CLOS_CASE_CNT             NUMBER(12)          ,
    TAT_CLOS_CASE_CNT_WTD         NUMBER(14)          ,
    TAT_CLOS_CASE_CNT_MTD         NUMBER(14)          ,
    TAT_CLOS_CASE_CNT_QTD         NUMBER(14)          ,
    TAT_CLOS_CASE_CNT_YTD         NUMBER(14)          ,
    QUY_DOI_RLOS                  NUMBER(14,4)        ,
    QUY_DOI_RLOS_WTD              NUMBER(16,4)        ,
    QUY_DOI_RLOS_MTD              NUMBER(16,4)        ,
    QUY_DOI_RLOS_QTD              NUMBER(16,4)        ,
    QUY_DOI_RLOS_YTD              NUMBER(16,4)        ,
    QUY_DOI_CLOS                  NUMBER(14,4)        ,
    QUY_DOI_CLOS_WTD              NUMBER(16,4)        ,
    QUY_DOI_CLOS_MTD              NUMBER(16,4)        ,
    QUY_DOI_CLOS_QTD              NUMBER(16,4)        ,
    QUY_DOI_CLOS_YTD              NUMBER(16,4)        ,
    USER_CNT                      NUMBER(8)           ,
    USER_CNT_WTD                  NUMBER(8)           ,
    USER_CNT_MTD                  NUMBER(8)           ,
    USER_CNT_QTD                  NUMBER(8)           ,
    USER_CNT_YTD                  NUMBER(8)           ,

	CONSTRAINT AGG_LOS_KPI_YTD_DAILY_PK PRIMARY KEY (DAYID) USING INDEX LOCAL
)
PARTITION BY RANGE (DAYID)
INTERVAL (NUMTODSINTERVAL(1, 'DAY'))
(
    PARTITION AGG_LOS_KPI_YTD_DAILY_P0 VALUES LESS THAN (
        TO_DATE(' 2008-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')
    )
);

COMMIT;

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

-- ============================================================
-- PDTD_DTM_FCT_CLOS_COLLATERAL.sql
-- ============================================================
CREATE TABLE PDTD_DTM.FCT_CLOS_COLLATERAL (
    DAYID                         DATE                NOT NULL,
    COLLATERAL_BK                 VARCHAR2(64)        NOT NULL,
    APPLICATION_SK                NUMBER              NOT NULL,
    COLLATERAL_TYPE_CODE          VARCHAR2(100)       ,
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
-- PDTD_DTM_FCT_CLOS_DEVIATION.sql
-- ============================================================
CREATE TABLE PDTD_DTM.FCT_CLOS_DEVIATION (
    DAYID                         DATE                NOT NULL,
    DEVIATION_BK                  VARCHAR2(64)        NOT NULL,
    APPLICATION_SK                NUMBER              NOT NULL,
    WI_NAME                       VARCHAR2(100)       NOT NULL,
    DEVIATION_TYPE_CODE           VARCHAR2(300)       ,
    DEV_PROPOSAL                  VARCHAR2(4000)      ,
    AS_REGULAR                    VARCHAR2(4000)      ,
    PROCESSED_DATE                DATE                ,

	CONSTRAINT FCT_CLOS_DEVIATION_PK PRIMARY KEY (DEVIATION_BK, DAYID) USING INDEX LOCAL
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
-- PDTD_DTM_FCT_CLOS_EXCEPTION.sql
-- ============================================================
CREATE TABLE PDTD_DTM.FCT_CLOS_EXCEPTION (
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
    PHAN_LOAI_DDE                 VARCHAR2(100)       ,
    CHECK_FTR                     VARCHAR2(20)        ,
    FIRST_WORKSTEP_RETURN         VARCHAR2(200)       ,

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
-- PDTD_DTM_FCT_CLOS_LEGAL_PARTY.sql
-- ============================================================
CREATE TABLE PDTD_DTM.FCT_CLOS_LEGAL_PARTY (
    DAYID                         DATE                NOT NULL,
    LEGAL_PARTY_BK                VARCHAR2(64)        NOT NULL,
    CUSTOMER_SK                   NUMBER              NOT NULL,
    APPLICATION_SK                NUMBER              NOT NULL,
    WI_NAME                       VARCHAR2(100)       NOT NULL,
    ID_NUMBER                     VARCHAR2(100)       NOT NULL,
    FULL_NAME                     VARCHAR2(200)       ,
    OBJ_TYPE                      VARCHAR2(100)       ,
    LEGAL_DOC                     VARCHAR2(100)       ,
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

-- ============================================================
-- PDTD_DTM_FCT_CLOS_WORKSTEP_EVENT.sql
-- ============================================================
CREATE TABLE PDTD_DTM.FCT_CLOS_WORKSTEP_EVENT (
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
    APPROVAL_FLAG                 VARCHAR2(50)        ,
    WORKSTEP_FLAG                 VARCHAR2(200)       ,

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
-- PDTD_DTM_FCT_RLOS_APPLICATION_SECONDPRODUCT.sql
-- ============================================================
CREATE TABLE PDTD_DTM.FCT_RLOS_APPLICATION_SECONDPRODUCT (
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
-- PDTD_DTM_FCT_RLOS_APPLICATION.sql
-- ============================================================
-- ===========================================================================
-- NOTE - CAN CHECK LAI: PK khong co cot _BK
--
-- PK hien tai : (WI_NAME, DAYID)
-- Mau chuan   : (<bang>_BK, DAYID)
-- Thuc te     : LLD danh key=PK vao WI_NAME thay vi mot cot _BK.
--
-- Can xac nhan: WI_NAME dang dong vai tro business key.
--               Co can bo sung cot <bang>_BK cho nhat quan voi cac bang
--               FCT_ khac hay giu nguyen?
-- ===========================================================================
-- DROP TABLE PDTD_DTM.FCT_RLOS_APPLICATION
CREATE TABLE PDTD_DTM.FCT_RLOS_APPLICATION (
    DAYID                         DATE                NOT NULL,
    APPLICATION_SK                NUMBER              NOT NULL,
    WORKSTEP_DECISION_SK          NUMBER              NOT NULL,
    PRODUCT_SK                    NUMBER              NOT NULL,
    COMPANY_SK                    NUMBER              NOT NULL,
    CHANGE_TYPE_SK                NUMBER              NOT NULL,
    CARD_PROMOTION_SK             NUMBER              NOT NULL,
    T24_CARD_SK                   NUMBER              NOT NULL,
    T24_SEAB_MAIN_CARD_SK         NUMBER              NOT NULL,
    WI_NAME                       VARCHAR2(100)       NOT NULL,
    USER_SK                       NUMBER              NOT NULL,
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
    CANCEL_DATE                   DATE                ,
    LAST_ENTRYDATE                TIMESTAMP           ,
    LAST_EXITDATE                 TIMESTAMP           ,
    PRE_WORKSTEP_CODE             VARCHAR2(200)       ,
    LAST_REMARKS                  VARCHAR2(4000)      ,
    LAST_REMARK_DDE               VARCHAR2(4000)      ,
    LAST_CAN_REMARKS              VARCHAR2(4000)      ,
    APPROVED_AMT_FINAL            NUMBER(20,2)        ,
    APPROVED_TERM                 NUMBER(5)           ,
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
-- PDTD_DTM_FCT_RLOS_COLLATERAL.sql
-- ============================================================
-- DROP TABLE PDTD_DTM.FCT_RLOS_COLLATERAL
CREATE TABLE PDTD_DTM.FCT_RLOS_COLLATERAL (
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
    TYPES_OF_COLLATERALS          VARCHAR2(500)       ,

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
-- PDTD_DTM_FCT_RLOS_COREPAYER.sql
-- ============================================================
-- ===========================================================================
-- DROP TABLE PDTD_DTM.FCT_RLOS_COREPAYER
CREATE TABLE PDTD_DTM.FCT_RLOS_COREPAYER (
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
-- PDTD_DTM_FCT_RLOS_CUSTOMER.sql
-- ============================================================
-- ===========================================================================
-- DROP TABLE PDTD_DTM.FCT_RLOS_CUSTOMER
CREATE TABLE PDTD_DTM.FCT_RLOS_CUSTOMER (
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
-- PDTD_DTM_FCT_RLOS_DEVIATION.sql
-- ============================================================
-- DROP TABLE PDTD_DTM.FCT_RLOS_DEVIATION
CREATE TABLE PDTD_DTM.FCT_RLOS_DEVIATION (
    DAYID                         DATE                NOT NULL,
    DEVIATION_BK                  VARCHAR2(64)        NOT NULL,
    APPLICATION_SK                NUMBER              NOT NULL,
    WI_NAME                       VARCHAR2(100)       NOT NULL,
    CHECKING_CONDITION            VARCHAR2(500)       ,
    CHECKING_RESULT               VARCHAR2(200)       ,
    DEVIATION_REASON              VARCHAR2(4000)      ,
    PROCESSED_DATE                DATE                ,

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
-- PDTD_DTM_FCT_RLOS_EXCEPTION.sql
-- ============================================================
-- ===========================================================================
-- DROP TABLE PDTD_DTM.FCT_RLOS_EXCEPTION
CREATE TABLE PDTD_DTM.FCT_RLOS_EXCEPTION (
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
    PHAN_LOAI_DDE                 VARCHAR2(100)       ,
    CHECK_FTR                     VARCHAR2(20)        ,
    FIRST_WORKSTEP_RETURN         VARCHAR2(200)       ,

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
-- PDTD_DTM_FCT_RLOS_LOAN_DISBURSEMENT.sql
-- ============================================================
-- ===========================================================================
-- NOTE - CAN CHECK LAI: PK khong co cot _BK
--
-- PK hien tai : (CONTRACT, DAYID)
-- Mau chuan   : (<bang>_BK, DAYID)
-- Thuc te     : LLD danh key=PK vao CONTRACT thay vi mot cot _BK.
--
-- Can xac nhan: CONTRACT dang dong vai tro business key.
--               Co can bo sung cot <bang>_BK cho nhat quan voi cac bang
--               FCT_ khac hay giu nguyen?
-- ===========================================================================
-- DROP TABLE PDTD_DTM.FCT_RLOS_LOAN_DISBURSEMENT
CREATE TABLE PDTD_DTM.FCT_RLOS_LOAN_DISBURSEMENT (
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
    APPROVAL_DATE                 DATE                ,

	CONSTRAINT FCT_RLOS_LOAN_DISBURSEMENT_PK PRIMARY KEY (CONTRACT, DAYID) USING INDEX LOCAL
)
PARTITION BY RANGE (DAYID)
INTERVAL (NUMTODSINTERVAL(1, 'DAY'))
(
    PARTITION FCT_RLOS_LOAN_DISBURSEMENT_P0 VALUES LESS THAN (
        TO_DATE(' 2008-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')
    )
);

COMMIT;

-- ============================================================
-- PDTD_DTM_FCT_RLOS_WORKSTEP_EVENT.sql
-- ============================================================
-- ===========================================================================
-- DROP TABLE PDTD_DTM.FCT_RLOS_WORKSTEP_EVENT
CREATE TABLE PDTD_DTM.FCT_RLOS_WORKSTEP_EVENT (
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
    APPROVAL_FLAG                 VARCHAR2(50)        ,
    WORKSTEP_FLAG                 VARCHAR2(200)       ,

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
