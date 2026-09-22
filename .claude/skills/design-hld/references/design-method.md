# Design method — DIM and FACT reasoning chains

Apply the matching chain below to every table **before** looking at what
columns the old merged `DIM_LOS_*`/`FCT_LOS_*`/`DIM_PDTD_*`/`FCT_PDTD_*` table
happened to have. The old column list is evidence, not the answer — a column
that was only ever populated for one of the two systems should not survive
into the split table for the other system.

## DIM reasoning chain

> Xuất phát từ (các) bảng nguồn trên LOS cùng mô tả 1 đối tượng nghiệp vụ →
> hợp nhất thành 1 chiều duy nhất ở tầng SB_DWH (`DIM_LOS_*`) → xem thuộc
> tính chính có phải loại tương đối ổn định, dùng để phân loại/gắn nhãn hay
> không → nếu đúng, kết luận tạo DIM, và PDTD_DTM bê nguyên 1-1 từ DIM_LOS
> tương ứng.

Steps to work through explicitly for every DIM:

1. **Identify the source tables.** Which STG_LOS table(s) (per
   `extract/SB_DWH/<TABLE>.md`'s "Nguồn" line) describe this one business
   entity? For a CLOS/RLOS split table there are usually two source tables,
   one per system (e.g. `NG_SB_CLOS_CUST_INFO` / `NG_SB_RLOS_APPLICANT_GENERAL`
   both feeding a shared `DIM_LOS_ORG_UNIT`, or `NG_SB_CLOS_APPROVAL` alone
   feeding `DIM_CLOS_APPROVAL_GROUP`).
2. **Confirm they describe one entity, not two.** If the "shared" dimension
   is actually gluing together two different business concepts under one
   table (this was the original problem the split proposal fixed), that's
   already resolved by the split — don't re-introduce it.
3. **Check attribute stability.** A DIM column should be a relatively stable,
   classification/labeling attribute of the entity (a code, a name, a type,
   a flag that rarely changes) — not something that varies per transaction
   or per day. If a column looks transaction-scoped, it doesn't belong in
   the DIM; flag it and ask (see SKILL.md "Where to stop and ask").
4. **Only then conclude DIM**, with the key as `DIMENSION_KEY` (see key rules
   below).
5. **PDTD_DTM copies 1:1 from the SB_DWH `DIM_LOS_*`/`DIM_CLOS_*`/`DIM_RLOS_*`
   counterpart** — same `DIMENSION_KEY` values (never a new sequence), same
   EFF_DATE/EXP_DATE (SCD2 history already resolved at SB_DWH, not
   recomputed at PDTD_DTM). The PDTD_DTM version may then LEFT JOIN one of
   the 9 `REF_` tables to add report-facing normalized columns (e.g.
   `BI_FLOW`, `ZONE`) — this is the only place PDTD_DTM's column list may
   exceed SB_DWH's for the same table.

## Red flag — source table has no CDC key → can't be a DIM/SCD2

Before applying the "attribute stability" test in DIM chain step 3, check one
prior, harder gate: does the STG_LOS source table even declare a **CDC key**?
Look it up in `input/DS_BANG_202608.xlsx` (sheet `DS_bang`, column `KEY CDC`)
— do this for every source table, every time, not only when a table's columns
already look suspiciously DIM-like. An empty `KEY CDC` cell means the source
system does not expose a stable row identity independent of the row's own
content.

This matters even when the columns *look* exactly like DIM material (stable,
descriptive, classification-shaped) — attribute stability and identity
stability are two different things, and DIM/SCD2 needs both:

- **SCD2 requires distinguishing "same entity, changed attribute" from "new
  entity appeared."** That distinction is only possible if the row's identity
  key is independent of the mutable attribute values.
- **When there is no declared CDC key**, the backup approach is to hash the
  row's own content into a synthetic key (`STANDARD_HASH(...)` over the
  non-CLOB columns, per `Trường CLOB` in the same DS_BANG sheet telling you
  which columns to exclude from the hash). But then the "key" *is* the
  attributes — any legitimate content change (a re-appraisal, a typo fix)
  silently produces a new identity instead of a new SCD2 version of the same
  one. Splitting this into a DIM would create the illusion of trackable
  entity history while actually tracking nothing: every attribute edit
  fragments one real-world entity into multiple unrelated DIM rows.
