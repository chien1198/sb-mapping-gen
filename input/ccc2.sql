-- Create table
create table STG_DTM.STG_DIM_CUSTOMER
(
  dimension_key        NUMBER not null,
  total_name           VARCHAR2(200),
  total                VARCHAR2(50),
  total_sk             NUMBER,
  company_book         VARCHAR2(44),
  birth_incorp_date    DATE,
  authoriser           VARCHAR2(50),
  addition_value       VARCHAR2(400),
  customer_group       VARCHAR2(50),
  customer             VARCHAR2(200),
  country              VARCHAR2(200),
  contact_date         DATE,
  account_officer_name VARCHAR2(50),
  account_officer      VARCHAR2(16),
  sms_1                VARCHAR2(200),
  street               VARCHAR2(4000),
  short_name           VARCHAR2(200),
  customer_sk          NUMBER,
  sector               VARCHAR2(16),
  sector_sk            NUMBER,
  seab_cu_segment      VARCHAR2(200),
  seab_district1       VARCHAR2(200),
  residence            VARCHAR2(200),
  salary               NUMBER,
  represent            VARCHAR2(200),
  represent_tel        VARCHAR2(200),
  relation_code        VARCHAR2(50),
  rel_customer         VARCHAR2(50),
  referred_by          VARCHAR2(40),
  referred_emp         VARCHAR2(140),
  turnover             NUMBER,
  town_country         VARCHAR2(200),
  total_asset          NUMBER,
  title                VARCHAR2(200),
  tax_id               VARCHAR2(200),
  target               VARCHAR2(16),
  sub_industry         VARCHAR2(16),
  industry_sk          NUMBER,
  inputter             VARCHAR2(50),
  job_title            VARCHAR2(200),
  legal_doc_name       VARCHAR2(200),
  gender               VARCHAR2(200),
  given_names          VARCHAR2(200),
  industry             VARCHAR2(16),
  industry_group       VARCHAR2(16),
  eff_date             DATE,
  email_1              VARCHAR2(200),
  exp_date             DATE,
  fax_1                VARCHAR2(200),
  customer_liability   VARCHAR2(40),
  customer_status      VARCHAR2(16),
  cus_target           VARCHAR2(200),
  date_of_birth        DATE,
  portfolio            VARCHAR2(200),
  phone_1              VARCHAR2(200),
  referred_branch      VARCHAR2(16),
  province             VARCHAR2(60),
  nationality          VARCHAR2(8),
  name1                VARCHAR2(4000),
  occupation           VARCHAR2(200),
  no_of_employees      NUMBER,
  location_sk          NUMBER,
  legal_iss_date       DATE,
  marital_status       VARCHAR2(200),
  loyalty              VARCHAR2(12),
  legal_holder_name    VARCHAR2(400),
  legal_exp_date       DATE,
  legal_iss_auth       VARCHAR2(400),
  legal_id             VARCHAR2(200),
  employment_status    VARCHAR2(200),
  seab_sales_type      VARCHAR2(35),
  seab_sales_id        VARCHAR2(35),
  seab_brokers_type    VARCHAR2(35),
  seab_brokers_id      VARCHAR2(35),
  campaign_id          VARCHAR2(35),
  sb_id                VARCHAR2(50),
  branch_salary        VARCHAR2(50),
  residence_status     VARCHAR2(35),
  represent_id         VARCHAR2(35),
  no_of_dependents     NUMBER,
  employers_name       VARCHAR2(100),
  seab_purpose         VARCHAR2(4000),
  customer_class       VARCHAR2(4000),
  mnemonic             VARCHAR2(50),
  priority             VARCHAR2(50),
  vn_name              VARCHAR2(4000),
  full_name            VARCHAR2(4000),
  address              VARCHAR2(4000),
  seab_pob             VARCHAR2(35),
  date_time_authorise  DATE,
  date_time_input      DATE,
  channel              VARCHAR2(35),
  sea_sub_channel      VARCHAR2(35),
  language             VARCHAR2(8),
  seab_fatca_tax       VARCHAR2(255),
  auth_cust            VARCHAR2(35),
  seab_reg_status      VARCHAR2(250)
)
partition by range (EXP_DATE)
(
  partition STG_DIM_CUSTOMER_P0 values less than (TO_DATE(' 9999-12-31 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN'))
    tablespace STG_DTM_TBS
    pctfree 0
    initrans 1
    maxtrans 255
    storage
    (
      initial 8M
      next 1M
      minextents 1
      maxextents unlimited
    ),
  partition STG_DIM_CUSTOMER_P1 values less than (MAXVALUE)
    tablespace STG_DTM_TBS
    pctfree 0
    initrans 1
    maxtrans 255
    storage
    (
      initial 8M
      next 1M
      minextents 1
      maxextents unlimited
    )
);
-- Create/Recreate indexes 
create index STG_DTM.STG_DIM_CUSTOMER_CUST_IDX on STG_DTM.STG_DIM_CUSTOMER (CUSTOMER)
  nologging  local;
create index STG_DTM.STG_DIM_CUSTOMER_LEGAL_IDX on STG_DTM.STG_DIM_CUSTOMER (LEGAL_ID)
  nologging  local;
-- Create/Recreate primary, unique and foreign key constraints 
alter table STG_DTM.STG_DIM_CUSTOMER
  add constraint STG_DIM_CUSTOMER_PK primary key (DIMENSION_KEY)
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
alter index STG_DTM.STG_DIM_CUSTOMER_PK nologging;
-- Grant/Revoke object privileges 
grant select on STG_DTM.STG_DIM_CUSTOMER to U_RISK_DTM_FSSC;


