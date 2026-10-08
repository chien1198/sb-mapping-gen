-- Create table
create table PDTD_DTM.DIM_CLOS_CUSTOMER
(
  dimension_key      NUMBER not null,
  customer_sk        NUMBER not null,
  id_number          VARCHAR2(100) not null,
  full_name          NVARCHAR2(200),
  cust_group         NVARCHAR2(200),
  cust_category      NVARCHAR2(200),
  precustgroup       NVARCHAR2(300),
  industry_lvl1_code VARCHAR2(200),
  industry_lvl2_code VARCHAR2(200),
  industry_lvl3_code VARCHAR2(200),
  eff_date           DATE not null,
  exp_date           DATE
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
alter table PDTD_DTM.DIM_CLOS_CUSTOMER
  add constraint DIM_CLOS_CUSTOMER_PK primary key (DIMENSION_KEY)
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
alter index PDTD_DTM.DIM_CLOS_CUSTOMER_PK nologging;
-- Create/Recreate indexes
create index PDTD_DTM.DIM_CLOS_CUSTOMER_ID_NUMBER_IDX on PDTD_DTM.DIM_CLOS_CUSTOMER (ID_NUMBER)
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
create index PDTD_DTM.DIM_CLOS_CUSTOMER_EFF_DATE_IDX on PDTD_DTM.DIM_CLOS_CUSTOMER (EFF_DATE)
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
create index PDTD_DTM.DIM_CLOS_CUSTOMER_EXP_DATE_IDX on PDTD_DTM.DIM_CLOS_CUSTOMER (EXP_DATE)
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
create index PDTD_DTM.DIM_CLOS_CUSTOMER_CUSTOMER_SK_IDX on PDTD_DTM.DIM_CLOS_CUSTOMER (CUSTOMER_SK)
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
