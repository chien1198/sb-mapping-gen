-- ============================================================
-- STG_DTM_UPDATE.sql
-- UPDATE DDL cho cac bang STG_DTM da dong bo lai nullable / data_type /
-- length theo chuan SB_DWH (13 bang STG_DIM_* + 14 bang STG_FCT_*).
-- Phan 1: DROP TABLE cac bang lien quan.
-- Phan 2: CREATE TABLE voi DDL moi (da sua).
-- CHU Y: chay script nay se XOA SACH DU LIEU hien co trong cac bang
-- duoc liet ke (DROP TABLE). Backup/migrate du lieu truoc khi chay
-- tren moi truong co du lieu that.
-- ============================================================

-- ================================================================
-- A. BANG DIM (STG_DIM_*) - PL/SQL block, EXECUTE IMMEDIATE
-- ================================================================
BEGIN
   -- ============================================================
   -- PHAN 1: DROP TABLE
   -- ============================================================
   EXECUTE IMMEDIATE 'DROP TABLE STG_DTM.STG_DIM_CLOS_APPLICATION';
   EXECUTE IMMEDIATE 'DROP TABLE STG_DTM.STG_DIM_CLOS_CUSTOMER';
   EXECUTE IMMEDIATE 'DROP TABLE STG_DTM.STG_DIM_CLOS_EXCEPTION';
   EXECUTE IMMEDIATE 'DROP TABLE STG_DTM.STG_DIM_CLOS_PRODUCT';
   EXECUTE IMMEDIATE 'DROP TABLE STG_DTM.STG_DIM_CLOS_WORKSTEP_DECISION';
   EXECUTE IMMEDIATE 'DROP TABLE STG_DTM.STG_DIM_LOS_COMPANY';
   EXECUTE IMMEDIATE 'DROP TABLE STG_DTM.STG_DIM_LOS_USER';
   EXECUTE IMMEDIATE 'DROP TABLE STG_DTM.STG_DIM_RLOS_APPLICATION';
   EXECUTE IMMEDIATE 'DROP TABLE STG_DTM.STG_DIM_RLOS_CARD_PROMOTION';
   EXECUTE IMMEDIATE 'DROP TABLE STG_DTM.STG_DIM_RLOS_CHANGE_TYPE';
   EXECUTE IMMEDIATE 'DROP TABLE STG_DTM.STG_DIM_RLOS_EXCEPTION';
   EXECUTE IMMEDIATE 'DROP TABLE STG_DTM.STG_DIM_RLOS_PRODUCT';
   EXECUTE IMMEDIATE 'DROP TABLE STG_DTM.STG_DIM_RLOS_WORKSTEP_DECISION';

   -- ============================================================
   -- PHAN 2: CREATE TABLE (DDL moi)
   -- ============================================================
   -- ============================================================
   -- STG_DIM_CLOS_APPLICATION
   -- ============================================================
   EXECUTE IMMEDIATE 'create table STG_DTM.STG_DIM_CLOS_APPLICATION
      (
        dimension_key            NUMBER not null,
        application_sk           NUMBER,
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
        exp_date                 DATE,
        time_update TIMESTAMP
      )
      tablespace STG_DTM_TBS
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
   EXECUTE IMMEDIATE 'alter table STG_DTM.STG_DIM_CLOS_APPLICATION
        add constraint STG_DIM_CLOS_APPLICATION_PK primary key (DIMENSION_KEY)
        using index
        tablespace STG_DTM_TBS
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
   EXECUTE IMMEDIATE 'alter index STG_DTM.STG_DIM_CLOS_APPLICATION_PK nologging';
   EXECUTE IMMEDIATE 'create index STG_DTM.STG_DIM_CLOS_APPLICATION_WI_NAME_IDX on STG_DTM.STG_DIM_CLOS_APPLICATION (WI_NAME)
        tablespace STG_DTM_TBS
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
   EXECUTE IMMEDIATE 'create index STG_DTM.STG_DIM_CLOS_APPLICATION_EFF_DATE_IDX on STG_DTM.STG_DIM_CLOS_APPLICATION (EFF_DATE)
        tablespace STG_DTM_TBS
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
   EXECUTE IMMEDIATE 'create index STG_DTM.STG_DIM_CLOS_APPLICATION_EXP_DATE_IDX on STG_DTM.STG_DIM_CLOS_APPLICATION (EXP_DATE)
        tablespace STG_DTM_TBS
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
   EXECUTE IMMEDIATE 'create index STG_DTM.STG_DIM_CLOS_APPLICATION_APPLICATION_SK_IDX on STG_DTM.STG_DIM_CLOS_APPLICATION (APPLICATION_SK)
        tablespace STG_DTM_TBS
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
   -- STG_DIM_CLOS_CUSTOMER
   -- ============================================================
   EXECUTE IMMEDIATE 'create table STG_DTM.STG_DIM_CLOS_CUSTOMER
      (
        dimension_key      NUMBER not null,
        customer_sk        NUMBER,
        customer_code      VARCHAR2(100),
        customer_name      VARCHAR2(200),
        cust_group         VARCHAR2(100),
        cust_category      VARCHAR2(200),
        precustgroup       VARCHAR2(100),
        industry_lvl1_code VARCHAR2(200),
        industry_lvl2_code VARCHAR2(200),
        industry_lvl3_code VARCHAR2(200),
        eff_date           DATE,
        exp_date           DATE,
        time_update TIMESTAMP
      )
      tablespace STG_DTM_TBS
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
   EXECUTE IMMEDIATE 'alter table STG_DTM.STG_DIM_CLOS_CUSTOMER
        add constraint STG_DIM_CLOS_CUSTOMER_PK primary key (DIMENSION_KEY)
        using index
        tablespace STG_DTM_TBS
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
   EXECUTE IMMEDIATE 'alter index STG_DTM.STG_DIM_CLOS_CUSTOMER_PK nologging';

   -- ============================================================
   -- STG_DIM_CLOS_EXCEPTION
   -- ============================================================
   EXECUTE IMMEDIATE 'create table STG_DTM.STG_DIM_CLOS_EXCEPTION
      (
        dimension_key      NUMBER not null,
        exception_sk       NUMBER,
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
        exp_date           DATE,
        time_update TIMESTAMP
      )
      tablespace STG_DTM_TBS
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
   EXECUTE IMMEDIATE 'alter table STG_DTM.STG_DIM_CLOS_EXCEPTION
        add constraint STG_DIM_CLOS_EXCEPTION_PK primary key (DIMENSION_KEY)
        using index
        tablespace STG_DTM_TBS
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
   EXECUTE IMMEDIATE 'alter index STG_DTM.STG_DIM_CLOS_EXCEPTION_PK nologging';

   -- ============================================================
   -- STG_DIM_CLOS_PRODUCT
   -- ============================================================
   EXECUTE IMMEDIATE 'create table STG_DTM.STG_DIM_CLOS_PRODUCT
      (
        dimension_key          NUMBER not null,
        productline_sk          NUMBER,
        productline_code        VARCHAR2(100),
        productline_name        VARCHAR2(200),
        productline_eff_date    DATE,
        productline_exp_date    DATE,
        sub_product_sk           NUMBER,
        sub_product_code         VARCHAR2(100),
        sub_product_name         VARCHAR2(150),
        sub_product_active       VARCHAR2(100),
        sub_product_eff_date     DATE,
        sub_product_exp_date     DATE,
        time_update TIMESTAMP
      )
      tablespace STG_DTM_TBS
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
   EXECUTE IMMEDIATE 'alter table STG_DTM.STG_DIM_CLOS_PRODUCT
        add constraint STG_DIM_CLOS_PRODUCT_PK primary key (DIMENSION_KEY)
        using index
        tablespace STG_DTM_TBS
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
   EXECUTE IMMEDIATE 'alter index STG_DTM.STG_DIM_CLOS_PRODUCT_PK nologging';

   -- ============================================================
   -- STG_DIM_CLOS_WORKSTEP_DECISION
   -- ============================================================
   EXECUTE IMMEDIATE 'create table STG_DTM.STG_DIM_CLOS_WORKSTEP_DECISION
      (
        dimension_key        NUMBER not null,
        workstep_decision_sk NUMBER,
        workstep_code        VARCHAR2(200),
        decision_code        VARCHAR2(200),
        channel              VARCHAR2(200),
        eff_date             DATE,
        exp_date             DATE,
        time_update TIMESTAMP
      )
      tablespace STG_DTM_TBS
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
   EXECUTE IMMEDIATE 'alter table STG_DTM.STG_DIM_CLOS_WORKSTEP_DECISION
        add constraint STG_DIM_CLOS_WORKSTEP_DECISION_PK primary key (DIMENSION_KEY)
        using index
        tablespace STG_DTM_TBS
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
   EXECUTE IMMEDIATE 'alter index STG_DTM.STG_DIM_CLOS_WORKSTEP_DECISION_PK nologging';

   -- ============================================================
   -- STG_DIM_LOS_COMPANY
   -- ============================================================
   EXECUTE IMMEDIATE 'create table STG_DTM.STG_DIM_LOS_COMPANY
      (
        dimension_key     NUMBER not null,
        company_sk        NUMBER,
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
        region_exp_date   DATE,
        time_update TIMESTAMP
      )
      tablespace STG_DTM_TBS
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
   EXECUTE IMMEDIATE 'alter table STG_DTM.STG_DIM_LOS_COMPANY
        add constraint STG_DIM_LOS_COMPANY_PK primary key (DIMENSION_KEY)
        using index
        tablespace STG_DTM_TBS
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
   EXECUTE IMMEDIATE 'alter index STG_DTM.STG_DIM_LOS_COMPANY_PK nologging';

   -- ============================================================
   -- STG_DIM_LOS_USER
   -- ============================================================
   EXECUTE IMMEDIATE 'create table STG_DTM.STG_DIM_LOS_USER
      (
        dimension_key        NUMBER not null,
        user_sk              NUMBER,
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
        exp_date             DATE,
        time_update TIMESTAMP
      )
      tablespace STG_DTM_TBS
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
   EXECUTE IMMEDIATE 'alter table STG_DTM.STG_DIM_LOS_USER
        add constraint STG_DIM_LOS_USER_PK primary key (DIMENSION_KEY)
        using index
        tablespace STG_DTM_TBS
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
   EXECUTE IMMEDIATE 'alter index STG_DTM.STG_DIM_LOS_USER_PK nologging';

   -- ============================================================
   -- STG_DIM_RLOS_APPLICATION
   -- ============================================================
   EXECUTE IMMEDIATE 'create table STG_DTM.STG_DIM_RLOS_APPLICATION
      (
        dimension_key        NUMBER not null,
        application_sk       NUMBER,
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
        exp_date             DATE,
        time_update TIMESTAMP
      )
      tablespace STG_DTM_TBS
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
   EXECUTE IMMEDIATE 'alter table STG_DTM.STG_DIM_RLOS_APPLICATION
        add constraint STG_DIM_RLOS_APPLICATION_PK primary key (DIMENSION_KEY)
        using index
        tablespace STG_DTM_TBS
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
   EXECUTE IMMEDIATE 'alter index STG_DTM.STG_DIM_RLOS_APPLICATION_PK nologging';
   EXECUTE IMMEDIATE 'create index STG_DTM.STG_DIM_RLOS_APPLICATION_WI_NAME_IDX on STG_DTM.STG_DIM_RLOS_APPLICATION (WI_NAME)
        tablespace STG_DTM_TBS
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
   EXECUTE IMMEDIATE 'create index STG_DTM.STG_DIM_RLOS_APPLICATION_EFF_DATE_IDX on STG_DTM.STG_DIM_RLOS_APPLICATION (EFF_DATE)
        tablespace STG_DTM_TBS
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
   EXECUTE IMMEDIATE 'create index STG_DTM.STG_DIM_RLOS_APPLICATION_EXP_DATE_IDX on STG_DTM.STG_DIM_RLOS_APPLICATION (EXP_DATE)
        tablespace STG_DTM_TBS
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
   EXECUTE IMMEDIATE 'create index STG_DTM.STG_DIM_RLOS_APPLICATION_APPLICATION_SK_IDX on STG_DTM.STG_DIM_RLOS_APPLICATION (APPLICATION_SK)
        tablespace STG_DTM_TBS
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
   -- STG_DIM_RLOS_CARD_PROMOTION
   -- ============================================================
   EXECUTE IMMEDIATE 'create table STG_DTM.STG_DIM_RLOS_CARD_PROMOTION
      (
        dimension_key     NUMBER not null,
        card_promotion_sk NUMBER,
        promotion_code    NVARCHAR2(255),
        promotion_desc    NVARCHAR2(255),
        pro_trans         NVARCHAR2(255),
        pro_valid         NVARCHAR2(255),
        order_promotion   NVARCHAR2(255),
        eff_date          DATE,
        exp_date          DATE,
        time_update TIMESTAMP
      )
      tablespace STG_DTM_TBS
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
   EXECUTE IMMEDIATE 'alter table STG_DTM.STG_DIM_RLOS_CARD_PROMOTION
        add constraint STG_DIM_RLOS_CARD_PROMOTION_PK primary key (DIMENSION_KEY)
        using index
        tablespace STG_DTM_TBS
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
   EXECUTE IMMEDIATE 'alter index STG_DTM.STG_DIM_RLOS_CARD_PROMOTION_PK nologging';

   -- ============================================================
   -- STG_DIM_RLOS_CHANGE_TYPE
   -- ============================================================
   EXECUTE IMMEDIATE 'create table STG_DTM.STG_DIM_RLOS_CHANGE_TYPE
      (
        dimension_key           NUMBER not null,
        change_type_sk          NUMBER,
        change_type_code        VARCHAR2(100),
        change_type_name        VARCHAR2(200),
        detail_change_type_code VARCHAR2(100),
        detail_change_type_name VARCHAR2(500),
        is_active               VARCHAR2(1),
        eff_date                DATE,
        exp_date                DATE,
        time_update TIMESTAMP
      )
      tablespace STG_DTM_TBS
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
   EXECUTE IMMEDIATE 'alter table STG_DTM.STG_DIM_RLOS_CHANGE_TYPE
        add constraint STG_DIM_RLOS_CHANGE_TYPE_PK primary key (DIMENSION_KEY)
        using index
        tablespace STG_DTM_TBS
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
   EXECUTE IMMEDIATE 'alter index STG_DTM.STG_DIM_RLOS_CHANGE_TYPE_PK nologging';

   -- ============================================================
   -- STG_DIM_RLOS_EXCEPTION
   -- ============================================================
   EXECUTE IMMEDIATE 'create table STG_DTM.STG_DIM_RLOS_EXCEPTION
      (
        dimension_key      NUMBER not null,
        exception_sk       NUMBER,
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
        exp_date           DATE,
        time_update TIMESTAMP
      )
      tablespace STG_DTM_TBS
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
   EXECUTE IMMEDIATE 'alter table STG_DTM.STG_DIM_RLOS_EXCEPTION
        add constraint STG_DIM_RLOS_EXCEPTION_PK primary key (DIMENSION_KEY)
        using index
        tablespace STG_DTM_TBS
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
   EXECUTE IMMEDIATE 'alter index STG_DTM.STG_DIM_RLOS_EXCEPTION_PK nologging';

   -- ============================================================
   -- STG_DIM_RLOS_PRODUCT
   -- ============================================================
   EXECUTE IMMEDIATE 'create table STG_DTM.STG_DIM_RLOS_PRODUCT
      (
        dimension_key    NUMBER not null,
        productline_sk    NUMBER not null,
        productline_code VARCHAR2(100),
        productline_name VARCHAR2(200),
        sub_product_sk    NUMBER,
        sub_product_bk    VARCHAR2(64),
        sub_product_code VARCHAR2(100),
        sub_product_name VARCHAR2(150),
        score_required   VARCHAR2(10),
        score_model      VARCHAR2(100),
        eff_date         DATE,
        exp_date         DATE,
        time_update TIMESTAMP
      )
      tablespace STG_DTM_TBS
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
   EXECUTE IMMEDIATE 'alter table STG_DTM.STG_DIM_RLOS_PRODUCT
        add constraint STG_DIM_RLOS_PRODUCT_PK primary key (DIMENSION_KEY)
        using index
        tablespace STG_DTM_TBS
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
   EXECUTE IMMEDIATE 'alter index STG_DTM.STG_DIM_RLOS_PRODUCT_PK nologging';

   -- ============================================================
   -- STG_DIM_RLOS_WORKSTEP_DECISION
   -- ============================================================
   EXECUTE IMMEDIATE 'create table STG_DTM.STG_DIM_RLOS_WORKSTEP_DECISION
      (
        dimension_key        NUMBER not null,
        workstep_decision_sk NUMBER,
        workstep_code        VARCHAR2(200),
        decision_code        VARCHAR2(200),
        req_type             VARCHAR2(255),
        eff_date             DATE,
        exp_date             DATE,
        time_update TIMESTAMP
      )
      tablespace STG_DTM_TBS
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
   EXECUTE IMMEDIATE 'alter table STG_DTM.STG_DIM_RLOS_WORKSTEP_DECISION
        add constraint STG_DIM_RLOS_WORKSTEP_DECISION_PK primary key (DIMENSION_KEY)
        using index
        tablespace STG_DTM_TBS
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
   EXECUTE IMMEDIATE 'alter index STG_DTM.STG_DIM_RLOS_WORKSTEP_DECISION_PK nologging';

