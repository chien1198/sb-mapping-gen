-- Create table
create table SB_DWH.DIM_CLOS_WORKSTEP_DECISION
(
  dimension_key            NUMBER not null,
  workstep_decision_sk      NUMBER not null,
  workstep_decision_bk      VARCHAR2(64) not null,
  workstep_code            VARCHAR2(200) not null,
  decision_code             VARCHAR2(200) not null,
  channel                  VARCHAR2(200),
  eff_date                 DATE not null,
  exp_date                 DATE
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
alter table SB_DWH.DIM_CLOS_WORKSTEP_DECISION
  add constraint DIM_CLOS_WORKSTEP_DECISION_PK primary key (DIMENSION_KEY)
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
alter index SB_DWH.DIM_CLOS_WORKSTEP_DECISION_PK nologging;
-- Create/Recreate indexes
create index SB_DWH.WORKSTEP_DECISION_BK_IDX_1 on SB_DWH.DIM_CLOS_WORKSTEP_DECISION (WORKSTEP_DECISION_BK)
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
create index SB_DWH.DIM_CLOS_WORKSTEP_DECISION_EFF_DATE_IDX_1 on SB_DWH.DIM_CLOS_WORKSTEP_DECISION (EFF_DATE)
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
create index SB_DWH.DIM_CLOS_WORKSTEP_DECISION_EXP_DATE_IDX_1 on SB_DWH.DIM_CLOS_WORKSTEP_DECISION (EXP_DATE)
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
create index SB_DWH.I_DIM_CLOS_WORKSTEP_DECISION_SK on SB_DWH.DIM_CLOS_WORKSTEP_DECISION (WORKSTEP_DECISION_SK)
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
