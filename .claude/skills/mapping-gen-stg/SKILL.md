---
name: mapping-gen-stg
description: Generate a 1:1 mapping Excel file (mapping/STG_DTM/Mapping_STG_<TABLE>.xlsx) from an SB_DWH DIM/FCT table into its STG_DTM staging counterpart, following the format of references/Mapping_*_template.xlsx. Use when the user asks to gen/generate/create the STG_DTM mapping (phase 2), as opposed to the SB_DWH mapping (phase 1, see mapping-gen).
---

# Generate STG_DTM mapping (phase 2)

Produces `mapping/STG_DTM/Mapping_STG_<TABLE>.xlsx` for a table already
mapped into `SB_DWH` (i.e. one with an existing
`mapping/SB_DWH/Mapping_<TABLE>.xlsx` from the `mapping-gen` skill / listed
in `extract/database/_index.json` under the LOS section). This is **phase
2**: `SB_DWH.<TABLE>` → `STG_DTM.STG_<TABLE>`, a straight 1:1 copy — unlike
phase 1 (`mapping-gen`), there is no CLOS/RLOS source analysis, no column
transformation, and no JOIN between multiple source tables. The only
non-trivial part is the row-level filter each table type needs (see below).

This skill covers **one table per run** unless the user explicitly asks for
all tables — same default-to-one-table convention as `mapping-gen`.

## Scope note

This skill only covers `STG_DTM`. `PDTD_DTM` is a **separate, later
phase**: `extract/database/DIM_PDTD_*.md` schemas differ from their
`DIM_LOS_*.md` counterparts (different column sets/order, e.g.
`DIM_PDTD_APPLICATION` has 35 columns vs. `DIM_LOS_APPLICATION`'s 33 —
extra `BI_FLOW`, `CUSTOMER_SK`, etc.), so PDTD_DTM needs real column
matching/analysis like phase 1, not a same-schema copy. Do not use this
skill for PDTD_DTM tables — flag it back to the user if asked.

## Inputs you read (never write to these)

- `extract/database/<TABLE>.md` — the *only* input needed. It is both the
  target schema (STG_DTM's own columns are identical to SB_DWH's, since
  this is a 1:1 copy) and the schema of the single source table
  (`SB_DWH.<TABLE>`). No need to read `extract/datamart/<TABLE>.md` — no
  lineage/business-logic analysis happens at this phase, that was already
  resolved in phase 1.
- `references/Mapping_DIM_LOAN_template.xlsx` (DIM) or
  `references/Mapping_FCT_LOAN_template .xlsx` (FCT, mind the trailing
  space in the filename) — same templates phase 1 uses.

## What's different from phase 1 (`mapping-gen`)

- **One source table, one alias.** `sources` has exactly one entry: column
  E, single line `"SB_DWH.<TABLE> AS A"`. No column F/G.
- **One mapping column, labeled "How to mapping CLOS/RLOS".** Even though
  there's only one physical source table, the user wants the header kept as
  `"How to mapping CLOS/RLOS"` (not `"How to mapping SB_DWH"`) because
  `SB_DWH.<TABLE>` itself already blends CLOS+RLOS data from phase 1 — the
  label names the original systems, the formula still points at the single
  physical table. So `mapping_headers = ["How to mapping CLOS/RLOS"]`.
- **Every column mapping is `A.<COLUMN_NAME>`** — same column name on both
  sides, since STG_DTM's schema is an exact copy of SB_DWH's. Never leave a
  cell `"NULL"` here (unlike phase 1, there's no "system doesn't produce
  this column" case — the source table has every column by construction).
- **No JOIN section.** Omit `join_conditions` entirely (or leave it out of
  the JSON) — a single source table needs no join.
- **Table-wide row filter, not per-column.** Both DIM and FCT tables need a
  row-level filter that applies to the whole extract. The template has a
  FIXED sub-row right under the header, with the label "Điều kiện lấy dữ
  liệu" already sitting in column D in every template (never write to that
  cell — it's not the filter text, just the row's label). The filter
  expression itself goes into `gen_mapping.py`'s `table_condition` field
  (a list, one entry per `mapping_headers` entry — here just one), which
  the script writes into that fixed row's mapping column (E). Do **not**
  use the per-column `"condition"` field on the first column entry — that
  mechanism inserts a *new* row above one specific column and writes into
  Description (D), which is for a column-specific caveat, not a
  whole-table filter; using it here would misplace the text.
  - **DIM tables**: keep only currently-valid or recently-expired history —
    `A.EXP_DATE IS NULL OR (A.EXP_DATE IS NOT NULL AND A.EXP_DATE >= V_DATE_BATCH - 3)`.
    (Batch runs at T-1, so `V_DATE_BATCH` is already T-1; keeping 3 days of
    recently-expired rows covers late-arriving history.) Verified: every
    `DIM_LOS_*.md` table has an `EXP_DATE` column, so this filter applies
    uniformly across all 14 DIM tables — no per-table exceptions expected,
    but double check the specific table's `extract/database/<TABLE>.md`
    still has `EXP_DATE` before applying it.
  - **FCT tables**: keep only the batch day's data —
    `A.DAYID = V_DATE_BATCH`. Verified: every `FCT_LOS_*.md` table has a
    `DAYID` PK column, so this applies uniformly across all 8 FCT tables.
    Also set the template's row 4 ("Tần suất chạy dữ liệu", FCT-only field)
    to `"Chạy dữ liệu T-1 theo DAYID = V_DATE_BATCH"`.
  - `V_DATE_BATCH` is already defined in the template's `Variable` sheet
    (row 3) — don't redefine it, just reference it in the filter text and
    copy the Variable sheet across unchanged.
