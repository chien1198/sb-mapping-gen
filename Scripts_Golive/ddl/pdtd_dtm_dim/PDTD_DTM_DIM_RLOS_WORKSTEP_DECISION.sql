-- Create table
create table PDTD_DTM.DIM_RLOS_WORKSTEP_DECISION
(
  dimension_key        NUMBER not null,
  workstep_decision_sk NUMBER not null,
  workstep_decision_bk VARCHAR2(64) not null,
  workstep_code        VARCHAR2(200) not null,
  decision_code        VARCHAR2(200) not null,
  eff_date             DATE not null,
  exp_date             DATE
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
alter table PDTD_DTM.DIM_RLOS_WORKSTEP_DECISION
  add constraint DIM_RLOS_WORKSTEP_DECISION_PK primary key (DIMENSION_KEY)
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
alter index PDTD_DTM.DIM_RLOS_WORKSTEP_DECISION_PK nologging;
-- Create/Recreate indexes
create index PDTD_DTM.DIM_RLOS_WORKSTEP_DECISION_WORKSTEP_DECISION_BK_IDX on PDTD_DTM.DIM_RLOS_WORKSTEP_DECISION (WORKSTEP_DECISION_BK)
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
create index PDTD_DTM.DIM_RLOS_WORKSTEP_DECISION_EFF_DATE_IDX on PDTD_DTM.DIM_RLOS_WORKSTEP_DECISION (EFF_DATE)
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
create index PDTD_DTM.DIM_RLOS_WORKSTEP_DECISION_EXP_DATE_IDX on PDTD_DTM.DIM_RLOS_WORKSTEP_DECISION (EXP_DATE)
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
create index PDTD_DTM.DIM_RLOS_WORKSTEP_DECISION_WORKSTEP_DECISION_SK_IDX on PDTD_DTM.DIM_RLOS_WORKSTEP_DECISION (WORKSTEP_DECISION_SK)
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
