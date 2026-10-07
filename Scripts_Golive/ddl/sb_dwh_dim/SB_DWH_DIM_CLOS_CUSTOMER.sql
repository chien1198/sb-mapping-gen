-- Create table
create table SB_DWH.DIM_CLOS_CUSTOMER
(
  dimension_key        NUMBER not null,
  customer_sk          NUMBER,
  id_number            VARCHAR2(100) not null,
  full_name            VARCHAR2(200),
  cust_group           VARCHAR2(100),
  cust_category        VARCHAR2(200),
  precustgroup         VARCHAR2(100),
  industry_lvl1_code   VARCHAR2(200),
  industry_lvl2_code   VARCHAR2(200),
  industry_lvl3_code   VARCHAR2(200),
  eff_date             DATE not null,
  exp_date             DATE
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
alter table SB_DWH.DIM_CLOS_CUSTOMER
  add constraint DIM_CLOS_CUSTOMER_PK primary key (DIMENSION_KEY)
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
alter index SB_DWH.DIM_CLOS_CUSTOMER_PK nologging;
-- Create/Recreate indexes
create index SB_DWH.ID_NUMBER_IDX_1 on SB_DWH.DIM_CLOS_CUSTOMER (ID_NUMBER)
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
create index SB_DWH.DIM_CLOS_CUSTOMER_EFF_DATE_IDX_1 on SB_DWH.DIM_CLOS_CUSTOMER (EFF_DATE)
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
create index SB_DWH.DIM_CLOS_CUSTOMER_EXP_DATE_IDX_1 on SB_DWH.DIM_CLOS_CUSTOMER (EXP_DATE)
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
create index SB_DWH.I_DIM_CLOS_CUSTOMER_CUSTOMER_SK on SB_DWH.DIM_CLOS_CUSTOMER (CUSTOMER_SK)
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
