-- Create table
create table RISK_DTM.FCT_LOAN_TRAN
(
  dayid         DATE not null,
  contract      VARCHAR2(200),
  value_date    DATE,
  datasource    VARCHAR2(2),
  customer_code VARCHAR2(40),
  ccy           VARCHAR2(3),
  trans_type    VARCHAR2(5) not null,
  trans_name    VARCHAR2(50),
  amt           NUMBER,
  co_code       VARCHAR2(40),
  category      VARCHAR2(200),
  reval_rate    NUMBER(25,5),
  recid         VARCHAR2(200) not null,
  repay_times   NUMBER not null,
  category_sk   NUMBER,
  company_sk    NUMBER,
  customer_sk   NUMBER,
  contract_sk   NUMBER not null
)
partition by range (DAYID)
interval (NUMTODSINTERVAL(1, 'DAY'))
(
  partition P0 values less than (TO_DATE(' 2008-06-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN'))
    tablespace RISK_DTM_TBS
    pctfree 10
    initrans 1
    maxtrans 255
);
-- Create/Recreate primary, unique and foreign key constraints 
alter table RISK_DTM.FCT_LOAN_TRAN
  add constraint FCT_LOAN_TRAN_PK primary key (DAYID, TRANS_TYPE, RECID, REPAY_TIMES, CONTRACT_SK)
  using index 
  tablespace RISK_DTM_TBS
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


-- Create table
create table RISK_DTM.FCT_MD
(
  contract_md             VARCHAR2(200),
  principal_amt           NUMBER(25,5),
  dayid                   DATE not null,
  co_code                 VARCHAR2(100),
  customer                VARCHAR2(50),
  category                VARCHAR2(50),
  ccy                     VARCHAR2(12),
  charge_ccy              VARCHAR2(12),
  charge_amt              NUMBER(25,5),
  first_principal_amt     NUMBER(25,5),
  total_sched_add_amt     NUMBER(25,5),
  total_sched_all_amt     NUMBER(25,5),
  total_sched_part_amt    NUMBER(25,5),
  total_sched_new_amt     NUMBER(25,5),
  sched_add_amt_ytd       NUMBER(25,5),
  sched_all_amt_ytd       NUMBER(25,5),
  sched_part_amt_ytd      NUMBER(25,5),
  sched_new_amt_ytd       NUMBER(25,5),
  limit_reference         VARCHAR2(40),
  prov_amount             NUMBER(25,5),
  rec_status              VARCHAR2(20),
  category_sk             NUMBER,
  company_sk              NUMBER,
  customer_sk             NUMBER,
  contract_md_sk          NUMBER not null,
  limit_sk                NUMBER,
  campaign_id             VARCHAR2(35),
  seab_sales_type         VARCHAR2(35),
  seab_sales_id           VARCHAR2(35),
  seab_brokers_type       VARCHAR2(35),
  seab_brokers_id         VARCHAR2(35),
  collateral_id           VARCHAR2(35),
  collateral_sk           NUMBER,
  product_code            VARCHAR2(35),
  product_sk              NUMBER,
  term                    VARCHAR2(30),
  term_sk                 NUMBER,
  term_sbv                VARCHAR2(30),
  term_sbv_sk             NUMBER,
  sub_category            VARCHAR2(35),
  sub_category_sk         NUMBER,
  seab_products           VARCHAR2(35),
  seab_products_sk        NUMBER,
  seab_pur_de             VARCHAR2(35),
  seab_pur_de_sk          NUMBER,
  prov_cr_account         VARCHAR2(100),
  classification          VARCHAR2(3),
  classification_sk       NUMBER,
  sub_product             VARCHAR2(35),
  seab_los_id             VARCHAR2(35),
  ben_address             VARCHAR2(4000),
  first_principal_amt_lcy NUMBER(25,5),
  seab_total_amt          NUMBER,
  check_changed           VARCHAR2(10),
  prin_movement           NUMBER
)
partition by range (DAYID)
interval (NUMTODSINTERVAL(1, 'DAY'))
(
  partition P0 values less than (TO_DATE(' 2008-06-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN'))
    tablespace RISK_DTM_TBS
    pctfree 10
    initrans 1
    maxtrans 255
);
-- Create/Recreate primary, unique and foreign key constraints 
alter table RISK_DTM.FCT_MD
  add constraint FCT_MD_PK1 primary key (DAYID, CONTRACT_MD_SK)
  using index 
  local;