-- Create table
create table STG_DTM.STG_FCT_CUSTOMER
(
  dayid                      DATE,
  customer                   VARCHAR2(230),
  customer_sk                NUMBER,
  company                    VARCHAR2(30),
  company_sk                 NUMBER,
  loan_active_acc_num        NUMBER(25,5),
  loan_close_acc_num         NUMBER(25,5),
  loan_inactive_acc_num      NUMBER(25,5),
  loan_active_acc_bal        NUMBER(25,5),
  loan_inactive_acc_bal      NUMBER(25,5),
  loan_active_acc_cr_amt     NUMBER(25,5),
  loan_active_acc_dr_amt     NUMBER(25,5),
  agg_loan_active_acc_cr_amt NUMBER(25,5),
  agg_loan_active_acc_dr_amt NUMBER(25,5),
  agg_loan_active_acc_fee    NUMBER(25,5),
  tf_active_acc_num          NUMBER(25,5),
  tf_inactive_acc_num        NUMBER(25,5),
  tf_active_acc_bal          NUMBER(25,5),
  tf_inactive_acc_bal        NUMBER(25,5),
  tf_close_acc_num           NUMBER(25,5),
  tf_active_acc_cr_amt       NUMBER(25,5),
  tf_active_acc_dr_amt       NUMBER(25,5),
  agg_tf_active_acc_cr_amt   NUMBER(25,5),
  agg_tf_active_acc_dr_amt   NUMBER(25,5),
  agg_tf_active_acc_fee      NUMBER(25,5),
  current_active_acc_num     NUMBER(25,5),
  current_open_acc_num_ytd   NUMBER(25,5),
  current_inactive_acc_num   NUMBER(25,5),
  current_close_acc_num_y    NUMBER(25,5),
  account_close_num          NUMBER(25,5),
  current_active_acc_bal     NUMBER(25,5),
  current_inactive_acc_bal   NUMBER(25,5),
  saving_active_acc_num      NUMBER(25,5),
  saving_inactive_acc_num    NUMBER(25,5),
  saving_active_acc_bal      NUMBER(25,5),
  saving_inactive_acc_bal    NUMBER(25,5),
  account_open_num_ytd       NUMBER(25,5),
  loan_open_acc_num_ytd      NUMBER(25,5),
  lc_open_acc_num_ytd        NUMBER(25,5),
  mm_open_acc_num_ytd        NUMBER(25,5),
  mm_active_acc_num          NUMBER(25,5),
  mm_active_acc_bal          NUMBER(25,5),
  mm_close_acc_num           NUMBER(25,5),
  seapay_open_acc_num_ytd    NUMBER(25,5),
  card_open_acc_num_ytd      NUMBER(25,5),
  account_enable_num         NUMBER(25,5),
  loan_enable_acc_num        NUMBER(25,5),
  lc_enable_acc_num          NUMBER(25,5),
  mm_enable_acc_num          NUMBER(25,5),
  md_enable_acc_num          NUMBER(25,5),
  md_active_acc_num          NUMBER(25,5),
  md_active_acc_bal          NUMBER(25,5),
  md_close_acc_num           NUMBER(25,5),
  card_enable_acc_num        NUMBER(25,5),
  last_tran_date             DATE,
  inactive_date              DATE,
  last_active_date           DATE,
  last_create_prod_date      DATE,
  salary_active_acc_num      NUMBER(25,5),
  customer_status            VARCHAR2(30),
  customer_status_name       VARCHAR2(30),
  other_active_acc_num       NUMBER(25,5) default 0,
  other_inactive_acc_num     NUMBER(25,5) default 0,
  other_active_acc_bal       NUMBER(25,5) default 0,
  other_inactive_acc_bal     NUMBER(25,5) default 0,
  customer_class             VARCHAR2(30),
  seapay_first_tran_date     DATE,
  first_disbursement_date    DATE,
  seab_los_id                VARCHAR2(35),
  customer_status_name_new   VARCHAR2(200),
  debt_group                 NUMBER
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
  )
nologging;
-- Create/Recreate indexes 
create index STG_DTM.STG_FCT_CUSTOMER_CUS on STG_DTM.STG_FCT_CUSTOMER (CUSTOMER)
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
-- Grant/Revoke object privileges 
grant select on STG_DTM.STG_FCT_CUSTOMER to U_RISK_DTM_FSSC;


-- Create table
create table STG_DTM.STG_DIM_PRODUCTS
(
  dimension_key   NUMBER not null,
  line_pro_name   VARCHAR2(200),
  line_pro_code   VARCHAR2(35),
  line_pro_sk     NUMBER,
  group3_name     VARCHAR2(200),
  group3_code     VARCHAR2(35),
  group3_sk       NUMBER,
  group2_sk       NUMBER,
  group2_code     VARCHAR2(35),
  group2_name     VARCHAR2(200),
  group1_sk       NUMBER,
  group1_code     VARCHAR2(35),
  group1_name     VARCHAR2(200),
  channel         VARCHAR2(35),
  available_date  DATE,
  eff_date        DATE,
  product_code    VARCHAR2(35),
  exp_date        DATE,
  expiry_date     DATE,
  product_sk      NUMBER,
  product_name    VARCHAR2(200),
  product_name_vn VARCHAR2(35)
)
partition by range (EXP_DATE)
(
  partition STG_DIM_PRODUCTS_P0 values less than (TO_DATE(' 9999-12-31 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN'))
    tablespace STG_DTM_TBS
    pctfree 0
    initrans 1
    maxtrans 255
    storage
    (
      initial 8M
      next 1M
      minextents 1
      maxextents unlimited
    ),
  partition STG_DIM_PRODUCTS_P1 values less than (MAXVALUE)
    tablespace STG_DTM_TBS
    pctfree 0
    initrans 1
    maxtrans 255
    storage
    (
      initial 8M
      next 1M
      minextents 1
      maxextents unlimited
    )
);
-- Create/Recreate primary, unique and foreign key constraints 
alter table STG_DTM.STG_DIM_PRODUCTS
  add constraint STG_DIM_PRODUCTS_PK primary key (DIMENSION_KEY)
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
alter index STG_DTM.STG_DIM_PRODUCTS_PK nologging;
-- Grant/Revoke object privileges 
grant select on STG_DTM.STG_DIM_PRODUCTS to U_RISK_DTM_FSSC;

