-- Create table
create table SB_DWH.DIM_RLOS_PRODUCT
(
  dimension_key       NUMBER not null,
  product_sk           NUMBER not null,
  product_bk           VARCHAR2(64) not null,
  productline_code     VARCHAR2(200),
  productline_name     VARCHAR2(200),
  sub_product_code     VARCHAR2(200),
  sub_product_name     NVARCHAR2(200),
  score_required       VARCHAR2(200),
  score_model          VARCHAR2(200),
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
  );
-- Create/Recreate primary, unique key constraints
alter table SB_DWH.DIM_RLOS_PRODUCT
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
  );
alter index SB_DWH.DIM_RLOS_PRODUCT_PK nologging;
-- Create/Recreate indexes
create index SB_DWH.RLOS_PRODUCT_BK_IDX_1 on SB_DWH.DIM_RLOS_PRODUCT (PRODUCT_BK)
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
create index SB_DWH.DIM_RLOS_PRODUCT_EFF_DATE_IDX_1 on SB_DWH.DIM_RLOS_PRODUCT (EFF_DATE)
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
create index SB_DWH.DIM_RLOS_PRODUCT_EXP_DATE_IDX_1 on SB_DWH.DIM_RLOS_PRODUCT (EXP_DATE)
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
create index SB_DWH.I_DIM_RLOS_PRODUCT_PRODUCT_SK on SB_DWH.DIM_RLOS_PRODUCT (PRODUCT_SK)
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
