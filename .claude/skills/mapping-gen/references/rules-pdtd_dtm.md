# Rules — phase 3: STG_DTM → PDTD_DTM

Produces `mapping/PDTD_DTM/Mapping_<TABLE>.xlsx` for a table that has a
file in `lld/pdtd_dtm/PDTD_DTM_<TABLE>.csv`.

## What PDTD_DTM actually is — corrects earlier assumptions

Earlier drafts of this phase assumed PDTD_DTM reads directly from
`SB_DWH.<TABLE_LOS>` (one alias, 1:1 column copy, like phase 2) and only
covered a fixed list of 22 DIM/FCT pairs with a same-named LOS table. The
LLD data confirms neither assumption holds:

- **Every table in `lld/pdtd_dtm/*.csv` sources from `STG_DTM`**
  (`STG_DIM_*`/`STG_FCT_*`), not `SB_DWH` directly — PDTD_DTM is a
  **further aggregation layer on top of STG_DTM**. Physically this is a
  technical ETL layering choice; the data itself is still ultimately
  CLOS/RLOS in origin (plus a few REF/lookup tables that exist only at
  PDTD_DTM, and a T24 side explicitly out of scope for now — see below).
  The "How to mapping" header still names the **original** system (CLOS /
  RLOS / LOS), the same way phase 2 keeps naming CLOS/RLOS even though its
  formula points at a single SB_DWH table.
- **A PDTD_DTM table can be a straight 1:1 copy of one STG_DTM table, or
  can JOIN several STG_DTM (and REF_*) tables together** — there's no
  clean split between "simple" and "complex" tables by naming pattern.
  This file uses the **same `etl_logic_type`-driven parsing `rules-sb_dwh.md`
  uses**, not a separate "phase-2-style" vs. "phase-1-style" branch — the
  JSON naturally ends up with zero, one, or several JOIN clauses depending
  on what the table's own rows need.
- **Every file in `lld/pdtd_dtm/` gets a mapping, 1:1** — there is no
  "out of scope" table in this phase anymore (the old delta-table/pair-list
  approach is gone; the LLD already resolved every column's source,
  including the KPI/aggregation tables the old rules file deferred).

## Scope note — DIM_T24_* deferred

The 6 `DIM_T24_*` tables (`CARD`, `COMPANY`, `CUSTOMER`, `LOAN`,
`SEAB_MAIN_CARD`, `SEAB_PRODUCTS_DE`) are deliberately **left for later** —
not covered by this rules file yet. If the user asks for one of these, say
so plainly and don't attempt to invent a rule for them from the general
pattern below; ask how they want this group handled when it comes up.

## Inputs you read (never write to these)

- `lld/pdtd_dtm/PDTD_DTM_<TABLE>.csv` — the only input needed, same 11
  columns as the phase-1 CSV (`target_table, target_column, nullable,
  data_type, key, description, etl_logic, etl_logic_type, source_table,
  source_column, note`).
- `mapping/STG_DTM/Mapping_STG_<TABLE_LOS>.xlsx` — read-only, for `Item
  Name` reuse on any column shared with its STG_DTM counterpart (same
  name, same meaning) — see "Item Name and Description" below. Only
  relevant when such a phase-2 file exists for a given source table; many
  PDTD_DTM columns are new aggregations with no phase-2 equivalent to pull
  from, in which case derive `item_name` fresh the same way phase 1 does.
- `references/Mapping_DIM_LOAN_template.xlsx` (DIM) or
  `references/Mapping_FCT_LOAN_template .xlsx` (FCT, mind the trailing
  space) — same templates every phase uses.

You do **not** read `extract/database/` or any `input/*.docx` for this
phase anymore — the LLD CSV supersedes them.

## Aliasing and the mapping header

Identical convention to `rules-sb_dwh.md`: alias each distinct
`source_table` `A`, `B`, `C`... in order of first appearance, driving table
(the `source_table` behind the key column's `direct` row — typically the
single `STG_FCT_*`/`STG_DIM_*` table most columns pull from directly) is
always `A`. The single mapping header's system label is read off the
**driving table's own name**, same rule as phase 1:
- Driving table containing `CLOS` → `"How to mapping CLOS"`
- Driving table containing `RLOS` → `"How to mapping RLOS"`
- Otherwise → `"How to mapping LOS"`

A table can reference tables from more than one naming family (e.g.
`FCT_CLOS_APPLICATION` joins `Q_RLOS_REF_WORKSTEP_2SYSTEMS`, a REF_ table,
and even a `STG_DIM_CUSTOMER` T24 lookup for `T24_CUSTOMER_SK`) — this
does **not** change the header label or split it into multiple mapping
columns. The header always follows the driving table alone; every other
referenced table just becomes another lettered alias inside the same
single mapping column, exactly as phase 1 already does when a table joins
across several source tables of the same system.

