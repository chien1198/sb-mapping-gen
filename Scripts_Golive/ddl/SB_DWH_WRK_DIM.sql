-- SB_DWH: tao 17 bang WRK_DIM_* (CREATE). Chay 1 lan trong SQL Window (F8).
-- Review 2026-10-12: WRK_DIM_LOS_COMPANY (1 bang) tach thanh 3 bang rieng
-- theo layer SCD2 doc lap cua DIM_LOS_COMPANY — WRK_DIM_LOS_COMPANY_REGION,
-- WRK_DIM_LOS_COMPANY_BRANCH, WRK_DIM_LOS_COMPANY_COMPANY (14 -> 16 bang).
-- WRK_DIM_CLOS_PRODUCT (1 bang) tach thanh 2 bang rieng theo layer SCD2
-- doc lap cua DIM_CLOS_PRODUCT — WRK_DIM_CLOS_PRODUCT_LINE,
-- WRK_DIM_CLOS_PRODUCT_SUB (16 -> 17 bang).
-- Tam thoi chua GRANT cho FSS_STG_LOS, CIC_FSS (se bo sung sau).
BEGIN
   -- ============================================================
   -- 1. WRK_DIM_LOS_USER
   -- ============================================================
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
   -- ============================================================
   -- 2a. WRK_DIM_CLOS_PRODUCT_LINE (layer Product Line — CDC độc lập từ NG_SB_CLOS_MAS_PRO_LINE)
   -- ============================================================
   EXECUTE IMMEDIATE 'CREATE TABLE SB_DWH.WRK_DIM_CLOS_PRODUCT_LINE (
      productline_sk         NUMBER,
      productline_code       VARCHAR2(100),
      productline_name       VARCHAR2(200),
      productline_eff_date   DATE,
      productline_exp_date   DATE
   ) TABLESPACE SB_DWH_TBS PCTFREE 10 INITRANS 1 MAXTRANS 255 STORAGE (INITIAL 64K NEXT 1M MINEXTENTS 1 MAXEXTENTS UNLIMITED)';

   -- ============================================================
   -- 2b. WRK_DIM_CLOS_PRODUCT_SUB (layer Sub Product — CDC độc lập từ NG_SB_CLOS_MAS_SUB_PROD,
   --     denormalize sẵn layer Product Line tương ứng để phục vụ MERGE vào DIM_CLOS_PRODUCT)
   -- ============================================================
   EXECUTE IMMEDIATE 'CREATE TABLE SB_DWH.WRK_DIM_CLOS_PRODUCT_SUB (
      sub_product_sk         NUMBER,
      sub_product_code       VARCHAR2(100),
      sub_product_name       VARCHAR2(150),
      sub_product_active     VARCHAR2(100),
      sub_product_eff_date   DATE,
      sub_product_exp_date   DATE,
      productline_sk         NUMBER,
      productline_code       VARCHAR2(100),
      productline_name       VARCHAR2(200),
      productline_eff_date   DATE,
      productline_exp_date   DATE
   ) TABLESPACE SB_DWH_TBS PCTFREE 10 INITRANS 1 MAXTRANS 255 STORAGE (INITIAL 64K NEXT 1M MINEXTENTS 1 MAXEXTENTS UNLIMITED)';
   -- ============================================================
   -- 3. WRK_DIM_CLOS_EXCEPTION
   -- ============================================================
   EXECUTE IMMEDIATE 'CREATE TABLE SB_DWH.WRK_DIM_CLOS_EXCEPTION (
      exception_sk          NUMBER,
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
   -- 4a. WRK_DIM_LOS_COMPANY_REGION (layer Region — CDC độc lập từ NG_SB_RLOS_MAS_REGION)
   -- ============================================================
   EXECUTE IMMEDIATE 'CREATE TABLE SB_DWH.WRK_DIM_LOS_COMPANY_REGION (
      region_sk          NUMBER,
      region_code        NUMBER,
      region_name        VARCHAR2(200),
      region_eff_date    DATE,
      region_exp_date    DATE
   ) TABLESPACE SB_DWH_TBS PCTFREE 10 INITRANS 1 MAXTRANS 255 STORAGE (INITIAL 64K NEXT 1M MINEXTENTS 1 MAXEXTENTS UNLIMITED)';

   -- ============================================================
   -- 4b. WRK_DIM_LOS_COMPANY_BRANCH (layer Branch — CDC độc lập từ NG_SB_RLOS_MAS_BRANCH,
   --     denormalize sẵn layer Region tương ứng để phục vụ MERGE vào DIM_LOS_COMPANY)
   -- ============================================================
   EXECUTE IMMEDIATE 'CREATE TABLE SB_DWH.WRK_DIM_LOS_COMPANY_BRANCH (
      branch_sk          NUMBER,
      branch_code        VARCHAR2(50),
      branch_name        VARCHAR2(200),
      branch_eff_date    DATE,
      branch_exp_date    DATE,
      region_sk          NUMBER,
      region_code        NUMBER,
      region_name        VARCHAR2(200),
      region_eff_date    DATE,
      region_exp_date    DATE
   ) TABLESPACE SB_DWH_TBS PCTFREE 10 INITRANS 1 MAXTRANS 255 STORAGE (INITIAL 64K NEXT 1M MINEXTENTS 1 MAXEXTENTS UNLIMITED)';

   -- ============================================================
   -- 4c. WRK_DIM_LOS_COMPANY_COMPANY (layer Company — CDC độc lập từ NG_SB_RLOS_MAS_COMPANY,
   --     denormalize sẵn layer Branch+Region tương ứng — đây là bảng dùng để MERGE vào DIM_LOS_COMPANY thật)
   -- ============================================================
   EXECUTE IMMEDIATE 'CREATE TABLE SB_DWH.WRK_DIM_LOS_COMPANY_COMPANY (
      company_sk         NUMBER,
      company_code       VARCHAR2(50),
      company_name       VARCHAR2(200),
      company_address    VARCHAR2(500),
      company_email      VARCHAR2(200),
      zone               NUMBER,
      company_eff_date   DATE,
      company_exp_date   DATE,
      branch_sk          NUMBER,
      branch_code        VARCHAR2(50),
      branch_name        VARCHAR2(200),
      branch_eff_date    DATE,
      branch_exp_date    DATE,
      region_sk          NUMBER,
      region_code        NUMBER,
      region_name        VARCHAR2(200),
      region_eff_date    DATE,
      region_exp_date    DATE
   ) TABLESPACE SB_DWH_TBS PCTFREE 10 INITRANS 1 MAXTRANS 255 STORAGE (INITIAL 64K NEXT 1M MINEXTENTS 1 MAXEXTENTS UNLIMITED)';

   -- ============================================================
   -- 5. WRK_DIM_RLOS_CARD_PROMOTION
   -- ============================================================
   EXECUTE IMMEDIATE 'CREATE TABLE SB_DWH.WRK_DIM_RLOS_CARD_PROMOTION (
      card_promotion_sk    NUMBER,
      promotion_code       NVARCHAR2(255),
      promotion_desc       NVARCHAR2(255),
      pro_trans            NVARCHAR2(255),
      pro_valid            NVARCHAR2(255),
      order_promotion      NVARCHAR2(255),
      eff_date             DATE,
      exp_date             DATE
   ) TABLESPACE SB_DWH_TBS PCTFREE 10 INITRANS 1 MAXTRANS 255 STORAGE (INITIAL 64K NEXT 1M MINEXTENTS 1 MAXEXTENTS UNLIMITED)';

   -- ============================================================
   -- 6. WRK_DIM_RLOS_CHANGE_TYPE
   -- ============================================================
   EXECUTE IMMEDIATE 'CREATE TABLE SB_DWH.WRK_DIM_RLOS_CHANGE_TYPE (
      change_type_sk              NUMBER,
      change_type_code            VARCHAR2(100),
      change_type_name            VARCHAR2(200),
      detail_change_type_code     VARCHAR2(100),
      detail_change_type_name     VARCHAR2(500),
      is_active                   VARCHAR2(1),
      eff_date                    DATE,
      exp_date                    DATE
   ) TABLESPACE SB_DWH_TBS PCTFREE 10 INITRANS 1 MAXTRANS 255 STORAGE (INITIAL 64K NEXT 1M MINEXTENTS 1 MAXEXTENTS UNLIMITED)';

   -- ============================================================
   -- 7. WRK_DIM_RLOS_EXCEPTION
   -- ============================================================
   EXECUTE IMMEDIATE 'CREATE TABLE SB_DWH.WRK_DIM_RLOS_EXCEPTION (
      exception_sk          NUMBER,
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
   EXECUTE IMMEDIATE 'CREATE TABLE SB_DWH.WRK_DIM_RLOS_SECONDPRODUCT (
      secondproduct_sk       NUMBER,
      productline_code       VARCHAR2(200),
      productline_name       VARCHAR2(200),
      secondary_product      VARCHAR2(200),
      eff_date               DATE,
      exp_date               DATE
   ) TABLESPACE SB_DWH_TBS PCTFREE 10 INITRANS 1 MAXTRANS 255 STORAGE (INITIAL 64K NEXT 1M MINEXTENTS 1 MAXEXTENTS UNLIMITED)';

   -- ============================================================
   -- 9a. WRK_DIM_RLOS_PRODUCT_LINE (layer Product Line - layer cha, khong SCD2 rieng)
   -- ============================================================
   EXECUTE IMMEDIATE 'CREATE TABLE SB_DWH.WRK_DIM_RLOS_PRODUCT_LINE (
      productline_sk      NUMBER,
      productline_code    VARCHAR2(100),
      productline_name    VARCHAR2(200)
   ) TABLESPACE SB_DWH_TBS PCTFREE 10 INITRANS 1 MAXTRANS 255 STORAGE (INITIAL 64K NEXT 1M MINEXTENTS 1 MAXEXTENTS UNLIMITED)';

   -- ============================================================
   -- 9b. WRK_DIM_RLOS_PRODUCT_SUB (layer Sub Product - CDC tu NG_SB_RLOS_MAS_SUB_PRODUCT,
   --     denormalize san layer Product Line cha de phuc vu MERGE vao DIM_RLOS_PRODUCT)
   -- ============================================================
   EXECUTE IMMEDIATE 'CREATE TABLE SB_DWH.WRK_DIM_RLOS_PRODUCT_SUB (
      sub_product_sk      NUMBER,
      sub_product_code    VARCHAR2(100),
      sub_product_name    VARCHAR2(150),
      score_required      VARCHAR2(10),
      score_model         VARCHAR2(100),
      eff_date            DATE,
      exp_date            DATE,
      productline_sk      NUMBER,
      productline_code    VARCHAR2(100),
      productline_name    VARCHAR2(200)
   ) TABLESPACE SB_DWH_TBS PCTFREE 10 INITRANS 1 MAXTRANS 255 STORAGE (INITIAL 64K NEXT 1M MINEXTENTS 1 MAXEXTENTS UNLIMITED)';