alter index RISK_DTM.FCT_MD_PK1 nologging;

-- Create table
create table RISK_DTM.FCT_STMT_ENTRY
(
  dayid              DATE,
  account            VARCHAR2(50),
  pl_category        VARCHAR2(10),
  entry_id           VARCHAR2(100) not null,
  transaction_code   VARCHAR2(50),
  company_code       VARCHAR2(50),
  product_category   VARCHAR2(50),
  narrative          VARCHAR2(1000),
  customer_id        VARCHAR2(50),
  currency           VARCHAR2(10),
  amount             NUMBER(25,5),
  amount_lcy         NUMBER(25,5),
  account_officer    VARCHAR2(50),
  authoriser         VARCHAR2(50),
  booking_date       DATE,
  inputter           VARCHAR2(50),
  our_reference      VARCHAR2(50),
  trans_reference    VARCHAR2(100),
  value_date         DATE,
  loan_contract      VARCHAR2(240),
  ft_id              VARCHAR2(240),
  dc_id              VARCHAR2(240),
  ch_id              VARCHAR2(240),
  tt_id              VARCHAR2(240),
  sc_id              VARCHAR2(240),
  mm_contract        VARCHAR2(240),
  fx_id              VARCHAR2(240),
  system_id          VARCHAR2(16),
  tf_contract        VARCHAR2(240),
  md_contract        VARCHAR2(240),
  reval_rate         NUMBER(25,5),
  consol_key         VARCHAR2(200),
  record_status      VARCHAR2(10),
  account_sk         NUMBER,
  category_sk        NUMBER,
  loan_contract_sk   NUMBER,
  mm_contract_sk     NUMBER,
  securities_sk      NUMBER,
  tf_contract_sk     NUMBER,
  company_sk         NUMBER,
  customer_sk        NUMBER,
  md_contract_sk     NUMBER,
  date_time          DATE,
  their_reference    VARCHAR2(200),
  company_user       VARCHAR2(35 CHAR),
  company_accounting VARCHAR2(35 CHAR),
  inputter_his       VARCHAR2(4000 CHAR),
  narrative_all      VARCHAR2(4000 CHAR),
  company_user_sk    NUMBER,
  company_acc_sk     NUMBER,
  exchange_rate      NUMBER,
  process_account    VARCHAR2(50),
  department_code    VARCHAR2(35)
)
partition by range (DAYID)
interval (NUMTODSINTERVAL(1, 'DAY'))
(
  partition FCT_STMT_ENTRY_P0 values less than (TO_DATE(' 2008-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN'))
    tablespace RISK_DTM_TBS
    pctfree 10
    initrans 1
    maxtrans 255
);
-- Create/Recreate primary, unique and foreign key constraints 
alter table RISK_DTM.FCT_STMT_ENTRY
  add constraint FCT_STMT_ENTRY_PK primary key (ENTRY_ID)
  using index 
  tablespace RISK_DTM_TBS
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

-- Create table
create table RISK_DTM.FCT_EXCHANGE_RATE
(
  dayid          DATE not null,
  ccy            VARCHAR2(10) not null,
  mid_reval_rate NUMBER(25,5),
  buy_rate       NUMBER(25,5),
  sell_rate      NUMBER(25,5),
  reval_rate     NUMBER(25,5)
)
partition by range (DAYID)
interval (NUMTODSINTERVAL(1, 'DAY'))
(
  partition P0 values less than (TO_DATE(' 2008-06-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN'))
    tablespace RISK_DTM_TBS
    pctfree 10
    initrans 1
    maxtrans 255
);
-- Create/Recreate indexes 
create unique index RISK_DTM.FCT_EXCHANGE_RATE_PK on RISK_DTM.FCT_EXCHANGE_RATE (DAYID, CCY)
  nologging  local;

