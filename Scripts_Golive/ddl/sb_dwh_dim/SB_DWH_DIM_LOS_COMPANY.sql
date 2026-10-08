-- Create table
create table SB_DWH.DIM_LOS_COMPANY
(
  dimension_key    NUMBER not null,
  company_sk        NUMBER not null,
  company_code      VARCHAR2(200),
  company_name      NVARCHAR2(200),
  company_address   NVARCHAR2(200),
  company_email     VARCHAR2(200),
  zone             NUMBER,
  branch_code       VARCHAR2(200),
  branch_name       NVARCHAR2(200),
  city              VARCHAR2(200),
  district          VARCHAR2(200),
  region_code       NUMBER,
  region_name       NVARCHAR2(200),
  eff_date         DATE not null,
  exp_date         DATE
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
alter table SB_DWH.DIM_LOS_COMPANY
  add constraint DIM_LOS_COMPANY_PK primary key (DIMENSION_KEY)
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
alter index SB_DWH.DIM_LOS_COMPANY_PK nologging;
-- Create/Recreate indexes
create index SB_DWH.COMPANY_CODE_IDX_1 on SB_DWH.DIM_LOS_COMPANY (COMPANY_CODE)
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
create index SB_DWH.DIM_LOS_COMPANY_EFF_DATE_IDX_1 on SB_DWH.DIM_LOS_COMPANY (EFF_DATE)
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
create index SB_DWH.DIM_LOS_COMPANY_EXP_DATE_IDX_1 on SB_DWH.DIM_LOS_COMPANY (EXP_DATE)
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
create index SB_DWH.I_DIM_LOS_COMPANY_COMPANY_SK on SB_DWH.DIM_LOS_COMPANY (COMPANY_SK)
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
