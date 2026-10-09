-- SB_DWH: tao 14 bang WRK_DIM_* (DROP + CREATE). Chay 1 lan trong SQL Window (F8).
-- Tam thoi chua GRANT cho FSS_STG_LOS, CIC_FSS (se bo sung sau).
-- Luu y: DROP se xoa du lieu WRK cu.


BEGIN
   -- ============================================================
   -- 1. WRK_DIM_LOS_USER
   -- ============================================================
   BEGIN
      EXECUTE IMMEDIATE 'DROP TABLE SB_DWH.WRK_DIM_LOS_USER CASCADE CONSTRAINTS';
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF;
   END;
   EXECUTE IMMEDIATE 'CREATE TABLE SB_DWH.WRK_DIM_LOS_USER (
      user_sk                  NUMBER,
      username                 VARCHAR2(100),
      employee_name            VARCHAR2(200),
      employee_status          VARCHAR2(50),
      email                    VARCHAR2(200),
      ip_phone                 VARCHAR2(50),
      sb_code                  VARCHAR2(50),
      id_customer              VARCHAR2(50),
      company_code             VARCHAR2(50),
      company_name             VARCHAR2(200),
      title                    VARCHAR2(100),
      department_code          VARCHAR2(50),
      department_name          VARCHAR2(200),
      uwmaker_group            VARCHAR2(100),
      uwchecker_group          VARCHAR2(100),
      ap_group                 VARCHAR2(100),
      predisb_maker_group      VARCHAR2(100),
      predisb_group            VARCHAR2(100),
      disb_maker_group         VARCHAR2(100),
      disb_checker_group       VARCHAR2(100),
      hub                      VARCHAR2(100),
      branch_manager_email     VARCHAR2(200),
      eff_date                 DATE,
      exp_date                 DATE
   ) TABLESPACE SB_DWH_TBS PCTFREE 10 INITRANS 1 MAXTRANS 255 STORAGE (INITIAL 64K NEXT 1M MINEXTENTS 1 MAXEXTENTS UNLIMITED)';
