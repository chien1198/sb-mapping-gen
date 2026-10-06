-- Create table
create table SB_DWH.DIM_RLOS_APPLICATION
(
  dimension_key               NUMBER not null,
  application_sk               NUMBER not null,
  wi_name                      VARCHAR2(100) not null,
  loancaseid                   VARCHAR2(100),
  stream                       VARCHAR2(200),
  policy                       VARCHAR2(200),
  campaign                     VARCHAR2(200),
  proof_of_income               VARCHAR2(200),
  coll_require                  VARCHAR2(10),
  is_sec_product                VARCHAR2(10),
  deviation_flag               VARCHAR2(10),
  create_employee_code         VARCHAR2(50),
  create_employee_name         VARCHAR2(200),
  creation_date                 DATE,
  application_date              DATE,
  result_main_card_id          VARCHAR2(100),
  app_grp                      VARCHAR2(50),
  last_approval_date            DATE,
  customer_name                 VARCHAR2(150),
  approval_condition            VARCHAR2(50),
  approver_type                 VARCHAR2(100),
  app_status                   VARCHAR2(100),
  rmemailid                    VARCHAR2(250),
  remarks                      VARCHAR2(4000),
  zone                         VARCHAR2(50),
  sale_type                    VARCHAR2(100),
  broker_type                  VARCHAR2(100),
  broker_id                    VARCHAR2(100),
  broker_name                  VARCHAR2(200),
  acc_officer                  VARCHAR2(100),
  account_officer_name          VARCHAR2(200),
  existing_customer             VARCHAR2(10),
  applicant_cif                 VARCHAR2(50),
  kyc1                         VARCHAR2(50),
  interest_rate_pct             NUMBER(8,4),
  loan_to_value                 NUMBER(5,2),
  loan_objective                VARCHAR2(200),
  total_income                  NUMBER(20,2),
  salaryflag                   VARCHAR2(10),
  carflag                      VARCHAR2(10),
  houseflag                    VARCHAR2(10),
  enterprisseflag               VARCHAR2(10),
  divingflag                   VARCHAR2(10),
  faimilyflag                  VARCHAR2(10),
  nonlicflag                   VARCHAR2(10),
  wagesflag                    VARCHAR2(10),
  pensionflag                  VARCHAR2(10),
  otherflag                    VARCHAR2(10),
  product_name                  VARCHAR2(200),
  c_phone_create_flag           VARCHAR2(20),
  c_phone_delete_flag           VARCHAR2(10),
  c_fi_create_flag              VARCHAR2(20),
  c_fi_delete_flag              VARCHAR2(10),
  c_legal_create_flag           VARCHAR2(20),
  c_legal_delete_flag           VARCHAR2(10),
  reinitiate                   VARCHAR2(5),
  normalbrhold                 VARCHAR2(10),
  regbrhold                    VARCHAR2(10),
  stp_flag                     VARCHAR2(50),
  eligible                     VARCHAR2(100),
  totalnoneligible              VARCHAR2(5),
  cancel_reason                 VARCHAR2(500),
  eff_date                     DATE not null,
  exp_date                     DATE
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
  );
-- Create/Recreate primary, unique key constraints
alter table SB_DWH.DIM_RLOS_APPLICATION
  add constraint DIM_RLOS_APPLICATION_PK primary key (DIMENSION_KEY)
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
  );
alter index SB_DWH.DIM_RLOS_APPLICATION_PK nologging;
-- Create/Recreate indexes
create index SB_DWH.RLOS_WI_NAME_IDX_1 on SB_DWH.DIM_RLOS_APPLICATION (WI_NAME)
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
  nologging;
create index SB_DWH.DIM_RLOS_APPLICATION_EFF_DATE_IDX_1 on SB_DWH.DIM_RLOS_APPLICATION (EFF_DATE)
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
  nologging;
create index SB_DWH.DIM_RLOS_APPLICATION_EXP_DATE_IDX_1 on SB_DWH.DIM_RLOS_APPLICATION (EXP_DATE)
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
  nologging;
create index SB_DWH.I_DIM_RLOS_APPLICATION_APPLICATION_SK on SB_DWH.DIM_RLOS_APPLICATION (APPLICATION_SK)
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
  nologging;
