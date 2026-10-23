# Rules — phase 1: CLOS/RLOS → SB_DWH

Produces `mapping/SB_DWH/Mapping_<TABLE_NAME>.xlsx` for a table that has a
file in `lld/sb_dwh/SB_DWH_<TABLE>.csv`, in the exact layout of the sample
templates in `references/` (2 sheets: `Mapping`, `Variable`).

This phase used to require deep CLOS/RLOS source-system analysis from raw
docx/xlsx extracts. That analysis has already been done — the LLD CSV is
its finished output, one row per target column, with the real SQL already
written (driving table, JOIN clauses, derived-value expressions). This
phase is now a **reshape**: read the LLD, decide `item_name` per column
(the one thing the CSV doesn't carry), and place everything into the
template's cell layout — it is not re-deriving mapping logic from scratch.

## Inputs you read (never write to these)

- `lld/sb_dwh/SB_DWH_<TABLE>.csv` — the only input needed. 11 columns:
  `target_table, target_column, nullable, data_type, key, description,
  etl_logic, etl_logic_type, source_table, source_column, note`. This is
  the source of truth for everything in the output except `Item Name`:
  - `data_type` → `Column type` directly (already a short form like
    `string(100)`, `number`, `date` — use it as-is, don't expand/reformat
    to Oracle syntax).
  - `key` → `PK`, `NK`, or blank. Carried into the output as `is_key`
    (kept for traceability only — no longer rendered as red font; see "Row
    3"/"Row 4" below for where PK/NK actually surface). `PK` also drives
    `primary_key` in the header block, `NK` drives `business_key`.
  - `etl_logic_type` → which shape the mapping cell and any
    JOIN/notes/description entries take (see below): `direct`, `join`,
    `generated`, `scd2`, `computed`, `pending`.
  - `source_table` / `source_column` → which physical table(s) this column
    reads from. Each distinct source table gets a short alias (`A`, `B`,
    `C`...) — see "Aliasing" below.
  - `note` → background/justification text. See "Handling `note`" below
    for what carries into `Description` vs. what to drop.
- `references/Mapping_DIM_LOAN_template.xlsx` (for DIM tables) or
  `references/Mapping_FCT_LOAN_template .xlsx` (for FCT tables, mind the
  trailing space before `.xlsx` in that filename) — layout reference. Open
  it read-only with openpyxl to see exact structure if needed; do not
  modify it.

You do **not** read `extract/SB_DWH/<TABLE>.md` or `extract/database/<TABLE>.md`
for this phase anymore — the LLD CSV supersedes both (it already carries
the resolved lineage that `extract/SB_DWH/` held, and the schema facts
`extract/database/` held).

## Aliasing

The LLD's `etl_logic` writes every formula and JOIN clause using full table
names (e.g. `NG_SB_CLOS_APPROVAL.STREAM`, `LEFT JOIN NG_SB_CLOS_APPROVAL ON
NG_SB_CLOS_APPROVAL.WI_NAME = NG_SB_CLOS_EXTTABLE.WI_NAME`). The output,
like the LOAN templates, aliases each distinct source table with a single
letter — `A`, `B`, `C`... — assigned **in order of first appearance** in
the LLD's rows (reading top to bottom), with the driving table (the
`source_table` behind the key column's `direct` row) always `A`. Rewrite
every mapping formula and JOIN clause to use these aliases instead of the
LLD's full table names:
- The header block's source list (rows 1-2, column E) lists each distinct
  `source_table` referenced by this table's columns, one per line, as
  `<TABLE> AS <ALIAS>` (e.g. `NG_SB_CLOS_EXTTABLE AS A`), **left-aligned**.
- Every mapping cell and JOIN clause in the output substitutes the alias
  for the full table name — e.g. `NG_SB_CLOS_APPROVAL.STREAM` becomes
  `B.STREAM` once `NG_SB_CLOS_APPROVAL` is assigned alias `B`.
- A column/table name that collides with another table's own column name
  is not a concern here — aliasing is purely textual substitution of the
  table-name prefix, never a rename of the column itself.

**Several columns JOINing the same physical table with a *different*
condition per column each time** (e.g. `FCT_CLOS_WORKSTEP_EVENT`'s
`UNDERWRITERMAKER_USERMAKE`/`UNDERWRITERCHECKER_USERMAKE`/
`APPROVAL_USERMAKE`, each originally written in the LLD as its own row
JOINing `NG_SB_CLOS_USER_MAKE_WORK_STEP` filtered to a different
`WORK_STEP` value): don't give each row's JOIN a separate alias. Collapse
them into **one JOIN, one alias**, keyed on every column the LLD's several
versions have in common (here: `WI_NAME` **and** `WORK_STEP = <driving
row's own WORKSTEP column>` — the second part is what keeps this a
same-cardinality lookup instead of a fan-out, since it pins the match to
the current event row's own step) — never just the loosest shared key
(`WI_NAME` alone), which would multiply rows whenever the joined table
has more than one entry per `WI_NAME`. Push what distinguished each
original row (the specific `WORK_STEP` value) into that column's own
mapping-cell `CASE WHEN A.<driving row's column> = '<value>' THEN
<alias>.<column> END`, not into the JOIN's `ON` clause. This differs from
the ordinary self-join case (e.g. `FCT_CLOS_LEGAL_PARTY`'s `customer_row`
alias for a different *role* on the same table) where a second alias is
correct because the two lookups are genuinely independent, not three
filtered views of the same lookup.

## One mapping column, always — never a second blank "NULL" column

The LOAN templates ship with two mapping columns (E = system 1, F = system
2) because the original LOS tables routinely blended two source systems
(CLOS + RLOS) in one target table. **That is no longer the shape of this
project's tables** — every `lld/sb_dwh/SB_DWH_<TABLE>.csv` file sources
from exactly one system. So:
- `mapping_headers` always has **exactly one entry** — never pass a second
  entry just because the template has an F column. `gen_mapping.py`
  already clears any unused trailing "How to mapping" header label when
  `mapping_headers` has fewer entries than the template ships with, so the
  F column simply disappears from the output — don't fill it with the
  literal `"NULL"` convention from the old multi-system design; that
  convention was for "system X doesn't produce this column", which can't
  happen when there's only one system to begin with.
- The single header label is chosen by the table's **driving table**'s own
  system — not by the target table's name prefix. The driving table is the
  `source_table` on the row(s) with `etl_logic_type = direct` that feed the
  table's own key column(s) (typically the first few rows, e.g. the row
  behind `DIMENSION_KEY`'s description/note, or the PK natural-key row).
  Read the system off that source table's own name:
  - A driving table named `NG_SB_CLOS_*` → `"How to mapping CLOS"`
  - A driving table named `NG_SB_RLOS_*` → `"How to mapping RLOS"`
  - Anything else (shared/unified source table not under a CLOS/RLOS
    prefix) → `"How to mapping LOS"`
  In practice this usually agrees with the target table's own
  `CLOS`/`RLOS` name segment, but don't shortcut to reading the name
  segment alone — always confirm against the actual driving table's name,
  since a table's target name doesn't always mirror its source system.

**Exception — a FCT table that UNIONs several distinct source tables into
one target row shape.** A small number of FCT LLDs (confirmed so far:
`FCT_RLOS_COLLATERAL`, which UNIONs 4 collateral-type sources —
`NG_SB_RLOS_COL_REALESTATE`/`_TRANSPORT`/`_VALPAPER`/`_OTHER`) repeat the
*same* `target_table` + PK shape (`DAYID`, `<TABLE>_BK`) once per source
table in the LLD CSV, each block driven by a different `source_table` and
sharing most — but not all — of the same target columns (a column present
in one source's block but absent from another's, e.g. `VEHICLE_TYPE`
exists only in the Transport block). This is **not** the "one mapping
column" case above — it's the LOAN templates' original two-system shape,
generalized to N systems instead of 2:
- One target row per distinct column name across all blocks (don't repeat
  a row per source) — `mapping_headers` has one entry **per source table**
  in the UNION, not one.
- Each header label names both the system and the source's own distinguishing
  segment, e.g. `"How to mapping RLOS_REALESTATE"`, `"How to mapping
  RLOS_TRANSPORT"`, `"How to mapping RLOS_VALPAPER"`, `"How to mapping
  RLOS_OTHER"` — plain `"How to mapping RLOS"` repeated four times would
  leave a reviewer unable to tell the columns apart.
- A column absent from a given source's block uses the literal `"NULL"` in
  that source's mapping cell — this is exactly the scenario the old
  multi-system `"NULL"` convention (see above) was for; it applies here
  specifically because this is the one case in the project with a genuine
  "system X doesn't produce this column" shape.
- `gen_mapping.py`'s `last_mapping_col` already grows past column F to fit
  more than 2 mapping columns, and `ensure_mapping_columns_room` gives any
  column past F the same style/width as F (every template only ships
  columns E/F pre-styled) — no template changes needed, just pass more
  entries in `sources`/`mapping_headers` and a same-length `mapping` list
  per column.
- Only split into parallel columns when the LLD itself repeats the same
  target_table+PK block per source (a real UNION) — a table that merely
  joins several tables to enrich one row (the normal `join` case) stays a
  single mapping column, aliased `A`, `B`, `C`... as usual.

## Output structure (what the template encodes)

Sheet `Mapping`:
- Row 1-2: `Table name` / `Table description` in column B, with the list
  of distinct source tables (`<TABLE> AS <ALIAS>`) stacked down column E —
  one line per source table, **left-aligned**.
- Row 3: `Primary Key` — the column name(s) with `key = PK` in the LLD
  (join multiple with `" + "`, e.g. `DAYID + CONTRACT`). This is the
  `primary_key` JSON field.
- Row 4 (DIM only): `Business Key` — the column name(s) with `key = NK`
  (natural/business key) in the LLD, same `" + "` join rule. This is the
  `business_key` JSON field — omit it entirely for FCT tables, whose
  template has no Business Key row (FCT identity is fully expressed by its
  Primary Key, typically `DAYID + <natural key>`).
- Row 4 (FCT only) / Row 5 (DIM, when present): `Tần suất chạy dữ liệu`.
  The script locates this row by its own "Primary Key"/"Business Key"/
  "Tần suất chạy dữ liệu" labels already baked into the template, not by a
  fixed row number — so DIM's extra Business Key row doesn't require any
  row-number bookkeeping on your part. For every FCT table in this
  project's `lld/sb_dwh/`, the `DAYID` row's `etl_logic` resolves to the
  plain literal `v_batch_date` (a full daily snapshot) — `frequency` is
  `"Chạy dữ liệu FULL hàng ngày"` for all of them, confirmed across the
  whole FCT set, including the one table (`FCT_CLOS_COLLATERAL`) whose
  `DAYID` row carries an extra row-level `WHERE` filter (that filter
  doesn't change the frequency, only which rows qualify — see the
  `generated`/`DAYID` rule below for where that filter itself goes).
- Header row: `Column name | Column type | Item Name | Description | How
  to mapping <SYSTEM>` — exactly one mapping column, per the rule above.
- Below that, one row per target column from the LLD, in the same order as
  the CSV: `Column name` always in the template's default (black) font —
  PK/NK are no longer marked with red font per row, since the header
  block's `Primary Key`/`Business Key` rows already declare them once.
  `Column type` from `data_type`. `Item Name` always
  filled (see below) — `scripts/validate_mapping.py` rule #13 enforces
  this. `Description` always filled too, with the LLD's full `description`
  text (plus any `[CẦN REVIEW]` caveat) — see "Item Name and Description"
  below.
- After all columns: "Điều kiện join giữa các bảng" label in column D, JOIN
  clauses one per row in column E (see "Building JOIN conditions" below).
  Omit this section entirely (`join_conditions` left out of the JSON) if
  no column in the table has `etl_logic_type = join`.
- Optional trailing "Chú ý:" row — only emitted when there's real
  table-wide note content that doesn't belong to one column (most
  table-level LLD caveats belong in a specific row's Description instead;
  reserve this for something that really applies to the whole table).

Sheet `Variable`: copy from the template unchanged unless the table has
day-over-day accumulation logic that needs a new variable — same as
before, don't invent variables that aren't needed.

## Deriving the mapping cell per `etl_logic_type`

In every case below, apply the alias substitution from "Aliasing" above
before writing the final mapping/JOIN text — the LLD's full table names
never survive unchanged into the output.

- **FCT's `DAYID` column, regardless of its `etl_logic_type`** (the LLD
  writes it as `direct` on some tables and `generated` on others, but it's
  always the same shape — a bare `v_batch_date` reference, no table name
  to alias-substitute): mapping cell is the literal `v_batch_date`,
  nothing else. **If that same row's `etl_logic` carries a `WHERE`
  clause** (e.g. `FCT_CLOS_COLLATERAL`'s `v_batch_date WHERE
  NG_SB_CLOS_COLL_CD.COLLTYPE IS NOT NULL` — a row-level business filter,
  not a date-window filter like STG_DTM/PDTD_DTM's own `table_condition`
  use): split on `WHERE` — `v_batch_date` (before `WHERE`) is still the
  `DAYID` mapping cell, and the alias-substituted filter (after `WHERE`)
  goes into the JSON's `table_condition` field (one entry per mapping
  column), which `gen_mapping.py` writes into the template's fixed "Điều
  kiện lấy dữ liệu" sub-row, in that row's own mapping column (E, F, ...)
  — never into a per-column `condition` field, and never left inline in
  the `DAYID` mapping cell itself.
- `direct` → the mapping cell is `etl_logic` with its table name replaced
  by the assigned alias (e.g. `NG_SB_CLOS_EXTTABLE.WI_NAME` → `A.WI_NAME`).
- `generated` → technical/ETL-generated value (surrogate key, FK
  self-reference, hash business key).
  - **Every `DIMENSION_KEY` row, and every `*_SK` column on a DIM table —
    no exceptions, regardless of what `etl_logic` actually
    says** (blank, `= DIMENSION_KEY (cùng dòng)`, a named
    `SEQ_x.NEXTVAL` call, or anything else): the mapping cell is always
    the fixed literal `"Sinh bằng Oracle sequence tại SB_DWH"`. This is a
    project-wide default for this phase, not a case-by-case judgment call
    — don't branch on whether the SK mirrors the PK, shares a sequence
    with another column, or has its own named sequence; all of that detail
    belongs in `description`, never in the mapping cell itself. Move
    whatever `etl_logic` originally said (the sequence name if one is
    given, which layer's change triggers a new value, "giữ nguyên khi
    không đổi", etc.) into this column's `description`, appended after the
    LLD's own `description` text, the same way the `EFF_DATE` rule above
    relocates its CDC prose. Also drop any "Mặc định -1 nếu không có giá
    trị phù hợp" note text for these specific rows — that FK-default
    caveat describes a *looked-up* FK resolving against another DIM, which
    doesn't apply to a column whose value is simply the next/current
    sequence value.
  - **`*_SK` on a FCT table is a different thing — don't apply the rule
    above to it.** On a DIM, `*_SK` is a self-generated surrogate key
    (`etl_logic_type = generated`). On a FCT, a `*_SK` column (e.g.
    `APPLICATION_SK`, `CUSTOMER_SK`, `USER_SK`) is a **FK looked up
    against another DIM's `DIMENSION_KEY`** — its `etl_logic_type` is
    `join`, not `generated`, so it never reaches this bullet in the first
    place; handle it under the `join` rule below like any other JOIN
    column. The two only share a `*_SK` naming convention, not the same
    mechanics — a FCT's `*_SK` row's `note` saying "Mặc định -1 nếu không
    khớp" is live, meaningful FK-default behavior (see the `join` rule's
    own note on this below), the opposite of the DIM case above where
    that same phrase gets dropped.
  - **Any other `generated` row that is not `DIMENSION_KEY` or a DIM's
    `*_SK` column** (e.g. a hash business key column like `*_BK`):
    mapping cell is `etl_logic` as-is, alias-substituted where it
    references a source table (e.g. `STANDARD_HASH(...)`) — unaffected by
    the rule above.
- `scd2` → `EFF_DATE`/`EXP_DATE` plumbing.
  - **`EFF_DATE` / `<LAYER>_EFF_DATE` rows**: the mapping cell is always
    just the literal `v_batch_date` — never the full CDC prose the LLD
    writes around it (e.g. `etl_logic` reading "CDC: v_batch_date khi phát
    hiện thay đổi trên NG_SB_CLOS_MAS_PRO_LINE (so sánh toàn bộ cột
    non-key với bản ghi đang hiệu lực)" still becomes mapping cell
    `v_batch_date`). **`description` is a short fixed sentence, drop the
    CDC prose entirely — don't relocate it there either.** For the
    table-level `EFF_DATE` column: exactly `"Ngày bắt đầu hiệu lực của
    phiên bản bản ghi (SCD Type 2)"`, no CDC clause appended. For a
    `<LAYER>_EFF_DATE` column in a multi-layer DIM: exactly `"Ngày bắt đầu
    hiệu lực của layer <Layer Name>"` (e.g. `"Ngày bắt đầu hiệu lực của
    layer Product Line"`), same rule — no CDC clause, no source
    table/column names, no "so sánh toàn bộ cột non-key..." explanation.
    This applies uniformly: every `EFF_DATE`-type row in this project's
    LLD resolves to `v_batch_date` at ETL time, and the CDC mechanics are
    implementation detail that doesn't belong in a human-facing
    description once the pattern is this well-established across the
    project.
  - **`EXP_DATE` / `<LAYER>_EXP_DATE` rows**: mapping cell is `etl_logic`
    as-is — almost always the literal `NULL` (current/active row), with
    the "closed by previous row's EFF_DATE - 1" mechanics living in `note`
    (already headed to `description` by the normal note-handling rule, not
    something to special-case here). This column's convention is
    unaffected by the `EFF_DATE` change above.
- `computed` → derived/business logic (equivalent to the old `PHÁI SINH`
  tag). Mapping cell is `etl_logic` as-is apart from alias substitution —
  it's already a SQL-like expression (CASE WHEN, string functions,
  literals inside a UNION branch, etc.), just carry it over; reformat only
  if the raw text has obvious transcription noise (stray line-wrap), never
  re-derive the logic itself.
- `join` → see "Building JOIN conditions" below — the mapping cell is the
  **final target expression** (the part after the last `→` in
  `etl_logic`), alias-substituted; the JOIN clause itself moves to the
  join section.
  - **FCT's standard DIM-lookup shape** — the large majority of a FCT
    table's `join` rows are a FK lookup resolving a `*_SK` column against
    another DIM's `DIMENSION_KEY` (or a DIM layer's own `*_SK`), always
    shaped `LEFT JOIN <DIM> ON <DIM>.<key> = <source>.<key> AND
    v_batch_date BETWEEN <DIM>.EFF_DATE AND NVL(<DIM>.EXP_DATE,
    v_batch_date) → <DIM>.DIMENSION_KEY`. Carry the `BETWEEN ... AND
    NVL(..., v_batch_date)` clause through alias substitution exactly as
    written — don't simplify it to a plain key-equality JOIN, and don't
    swap `v_batch_date` for another date column (every FCT table in this
    project uses `v_batch_date` here, confirmed and standardized across
    the whole `lld/sb_dwh/` set as of 2026-10 — an earlier LLD draft had a
    few tables comparing against a source row's own event-timestamp column
    or the target table's own `DAYID` instead; those were normalized back
    to `v_batch_date` for consistency, so a `BETWEEN` clause using anything
    else should be treated as a transcription error to flag, not a
    legitimate variant to preserve).
  - **Keep the row's `note` saying "Mặc định -1 nếu không khớp" (or
    equivalent wording) in `description`** for these FK-lookup `*_SK`
    rows — this is the opposite of the DIM-table `*_SK` rule above. It's
    live FK-default behavior (what the column holds when the JOIN finds no
    match), not dead text to drop; the general note-handling rule below
    would normally drop it for lacking a `⚠️`/`CẦN XÁC NHẬN` marker, but
    this specific phrase on a FCT `*_SK` row is always substantive and
    should be appended to `description` regardless.