END;
/

-- ================================================================
-- B. BANG FACT (STG_FCT_*) - plain SQL
-- ================================================================

-- ============================================================
-- PHAN 1: DROP TABLE
-- ============================================================
DROP TABLE STG_DTM.STG_FCT_CLOS_APPLICATION;
DROP TABLE STG_DTM.STG_FCT_CLOS_COLLATERAL;
DROP TABLE STG_DTM.STG_FCT_CLOS_DEVIATION;
DROP TABLE STG_DTM.STG_FCT_CLOS_EXCEPTION;
DROP TABLE STG_DTM.STG_FCT_CLOS_LEGAL_PARTY;
DROP TABLE STG_DTM.STG_FCT_CLOS_WORKSTEP_EVENT;
DROP TABLE STG_DTM.STG_FCT_RLOS_APPLICATION;
DROP TABLE STG_DTM.STG_FCT_RLOS_APPLICATION_SECONDPRODUCT;
DROP TABLE STG_DTM.STG_FCT_RLOS_COLLATERAL;
DROP TABLE STG_DTM.STG_FCT_RLOS_COREPAYER;
DROP TABLE STG_DTM.STG_FCT_RLOS_CUSTOMER;
DROP TABLE STG_DTM.STG_FCT_RLOS_DEVIATION;
DROP TABLE STG_DTM.STG_FCT_RLOS_EXCEPTION;
DROP TABLE STG_DTM.STG_FCT_RLOS_WORKSTEP_EVENT;