-- Create table
create table RISK_DTM.FCT_FUNDS_TRANSFER
(
  dayid               DATE not null,
  ft_id               VARCHAR2(50) not null,
  channel             VARCHAR2(200),
  charge_code         VARCHAR2(50),
  charged_customer    VARCHAR2(240),
  classify_code       VARCHAR2(140),
  co_code             VARCHAR2(11),
  commission_code     VARCHAR2(80),
  credit_acct_no      VARCHAR2(264),
  credit_amount       NUMBER(25,5),
  credit_currency     VARCHAR2(12),
  credit_customer     VARCHAR2(240),
  credit_their_ref    VARCHAR2(50),
  credit_value_date   DATE,
  debit_acct_no       VARCHAR2(264),
  debit_amount        NUMBER(25,5),
  debit_currency      VARCHAR2(12),
  debit_customer      VARCHAR2(240),
  debit_value_date    DATE,
  inputter            VARCHAR2(50),
  ordering_cust       VARCHAR2(4000),
  rec_status          VARCHAR2(16),
  record_status       VARCHAR2(16),
  transaction_type    VARCHAR2(16),
  username_seanet     VARCHAR2(80),
  bc_bank_sort_code   VARCHAR2(80),
  tax_type1           VARCHAR2(200),
  seab_tax_ccy_1      VARCHAR2(12),
  tax_amt1            NUMBER,
  tax_type2           VARCHAR2(200),
  seab_tax_ccy_2      VARCHAR2(12),
  tax_amt2            NUMBER,
  total_charge_amt    NUMBER,
  total_tax_amount    NUMBER,
  auth_date           DATE,
  authoriser          VARCHAR2(80),
  inputter_2          VARCHAR2(100),
  payment_details     VARCHAR2(4000),
  owner_name          VARCHAR2(500),
  owner_address       VARCHAR2(2000),
  owner_tel           VARCHAR2(200),
  debit_their_ref     VARCHAR2(50),
  debit_comp_code     VARCHAR2(11),
  credit_comp_code    VARCHAR2(11),
  reval_rate_cr       NUMBER(25,5),
  reval_rate_dr       NUMBER(25,5),
  loc_amt_debited     NUMBER(25,5),
  amount_credited     NUMBER(25,5),
  amount_debited      NUMBER(25,5),
  cust_tel_no         VARCHAR2(50),
  product_code        VARCHAR2(50),
  cover_methor        VARCHAR2(50),
  acct_with_bank      VARCHAR2(200),
  receiver_bank       VARCHAR2(200),
  txn_purpose         VARCHAR2(20),
  debit_customer_sk   NUMBER,
  ebank_sk            NUMBER,
  company_sk          NUMBER,
  credit_customer_sk  NUMBER,
  company_credit_sk   NUMBER,
  company_debit_sk    NUMBER,
  product_sk          NUMBER,
  channel_sk          NUMBER,
  bal_aft_txn         VARCHAR2(100),
  date_time_authorise DATE,
  trans_code          VARCHAR2(200),
  sub_channel         VARCHAR2(35),
  loc_amt_credited    NUMBER,
  loc_tot_tax_amt     NUMBER,
  local_charge_amt    NUMBER,
  loc_pos_chgs_amt    NUMBER,
  ft_pay_details      VARCHAR2(35),
  campaign_id         VARCHAR2(35),
  seab_sales_type     VARCHAR2(35),
  seab_sales_id       VARCHAR2(235),
  seab_brokers_type   VARCHAR2(35),
  seab_brokers_id     VARCHAR2(235),
  profit_centre_dept  VARCHAR2(16),
  seab_ofs_ref        VARCHAR2(1000),
  at_unique_id        VARCHAR2(86),
  atm_term_id         VARCHAR2(40),
  trace_id            VARCHAR2(48),
  at_add_info         VARCHAR2(60),
  ben_customer        VARCHAR2(255),
  in_ben_customer     VARCHAR2(450),
  in_ben_acct_no      VARCHAR2(235),
  branch_id           VARCHAR2(35),
  province            VARCHAR2(35),
  bank_branches_sk    NUMBER,
  ft_ben_acct_no      VARCHAR2(255),
  credit_acct_no_sk   NUMBER,
  debit_acct_no_sk    NUMBER,
  cheque_number       VARCHAR2(35),
  trans_purpose       VARCHAR2(35),
  pay_principal       NUMBER,
  charge_acct_no      VARCHAR2(264),
  treasury_rate       NUMBER,
  purpose_details     VARCHAR2(35),
  sending_addr        VARCHAR2(2000),
  receiving_addr      VARCHAR2(2000),
  seab_ben_cus        VARCHAR2(1000),
  seab_pay_detail     VARCHAR2(1000),
  seab_token_key      VARCHAR2(100),
  atm_trans_date      DATE,
  dept_code           VARCHAR2(16),
  ord_cust_acct       VARCHAR2(235),
  ft_cost_pool        VARCHAR2(255),
  commission_type1    VARCHAR2(20),
  commission_type2    VARCHAR2(20),
  commission_type3    VARCHAR2(20),
  commission_type4    VARCHAR2(20),
  cost_pool_sk        NUMBER,
  profit_centre_cust  VARCHAR2(40),
  date_time_input     DATE,
  clearing_id         VARCHAR2(200),
  seab_ord_cus        VARCHAR2(200),
  received_addr       VARCHAR2(2000),
  ben_acct_no         VARCHAR2(255),
  ben_our_charges     VARCHAR2(35),
  seab_context        VARCHAR2(1000),
  seab_location       VARCHAR2(1000),
  chuyen_tiep         VARCHAR2(50),
  atm_bin_no          VARCHAR2(255),
  banks_code_id       VARCHAR2(255),
  seab_custody        VARCHAR2(50),
  seab_nego_rate      VARCHAR2(50),
  reference_no        VARCHAR2(255),
  inputter_his        VARCHAR2(255),
  seab_partner1       VARCHAR2(500),
  seab_remit_fee      VARCHAR2(25),
  id_pack             VARCHAR2(4000),
  seab_token_card     VARCHAR2(65),
  sb_ft_sof           VARCHAR2(100),
  seab_los_id         VARCHAR2(100),
  inw_send_bic        VARCHAR2(255),
  telex_form_cust     VARCHAR2(255),
  customer_rate       NUMBER,
  msg_value_date      DATE,
  seab_batch_id       VARCHAR2(255),
  seab_cust_pros      VARCHAR2(35),
  instrctn_code       VARCHAR2(255),
  ben_name            VARCHAR2(50),
  in_ben_name         VARCHAR2(500),
  first_inputter      VARCHAR2(255),
  first_date_time     DATE
)
partition by range (DAYID)
interval (NUMTODSINTERVAL(1, 'DAY'))
(
  partition P0 values less than (TO_DATE(' 2008-06-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN'))
    tablespace RISK_DTM_TBS
    pctfree 10
    initrans 1
    maxtrans 255
);
-- Create/Recreate indexes 
create index RISK_DTM.CHANNEL_SK_IDX_1 on RISK_DTM.FCT_FUNDS_TRANSFER (CHANNEL_SK)
  nologging  local;
