-- PDTD_DTM: tao 14 bang DIM_* (bang + PK + index). Chay 1 lan trong SQL Window (F8).
-- Chua gom: DIM_DATE va 6 bang DIM_T24_* (co trong lld/pdtd_dtm/).
BEGIN
   -- ============================================================
   -- DIM_CLOS_APPLICATION
   -- ============================================================
   EXECUTE IMMEDIATE 'create table PDTD_DTM.DIM_CLOS_APPLICATION
      (
        dimension_key            NUMBER not null,
        application_sk           NUMBER not null,
        wi_name                  VARCHAR2(100),
        loancaseid               VARCHAR2(100),
        stream                   VARCHAR2(200),
        credit_profile           VARCHAR2(50),
        create_employee_code     VARCHAR2(100),
        create_employee_name     VARCHAR2(225),
        creation_date            DATE,
        app_grp                  VARCHAR2(50),
        have_any_deviation       VARCHAR2(10),
        zone                     VARCHAR2(200),
        loan_purpose             VARCHAR2(200),
        email                    VARCHAR2(200),
        distance_branch_customer VARCHAR2(100),
        product_line             VARCHAR2(200),
        sub_product              VARCHAR2(255),
        id_number                VARCHAR2(100),
        channel                  VARCHAR2(200),
        eff_date                 DATE,
        exp_date                 DATE
      )
      tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 1
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )';
   EXECUTE IMMEDIATE 'alter table PDTD_DTM.DIM_CLOS_APPLICATION
        add constraint DIM_CLOS_APPLICATION_PK primary key (DIMENSION_KEY)
        using index
        tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 2
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )';
   EXECUTE IMMEDIATE 'alter index PDTD_DTM.DIM_CLOS_APPLICATION_PK nologging';
   EXECUTE IMMEDIATE 'create index PDTD_DTM.DIM_CLOS_APPLICATION_WI_NAME_IDX on PDTD_DTM.DIM_CLOS_APPLICATION (WI_NAME)
        tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 2
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )
        nologging';
   EXECUTE IMMEDIATE 'create index PDTD_DTM.DIM_CLOS_APPLICATION_EFF_DATE_IDX on PDTD_DTM.DIM_CLOS_APPLICATION (EFF_DATE)
        tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 2
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )
        nologging';
   EXECUTE IMMEDIATE 'create index PDTD_DTM.DIM_CLOS_APPLICATION_EXP_DATE_IDX on PDTD_DTM.DIM_CLOS_APPLICATION (EXP_DATE)
        tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 2
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )
        nologging';
   EXECUTE IMMEDIATE 'create index PDTD_DTM.DIM_CLOS_APPLICATION_APPLICATION_SK_IDX on PDTD_DTM.DIM_CLOS_APPLICATION (APPLICATION_SK)
        tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 2
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )
        nologging';

   -- ============================================================
   -- DIM_CLOS_CUSTOMER
   -- ============================================================
   EXECUTE IMMEDIATE 'create table PDTD_DTM.DIM_CLOS_CUSTOMER
      (
        dimension_key      NUMBER not null,
        customer_sk        NUMBER not null,
        id_number          VARCHAR2(100),
        full_name          VARCHAR2(200),
        cust_group         VARCHAR2(100),
        cust_category      VARCHAR2(200),
        precustgroup       VARCHAR2(100),
        industry_lvl1_code VARCHAR2(200),
        industry_lvl2_code VARCHAR2(200),
        industry_lvl3_code VARCHAR2(200),
        eff_date           DATE,
        exp_date           DATE
      )
      tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 1
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )';
   EXECUTE IMMEDIATE 'alter table PDTD_DTM.DIM_CLOS_CUSTOMER
        add constraint DIM_CLOS_CUSTOMER_PK primary key (DIMENSION_KEY)
        using index
        tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 2
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )';
   EXECUTE IMMEDIATE 'alter index PDTD_DTM.DIM_CLOS_CUSTOMER_PK nologging';
   EXECUTE IMMEDIATE 'create index PDTD_DTM.DIM_CLOS_CUSTOMER_ID_NUMBER_IDX on PDTD_DTM.DIM_CLOS_CUSTOMER (ID_NUMBER)
        tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 2
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )
        nologging';
   EXECUTE IMMEDIATE 'create index PDTD_DTM.DIM_CLOS_CUSTOMER_EFF_DATE_IDX on PDTD_DTM.DIM_CLOS_CUSTOMER (EFF_DATE)
        tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 2
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )
        nologging';
   EXECUTE IMMEDIATE 'create index PDTD_DTM.DIM_CLOS_CUSTOMER_EXP_DATE_IDX on PDTD_DTM.DIM_CLOS_CUSTOMER (EXP_DATE)
        tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 2
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )
        nologging';
   EXECUTE IMMEDIATE 'create index PDTD_DTM.DIM_CLOS_CUSTOMER_CUSTOMER_SK_IDX on PDTD_DTM.DIM_CLOS_CUSTOMER (CUSTOMER_SK)
        tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 2
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )
        nologging';

   -- ============================================================
   -- DIM_CLOS_EXCEPTION
   -- ============================================================
   EXECUTE IMMEDIATE 'create table PDTD_DTM.DIM_CLOS_EXCEPTION
      (
        dimension_key      NUMBER not null,
        exception_sk       NUMBER not null,
        exception_bk       VARCHAR2(64),
        activityname       VARCHAR2(200),
        decision_code      VARCHAR2(200),
        exception_category VARCHAR2(500),
        exception_name     VARCHAR2(500),
        exception_code     VARCHAR2(50),
        raise_flag         VARCHAR2(5),
        clear_flag         VARCHAR2(5),
        id_source          NUMBER,
        code_source        VARCHAR2(255),
        status             VARCHAR2(50),
        eff_date           DATE,
        exp_date           DATE
      )
      tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 1
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )';
   EXECUTE IMMEDIATE 'alter table PDTD_DTM.DIM_CLOS_EXCEPTION
        add constraint DIM_CLOS_EXCEPTION_PK primary key (DIMENSION_KEY)
        using index
        tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 2
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )';
   EXECUTE IMMEDIATE 'alter index PDTD_DTM.DIM_CLOS_EXCEPTION_PK nologging';
   EXECUTE IMMEDIATE 'create index PDTD_DTM.DIM_CLOS_EXCEPTION_EXCEPTION_BK_IDX on PDTD_DTM.DIM_CLOS_EXCEPTION (EXCEPTION_BK)
        tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 2
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )
        nologging';
   EXECUTE IMMEDIATE 'create index PDTD_DTM.DIM_CLOS_EXCEPTION_EFF_DATE_IDX on PDTD_DTM.DIM_CLOS_EXCEPTION (EFF_DATE)
        tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 2
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )
        nologging';
   EXECUTE IMMEDIATE 'create index PDTD_DTM.DIM_CLOS_EXCEPTION_EXP_DATE_IDX on PDTD_DTM.DIM_CLOS_EXCEPTION (EXP_DATE)
        tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 2
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )
        nologging';
   EXECUTE IMMEDIATE 'create index PDTD_DTM.DIM_CLOS_EXCEPTION_EXCEPTION_SK_IDX on PDTD_DTM.DIM_CLOS_EXCEPTION (EXCEPTION_SK)
        tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 2
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )
        nologging';

   -- ============================================================
   -- DIM_CLOS_PRODUCT
   -- ============================================================
   EXECUTE IMMEDIATE 'create table PDTD_DTM.DIM_CLOS_PRODUCT
      (
        dimension_key     NUMBER not null,
        product_sk        NUMBER not null,
        product_bk        VARCHAR2(64),
        product_line_code VARCHAR2(100),
        product_line_name VARCHAR2(200),
        sub_product_code  VARCHAR2(100),
        sub_product_name  VARCHAR2(150),
        eff_date          DATE,
        exp_date          DATE
      )
      tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 1
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )';
   EXECUTE IMMEDIATE 'alter table PDTD_DTM.DIM_CLOS_PRODUCT
        add constraint DIM_CLOS_PRODUCT_PK primary key (DIMENSION_KEY)
        using index
        tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 2
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )';
   EXECUTE IMMEDIATE 'alter index PDTD_DTM.DIM_CLOS_PRODUCT_PK nologging';
   EXECUTE IMMEDIATE 'create index PDTD_DTM.DIM_CLOS_PRODUCT_PRODUCT_BK_IDX on PDTD_DTM.DIM_CLOS_PRODUCT (PRODUCT_BK)
        tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 2
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )
        nologging';
   EXECUTE IMMEDIATE 'create index PDTD_DTM.DIM_CLOS_PRODUCT_EFF_DATE_IDX on PDTD_DTM.DIM_CLOS_PRODUCT (EFF_DATE)
        tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 2
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )
        nologging';
   EXECUTE IMMEDIATE 'create index PDTD_DTM.DIM_CLOS_PRODUCT_EXP_DATE_IDX on PDTD_DTM.DIM_CLOS_PRODUCT (EXP_DATE)
        tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 2
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )
        nologging';
   EXECUTE IMMEDIATE 'create index PDTD_DTM.DIM_CLOS_PRODUCT_PRODUCT_SK_IDX on PDTD_DTM.DIM_CLOS_PRODUCT (PRODUCT_SK)
        tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 2
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )
        nologging';

   -- ============================================================
   -- DIM_CLOS_WORKSTEP_DECISION
   -- ============================================================
   EXECUTE IMMEDIATE 'create table PDTD_DTM.DIM_CLOS_WORKSTEP_DECISION
      (
        dimension_key        NUMBER not null,
        workstep_decision_sk NUMBER not null,
        workstep_decision_bk VARCHAR2(64),
        workstep_code        VARCHAR2(200),
        decision_code        VARCHAR2(200),
        channel              VARCHAR2(200),
        eff_date             DATE,
        exp_date             DATE
      )
      tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 1
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )';
   EXECUTE IMMEDIATE 'alter table PDTD_DTM.DIM_CLOS_WORKSTEP_DECISION
        add constraint DIM_CLOS_WORKSTEP_DECISION_PK primary key (DIMENSION_KEY)
        using index
        tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 2
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )';
   EXECUTE IMMEDIATE 'alter index PDTD_DTM.DIM_CLOS_WORKSTEP_DECISION_PK nologging';
   EXECUTE IMMEDIATE 'create index PDTD_DTM.DIM_CLOS_WORKSTEP_DECISION_WORKSTEP_DECISION_BK_IDX on PDTD_DTM.DIM_CLOS_WORKSTEP_DECISION (WORKSTEP_DECISION_BK)
        tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 2
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )
        nologging';
   EXECUTE IMMEDIATE 'create index PDTD_DTM.DIM_CLOS_WORKSTEP_DECISION_EFF_DATE_IDX on PDTD_DTM.DIM_CLOS_WORKSTEP_DECISION (EFF_DATE)
        tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 2
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )
        nologging';
   EXECUTE IMMEDIATE 'create index PDTD_DTM.DIM_CLOS_WORKSTEP_DECISION_EXP_DATE_IDX on PDTD_DTM.DIM_CLOS_WORKSTEP_DECISION (EXP_DATE)
        tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 2
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )
        nologging';
   EXECUTE IMMEDIATE 'create index PDTD_DTM.DIM_CLOS_WORKSTEP_DECISION_WORKSTEP_DECISION_SK_IDX on PDTD_DTM.DIM_CLOS_WORKSTEP_DECISION (WORKSTEP_DECISION_SK)
        tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 2
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )
        nologging';

   -- ============================================================
   -- DIM_LOS_COMPANY
   -- ============================================================
   EXECUTE IMMEDIATE 'create table PDTD_DTM.DIM_LOS_COMPANY
      (
        dimension_key   NUMBER not null,
        company_sk      NUMBER not null,
        company_code    VARCHAR2(50),
        company_name    VARCHAR2(200),
        company_address VARCHAR2(500),
        company_email   VARCHAR2(200),
        zone            NUMBER,
        branch_code     VARCHAR2(50),
        branch_name     VARCHAR2(200),
        city            VARCHAR2(100),
        district        VARCHAR2(100),
        region_code     NUMBER,
        region_name     VARCHAR2(200),
        eff_date        DATE,
        exp_date        DATE
      )
      tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 1
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )';
   EXECUTE IMMEDIATE 'alter table PDTD_DTM.DIM_LOS_COMPANY
        add constraint DIM_LOS_COMPANY_PK primary key (DIMENSION_KEY)
        using index
        tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 2
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )';
   EXECUTE IMMEDIATE 'alter index PDTD_DTM.DIM_LOS_COMPANY_PK nologging';
   EXECUTE IMMEDIATE 'create index PDTD_DTM.DIM_LOS_COMPANY_COMPANY_CODE_IDX on PDTD_DTM.DIM_LOS_COMPANY (COMPANY_CODE)
        tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 2
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )
        nologging';
   EXECUTE IMMEDIATE 'create index PDTD_DTM.DIM_LOS_COMPANY_EFF_DATE_IDX on PDTD_DTM.DIM_LOS_COMPANY (EFF_DATE)
        tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 2
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )
        nologging';
   EXECUTE IMMEDIATE 'create index PDTD_DTM.DIM_LOS_COMPANY_EXP_DATE_IDX on PDTD_DTM.DIM_LOS_COMPANY (EXP_DATE)
        tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 2
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )
        nologging';
   EXECUTE IMMEDIATE 'create index PDTD_DTM.DIM_LOS_COMPANY_COMPANY_SK_IDX on PDTD_DTM.DIM_LOS_COMPANY (COMPANY_SK)
        tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 2
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )
        nologging';

   -- ============================================================
   -- DIM_LOS_USER
   -- ============================================================
   EXECUTE IMMEDIATE 'create table PDTD_DTM.DIM_LOS_USER
      (
        dimension_key        NUMBER not null,
        user_sk              NUMBER not null,
        username             VARCHAR2(100),
        employee_name        VARCHAR2(200),
        employee_status      VARCHAR2(50),
        email                VARCHAR2(200),
        ip_phone             VARCHAR2(50),
        sb_code              VARCHAR2(50),
        id_customer          VARCHAR2(50),
        company_code         VARCHAR2(50),
        company_name         VARCHAR2(200),
        title                VARCHAR2(100),
        department_code      VARCHAR2(50),
        department_name      VARCHAR2(200),
        uwmaker_group        VARCHAR2(100),
        uwchecker_group      VARCHAR2(100),
        ap_group             VARCHAR2(100),
        predisb_maker_group  VARCHAR2(100),
        predisb_group        VARCHAR2(100),
        disb_maker_group     VARCHAR2(100),
        disb_checker_group   VARCHAR2(100),
        hub                  VARCHAR2(100),
        branch_manager_email VARCHAR2(200),
        eff_date             DATE,
        exp_date             DATE
      )
      tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 1
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )';
   EXECUTE IMMEDIATE 'alter table PDTD_DTM.DIM_LOS_USER
        add constraint DIM_LOS_USER_PK primary key (DIMENSION_KEY)
        using index
        tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 2
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )';
   EXECUTE IMMEDIATE 'alter index PDTD_DTM.DIM_LOS_USER_PK nologging';
   EXECUTE IMMEDIATE 'create index PDTD_DTM.DIM_LOS_USER_USERNAME_IDX on PDTD_DTM.DIM_LOS_USER (USERNAME)
        tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 2
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )
        nologging';
   EXECUTE IMMEDIATE 'create index PDTD_DTM.DIM_LOS_USER_EFF_DATE_IDX on PDTD_DTM.DIM_LOS_USER (EFF_DATE)
        tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 2
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )
        nologging';
   EXECUTE IMMEDIATE 'create index PDTD_DTM.DIM_LOS_USER_EXP_DATE_IDX on PDTD_DTM.DIM_LOS_USER (EXP_DATE)
        tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 2
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )
        nologging';
   EXECUTE IMMEDIATE 'create index PDTD_DTM.DIM_LOS_USER_USER_SK_IDX on PDTD_DTM.DIM_LOS_USER (USER_SK)
        tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 2
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )
        nologging';

   -- ============================================================
   -- DIM_RLOS_APPLICATION
   -- ============================================================
   EXECUTE IMMEDIATE 'create table PDTD_DTM.DIM_RLOS_APPLICATION
      (
        dimension_key        NUMBER not null,
        application_sk       NUMBER not null,
        wi_name              VARCHAR2(100),
        loancaseid           VARCHAR2(100),
        stream               VARCHAR2(200),
        policy               VARCHAR2(200),
        campaign             VARCHAR2(200),
        proof_of_income      VARCHAR2(200),
        coll_require         VARCHAR2(10),
        is_sec_product       VARCHAR2(10),
        deviation_flag       VARCHAR2(10),
        create_employee_code VARCHAR2(50),
        create_employee_name VARCHAR2(200),
        creation_date        DATE,
        application_date     DATE,
        result_main_card_id  VARCHAR2(100),
        app_grp              VARCHAR2(50),
        last_approval_date   DATE,
        customer_name        VARCHAR2(150),
        approval_condition   VARCHAR2(50),
        approver_type        VARCHAR2(100),
        app_status           VARCHAR2(100),
        rmemailid            VARCHAR2(250),
        remarks              VARCHAR2(4000),
        zone                 VARCHAR2(50),
        sale_type            VARCHAR2(100),
        broker_type          VARCHAR2(100),
        broker_id            VARCHAR2(100),
        broker_name          VARCHAR2(200),
        acc_officer          VARCHAR2(100),
        account_officer_name VARCHAR2(200),
        existing_customer    VARCHAR2(10),
        applicant_cif        VARCHAR2(50),
        kyc1                 VARCHAR2(50),
        interest_rate_pct    NUMBER(8,4),
        loan_to_value        NUMBER(5,2),
        loan_objective       VARCHAR2(200),
        total_income         NUMBER(20,2),
        salaryflag           VARCHAR2(10),
        carflag              VARCHAR2(10),
        houseflag            VARCHAR2(10),
        enterprisseflag      VARCHAR2(10),
        divingflag           VARCHAR2(10),
        faimilyflag          VARCHAR2(10),
        nonlicflag           VARCHAR2(10),
        wagesflag            VARCHAR2(10),
        pensionflag          VARCHAR2(10),
        otherflag            VARCHAR2(10),
        product_name         VARCHAR2(200),
        c_phone_create_flag  VARCHAR2(20),
        c_phone_delete_flag  VARCHAR2(10),
        c_fi_create_flag     VARCHAR2(20),
        c_fi_delete_flag     VARCHAR2(10),
        c_legal_create_flag  VARCHAR2(20),
        c_legal_delete_flag  VARCHAR2(10),
        reinitiate           VARCHAR2(5),
        normalbrhold         VARCHAR2(10),
        regbrhold            VARCHAR2(10),
        stp_flag             VARCHAR2(50),
        eligible             VARCHAR2(100),
        totalnoneligible     VARCHAR2(5),
        cancel_reason        VARCHAR2(500),
        eff_date             DATE,
        exp_date             DATE
      )
      tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 1
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )';
   EXECUTE IMMEDIATE 'alter table PDTD_DTM.DIM_RLOS_APPLICATION
        add constraint DIM_RLOS_APPLICATION_PK primary key (DIMENSION_KEY)
        using index
        tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 2
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )';
   EXECUTE IMMEDIATE 'alter index PDTD_DTM.DIM_RLOS_APPLICATION_PK nologging';
   EXECUTE IMMEDIATE 'create index PDTD_DTM.DIM_RLOS_APPLICATION_WI_NAME_IDX on PDTD_DTM.DIM_RLOS_APPLICATION (WI_NAME)
        tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 2
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )
        nologging';
   EXECUTE IMMEDIATE 'create index PDTD_DTM.DIM_RLOS_APPLICATION_EFF_DATE_IDX on PDTD_DTM.DIM_RLOS_APPLICATION (EFF_DATE)
        tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 2
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )
        nologging';
   EXECUTE IMMEDIATE 'create index PDTD_DTM.DIM_RLOS_APPLICATION_EXP_DATE_IDX on PDTD_DTM.DIM_RLOS_APPLICATION (EXP_DATE)
        tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 2
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )
        nologging';
   EXECUTE IMMEDIATE 'create index PDTD_DTM.DIM_RLOS_APPLICATION_APPLICATION_SK_IDX on PDTD_DTM.DIM_RLOS_APPLICATION (APPLICATION_SK)
        tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 2
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )
        nologging';

   -- ============================================================
   -- DIM_RLOS_CARD_PROMOTION
   -- ============================================================
   EXECUTE IMMEDIATE 'create table PDTD_DTM.DIM_RLOS_CARD_PROMOTION
      (
        dimension_key     NUMBER not null,
        card_promotion_sk NUMBER not null,
        promotion_code    VARCHAR2(100),
        promotion_desc    VARCHAR2(500),
        eff_date          DATE,
        exp_date          DATE
      )
      tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 1
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )';
   EXECUTE IMMEDIATE 'alter table PDTD_DTM.DIM_RLOS_CARD_PROMOTION
        add constraint DIM_RLOS_CARD_PROMOTION_PK primary key (DIMENSION_KEY)
        using index
        tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 2
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )';
   EXECUTE IMMEDIATE 'alter index PDTD_DTM.DIM_RLOS_CARD_PROMOTION_PK nologging';
   EXECUTE IMMEDIATE 'create index PDTD_DTM.DIM_RLOS_CARD_PROMOTION_PROMOTION_CODE_IDX on PDTD_DTM.DIM_RLOS_CARD_PROMOTION (PROMOTION_CODE)
        tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 2
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )
        nologging';
   EXECUTE IMMEDIATE 'create index PDTD_DTM.DIM_RLOS_CARD_PROMOTION_EFF_DATE_IDX on PDTD_DTM.DIM_RLOS_CARD_PROMOTION (EFF_DATE)
        tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 2
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )
        nologging';
   EXECUTE IMMEDIATE 'create index PDTD_DTM.DIM_RLOS_CARD_PROMOTION_EXP_DATE_IDX on PDTD_DTM.DIM_RLOS_CARD_PROMOTION (EXP_DATE)
        tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 2
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )
        nologging';
   EXECUTE IMMEDIATE 'create index PDTD_DTM.DIM_RLOS_CARD_PROMOTION_CARD_PROMOTION_SK_IDX on PDTD_DTM.DIM_RLOS_CARD_PROMOTION (CARD_PROMOTION_SK)
        tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 2
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )
        nologging';

   -- ============================================================
   -- DIM_RLOS_CHANGE_TYPE
   -- ============================================================
   EXECUTE IMMEDIATE 'create table PDTD_DTM.DIM_RLOS_CHANGE_TYPE
      (
        dimension_key           NUMBER not null,
        change_type_sk          NUMBER not null,
        change_type_bk          VARCHAR2(64),
        change_type_code        VARCHAR2(100),
        change_type_name        VARCHAR2(200),
        detail_change_type_code VARCHAR2(100),
        detail_change_type_name VARCHAR2(500),
        eff_date                DATE,
        exp_date                DATE
      )
      tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 1
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )';
   EXECUTE IMMEDIATE 'alter table PDTD_DTM.DIM_RLOS_CHANGE_TYPE
        add constraint DIM_RLOS_CHANGE_TYPE_PK primary key (DIMENSION_KEY)
        using index
        tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 2
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )';
   EXECUTE IMMEDIATE 'alter index PDTD_DTM.DIM_RLOS_CHANGE_TYPE_PK nologging';
   EXECUTE IMMEDIATE 'create index PDTD_DTM.DIM_RLOS_CHANGE_TYPE_CHANGE_TYPE_BK_IDX on PDTD_DTM.DIM_RLOS_CHANGE_TYPE (CHANGE_TYPE_BK)
        tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 2
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )
        nologging';
   EXECUTE IMMEDIATE 'create index PDTD_DTM.DIM_RLOS_CHANGE_TYPE_EFF_DATE_IDX on PDTD_DTM.DIM_RLOS_CHANGE_TYPE (EFF_DATE)
        tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 2
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )
        nologging';
   EXECUTE IMMEDIATE 'create index PDTD_DTM.DIM_RLOS_CHANGE_TYPE_EXP_DATE_IDX on PDTD_DTM.DIM_RLOS_CHANGE_TYPE (EXP_DATE)
        tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 2
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )
        nologging';
   EXECUTE IMMEDIATE 'create index PDTD_DTM.DIM_RLOS_CHANGE_TYPE_CHANGE_TYPE_SK_IDX on PDTD_DTM.DIM_RLOS_CHANGE_TYPE (CHANGE_TYPE_SK)
        tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 2
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )
        nologging';

   -- ============================================================
   -- DIM_RLOS_EXCEPTION
   -- ============================================================
   EXECUTE IMMEDIATE 'create table PDTD_DTM.DIM_RLOS_EXCEPTION
      (
        dimension_key      NUMBER not null,
        exception_sk       NUMBER not null,
        exception_bk       VARCHAR2(64),
        activityname       VARCHAR2(200),
        decision_code      VARCHAR2(200),
        exception_category VARCHAR2(500),
        exception_name     VARCHAR2(500),
        exception_code     VARCHAR2(50),
        raise_flag         VARCHAR2(5),
        clear_flag         VARCHAR2(5),
        id_source          NUMBER,
        code_source        VARCHAR2(255),
        status             VARCHAR2(50),
        eff_date           DATE,
        exp_date           DATE
      )
      tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 1
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )';
   EXECUTE IMMEDIATE 'alter table PDTD_DTM.DIM_RLOS_EXCEPTION
        add constraint DIM_RLOS_EXCEPTION_PK primary key (DIMENSION_KEY)
        using index
        tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 2
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )';
   EXECUTE IMMEDIATE 'alter index PDTD_DTM.DIM_RLOS_EXCEPTION_PK nologging';
   EXECUTE IMMEDIATE 'create index PDTD_DTM.DIM_RLOS_EXCEPTION_EXCEPTION_BK_IDX on PDTD_DTM.DIM_RLOS_EXCEPTION (EXCEPTION_BK)
        tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 2
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )
        nologging';
   EXECUTE IMMEDIATE 'create index PDTD_DTM.DIM_RLOS_EXCEPTION_EFF_DATE_IDX on PDTD_DTM.DIM_RLOS_EXCEPTION (EFF_DATE)
        tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 2
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )
        nologging';
   EXECUTE IMMEDIATE 'create index PDTD_DTM.DIM_RLOS_EXCEPTION_EXP_DATE_IDX on PDTD_DTM.DIM_RLOS_EXCEPTION (EXP_DATE)
        tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 2
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )
        nologging';
   EXECUTE IMMEDIATE 'create index PDTD_DTM.DIM_RLOS_EXCEPTION_EXCEPTION_SK_IDX on PDTD_DTM.DIM_RLOS_EXCEPTION (EXCEPTION_SK)
        tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 2
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )
        nologging';

   -- ============================================================
   -- DIM_RLOS_PRODUCT
   -- ============================================================
   EXECUTE IMMEDIATE 'create table PDTD_DTM.DIM_RLOS_PRODUCT
      (
        dimension_key    NUMBER not null,
        product_sk       NUMBER not null,
        product_bk       VARCHAR2(64),
        productline_code VARCHAR2(100),
        productline_name VARCHAR2(200),
        sub_product_code VARCHAR2(100),
        sub_product_name VARCHAR2(150),
        score_required   VARCHAR2(10),
        score_model      VARCHAR2(100),
        eff_date         DATE,
        exp_date         DATE
      )
      tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 1
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )';
   EXECUTE IMMEDIATE 'alter table PDTD_DTM.DIM_RLOS_PRODUCT
        add constraint DIM_RLOS_PRODUCT_PK primary key (DIMENSION_KEY)
        using index
        tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 2
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )';
   EXECUTE IMMEDIATE 'alter index PDTD_DTM.DIM_RLOS_PRODUCT_PK nologging';
   EXECUTE IMMEDIATE 'create index PDTD_DTM.DIM_RLOS_PRODUCT_PRODUCT_BK_IDX on PDTD_DTM.DIM_RLOS_PRODUCT (PRODUCT_BK)
        tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 2
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )
        nologging';
   EXECUTE IMMEDIATE 'create index PDTD_DTM.DIM_RLOS_PRODUCT_EFF_DATE_IDX on PDTD_DTM.DIM_RLOS_PRODUCT (EFF_DATE)
        tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 2
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )
        nologging';
   EXECUTE IMMEDIATE 'create index PDTD_DTM.DIM_RLOS_PRODUCT_EXP_DATE_IDX on PDTD_DTM.DIM_RLOS_PRODUCT (EXP_DATE)
        tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 2
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )
        nologging';
   EXECUTE IMMEDIATE 'create index PDTD_DTM.DIM_RLOS_PRODUCT_PRODUCT_SK_IDX on PDTD_DTM.DIM_RLOS_PRODUCT (PRODUCT_SK)
        tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 2
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )
        nologging';

   -- ============================================================
   -- DIM_RLOS_SECONDPRODUCT
   -- ============================================================
   EXECUTE IMMEDIATE 'create table PDTD_DTM.DIM_RLOS_SECONDPRODUCT
      (
        dimension_key     NUMBER not null,
        secondproduct_sk  NUMBER not null,
        secondproduct_bk  VARCHAR2(64),
        productline_code  VARCHAR2(200),
        productline_name  VARCHAR2(200),
        secondary_product VARCHAR2(200),
        eff_date          DATE,
        exp_date          DATE
      )
      tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 1
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )';
   EXECUTE IMMEDIATE 'alter table PDTD_DTM.DIM_RLOS_SECONDPRODUCT
        add constraint DIM_RLOS_SECONDPRODUCT_PK primary key (DIMENSION_KEY)
        using index
        tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 2
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )';
   EXECUTE IMMEDIATE 'alter index PDTD_DTM.DIM_RLOS_SECONDPRODUCT_PK nologging';
   EXECUTE IMMEDIATE 'create index PDTD_DTM.DIM_RLOS_SECONDPRODUCT_SECONDPRODUCT_BK_IDX on PDTD_DTM.DIM_RLOS_SECONDPRODUCT (SECONDPRODUCT_BK)
        tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 2
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )
        nologging';
   EXECUTE IMMEDIATE 'create index PDTD_DTM.DIM_RLOS_SECONDPRODUCT_EFF_DATE_IDX on PDTD_DTM.DIM_RLOS_SECONDPRODUCT (EFF_DATE)
        tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 2
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )
        nologging';
   EXECUTE IMMEDIATE 'create index PDTD_DTM.DIM_RLOS_SECONDPRODUCT_EXP_DATE_IDX on PDTD_DTM.DIM_RLOS_SECONDPRODUCT (EXP_DATE)
        tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 2
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )
        nologging';
   EXECUTE IMMEDIATE 'create index PDTD_DTM.DIM_RLOS_SECONDPRODUCT_SECONDPRODUCT_SK_IDX on PDTD_DTM.DIM_RLOS_SECONDPRODUCT (SECONDPRODUCT_SK)
        tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 2
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )
        nologging';

   -- ============================================================
   -- DIM_RLOS_WORKSTEP_DECISION
   -- ============================================================
   EXECUTE IMMEDIATE 'create table PDTD_DTM.DIM_RLOS_WORKSTEP_DECISION
      (
        dimension_key        NUMBER not null,
        workstep_decision_sk NUMBER not null,
        workstep_decision_bk VARCHAR2(64),
        workstep_code        VARCHAR2(200),
        decision_code        VARCHAR2(200),
        eff_date             DATE,
        exp_date             DATE
      )
      tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 1
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )';
   EXECUTE IMMEDIATE 'alter table PDTD_DTM.DIM_RLOS_WORKSTEP_DECISION
        add constraint DIM_RLOS_WORKSTEP_DECISION_PK primary key (DIMENSION_KEY)
        using index
        tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 2
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )';
   EXECUTE IMMEDIATE 'alter index PDTD_DTM.DIM_RLOS_WORKSTEP_DECISION_PK nologging';
   EXECUTE IMMEDIATE 'create index PDTD_DTM.DIM_RLOS_WORKSTEP_DECISION_WORKSTEP_DECISION_BK_IDX on PDTD_DTM.DIM_RLOS_WORKSTEP_DECISION (WORKSTEP_DECISION_BK)
        tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 2
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )
        nologging';
   EXECUTE IMMEDIATE 'create index PDTD_DTM.DIM_RLOS_WORKSTEP_DECISION_EFF_DATE_IDX on PDTD_DTM.DIM_RLOS_WORKSTEP_DECISION (EFF_DATE)
        tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 2
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )
        nologging';
   EXECUTE IMMEDIATE 'create index PDTD_DTM.DIM_RLOS_WORKSTEP_DECISION_EXP_DATE_IDX on PDTD_DTM.DIM_RLOS_WORKSTEP_DECISION (EXP_DATE)
        tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 2
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )
        nologging';
   EXECUTE IMMEDIATE 'create index PDTD_DTM.DIM_RLOS_WORKSTEP_DECISION_WORKSTEP_DECISION_SK_IDX on PDTD_DTM.DIM_RLOS_WORKSTEP_DECISION (WORKSTEP_DECISION_SK)
        tablespace PDTD_DTM_TBS
        pctfree 10
        initrans 2
        maxtrans 255
        storage
        (
          initial 64K
          next 1M
          minextents 1
          maxextents unlimited
        )
        nologging';

END;