-- ============================================================
-- PHAN 2: CREATE TABLE (DDL moi)
-- ============================================================
-- ============================================================
-- STG_DTM_STG_FCT_CLOS_APPLICATION.sql
-- ============================================================
CREATE TABLE STG_DTM.STG_FCT_CLOS_APPLICATION (
    DAYID                         DATE                NOT NULL,
    APPLICATION_SK                NUMBER              ,
    WI_NAME                       VARCHAR2(100)       NOT NULL,
    WORKSTEP_DECISION_SK          NUMBER              ,
    WORKSTEP_CODE                 VARCHAR2(200)       ,
    DECISION_CODE                 VARCHAR2(200)       ,
    PRODUCTLINE_SK                NUMBER              ,
    PRODUCTLINE_CODE              VARCHAR2(100)       ,
    SUB_PRODUCT_SK                NUMBER              ,
    SUB_PRODUCT_CODE              VARCHAR2(100)       ,
    COMPANY_SK                    NUMBER              ,
    COMPANY_CODE                  VARCHAR2(50)        ,
    CUSTOMER_SK                   NUMBER              ,
    CUSTOMER_CODE                 VARCHAR2(100)       ,
    PROCESSED_DATE                DATE                ,
    PROPOSED_AMT                  NUMBER(20,2)        ,
    CREDIT_LIMIT_APPROVAL         NUMBER(20,2)        ,
    APPROVED_AMT_FINAL            NUMBER(20,2)        ,
    APPROVED_TERM                 NVARCHAR2(100)      ,
    INTEREST_RATE_PCT             NVARCHAR2(500)      ,
    CURRENCY_CODE                 NVARCHAR2(100)      ,
    APPLICATION_LINK_INFO         VARCHAR2(200)       ,
    LG_REQ                        NVARCHAR2(100)      ,
    FI_REQ                        NVARCHAR2(100)      ,
    PHONE_REQ                     NVARCHAR2(100)      ,
    CHANGE_REQUEST                VARCHAR2(200)       ,
    CHANGE_TYPE                   VARCHAR2(500)       ,
    TIME_UPDATE                   TIMESTAMP           ,

  CONSTRAINT STG_FCT_CLOS_APPLICATION_PK PRIMARY KEY (WI_NAME, DAYID)
);