create index RISK_DTM.CREDIT_CUSTOMER_SK_IDX on RISK_DTM.FCT_FUNDS_TRANSFER (CREDIT_CUSTOMER_SK)
  nologging  local;
create index RISK_DTM.EBANK_SK_IDX on RISK_DTM.FCT_FUNDS_TRANSFER (EBANK_SK)
  nologging  local;
-- Create/Recreate primary, unique and foreign key constraints 
alter table RISK_DTM.FCT_FUNDS_TRANSFER
  add constraint FCT_FUNDS_TRANSFER_PK primary key (FT_ID, DAYID)
  using index 
  tablespace RISK_DTM_TBS
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


-- Create table
create table RISK_DTM.DIM_COLLATERAL_TYPE
(
  dimension_key   NUMBER not null,
  total_sk        NUMBER,
  total_code      VARCHAR2(10),
  total_name      VARCHAR2(100),
  colla_type_sk   NUMBER,
  colla_type_code VARCHAR2(50),
  colla_type_name VARCHAR2(200),
  eff_date        DATE,
  exp_date        DATE
)
tablespace RISK_DTM_TBS
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
-- Create/Recreate indexes 
create index RISK_DTM.COLLA_TYPE_IDX on RISK_DTM.DIM_COLLATERAL_TYPE (COLLA_TYPE_CODE)
  tablespace RISK_DTM_TBS
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
create unique index RISK_DTM.DIM_COLLA_TYPE_PK on RISK_DTM.DIM_COLLATERAL_TYPE (DIMENSION_KEY)
  tablespace RISK_DTM_TBS
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


