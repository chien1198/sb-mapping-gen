-- Create table
create table SB_DWH.DIM_RLOS_APPLICATION
(
  dimension_key               NUMBER not null,
  application_sk               NUMBER not null,
  wi_name                      NVARCHAR2(63) not null,
  loancaseid                   NVARCHAR2(100),
  stream                       NVARCHAR2(200),
  policy                       NVARCHAR2(200),
  campaign                     NVARCHAR2(200),
  proof_of_income               NVARCHAR2(200),
  coll_require                  NVARCHAR2(10),
  is_sec_product                NVARCHAR2(100),
  deviation_flag               NVARCHAR2(10),
  create_employee_code         NVARCHAR2(20),
  create_employee_name         NVARCHAR2(50),
  creation_date                 DATE,
  application_date              DATE,
  result_main_card_id          VARCHAR2(200),
  app_grp                      NVARCHAR2(200),
  last_approval_date            DATE,
  customer_name                 NVARCHAR2(150),
  approval_condition            NVARCHAR2(50),
  approver_type                 NVARCHAR2(100),
  app_status                   NVARCHAR2(100),
  rmemailid                    NVARCHAR2(250),
  remarks                      NVARCHAR2(4000),
  zone                         NVARCHAR2(50),
  sale_type                    NVARCHAR2(200),
  broker_type                  NVARCHAR2(200),
  broker_id                    NVARCHAR2(200),
  broker_name                  NVARCHAR2(200),
  acc_officer                  NVARCHAR2(100),
  account_officer_name          NVARCHAR2(200),
  existing_customer             NVARCHAR2(100),
  applicant_cif                 NVARCHAR2(100),
  kyc1                         NVARCHAR2(20),
  interest_rate_pct             NUMBER(8,4),
  loan_to_value                 NUMBER(5,2),
  loan_objective                NVARCHAR2(100),
  total_income                  NUMBER(20,2),
  salaryflag                   NVARCHAR2(10),
  carflag                      NVARCHAR2(10),
  houseflag                    NVARCHAR2(10),
  enterprisseflag               NVARCHAR2(10),
  divingflag                   NVARCHAR2(10),
  faimilyflag                  NVARCHAR2(10),
  nonlicflag                   NVARCHAR2(10),
  wagesflag                    NVARCHAR2(10),
  pensionflag                  NVARCHAR2(10),
  otherflag                    NVARCHAR2(10),
  product_name                  NVARCHAR2(150),
  c_phone_create_flag           NVARCHAR2(20),
  c_phone_delete_flag           NVARCHAR2(10),
  c_fi_create_flag              NVARCHAR2(10),
  c_fi_delete_flag              NVARCHAR2(10),
  c_legal_create_flag           NVARCHAR2(10),
  c_legal_delete_flag           NVARCHAR2(10),
  reinitiate                   NVARCHAR2(5),
  normalbrhold                 NVARCHAR2(10),
  regbrhold                    NVARCHAR2(10),
  stp_flag                     NVARCHAR2(50),
  eligible                     NVARCHAR2(100),
  totalnoneligible              NVARCHAR2(5),
  cancel_reason                 NVARCHAR2(500),
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