- `pending` → the LLD's own convention for "not yet decided". Mapping cell
  is the literal string `"NULL"`. Description gets a `[CẦN REVIEW] ` prefix
  explaining what's missing — pull the reason from `note`/`description` if
  one is given, otherwise say plainly that the LLD left this column
  pending. Never invent a formula for a `pending` row.

## Building JOIN conditions

`join`-type rows in the LLD write their full logic in one `etl_logic`
string shaped like:
```
LEFT JOIN <TABLE> ON <condition> → <TABLE>.<COLUMN>
```
(occasionally chained, e.g. two `→`-separated hops for a nested lookup).
Split on `→`:
- Everything **before** the last `→` is one or more JOIN clauses — alias-
  substitute every table reference in each clause (both the table being
  joined and any table it references in its `ON` condition), then collect
  the result into `join_conditions` for this source column (list of
  strings, one clause per hop, in the order they appear). E.g.
  `LEFT JOIN NG_SB_CLOS_CUST_INFO_LEGAL ON NG_SB_CLOS_CUST_INFO_LEGAL.WI_NAME
  = NG_SB_CLOS_EXTTABLE.WI_NAME` becomes `LEFT JOIN B.WI_NAME = A.WI_NAME`
  (dropping the redundant table-name repetition the LLD's prose carries,
  matching the LOAN template's own terse `LEFT JOIN B.WI_NAME = A.WI_NAME`
  style). Several different columns in the same table often repeat the
  *same* JOIN clause (e.g. every column pulled from
  `NG_SB_CLOS_CUST_INFO_LEGAL` repeats that same JOIN) — de-duplicate
  identical clauses across columns before building the final
  `join_conditions` list, don't emit the same JOIN line once per column.
