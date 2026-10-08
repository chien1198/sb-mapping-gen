-- Create table
create table STG_DTM.STG_DIM_CLOS_WORKSTEP_DECISION
(
  dimension_key        NUMBER not null,
  workstep_decision_sk NUMBER not null,
  workstep_decision_bk VARCHAR2(64) not null,
  workstep_code        NVARCHAR2(255) not null,
  decision_code        NVARCHAR2(255) not null,
  channel              NVARCHAR2(255),
  eff_date             DATE not null,
  exp_date             DATE
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
alter table STG_DTM.STG_DIM_CLOS_WORKSTEP_DECISION
  add constraint STG_DIM_CLOS_WORKSTEP_DECISION_PK primary key (DIMENSION_KEY)
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
alter index STG_DTM.STG_DIM_CLOS_WORKSTEP_DECISION_PK nologging;
-- Create/Recreate indexes
create index STG_DTM.STG_DIM_CLOS_WORKSTEP_DECISION_WORKSTEP_DECISION_BK_IDX on STG_DTM.STG_DIM_CLOS_WORKSTEP_DECISION (WORKSTEP_DECISION_BK)
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
create index STG_DTM.STG_DIM_CLOS_WORKSTEP_DECISION_EFF_DATE_IDX on STG_DTM.STG_DIM_CLOS_WORKSTEP_DECISION (EFF_DATE)
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
create index STG_DTM.STG_DIM_CLOS_WORKSTEP_DECISION_EXP_DATE_IDX on STG_DTM.STG_DIM_CLOS_WORKSTEP_DECISION (EXP_DATE)
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
create index STG_DTM.STG_DIM_CLOS_WORKSTEP_DECISION_WORKSTEP_DECISION_SK_IDX on STG_DTM.STG_DIM_CLOS_WORKSTEP_DECISION (WORKSTEP_DECISION_SK)
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
