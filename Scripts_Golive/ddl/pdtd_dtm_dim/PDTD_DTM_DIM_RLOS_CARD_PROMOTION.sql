-- Create table
create table PDTD_DTM.DIM_RLOS_CARD_PROMOTION
(
  dimension_key     NUMBER not null,
  card_promotion_sk NUMBER not null,
  promotion_code    NVARCHAR2(255) not null,
  promotion_desc    NVARCHAR2(255),
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
alter table PDTD_DTM.DIM_RLOS_CARD_PROMOTION
  add constraint DIM_RLOS_CARD_PROMOTION_PK primary key (DIMENSION_KEY)
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
alter index PDTD_DTM.DIM_RLOS_CARD_PROMOTION_PK nologging;
-- Create/Recreate indexes
create index PDTD_DTM.DIM_RLOS_CARD_PROMOTION_PROMOTION_CODE_IDX on PDTD_DTM.DIM_RLOS_CARD_PROMOTION (PROMOTION_CODE)
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
create index PDTD_DTM.DIM_RLOS_CARD_PROMOTION_EFF_DATE_IDX on PDTD_DTM.DIM_RLOS_CARD_PROMOTION (EFF_DATE)
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
create index PDTD_DTM.DIM_RLOS_CARD_PROMOTION_EXP_DATE_IDX on PDTD_DTM.DIM_RLOS_CARD_PROMOTION (EXP_DATE)
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
create index PDTD_DTM.DIM_RLOS_CARD_PROMOTION_CARD_PROMOTION_SK_IDX on PDTD_DTM.DIM_RLOS_CARD_PROMOTION (CARD_PROMOTION_SK)
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
