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
        customer_code            VARCHAR2(100),
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
        customer_code      VARCHAR2(100),
        customer_name      VARCHAR2(200),
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

   -- ============================================================
   -- DIM_CLOS_EXCEPTION
   -- ============================================================
   EXECUTE IMMEDIATE 'create table PDTD_DTM.DIM_CLOS_EXCEPTION
      (
        dimension_key      NUMBER not null,
        exception_sk       NUMBER not null,
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

   -- ============================================================
   -- DIM_CLOS_PRODUCT
   -- ============================================================
   EXECUTE IMMEDIATE 'create table PDTD_DTM.DIM_CLOS_PRODUCT
      (
        dimension_key          NUMBER not null,
        productline_sk          NUMBER not null,
        productline_code        VARCHAR2(100),
        productline_name        VARCHAR2(200),
        productline_eff_date    DATE,
        productline_exp_date    DATE,
        sub_product_sk           NUMBER not null,
        sub_product_code         VARCHAR2(100),
        sub_product_name         VARCHAR2(150),
        sub_product_active       VARCHAR2(100),
        sub_product_eff_date     DATE,
        sub_product_exp_date     DATE
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

   -- ============================================================
   -- DIM_CLOS_WORKSTEP_DECISION
   -- ============================================================
   EXECUTE IMMEDIATE 'create table PDTD_DTM.DIM_CLOS_WORKSTEP_DECISION
      (
        dimension_key        NUMBER not null,
        workstep_decision_sk NUMBER not null,
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

   -- ============================================================
   -- DIM_LOS_COMPANY
   -- ============================================================
   EXECUTE IMMEDIATE 'create table PDTD_DTM.DIM_LOS_COMPANY
      (
        dimension_key     NUMBER not null,
        company_sk        NUMBER not null,
        company_code      VARCHAR2(50),
        company_name      VARCHAR2(200),
        company_address   VARCHAR2(500),
        company_email     VARCHAR2(200),
        zone              NUMBER,
        company_eff_date  DATE,
        company_exp_date  DATE,
        branch_sk         NUMBER,
        branch_code       VARCHAR2(50),
        branch_name       VARCHAR2(200),
        branch_eff_date   DATE,
        branch_exp_date   DATE,
        region_sk         NUMBER,
        region_code       NUMBER,
        region_name       VARCHAR2(200),
        region_eff_date   DATE,
        region_exp_date   DATE
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
        interest_rate_pct    NUMBER(12,4),
        loan_to_value        NUMBER(5,2),
        loan_objective       VARCHAR2(200),
        total_income         NUMBER(25,2),
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
        promotion_code    NVARCHAR2(255),
        promotion_desc    NVARCHAR2(255),
        pro_trans         NVARCHAR2(255),
        pro_valid         NVARCHAR2(255),
        order_promotion   NVARCHAR2(255),
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

   -- ============================================================
   -- DIM_RLOS_CHANGE_TYPE
   -- ============================================================
   EXECUTE IMMEDIATE 'create table PDTD_DTM.DIM_RLOS_CHANGE_TYPE
      (
        dimension_key           NUMBER not null,
        change_type_sk          NUMBER not null,
        change_type_code        VARCHAR2(100),
        change_type_name        VARCHAR2(200),
        detail_change_type_code VARCHAR2(100),
        detail_change_type_name VARCHAR2(500),
        is_active               VARCHAR2(1),
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

   -- ============================================================
   -- DIM_RLOS_EXCEPTION
   -- ============================================================
   EXECUTE IMMEDIATE 'create table PDTD_DTM.DIM_RLOS_EXCEPTION
      (
        dimension_key      NUMBER not null,
        exception_sk       NUMBER not null,
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

   -- ============================================================
   -- DIM_RLOS_PRODUCT
   -- ============================================================
   EXECUTE IMMEDIATE 'create table PDTD_DTM.DIM_RLOS_PRODUCT
      (
        dimension_key    NUMBER not null,
        productline_sk    NUMBER not null,
        productline_code VARCHAR2(100),
        productline_name VARCHAR2(200),
        sub_product_sk    NUMBER not null,
        sub_product_bk    VARCHAR2(64),
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

   -- ============================================================
   -- DIM_RLOS_SECONDPRODUCT
   -- ============================================================
   EXECUTE IMMEDIATE 'create table PDTD_DTM.DIM_RLOS_SECONDPRODUCT
      (
        dimension_key     NUMBER not null,
        secondproduct_sk  NUMBER not null,
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

   -- ============================================================
   -- DIM_RLOS_WORKSTEP_DECISION
   -- ============================================================
   EXECUTE IMMEDIATE 'create table PDTD_DTM.DIM_RLOS_WORKSTEP_DECISION
      (
        dimension_key        NUMBER not null,
        workstep_decision_sk NUMBER not null,
        workstep_code        VARCHAR2(200),
        decision_code        VARCHAR2(200),
        req_type             VARCHAR2(255),
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

END;
