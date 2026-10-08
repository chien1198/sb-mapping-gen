-- Create table
create table STG_DTM.STG_DIM_CLOS_APPLICATION
(
  dimension_key            NUMBER not null,
  application_sk           NUMBER not null,
  wi_name                  NVARCHAR2(63) not null,
  loancaseid               NVARCHAR2(100),
  stream                   NVARCHAR2(200),
  credit_profile           NVARCHAR2(50),
  create_employee_code     NVARCHAR2(100),
  create_employee_name     NVARCHAR2(225),
  creation_date            DATE,
  app_grp                  NVARCHAR2(200),
  have_any_deviation       NVARCHAR2(100),
  zone                     NVARCHAR2(200),
  loan_purpose             NVARCHAR2(200),
  email                    NVARCHAR2(100),
  distance_branch_customer NVARCHAR2(200),
  product_line             NVARCHAR2(200),
  sub_product              NVARCHAR2(255),
  id_number                NVARCHAR2(100),
  channel                  NVARCHAR2(255),
  eff_date                 DATE not null,
  exp_date                 DATE
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
  );
-- Create/Recreate primary, unique key constraints
alter table STG_DTM.STG_DIM_CLOS_APPLICATION
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
  );
alter index STG_DTM.STG_DIM_CLOS_APPLICATION_PK nologging;
-- Create/Recreate indexes
create index STG_DTM.STG_DIM_CLOS_APPLICATION_WI_NAME_IDX on STG_DTM.STG_DIM_CLOS_APPLICATION (WI_NAME)
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
  nologging;
create index STG_DTM.STG_DIM_CLOS_APPLICATION_EFF_DATE_IDX on STG_DTM.STG_DIM_CLOS_APPLICATION (EFF_DATE)
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
  nologging;
create index STG_DTM.STG_DIM_CLOS_APPLICATION_EXP_DATE_IDX on STG_DTM.STG_DIM_CLOS_APPLICATION (EXP_DATE)
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
  nologging;
create index STG_DTM.STG_DIM_CLOS_APPLICATION_APPLICATION_SK_IDX on STG_DTM.STG_DIM_CLOS_APPLICATION (APPLICATION_SK)
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
  nologging;
