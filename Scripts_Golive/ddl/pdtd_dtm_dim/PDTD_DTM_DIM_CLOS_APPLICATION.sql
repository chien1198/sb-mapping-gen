-- Create table
create table PDTD_DTM.DIM_CLOS_APPLICATION
(
  dimension_key            NUMBER not null,
  application_sk           NUMBER not null,
  wi_name                  VARCHAR2(100) not null,
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
  eff_date                 DATE not null,
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
  );
-- Create/Recreate primary, unique key constraints
alter table PDTD_DTM.DIM_CLOS_APPLICATION
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
  );
alter index PDTD_DTM.DIM_CLOS_APPLICATION_PK nologging;
-- Create/Recreate indexes
create index PDTD_DTM.DIM_CLOS_APPLICATION_WI_NAME_IDX on PDTD_DTM.DIM_CLOS_APPLICATION (WI_NAME)
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
  nologging;
create index PDTD_DTM.DIM_CLOS_APPLICATION_EFF_DATE_IDX on PDTD_DTM.DIM_CLOS_APPLICATION (EFF_DATE)
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
  nologging;
create index PDTD_DTM.DIM_CLOS_APPLICATION_EXP_DATE_IDX on PDTD_DTM.DIM_CLOS_APPLICATION (EXP_DATE)
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
  nologging;
create index PDTD_DTM.DIM_CLOS_APPLICATION_APPLICATION_SK_IDX on PDTD_DTM.DIM_CLOS_APPLICATION (APPLICATION_SK)
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
  nologging;