-- Create table
create table STG_DTM.STG_DIM_DEPOSIT
(
  dimension_key       NUMBER not null,
  total_sk            NUMBER,
  total               VARCHAR2(10),
  total_name          VARCHAR2(10),
  amt_prin_sch        NUMBER,
  account_officer     VARCHAR2(16),
  rollover_status     NUMBER(1),
  rollover_int_rate   VARCHAR2(30),
  rollover_date       DATE,
  repay_account       VARCHAR2(264),
  value_date          DATE,
  status              VARCHAR2(2),
  contract_sk         NUMBER,
  short_title         VARCHAR2(2000),
  master_account      VARCHAR2(250),
  limit_ref           VARCHAR2(40),
  legacy_id           VARCHAR2(2140),
  inputter            VARCHAR2(100),
  passbook            VARCHAR2(8),
  orig_interest_rate  NUMBER,
  opening_date        DATE,
  maturity_date       DATE,
  interest_liqu_acct  VARCHAR2(235),
  date_time_authorise DATE,
  joint_holder        VARCHAR2(235),
  eff_date            DATE,
  datasource          VARCHAR2(2),
  date_prin_sch       DATE,
  freq_day            VARCHAR2(2),
  inactiv_marker      VARCHAR2(4),
  exp_date            DATE,
  frequency           VARCHAR2(10),
  close_date          DATE,
  condition_group     VARCHAR2(16),
  authoriser          VARCHAR2(80),
  category            VARCHAR2(50),
  type_of_schdle      VARCHAR2(3),
  currency            VARCHAR2(5),
  customer            VARCHAR2(240),
  contract            VARCHAR2(2000),
  all_in_one_product  VARCHAR2(64),
  co_code             VARCHAR2(44),
  reference_info      VARCHAR2(4000),
  nominated_account   VARCHAR2(200),
  date_time_input     DATE,
  save_type           VARCHAR2(30),
  relation_code       VARCHAR2(250)
)
partition by range (EXP_DATE)
(
  partition STG_DIM_DEPOSIT_P0 values less than (TO_DATE(' 9999-12-31 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN'))
    tablespace STG_DTM_TBS
    pctfree 0
    initrans 1
    maxtrans 255
    storage
    (
      initial 8M
      next 1M
      minextents 1
      maxextents unlimited
    ),
  partition STG_DIM_DEPOSIT_P1 values less than (MAXVALUE)
    tablespace STG_DTM_TBS
    pctfree 0
    initrans 1
    maxtrans 255
    storage
    (
      initial 8M
      next 1M
      minextents 1
      maxextents unlimited
    )
);
-- Create/Recreate indexes 
create index STG_DTM.STG_DIM_DEPOSIT_CONTRACT_I on STG_DTM.STG_DIM_DEPOSIT (CONTRACT)
  nologging  local;
-- Create/Recreate primary, unique and foreign key constraints 
alter table STG_DTM.STG_DIM_DEPOSIT
  add constraint STG_DIM_DEPOSIT_PK primary key (DIMENSION_KEY)
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
alter index STG_DTM.STG_DIM_DEPOSIT_PK nologging;
-- Grant/Revoke object privileges 
grant select on STG_DTM.STG_DIM_DEPOSIT to U_RISK_DTM_FSSC;

