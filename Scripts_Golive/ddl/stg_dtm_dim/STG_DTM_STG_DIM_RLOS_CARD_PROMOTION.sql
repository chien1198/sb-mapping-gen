-- Create table
create table STG_DTM.STG_DIM_RLOS_CARD_PROMOTION
(
  dimension_key     NUMBER not null,
  card_promotion_sk NUMBER not null,
  promotion_code    VARCHAR2(100) not null,
  promotion_desc    VARCHAR2(500),
  eff_date          DATE not null,
  exp_date          DATE
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
alter table STG_DTM.STG_DIM_RLOS_CARD_PROMOTION
  add constraint STG_DIM_RLOS_CARD_PROMOTION_PK primary key (DIMENSION_KEY)
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
alter index STG_DTM.STG_DIM_RLOS_CARD_PROMOTION_PK nologging;
-- Create/Recreate indexes
create index STG_DTM.STG_DIM_RLOS_CARD_PROMOTION_PROMOTION_CODE_IDX on STG_DTM.STG_DIM_RLOS_CARD_PROMOTION (PROMOTION_CODE)
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
create index STG_DTM.STG_DIM_RLOS_CARD_PROMOTION_EFF_DATE_IDX on STG_DTM.STG_DIM_RLOS_CARD_PROMOTION (EFF_DATE)
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
create index STG_DTM.STG_DIM_RLOS_CARD_PROMOTION_EXP_DATE_IDX on STG_DTM.STG_DIM_RLOS_CARD_PROMOTION (EXP_DATE)
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
create index STG_DTM.STG_DIM_RLOS_CARD_PROMOTION_CARD_PROMOTION_SK_IDX on STG_DTM.STG_DIM_RLOS_CARD_PROMOTION (CARD_PROMOTION_SK)
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