COMMIT;

-- ============================================================
-- STG_DTM_STG_FCT_CLOS_COLLATERAL.sql
-- ============================================================
-- ==============================
-- DROP TABLE STG_DTM.STG_FCT_CLOS_COLLATERAL
CREATE TABLE STG_DTM.STG_FCT_CLOS_COLLATERAL (
    DAYID                         DATE                NOT NULL,
    COLLATERAL_BK                 VARCHAR2(64)        NOT NULL,
    APPLICATION_SK                NUMBER              ,
    COLLATERAL_TYPE_CODE          VARCHAR2(500)       NOT NULL,
    WI_NAME                       VARCHAR2(100)       NOT NULL,
    DESCRIPTION                   CLOB                ,
    OWNER_NAME                    VARCHAR2(200)       ,
    COLL_MGMT_METHOD              CLOB                ,
    APPRAISED_VALUE               NVARCHAR2(100)      ,
    LOAN_RATE_LTV                 NVARCHAR2(100)      ,
    TIME_UPDATE                   TIMESTAMP           ,

  CONSTRAINT STG_FCT_CLOS_COLLATERAL_PK PRIMARY KEY (COLLATERAL_BK, DAYID)
);

COMMIT;

-- ============================================================
-- STG_DTM_STG_FCT_CLOS_DEVIATION.sql
-- ============================================================
CREATE TABLE STG_DTM.STG_FCT_CLOS_DEVIATION (
    DAYID                         DATE                NOT NULL,
    DEVIATION_BK                  VARCHAR2(64)        NOT NULL,
    APPLICATION_SK                NUMBER              ,
    WI_NAME                       VARCHAR2(100)       NOT NULL,
    DEVIATION_TYPE_CODE           VARCHAR2(300)       ,
    DEV_PROPOSAL                  CLOB                ,
    AS_REGULAR                    CLOB                ,
    PROCESSED_DATE                DATE                ,
    TIME_UPDATE                   TIMESTAMP           ,

  CONSTRAINT STG_FCT_CLOS_DEVIATION_PK PRIMARY KEY (DEVIATION_BK, DAYID)
);

