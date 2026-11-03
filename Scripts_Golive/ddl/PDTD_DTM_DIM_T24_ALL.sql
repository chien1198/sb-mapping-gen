
--Bang DIM_T24_COMPANY
create table PDTD_DTM.DIM_T24_COMPANY
(
  dimension_key      NUMBER,
  region_code        VARCHAR2(50),
  region_name        VARCHAR2(300),
  region_sk          NUMBER,
  region_eff_date    DATE,
  region_exp_date    DATE,
  country_code       VARCHAR2(50),
  city_branch_cd     VARCHAR2(50),
  city_name          VARCHAR2(300),
  city_exp_date      DATE,
  city_eff_date      DATE,
  country_name       VARCHAR2(300),
  city_sk            NUMBER,
  districts_eff_date DATE,
  districts_exp_date DATE,
  districts_cd       VARCHAR2(50),
  districts_name     VARCHAR2(300),
  districts_sk       NUMBER,
  branch_name        VARCHAR2(300),
  branch_exp_date    DATE,
  branch_eff_date    DATE,
  branch_code        VARCHAR2(50),
  branch_sk          NUMBER,
  company_name       VARCHAR2(300),
  company_sk         NUMBER,
  company_eff_date   DATE,
  company_exp_date   DATE,
  company_address    VARCHAR2(4000),
  company_code       VARCHAR2(50),
  company_name_vn    VARCHAR2(300),
  tax_code           VARCHAR2(30),
  mnemonic           VARCHAR2(12),
  dept_code          VARCHAR2(35)
)
tablespace PDTD_DTM_TBS
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 80K
    next 1M
    minextents 1
    maxextents unlimited
  )
nologging;

--Bang DIM_T24_LOAN
create table PDTD_DTM.DIM_T24_LOAN
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
  partition DIM_T24_LOAN_P0 values less than (TO_DATE(' 9999-12-31 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN'))
    tablespace PDTD_DTM_TBS
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
  partition DIM_T24_LOAN_P1 values less than (MAXVALUE)
    tablespace PDTD_DTM_TBS
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
create index PDTD_DTM.DIM_T24_LOAN_I on PDTD_DTM.DIM_T24_LOAN (CONTRACT)
  nologging  local;
-- Create/Recreate primary, unique and foreign key constraints
alter table PDTD_DTM.DIM_T24_LOAN
  add constraint DIM_T24_LOAN_PK primary key (DIMENSION_KEY)
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
alter index PDTD_DTM.DIM_T24_LOAN_PK nologging;

