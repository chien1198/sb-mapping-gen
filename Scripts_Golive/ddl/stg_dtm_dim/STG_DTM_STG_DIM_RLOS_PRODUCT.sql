-- Create table
create table STG_DTM.STG_DIM_RLOS_PRODUCT
(
  dimension_key    NUMBER not null,
  product_sk       NUMBER not null,
  product_bk       VARCHAR2(64) not null,
  productline_code VARCHAR2(100),
  productline_name VARCHAR2(200),
  sub_product_code VARCHAR2(100),
  sub_product_name VARCHAR2(150),
  score_required   VARCHAR2(10),
  score_model      VARCHAR2(100),
  eff_date         DATE not null,
  exp_date         DATE
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
alter table STG_DTM.STG_DIM_RLOS_PRODUCT
  add constraint STG_DIM_RLOS_PRODUCT_PK primary key (DIMENSION_KEY)
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
alter index STG_DTM.STG_DIM_RLOS_PRODUCT_PK nologging;
-- Create/Recreate indexes
create index STG_DTM.STG_DIM_RLOS_PRODUCT_PRODUCT_BK_IDX on STG_DTM.STG_DIM_RLOS_PRODUCT (PRODUCT_BK)
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
create index STG_DTM.STG_DIM_RLOS_PRODUCT_EFF_DATE_IDX on STG_DTM.STG_DIM_RLOS_PRODUCT (EFF_DATE)
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
create index STG_DTM.STG_DIM_RLOS_PRODUCT_EXP_DATE_IDX on STG_DTM.STG_DIM_RLOS_PRODUCT (EXP_DATE)
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
create index STG_DTM.STG_DIM_RLOS_PRODUCT_PRODUCT_SK_IDX on STG_DTM.STG_DIM_RLOS_PRODUCT (PRODUCT_SK)
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