COMMIT;

-- ============================================================
-- STG_DTM_STG_FCT_CLOS_EXCEPTION.sql
-- ============================================================
CREATE TABLE STG_DTM.STG_FCT_CLOS_EXCEPTION (
    DAYID                         DATE                NOT NULL,
    EXCEPTION_BK                  VARCHAR2(64)        NOT NULL,
    APPLICATION_SK                NUMBER              ,
    WI_NAME                       VARCHAR2(100)       NOT NULL,
    EXCEPTION_SK                  NUMBER              ,
    WORKSTEP_CODE                 VARCHAR2(200)       ,
    DECISION_CODE                 VARCHAR2(200)       ,
    USER_SK                       NUMBER              ,
    USERNAME                      VARCHAR2(150)       ,
    CUSTOMER_SK                   NUMBER              ,
    CUSTOMER_CODE                 VARCHAR2(100)       ,
    EXCEPTION_CATEGORY            VARCHAR2(500)       ,
    RAISED_BY                     VARCHAR2(100)       NOT NULL,
    RAISED_DATE_TIME              TIMESTAMP           NOT NULL,
    EXCEPTION_NAME                VARCHAR2(500)       ,
    EXCEPTION_REMARKS             VARCHAR2(4000)      ,
    RCTYPE                        VARCHAR2(20)        ,
    TIME_UPDATE                   TIMESTAMP           ,

  CONSTRAINT STG_FCT_CLOS_EXCEPTION_PK PRIMARY KEY (EXCEPTION_BK, DAYID)
);