## Table-wide row filter (DIM tables with EFF/EXP columns) — merge-by-key, not full reload

PDTD_DTM does not run its own SCD2 comparison against the table's current
rows — `STG_DTM` already owns SCD2 (it sets `EFF_DATE`/`EXP_DATE` when CDC
detects a change). PDTD_DTM's job is to **MERGE (UPSERT) by key** only the
rows that changed state since the previous run, confirmed against a real
ETL job's own filter:

```sql
STG_DIM_CUSTOMER.EFF_DATE = v_batch_date OR
(STG_DIM_CUSTOMER.EXP_DATE >= v_prev_date AND STG_DIM_CUSTOMER.EXP_DATE < v_batch_date)
```

— rows just opened exactly on `v_batch_date` (new version), OR rows that
expired in `(v_prev_date, v_batch_date)` (version just superseded). This is
a table-wide filter, same shape and placement as STG_DTM's own filter: it
lives in the PK row's `etl_logic` as `<PK> WHERE <filter>`, split on
`WHERE` the same way, and goes into `table_condition`, never a per-column
`condition`.

For a DIM table with several EFF/EXP layer pairs (e.g. `DIM_CLOS_PRODUCT`'s
Product Line/Sub Product, `DIM_LOS_COMPANY`'s Company/Branch/Region), apply
one such clause per layer (driving table's own alias, e.g. `A.<LAYER>_EFF_DATE`
/ `A.<LAYER>_EXP_DATE`) and OR-combine them, parenthesized per layer — same
pattern as the STG_DTM table-wide filter.

The PK column's own `mapping` value (`A.DIMENSION_KEY`, before `WHERE`) is
unaffected — `DIMENSION_KEY` is still carried over verbatim from SB_DWH via
STG_DTM (sourced from a SB_DWH sequence), never a freshly-generated PDTD_DTM
sequence.

**`extra_variables`**: every PDTD_DTM DIM mapping that carries this
table-wide filter (i.e. nearly all of them) must also declare the JSON's
`extra_variables` key so `scripts/gen_mapping.py` appends a `V_PREV_DATE`
row to the template's "Variable" sheet:
```json
"extra_variables": [["V_PREV_DATE", "DATE", "Ngày chạy dữ liệu - 1", null]]
```
Always add this row for every PDTD_DTM table in this phase, regardless of
whether that specific table's own filter happens to reference it — keeps
the Variable sheet consistent across the whole PDTD_DTM mapping set. This
is additive only (it never touches `V_DATE_BATCH` or the other existing
rows) and is a no-key-at-all no-op for STG_DTM/SB_DWH phases, which don't
set `extra_variables`.

## Deriving the mapping cell per `etl_logic_type`

- `direct` → mapping cell is `etl_logic`, alias-substituted (e.g.
  `STG_FCT_CLOS_APPLICATION.APPLICATION_SK` → `A.APPLICATION_SK`).
- `generated` / `scd2` → same as phase 1: mapping cell is `etl_logic`
  as-is, alias-substituted where it references a source table.
- `join` → the shape of `etl_logic` varies more here than in phase 1.
  Handle each shape as follows:
  1. **Has a `→` separator** (one or more JOIN clauses, then a final
     target expression) — same as phase 1: alias-substitute each clause
     before the last `→` into `join_conditions`, the part after the last
     `→` (alias-substituted) is the mapping cell. This includes chains of
     several hops (e.g. `T24_CUSTOMER_SK`'s two-hop
     `STG_DIM_CLOS_CUSTOMER` → `STG_DIM_CUSTOMER` lookup), and hops where
     the LLD itself already wrote a parenthesized sub-select with its own
     alias (e.g. `LEGAL_REPRESENTATIVE`'s `LEFT JOIN (SELECT ... GROUP BY
     ...) LP ON LP.WI_NAME = ...`) — treat that whole parenthesized
     sub-select + its own alias as one JOIN clause, don't try to simplify
     or re-derive what's inside it, just alias-substitute any outer table
     reference around it.
  2. **No `→`, but `etl_logic` is itself a complete `LEFT JOIN ... ON
     ...` clause with no target expression written out** (e.g.
     `LAST_WORKSTEP`'s `etl_logic` is only the JOIN condition) — the whole
     alias-substituted `etl_logic` becomes the (sole) JOIN clause in
     `join_conditions`, and the mapping cell is built from
     `<alias of source_table>.<source_column>` (both given on the same
     row) rather than parsed out of `etl_logic` itself.
  3. **No `LEFT JOIN`/`→` at all — a bare `<TABLE>.<COLUMN> WHERE <filter>
     [ORDER BY ... FETCH FIRST 1 ROW ONLY]` shape**, where the filter
     includes an equality back to the driving table's key (e.g. RI_USER-
     style rows: `STG_FCT_CLOS_WORKSTEP_EVENT.USERNAME WHERE
     STG_FCT_CLOS_WORKSTEP_EVENT.WORKSTEP_CODE = 'RequestInitiate' AND
     STG_FCT_CLOS_WORKSTEP_EVENT.WI_NAME = STG_FCT_CLOS_APPLICATION.WI_NAME`)
     — this is a filtered lookup, not a plain JOIN-on-key. Rewrite it as a
     JOIN against a derived sub-select, alias the sub-select with the next
     unused letter, and move the filter condition (everything in `WHERE`
     *except* the join-key equality) inside the sub-select:
     ```
     LEFT JOIN (SELECT <key column>, <value column> FROM <TABLE>
       WHERE <filter condition, minus the join-key equality>) <ALIAS>
       ON <ALIAS>.<key column> = A.<key column>
     ```
     and the mapping cell becomes `<ALIAS>.<value column>`. E.g. `RI_USER`
     becomes JOIN clause `LEFT JOIN (SELECT WI_NAME, USERNAME FROM
     STG_FCT_CLOS_WORKSTEP_EVENT WHERE WORKSTEP_CODE = 'RequestInitiate')
     B ON B.WI_NAME = A.WI_NAME` with mapping cell `B.USERNAME`. When the
     LLD's filter also carries an `ORDER BY ... FETCH FIRST 1 ROW ONLY`
     (picking one row per key out of several candidates, e.g.
     `LAST_ENTRYDATE`), carry that ordering into the sub-select as a
     `ROW_NUMBER() OVER (PARTITION BY <key column> ORDER BY ...) = 1`
     filter instead of `FETCH FIRST 1 ROW ONLY` — `FETCH FIRST` without a
     `PARTITION BY` only returns one row total, not one row per key, which
     would silently change the join's cardinality; flag this rewrite with
     `[CẦN REVIEW]` in the column's `description` so the user can confirm
     the per-key intent was preserved correctly.
- `computed` → if the expression naturally separates into JOIN
  clause(s) + target the same way a `join` row does (via `→`), handle it
  identically to the `join` cases above. Otherwise (a CASE WHEN, scalar
  subquery, or multi-table expression that doesn't cleanly separate into
  "JOIN then target" — e.g. `SLA_CREDIT_OFFICER`, `FLAG_AUTO_CANCEL`,
  `APPROVAL_TYPE`), keep the whole expression in the mapping cell,
  alias-substituting every table reference inside it; don't force it into
  the JOIN section. These tend to reference tables already aliased by
  other columns in the same file — reuse those same aliases rather than
  assigning new ones for the same table.
- `pending` → same as phase 1: mapping cell is the literal `"NULL"`,
  `description` gets a `[CẦN REVIEW] ` prefix explaining what's missing.

If a `join`/`computed` row's JOIN appears incomplete — e.g. `note`
mentions an intermediate hop that `etl_logic` itself never spells out
(this happens: `LAST_WORKSTEP`'s note describes a `WORKSTEP_DECISION_SK`
hop that isn't in its own `etl_logic`) — **don't invent the missing JOIN
clause from the note's prose**. Use exactly what `etl_logic` states, and
add a `[CẦN REVIEW]` note in `description` flagging that the JOIN chain
may be incomplete relative to what `note` describes, so the user can
confirm or fill it in during review.

## Building JOIN conditions

Same mechanics as `rules-sb_dwh.md`'s "Building JOIN conditions": collect
every JOIN clause (from any of the three `join` shapes above, or from a
`computed` row handled the same way) into `join_conditions` — a
one-element list (since there's exactly one mapping column), itself a list
of deduplicated clauses in order of first appearance, one clause per row
in the output.

## Item Name and Description

Same convention as phase 1 (see `rules-sb_dwh.md`'s "Item Name and
Description"): `item_name` (column C) is a short Vietnamese business name
condensed from the row's `description`; `description` (column D) is the
LLD's full `description` text verbatim, with any `⚠️`/open-caveat content
from `note` appended with a `[CẦN REVIEW] ` prefix (including the
"incomplete JOIN" flag from the previous section, and the sub-select
`ROW_NUMBER()` rewrite flag from case 3 above, when applicable).

When a column shares its name and meaning with a column already mapped in
`mapping/STG_DTM/Mapping_STG_<TABLE_LOS>.xlsx` (i.e. a straight carried-over
column, `etl_logic_type = direct`), you may reuse that file's `Item Name`
(column C) instead of re-deriving it, the same way phase 2 reuses phase
1's — but always still write `description` fresh from *this* table's own
LLD `description` text, since PDTD_DTM's own wording may differ slightly.
For new/aggregated columns with no STG_DTM counterpart, derive `item_name`
fresh from this table's own `description`, same as phase 1.

## Output structure

Same template layout as phase 1 — header block (rows 1-4), header row,
data rows (key column names in red per the LLD's `key` field), optional
JOIN section ("Điều kiện join giữa các bảng" in column D, one clause per
row), optional trailing "Chú ý:" row. See `rules-sb_dwh.md`'s "Output
structure" for the full breakdown — it applies unchanged here.

- `table_name`: the LLD's own `target_table` value — already the real
  PDTD_DTM target name (e.g. `DIM_CLOS_APPLICATION`, `AGG_LOS_KPI_APPLICATION`,
  not a `DIM_PDTD_*`-prefixed name; that naming pattern doesn't exist in
  this project's actual PDTD_DTM schema).
- `table_description`: state that it's sourced from STG_DTM (name the
  specific driving table), briefly noting it's an aggregation/relay layer
  on top of STG_DTM.

## Steps

1. Confirm scope with the user if not already clear: one specific table, or
   all tables in `lld/pdtd_dtm/` (excluding the deferred `DIM_T24_*` group —
   see Scope note). Default to one table at a time unless the user
   explicitly asks for a batch.
2. Read `lld/pdtd_dtm/PDTD_DTM_<TABLE>.csv`. If any row's `source_table`
   has a phase-2 output (`mapping/STG_DTM/Mapping_STG_<SOURCE>.xlsx`),
   read that file's column C for potential `Item Name` reuse on `direct`
   rows.
3. Identify the driving table and assign aliases `A`, `B`, `C`... in order
   of first appearance, per "Aliasing" above.
4. Walk every row and build its `columns` entry: `name`, `type` (from
   `data_type`), `is_key` (from `key`), `item_name`, `description` (full
   LLD text + any `[CẦN REVIEW]` flags), and `mapping`, applying the
   `etl_logic_type` rules above — including the sub-select rewrite for
   WHERE-filtered lookups, and the "no `→`" JOIN-only case.
5. Collect and deduplicate JOIN clauses into a single `join_conditions`
   entry. Omit the key entirely if the table has no `join`/JOIN-shaped
   `computed` rows at all (a pure 1:1 relay table, same as phase 2's
   shape).
6. Write the result as a JSON file matching `scripts/gen_mapping.py`'s
   schema to a scratch path. `mapping_headers` has exactly one entry;
   every column's `mapping` list has exactly one entry.
   **When re-generating a table you've mapped before**, rebuild
   `notes`/`[CẦN REVIEW]` flags fresh from the current LLD — never reuse a
   previous run's JSON.
7. Pick the template: DIM or FCT per the table's own prefix (note some
   PDTD_DTM tables, like `AGG_LOS_KPI_*`, aren't literally named
   `DIM_`/`FCT_` — pick by shape: a daily/grain fact table uses the FCT
   template, a reference/dimension-shaped table uses the DIM template; ask
   the user if genuinely unclear for a specific table).
8. Run:
   ```bash
   .venv/bin/python scripts/gen_mapping.py <scratch>/<table>.json "<template>" mapping/PDTD_DTM/Mapping_<TABLE>.xlsx
   ```
9. Self-check:
   ```bash
   .venv/bin/python scripts/validate_mapping.py mapping/PDTD_DTM/Mapping_<TABLE>.xlsx
   ```
   If it exits non-zero, fix `scripts/gen_mapping.py` — do not hand-edit
   the output file.
10. Report to the user: output path, validator result, every
    `[CẦN REVIEW]` flag and why (pending rows, incomplete JOINs flagged
    from `note` mismatches, `ROW_NUMBER()` rewrites from `FETCH FIRST 1
    ROW ONLY`), and any column you could not confidently map at all.

## Notes

- `mapping/` is git-ignored — safe to regenerate freely.
- The script (`scripts/gen_mapping.py`) only places pre-decided strings
  into cells and preserves template styling. It does no analysis.
- If a table's LLD has a row shape not covered above (e.g. a `join`/
  `computed` expression that doesn't fit any of the three documented
  shapes, or references a table from the deferred `DIM_T24_*` group),
  don't force it through — inspect the actual row and use judgment, or
  ask the user.
