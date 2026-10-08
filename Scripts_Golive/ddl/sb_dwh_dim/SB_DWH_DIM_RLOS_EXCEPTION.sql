-- Create table
create table SB_DWH.DIM_RLOS_EXCEPTION
(
  dimension_key        NUMBER not null,
  exception_sk          NUMBER not null,
  exception_bk          VARCHAR2(64) not null,
  activityname          NVARCHAR2(255) not null,
  decision_code          NVARCHAR2(100) not null,
  exception_category    NVARCHAR2(100) not null,
  exception_name        NVARCHAR2(1000) not null,
  exception_code        VARCHAR2(50),
  raise_flag            NVARCHAR2(5),
  clear_flag            NVARCHAR2(5),
  id_source             NUMBER,
  code_source            NVARCHAR2(255),
  status                NVARCHAR2(1),
  eff_date              DATE not null,
  exp_date              DATE
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
alter table SB_DWH.DIM_RLOS_EXCEPTION
  add constraint DIM_RLOS_EXCEPTION_PK primary key (DIMENSION_KEY)
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
alter index SB_DWH.DIM_RLOS_EXCEPTION_PK nologging;
-- Create/Recreate indexes
create index SB_DWH.RLOS_EXCEPTION_BK_IDX_1 on SB_DWH.DIM_RLOS_EXCEPTION (EXCEPTION_BK)
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
create index SB_DWH.DIM_RLOS_EXCEPTION_EFF_DATE_IDX_1 on SB_DWH.DIM_RLOS_EXCEPTION (EFF_DATE)
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
create index SB_DWH.DIM_RLOS_EXCEPTION_EXP_DATE_IDX_1 on SB_DWH.DIM_RLOS_EXCEPTION (EXP_DATE)
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
create index SB_DWH.I_DIM_RLOS_EXCEPTION_EXCEPTION_SK on SB_DWH.DIM_RLOS_EXCEPTION (EXCEPTION_SK)
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