- The part **after** the last `→` is the mapping cell value for that
  column, alias-substituted (e.g. `NG_SB_CLOS_CUST_INFO_LEGAL.ID_NUMBER` →
  `B.ID_NUMBER`).

Since this phase now has exactly one mapping column, `join_conditions` is a
list with **exactly one entry**: the deduplicated list of JOIN clauses for
this table's single source system, each one rendered on its own row by
`gen_mapping.py` (never multiple clauses stacked with `\n` in one cell —
this is what `scripts/validate_mapping.py` rule #3 checks).

## Item Name and Description

The LLD's `description` field is a full sentence (e.g. "Business key — số
ĐKKD/CMND của khách hàng, định danh pháp lý ổn định, không đổi giữa các hồ
sơ khác nhau"), not the short label the template's `Item Name` column
expects. Both columns get filled, from the same source, at two different
lengths:
- `item_name` (column C) — a short Vietnamese business name (2-5 words),
  derived/condensed from the row's `description`. Never leave it blank.
- `description` (column D, the template's own `Description` column) — the
  **full, verbatim** `description` text from the LLD. Always fill it (not
  just when there's a caveat, unlike the old extract-based convention) —
  this column is now where the complete business meaning lives, not a
  "only when there's something unusual" field.

When the row's `note` contains an open caveat (see below), append it to
the end of this same `description` value — don't create a separate
field or leave `description` blank just to make room for the caveat.

`EFF_DATE`/`<LAYER>_EFF_DATE` rows are the one exception to "always use
the LLD's full `description` text" above (see the `scd2` rule above for
the mapping-cell side of this same exception): `description` is always
the short fixed sentence — `"Ngày bắt đầu hiệu lực của phiên bản bản ghi
(SCD Type 2)"` for the table-level column, `"Ngày bắt đầu hiệu lực của
layer <Layer Name>"` for a `<LAYER>_EFF_DATE` column — never the LLD's CDC
prose (which source table/columns the comparison runs against, "so sánh
toàn bộ cột non-key...", etc.), and never that prose appended after the
short sentence either. This applies consistently across every DIM in
every phase, not just this one — the CDC mechanics are the same
everywhere and don't need restating per table.

## Handling `note`

`note` mixes two kinds of content: resolved review history (dated entries
like "Review 2026-09-25: đổi NK từ WI_NAME sang ID_NUMBER", or references
to where a decision was confirmed, e.g. "Theo HLD_DIM_SB_DWH_review.md
mục...") and genuinely open caveats (marked with `⚠️`, or phrases like
`CẦN XÁC NHẬN` / `PENDING xác nhận` / `cần BA xác nhận`).
- **Open caveats** (the `⚠️`-marked kind): append to the column's
  `description` value (after the LLD's own description text) with a
  `[CẦN REVIEW] ` prefix, keeping the substance of what's unconfirmed —
  e.g. a row whose LLD `description` is "Khoảng cách địa bàn khách hàng"
  and whose `note` has "⚠️ Metadata: cần BA xác nhận đơn vị đo (nghi vấn
  km)" becomes `description: "Khoảng cách địa bàn khách hàng [CẦN REVIEW]
  Cần BA xác nhận đơn vị đo (nghi vấn km)"`.
- **Resolved history / internal cross-references**: don't append these —
  they document how the LLD reached its current state, not something the
  mapping reviewer needs to act on. Leave them out of `description`
  entirely; the LLD's own `description` field is already the right length
  for this column, no further context needed from `note` unless it's an
  open caveat.
- When in doubt whether a note is still open, check for `⚠️`, `TODO`,
  `CẦN XÁC NHẬN`, `PENDING` markers specifically — these are the LLD's own
  convention for "still open," per the project's established review
  workflow.

## Steps

1. Confirm scope with the user if not already clear: one specific table, or
   all tables in `lld/sb_dwh/`. Default to one table at a time unless the
   user explicitly asks for a batch.
2. Read `lld/sb_dwh/SB_DWH_<TABLE>.csv`.
3. Identify the driving table (the `source_table` behind the key column's
   `direct` row) and read its system off its own name (CLOS / RLOS / LOS,
   see above) — this sets the single mapping header. Assign it alias `A`.
   Walk the rest of the rows in order and assign `B`, `C`, ... to every
   other distinct `source_table` the first time it appears, building the
   header block's source list (`<TABLE> AS <ALIAS>`) as you go.
4. Walk every row and build its `columns` entry: `name`, `type` (from
   `data_type`), `is_key` (from `key`), `item_name` (condensed from
   `description`), `description` (the LLD's full `description` text plus
   any `[CẦN REVIEW]` caveat from `note`, per the rules above), and
   `mapping` (a one-element list, alias-substituted per the
   `etl_logic_type` rules above).
5. Collect and deduplicate JOIN clauses from every `join`-type row into a
   single `join_conditions` list (one element, itself a list of clauses).
   Omit the key entirely if there are no `join`-type rows.
6. Write the result as a JSON file matching the schema documented at the
   top of `scripts/gen_mapping.py` to a scratch path (the session
   scratchpad directory, not `/tmp`). `mapping_headers` has exactly one
   entry; every column's `mapping` list has exactly one entry — never pad
   to two.
   **When re-generating a table you've mapped before** (LLD updated since),
   rebuild `notes`/`[CẦN REVIEW]` flags fresh from the current LLD content
   — never reuse or copy forward a previous run's JSON.
7. Pick the template: `references/Mapping_DIM_LOAN_template.xlsx` for a DIM
   table, `references/Mapping_FCT_LOAN_template .xlsx` (mind the trailing
   space) for a FCT table.
8. Run:
   ```bash
   .venv/bin/python scripts/gen_mapping.py <scratch>/<table>.json "<template>" mapping/SB_DWH/Mapping_<TABLE>.xlsx
   ```
9. Self-check the output before reporting it as done:
   ```bash
   .venv/bin/python scripts/validate_mapping.py mapping/SB_DWH/Mapping_<TABLE>.xlsx
   ```
   This catches formatting regressions only — see the checklist at the top
   of `scripts/validate_mapping.py`. The CLOS/RLOS column-order check (rule
   #11) only triggers when both labels appear as separate headers, which
   never happens now that each table has exactly one mapping column — it
   won't false-positive. If the validator exits non-zero, the bug is
   almost always in `scripts/gen_mapping.py`'s styling/placement logic, not
   the JSON data — fix the script, regenerate, and re-validate.
10. Report to the user: output path, the validator's result, which
    columns got a `[CẦN REVIEW]` flag and why (from `pending` rows or
    `⚠️`-marked notes), and any column you could not confidently map at all.

## Notes

- `mapping/` is git-ignored (see `.gitignore`) — safe to regenerate freely.
- The script (`scripts/gen_mapping.py`) only places pre-decided strings
  into cells and preserves template styling. It does no analysis.
- `scripts/validate_mapping.py` is a formatting self-check, not a linter
  you run separately on demand — always run it on every table, every time.
- If a table's LLD doesn't fit the assumptions above (e.g. a column with an
  `etl_logic_type` not covered here, or `etl_logic` whose `→`-split doesn't
  cleanly separate JOIN clause from target expression), inspect the actual
  CSV row directly and use judgment rather than forcing it through — ask
  the user if the right structure is unclear.