-- Create table
create table RISK_DTM.DIM_DW_SEAB_CONTRACT_REF_DEFIN
(
  dimension_key                  NUMBER not null,
  total                          VARCHAR2(10),
  total_name                     VARCHAR2(10),
  total_sk                       NUMBER,
  loans_product_id               VARCHAR2(25),
  contract_amt                   NUMBER,
  contract_ref                   VARCHAR2(35),
  recid                          VARCHAR2(35),
  revolving                      VARCHAR2(3),
  mat_date                       DATE,
  value_date                     DATE,
  exp_date                       DATE,
  eff_date                       DATE,
  dw_seab_contract_ref_define_sk NUMBER,
  currency                       VARCHAR2(3),
  ld_ctrl_group                  VARCHAR2(35),
  des_ld_group                   VARCHAR2(300),
  loan_exception                 VARCHAR2(35),
  exception_group                VARCHAR2(500),
  exception_item                 VARCHAR2(500),
  seab_distance                  VARCHAR2(35),
  staff_id                       NUMBER,
  legacy_ref                     VARCHAR2(35),
  insurance_info                 VARCHAR2(500),
  co_code                        VARCHAR2(50),
  credit_policy                  VARCHAR2(255),
  credit_industry                VARCHAR2(255),
  customer_id                    VARCHAR2(50),
  seab_policy                    VARCHAR2(255),
  date_time                      DATE,
  curr_no                        VARCHAR2(255),
  card_no                        VARCHAR2(255),
  seab_los_id                    VARCHAR2(50)
)
tablespace RISK_DTM_TBS
  pctfree 0
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  )
compress
nologging;
-- Create/Recreate indexes 
create unique index RISK_DTM.DIM_DW_SEAB_CONTR_REF_DEFIN_PK on RISK_DTM.DIM_DW_SEAB_CONTRACT_REF_DEFIN (DIMENSION_KEY)
  tablespace RISK_DTM_TBS
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
create index RISK_DTM.DW_SEAB_CONTRACT_REF_DE_IDX on RISK_DTM.DIM_DW_SEAB_CONTRACT_REF_DEFIN (RECID)
  tablespace RISK_DTM_TBS
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
create index RISK_DTM.IDX_DW_SEAB_CONTR_REF_DEFIN_DATE on RISK_DTM.DIM_DW_SEAB_CONTRACT_REF_DEFIN (EFF_DATE, EXP_DATE)
  tablespace RISK_DTM_TBS
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


-- Create table
create table RISK_DTM.DIM_USER
(
  dimension_key       NUMBER not null,
  total_name          VARCHAR2(10),
  total_sk            NUMBER,
  total               VARCHAR2(10),
  user_name           VARCHAR2(200),
  user_id             VARCHAR2(255),
  time_last_sign_on   VARCHAR2(200),
  language            VARCHAR2(200),
  init_applicationsau VARCHAR2(200),
  exp_date            DATE,
  end_date_profile    VARCHAR2(200),
  start_date_profile  VARCHAR2(200),
  user_sk             NUMBER,
  sign_on_name        VARCHAR2(200),
  passw_change_date   VARCHAR2(200),
  department_code     VARCHAR2(200),
  eff_date            DATE,
  classification      VARCHAR2(200),
  date_last_sign_on   VARCHAR2(200),
  attributes          VARCHAR2(200),
  seab_hr_cust_id     VARCHAR2(35),
  company_code        VARCHAR2(35)
)
tablespace RISK_DTM_TBS
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
-- Create/Recreate indexes 
create unique index RISK_DTM.DIMENSION_KEY_PK_132 on RISK_DTM.DIM_USER (DIMENSION_KEY)
  tablespace RISK_DTM_TBS
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
create index RISK_DTM.USER_IDX on RISK_DTM.DIM_USER (USER_ID)
  tablespace RISK_DTM_TBS
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