COMMIT;

-- ============================================================
-- STG_DTM_STG_FCT_CLOS_LEGAL_PARTY.sql
-- ============================================================
CREATE TABLE STG_DTM.STG_FCT_CLOS_LEGAL_PARTY (
    DAYID                         DATE                NOT NULL,
    LEGAL_PARTY_BK                VARCHAR2(64)        NOT NULL,
    CUSTOMER_SK                   NUMBER              ,
    CUSTOMER_CODE                 VARCHAR2(100)       ,
    APPLICATION_SK                NUMBER              ,
    WI_NAME                       VARCHAR2(100)       NOT NULL,
    ID_NUMBER                     VARCHAR2(100)       ,
    FULL_NAME                     VARCHAR2(200)       ,
    OBJ_TYPE                      VARCHAR2(100)       ,
    LEGAL_DOC                     VARCHAR2(100)       ,
    TIME_UPDATE                   TIMESTAMP           ,

  CONSTRAINT STG_FCT_CLOS_LEGAL_PARTY_PK PRIMARY KEY (LEGAL_PARTY_BK, DAYID)
);

COMMIT;

-- ============================================================
-- STG_DTM_STG_FCT_CLOS_WORKSTEP_EVENT.sql
-- ============================================================
CREATE TABLE STG_DTM.STG_FCT_CLOS_WORKSTEP_EVENT (
    DAYID                         DATE                NOT NULL,
    WORKSTEP_EVENT_BK             VARCHAR2(64)        NOT NULL,
    WORKSTEP_DECISION_SK          NUMBER              ,
    WORKSTEP_CODE                 VARCHAR2(200)       ,
    DECISION_CODE                 VARCHAR2(200)       ,
    APPLICATION_SK                NUMBER              ,
    WI_NAME                       VARCHAR2(100)       NOT NULL,
    CUSTOMER_SK                   NUMBER              ,
    CUSTOMER_CODE                 VARCHAR2(100)       ,
    USER_SK                       NUMBER              ,
    ENTRYDATE                     TIMESTAMP           ,
    EXITDATE                      TIMESTAMP           ,
    USERNAME                      VARCHAR2(100)       ,
    REMARKS                       VARCHAR2(4000)      ,
    TAT_SOURCE_SEC                NUMBER(12)          ,
    PROCESSED_DATE                DATE                ,
    WF_PROCESSNAME                VARCHAR2(50)        ,
    WF_ACTIVITYNAME               VARCHAR2(200)       ,
    WF_CREATEDBY                  VARCHAR2(50)        ,
    APPROVED_DATE                 DATE                ,
    UNDERWRITERMAKER_USERMAKE     VARCHAR2(100)       ,
    UNDERWRITERCHECKER_USERMAKE   VARCHAR2(100)       ,
    APPROVAL_USERMAKE             VARCHAR2(100)       ,
    TIME_UPDATE                   TIMESTAMP           ,

  CONSTRAINT STG_FCT_CLOS_WORKSTEP_EVENT_PK PRIMARY KEY (WORKSTEP_EVENT_BK, DAYID)
);

COMMIT;

