

/* ------------------------------------------------------------
   1) Sheet: RLOS_REF_SLA_TDKHCN
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
   2) Sheet: CLOS_REF_SLA_TDKHDNL
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
   3) Sheet: CLOS_REF_SLA_TDKHDN_2
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
   4) Sheet: REF_SLA_NLTT
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