-- Create table
create table RISK_DTM.DIM_COLL_RIGHT
(
  dimension_key       NUMBER not null,
  total               VARCHAR2(20),
  total_name          VARCHAR2(30),
  total_sk            NUMBER,
  exp_date            DATE,
  inputter            VARCHAR2(200),
  dept_code           VARCHAR2(16),
  eff_date            DATE,
  co_code             VARCHAR2(44),
  date_time           DATE,
  authoriser          VARCHAR2(200),
  collateral_code     VARCHAR2(200),
  status              VARCHAR2(200),
  validity_date       DATE,
  review_date_fqu     VARCHAR2(200),
  collateral_right_sk NUMBER,
  notes               VARCHAR2(4000),
  recid               VARCHAR2(200),
  alloc_work_id       VARCHAR2(200),
  expiry_date         DATE,
  right_at_company    VARCHAR2(50)
)
tablespace RISK_DTM_TBS
  pctfree 0
  initrans 1
  maxtrans 255
compress
nologging;
-- Create/Recreate indexes 
create index RISK_DTM.COLLATERAL_RIGHT_IDX on RISK_DTM.DIM_COLL_RIGHT (RECID)
  tablespace RISK_DTM_TBS
  pctfree 10
  initrans 2
  maxtrans 255
  nologging;
create unique index RISK_DTM.DIMENSION_KEY_PK_65 on RISK_DTM.DIM_COLL_RIGHT (DIMENSION_KEY)
  tablespace RISK_DTM_TBS
  pctfree 10
  initrans 2
  maxtrans 255
  nologging;

/*
-- Create table
create table RISK_DTM.LOGIP
(
  dayid               DATE,            -- Ngay bao cao
  event_name          VARCHAR2(100),   -- Ten su kien (log.CHANNEL)
  source_ip           VARCHAR2(100),   -- IP nguon (log.IP_ADDRESS)
  destination_ip      VARCHAR2(100),   -- IP dich (log.LOCATION)
  username            VARCHAR2(50),    -- Cus ID (log.USER_ID)
  context_eb          CLOB,            -- Ngu canh thiet bi & ung dung (log.CONTEXT)
  ebank_login_id      VARCHAR2(100),   -- ID phien dang nhap (log.ID)
  login_time_eb       TIMESTAMP(0),    -- Thoi gian trong phien dang nhap (log.LOGIN_TIME)
  machine_name        VARCHAR2(100),   -- Ten thiet bi
  machine_type        VARCHAR2(100),   -- Loai thiet bi
  application         VARCHAR2(100),   -- Ung dung
  biometric_type      VARCHAR2(100),   -- Co/khong su dung phuong thuc xac thuc bang sinh trac hoc
  sub_channel         VARCHAR2(100)    -- Kenh dang nhap
)
partition by range (DAYID)
interval (NUMTODSINTERVAL(1, 'DAY'))
(
  partition P0 values less than (TO_DATE(' 2023-05-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN'))
    tablespace RISK_DTM_TBS
    pctfree 10
    initrans 1
    maxtrans 255
);
-- Create/Recreate indexes 
create index RISK_DTM.LOGIP_ID_I on RISK_DTM.LOGIP (EBANK_LOGIN_ID)
  nologging  local;
-- Create/Recreate primary, unique and foreign key constraints 
alter table RISK_DTM.LOGIP
  add constraint LOGIP_PK primary key (DAYID, USERNAME, LOGIN_TIME_EB)
  using index 
  local;
*/

-- Create table
create table RISK_DTM.DIM_REPO_SECURITIES
(
  dimension_key         NUMBER not null,
  repo_sk               NUMBER,
  repo_repo_id          VARCHAR2(35),
  repo_currency         VARCHAR2(10),
  new_sec_code_sk       NUMBER,
  new_sec_code_repo_id  VARCHAR2(35),
  new_sec_code          VARCHAR2(35),
  new_nominal           NUMBER,
  new_sec_code_currency VARCHAR2(10),
  authoriser            VARCHAR2(35),
  inputter              VARCHAR2(35),
  eff_date              DATE,
  exp_date              DATE
)
tablespace RISK_DTM_TBS
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
-- Create/Recreate indexes 
create unique index RISK_DTM.DIM_REPO_SECURITIES_PK on RISK_DTM.DIM_REPO_SECURITIES (DIMENSION_KEY)
  tablespace RISK_DTM_TBS
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
create index RISK_DTM.NEW_SEC_CODE_IDX on RISK_DTM.DIM_REPO_SECURITIES (NEW_SEC_CODE, NEW_SEC_CODE_REPO_ID)
  tablespace RISK_DTM_TBS
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
create index RISK_DTM.REPO_IDX on RISK_DTM.DIM_REPO_SECURITIES (REPO_REPO_ID)
  tablespace RISK_DTM_TBS
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