-- Create table
create table STG_DTM.STG_FCT_DEPOSIT
(
  dayid                  DATE,
  contract               VARCHAR2(200),
  datasource             VARCHAR2(2),
  co_code                VARCHAR2(50),
  category               VARCHAR2(50),
  customer               VARCHAR2(250),
  product_code           VARCHAR2(50),
  reval_rate             NUMBER(25,5),
  interest_rate          NUMBER(10,5),
  currency               VARCHAR2(3),
  close_bal              NUMBER(25,5),
  close_bal_lcy          NUMBER(25,5),
  accr_int               NUMBER(25,5),
  accr_remain            NUMBER(25,5),
  remain_term            VARCHAR2(10),
  online_actual_bal      NUMBER(25,5),
  online_cleared_bal     NUMBER(25,5),
  open_actual_bal        NUMBER(25,5),
  working_balance        NUMBER(25,5),
  agg_bal_mtd            NUMBER(25,5),
  agg_bal_qtd            NUMBER(25,5),
  agg_bal_ytd            NUMBER(25,5),
  agg_bal                NUMBER(25,5),
  date_last_cr_cust      DATE,
  date_last_dr_cust      DATE,
  date_last_cr_bank      DATE,
  date_last_dr_bank      DATE,
  limit_id               VARCHAR2(35),
  line_no                VARCHAR2(10),
  condition_group        VARCHAR2(35),
  channel_id             VARCHAR2(35),
  sub_channel_id         VARCHAR2(35),
  campaign_id            VARCHAR2(35),
  ben_customer           VARCHAR2(235),
  setlement_ac           VARCHAR2(235),
  ft_count               NUMBER(25),
  ins_fee_rate           NUMBER(25,5),
  ins_end_date           DATE,
  close_reason           VARCHAR2(35),
  term                   VARCHAR2(10),
  term_sbv               VARCHAR2(10),
  sub_product            VARCHAR2(140),
  supp_amt               NUMBER(25,5),
  cr_minimum_bal         NUMBER(25),
  contract_sk            NUMBER,
  company_sk             NUMBER,
  category_sk            NUMBER,
  customer_sk            NUMBER,
  products_sk            NUMBER,
  sub_product_sk         NUMBER,
  limit_sk               NUMBER,
  currency_sk            NUMBER,
  cust_group_sk          NUMBER,
  line_sk                NUMBER,
  channel_sk             NUMBER,
  sub_channel_sk         NUMBER,
  ben_customer_sk        NUMBER,
  remain_term_sk         NUMBER,
  term_sk                NUMBER,
  term_sbv_sk            NUMBER,
  frequency_date         DATE,
  rollover_term          VARCHAR2(12),
  orig_interest_rate     NUMBER,
  first_interest         NUMBER,
  first_balance          NUMBER,
  favorite_term          VARCHAR2(100),
  next_schedule_date_int DATE,
  seab_sales_type        VARCHAR2(35),
  seab_sales_id          VARCHAR2(235),
  seab_brokers_type      VARCHAR2(35),
  seab_brokers_id        VARCHAR2(235),
  offer_rate             NUMBER,
  favorite_offer_rate    NUMBER,
  addition_rate          NUMBER,
  last_reprice_date      DATE,
  agg_bal_mtd_lcy        NUMBER(25,5),
  agg_bal_ytd_lcy        NUMBER(25,5)
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
  )
nologging;
-- Create/Recreate indexes 
create index STG_DTM.STG_FCT_DEPOSIT_CONTRACT_I on STG_DTM.STG_FCT_DEPOSIT (CONTRACT)
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
create index STG_DTM.STG_FCT_DEPOSIT_CUSTOMER_IX on STG_DTM.STG_FCT_DEPOSIT (CUSTOMER)
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
create index STG_DTM.STG_FCT_DEPOSIT_CUSTOMER_SK on STG_DTM.STG_FCT_DEPOSIT (CUSTOMER_SK)
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
-- Grant/Revoke object privileges 
grant select on STG_DTM.STG_FCT_DEPOSIT to U_RISK_DTM_FSSC;


-- Create table
create table STG_DTM.STG_DIM_CARD
(
  dimension_key         NUMBER not null,
  total_sk              NUMBER,
  total                 VARCHAR2(10),
  total_name            VARCHAR2(50),
  card_sk               NUMBER,
  trans_pro_id          VARCHAR2(50),
  tr_sic                VARCHAR2(4),
  eff_date              DATE,
  date_open             DATE,
  exp_date              DATE,
  exprity_date          DATE,
  con_cat               VARCHAR2(1),
  contr_status          NUMBER(22),
  date_expire           DATE,
  currency              VARCHAR2(3),
  pcat                  VARCHAR2(1),
  main_id               VARCHAR2(200),
  registration_date_t24 DATE,
  registration_date     DATE,
  issue_date            DATE,
  inputter              VARCHAR2(50),
  k_type                VARCHAR2(50),
  is_ready              VARCHAR2(1),
  authoriser            VARCHAR2(50),
  card_id               VARCHAR2(100),
  acnt_contract_oid     NUMBER(22),
  amnd_state            VARCHAR2(1),
  account_id            VARCHAR2(200),
  close_date            DATE,
  code                  VARCHAR2(32),
  channel               VARCHAR2(200),
  client_id             VARCHAR2(50),
  card_type             VARCHAR2(50),
  cat                   VARCHAR2(1),
  card_issue            VARCHAR2(200),
  card_status           VARCHAR2(50),
  customer_id           VARCHAR2(200),
  parent_product        VARCHAR2(50),
  promotion_id          VARCHAR2(50),
  limit_des             VARCHAR2(55),
  payment_account       VARCHAR2(50),
  member_code           VARCHAR2(35),
  member_date_exp       DATE,
  embossing_name        VARCHAR2(250),
  card_expire           VARCHAR2(4),
  campaign_id           VARCHAR2(50),
  product_code          VARCHAR2(35),
  trans_date            DATE,
  reissue_date          DATE,
  limit_ref             VARCHAR2(35),
  seab_sales_type       VARCHAR2(35),
  seab_sales_id         VARCHAR2(235),
  seab_brokers_type     VARCHAR2(35),
  seab_brokers_id       VARCHAR2(200),
  date_time_authorise   DATE,
  date_time_input       DATE,
  production_status     VARCHAR2(30),
  open_channel          VARCHAR2(200),
  sub_open_channel      VARCHAR2(200)
)
partition by range (EXP_DATE)
(
  partition STG_DIM_CARD_P0 values less than (TO_DATE(' 9999-12-31 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN'))
    tablespace STG_DTM_TBS
    pctfree 0
    initrans 1
    maxtrans 255
    storage
    (
      initial 8M
      next 1M
      minextents 1
      maxextents unlimited
    ),
  partition STG_DIM_CARD_P1 values less than (MAXVALUE)
    tablespace STG_DTM_TBS
    pctfree 0
    initrans 1
    maxtrans 255
    storage
    (
      initial 8M
      next 1M
      minextents 1
      maxextents unlimited
    )
);
-- Create/Recreate indexes 
create index STG_DTM.STG_DIM_CARD_ID_I on STG_DTM.STG_DIM_CARD (CARD_ID)
  nologging  local;
