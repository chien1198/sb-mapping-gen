-- Create table
create table PDTD_DTM.DIM_RLOS_SECONDPRODUCT
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
alter table PDTD_DTM.DIM_RLOS_SECONDPRODUCT
  add constraint DIM_RLOS_SECONDPRODUCT_PK primary key (DIMENSION_KEY)
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
alter index PDTD_DTM.DIM_RLOS_SECONDPRODUCT_PK nologging;
-- Create/Recreate indexes
create index PDTD_DTM.DIM_RLOS_SECONDPRODUCT_SECONDPRODUCT_BK_IDX on PDTD_DTM.DIM_RLOS_SECONDPRODUCT (SECONDPRODUCT_BK)
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
create index PDTD_DTM.DIM_RLOS_SECONDPRODUCT_EFF_DATE_IDX on PDTD_DTM.DIM_RLOS_SECONDPRODUCT (EFF_DATE)
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
create index PDTD_DTM.DIM_RLOS_SECONDPRODUCT_EXP_DATE_IDX on PDTD_DTM.DIM_RLOS_SECONDPRODUCT (EXP_DATE)
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
create index PDTD_DTM.DIM_RLOS_SECONDPRODUCT_SECONDPRODUCT_SK_IDX on PDTD_DTM.DIM_RLOS_SECONDPRODUCT (SECONDPRODUCT_SK)
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
