# Rules — phase 2: SB_DWH → STG_DTM

Produces `mapping/STG_DTM/Mapping_STG_<TABLE>.xlsx` for a table that has a
file in `lld/stg_dtm/STG_DTM_STG_<TABLE>.csv`. This is `SB_DWH.<TABLE>` →
`STG_DTM.STG_<TABLE>`, a straight 1:1 copy — no column transformation, no
JOIN between multiple source tables. The only non-trivial part is the
row-level filter each table carries on its key column (see below).

Like phase 1, this is now a **reshape** of an already-finished LLD, not an
analysis task: `lld/stg_dtm/STG_DTM_STG_<TABLE>.csv` already states every
column's source and the table's filter condition — read it and place it
into the template, following the same conventions `rules-sb_dwh.md` uses.

## Scope note

This file only covers `STG_DTM`. `PDTD_DTM` is a different phase (see
`rules-pdtd_dtm.md`) — PDTD_DTM is a further aggregation layer on top of
STG_DTM, not a 1:1 copy, and needs its own JOIN/column-matching treatment.

## Inputs you read (never write to these)

- `lld/stg_dtm/STG_DTM_STG_<TABLE>.csv` — the only input needed, same 11
  columns as the phase-1 CSV. Every row's `etl_logic_type` is `direct` and
  `source_table` is the single SB_DWH table (`SB_DWH.<TABLE>`, written in
  the LLD as the bare SB_DWH table name, e.g. `DIM_CLOS_CUSTOMER`). The PK
  row's `etl_logic` carries the table-wide filter inline (see "Table-wide
  row filter" below) — don't derive the filter from a general EXP_DATE/
  DAYID rule, read it directly off that row.
- `mapping/SB_DWH/Mapping_<TABLE>.xlsx` — the phase-1 output for this same
  table (`Mapping` sheet, column C) — read-only, for `Item Name` reuse (see
  below).
- `references/Mapping_DIM_LOAN_template.xlsx` (DIM) or
  `references/Mapping_FCT_LOAN_template .xlsx` (FCT, mind the trailing
  space) — same templates phase 1 uses.

You do **not** read `extract/database/<TABLE>.md` for this phase anymore —
the LLD CSV supersedes it.

## What's different from phase 1

- **One source table, always alias `A`.** `sources` has exactly one entry:
  column E, single line `"SB_DWH.<TABLE> AS A"` (same aliasing convention
  as phase 1 — see `rules-sb_dwh.md`'s "Aliasing" section — just with only
  one table to alias, so it's always `A`, never B/C).
- **One mapping column, labeled "How to mapping CLOS/RLOS/LOS" — matching
  phase 1's own label for this table.** Read the label phase 1 used for
  this same table (from `mapping/SB_DWH/Mapping_<TABLE>.xlsx`'s header
  row) and reuse it verbatim — `SB_DWH.<TABLE>` is the direct output of
  that phase-1 mapping, so the system label must stay identical across
  the two files for a reviewer comparing them side by side.
- **Every column mapping is `A.<COLUMN_NAME>`** — same column name on both
  sides, since STG_DTM's schema is an exact copy of SB_DWH's. There is no
  "system doesn't produce this column" case here — never use the literal
  `"NULL"` convention in this phase.
- **No JOIN section.** Omit `join_conditions` entirely — a single source
  table needs no join.
- **Table-wide row filter, read from the PK row's `etl_logic`, not
  derived.** The LLD's PK row (`DIMENSION_KEY` for DIM, `DAYID` for FCT)
  writes its `etl_logic` as `<TABLE>.<PK_COLUMN> WHERE <filter
  expression>` — e.g. `DIM_CLOS_CUSTOMER.DIMENSION_KEY WHERE
  DIM_CLOS_CUSTOMER.EXP_DATE IS NULL OR DIM_CLOS_CUSTOMER.EXP_DATE >=
  v_batch_date - 3` or `FCT_CLOS_APPLICATION.DAYID WHERE
  FCT_CLOS_APPLICATION.DAYID = v_batch_date`. Split on `WHERE`:
  - Before `WHERE` → the PK column's own mapping cell value, alias-
    substituted (e.g. `DIM_CLOS_CUSTOMER.DIMENSION_KEY` → `A.DIMENSION_KEY`).
  - After `WHERE` → the table-wide filter, alias-substituted (e.g.
    `DIM_CLOS_CUSTOMER.EXP_DATE IS NULL OR ...` → `A.EXP_DATE IS NULL OR
    ...`), goes into `gen_mapping.py`'s `table_condition` field (a
    one-element list), which writes into the template's FIXED "Điều kiện
    lấy dữ liệu" sub-row's mapping column (E). Do **not** use the
    per-column `"condition"` field for this — that inserts a new row above
    one column and writes into Description, which is for a column-specific
    caveat, not a whole-table filter. `scripts/validate_mapping.py` rule
    #12 enforces that column D of that fixed row always keeps its literal
    label, never the filter text.
  - Every other (non-PK) row's `etl_logic` is already a plain
    `<TABLE>.<COLUMN>` reference with no `WHERE` clause — alias-substitute
    and use it as-is (e.g. `DIM_CLOS_CUSTOMER.FULL_NAME` → `A.FULL_NAME`).
  - For a FCT table, also set the template's row 4 ("Tần suất chạy dữ
    liệu") from the filter — e.g. `"Chạy dữ liệu T-1 theo DAYID =
    v_batch_date"` when the filter is a DAYID equality, worded to match
    the actual filter expression rather than assumed.
  - If a specific table's PK row filter doesn't fit this `<PK> WHERE
    <condition>` shape, don't force it — read the row as given and ask the
    user how to handle it.