--Bang DIM_T24_SEAB_PRODUCTS_DE
create table PDTD_DTM.DIM_T24_SEAB_PRODUCTS_DE
(
  dimension_key         NUMBER not null,
  total_sk              NUMBER,
  total                 VARCHAR2(10),
  total_name            VARCHAR2(30),
  seab_products_de      VARCHAR2(35),
  seab_products_de_name VARCHAR2(200),
  seab_products_de_sk   NUMBER,
  exp_date              DATE,
  eff_date              DATE,
  product_group         VARCHAR2(35)
)
partition by range (EXP_DATE)
(
  partition DIM_T24_SEAB_PRODUCTS_DE_P0 values less than (TO_DATE(' 9999-12-31 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN'))
    tablespace PDTD_DTM_TBS
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
  partition DIM_T24_SEAB_PRODUCTS_DE_P1 values less than (MAXVALUE)
    tablespace PDTD_DTM_TBS
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
alter table PDTD_DTM.DIM_T24_SEAB_PRODUCTS_DE
  add constraint DIM_T24_SEAB_PRODUCTS_DE_PK primary key (DIMENSION_KEY)
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
alter index PDTD_DTM.DIM_T24_SEAB_PRODUCTS_DE_PK nologging;


--Bang DIM_T24_CARD
create table PDTD_DTM.DIM_T24_CARD
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
  partition DIM_T24_CARD_P0 values less than (TO_DATE(' 9999-12-31 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN'))
    tablespace PDTD_DTM_TBS
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
  partition DIM_T24_CARD_P1 values less than (MAXVALUE)
    tablespace PDTD_DTM_TBS
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
create index PDTD_DTM.DIM_T24_CARD_ID_I on PDTD_DTM.DIM_T24_CARD (CARD_ID)
  nologging  local;
-- Create/Recreate primary, unique and foreign key constraints
alter table PDTD_DTM.DIM_T24_CARD
  add constraint DIM_T24_CARD_PK primary key (DIMENSION_KEY)
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
alter index PDTD_DTM.DIM_T24_CARD_PK nologging;

--Bang DIM_T24_SEAB_MAIN_CARD
create table PDTD_DTM.DIM_T24_SEAB_MAIN_CARD
(
  dimension_key       NUMBER not null,
  total_sk            NUMBER,
  total               VARCHAR2(10),
  total_name          VARCHAR2(10),
  agent               VARCHAR2(50),
  answer              VARCHAR2(200),
  authoriser          VARCHAR2(50),
  billing_close       VARCHAR2(50),
  account_link        VARCHAR2(50),
  question            VARCHAR2(200),
  promotion_id        VARCHAR2(50),
  phone_number        VARCHAR2(50),
  max_reg             DATE,
  reg_number          VARCHAR2(800),
  reg_date            DATE,
  registration_date   DATE,
  recid               VARCHAR2(50),
  recid_sk            NUMBER,
  salary              VARCHAR2(50),
  repay_date          VARCHAR2(50),
  reg_number2         VARCHAR2(50),
  way4_reg_number     VARCHAR2(50),
  trans_pro_id        VARCHAR2(50),
  trade_name          VARCHAR2(200),
  card_type           VARCHAR2(50),
  client_type         VARCHAR2(50),
  card_classification VARCHAR2(50),
  card_status         VARCHAR2(50),
  eff_date            DATE,
  embossing_name      VARCHAR2(50),
  company_name        VARCHAR2(200),
  com_salary          VARCHAR2(50),
  first_name          VARCHAR2(50),
  home_address        VARCHAR2(200),
  emb_comp_name       VARCHAR2(200),
  exp_date            DATE,
  last_name           VARCHAR2(50),
  mail_address        VARCHAR2(100),
  id_date             DATE,
  inputter            VARCHAR2(50),
  rate_to_funds       NUMBER,
  auto_funds_y_n      VARCHAR2(35),
  pin_receiving       VARCHAR2(35),
  ecommer_y_n         VARCHAR2(35),
  physical_type       VARCHAR2(35)
)
partition by range (EXP_DATE)
(
  partition DIM_T24_SEAB_MAIN_CARD_P0 values less than (TO_DATE(' 9999-12-31 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN'))
    tablespace PDTD_DTM_TBS
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
  partition DIM_T24_SEAB_MAIN_CARD_P1 values less than (MAXVALUE)
    tablespace PDTD_DTM_TBS
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
alter table PDTD_DTM.DIM_T24_SEAB_MAIN_CARD
  add constraint DIM_T24_SEAB_MAIN_CARD_PK primary key (DIMENSION_KEY)
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
alter index PDTD_DTM.DIM_T24_SEAB_MAIN_CARD_PK nologging;

--Bang DIM_T24_CUSTOMER
create table PDTD_DTM.DIM_T24_CUSTOMER
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
  partition DIM_T24_CUSTOMER_P0 values less than (TO_DATE(' 9999-12-31 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN'))
    tablespace PDTD_DTM_TBS
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
  partition DIM_T24_CUSTOMER_P1 values less than (MAXVALUE)
    tablespace PDTD_DTM_TBS
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
create index PDTD_DTM.DIM_T24_CUSTOMER_CUST_IDX on PDTD_DTM.DIM_T24_CUSTOMER (CUSTOMER)
  nologging  local;
create index PDTD_DTM.DIM_T24_CUSTOMER_LEGAL_IDX on PDTD_DTM.DIM_T24_CUSTOMER (LEGAL_ID)
  nologging  local;
-- Create/Recreate primary, unique and foreign key constraints
alter table PDTD_DTM.DIM_T24_CUSTOMER
  add constraint DIM_T24_CUSTOMER_PK primary key (DIMENSION_KEY)
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
alter index PDTD_DTM.DIM_T24_CUSTOMER_PK nologging;
