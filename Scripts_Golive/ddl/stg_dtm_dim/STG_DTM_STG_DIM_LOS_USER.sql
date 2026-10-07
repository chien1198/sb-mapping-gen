-- Create table
create table STG_DTM.STG_DIM_LOS_USER
(
  dimension_key        NUMBER not null,
  user_sk              NUMBER not null,
  username             VARCHAR2(100) not null,
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
  eff_date             DATE not null,
  exp_date             DATE
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
alter table STG_DTM.STG_DIM_LOS_USER
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
  );
alter index STG_DTM.STG_DIM_LOS_USER_PK nologging;
-- Create/Recreate indexes
create index STG_DTM.STG_DIM_LOS_USER_USERNAME_IDX on STG_DTM.STG_DIM_LOS_USER (USERNAME)
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
create index STG_DTM.STG_DIM_LOS_USER_EFF_DATE_IDX on STG_DTM.STG_DIM_LOS_USER (EFF_DATE)
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
create index STG_DTM.STG_DIM_LOS_USER_EXP_DATE_IDX on STG_DTM.STG_DIM_LOS_USER (EXP_DATE)
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
create index STG_DTM.STG_DIM_LOS_USER_USER_SK_IDX on STG_DTM.STG_DIM_LOS_USER (USER_SK)
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
