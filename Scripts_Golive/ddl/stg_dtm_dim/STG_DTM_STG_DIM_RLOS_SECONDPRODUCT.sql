-- Create table
create table STG_DTM.STG_DIM_RLOS_SECONDPRODUCT
(
  dimension_key     NUMBER not null,
  secondproduct_sk  NUMBER not null,
  secondproduct_bk  VARCHAR2(64) not null,
  productline_code  VARCHAR2(200) not null,
  productline_name  VARCHAR2(200),
  secondary_product VARCHAR2(200),
  eff_date          DATE not null,
  exp_date          DATE
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
alter table STG_DTM.STG_DIM_RLOS_SECONDPRODUCT
  add constraint STG_DIM_RLOS_SECONDPRODUCT_PK primary key (DIMENSION_KEY)
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
alter index STG_DTM.STG_DIM_RLOS_SECONDPRODUCT_PK nologging;
-- Create/Recreate indexes
create index STG_DTM.STG_DIM_RLOS_SECONDPRODUCT_SECONDPRODUCT_BK_IDX on STG_DTM.STG_DIM_RLOS_SECONDPRODUCT (SECONDPRODUCT_BK)
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
create index STG_DTM.STG_DIM_RLOS_SECONDPRODUCT_EFF_DATE_IDX on STG_DTM.STG_DIM_RLOS_SECONDPRODUCT (EFF_DATE)
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
create index STG_DTM.STG_DIM_RLOS_SECONDPRODUCT_EXP_DATE_IDX on STG_DTM.STG_DIM_RLOS_SECONDPRODUCT (EXP_DATE)
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
create index STG_DTM.STG_DIM_RLOS_SECONDPRODUCT_SECONDPRODUCT_SK_IDX on STG_DTM.STG_DIM_RLOS_SECONDPRODUCT (SECONDPRODUCT_SK)
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