/*
   -- ============================================================
   -- 2. WRK_DIM_CLOS_PRODUCT
   -- ============================================================
   BEGIN
      EXECUTE IMMEDIATE 'DROP TABLE SB_DWH.WRK_DIM_CLOS_PRODUCT CASCADE CONSTRAINTS';
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF;
   END;
   EXECUTE IMMEDIATE 'CREATE TABLE SB_DWH.WRK_DIM_CLOS_PRODUCT (
      product_sk             NUMBER,
      product_bk             VARCHAR2(64),
      product_line_code      VARCHAR2(100),
      product_line_name      VARCHAR2(200),
      sub_product_code       VARCHAR2(100),
      product_name           VARCHAR2(150),
      eff_date               DATE,
      exp_date               DATE
   ) TABLESPACE SB_DWH_TBS PCTFREE 10 INITRANS 1 MAXTRANS 255 STORAGE (INITIAL 64K NEXT 1M MINEXTENTS 1 MAXEXTENTS UNLIMITED)';
*/
   -- ============================================================
   -- 3. WRK_DIM_CLOS_EXCEPTION
   -- ============================================================
   BEGIN
      EXECUTE IMMEDIATE 'DROP TABLE SB_DWH.WRK_DIM_CLOS_EXCEPTION CASCADE CONSTRAINTS';
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF;
   END;
   EXECUTE IMMEDIATE 'CREATE TABLE SB_DWH.WRK_DIM_CLOS_EXCEPTION (
      exception_sk          NUMBER,
      exception_bk          VARCHAR2(64),
      activityname          VARCHAR2(200),
      decision_code         VARCHAR2(200),
      exception_category    VARCHAR2(500),
      exception_name        VARCHAR2(500),
      exception_code        VARCHAR2(50),
      raise_flag            VARCHAR2(5),
      clear_flag            VARCHAR2(5),
      id_source             NUMBER,
      code_source           VARCHAR2(255),
      status                VARCHAR2(50),
      eff_date              DATE,
      exp_date              DATE
   ) TABLESPACE SB_DWH_TBS PCTFREE 10 INITRANS 1 MAXTRANS 255 STORAGE (INITIAL 64K NEXT 1M MINEXTENTS 1 MAXEXTENTS UNLIMITED)';

   -- ============================================================
   -- 4. WRK_DIM_LOS_COMPANY
   -- ============================================================
   BEGIN
      EXECUTE IMMEDIATE 'DROP TABLE SB_DWH.WRK_DIM_LOS_COMPANY CASCADE CONSTRAINTS';
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF;
   END;
   EXECUTE IMMEDIATE 'CREATE TABLE SB_DWH.WRK_DIM_LOS_COMPANY (
      company_sk       NUMBER,
      company_code     VARCHAR2(50),
      company_name     VARCHAR2(200),
      company_address  VARCHAR2(500),
      company_email    VARCHAR2(200),
      zone             NUMBER,
      branch_code      VARCHAR2(50),
      branch_name      VARCHAR2(200),
      city             VARCHAR2(100),
      district         VARCHAR2(100),
      region_code      NUMBER,
      region_name      VARCHAR2(200),
      eff_date         DATE,
      exp_date         DATE
   ) TABLESPACE SB_DWH_TBS PCTFREE 10 INITRANS 1 MAXTRANS 255 STORAGE (INITIAL 64K NEXT 1M MINEXTENTS 1 MAXEXTENTS UNLIMITED)';

   -- ============================================================
   -- 5. WRK_DIM_RLOS_CARD_PROMOTION
   -- ============================================================
   BEGIN
      EXECUTE IMMEDIATE 'DROP TABLE SB_DWH.WRK_DIM_RLOS_CARD_PROMOTION CASCADE CONSTRAINTS';
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF;
   END;
   EXECUTE IMMEDIATE 'CREATE TABLE SB_DWH.WRK_DIM_RLOS_CARD_PROMOTION (
      card_promotion_sk    NUMBER,
      promotion_code       NVARCHAR2(255),
      promotion_desc       NVARCHAR2(255),
      eff_date             DATE,
      exp_date             DATE
   ) TABLESPACE SB_DWH_TBS PCTFREE 10 INITRANS 1 MAXTRANS 255 STORAGE (INITIAL 64K NEXT 1M MINEXTENTS 1 MAXEXTENTS UNLIMITED)';

   -- ============================================================
   -- 6. WRK_DIM_RLOS_CHANGE_TYPE
   -- ============================================================
   BEGIN
      EXECUTE IMMEDIATE 'DROP TABLE SB_DWH.WRK_DIM_RLOS_CHANGE_TYPE CASCADE CONSTRAINTS';
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF;
   END;
   EXECUTE IMMEDIATE 'CREATE TABLE SB_DWH.WRK_DIM_RLOS_CHANGE_TYPE (
      change_type_sk              NUMBER,
      change_type_bk              VARCHAR2(64),
      change_type_code            VARCHAR2(100),
      change_type_name            VARCHAR2(200),
      detail_change_type_code     VARCHAR2(100),
      detail_change_type_name     VARCHAR2(500),
      eff_date                    DATE,
      exp_date                    DATE
   ) TABLESPACE SB_DWH_TBS PCTFREE 10 INITRANS 1 MAXTRANS 255 STORAGE (INITIAL 64K NEXT 1M MINEXTENTS 1 MAXEXTENTS UNLIMITED)';

   -- ============================================================
   -- 7. WRK_DIM_RLOS_EXCEPTION
   -- ============================================================
   BEGIN
      EXECUTE IMMEDIATE 'DROP TABLE SB_DWH.WRK_DIM_RLOS_EXCEPTION CASCADE CONSTRAINTS';
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF;
   END;
   EXECUTE IMMEDIATE 'CREATE TABLE SB_DWH.WRK_DIM_RLOS_EXCEPTION (
      exception_sk          NUMBER,
      exception_bk          VARCHAR2(64),
      activityname          VARCHAR2(200),
      decision_code         VARCHAR2(200),
      exception_category    VARCHAR2(500),
      exception_name        VARCHAR2(500),
      exception_code        VARCHAR2(50),
      raise_flag            VARCHAR2(5),
      clear_flag            VARCHAR2(5),
      id_source             NUMBER,
      code_source           VARCHAR2(255),
      status                VARCHAR2(50),
      eff_date              DATE,
      exp_date              DATE
   ) TABLESPACE SB_DWH_TBS PCTFREE 10 INITRANS 1 MAXTRANS 255 STORAGE (INITIAL 64K NEXT 1M MINEXTENTS 1 MAXEXTENTS UNLIMITED)';
