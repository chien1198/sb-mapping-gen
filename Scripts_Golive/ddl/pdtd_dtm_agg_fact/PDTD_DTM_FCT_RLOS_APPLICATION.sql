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
    WI_NAME                       NVARCHAR2(70)       NOT NULL,
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
    CURRENCY_CODE                 NVARCHAR2(100)        ,
    UNDERWRITERMAKER_USERMAKE     VARCHAR2(100)       ,
    UNDERWRITERCHECKER_USERMAKE   VARCHAR2(100)       ,
    APPROVAL_USERMAKE             VARCHAR2(100)       ,
    CHANGE_REQUEST                NVARCHAR2(50)       ,
    CHANGE_TYPE                   NVARCHAR2(255)       ,
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