-- Create/Recreate primary, unique and foreign key constraints 
alter table STG_DTM.STG_DIM_CARD
  add constraint STG_DIM_CARD_PK primary key (DIMENSION_KEY)
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
alter index STG_DTM.STG_DIM_CARD_PK nologging;
-- Grant/Revoke object privileges 
grant select on STG_DTM.STG_DIM_CARD to U_RISK_DTM_FSSC;

-- Create table
create table STG_DTM.STG_DIM_LOAN
(
  dimension_key        NUMBER not null,
  total_name           VARCHAR2(10),
  total                VARCHAR2(10),
  total_sk             NUMBER,
  secured              VARCHAR2(12),
  schedule_define_date DATE,
  rec_status           VARCHAR2(10),
  record_status        VARCHAR2(12),
  value_date           DATE,
  status_pd            VARCHAR2(16),
  contract_sk          NUMBER,
  category             VARCHAR2(50),
  authorise            VARCHAR2(50),
  collateral_desc      VARCHAR2(140),
  chrg_liq_acct        VARCHAR2(50),
  contract_main        VARCHAR2(200),
  contract             VARCHAR2(200),
  co_code              VARCHAR2(50),
  contract_ref         VARCHAR2(80),
  acc_officer          VARCHAR2(16),
  inputter             VARCHAR2(50),
  ln_appr_amt          NUMBER,
  loans_term           VARCHAR2(24),
  loc_term             VARCHAR2(24),
  maturity_date        DATE,
  mortgage_account     VARCHAR2(50),
  overdue_status       VARCHAR2(16),
  period_type          VARCHAR2(50),
  currency             VARCHAR2(12),
  customer             VARCHAR2(50),
  datasource           VARCHAR2(2),
  date_time_authorise  DATE,
  disb_purpose         VARCHAR2(140),
  eff_date             DATE,
  exp_date             DATE,
  fixed_var_ind        VARCHAR2(200),
  lc_number            VARCHAR2(100),
  campaign_id          VARCHAR2(35),
  channel              VARCHAR2(20),
  ref_revolving        VARCHAR2(3),
  ref_value_date       DATE,
  ref_contract_ref     VARCHAR2(35),
  ref_loans_product_id VARCHAR2(25),
  ref_contract_amt     NUMBER,
  ref_mat_date         DATE,
  status               VARCHAR2(12),
  our_remarks          VARCHAR2(1000),
  ref_id               VARCHAR2(35),
  frequency            VARCHAR2(5),
  frequency_day        VARCHAR2(2),
  int_liq_acct         VARCHAR2(50),
  ref_contract_ccy     VARCHAR2(3),
  interest_basis       VARCHAR2(35),
  ld_ctrl_group        VARCHAR2(35),
  des_ld_group         VARCHAR2(300),
  loan_exception       VARCHAR2(35),
  exception_group      VARCHAR2(500),
  exception_item       VARCHAR2(500),
  seab_distance        VARCHAR2(35),
  insurance_info       VARCHAR2(500),
  date_time_input      DATE,
  seab_md_id           VARCHAR2(255),
  frequency_pr         VARCHAR2(10),
  credit_policy        VARCHAR2(255),
  credit_industry      VARCHAR2(255),
  cust_remarks         VARCHAR2(255),
  dept_code            VARCHAR2(30),
  parameter_record     VARCHAR2(50),
  drawdown_account     VARCHAR2(250),
  sub_agency_code      VARCHAR2(250),
  seab_partner1        VARCHAR2(500),
  ref_seab_policy      VARCHAR2(255)
)
partition by range (EXP_DATE)
(
  partition STG_DIM_LOAN_P0 values less than (TO_DATE(' 9999-12-31 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN'))
    tablespace STG_DTM_TBS
    pctfree 0
    initrans 1
    maxtrans 255
    storage
    (
      initial 8M
      next 1M
      minextents 1
      maxextents unlimited
    ),
  partition STG_DIM_LOAN_P1 values less than (MAXVALUE)
    tablespace STG_DTM_TBS
    pctfree 0
    initrans 1
    maxtrans 255
    storage
    (
      initial 8M
      next 1M
      minextents 1
      maxextents unlimited
    )
);
-- Create/Recreate indexes 
create index STG_DTM.STG_DIM_LOAN_I on STG_DTM.STG_DIM_LOAN (CONTRACT)
  nologging  local;
-- Create/Recreate primary, unique and foreign key constraints 
alter table STG_DTM.STG_DIM_LOAN
  add constraint STG_DIM_LOAN_PK primary key (DIMENSION_KEY)
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
alter index STG_DTM.STG_DIM_LOAN_PK nologging;
-- Grant/Revoke object privileges 
grant select on STG_DTM.STG_DIM_LOAN to U_RISK_DTM_FSSC;


