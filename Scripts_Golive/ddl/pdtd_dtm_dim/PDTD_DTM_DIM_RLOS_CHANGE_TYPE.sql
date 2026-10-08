-- Create table
create table PDTD_DTM.DIM_RLOS_CHANGE_TYPE
(
  dimension_key           NUMBER not null,
  change_type_sk          NUMBER not null,
  change_type_bk          VARCHAR2(64) not null,
  change_type_code        NVARCHAR2(200) not null,
  change_type_name        NVARCHAR2(200),
  detail_change_type_code NVARCHAR2(200) not null,
  detail_change_type_name NVARCHAR2(200),
  is_active               NVARCHAR2(1),
  eff_date                DATE not null,
  exp_date                DATE
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
alter table PDTD_DTM.DIM_RLOS_CHANGE_TYPE
  add constraint DIM_RLOS_CHANGE_TYPE_PK primary key (DIMENSION_KEY)
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
alter index PDTD_DTM.DIM_RLOS_CHANGE_TYPE_PK nologging;
-- Create/Recreate indexes
create index PDTD_DTM.DIM_RLOS_CHANGE_TYPE_CHANGE_TYPE_BK_IDX on PDTD_DTM.DIM_RLOS_CHANGE_TYPE (CHANGE_TYPE_BK)
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
create index PDTD_DTM.DIM_RLOS_CHANGE_TYPE_EFF_DATE_IDX on PDTD_DTM.DIM_RLOS_CHANGE_TYPE (EFF_DATE)
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
create index PDTD_DTM.DIM_RLOS_CHANGE_TYPE_EXP_DATE_IDX on PDTD_DTM.DIM_RLOS_CHANGE_TYPE (EXP_DATE)
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
create index PDTD_DTM.DIM_RLOS_CHANGE_TYPE_CHANGE_TYPE_SK_IDX on PDTD_DTM.DIM_RLOS_CHANGE_TYPE (CHANGE_TYPE_SK)
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
