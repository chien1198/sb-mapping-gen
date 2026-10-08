-- Create table
create table STG_DTM.STG_DIM_CLOS_EXCEPTION
(
  dimension_key      NUMBER not null,
  exception_sk       NUMBER not null,
  exception_bk       VARCHAR2(64) not null,
  activityname       NVARCHAR2(255) not null,
  decision_code      NVARCHAR2(100) not null,
  exception_category NVARCHAR2(500) not null,
  exception_name     NVARCHAR2(500) not null,
  exception_code     VARCHAR2(50),
  raise_flag         NVARCHAR2(5),
  clear_flag         NVARCHAR2(255),
  id_source          NUMBER,
  code_source        NVARCHAR2(255),
  status             NVARCHAR2(1),
  eff_date           DATE not null,
  exp_date           DATE
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
alter table STG_DTM.STG_DIM_CLOS_EXCEPTION
  add constraint STG_DIM_CLOS_EXCEPTION_PK primary key (DIMENSION_KEY)
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
alter index STG_DTM.STG_DIM_CLOS_EXCEPTION_PK nologging;
-- Create/Recreate indexes
create index STG_DTM.STG_DIM_CLOS_EXCEPTION_EXCEPTION_BK_IDX on STG_DTM.STG_DIM_CLOS_EXCEPTION (EXCEPTION_BK)
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
create index STG_DTM.STG_DIM_CLOS_EXCEPTION_EFF_DATE_IDX on STG_DTM.STG_DIM_CLOS_EXCEPTION (EFF_DATE)
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
create index STG_DTM.STG_DIM_CLOS_EXCEPTION_EXP_DATE_IDX on STG_DTM.STG_DIM_CLOS_EXCEPTION (EXP_DATE)
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
create index STG_DTM.STG_DIM_CLOS_EXCEPTION_EXCEPTION_SK_IDX on STG_DTM.STG_DIM_CLOS_EXCEPTION (EXCEPTION_SK)
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
