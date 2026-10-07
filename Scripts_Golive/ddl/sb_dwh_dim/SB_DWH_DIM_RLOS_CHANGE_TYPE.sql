-- Create table
create table SB_DWH.DIM_RLOS_CHANGE_TYPE
(
  dimension_key               NUMBER not null,
  change_type_sk               NUMBER not null,
  change_type_bk               VARCHAR2(64) not null,
  change_type_code             VARCHAR2(100) not null,
  change_type_name             VARCHAR2(200),
  detail_change_type_code      VARCHAR2(100) not null,
  detail_change_type_name      VARCHAR2(500),
  eff_date                    DATE not null,
  exp_date                    DATE
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
alter table SB_DWH.DIM_RLOS_CHANGE_TYPE
  add constraint DIM_RLOS_CHANGE_TYPE_PK primary key (DIMENSION_KEY)
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
alter index SB_DWH.DIM_RLOS_CHANGE_TYPE_PK nologging;
-- Create/Recreate indexes
create index SB_DWH.CHANGE_TYPE_BK_IDX_1 on SB_DWH.DIM_RLOS_CHANGE_TYPE (CHANGE_TYPE_BK)
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
create index SB_DWH.DIM_RLOS_CHANGE_TYPE_EFF_DATE_IDX_1 on SB_DWH.DIM_RLOS_CHANGE_TYPE (EFF_DATE)
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
create index SB_DWH.DIM_RLOS_CHANGE_TYPE_EXP_DATE_IDX_1 on SB_DWH.DIM_RLOS_CHANGE_TYPE (EXP_DATE)
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
create index SB_DWH.I_DIM_RLOS_CHANGE_TYPE_SK on SB_DWH.DIM_RLOS_CHANGE_TYPE (CHANGE_TYPE_SK)
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