-- Create table
create table STG_DTM.STG_FCT_LOAN
(
  dayid                      DATE,
  contract                   VARCHAR2(200),
  datasource                 VARCHAR2(2),
  first_disbursement_amt     NUMBER(25,5),
  first_disbursement_date    DATE,
  last_disbursement_date     DATE,
  last_disbursement_amt      NUMBER(25,5),
  disbursement_amt_ytd       NUMBER(25,5),
  disbursement_amt_wtd       NUMBER(25,5),
  disbursement_amt_mtd       NUMBER(25,5),
  disbursement_amt           NUMBER(25,5),
  agg_disbursement_amt       NUMBER(25,5),
  disbursement_num_ytd       NUMBER(25,5),
  disbursement_num_mtd       NUMBER(25,5),
  disbursement_num_wtd       NUMBER(25,5),
  fixed_rate                 NUMBER,
  interest_rate              NUMBER,
  basic_rate_code            VARCHAR2(200),
  min_contract_rate          NUMBER,
  interest_spread            NUMBER,
  balance                    NUMBER(25,5),
  balance_pe                 NUMBER(25,5),
  balance_ps                 NUMBER(25,5),
  balance_in                 NUMBER(25,5),
  ccy                        VARCHAR2(10),
  pd_balance                 NUMBER(25,5),
  pd_contract                VARCHAR2(200),
  principal_rcvd             NUMBER(25,5),
  receivable_interest        NUMBER(25,5),
  received_interest          NUMBER(25,5),
  received_pe                NUMBER(25,5),
  receivable_pe              NUMBER(25,5),
  received_ps                NUMBER(25,5),
  receivable_ps              NUMBER(25,5),
  acc_receivable_interest    NUMBER(25,5),
  acc_received_interest      NUMBER(25,5),
  acc_received_ps            NUMBER(25,5),
  acc_receivable_ps          NUMBER(25,5),
  acc_received_pe            NUMBER(25,5),
  acc_receivable_pe          NUMBER(25,5),
  ld_legacy_id               VARCHAR2(140),
  extend_sch                 VARCHAR2(50),
  discount_rate              VARCHAR2(32),
  ots_interest               NUMBER(25,5),
  ots_susp_int               NUMBER(25,5),
  extended_date              DATE,
  is_extended                NUMBER(1),
  ln_appr_amt                NUMBER(25,5),
  acc_bal_rate               NUMBER(25,5),
  agg_bal                    NUMBER(25,5),
  agg_bal_mtd                NUMBER(25,5),
  agg_pd_bal_mtd             NUMBER(25,5),
  bal_dlm                    NUMBER(25,5),
  acc_disbursement_rate      NUMBER(25,5),
  acc_pd_bal_rate            NUMBER(25,5),
  agg_pd_bal                 NUMBER(25,5),
  industry_l1                NUMBER,
  co_code                    VARCHAR2(44),
  category                   VARCHAR2(12),
  customer_code              VARCHAR2(40),
  classification             VARCHAR2(12),
  sub_category               VARCHAR2(140),
  sub_product                VARCHAR2(140),
  seab_products              VARCHAR2(140),
  product                    VARCHAR2(140),
  limit_ref                  VARCHAR2(100),
  amt_rec                    VARCHAR2(50),
  committed_int              NUMBER(25,5),
  customer_class             VARCHAR2(35),
  cust_status                VARCHAR2(35),
  contract_class             VARCHAR2(35),
  contract_date_class        DATE,
  contract_des               VARCHAR2(35),
  contract_change_cnt        NUMBER(3),
  contract_change_date       VARCHAR2(35),
  contract_mat_cnt           NUMBER(3),
  class_cur                  VARCHAR2(35),
  repayment_amount           NUMBER,
  contract_type              VARCHAR2(35),
  pr_next_repay_date         DATE,
  start_period_int           DATE,
  end_period_int             DATE,
  period_start_date          DATE,
  period_end_date            DATE,
  no_ovd_days                NUMBER,
  no_days_overdue            NUMBER,
  record_start_date          DATE,
  reval_rate                 NUMBER(25,5),
  acc_bal_rate_wtd           NUMBER(25,5),
  acc_bal_rate_mtd           NUMBER(25,5),
  acc_bal_rate_qtd           NUMBER(25,5),
  agg_bal_wtd                NUMBER(25,5),
  agg_pd_bal_wtd             NUMBER(25,5),
  agg_bal_qtd                NUMBER(25,5),
  agg_pd_bal_qtd             NUMBER(25,5),
  num_grace_period           NUMBER,
  seab_products_de           VARCHAR2(140),
  channel_name               VARCHAR2(200),
  input_extended_date        DATE,
  sub_category_sk            NUMBER,
  limit_sk                   NUMBER,
  contract_sk                NUMBER,
  sub_product_sk             NUMBER,
  seab_products_sk           NUMBER,
  category_sk                NUMBER,
  product_sk                 NUMBER,
  classification_sk          NUMBER,
  company_sk                 NUMBER,
  customer_sk                NUMBER,
  seab_products_de_sk        NUMBER,
  channel_sk                 NUMBER,
  new_int_rate_1             NUMBER,
  new_int_rate_2             NUMBER,
  int_rate_v_date            DATE,
  new_spread                 NUMBER,
  spread_v_date              DATE,
  campaign_id                VARCHAR2(35),
  seab_sales_type            VARCHAR2(35),
  seab_sales_id              VARCHAR2(35),
  seab_brokers_type          VARCHAR2(35),
  seab_brokers_id            VARCHAR2(35),
  first_maturity_date        DATE,
  extend_sch_date            DATE,
  mis_dao                    VARCHAR2(35),
  curr_mis_dao               VARCHAR2(35),
  first_rate                 NUMBER,
  seab_insur_sk              NUMBER,
  seab_insur_id              VARCHAR2(200),
  pref_expiry_date           DATE,
  seab_pur_de                VARCHAR2(35),
  seab_pur_fcy               VARCHAR2(65),
  seab_repay_src             VARCHAR2(35),
  seab_biz_imex              VARCHAR2(35),
  removed_insur_date         DATE,
  seab_pur_de_sk             NUMBER,
  seab_pur_fcy_sk            NUMBER,
  seab_repay_src_sk          NUMBER,
  seab_biz_imex_sk           NUMBER,
  term                       VARCHAR2(30),
  term_sbv                   VARCHAR2(30),
  term_sk                    NUMBER,
  term_sbv_sk                NUMBER,
  source_of_fund             VARCHAR2(12),
  billing_close              DATE,
  lst_billing_close          DATE,
  repayment_date             DATE,
  def_int_cap                VARCHAR2(35),
  seab_partner               VARCHAR2(35),
  seab_los_id                VARCHAR2(35),
  promo_end_date             DATE,
  balance_mat                NUMBER,
  agg_bal_ytd                NUMBER(25,5),
  agg_pd_bal_ytd             NUMBER(25,5),
  new_int_key                VARCHAR2(200),
  frequency_rate             VARCHAR2(5),
  seab_policy                VARCHAR2(200),
  extend_mat_num             NUMBER,
  extend_sch_num             NUMBER,
  last_extend_sch_date       DATE,
  last_extend_date_change    VARCHAR2(255),
  last_extend_user_change    VARCHAR2(255),
  agg_bal_mtd_lcy            NUMBER(25,5),
  agg_bal_ytd_lcy            NUMBER(25,5),
  agg_pd_bal_mtd_lcy         NUMBER(25,5),
  agg_pd_bal_ytd_lcy         NUMBER(25,5),
  disbursement_amt_mtd_lcy   NUMBER(25,5),
  disbursement_amt_ytd_lcy   NUMBER(25,5),
  first_disbursement_amt_lcy NUMBER(25,5),
  sub_agency_code            VARCHAR2(35),
  sub_agency_code_sk         NUMBER,
  acc_received_pr            NUMBER,
  seab_restr_type            VARCHAR2(255),
  seab_other_type            VARCHAR2(255)
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
  )
