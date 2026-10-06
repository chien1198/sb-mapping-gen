-- SB_DWH: tao 11 bang WRK_DIM_* (DROP + CREATE). Chay 1 lan trong SQL Window (F8).
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
      promotion_code       VARCHAR2(100),
      promotion_desc       VARCHAR2(500),
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

END;