- **No `[CẦN REVIEW]` flags expected in the normal case** — this phase does
  no source-system inference. Still carry forward any `⚠️`/open-caveat
  content from a row's own `note`, the same way phase 1 does (see below).
- **Table naming**: `table_name` in the header block is the LLD's own
  `target_table` value (already `STG_<TABLE>`, e.g.
  `STG_DIM_CLOS_CUSTOMER`). `table_description` can reuse the SB_DWH
  table's own description (from the phase-1 file's header block) plus a
  short note that it's a 1:1 staging copy.
- **`item_name` is copied from the phase-1 file, not re-derived.**
  `mapping/SB_DWH/Mapping_<TABLE>.xlsx` (the `Mapping` sheet, column C) has
  already worked out a short Vietnamese business name for every column —
  since STG_DTM's columns are identical, reuse that value verbatim per
  column. Open the phase-1 file read-only with openpyxl to pull column C
  per row before building the JSON. `scripts/validate_mapping.py` rule #13
  rejects any blank Item Name cell.
- **`description` is copied from the LLD's own `description` field for
  this table**, same convention as phase 1 (full text, plus `[CẦN REVIEW]`
  appended if the row's `note` has an open caveat) — don't copy phase-1's
  Description column instead, since phase-1's description text was written
  for the SB_DWH table's own context and this table's LLD may word it
  slightly differently.

## Steps

1. Confirm scope with the user if not already clear: one specific table, or
   all tables in `lld/stg_dtm/`. Confirm the table's phase-1 output exists
   at `mapping/SB_DWH/Mapping_<TABLE>.xlsx` — if not, phase 1 needs to run
   first for this table (`lld/sb_dwh/SB_DWH_<TABLE>.csv` must also exist).
2. Read `lld/stg_dtm/STG_DTM_STG_<TABLE>.csv` and
   `mapping/SB_DWH/Mapping_<TABLE>.xlsx` (for `Item Name` and the mapping
   header's system label, both column-matched by row/column name).
3. Determine table type (DIM/FCT) from the table name prefix. Split the PK
   row's `etl_logic` on `WHERE` to get the PK mapping value and the
   table-wide filter text.
4. Build the JSON per `scripts/gen_mapping.py`'s docstring:
   - `table_name`: the LLD's `target_table` (already `STG_<TABLE>`)
   - `sources`: `[{"column": "E", "lines": ["SB_DWH.<TABLE> AS A"]}]`
   - `mapping_headers`: `["<same label phase-1 used for this table>"]`
   - `table_condition`: `["<alias-substituted filter text after WHERE on
     the PK row>"]`
   - `frequency` (FCT only): short text matching the actual filter
   - Every column: `mapping: ["A.<COLUMN_NAME>"]` (PK row uses the
     alias-substituted part before `WHERE`), `item_name` copied from
     phase-1's column C, `description` from the LLD's own `description`
     (+ `[CẦN REVIEW]` if applicable)
   - No `join_conditions` key
   Write it to a scratch path (session scratchpad directory, not `/tmp`).
5. Pick the template per table type (same templates as phase 1).
6. Run:
   ```bash
   .venv/bin/python scripts/gen_mapping.py <scratch>/<table>.json "<template>" mapping/STG_DTM/Mapping_STG_<TABLE>.xlsx
   ```
7. Self-check:
   ```bash
   .venv/bin/python scripts/validate_mapping.py mapping/STG_DTM/Mapping_STG_<TABLE>.xlsx
   ```
   The CLOS/RLOS column-order check only triggers when both labels appear
   as *separate* headers — a single combined label here never matches that
   pattern. Join-section checks are skip-safe when no join row exists. If
   it exits non-zero, fix `scripts/gen_mapping.py` — do not hand-edit the
   output file.
8. Report to the user: output path, validator result, the filter condition
   applied (read from the PK row, not assumed), and any column flagged
   `[CẦN REVIEW]`.

## Notes

- `mapping/` is git-ignored — safe to regenerate freely.
- Reuses `scripts/gen_mapping.py` and `scripts/validate_mapping.py`
  unchanged.
- If a table's LLD has any row with `etl_logic_type` other than `direct`,
  or a PK row whose `etl_logic` doesn't fit the `<PK> WHERE <filter>`
  shape, stop and ask the user — this phase's whole premise is that
  STG_DTM is a 1:1 copy, so a mismatch here means something about that
  table doesn't fit the assumption.
