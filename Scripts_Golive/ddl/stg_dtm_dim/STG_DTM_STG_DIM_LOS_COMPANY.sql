-- Create table
create table STG_DTM.STG_DIM_LOS_COMPANY
(
  dimension_key   NUMBER not null,
  company_sk      NUMBER not null,
  company_code    VARCHAR2(50),
  company_name    VARCHAR2(200),
  company_address VARCHAR2(500),
  company_email   VARCHAR2(200),
  zone            NUMBER,
  branch_code     VARCHAR2(50),
  branch_name     VARCHAR2(200),
  city            VARCHAR2(100),
  district        VARCHAR2(100),
  region_code     NUMBER,
  region_name     VARCHAR2(200),
  eff_date        DATE not null,
  exp_date        DATE
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
alter table STG_DTM.STG_DIM_LOS_COMPANY
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
  );
alter index STG_DTM.STG_DIM_LOS_COMPANY_PK nologging;
-- Create/Recreate indexes
create index STG_DTM.STG_DIM_LOS_COMPANY_COMPANY_CODE_IDX on STG_DTM.STG_DIM_LOS_COMPANY (COMPANY_CODE)
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
create index STG_DTM.STG_DIM_LOS_COMPANY_EFF_DATE_IDX on STG_DTM.STG_DIM_LOS_COMPANY (EFF_DATE)
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
create index STG_DTM.STG_DIM_LOS_COMPANY_EXP_DATE_IDX on STG_DTM.STG_DIM_LOS_COMPANY (EXP_DATE)
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
create index STG_DTM.STG_DIM_LOS_COMPANY_COMPANY_SK_IDX on STG_DTM.STG_DIM_LOS_COMPANY (COMPANY_SK)
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