- **No `[CẦN REVIEW]` uncertainty flags expected in the normal case** —
  since this phase does no source-system inference, there's nothing to be
  unsure about column-by-column. Still flag anything genuinely unclear
  (e.g. a column whose EXP_DATE/DAYID filter doesn't apply for some
  table-specific reason) the same way phase 1 does, prefixed
  `[CẦN REVIEW] `.
- **Table naming**: `table_name` in the header block is `STG_<TABLE>` (e.g.
  `STG_DIM_LOS_APPLICATION`), the sheet's own displayed name — not the
  source table's name. `table_description` can reuse the SB_DWH table's own
  description (read from `mapping/SB_DWH/Mapping_<TABLE>.xlsx` header block
  if you want to match wording, or restate briefly) plus a short note that
  it's a 1:1 staging copy.
- **`item_name` must be copied from the phase-1 file, not left blank.**
  `mapping/SB_DWH/Mapping_<TABLE>.xlsx` (the `Mapping` sheet, column C) has
  already worked out a short Vietnamese business name for every column —
  since STG_DTM's columns are identical, reuse that value verbatim per
  column instead of guessing or leaving it empty. Open the phase-1 file
  read-only with openpyxl to pull column C per row before building the
  JSON.

## Steps

1. Confirm scope with the user if not already clear: one specific table
   (schema `SB_DWH.<TABLE>`), or all tables. Confirm the table actually has
   a phase-1 output in `mapping/SB_DWH/Mapping_<TABLE>.xlsx` — if not,
   phase 1 needs to run first (or at minimum `extract/database/<TABLE>.md`
   needs to exist).
2. Read `extract/database/<TABLE>.md` for the column list (name, Oracle
   type, nullability, size, PK marker).
3. Determine table type (DIM/FCT) from the table name prefix, and build the
   JSON per the schema in `scripts/gen_mapping.py`'s docstring, following
   the rules above:
   - `table_name`: `STG_<TABLE>`
   - `sources`: `[{"column": "E", "lines": ["SB_DWH.<TABLE> AS A"]}]`
   - `mapping_headers`: `["How to mapping CLOS/RLOS"]`
   - `table_condition`: `["<DIM or FCT filter text above>"]` — written into
     the template's fixed "Điều kiện lấy dữ liệu" sub-row (column E), not
     into any column's own row
   - `frequency` (FCT only): `"Chạy dữ liệu T-1 theo DAYID = V_DATE_BATCH"`
   - Every column: `mapping: ["A.<COLUMN_NAME>"]`, no per-column
     `"condition"` field (that mechanism is for a different, column-scoped
     use case — see above)
   - No `join_conditions` key
   Write it to a scratch path (session scratchpad directory, not `/tmp`).
4. Pick the template per table type (same templates as phase 1).
5. Run:
   ```bash
   .venv/bin/python scripts/gen_mapping.py <scratch>/<table>.json "<template>" mapping/STG_DTM/Mapping_STG_<TABLE>.xlsx
   ```
6. Self-check:
   ```bash
   .venv/bin/python scripts/validate_mapping.py mapping/STG_DTM/Mapping_STG_<TABLE>.xlsx
   ```
   The validator's CLOS/RLOS column-order check only triggers when both
   `"How to mapping CLOS"` and `"How to mapping RLOS"` appear as *separate*
   headers — the single combined `"How to mapping CLOS/RLOS"` label used
   here doesn't match that pattern, so it won't false-positive. The
   join-section checks are skip-safe when no join row exists (this file has
   none). If it exits non-zero, fix `scripts/gen_mapping.py` — do not
   hand-edit the output file.
7. Report to the user: output path, validator result, the filter condition
   applied (DIM EXP_DATE window or FCT DAYID), and any column flagged
   `[CẦN REVIEW]`.

## Notes

- `mapping/` is git-ignored — safe to regenerate freely.
- Reuses `scripts/gen_mapping.py` and `scripts/validate_mapping.py`
  unchanged — this skill only changes how the input JSON is assembled (no
  source-system lookup, straight column copy), not the rendering script.
- If a specific table's `extract/database/<TABLE>.md` doesn't have
  `EXP_DATE` (DIM) or `DAYID` (FCT) as expected, stop and ask the user how
  to handle that table instead of guessing a different filter column.