nologging;
-- Create/Recreate indexes 
create index STG_DTM.STG_FCT_LOAN_CONTRACT_I on STG_DTM.STG_FCT_LOAN (CONTRACT)
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
create index STG_DTM.STG_FCT_LOAN_CUS_CODE on STG_DTM.STG_FCT_LOAN (CUSTOMER_CODE)
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
create index STG_DTM.STG_FCT_LOAN_I on STG_DTM.STG_FCT_LOAN (CONTRACT, PD_CONTRACT)
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
create index STG_DTM.STG_FCT_LOAN_PD_CONTRACT_I on STG_DTM.STG_FCT_LOAN (PD_CONTRACT)
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
-- Grant/Revoke object privileges 
grant select on STG_DTM.STG_FCT_LOAN to U_RISK_DTM_FSSC;

-- Create table
create table STG_DTM.STG_DIM_COLLATERAL
(
  dimension_key     NUMBER not null,
  total_name        VARCHAR2(200),
  total             VARCHAR2(10),
  total_sk          NUMBER,
  registration_no   VARCHAR2(200),
  notes             VARCHAR2(4000),
  collateral_sk     NUMBER,
  reg_date          DATE,
  eff_date          DATE,
  description       VARCHAR2(4000),
  collateral_name   VARCHAR2(200),
  exp_date          DATE,
  coll_type_name    VARCHAR2(200),
  coll_code_name    VARCHAR2(200),
  curr_company      VARCHAR2(50),
  contract_no       VARCHAR2(200),
  collateral_code   VARCHAR2(12),
  ccy               VARCHAR2(3),
  collateral_type   VARCHAR2(12),
  collateral_id     VARCHAR2(200),
  addres            VARCHAR2(4000),
  status            VARCHAR2(10),
  percent_alloc     VARCHAR2(200),
  validity_date     DATE,
  expiry_date_right DATE,
  owner_id          VARCHAR2(250),
  value_date        DATE,
  expiry_date       DATE,
  receive_date      DATE,
  insur_issue_date  DATE,
  is_expiry_date    DATE,
  contract_date     DATE,
  sec_reg_no        VARCHAR2(35),
  regs_date         DATE,
  review_date_fqu   DATE,
  review_frequency  VARCHAR2(50),
  insur_provider    VARCHAR2(200),
  legal_procedure   VARCHAR2(250),
  insurance_req     VARCHAR2(200),
  owner_doctype     VARCHAR2(235),
  owner_name        VARCHAR2(500),
  owner_legal_id    VARCHAR2(235),
  remarks           VARCHAR2(500),
  ver_officer       VARCHAR2(35),
  col_type_details  VARCHAR2(35),
  block_record      VARCHAR2(30),
  inputter          VARCHAR2(200),
  authoriser        VARCHAR2(200),
  seab_vehcle_bra   VARCHAR2(200),
  seab_vehcle_mod   VARCHAR2(200),
  seab_coll_origi   VARCHAR2(200),
  seab_man_year     VARCHAR2(35),
  seab_man_countr   VARCHAR2(200),
  seab_pro_type     VARCHAR2(200),
  seab_reval_type   VARCHAR2(200),
  seab_reval_doc    VARCHAR2(200),
  copy              VARCHAR2(35),
  doc_remarks       VARCHAR2(500),
  seab_col_source   VARCHAR2(200),
  reg_closure       VARCHAR2(200),
  seab_vehcle_stt   VARCHAR2(200),
  sea_coll_area     NUMBER,
  sb_area_bus       NUMBER,
  sb_area_not_bus   NUMBER,
  notary_date       DATE,
  seab_model        VARCHAR2(65),
  seab_reval_comp   VARCHAR2(200),
  seab_reval_no     VARCHAR2(200),
  reg_auth          VARCHAR2(500),
  reg_validity      VARCHAR2(500),
  original          VARCHAR2(200),
  seab_assem_stat   VARCHAR2(200),
  seab_machine_no   VARCHAR2(200),
  seab_capacity     VARCHAR2(200),
  seab_vehcle_no    VARCHAR2(200),
  seab_vehcle_fra   VARCHAR2(200),
  seab_goods_name   VARCHAR2(200),
  quantity          VARCHAR2(200),
  seab_unit         VARCHAR2(200),
  seab_store_owne   VARCHAR2(200),
  seab_store_endd   DATE,
  seab_store_guar   VARCHAR2(200),
  seab_guard_endd   DATE,
  seab_guard_meth   VARCHAR2(200),
  grua_start_date   DATE,
  grua_end_date     DATE,
  seab_debt_right   VARCHAR2(200),
  gruan_commit      VARCHAR2(200),
  seab_owner_stas   VARCHAR2(50),
  seab_owner_id     VARCHAR2(250),
  mng_officer       VARCHAR2(50),
  seab_hub_id       VARCHAR2(200),
  seab_vault_no     VARCHAR2(200),
  seab_vault_date   DATE
)
partition by range (EXP_DATE)
(
  partition STG_DIM_COLLATERAL_P0 values less than (TO_DATE(' 9999-12-31 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN'))
    tablespace STG_DTM_TBS
    pctfree 0
    initrans 1
    maxtrans 255
    storage
    (
      initial 8M
      next 1M
      minextents 1
      maxextents unlimited
    ),
  partition STG_DIM_COLLATERAL_P1 values less than (MAXVALUE)
    tablespace STG_DTM_TBS
    pctfree 0
    initrans 1
    maxtrans 255
    storage
    (
      initial 8M
      next 1M
      minextents 1
      maxextents unlimited
    )
);
-- Create/Recreate primary, unique and foreign key constraints 
alter table STG_DTM.STG_DIM_COLLATERAL
  add constraint STG_DIM_COLLATERAL_PK primary key (DIMENSION_KEY)
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
alter index STG_DTM.STG_DIM_COLLATERAL_PK nologging;
-- Grant/Revoke object privileges 
grant select on STG_DTM.STG_DIM_COLLATERAL to U_RISK_DTM_FSSC;


