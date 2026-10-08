
/* ----------------------------------------------------------------------
   1. Q_RLOS_REF_WORKSTEP_2SYSTEMS
---------------------------------------------------------------------- */
CREATE TABLE Q_RLOS_REF_WORKSTEP_2SYSTEMS (
    SYSTEM          VARCHAR2(10)    NOT NULL,   
    IDFLOW          VARCHAR2(10),               
    WORKSTEP        VARCHAR2(50)    NOT NULL,   
    BI_WORKSTEP     VARCHAR2(50),               
    DECISION        VARCHAR2(100)               
);

/* ----------------------------------------------------------------------
   2. TMP_REF_COMPANY_REGION_KHDN
---------------------------------------------------------------------- */
CREATE TABLE TMP_REF_COMPANY_REGION_KHDN (
    COMPANY_CODE    VARCHAR2(20)    NOT NULL,   
    TEN_CN_T24 		VARCHAR2(50)    NOT NULL,   
    TRUNG_TAM     	VARCHAR2(50)    NOT NULL,   
    VUNG          	VARCHAR2(50)    NOT NULL,   
    CONSTRAINT PK_REF_COMPANY_REGION_KHDN PRIMARY KEY (COMPANY_CODE)
);

/* ----------------------------------------------------------------------
   3. TMP_REF_COMPANY_REGION_KHCN
---------------------------------------------------------------------- */
CREATE TABLE TMP_REF_COMPANY_REGION_KHCN (
    COMPANY_CODE    VARCHAR2(20)    NOT NULL,   
    DVKD            VARCHAR2(50)    NOT NULL,   
    CHI_NHANH       VARCHAR2(50)    NOT NULL,   
    VUNG            VARCHAR2(30)    NOT NULL,   
    CONSTRAINT PK_REF_COMPANY_REGION_KHCN PRIMARY KEY (COMPANY_CODE)
);

/* ----------------------------------------------------------------------
   4. REF_RLOS_FLOW
---------------------------------------------------------------------- */
CREATE TABLE REF_RLOS_FLOW (
    STREAM          VARCHAR2(200)   NOT NULL,   
    BI_FLOW         VARCHAR2(100)   NOT NULL,   
    CONSTRAINT PK_REF_RLOS_FLOW PRIMARY KEY (STREAM)
);

/* ----------------------------------------------------------------------
   5. REF_CLOS_LEGAL
---------------------------------------------------------------------- */
CREATE TABLE REF_CLOS_LEGAL (
    OBJ_TYPE        VARCHAR2(50)    NOT NULL,   
    LEGAL_TYPE      VARCHAR2(50)    NOT NULL,   
    CONSTRAINT PK_REF_CLOS_LEGAL PRIMARY KEY (OBJ_TYPE)
);

/* ----------------------------------------------------------------------
   6. REF_PHAN_LOAI_DDE
---------------------------------------------------------------------- */
CREATE TABLE REF_PHAN_LOAI_DDE (
    EXCEPTION_CATEGORY NVARCHAR(255),
    PHAN_LOAI_DDE NVARCHAR(100),
    SYSTEMNAME VARCHAR(50)
);



/* ------------------------------------------------------------
   7) Sheet: RLOS_REF_SLA_TDKHCN
   ------------------------------------------------------------ */
CREATE TABLE RLOS_REF_SLA_TDKHCN (
    REF_PRODUCT            NVARCHAR2(200) NOT NULL,
    PRODUCT_LINE            NVARCHAR2(200) NOT NULL,
    CHANGE_TYPE             NVARCHAR2(200),
    DEVIATION_G3            VARCHAR2(10),
    SECONDARY_PRODUCTLINE   VARCHAR2(10),
    SLA_CREDIT_OFFICER      NUMBER(10,2),
    SLA_MARKER              NUMBER(10,2),
    SLA_CHECKER              NUMBER(10,2),
    SLA_CREDIT_APPROVER     NUMBER(10,2),
    APP_GRP                 NVARCHAR2(200) NOT NULL,
    CONSTRAINT UK_RLOS_REF_SLA_TDKHCN UNIQUE (
        REF_PRODUCT, PRODUCT_LINE, CHANGE_TYPE, DEVIATION_G3,
        SECONDARY_PRODUCTLINE, APP_GRP
    )
);

/* ------------------------------------------------------------
   8) Sheet: CLOS_REF_SLA_TDKHDNL
   ------------------------------------------------------------ */
CREATE TABLE CLOS_REF_SLA_TDKHDNL (
    REF_PRODUCT             NVARCHAR2(200) NOT NULL,
    PRODUCT_LINE            NVARCHAR2(200) NOT NULL,
    SUB_PRODUCT             NVARCHAR2(200),
    HAVE_ANY_DEVIATION      NVARCHAR2(200) NOT NULL,
    SLA_CREDIT_OFFICER      NUMBER(10,2),
    SLA_MARKER              NUMBER(10,2),
    SLA_CHECKER             NUMBER(10,2),
    SLA_CREDIT_APPROVER     NUMBER(10,2),
    FLAG_APP_GRP            NVARCHAR2(200) NOT NULL,
    CONSTRAINT UK_CLOS_REF_SLA_TDKHDNL UNIQUE (
        REF_PRODUCT, PRODUCT_LINE, SUB_PRODUCT,
        HAVE_ANY_DEVIATION, FLAG_APP_GRP
    )
);

/* ------------------------------------------------------------
   9) Sheet: CLOS_REF_SLA_TDKHDN_2
   ------------------------------------------------------------ */
CREATE TABLE CLOS_REF_SLA_TDKHDN_2 (
    REF_PRODUCT             NVARCHAR2(200) NOT NULL,
    PRODUCT_LINE            NVARCHAR2(200) NOT NULL,
    SUB_PRODUCT             NVARCHAR2(200),
    HAVE_ANY_DEVIATION      NVARCHAR2(200) NOT NULL,
    SLA_CREDIT_OFFICER      NUMBER(10,2),
    SLA_MARKER              NUMBER(10,2),
    SLA_CHECKER             NUMBER(10,2),
    SLA_CREDIT_APPROVER     NUMBER(10,2),
    FLAG_APP_GRP            NVARCHAR2(200) NOT NULL,
    CONSTRAINT UK_CLOS_REF_SLA_TDKHDN_2 UNIQUE (
        REF_PRODUCT, PRODUCT_LINE, SUB_PRODUCT,
        HAVE_ANY_DEVIATION, FLAG_APP_GRP
    )
);

/* ------------------------------------------------------------
   10) Sheet: REF_SLA_NLTT
   ------------------------------------------------------------ */
CREATE TABLE REF_SLA_NLTT (
    REF_PRODUCT              NVARCHAR2(200) NOT NULL,
    PRODUCT_LINE             NVARCHAR2(200) NOT NULL,
    SUB_PRODUCT              NVARCHAR2(200),
    NEW_CHANGE_REQUEST       NVARCHAR2(200) NOT NULL,
    SLA_DE_RESULT	         NUMBER(10,2),
    SLA_QC_RESULT	         NUMBER(10,2),
    SLA_DE_TOTAL_RESULT		 NUMBER(10,2),
    QD_DDE                   NUMBER(10,2),
    QD_QC                    NUMBER(10,2),
    SYSTEMNAME              VARCHAR2(10) NOT NULL,
    CONSTRAINT UK_REF_SLA_NLTT UNIQUE (
        REF_PRODUCT, PRODUCT_LINE, POLICY, SUB_PRODUCT,
        NEW_CHANGE_REQUEST, SYSTEM_CODE
    )
);
