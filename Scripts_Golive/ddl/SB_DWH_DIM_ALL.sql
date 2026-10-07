-- SB_DWH: tao 11 bang DIM (bang + PK + index). Chay 1 lan trong SQL Window (F8).
-- Tam thoi chua gom: DIM_CLOS_APPLICATION, DIM_CLOS_CUSTOMER, DIM_RLOS_APPLICATION (xem sb_dwh_dim/).
-- CANH BAO: DROP TABLE ... CASCADE CONSTRAINTS truoc khi tao => XOA SACH du lieu DIM cu.
BEGIN
   -- ============================================================
   -- DIM_CLOS_EXCEPTION
   -- ============================================================
   BEGIN
      EXECUTE IMMEDIATE 'DROP TABLE SB_DWH.DIM_CLOS_EXCEPTION CASCADE CONSTRAINTS';
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF;
   END;
   BEGIN
      EXECUTE IMMEDIATE 'create table SB_DWH.DIM_CLOS_EXCEPTION
      (
        dimension_key        NUMBER not null,
        exception_sk          NUMBER not null,
        exception_bk          VARCHAR2(64) not null,
        activityname          VARCHAR2(200) not null,
        decision_code          VARCHAR2(200) not null,
        exception_category    VARCHAR2(500) not null,
        exception_name        VARCHAR2(500) not null,
        exception_code        VARCHAR2(50),
        raise_flag            VARCHAR2(5),
        clear_flag            VARCHAR2(5),
        id_source             NUMBER,
        code_source            VARCHAR2(255),
        status                VARCHAR2(50),
        eff_date              DATE not null,
        exp_date              DATE
      )
      tablespace SB_DWH_TBS
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
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE NOT IN (-955, -2260) THEN RAISE; END IF;
   END;
   BEGIN
      EXECUTE IMMEDIATE 'alter table SB_DWH.DIM_CLOS_EXCEPTION
        add constraint DIM_CLOS_EXCEPTION_PK primary key (DIMENSION_KEY)
        using index
        tablespace SB_DWH_TBS
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
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE NOT IN (-955, -2260) THEN RAISE; END IF;
   END;
   BEGIN
      EXECUTE IMMEDIATE 'alter index SB_DWH.DIM_CLOS_EXCEPTION_PK nologging';
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE NOT IN (-955, -2260) THEN RAISE; END IF;
   END;
   BEGIN
      EXECUTE IMMEDIATE 'create index SB_DWH.EXCEPTION_BK_IDX_1 on SB_DWH.DIM_CLOS_EXCEPTION (EXCEPTION_BK)
        tablespace SB_DWH_TBS
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
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE NOT IN (-955, -2260) THEN RAISE; END IF;
   END;
   BEGIN
      EXECUTE IMMEDIATE 'create index SB_DWH.DIM_CLOS_EXCEPTION_EFF_DATE_IDX_1 on SB_DWH.DIM_CLOS_EXCEPTION (EFF_DATE)
        tablespace SB_DWH_TBS
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
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE NOT IN (-955, -2260) THEN RAISE; END IF;
   END;
   BEGIN
      EXECUTE IMMEDIATE 'create index SB_DWH.DIM_CLOS_EXCEPTION_EXP_DATE_IDX_1 on SB_DWH.DIM_CLOS_EXCEPTION (EXP_DATE)
        tablespace SB_DWH_TBS
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
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE NOT IN (-955, -2260) THEN RAISE; END IF;
   END;
   BEGIN
      EXECUTE IMMEDIATE 'create index SB_DWH.I_DIM_CLOS_EXCEPTION_EXCEPTION_SK on SB_DWH.DIM_CLOS_EXCEPTION (EXCEPTION_SK)
        tablespace SB_DWH_TBS
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
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE NOT IN (-955, -2260) THEN RAISE; END IF;
   END;

   -- ============================================================
   -- DIM_CLOS_PRODUCT
   -- ============================================================
   BEGIN
      EXECUTE IMMEDIATE 'DROP TABLE SB_DWH.DIM_CLOS_PRODUCT CASCADE CONSTRAINTS';
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF;
   END;
   BEGIN
      EXECUTE IMMEDIATE 'create table SB_DWH.DIM_CLOS_PRODUCT
      (
        dimension_key         NUMBER not null,
        product_sk             NUMBER not null,
        product_bk             VARCHAR2(64) not null,
        product_line_code      VARCHAR2(100) not null,
        product_line_name      VARCHAR2(200) not null,
        sub_product_code       VARCHAR2(100) not null,
        sub_product_name           VARCHAR2(150),
        eff_date               DATE not null,
        exp_date               DATE
      )
      tablespace SB_DWH_TBS
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
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE NOT IN (-955, -2260) THEN RAISE; END IF;
   END;
   BEGIN
      EXECUTE IMMEDIATE 'alter table SB_DWH.DIM_CLOS_PRODUCT
        add constraint DIM_CLOS_PRODUCT_PK primary key (DIMENSION_KEY)
        using index
        tablespace SB_DWH_TBS
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
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE NOT IN (-955, -2260) THEN RAISE; END IF;
   END;
   BEGIN
      EXECUTE IMMEDIATE 'alter index SB_DWH.DIM_CLOS_PRODUCT_PK nologging';
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE NOT IN (-955, -2260) THEN RAISE; END IF;
   END;
   BEGIN
      EXECUTE IMMEDIATE 'create index SB_DWH.PRODUCT_BK_IDX_1 on SB_DWH.DIM_CLOS_PRODUCT (PRODUCT_BK)
        tablespace SB_DWH_TBS
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
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE NOT IN (-955, -2260) THEN RAISE; END IF;
   END;
   BEGIN
      EXECUTE IMMEDIATE 'create index SB_DWH.DIM_CLOS_PRODUCT_EFF_DATE_IDX_1 on SB_DWH.DIM_CLOS_PRODUCT (EFF_DATE)
        tablespace SB_DWH_TBS
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
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE NOT IN (-955, -2260) THEN RAISE; END IF;
   END;
   BEGIN
      EXECUTE IMMEDIATE 'create index SB_DWH.DIM_CLOS_PRODUCT_EXP_DATE_IDX_1 on SB_DWH.DIM_CLOS_PRODUCT (EXP_DATE)
        tablespace SB_DWH_TBS
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
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE NOT IN (-955, -2260) THEN RAISE; END IF;
   END;
   BEGIN
      EXECUTE IMMEDIATE 'create index SB_DWH.I_DIM_CLOS_PRODUCT_PRODUCT_SK on SB_DWH.DIM_CLOS_PRODUCT (PRODUCT_SK)
        tablespace SB_DWH_TBS
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
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE NOT IN (-955, -2260) THEN RAISE; END IF;
   END;

   -- ============================================================
   -- DIM_CLOS_WORKSTEP_DECISION
   -- ============================================================
   BEGIN
      EXECUTE IMMEDIATE 'DROP TABLE SB_DWH.DIM_CLOS_WORKSTEP_DECISION CASCADE CONSTRAINTS';
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF;
   END;
   BEGIN
      EXECUTE IMMEDIATE 'create table SB_DWH.DIM_CLOS_WORKSTEP_DECISION
      (
        dimension_key            NUMBER not null,
        workstep_decision_sk      NUMBER not null,
        workstep_decision_bk      VARCHAR2(64) not null,
        workstep_code            VARCHAR2(200) not null,
        decision_code             VARCHAR2(200) not null,
        channel                  VARCHAR2(200),
        eff_date                 DATE not null,
        exp_date                 DATE
      )
      tablespace SB_DWH_TBS
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
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE NOT IN (-955, -2260) THEN RAISE; END IF;
   END;
   BEGIN
      EXECUTE IMMEDIATE 'alter table SB_DWH.DIM_CLOS_WORKSTEP_DECISION
        add constraint DIM_CLOS_WORKSTEP_DECISION_PK primary key (DIMENSION_KEY)
        using index
        tablespace SB_DWH_TBS
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
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE NOT IN (-955, -2260) THEN RAISE; END IF;
   END;
   BEGIN
      EXECUTE IMMEDIATE 'alter index SB_DWH.DIM_CLOS_WORKSTEP_DECISION_PK nologging';
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE NOT IN (-955, -2260) THEN RAISE; END IF;
   END;
   BEGIN
      EXECUTE IMMEDIATE 'create index SB_DWH.WORKSTEP_DECISION_BK_IDX_1 on SB_DWH.DIM_CLOS_WORKSTEP_DECISION (WORKSTEP_DECISION_BK)
        tablespace SB_DWH_TBS
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
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE NOT IN (-955, -2260) THEN RAISE; END IF;
   END;
   BEGIN
      EXECUTE IMMEDIATE 'create index SB_DWH.DIM_CLOS_WORKSTEP_DECISION_EFF_DATE_IDX_1 on SB_DWH.DIM_CLOS_WORKSTEP_DECISION (EFF_DATE)
        tablespace SB_DWH_TBS
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
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE NOT IN (-955, -2260) THEN RAISE; END IF;
   END;
   BEGIN
      EXECUTE IMMEDIATE 'create index SB_DWH.DIM_CLOS_WORKSTEP_DECISION_EXP_DATE_IDX_1 on SB_DWH.DIM_CLOS_WORKSTEP_DECISION (EXP_DATE)
        tablespace SB_DWH_TBS
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
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE NOT IN (-955, -2260) THEN RAISE; END IF;
   END;
   BEGIN
      EXECUTE IMMEDIATE 'create index SB_DWH.I_DIM_CLOS_WORKSTEP_DECISION_SK on SB_DWH.DIM_CLOS_WORKSTEP_DECISION (WORKSTEP_DECISION_SK)
        tablespace SB_DWH_TBS
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
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE NOT IN (-955, -2260) THEN RAISE; END IF;
   END;

   -- ============================================================
   -- DIM_LOS_COMPANY
   -- ============================================================
   BEGIN
      EXECUTE IMMEDIATE 'DROP TABLE SB_DWH.DIM_LOS_COMPANY CASCADE CONSTRAINTS';
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF;
   END;
   BEGIN
      EXECUTE IMMEDIATE 'create table SB_DWH.DIM_LOS_COMPANY
      (
        dimension_key    NUMBER not null,
        company_sk        NUMBER not null,
        company_code      VARCHAR2(50),
        company_name      VARCHAR2(200),
        company_address   VARCHAR2(500),
        company_email     VARCHAR2(200),
        zone             NUMBER,
        branch_code       VARCHAR2(50),
        branch_name       VARCHAR2(200),
        city              VARCHAR2(100),
        district          VARCHAR2(100),
        region_code       NUMBER,
        region_name       VARCHAR2(200),
        eff_date         DATE not null,
        exp_date         DATE
      )
      tablespace SB_DWH_TBS
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
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE NOT IN (-955, -2260) THEN RAISE; END IF;
   END;
   BEGIN
      EXECUTE IMMEDIATE 'alter table SB_DWH.DIM_LOS_COMPANY
        add constraint DIM_LOS_COMPANY_PK primary key (DIMENSION_KEY)
        using index
        tablespace SB_DWH_TBS
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
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE NOT IN (-955, -2260) THEN RAISE; END IF;
   END;
   BEGIN
      EXECUTE IMMEDIATE 'alter index SB_DWH.DIM_LOS_COMPANY_PK nologging';
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE NOT IN (-955, -2260) THEN RAISE; END IF;
   END;
   BEGIN
      EXECUTE IMMEDIATE 'create index SB_DWH.COMPANY_CODE_IDX_1 on SB_DWH.DIM_LOS_COMPANY (COMPANY_CODE)
        tablespace SB_DWH_TBS
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
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE NOT IN (-955, -2260) THEN RAISE; END IF;
   END;
   BEGIN
      EXECUTE IMMEDIATE 'create index SB_DWH.DIM_LOS_COMPANY_EFF_DATE_IDX_1 on SB_DWH.DIM_LOS_COMPANY (EFF_DATE)
        tablespace SB_DWH_TBS
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
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE NOT IN (-955, -2260) THEN RAISE; END IF;
   END;
   BEGIN
      EXECUTE IMMEDIATE 'create index SB_DWH.DIM_LOS_COMPANY_EXP_DATE_IDX_1 on SB_DWH.DIM_LOS_COMPANY (EXP_DATE)
        tablespace SB_DWH_TBS
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
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE NOT IN (-955, -2260) THEN RAISE; END IF;
   END;
   BEGIN
      EXECUTE IMMEDIATE 'create index SB_DWH.I_DIM_LOS_COMPANY_COMPANY_SK on SB_DWH.DIM_LOS_COMPANY (COMPANY_SK)
        tablespace SB_DWH_TBS
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
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE NOT IN (-955, -2260) THEN RAISE; END IF;
   END;

   -- ============================================================
   -- DIM_LOS_USER
   -- ============================================================
   BEGIN
      EXECUTE IMMEDIATE 'DROP TABLE SB_DWH.DIM_LOS_USER CASCADE CONSTRAINTS';
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF;
   END;
   BEGIN
      EXECUTE IMMEDIATE 'create table SB_DWH.DIM_LOS_USER
      (
        dimension_key           NUMBER not null,
        user_sk                  NUMBER not null,
        username                 VARCHAR2(100) not null,
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
        eff_date                DATE not null,
        exp_date                DATE
      )
      tablespace SB_DWH_TBS
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
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE NOT IN (-955, -2260) THEN RAISE; END IF;
   END;
   BEGIN
      EXECUTE IMMEDIATE 'alter table SB_DWH.DIM_LOS_USER
        add constraint DIM_LOS_USER_PK primary key (DIMENSION_KEY)
        using index
        tablespace SB_DWH_TBS
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
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE NOT IN (-955, -2260) THEN RAISE; END IF;
   END;
   BEGIN
      EXECUTE IMMEDIATE 'alter index SB_DWH.DIM_LOS_USER_PK nologging';
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE NOT IN (-955, -2260) THEN RAISE; END IF;
   END;
   BEGIN
      EXECUTE IMMEDIATE 'create index SB_DWH.USERNAME_IDX_1 on SB_DWH.DIM_LOS_USER (USERNAME)
        tablespace SB_DWH_TBS
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
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE NOT IN (-955, -2260) THEN RAISE; END IF;
   END;
   BEGIN
      EXECUTE IMMEDIATE 'create index SB_DWH.DIM_LOS_USER_EFF_DATE_IDX_1 on SB_DWH.DIM_LOS_USER (EFF_DATE)
        tablespace SB_DWH_TBS
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
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE NOT IN (-955, -2260) THEN RAISE; END IF;
   END;
   BEGIN
      EXECUTE IMMEDIATE 'create index SB_DWH.DIM_LOS_USER_EXP_DATE_IDX_1 on SB_DWH.DIM_LOS_USER (EXP_DATE)
        tablespace SB_DWH_TBS
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
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE NOT IN (-955, -2260) THEN RAISE; END IF;
   END;
   BEGIN
      EXECUTE IMMEDIATE 'create index SB_DWH.I_DIM_LOS_USER_USER_SK on SB_DWH.DIM_LOS_USER (USER_SK)
        tablespace SB_DWH_TBS
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
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE NOT IN (-955, -2260) THEN RAISE; END IF;
   END;

   -- ============================================================
   -- DIM_RLOS_CARD_PROMOTION
   -- ============================================================
   BEGIN
      EXECUTE IMMEDIATE 'DROP TABLE SB_DWH.DIM_RLOS_CARD_PROMOTION CASCADE CONSTRAINTS';
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF;
   END;
   BEGIN
      EXECUTE IMMEDIATE 'create table SB_DWH.DIM_RLOS_CARD_PROMOTION
      (
        dimension_key       NUMBER not null,
        card_promotion_sk     NUMBER not null,
        promotion_code       VARCHAR2(100) not null,
        promotion_desc       VARCHAR2(500),
        eff_date            DATE not null,
        exp_date            DATE
      )
      tablespace SB_DWH_TBS
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
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE NOT IN (-955, -2260) THEN RAISE; END IF;
   END;
   BEGIN
      EXECUTE IMMEDIATE 'alter table SB_DWH.DIM_RLOS_CARD_PROMOTION
        add constraint DIM_RLOS_CARD_PROMOTION_PK primary key (DIMENSION_KEY)
        using index
        tablespace SB_DWH_TBS
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
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE NOT IN (-955, -2260) THEN RAISE; END IF;
   END;
   BEGIN
      EXECUTE IMMEDIATE 'alter index SB_DWH.DIM_RLOS_CARD_PROMOTION_PK nologging';
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE NOT IN (-955, -2260) THEN RAISE; END IF;
   END;
   BEGIN
      EXECUTE IMMEDIATE 'create index SB_DWH.PROMOTION_CODE_IDX_1 on SB_DWH.DIM_RLOS_CARD_PROMOTION (PROMOTION_CODE)
        tablespace SB_DWH_TBS
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
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE NOT IN (-955, -2260) THEN RAISE; END IF;
   END;
   BEGIN
      EXECUTE IMMEDIATE 'create index SB_DWH.DIM_RLOS_CARD_PROMOTION_EFF_DATE_IDX_1 on SB_DWH.DIM_RLOS_CARD_PROMOTION (EFF_DATE)
        tablespace SB_DWH_TBS
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
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE NOT IN (-955, -2260) THEN RAISE; END IF;
   END;
   BEGIN
      EXECUTE IMMEDIATE 'create index SB_DWH.DIM_RLOS_CARD_PROMOTION_EXP_DATE_IDX_1 on SB_DWH.DIM_RLOS_CARD_PROMOTION (EXP_DATE)
        tablespace SB_DWH_TBS
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
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE NOT IN (-955, -2260) THEN RAISE; END IF;
   END;
   BEGIN
      EXECUTE IMMEDIATE 'create index SB_DWH.I_DIM_RLOS_CARD_PROMOTION_SK on SB_DWH.DIM_RLOS_CARD_PROMOTION (CARD_PROMOTION_SK)
        tablespace SB_DWH_TBS
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
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE NOT IN (-955, -2260) THEN RAISE; END IF;
   END;

   -- ============================================================
   -- DIM_RLOS_CHANGE_TYPE
   -- ============================================================
   BEGIN
      EXECUTE IMMEDIATE 'DROP TABLE SB_DWH.DIM_RLOS_CHANGE_TYPE CASCADE CONSTRAINTS';
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF;
   END;
   BEGIN
      EXECUTE IMMEDIATE 'create table SB_DWH.DIM_RLOS_CHANGE_TYPE
      (
        dimension_key               NUMBER not null,
        change_type_sk               NUMBER not null,
        change_type_bk               VARCHAR2(64) not null,
        change_type_code             VARCHAR2(100) not null,
        change_type_name             VARCHAR2(200),
        detail_change_type_code      VARCHAR2(100) not null,
        detail_change_type_name      VARCHAR2(500),
        eff_date                    DATE not null,
        exp_date                    DATE
      )
      tablespace SB_DWH_TBS
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
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE NOT IN (-955, -2260) THEN RAISE; END IF;
   END;
   BEGIN
      EXECUTE IMMEDIATE 'alter table SB_DWH.DIM_RLOS_CHANGE_TYPE
        add constraint DIM_RLOS_CHANGE_TYPE_PK primary key (DIMENSION_KEY)
        using index
        tablespace SB_DWH_TBS
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
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE NOT IN (-955, -2260) THEN RAISE; END IF;
   END;
   BEGIN
      EXECUTE IMMEDIATE 'alter index SB_DWH.DIM_RLOS_CHANGE_TYPE_PK nologging';
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE NOT IN (-955, -2260) THEN RAISE; END IF;
   END;
   BEGIN
      EXECUTE IMMEDIATE 'create index SB_DWH.CHANGE_TYPE_BK_IDX_1 on SB_DWH.DIM_RLOS_CHANGE_TYPE (CHANGE_TYPE_BK)
        tablespace SB_DWH_TBS
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
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE NOT IN (-955, -2260) THEN RAISE; END IF;
   END;
   BEGIN
      EXECUTE IMMEDIATE 'create index SB_DWH.DIM_RLOS_CHANGE_TYPE_EFF_DATE_IDX_1 on SB_DWH.DIM_RLOS_CHANGE_TYPE (EFF_DATE)
        tablespace SB_DWH_TBS
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
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE NOT IN (-955, -2260) THEN RAISE; END IF;
   END;
   BEGIN
      EXECUTE IMMEDIATE 'create index SB_DWH.DIM_RLOS_CHANGE_TYPE_EXP_DATE_IDX_1 on SB_DWH.DIM_RLOS_CHANGE_TYPE (EXP_DATE)
        tablespace SB_DWH_TBS
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
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE NOT IN (-955, -2260) THEN RAISE; END IF;
   END;
   BEGIN
      EXECUTE IMMEDIATE 'create index SB_DWH.I_DIM_RLOS_CHANGE_TYPE_SK on SB_DWH.DIM_RLOS_CHANGE_TYPE (CHANGE_TYPE_SK)
        tablespace SB_DWH_TBS
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
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE NOT IN (-955, -2260) THEN RAISE; END IF;
   END;

   -- ============================================================
   -- DIM_RLOS_EXCEPTION
   -- ============================================================
   BEGIN
      EXECUTE IMMEDIATE 'DROP TABLE SB_DWH.DIM_RLOS_EXCEPTION CASCADE CONSTRAINTS';
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF;
   END;
   BEGIN
      EXECUTE IMMEDIATE 'create table SB_DWH.DIM_RLOS_EXCEPTION
      (
        dimension_key        NUMBER not null,
        exception_sk          NUMBER not null,
        exception_bk          VARCHAR2(64) not null,
        activityname          VARCHAR2(200) not null,
        decision_code          VARCHAR2(200) not null,
        exception_category    VARCHAR2(500) not null,
        exception_name        VARCHAR2(500) not null,
        exception_code        VARCHAR2(50),
        raise_flag            VARCHAR2(5),
        clear_flag            VARCHAR2(5),
        id_source             NUMBER,
        code_source            VARCHAR2(255),
        status                VARCHAR2(50),
        eff_date              DATE not null,
        exp_date              DATE
      )
      tablespace SB_DWH_TBS
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
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE NOT IN (-955, -2260) THEN RAISE; END IF;
   END;
   BEGIN
      EXECUTE IMMEDIATE 'alter table SB_DWH.DIM_RLOS_EXCEPTION
        add constraint DIM_RLOS_EXCEPTION_PK primary key (DIMENSION_KEY)
        using index
        tablespace SB_DWH_TBS
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
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE NOT IN (-955, -2260) THEN RAISE; END IF;
   END;
   BEGIN
      EXECUTE IMMEDIATE 'alter index SB_DWH.DIM_RLOS_EXCEPTION_PK nologging';
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE NOT IN (-955, -2260) THEN RAISE; END IF;
   END;
   BEGIN
      EXECUTE IMMEDIATE 'create index SB_DWH.RLOS_EXCEPTION_BK_IDX_1 on SB_DWH.DIM_RLOS_EXCEPTION (EXCEPTION_BK)
        tablespace SB_DWH_TBS
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
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE NOT IN (-955, -2260) THEN RAISE; END IF;
   END;
   BEGIN
      EXECUTE IMMEDIATE 'create index SB_DWH.DIM_RLOS_EXCEPTION_EFF_DATE_IDX_1 on SB_DWH.DIM_RLOS_EXCEPTION (EFF_DATE)
        tablespace SB_DWH_TBS
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
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE NOT IN (-955, -2260) THEN RAISE; END IF;
   END;
   BEGIN
      EXECUTE IMMEDIATE 'create index SB_DWH.DIM_RLOS_EXCEPTION_EXP_DATE_IDX_1 on SB_DWH.DIM_RLOS_EXCEPTION (EXP_DATE)
        tablespace SB_DWH_TBS
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
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE NOT IN (-955, -2260) THEN RAISE; END IF;
   END;
   BEGIN
      EXECUTE IMMEDIATE 'create index SB_DWH.I_DIM_RLOS_EXCEPTION_EXCEPTION_SK on SB_DWH.DIM_RLOS_EXCEPTION (EXCEPTION_SK)
        tablespace SB_DWH_TBS
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
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE NOT IN (-955, -2260) THEN RAISE; END IF;
   END;

   -- ============================================================
   -- DIM_RLOS_PRODUCT
   -- ============================================================
   BEGIN
      EXECUTE IMMEDIATE 'DROP TABLE SB_DWH.DIM_RLOS_PRODUCT CASCADE CONSTRAINTS';
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF;
   END;
   BEGIN
      EXECUTE IMMEDIATE 'create table SB_DWH.DIM_RLOS_PRODUCT
      (
        dimension_key       NUMBER not null,
        product_sk           NUMBER not null,
        product_bk           VARCHAR2(64) not null,
        productline_code     VARCHAR2(100),
        productline_name     VARCHAR2(200),
        sub_product_code     VARCHAR2(100),
        sub_product_name     VARCHAR2(150),
        score_required       VARCHAR2(10),
        score_model          VARCHAR2(100),
        eff_date            DATE not null,
        exp_date            DATE
      )
      tablespace SB_DWH_TBS
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
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE NOT IN (-955, -2260) THEN RAISE; END IF;
   END;
   BEGIN
      EXECUTE IMMEDIATE 'alter table SB_DWH.DIM_RLOS_PRODUCT
        add constraint DIM_RLOS_PRODUCT_PK primary key (DIMENSION_KEY)
        using index
        tablespace SB_DWH_TBS
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
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE NOT IN (-955, -2260) THEN RAISE; END IF;
   END;
   BEGIN
      EXECUTE IMMEDIATE 'alter index SB_DWH.DIM_RLOS_PRODUCT_PK nologging';
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE NOT IN (-955, -2260) THEN RAISE; END IF;
   END;
   BEGIN
      EXECUTE IMMEDIATE 'create index SB_DWH.RLOS_PRODUCT_BK_IDX_1 on SB_DWH.DIM_RLOS_PRODUCT (PRODUCT_BK)
        tablespace SB_DWH_TBS
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
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE NOT IN (-955, -2260) THEN RAISE; END IF;
   END;
   BEGIN
      EXECUTE IMMEDIATE 'create index SB_DWH.DIM_RLOS_PRODUCT_EFF_DATE_IDX_1 on SB_DWH.DIM_RLOS_PRODUCT (EFF_DATE)
        tablespace SB_DWH_TBS
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
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE NOT IN (-955, -2260) THEN RAISE; END IF;
   END;
   BEGIN
      EXECUTE IMMEDIATE 'create index SB_DWH.DIM_RLOS_PRODUCT_EXP_DATE_IDX_1 on SB_DWH.DIM_RLOS_PRODUCT (EXP_DATE)
        tablespace SB_DWH_TBS
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
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE NOT IN (-955, -2260) THEN RAISE; END IF;
   END;
   BEGIN
      EXECUTE IMMEDIATE 'create index SB_DWH.I_DIM_RLOS_PRODUCT_PRODUCT_SK on SB_DWH.DIM_RLOS_PRODUCT (PRODUCT_SK)
        tablespace SB_DWH_TBS
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
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE NOT IN (-955, -2260) THEN RAISE; END IF;
   END;

   -- ============================================================
   -- DIM_RLOS_SECONDPRODUCT
   -- ============================================================
   BEGIN
      EXECUTE IMMEDIATE 'DROP TABLE SB_DWH.DIM_RLOS_SECONDPRODUCT CASCADE CONSTRAINTS';
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF;
   END;
   BEGIN
      EXECUTE IMMEDIATE 'create table SB_DWH.DIM_RLOS_SECONDPRODUCT
      (
        dimension_key        NUMBER not null,
        secondproduct_sk       NUMBER not null,
        secondproduct_bk       VARCHAR2(64) not null,
        productline_code       VARCHAR2(200) not null,
        productline_name       VARCHAR2(200),
        secondary_product      VARCHAR2(200),
        eff_date              DATE not null,
        exp_date              DATE
      )
      tablespace SB_DWH_TBS
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
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE NOT IN (-955, -2260) THEN RAISE; END IF;
   END;
   BEGIN
      EXECUTE IMMEDIATE 'alter table SB_DWH.DIM_RLOS_SECONDPRODUCT
        add constraint DIM_RLOS_SECONDPRODUCT_PK primary key (DIMENSION_KEY)
        using index
        tablespace SB_DWH_TBS
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
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE NOT IN (-955, -2260) THEN RAISE; END IF;
   END;
   BEGIN
      EXECUTE IMMEDIATE 'alter index SB_DWH.DIM_RLOS_SECONDPRODUCT_PK nologging';
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE NOT IN (-955, -2260) THEN RAISE; END IF;
   END;
   BEGIN
      EXECUTE IMMEDIATE 'create index SB_DWH.SECONDPRODUCT_BK_IDX_1 on SB_DWH.DIM_RLOS_SECONDPRODUCT (SECONDPRODUCT_BK)
        tablespace SB_DWH_TBS
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
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE NOT IN (-955, -2260) THEN RAISE; END IF;
   END;
   BEGIN
      EXECUTE IMMEDIATE 'create index SB_DWH.DIM_RLOS_SECONDPRODUCT_EFF_DATE_IDX_1 on SB_DWH.DIM_RLOS_SECONDPRODUCT (EFF_DATE)
        tablespace SB_DWH_TBS
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
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE NOT IN (-955, -2260) THEN RAISE; END IF;
   END;
   BEGIN
      EXECUTE IMMEDIATE 'create index SB_DWH.DIM_RLOS_SECONDPRODUCT_EXP_DATE_IDX_1 on SB_DWH.DIM_RLOS_SECONDPRODUCT (EXP_DATE)
        tablespace SB_DWH_TBS
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
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE NOT IN (-955, -2260) THEN RAISE; END IF;
   END;
   BEGIN
      EXECUTE IMMEDIATE 'create index SB_DWH.I_DIM_RLOS_SECONDPRODUCT_SK on SB_DWH.DIM_RLOS_SECONDPRODUCT (SECONDPRODUCT_SK)
        tablespace SB_DWH_TBS
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
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE NOT IN (-955, -2260) THEN RAISE; END IF;
   END;

   -- ============================================================
   -- DIM_RLOS_WORKSTEP_DECISION
   -- ============================================================
   BEGIN
      EXECUTE IMMEDIATE 'DROP TABLE SB_DWH.DIM_RLOS_WORKSTEP_DECISION CASCADE CONSTRAINTS';
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF;
   END;
   BEGIN
      EXECUTE IMMEDIATE 'create table SB_DWH.DIM_RLOS_WORKSTEP_DECISION
      (
        dimension_key            NUMBER not null,
        workstep_decision_sk      NUMBER not null,
        workstep_decision_bk      VARCHAR2(64) not null,
        workstep_code            VARCHAR2(200) not null,
        decision_code             VARCHAR2(200) not null,
        eff_date                 DATE not null,
        exp_date                 DATE
      )
      tablespace SB_DWH_TBS
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
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE NOT IN (-955, -2260) THEN RAISE; END IF;
   END;
   BEGIN
      EXECUTE IMMEDIATE 'alter table SB_DWH.DIM_RLOS_WORKSTEP_DECISION
        add constraint DIM_RLOS_WORKSTEP_DECISION_PK primary key (DIMENSION_KEY)
        using index
        tablespace SB_DWH_TBS
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
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE NOT IN (-955, -2260) THEN RAISE; END IF;
   END;
   BEGIN
      EXECUTE IMMEDIATE 'alter index SB_DWH.DIM_RLOS_WORKSTEP_DECISION_PK nologging';
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE NOT IN (-955, -2260) THEN RAISE; END IF;
   END;
   BEGIN
      EXECUTE IMMEDIATE 'create index SB_DWH.RLOS_WORKSTEP_DECISION_BK_IDX_1 on SB_DWH.DIM_RLOS_WORKSTEP_DECISION (WORKSTEP_DECISION_BK)
        tablespace SB_DWH_TBS
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
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE NOT IN (-955, -2260) THEN RAISE; END IF;
   END;
   BEGIN
      EXECUTE IMMEDIATE 'create index SB_DWH.DIM_RLOS_WORKSTEP_DECISION_EFF_DATE_IDX_1 on SB_DWH.DIM_RLOS_WORKSTEP_DECISION (EFF_DATE)
        tablespace SB_DWH_TBS
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
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE NOT IN (-955, -2260) THEN RAISE; END IF;
   END;
   BEGIN
      EXECUTE IMMEDIATE 'create index SB_DWH.DIM_RLOS_WORKSTEP_DECISION_EXP_DATE_IDX_1 on SB_DWH.DIM_RLOS_WORKSTEP_DECISION (EXP_DATE)
        tablespace SB_DWH_TBS
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
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE NOT IN (-955, -2260) THEN RAISE; END IF;
   END;
   BEGIN
      EXECUTE IMMEDIATE 'create index SB_DWH.I_DIM_RLOS_WORKSTEP_DECISION_SK on SB_DWH.DIM_RLOS_WORKSTEP_DECISION (WORKSTEP_DECISION_SK)
        tablespace SB_DWH_TBS
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
   EXCEPTION
      WHEN OTHERS THEN IF SQLCODE NOT IN (-955, -2260) THEN RAISE; END IF;
   END;

END;