-- Create table
create table STG_DTM.STG_FCT_COLLATERAL
(
  dayid                 DATE,
  contract_md           VARCHAR2(200),
  collateral_id         VARCHAR2(200),
  co_code               VARCHAR2(50),
  customer              VARCHAR2(50),
  nominal_value         NUMBER,
  execution_value       NUMBER,
  insurance_req         VARCHAR2(200),
  insurance_type        VARCHAR2(200),
  insurance_amount      NUMBER(20),
  insu_issue_date       DATE,
  is_expiry_date        DATE,
  contract_date         DATE,
  sec_reg_no            VARCHAR2(35),
  regs_date             DATE,
  collateral_sk         NUMBER,
  company_sk            NUMBER,
  customer_sk           NUMBER,
  contract_md_sk        NUMBER,
  coll_source_sk        NUMBER,
  coll_source_code      VARCHAR2(35),
  evl_method_sk         NUMBER,
  evl_method_code       VARCHAR2(500),
  store_keeper_sk       NUMBER,
  store_keeper_code     VARCHAR2(35),
  coll_status_sk        NUMBER,
  coll_status_code      VARCHAR2(35),
  legal_status_sk       NUMBER,
  legal_status_code     VARCHAR2(35),
  owner_status_sk       NUMBER,
  owner_status_code     VARCHAR2(35),
  coll_type_sk          NUMBER,
  coll_type             VARCHAR2(12),
  currency_sk           NUMBER,
  currency              VARCHAR2(10),
  insur_type_sk         NUMBER,
  insur_type            VARCHAR2(50),
  comtract_code         VARCHAR2(50),
  percent_bal           NUMBER,
  ver_date              DATE,
  market_value          NUMBER,
  reval_value           NUMBER,
  re_exec_value         NUMBER,
  coll_type_dtl         VARCHAR2(35),
  coll_type_dtl_sk      NUMBER,
  country               VARCHAR2(8),
  province              VARCHAR2(35),
  district              VARCHAR2(35),
  country_sk            NUMBER,
  province_sk           NUMBER,
  district_sk           NUMBER,
  application_id        VARCHAR2(35),
  first_nominal_value   NUMBER,
  first_ver_date        DATE,
  first_evl_method_code VARCHAR2(500),
  sea_issu_id           VARCHAR2(200),
  first_execution_value NUMBER
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
  )
nologging;
-- Grant/Revoke object privileges 
grant select on STG_DTM.STG_FCT_COLLATERAL to U_RISK_DTM_FSSC;


-- Create table
create table STG_DTM.STG_FCT_COLLATERAL_INSUR
(
  dayid           DATE,
  collateral_id   VARCHAR2(200),
  insu_amt        NUMBER(20),
  insu_type       VARCHAR2(50),
  insu_issue_date DATE,
  expire_date     DATE,
  pos_vm          NUMBER(5),
  collateral_sk   NUMBER,
  provider        VARCHAR2(50)
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
  )
nologging;
-- Grant/Revoke object privileges 
grant select on STG_DTM.STG_FCT_COLLATERAL_INSUR to U_RISK_DTM_FSSC;

-- Create table
create table STG_DTM.STG_FCT_COLLA_CONTR_REF
(
  dayid         DATE,
  collateral_id VARCHAR2(50),
  contract_ref  VARCHAR2(50),
  record_status VARCHAR2(30),
  co_code       VARCHAR2(200),
  collateral_sk NUMBER,
  seab_distance VARCHAR2(35)
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
  )
nologging;
-- Grant/Revoke object privileges 
grant select on STG_DTM.STG_FCT_COLLA_CONTR_REF to U_RISK_DTM_FSSC;