-- ============================================================
-- STG_DTM_STG_FCT_RLOS_APPLICATION.sql
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
--               STG_FCT_ khac hay giu nguyen?
-- ===========================================================================
-- DROP TABLE STG_DTM.STG_FCT_RLOS_APPLICATION
CREATE TABLE STG_DTM.STG_FCT_RLOS_APPLICATION (
    DAYID                         DATE                NOT NULL,
    APPLICATION_SK                NUMBER              ,
    WI_NAME                       VARCHAR2(100)       NOT NULL,
    WORKSTEP_DECISION_SK          NUMBER              ,
    WORKSTEP_CODE                 VARCHAR2(200)       ,
    DECISION_CODE                 VARCHAR2(200)       ,
    SUB_PRODUCT_SK                NUMBER              ,
    PRODUCTLINE_CODE              VARCHAR2(100)       ,
    SUB_PRODUCT_CODE              VARCHAR2(100)       ,
    COMPANY_SK                    NUMBER              ,
    COMPANY_CODE                  VARCHAR2(50)        ,
    CHANGE_TYPE_SK                NUMBER              ,
    CHANGE_TYPE_CODE              VARCHAR2(100)       ,
    DETAIL_CHANGE_TYPE_CODE       VARCHAR2(100)       ,
    CARD_PROMOTION_SK             NUMBER              ,
    PROMOTION_CODE                VARCHAR2(50)        ,
    PROCESSED_DATE                DATE                ,
    CREATION_DATE                 DATE                ,
    APPROVED_AMT_FINAL            NUMBER(25,2)        ,
    APPROVED_TERM                 NUMBER(15)           ,
    CURRENCY_CODE                 VARCHAR2(10)        ,
    CHANGE_REQUEST                VARCHAR2(200)       ,
    CHANGE_TYPE                   VARCHAR2(500)       ,
    TIME_UPDATE                   TIMESTAMP           ,

  CONSTRAINT STG_FCT_RLOS_APPLICATION_PK PRIMARY KEY (WI_NAME, DAYID)
);

COMMIT;

-- ============================================================
-- STG_DTM_STG_FCT_RLOS_APPLICATION_SECONDPRODUCT.sql
-- ============================================================
CREATE TABLE STG_DTM.STG_FCT_RLOS_APPLICATION_SECONDPRODUCT (
    DAYID                         DATE                NOT NULL,
    SUB_PRODUCT_BK                VARCHAR2(64)        NOT NULL,
    APPLICATION_SK                NUMBER              ,
    WI_NAME                       VARCHAR2(100)       ,
    SECONDPRODUCT_SK              NUMBER              ,
    PRODUCTLINE_CODE              VARCHAR2(100)       ,
    SECONDARY_PRODUCT             VARCHAR2(200)       ,
    SUB_PRODUCT_LINE              VARCHAR2(200)       ,
    SPP_AMOUNT                    NUMBER(20,2)        ,
    SPP_TERM                      NUMBER(5)           ,
    CARD_TYPE_CODE                VARCHAR2(100)       ,
    TIME_UPDATE                   TIMESTAMP           ,

  CONSTRAINT STG_FCT_RLOS_APPLICATION_SECONDPRODUCT_PK PRIMARY KEY (SUB_PRODUCT_BK, DAYID)
);

COMMIT;

-- ============================================================
-- STG_DTM_STG_FCT_RLOS_COLLATERAL.sql
-- ============================================================
-- DROP TABLE STG_DTM.STG_FCT_RLOS_COLLATERAL
CREATE TABLE STG_DTM.STG_FCT_RLOS_COLLATERAL (
    DAYID                         DATE                NOT NULL,
    COLLATERAL_BK                 VARCHAR2(64)        NOT NULL,
    APPLICATION_SK                NUMBER              ,
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
    APPRAISED_VALUE               NUMBER(36,2)        ,
    LOAN_RATE_LTV                 NUMBER(10,2)        ,
    TYPES_OF_COLLATERALS          VARCHAR2(500)       ,
    TIME_UPDATE                   TIMESTAMP           ,

  CONSTRAINT STG_FCT_RLOS_COLLATERAL_PK PRIMARY KEY (COLLATERAL_BK, DAYID)
);

COMMIT;

-- ============================================================
-- STG_DTM_STG_FCT_RLOS_COREPAYER.sql
-- ============================================================
-- DROP TABLE STG_DTM.STG_FCT_RLOS_COREPAYER
CREATE TABLE STG_DTM.STG_FCT_RLOS_COREPAYER (
    DAYID                         DATE                NOT NULL,
    COREPAYER_BK                  VARCHAR2(64)        NOT NULL,
    APPLICATION_SK                NUMBER              ,
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
    TIME_UPDATE                   TIMESTAMP           ,

  CONSTRAINT STG_FCT_RLOS_COREPAYER_PK PRIMARY KEY (COREPAYER_BK, DAYID)
);

COMMIT;

-- ============================================================
-- STG_DTM_STG_FCT_RLOS_CUSTOMER.sql
-- ============================================================
-- DROP TABLE STG_DTM.STG_FCT_RLOS_CUSTOMER
CREATE TABLE STG_DTM.STG_FCT_RLOS_CUSTOMER (
    DAYID                         DATE                NOT NULL,
    CUSTOMER_BK                   VARCHAR2(64)        NOT NULL,
    APPLICATION_SK                NUMBER              ,
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
    CURR_HOUSE_NO                 VARCHAR2(300)       ,
    CURR_WARD                     VARCHAR2(100)       ,
    CITY_CODE                     VARCHAR2(50)        ,
    CITY_NAME                     VARCHAR2(200)       ,
    CITY_NAME_VN                  VARCHAR2(200)       ,
    DISTRICT_CODE                 VARCHAR2(50)        ,
    DISTRICT_NAME                 VARCHAR2(200)       ,
    DISTRICT_NAME_VN              VARCHAR2(200)       ,
    CUS_SEGMENT                   VARCHAR2(100)       ,
    TIME_UPDATE                   TIMESTAMP           ,

  CONSTRAINT STG_FCT_RLOS_CUSTOMER_PK PRIMARY KEY (CUSTOMER_BK, DAYID)
);