- **Conclusion: keep it as a FACT** — a full snapshot per grain (e.g. per
  `DAYID`), which is honest about what the source actually gives you ("what
  was observed on this day"), not "one row per entity with a durable
  identity." Reports that need current-state answers filter by `DAYID`
  directly, which reads correctly under a snapshot-per-day design without
  needing entity continuity across days.

**Confirmed case: `FCT_CLOS_COLLATERAL` / `FCT_RLOS_COLLATERAL`.** Source
`NG_SB_CLOS_COLL_CD` (and the four RLOS collateral grid tables:
`NG_SB_RLOS_COL_OTHER`, `NG_SB_RLOS_COL_REALESTATE`,
`NG_SB_RLOS_COL_TRANSPORT`, `NG_SB_RLOS_COL_VALPAPER`, plus
`NG_SB_RLOS_COLL_CERTIGRD`) all show empty `KEY CDC` in DS_BANG. Even though
columns like `CERTIFICATE_NO`, `OWNER_NAME`, `APPRAISED_VALUE`,
`COLL_MGMT_METHOD` read as classic DIM attributes, both tables stay FACT
(full daily snapshot, `COLLATERAL_BK` = content hash) rather than being split
into a `DIM_*_COLLATERAL` — documented in `hld/HLD_Table_Design.md` section
1.2.2.3.

When this pattern shows up on a new table: don't ask the user to re-derive
this reasoning from scratch — cite this confirmed case, note the DS_BANG
`KEY CDC` finding for the new table's source(s), and propose FACT directly;
confirm only if the specific table has some other identity anchor DS_BANG
doesn't capture (e.g. a business ID column DS_BANG's `KEY CDC` field wasn't
populated for but that the source-system metadata elsewhere confirms is
unique and stable).

## T24-sourced tables — a separate reasoning path, not STG_LOS

Some tables in this datamart (`DIM_LOS_CUSTOMER`, `DIM_LOS_DISBURSEMENT`'s
T24 dimensions, etc.) have their primary source in **T24 core banking**
(`SB_DWH.DIM_CUSTOMER`, `SB_DWH.FCT_LOAN`, `SB_DWH.DIM_LOAN`,
`SB_DWH.DIM_COMPANY`, `SB_DWH.DIM_SEAB_PRODUCTS_DE`...), read through the
`STG_DTM` vùng chìa layer — not STG_LOS. These are architecturally different
from every other table in this document:

- They don't go through LOS CDC (no A1 I/D logic), and SCD2 history (if any)
  is owned by SB_DWH already — PDTD_DTM bê 1:1, `EFF_DATE`/`EXP_DATE` carried
  through unchanged.
- **Extract docs are usually missing or incomplete for these** — there is
  often no `extract/database/<TABLE>.md` at all (T24 dimensions aren't part
  of the original merged CLOS/RLOS design docx). SRS is the *only* source of
  truth for column list AND join keys.

**Before designing any T24-sourced table (or any FCT that joins to one),
open the SRS docx's full "Business Rules" table, not just the field-list
table.** python-docx's `table.rows[i].cells[j].text` walks nested tables
inline with the surrounding cell's own text, so a plain paragraph scan (or
even iterating `doc.tables` at the top level) silently misses join
conditions when the BR authors nested a "Tên bảng | Điều kiện Join" table
inside one BR row's cell — this happened with BC10/BC11's "Các bảng sử
dụng" (BR 1.2), which is where the *actual* join keys live (e.g.
`a.CUSTOMER_SK = d.DIMENSION_KEY`, `a.CO_CODE = e.COMPANY_CODE`,
`a.SEAB_PRODUCTS_SK = f.DIMENSION_KEY` — all surrogate keys already present
on the source fact, none of them the business-key guesses that seemed
reasonable from the field-list table alone). To find it:
`cell.tables` (not `cell.text`) on each BR-table row's last column. Do this
for every T24-sourced fact before finalizing FK column descriptions — a
plausible-sounding join key description ("lookup theo LEGAL_ID+LEGAL_DOC_NAME")
can be flatly wrong if the nested BR table specifies a different, simpler
surrogate-key join that was already available on the source fact table.

