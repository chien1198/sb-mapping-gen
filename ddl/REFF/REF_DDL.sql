
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