-- Create table
create table RISK_DTM.FCT_REPO
(
  dayid             DATE not null,
  repo_id           VARCHAR2(35) not null,
  repo_type         VARCHAR2(35),
  counterparty      VARCHAR2(35),
  currency          VARCHAR2(10),
  trade_date        DATE,
  value_date        DATE,
  maturity_date     DATE,
  principal_amount_1 NUMBER,
  principal_amount_2 NUMBER,
  repo_rate         NUMBER,
  product_category  VARCHAR2(35),
  co_code           VARCHAR2(11),
  company_sk        NUMBER,
  counterparty_sk   NUMBER,
  repo_sk           NUMBER,
  mm_contract_id    VARCHAR2(35),
  seab_product_de   VARCHAR2(35),
  product_sk        NUMBER,
  interest_basis    VARCHAR2(10),
  rec_status        VARCHAR2(30),
  interest_amount   NUMBER,
  last_reprice_date DATE,
  condition         VARCHAR2(4000),
  sb_acct_officer   VARCHAR2(255),
  drawdown_account  VARCHAR2(50)
)
partition by range (DAYID)
interval (NUMTODSINTERVAL(1, 'DAY'))
(
  partition P0 values less than (TO_DATE(' 2008-06-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN'))
    tablespace RISK_DTM_TBS
    pctfree 10
    initrans 1
    maxtrans 255
);
-- Create/Recreate indexes 
create bitmap index RISK_DTM.COMPANY_SK_IDX_48 on RISK_DTM.FCT_REPO (COMPANY_SK)
  nologging  local;
create bitmap index RISK_DTM.COUNTERPARTY_SK_IDX on RISK_DTM.FCT_REPO (COUNTERPARTY_SK)
  nologging  local;
create unique index RISK_DTM.FCT_REPO_PK on RISK_DTM.FCT_REPO (DAYID, REPO_ID)
  nologging  local;
create bitmap index RISK_DTM.REPO_SK_IDX on RISK_DTM.FCT_REPO (REPO_SK)
  nologging  local;


-- Create table
create table RISK_DTM.AGG_MONEY_MARKET
(
  dayid        DATE,           -- Ngay du lieu
  contract     VARCHAR2(50),   -- Ma hop dong MM
  repo_id      VARCHAR2(35),   -- Ma Repo
  category     VARCHAR2(50),   -- Ma phan loai san pham
  new_sec_code VARCHAR2(35),   -- Ma GTCG
  asset_type   VARCHAR2(200),  -- Loai TSDB
  contract_no  VARCHAR2(35),   -- So hop dong TSDB
  face_ccy     VARCHAR2(25),   -- Loai tien te giao dich TSDB
  asset_issuer NUMBER,         -- Chu the phat hanh TSDB
  face_value   NUMBER,         -- Gia tri TSDB
  co_available NUMBER,         -- Gia tri kha dung cua TSDB
  tenor_from   DATE,           -- Ngay gia tri TSDB
  tenor_to     DATE            -- Ngay dao han TSDB
)
partition by range (DAYID)
interval (NUMTODSINTERVAL(1, 'DAY'))
(
  partition P0 values less than (TO_DATE(' 2008-06-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN'))
    tablespace RISK_DTM_TBS
    pctfree 10
    initrans 1
    maxtrans 255
);
-- Create/Recreate indexes 
create index RISK_DTM.AGG_MONEY_MARKET_CONTRACT_I on RISK_DTM.AGG_MONEY_MARKET (CONTRACT)
  nologging  local;
-- Create/Recreate primary, unique and foreign key constraints 
alter table RISK_DTM.AGG_MONEY_MARKET
  add constraint AGG_MONEY_MARKET_PK primary key (DAYID, CONTRACT, NEW_SEC_CODE)
  using index 
  local;