*/
   -- ============================================================
   -- 10. WRK_DIM_RLOS_WORKSTEP_DECISION
   -- ============================================================
   EXECUTE IMMEDIATE 'CREATE TABLE SB_DWH.WRK_DIM_RLOS_WORKSTEP_DECISION (
      workstep_decision_sk     NUMBER,
      workstep_code            VARCHAR2(200),
      decision_code            VARCHAR2(200),
      req_type                 VARCHAR2(255),
      eff_date                 DATE,
      exp_date                 DATE
   ) TABLESPACE SB_DWH_TBS PCTFREE 10 INITRANS 1 MAXTRANS 255 STORAGE (INITIAL 64K NEXT 1M MINEXTENTS 1 MAXEXTENTS UNLIMITED)';

   -- ============================================================
   -- 11. WRK_DIM_CLOS_WORKSTEP_DECISION
   -- ============================================================
   EXECUTE IMMEDIATE 'CREATE TABLE SB_DWH.WRK_DIM_CLOS_WORKSTEP_DECISION (
      workstep_decision_sk     NUMBER,
      workstep_code            VARCHAR2(200),
      decision_code            VARCHAR2(200),
      channel                  VARCHAR2(200),
      eff_date                 DATE,
      exp_date                 DATE
   ) TABLESPACE SB_DWH_TBS PCTFREE 10 INITRANS 1 MAXTRANS 255 STORAGE (INITIAL 64K NEXT 1M MINEXTENTS 1 MAXEXTENTS UNLIMITED)';

   -- ============================================================
   -- 12. WRK_DIM_CLOS_APPLICATION
   -- ============================================================
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
      customer_code            VARCHAR2(100),
      channel                  VARCHAR2(200),
      eff_date                 DATE,
      exp_date                 DATE
   ) TABLESPACE SB_DWH_TBS PCTFREE 10 INITRANS 1 MAXTRANS 255 STORAGE (INITIAL 64K NEXT 1M MINEXTENTS 1 MAXEXTENTS UNLIMITED)';

   -- ============================================================
   -- 13. WRK_DIM_CLOS_CUSTOMER
   -- ============================================================
   EXECUTE IMMEDIATE 'CREATE TABLE SB_DWH.WRK_DIM_CLOS_CUSTOMER (
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
      exp_date           DATE
   ) TABLESPACE SB_DWH_TBS PCTFREE 10 INITRANS 1 MAXTRANS 255 STORAGE (INITIAL 64K NEXT 1M MINEXTENTS 1 MAXEXTENTS UNLIMITED)';

   -- ============================================================
   -- 14. WRK_DIM_RLOS_APPLICATION
   -- ============================================================
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
   ) TABLESPACE SB_DWH_TBS PCTFREE 10 INITRANS 1 MAXTRANS 255 STORAGE (INITIAL 64K NEXT 1M MINEXTENTS 1 MAXEXTENTS UNLIMITED)';

END;
