# Rules — phase 3: SB_DWH → PDTD_DTM

Produces `mapping/PDTD_DTM/Mapping_<TABLE_PDTD>.xlsx` for a `DIM_PDTD_*` /
`FCT_PDTD_*` table whose schema is confirmed (via
`input/Design_Database_PDTD_DTM_v1.0.docx`) to differ from its `DIM_LOS_*` /
`FCT_LOS_*` counterpart — extra columns, dropped columns, reordered
columns, and sometimes a different composite key. Unlike phase 2
(`rules-stg_dtm.md`), this is **not** a same-schema 1:1 copy: every table
needs real column-by-column matching against the LOS counterpart, the same
way phase 1 matches target columns against source lineage.

Confirmed from the architecture diagram embedded in
`input/Design_Database_PDTD_DTM_v1.0.docx` ("Tổng quan luồng tổng hợp dữ
liệu Datamart Khối PDTD"): PDTD_DTM is always loaded via ODI from `SB_DWH`
— never directly from T24 CORE or LOS. T24 CORE data reaches SB_DWH through
its own realtime staging path (`STG_DAILY`), separate from the CDC path LOS
uses (`STG_LOS`). This confirms `SB_DWH.<TABLE_LOS>` is the right source
for the tables this file covers — but it also means SB_DWH is **broader**
than the 23 `DIM_LOS_*`/`FCT_LOS_*` tables from phase 1: some PDTD columns
may reference T24-sourced SB_DWH data this project has no extract for yet
(see Scope note below).

## Scope note — which tables this file covers

`extract/database/_index.json` lists 30 PDTD tables total. This file only
covers the **22 tables with a same-named LOS counterpart** (13 DIM + 9
FCT — see the full pair list in "Known column deltas" below). It does
**not** yet cover:

- Tables with no LOS counterpart at all: `DIM_PDTD_DATE`, `DIM_PDTD_CUSTOMER`.
- FCT tables that are clearly aggregations/computations, not lineage
  copies: `FCT_PDTD_DISBURSEMENT` (columns look T24-core-sourced —
  `SEAB_LOS_ID`, `PRODUCT_T24`, `CONTRACT`, `VALUE_DATE`, `MATURITY_DATE`),
  `FCT_PDTD_KPI_APPLICATION`, `FCT_PDTD_KPI_USER_YEAR`,
  `FCT_PDTD_KPI_YTD_DAILY`, `FCT_PDTD_APPLICATION_MILESTONE`.

If the user asks for one of these, say plainly that this rules file
doesn't cover it yet — their "Mô tả" text describes business meaning only
(e.g. "Điểm KPI quy đổi"), never a source table, formula, or aggregation
window, so mapping them needs either more source documentation (the user
has said they'll provide it) or a manual walkthrough with the user before
a rule can be written. Don't attempt to invent source logic for these.

Also note: several REF/MAP tables exist under docx section 4.5 ("Bảng map
– Datamart PDTD": `Q_RLOS_REF_WORKSTEP_2SYSTEMS`, `REF_RLOS_FLOW`,
`REF_CLOS_LEGAL`, `TMP_REF_COMPANY_REGION_KHCN`,
`TMP_REF_COMPANY_REGION_KHDN`, `RLOS_REF_SLA_TDKHCN`,
`CLOS_REF_SLA_TDKHDNL`, `CLOS_REF_SLA_TDKHDN_2`, `REF_SLA_NLTT`) — these
look like lookup tables some of the excluded FCT tables' new columns may
join against (e.g. `FCT_PDTD_SLA_DAILY`'s `SLA_*`/`QD_*` columns need an
SLA-commitment lookup keyed by `REF_PRODUCT`). Not analyzed yet; relevant
once the excluded tables above are in scope.

## Inputs you read (never write to these)

- `extract/database/<TABLE_PDTD>.md` — target schema (PDTD_DTM's own
  columns, types, PK).
- `extract/database/<TABLE_LOS>.md` — the matching LOS table (same suffix
  after `DIM_PDTD_`/`DIM_LOS_` or `FCT_PDTD_`/`FCT_LOS_`) — this is what you
  diff against, column by column, to tell which PDTD columns are shared vs.
  new (see "How to build the mapping" below). You do **not** need
  `mapping/SB_DWH/Mapping_<TABLE_LOS>.xlsx`'s actual CLOS/RLOS formulas —
  see the important correction below.
- `references/Mapping_DIM_LOAN_template.xlsx` (DIM) or
  `references/Mapping_FCT_LOAN_template .xlsx` (FCT, mind the trailing
  space) — same templates every phase uses.

**Important correction (confirmed against a real phase-1 file)**: it might
seem natural to copy phase 1's actual CLOS/RLOS mapping formulas verbatim
for shared columns, since they "already solved" the source logic. Don't —
those formulas reference the *original* CLOS/RLOS source tables directly
(e.g. `mapping/SB_DWH/Mapping_DIM_LOS_GEO.xlsx` has `F9 = 'A.CITY_CODE'`
where alias `A` is `H_NG_SB_RLOS_MAS_CITY`, a raw RLOS table). But the
architecture diagram confirms PDTD_DTM only ever reads from the
already-materialized `SB_DWH.<TABLE_LOS>` table via ODI — it has no access
to the raw CLOS/RLOS tables phase 1's formulas point at. So for every
shared column, the correct PDTD formula is the **same shape phase 2 uses**:
`A.<COLUMN_NAME>` with a single alias `A = SB_DWH.<TABLE_LOS>` — not a
copy of phase 1's multi-alias CLOS/RLOS formula. Phase 1's file is only
useful here for `item_name` (column C) and for confirming a column's
*name* truly carries over unchanged; ignore its mapping columns (E, F, ...)
entirely for this phase.

## Known column deltas (from a full diff of all 22 pairs)

Two universal patterns apply to **every** pair below, so check for them
first before treating a column as a real delta:

- **`DIMENSION_KEY` generation differs but isn't a mapping difference you
  invent**: PDTD's `extract/database/DIM_PDTD_<X>.md` always describes it
  as "giữ nguyên DIMENSION_KEY của bảng chiều tương ứng bên DWH_LOS, không
  sinh sequence mới" (vs. LOS's "sinh bằng Oracle sequence"). So the PDTD
  mapping formula for `DIMENSION_KEY` is simply `A.DIMENSION_KEY` (copy the
  LOS table's own already-generated key), never a new
  `SEQ_DIM_PDTD_<X>.NEXTVAL`.
- **Existing `_SK` columns carry over unchanged**: any `_SK` column that
  already exists in the LOS counterpart (e.g. `PRODUCT_SK`, `ORG_UNIT_SK`)
  is just `A.<SK_COLUMN_NAME>` like any other shared column — its *value*
  was already resolved when the row landed in `SB_DWH.<TABLE_LOS>`, PDTD
  just relays it. (This corrects an earlier draft of this file, which
  assumed the FK lookup itself had to be re-targeted at `DIM_PDTD_*` — it
  doesn't; only a genuinely **new** `_SK` not present in LOS needs a real
  lookup, see step 4 below.)

Pairs that are a **pure 1:1 copy** — no added/dropped columns at all, so
every column (including any `_SK`) is simply `A.<COLUMN_NAME>`:
`DIM_GEO`, `DIM_COLLATERAL`, `DIM_COLLATERAL_TYPE`, `DIM_ORG_UNIT`,
`DIM_DECISION`, `DIM_APPROVAL_GROUP`, `DIM_EXCEPTION_REASON`,
`DIM_CHANGE_TYPE`, `DIM_CARD_PROMOTION`, `FCT_COLLATERAL`,
`FCT_APPLICATION_PARTY`.

Pairs with **real added columns** (source unclear from the "Mô tả" alone —
flag `[CẦN REVIEW]`, see below) or **dropped columns**:

| Pair | Added in PDTD (flag CẦN REVIEW unless noted) | Dropped from LOS |
|---|---|---|
| DIM_APPLICATION | `BI_FLOW`; `CUSTOMER_SK` → `DIM_PDTD_CUSTOMER` (out of scope, see above) | — |
| DIM_PARTY | `CURR_FULL_ADDRESS` | — |
| DIM_PRODUCT | `IS_CREDIT_CARD`, `IS_FAST_PRODUCT` | — |
| DIM_WORKSTEP | `IS_PDTD_STEP` | `WORKSTEP_NK` (natural key — confirm with user before dropping it silently) |
| FCT_APPLICATION_DAILY | `ORG_UNIT_SK`, `PRODUCT_SK`, `APPROVAL_GROUP_SK`, `CUSTOMER_SK`* , `LAST_WORKSTEP_SK`, `LAST_WORKSTEP`, `DATE_SK`, `LOAN_AMOUNT`, `LOAN_TERM`, `INTEREST_RATE`, `TSBD_BDS`, `TSBD_PTVT`, `TSBD_GTCG` | — |
| FCT_WORKSTEP_EVENT | `CREDIT_TERM`, `BI_WORKSTEP` | — (PK narrows, see below) |
| FCT_SLA_DAILY | `PRODUCT_SK`, `ORG_UNIT_SK`, `APPROVAL_GROUP_SK`, `BI_APPSTATUS`, `DEVIATION_FLAG`, `REF_PRODUCT`, plus 16 `SLA_*`/`QD_*` columns — the largest delta of any pair, almost entirely CẦN REVIEW (see Scope note: likely needs the section-4.5 REF/MAP SLA lookup tables) | `BI_FLAG_APPROVAL` |
| FCT_PARTY_DOCUMENT | `CUSTOMER_SK`* , `LEGAL_TYPE`, `IS_PRIMARY_ID` | — |
| FCT_SUB_PRODUCT | (no new columns; only PK narrows, see below) | — |
| FCT_DEVIATION | `PROCESSED_DATE` | — |
| FCT_EXCEPTION | `PROCESSED_DATE`, `CHECK_FTR`, `FIRST_WORKSTEP_RETURN`, `LOANCASEID` | — |

\* `CUSTOMER_SK` follows the standard new-`_SK` pattern (see "How to build
the mapping" below) but targets `DIM_PDTD_CUSTOMER`, which is itself out of
scope (no LOS counterpart, no extract yet) — treat it the same as any
other CẦN REVIEW column: literal `"NULL"` mapping with a
`[CẦN REVIEW]`-prefixed note explaining the blocking dependency, not a
guessed lookup.

**Composite-key deltas — confirm with the user before finalizing, these
change what counts as a duplicate row**:
- `FCT_WORKSTEP_EVENT`: LOS's PK includes `DECISION_SK` and `USER_SK`;
  PDTD's PK drops both (PK is just the first 4 columns).
- `FCT_SUB_PRODUCT`: LOS's PK is 6 columns including `PRODUCT_SK` and
  `SYSTEM_CODE`; PDTD's PK narrows to 4 (drops both).
- `DIM_WORKSTEP`: LOS has a natural key `WORKSTEP_NK` that PDTD's schema
  doesn't carry at all.

This delta table was built by diffing all 22 `extract/database/*.md` pairs
directly — if you're working a table not listed here (shouldn't happen
given the Scope note above), or `extract/database/` has changed since,
re-derive the diff yourself rather than trusting stale numbers.

## How to build the mapping

This phase's header block/source shape is **identical to phase 2**: one
alias, `SB_DWH.<TABLE_LOS> AS A` (column E), one mapping column
`"How to mapping CLOS/RLOS"`. No multi-alias JOINs — see the correction
above for why phase 1's own multi-alias formulas don't carry over.

1. Read both `extract/database/<TABLE_PDTD>.md` and
   `extract/database/<TABLE_LOS>.md`. Confirm the pair is in scope (listed
   above) — if not, stop and tell the user why (see Scope note).
2. Read `mapping/SB_DWH/Mapping_<TABLE_LOS>.xlsx` (the `Mapping` sheet) only
   for `Item Name` (column C) per column — ignore its mapping columns
   (E, F, ...) entirely, per the correction above.
3. For every PDTD column that has the **same name** in the LOS schema:
   - `DIMENSION_KEY` → `A.DIMENSION_KEY` (see universal pattern above, not
     a new sequence).
   - Any `_SK` column that already existed in LOS → `A.<SK_COLUMN_NAME>`,
     same as any other shared column — the FK value itself doesn't change
     between SB_DWH and PDTD_DTM, only which DIM table *other* rows resolve
     it against downstream. (Don't confuse this with the brand-new `_SK`
     case in step 4, which does need a real lookup.)
   - Every other shared column → `A.<COLUMN_NAME>`.
   - `item_name` → copy from the phase-1 file's Item Name column, same as
     phase 2.
4. For every PDTD column with **no equivalent in the LOS schema** (see the
   delta table above): this is a brand-new `_SK` (follow the standard
   "Khóa tham chiếu đến bảng chiều DIM_PDTD_X. Giá trị mặc định = -1 nếu
   không có giá trị phù hợp" pattern — write a lookup formula against that
   DIM_PDTD table on its natural key, defaulting to `-1`), or it's a
   genuinely new/derived business column whose "Mô tả" only states meaning,
   not source — for the latter, **do not invent a formula**: set the
   mapping cell to the literal string `"NULL"` and add a
   `[CẦN REVIEW]`-prefixed note in Description explaining what's missing
   (source table unclear, no formula given in extract). This mirrors phase
   1's convention for "not applicable"/"can't confidently map" columns —
   never guess and present it as settled.
5. For any LOS column **dropped** in the PDTD schema (see delta table): no
   action needed in the PDTD mapping (it simply doesn't appear as a target
   column) — but if it was a natural/business key (like `DIM_WORKSTEP`'s
   `WORKSTEP_NK`), call this out explicitly in your final report so the
   user can confirm the drop was intentional.
6. If the PK/composite key differs from the LOS counterpart (see the
   composite-key deltas above), don't silently narrow or widen it in the
   template's `Key` styling — apply exactly what
   `extract/database/<TABLE_PDTD>.md` states as PK, and flag the delta
   explicitly in your report (it changes row-uniqueness semantics, worth a
   second pair of eyes).
7. No JOIN section — a single-alias source needs no join, same as phase 2.
   The only exception would be a brand-new `_SK` lookup that genuinely
   needs to join against its target DIM_PDTD table to resolve the FK; if
   that comes up, treat it the same way phase 1 treats JOINs (one clause
   per row, see `rules-sb_dwh.md`).

## Table naming and output

- `table_name` in the header block is the PDTD table's own name (e.g.
  `DIM_PDTD_GEO`) — that's already its real target name, unlike phase 2's
  `STG_` prefix.
- Output: `mapping/PDTD_DTM/Mapping_<TABLE_PDTD>.xlsx`.
- `table_description`: state it's sourced from `SB_DWH.<TABLE_LOS>` via
  ODI, briefly noting any column deltas from the LOS version (added/dropped
  columns, PK differences) so a reviewer opening the file cold has that
  context without cross-referencing this rules file.

## Steps

1. Confirm scope: one specific table (must be in the in-scope pair list
   above), or all in-scope tables. Confirm `mapping/SB_DWH/Mapping_<TABLE_LOS>.xlsx`
   exists — phase 1 must have run for the LOS counterpart first.
2. Read both extract files + the phase-1 Mapping sheet (step 2 above).
3. Build the JSON per `scripts/gen_mapping.py`'s docstring, applying the
   column-matching rules above. Write it to the scratch path.
4. Pick the template per table type (same templates as every phase).
5. Run:
   ```bash
   .venv/bin/python scripts/gen_mapping.py <scratch>/<table>.json "<template>" mapping/PDTD_DTM/Mapping_<TABLE_PDTD>.xlsx
   ```
6. Self-check:
   ```bash
   .venv/bin/python scripts/validate_mapping.py mapping/PDTD_DTM/Mapping_<TABLE_PDTD>.xlsx
   ```
7. Report to the user: output path, validator result, every added/dropped
   column and how it was handled (retargeted `_SK`, `[CẦN REVIEW]` NULL, or
   confirmed intentional drop), and any PK/composite-key delta from the LOS
   counterpart.