**Denormalize vs. FK-only is a user call, not a default.** When a T24-sourced
fact's SRS lists several attributes that live on a separate T24 dimension
(branch name, loan value date, product name...), there are two valid designs:
keep them as physical columns on the fact (denormalized, read-optimized, but
can drift from the DIM's current SCD2 version) or drop them for an FK-only
design (always-current via join, but every report query needs the extra
join). Neither is inherently more correct — ask which the user wants before
assuming "FK implies denormalize" or "FK implies FK-only." In the confirmed
case here, the user chose full denormalization for `FCT_LOS_DISBURSEMENT`.

**"DTM chỉ đọc DWH" still holds even when the SRS narrative reads STG_LOS
directly.** SRS documents like BC10/BC11 describe the report's *actual SQL*,
which may join straight to `NG_SB_CLOS_CUST_INFO`/`NG_SB_CLOS_EXTTABLE`/etc.
— that is a description of the source system's query, not an instruction to
route PDTD_DTM through STG_LOS. When a field's SRS-described source is
STG_LOS but the datamart already has an equivalent column on an SB_DWH-layer
DIM (e.g. `CUST_GROUP`, `LOANCASEID`, `FIRST_APPROVED_WI_NAME`/`_DATE` on
`DIM_CLOS_APPLICATION`), denormalize from that DIM instead of adding a new
STG_LOS read at the PDTD_DTM layer — even though the two formulas may not
match byte-for-byte (confirm with the user whether the near-match is close
enough to treat as "the same business concept," as happened here for
`APPROVAL_WINAME_LOS`/`APPROVAL_DATE` vs. `FIRST_APPROVED_WI_NAME`/`_DATE`
— MIN vs. "smallest"/MAX, accepted as equivalent by explicit user decision).
Only add a genuinely new STG_LOS-sourced column to an SB_DWH DIM (as was
done for `DIM_RLOS_APPLICATION.LAST_APPROVAL_DATE`) when no equivalent
column exists anywhere in the datamart yet — never read STG_LOS directly at
PDTD_DTM as a shortcut.

## Red flag — DIM sourced from an application-scoped table, not a true master

Step 1 of the DIM chain asks "which STG_LOS table(s) describe this one
business entity" — but check *what kind of grain* each source table actually
has, not just that a plausible-looking source exists. This red flag is
broader than just event/log tables (entry-exit history, transaction logs) —
it also covers **application-scoped snapshot/master tables** whose grain is
"1 dòng = 1 hồ sơ (hoặc 1 phiên bản hồ sơ)", not "1 dòng = 1 thực thể danh
mục". A table named `..._EXTTABLE` or `..._CUST_INFO` can *sound* like a
master table but still be application-scoped underneath — check the grain,
not the name.

**Three confirmed cases so far, all worth knowing in detail:**

- **`DIM_LOS_USER`** (pure event/log case): only source is
  `NG_SB_CLOS_ENTRY_EXIT`/`NG_SB_RLOS_ENTRY_EXIT` (workflow step logs, grain
  = 1 sự kiện xử lý). The DIM can only ever contain usernames of staff who
  happened to process at least one application — it can't reflect staff who
  haven't processed anything yet, nor current employment status (resigned,
  transferred).