COMMIT;

-- ============================================================
-- STG_DTM_STG_FCT_RLOS_DEVIATION.sql
-- ============================================================
-- DROP TABLE STG_DTM.STG_FCT_RLOS_DEVIATION
CREATE TABLE STG_DTM.STG_FCT_RLOS_DEVIATION (
    DAYID                         DATE                NOT NULL,
    DEVIATION_BK                  VARCHAR2(64)        NOT NULL,
    APPLICATION_SK                NUMBER              ,
    WI_NAME                       VARCHAR2(100)       NOT NULL,
    CHECKING_CONDITION            VARCHAR2(500)       ,
    CHECKING_RESULT               VARCHAR2(200)       ,
    DEVIATION_REASON              CLOB                ,
    PROCESSED_DATE                DATE      ,          
    TIME_UPDATE                   TIMESTAMP           ,

  CONSTRAINT STG_FCT_RLOS_DEVIATION_PK PRIMARY KEY (DEVIATION_BK, DAYID)
);

COMMIT;

-- ============================================================
-- STG_DTM_STG_FCT_RLOS_EXCEPTION.sql
-- ============================================================
-- DROP TABLE STG_DTM.STG_FCT_RLOS_EXCEPTION
CREATE TABLE STG_DTM.STG_FCT_RLOS_EXCEPTION (
    DAYID                         DATE                NOT NULL,
    EXCEPTION_BK                  VARCHAR2(64)        NOT NULL,
    APPLICATION_SK                NUMBER              ,
    WI_NAME                       VARCHAR2(100)       NOT NULL,
    USER_SK                       NUMBER              ,
    USERNAME                      VARCHAR2(150)       ,
    EXCEPTION_CATEGORY            VARCHAR2(500)       ,
    RAISED_BY                     VARCHAR2(100)       NOT NULL,
    RAISED_DATE_TIME              TIMESTAMP           NOT NULL,
    EXCEPTION_NAME                VARCHAR2(500)       ,
    EXCEPTION_REMARKS             VARCHAR2(4000)      ,
    RCTYPE                        VARCHAR2(20)        ,
    SUB_PRODUCT                   VARCHAR2(255)       ,
    TIME_UPDATE                   TIMESTAMP           ,

  CONSTRAINT STG_FCT_RLOS_EXCEPTION_PK PRIMARY KEY (EXCEPTION_BK, DAYID)
);

COMMIT;

-- ============================================================
-- STG_DTM_STG_FCT_RLOS_WORKSTEP_EVENT.sql
-- ============================================================
-- DROP TABLE STG_DTM.STG_FCT_RLOS_WORKSTEP_EVENT
CREATE TABLE STG_DTM.STG_FCT_RLOS_WORKSTEP_EVENT (
    DAYID                         DATE                NOT NULL,
    WORKSTEP_EVENT_BK             VARCHAR2(64)        NOT NULL,
    WORKSTEP_DECISION_SK          NUMBER              ,
    WORKSTEP_CODE                 VARCHAR2(200)       ,
    DECISION_CODE                 VARCHAR2(200)       ,
    APPLICATION_SK                NUMBER              ,
    WI_NAME                       VARCHAR2(100)       NOT NULL,
    USER_SK                       NUMBER              ,
    ENTRYDATE                     TIMESTAMP           ,
    EXITDATE                      TIMESTAMP           ,
    USERNAME                      VARCHAR2(100)       ,
    REMARKS                       VARCHAR2(4000)      ,
    REASON_CODE                   VARCHAR2(50)        ,
    REASON_DESC                   VARCHAR2(500)       ,
    TAT_SOURCE_SEC                NUMBER(12)          ,
    PROCESSED_DATE                DATE                ,
    WF_PROCESSNAME                VARCHAR2(50)        ,
    WF_ACTIVITYNAME               VARCHAR2(200)       ,
    WF_CREATEDBY                  VARCHAR2(50)        ,
    UNDERWRITERMAKER_USERMAKE     VARCHAR2(100)       ,
    UNDERWRITERCHECKER_USERMAKE   VARCHAR2(100)       ,
    APPROVAL_USERMAKE             VARCHAR2(100)       ,
    TIME_UPDATE                   TIMESTAMP           ,

  CONSTRAINT STG_FCT_RLOS_WORKSTEP_EVENT_PK PRIMARY KEY (WORKSTEP_EVENT_BK, DAYID)
);

COMMIT;