/*
   -- ============================================================
   -- 8. WRK_DIM_RLOS_SECONDPRODUCT
   -- ============================================================
   BEGIN
      EXECUTE IMMEDIATE 'DROP TABLE SB_DWH.WRK_DIM_RLOS_SECONDPRODUCT CASCADE CONSTRAINTS';
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF;
   END;
   EXECUTE IMMEDIATE 'CREATE TABLE SB_DWH.WRK_DIM_RLOS_SECONDPRODUCT (
      secondproduct_sk       NUMBER,
      secondproduct_bk       VARCHAR2(64),
      productline_code       VARCHAR2(200),
      productline_name       VARCHAR2(200),
      secondary_product      VARCHAR2(200),
      eff_date               DATE,
      exp_date               DATE
   ) TABLESPACE SB_DWH_TBS PCTFREE 10 INITRANS 1 MAXTRANS 255 STORAGE (INITIAL 64K NEXT 1M MINEXTENTS 1 MAXEXTENTS UNLIMITED)';

   -- ============================================================
   -- 9. WRK_DIM_RLOS_PRODUCT
   -- ============================================================
   BEGIN
      EXECUTE IMMEDIATE 'DROP TABLE SB_DWH.WRK_DIM_RLOS_PRODUCT CASCADE CONSTRAINTS';
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF;
   END;
   EXECUTE IMMEDIATE 'CREATE TABLE SB_DWH.WRK_DIM_RLOS_PRODUCT (
      product_sk          NUMBER,
      product_bk          VARCHAR2(64),
      productline_code    VARCHAR2(100),
      productline_name    VARCHAR2(200),
      sub_product_code    VARCHAR2(100),
      sub_product_name    VARCHAR2(150),
      score_required      VARCHAR2(10),
      score_model         VARCHAR2(100),
      eff_date            DATE,
      exp_date            DATE
   ) TABLESPACE SB_DWH_TBS PCTFREE 10 INITRANS 1 MAXTRANS 255 STORAGE (INITIAL 64K NEXT 1M MINEXTENTS 1 MAXEXTENTS UNLIMITED)';
*/
   -- ============================================================
   -- 10. WRK_DIM_RLOS_WORKSTEP_DECISION
   -- ============================================================
   BEGIN
      EXECUTE IMMEDIATE 'DROP TABLE SB_DWH.WRK_DIM_RLOS_WORKSTEP_DECISION CASCADE CONSTRAINTS';
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF;
   END;
   EXECUTE IMMEDIATE 'CREATE TABLE SB_DWH.WRK_DIM_RLOS_WORKSTEP_DECISION (
      workstep_decision_sk     NUMBER,
      workstep_decision_bk     VARCHAR2(64),
      workstep_code            VARCHAR2(200),
      decision_code            VARCHAR2(200),
      eff_date                 DATE,
      exp_date                 DATE
   ) TABLESPACE SB_DWH_TBS PCTFREE 10 INITRANS 1 MAXTRANS 255 STORAGE (INITIAL 64K NEXT 1M MINEXTENTS 1 MAXEXTENTS UNLIMITED)';

   -- ============================================================
   -- 11. WRK_DIM_CLOS_WORKSTEP_DECISION
   -- ============================================================
   BEGIN
      EXECUTE IMMEDIATE 'DROP TABLE SB_DWH.WRK_DIM_CLOS_WORKSTEP_DECISION CASCADE CONSTRAINTS';
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF;
   END;
   EXECUTE IMMEDIATE 'CREATE TABLE SB_DWH.WRK_DIM_CLOS_WORKSTEP_DECISION (
      workstep_decision_sk     NUMBER,
      workstep_decision_bk     VARCHAR2(64),
      workstep_code            VARCHAR2(200),
      decision_code            VARCHAR2(200),
      channel                  VARCHAR2(200),
      eff_date                 DATE,
      exp_date                 DATE
   ) TABLESPACE SB_DWH_TBS PCTFREE 10 INITRANS 1 MAXTRANS 255 STORAGE (INITIAL 64K NEXT 1M MINEXTENTS 1 MAXEXTENTS UNLIMITED)';

   -- ============================================================
   -- 12. WRK_DIM_CLOS_APPLICATION
   -- ============================================================
   BEGIN
      EXECUTE IMMEDIATE 'DROP TABLE SB_DWH.WRK_DIM_CLOS_APPLICATION CASCADE CONSTRAINTS';
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF;
   END;
   EXECUTE IMMEDIATE 'CREATE TABLE SB_DWH.WRK_DIM_CLOS_APPLICATION (
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
      id_number                VARCHAR2(100),
      channel                  VARCHAR2(200),
      eff_date                 DATE,
      exp_date                 DATE
   ) TABLESPACE SB_DWH_TBS PCTFREE 10 INITRANS 1 MAXTRANS 255 STORAGE (INITIAL 64K NEXT 1M MINEXTENTS 1 MAXEXTENTS UNLIMITED)';

   -- ============================================================
   -- 13. WRK_DIM_CLOS_CUSTOMER
   -- ============================================================
   BEGIN
      EXECUTE IMMEDIATE 'DROP TABLE SB_DWH.WRK_DIM_CLOS_CUSTOMER CASCADE CONSTRAINTS';
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF;
   END;
   EXECUTE IMMEDIATE 'CREATE TABLE SB_DWH.WRK_DIM_CLOS_CUSTOMER (
      customer_sk        NUMBER,
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
   ) TABLESPACE SB_DWH_TBS PCTFREE 10 INITRANS 1 MAXTRANS 255 STORAGE (INITIAL 64K NEXT 1M MINEXTENTS 1 MAXEXTENTS UNLIMITED)';

   -- ============================================================
   -- 14. WRK_DIM_RLOS_APPLICATION
   -- ============================================================
   BEGIN
      EXECUTE IMMEDIATE 'DROP TABLE SB_DWH.WRK_DIM_RLOS_APPLICATION CASCADE CONSTRAINTS';
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF;
   END;
   EXECUTE IMMEDIATE 'CREATE TABLE SB_DWH.WRK_DIM_RLOS_APPLICATION (
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
   ) TABLESPACE SB_DWH_TBS PCTFREE 10 INITRANS 1 MAXTRANS 255 STORAGE (INITIAL 64K NEXT 1M MINEXTENTS 1 MAXEXTENTS UNLIMITED)';

END;