- **`DIM_CLOS_PRODUCT` / `DIM_RLOS_PRODUCT`** (application-scoped-table
  case — subtler, don't miss it just because the table names look
  master-ish): sources are `NG_SB_CLOS_CUST_INFO`, `NG_SB_CLOS_EXTTABLE`,
  `NG_SB_RLOS_APPLICANT_GENERAL`, `NG_SB_RLOS_EXTTABLE` — every one of these
  is grain-per-application (per the source-system metadata's own "Vai trò"
  description: `NG_SB_CLOS_CUST_INFO` is "thông tin tổng quan của hồ sơ
  CLOS", `NG_SB_CLOS_EXTTABLE` is "bức tranh tổng quan hiện tại của 1 hồ
  sơ"), not a product catalog. The only genuinely catalog-shaped source is
  `NG_SB_CLOS_MAS_PRO_LINE` (MAS = master) — and that one isn't even in the
  CLOS metadata's Column/Table Review yet (one of the 6 tables flagged
  unreviewed in `output/Table_Split_Proposal_CLOS_RLOS.md`'s Phụ lục), so
  even the one plausible master source is itself unverified. The practical
  consequence: this "product dimension" is really *the distinct set of
  product attribute combinations observed on applications so far* — a
  product with zero applications to date won't appear as a row, and there's
  no confirmed source for product-level attributes beyond what a few
  application-scoped tables happen to repeat per row (line code, sub-product
  code, product name).
- **`DIM_CLOS_WORKSTEP` / `DIM_RLOS_WORKSTEP`** (event-log case with a
  twist — the "true master" isn't a database table at all): only source is
  `NG_SB_CLOS_ENTRY_EXIT`/`NG_SB_RLOS_ENTRY_EXIT` (workflow event log, grain
  = 1 lần hồ sơ đi qua 1 bước), same shape as `DIM_LOS_USER`. But unlike
  `USERNAME`, the real master for `WORKSTEP_CODE` is **hardcoded BPM engine
  configuration** (the ~35 step names are wired into the BPM
  process/workflow definition, not stored as rows in any queryable STG_LOS
  table) — confirmed with the user, not assumed. This changes what
  "resolve the PENDING" means: there is no `NG_SB_..._MAS_WORKSTEP` table to
  go find, and asking DE to "review a master table" (the framing that
  worked for `DIM_LOS_USER`/`DIM_*_PRODUCT`) is the wrong ask here. The
  right ask is narrower — confirm whether the set of `WORKSTEP_CODE` values
  *observed so far* in ENTRY_EXIT already covers the full BPM-configured
  step list, or whether some configured steps have simply never been hit by
  a real application yet (same risk shape as the other two cases: an entity
  with zero occurrences to date won't appear as a row) — and that a step
  code is not renamed/reused for a different meaning at the BPM config
  level without ENTRY_EXIT reflecting it. Also worth separating from this
  DIM's own PENDING: `WFINSTRUMENTTABLE` (the live workflow-instance-state
  table, holding `PROCESSNAME`/`ACTIVITYNAME`) is a real STG_LOS table, but
  it is not loaded into `DIM_CLOS_WORKSTEP`/`DIM_RLOS_WORKSTEP` at all — it
  is only used downstream, at FCT design time, to cross-check which step an
  application is *currently* sitting in (e.g. the `WORKSTEP_FLAG` /
  ex-"BC4.FLAG" derivation on `FCT_*_APPLICATION_DAILY`). Don't fold that
  gap into the DIM's PENDING note — it belongs to the FCT design instead
  (see the FACT reasoning chain below and this table's own "Where to stop
  and ask" entry once that FCT is designed), since no DIM here claims to
  supply `PROCESSNAME`/`ACTIVITYNAME`.

**The generalizable test:** for each source table feeding a DIM, ask "does
one row of this table represent one instance of the *dimension entity*
(user, product, org unit...), or one instance of something else (an
application, an event) that merely *carries a reference to* the dimension
entity as one of its columns?" If every source is the latter, the DIM is
this pattern — regardless of whether the source is an event log or an
application snapshot table.

### Resolution — a manually-maintained `MAP_` seed table at STG_LOS

For all three confirmed cases (`DIM_LOS_USER`, `DIM_CLOS_PRODUCT`/
`DIM_RLOS_PRODUCT`, `DIM_CLOS_WORKSTEP`/`DIM_RLOS_WORKSTEP`), the user
decided on a standing architectural fix rather than leaving the DIM to be
inferred from application-scoped data indefinitely: introduce a **manually
maintained seed table at the STG_LOS layer** that becomes the *only* source
SB_DWH reads for that DIM, replacing the old application-scoped inference
entirely (SB_DWH no longer reads `ENTRY_EXIT`/`EXTTABLE`/`CUST_INFO`/etc. to
build these three DIMs — those source tables stay in the lineage only for
whatever FCTs still legitimately need them, e.g. `ENTRY_EXIT` still feeds
`FCT_*_APPLICATION_DAILY`).

- **Naming:** `MAP_<hệ>_<thực_thể>` — `MAP_LOS_USER` (shared, since
  `DIM_LOS_USER` is a CHUNG table), `MAP_CLOS_PRODUCT` / `MAP_RLOS_PRODUCT`,
  `MAP_CLOS_WORKSTEP` / `MAP_RLOS_WORKSTEP` — one seed table per split DIM,
  not merged across CLOS/RLOS (confirmed with the user: keep them split the
  same way the DIMs are split).
- **Layer:** STG_LOS — architecturally this is an input source like any
  `NG_SB_CLOS_*`/`NG_SB_RLOS_*` table, just manually populated instead of
  CDC-replicated from an OLTP system. Keeping it at STG_LOS (not SB_DWH, not
  PDTD_DTM) means the existing DIM reasoning chain step 5 still applies
  unchanged — **PDTD_DTM keeps copying 1:1 from SB_DWH, same
  `DIMENSION_KEY`, no special-casing** for these three DIMs. (An earlier
  draft of this decision briefly considered seeding PDTD_DTM directly and
  giving these DIMs their own independent key sequence there — the user
  corrected this back to "seed belongs at STG_LOS, everything downstream of
  it stays exactly as it already works for every other DIM.")
- **Column shape:** every column the DIM itself needs (its full business
  attribute set, decided the normal way — see the column-optimization rule
  and the mandatory SRS cross-check, not "whatever the old application-
  scoped source happened to carry"), plus exactly one extra column:
  `EFF_DATE` — the date the change actually takes effect, entered directly
  by whoever edits the seed row (ops/nghiệp vụ types the real effective
  date of their edit; this is **not** an ETL-computed `:P_DATE` load
  timestamp the way `EFF_DATE` is computed on every other STG→SB_DWH SCD2
  load). Do **not** add a separate `UPDATED_BY`-less audit trail beyond
  this — `EFF_DATE` is the only extra technical column besides whichever
  attribute columns the DIM already needs.

  Correction on this table's own audit column: the user's original request
  named it loosely as "USER (người sửa)" — settled name is `UPDATED_BY`
  (clearer than a bare `USER`, avoids confusion with the *business* concept
  of "user" that `DIM_LOS_USER` itself represents). `UPDATED_BY` is
  descriptive metadata only — it does not participate in the SCD2 key
  comparison or in any DIM column.
- **SCD2 load rule from seed → DIM (standard, not invented):** exactly the
  same SCD2 machinery already used everywhere else in this HLD — compare
  the seed row's business-key + attribute values against the DIM's
  currently-effective row for that key; if unchanged, do nothing; if
  changed (or a new key first appears), close the old version at
  `EFF_DATE - 1 second` and open a new one at the seed row's `EFF_DATE`,
  `DIMENSION_KEY` generated once per new key via the normal Oracle sequence
  and never re-sequenced. No new SCD2 concept is introduced — only the
  *source* changes from "inferred from an application-scoped table" to
  "explicitly declared by a human in a seed row".
- **No merge/fallback with the old application-scoped sources:** the user
  explicitly rejected blending — "sẽ không có luồng tổng hợp từ nguồn, lấy
  hoàn toàn từ danh sách thủ công." The DIM is populated **only** from the
  `MAP_` seed table. If a value hasn't been declared in the seed table yet,
  it simply doesn't exist in the DIM yet (same "must declare before it
  appears" tradeoff the pattern already had — the fix moves *who* declares
  it from "an application that happens to reference it" to "a human who
  explicitly seeds it", it doesn't remove the need to declare something
  before it's usable).

When this pattern shows up on a **new, not-yet-designed** table going
forward:

1. **Stop and confirm with the user whether the same `MAP_` seed fix
   applies here too** before finalizing — don't assume every future
   occurrence automatically gets this treatment without asking, but also
   don't default back to the old "PENDING, ask BA about a possible missing
   master table" framing without first checking whether the seed-table
   pattern is the intended standing fix (the answer will very likely be
   yes, given the user settled this as the general resolution across all
   three confirmed cases, but confirm rather than assume for a case with
   different shape).
2. **Decide the seed table's column set from report demand, not from the
   old source's richness.** Cross-check every report field that plausibly
   touches this entity (the mandatory SRS cross-check step in SKILL.md —
   same pass, not separate). Don't invent extra columns beyond what reports
   need; don't drop a column a report genuinely needs just because the old
   application-scoped source happened not to carry it well.
3. **Design the `MAP_<hệ>_<entity>` table explicitly.** In Section 1, it
   still appears as its own STG_LOS-layer source node inside the DIM's own
   lineage diagram (feeding the DIM the normal solid-arrow SCD2 way, since
   it's now a confirmed, non-tentative source — no more dashed PENDING
   arrows for this DIM once the seed table replaces the application-scoped
   inference). In Section 2, its column list (DIM's attributes + `EFF_DATE`
   + `UPDATED_BY`) does **not** get nested inside the DIM's own subsection —
   all `MAP_` tables are collected together under a dedicated
   `### 3. STG_LOS (MAP)` layer at the end of Section 2 (sibling to
   `### 1. SB_DWH` / `### 2. PDTD_DTM`, numbered `3.1`, `3.2`... in the
   order each `MAP_` table was designed). The DIM's own Section 2 entry
   keeps only a one-line pointer back to that subsection (e.g. "**Nguồn:**
   `MAP_CLOS_PRODUCT` ... — xem cấu trúc cột đầy đủ và quy tắc nạp SB_DWH
   tại Section 2 → 3. STG_LOS (MAP) → 3.x MAP_CLOS_PRODUCT."), never the
   full column table inline. See `references/output-format.md`'s "STG_LOS
   (MAP) layer" section for the exact shape.
4. **Log the architectural change in Section 3** if this is the first time
   applying the fix to a given DIM (transitioning it from "PENDING —
   application-scoped source" to "resolved via `MAP_` seed table") — mark
   that Section 3 row `ĐÃ GIẢI QUYẾT` once the seed table is in place,
   don't leave it as an open PENDING once the standing fix is applied.
5. **Don't fold a downstream FCT's data gap into this DIM's PENDING/seed
   design.** `WFINSTRUMENTTABLE` (live workflow-instance state:
   `PROCESSNAME`, `ACTIVITYNAME`) is a real STG_LOS table that is genuinely
   absent from the datamart today — but it was never claimed as a source
   for `DIM_*_WORKSTEP` in the first place (nor does the `MAP_CLOS_WORKSTEP`/
   `MAP_RLOS_WORKSTEP` seed table need it), so its absence is not part of
   this DIM's concern at all. It matters at FCT design time instead,
   wherever a report needs an application's *current* step cross-checked
   against the live workflow engine (e.g. the `WORKSTEP_FLAG` derivation on
   `FCT_*_APPLICATION_DAILY`, formerly referred to as "BC4.FLAG" — rename
   any such column away from a bare `FLAG` to something that names what it
   flags). Log that gap in Section 3 against the FCT, not against the DIM.

## FACT reasoning chain

> Xuất phát từ (các) bảng nguồn trên LOS cùng mô tả 1 đối tượng nghiệp vụ
> phát sinh theo giao dịch/thời gian → hợp nhất thành 1 fact duy nhất ở tầng
> SB_DWH (`FCT_LOS_*`) → xem grain có ổn định, có phải chốt lại thành "1 dòng
> = ?" rõ ràng hay không → nếu đúng, kết luận tạo FACT, và PDTD_DTM bê nguyên
> 1-1 từ FCT_LOS tương ứng.

Steps to work through explicitly for every FACT:

1. **Identify the source tables**, same as DIM step 1, but here they
   describe something that happens over time / per transaction (a workflow
   step event, a daily snapshot, a collateral record tied to an application).
2. **State the grain explicitly** as "1 dòng = ..." — copy or restate the
   grain line from `extract/SB_DWH/<TABLE>.md` if present, or derive it from
   the PK columns if not stated. If the grain isn't stable (adding one more
   source system column would change what "1 row" means), that's a signal
   the fact is mis-designed — flag and ask.
3. **Only then conclude FACT**, with the PK as whatever natural/business key
   columns make the grain unique (`DAYID + WI_NAME` for a daily snapshot,
   `DAYID + WI_NAME + WORKSTEP_CODE + ENTRYDATE` for an event fact, etc.) —
   FACT tables don't get a `DIMENSION_KEY`; they carry `*_SK` foreign keys to
   their DIMs instead.
4. **PDTD_DTM copies 1:1 from the SB_DWH `FCT_LOS_*`/`FCT_CLOS_*`/
   `FCT_RLOS_*` counterpart**, same grain and same PK, then may LEFT JOIN
   `REF_` tables and/or T24 data to add report-facing computed columns
   (e.g. the SLA_* commitment columns joined from `RLOS_REF_SLA_TDKHCN` /
   `CLOS_REF_SLA_TDKHDNL`, or `ZONE` from `TMP_REF_COMPANY_REGION_*`).

## Naming derived columns clearly

When a report field name from the SRS is generic on its own (e.g. plain
`FLAG`, `STATUS`, `TYPE`), don't carry that bare name onto the datamart
column — name it after what it actually flags/holds (e.g. `WORKSTEP_FLAG`
for a column stating an application's current-step status, not `FLAG`).
The SRS field name is a report-local label; the datamart column has to read
clearly on its own next to every other column on the same table. This came
up for the `FCT_*_APPLICATION_DAILY` column that will implement BC4's
`FLAG` field (current-step status derived from `WFINSTRUMENTTABLE` +
`LAST_WORKSTEP_SK`/`LAST_DECISION_SK`) — design it as `WORKSTEP_FLAG` (or
similarly descriptive), not `FLAG`, when that FCT is designed.

## Column-optimization rule (storage)

For every column in the old merged table, check whether the source lineage
(`extract/SB_DWH/<TABLE>.md`'s per-column "Bảng nguồn" / "Nguồn" field, or the
column's own Mô tả text) shows it is **only ever populated from one system's
source tables**. If so:

- **Drop the column entirely** from the split table belonging to the *other*
  system — don't keep it as an always-NULL column "just in case". Storage
  and mapping-maintenance cost of a column that's structurally always NULL
  outweighs the convenience of a uniform column list across CLOS/RLOS.
- **Keep the column** only in the split table for the system whose source
  tables actually populate it.
- If a column is populated by both systems but from *different* source
  tables with the *same business meaning* (e.g. `COMPANY_CODE` from
  `NG_SB_CLOS_CUST_INFO` for CLOS rows and from
  `NG_SB_RLOS_APPLICANT_GENERAL` for RLOS rows, inside a table the split
  proposal already marked CHUNG/shared) — this is the shared-dimension case,
  not a candidate for dropping; keep it once, and note both source tables in
  the lineage.
- When genuinely unsure whether a column is single-system or shared, ask
  (see SKILL.md) rather than guessing either direction.

## Key rules quick reference

- **DIM**: `DIMENSION_KEY` (Oracle sequence at SB_DWH; carried over unchanged
  at PDTD_DTM, never re-sequenced) is PK. A `<ENTITY>_SK` column duplicates
  `DIMENSION_KEY`'s value on the same row (naming convention already in the
  source docs — keep it, don't drop it as "redundant", it's what FACT tables
  join against). The natural key (NK) is called out in the source lineage
  doc's "Khóa" line — carry that NK annotation into the design table's Khóa
  column too, not just PK.
- **FACT**: PK is a composite of grain-defining columns (never
  `DIMENSION_KEY`). `*_SK` columns are FKs to DIM tables, defaulting to `-1`
  (the DIM's Unknown row) when no match is found — state this in the
  column's Mô tả if the old lineage doc says so.
