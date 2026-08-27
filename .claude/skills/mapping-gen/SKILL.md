---
name: mapping-gen
description: Generate a mapping Excel file (mapping/Mapping_<TABLE>.xlsx) for one DIM/FCT table in the LOS datamart, following the format of references/Mapping_*_template.xlsx. Use when the user asks to gen/generate/create mapping for a specific table, or for all tables.
---

# Generate mapping Excel

Produces `mapping/Mapping_<TABLE_NAME>.xlsx` for a table listed in
`extract/datamart/_index.json`, in the exact layout of the sample templates
in `references/` (2 sheets: `Mapping`, `Variable`).

This skill covers **one table per run** unless the user explicitly asks for
all tables — always confirm scope if it's ambiguous (see Steps).

## Inputs you read (never write to these)

- `extract/database/<TABLE>.md` — official target schema: column name, Oracle
  type, nullability, size, PK marker. This is the source of truth for
  `Column type` in the output.
- `extract/datamart/<TABLE>.md` — per-column lineage/business logic. Its
  header metadata block gives the table's own natural key (`Khóa:` line,
  e.g. `DIMENSION_KEY (sequence). NK = WI_NAME`) and the full list of CDC
  source tables feeding it (`Nguồn:` line) — use these to work out JOIN
  aliases, you don't need to cross-reference another sheet. The column
  table itself carries, per column: `Bảng nguồn` / `Cột nguồn` (the actual
  source table+column), `TRẠNG THÁI THIẾT KẾ` (`DA_CHOT` = confirmed,
  anything else, e.g. `CẦN XÁC NHẬN`, = not yet confirmed — flag anything
  you infer from a non-`DA_CHOT` row, see below), and `Mô tả`, which follows
  one of three tags:
  - `1:1 —` straight copy from a source column, may list **two sources
    separated by `/`** when CLOS and RLOS both feed the same target column
    (e.g. `NG_SB_RLOS_APPLICANT_GENERAL.WI_NAME / NG_SB_CLOS_CUST_INFO.WI_NAME`).
  - `PHÁI SINH —` derived value, description contains the transform logic in
    prose or pseudo-CASE-WHEN — translate it into a SQL-like expression.
  - `KỸ THUẬT —` technical/ETL-generated column (surrogate key, FK lookup to
    another DIM, EFF_DATE/EXP_DATE) — usually not tied to one specific
    source system.
  Everything needed to generate a mapping lives inside this one file per
  table — there is no separate overview/reference file to cross-check
  (`extract/datamart/` only ever contains real table files; non-table
  reference sheets from the xlsx are filtered out at extraction time, see
  `mapping-extract-input`).
- `references/Mapping_DIM_LOAN_template.xlsx` (for DIM tables) or
  `references/Mapping_FCT_LOAN_template .xlsx` (for FCT tables, note the
  trailing space before `.xlsx` in that filename) — layout reference. Open
  it read-only with openpyxl to see exact structure if needed; do not modify
  it.

## Output structure (what the template encodes)

Sheet `Mapping`:
- Row 1-4: `Table name` / `Table description` / `Key` (fixed note "Bao gồm
  các trường màu đỏ") / `Tần suất chạy dữ liệu` (FCT only) in column B, with
  the list of source tables + SQL aliases (`TABLE_NAME AS A`) stacked down
  column E (and F, G... for additional source systems) — one line per
  source table joined into that column's mapping, **left-aligned** (not
  centered) so lines of different lengths still read as one consistent
  left-anchored list.
- Header row (`Column name | Column type | Item Name | Description | How to
  mapping <SYSTEM1> | How to mapping <SYSTEM2>...`): one `How to mapping`
  column **per source system** (e.g. CLOS, RLOS) — not per CDC table. Two
  systems is the common case for LOS tables since most target tables merge
  CLOS + RLOS.
- Below that, one row per target column: `Column name` in **red font** if
  it's part of the table's key (SK/PK, or the natural key noted in
  extract/database — e.g. `DIMENSION_KEY`, or `DAYID` + business key for
  FCT), black otherwise. `Column type` copied from extract/database.
  `Description` only filled when there's a caveat worth calling out (unusual
  rule, edge case) — leave blank otherwise, don't restate the obvious.
  Occasionally a row above a column is a merged/plain note row reading
  "Điều kiện lấy dữ liệu" with the filter condition in the Description
  column — used when a column's value depends on a WHERE/filter clause.
- After all columns: a "Điều kiện join giữa các bảng" label **in column D**
  (the Description column, not column A), then the JOIN clauses between
  each system's source tables (e.g. `LEFT JOIN B.WI_NAME = A.WI_NAME`) laid
  out as **one clause per ROW, one column per source system** — clause[0]
  of every system on the first row below the label, clause[1] on the next
  row, and so on. Mirrors the FCT_LOAN template's own worked example
  (its "Điều kiện join" section spans two rows for two JOIN clauses per
  system). Never stack multiple clauses into one cell with `\n` — each
  cell holds exactly one JOIN clause. Both the label row and every
  JOIN-clause row carry the template's colored fill and cell borders —
  `gen_mapping.py` gets this by capturing the template's own styling from
  those exact rows before it wipes the sample data, not by inventing a
  color.
- Optional trailing "Chú ý:" row for free-text caveats that don't belong to
  one column — **only emitted when there is real note content** (never as
  an empty placeholder), and both the "Chú ý:" label and its content must
  be bold, with the content left-aligned and vertically centered (matching
  the template's own B72 example — `gen_mapping.py` gets this by capturing
  that row's style from the template before wiping the sample data, the
  same pattern used for the join rows). When there is more than one
  distinct point to flag, pass `notes` as a JSON list instead of one
  string — `gen_mapping.py` numbers each item "1. ", "2. ", ... on its own
  line inside the single B-column cell, **deliberately without wrap_text**
  (the user's own call: wrapping collapses numbered points into one dense
  visual block that's easy to skim past during review — leaving wrap off
  keeps each "\n"-separated point on its own legible line), so unrelated
  concerns stay visually separate instead of running together as one
  paragraph.

Sheet `Variable`: global variables referenced in mapping formulas (e.g.
`V_DATE_BATCH`, `V_IS_START_YEAR`). Only relevant for FCT tables with
day-over-day accumulation logic. If the table doesn't need any, copy the
template's Variable sheet as-is (it's harmless boilerplate) — don't invent
variables that aren't needed.

## How to derive the "How to mapping" formulas

- Determine the source systems for the table from how many distinct source
  DBs its columns cite (usually CLOS and RLOS for LOS tables). This sets
  `mapping_headers` (e.g. `["How to mapping CLOS", "How to mapping RLOS"]`)
  and the number of source columns (E, F, ...). **When both CLOS and RLOS
  are present, CLOS always goes first (column E), RLOS second (column F)**
  — this order must be identical across every table in the project so a
  reviewer scanning many files can rely on column E always being CLOS.
  Never flip it even if RLOS happens to be the "primary" or only-populated
  system for a given table — a table with only one system still keeps that
  system in its conventional slot and puts literal `"NULL"` in every cell
  of the other column, rather than dropping/reordering the header.
  `scripts/validate_mapping.py` enforces this order when both labels are
  present in the header row.
- Assign SQL aliases (A, B, C...) per system, one alias per distinct source
  table cited for that system, in the order first referenced — mirror how
  the LOAN templates alias each source table via `AS X`. List every source
  table + its alias in the header block column for that system.
- Per column, per system:
  - `1:1 —` with one source per system → `<ALIAS>.<SOURCE_COLUMN>`.
  - `1:1 —` with `A / B` sources → split on `/`, assign each half to its
    matching system's mapping column.
  - `PHÁI SINH —` → translate the described logic into a SQL-like
    expression (CASE WHEN / string functions / window functions as
    described). Keep it in the same language/register as the extract
    (Vietnamese conditions are fine, this mirrors the template's own style).
  - `KỸ THUẬT —` → sequence/lookup logic in one column if it's genuinely
    system-specific (e.g. differs by CLOS/RLOS lookup path), otherwise put
    the same value in all mapping columns, or in just the first if it's a
    single shared computation (e.g. `SEQ_xxx.NEXTVAL`, DATASOURCE literal).
  - If a system doesn't produce this column at all — no ETL logic feeds it
    from that source — set that mapping cell to the literal string `"NULL"`
    (never a blank/`null` JSON value). This is the template's own
    convention (see the LOAN template's literal `NULL` cells) and keeps
    "not applicable in this source" visually distinct from "forgot to
    fill in".
- JOIN conditions: derive from the table's own `Khóa:` line (natural key,
  e.g. `NK = WI_NAME`) plus each column's `Bảng nguồn` / `Cột nguồn` —
  e.g. a column sourced from `NG_SB_CLOS_APPROVAL` keyed by `WI_NAME`
  joins to the main entity table aliased earlier on that same key. One
  JOIN chain per system. Pass each system's chain as a **list of
  individual JOIN clauses**, one clause per source table beyond the first
  — the script renders each list entry on its own line within the cell,
  never concatenated into one run-on string.

### Flagging uncertainty

Any inference drawn from a column whose `TRẠNG THÁI THIẾT KẾ` is anything
other than `DA_CHOT` (e.g. `CẦN XÁC NHẬN`), or any derived-logic
translation you are not fully certain of, must be marked in the output so
the user can spot it during review: prefix the cell's text with
`[CẦN REVIEW] ` (kept inside the Description column when the mapping
formula itself is confident but the source key isn't, or inside the
mapping cell itself when the formula is a guess). Never silently guess and
present it as settled — the whole point of the review pass is to catch
these.

## Steps

1. Confirm scope with the user if not already clear: one specific table, or
   all tables in `extract/datamart/_index.json`. Default to one table at a
   time unless the user explicitly asks for a batch — this keeps each
   output reviewable, per the user's workflow of testing one file before
   running the rest.
2. Read `extract/database/<TABLE>.md` (official target schema) and
   `extract/datamart/<TABLE>.md` (lineage, source tables/columns, and
   confirmation status — everything needed lives in this one file, see
   above).
3. Work out the header block (sources per system + aliases), the per-column
   mapping per system, join conditions, and any Variable-sheet needs, per
   the rules above.
4. Write the result as a JSON file matching the schema documented at the top
   of `scripts/gen_mapping.py` (read that docstring for the exact field
   names) to a scratch path, e.g.
   `/tmp` is off-limits — use the session scratchpad directory instead.
   **When re-generating a table you've mapped before** (input doc updated),
   write `notes`/`[CẦN REVIEW]` flags fresh from the current extract content
   — never reuse or copy forward a previous run's JSON/notes. A caveat from
   an old run may already be resolved in the new doc (e.g. a column that
   used to have no lineage now has one); carrying it forward unchanged
   would leave a stale warning in the output about a problem that no longer
   exists. Every flag in the final output must trace to something you can
   point to in the *current* `extract/datamart/<TABLE>.md`.
5. Pick the template: `references/Mapping_DIM_LOAN_template.xlsx` for a DIM
   table, `references/Mapping_FCT_LOAN_template .xlsx` (mind the trailing
   space in the filename) for a FCT table.
6. Run:
   ```bash
   .venv/bin/python scripts/gen_mapping.py <scratch>/<table>.json "<template>" mapping/Mapping_<TABLE>.xlsx
   ```
7. Self-check the output before reporting it as done:
   ```bash
   .venv/bin/python scripts/validate_mapping.py mapping/Mapping_<TABLE>.xlsx
   ```
   This catches formatting regressions only (bold header lines, no stray
   strikethrough, multi-line JOIN cells, no blank mapping cells) — it does
   not judge business-logic correctness. If it exits non-zero, the bug is
   almost always in `scripts/gen_mapping.py`'s styling/placement logic, not
   in the JSON data — fix the script, regenerate, and re-validate before
   moving on. Never hand back a file that fails this check without saying
   so.
8. Report to the user: output path, the validator's result, which
   columns/rows got a `[CẦN REVIEW]` flag and why, and any column you could
   not confidently map at all (its mapping cells should be the literal
   `"NULL"` with a `[CẦN REVIEW]`-prefixed note in Description explaining
   why, never a fabricated formula — call this out explicitly in your
   summary).

## Notes

- `mapping/` is git-ignored (see `.gitignore`) — safe to regenerate freely.
- The script (`scripts/gen_mapping.py`) only places pre-decided strings into
  cells and preserves template styling (red key font, header fill, borders).
  It does no analysis — all mapping logic must be decided before calling it.
- `scripts/validate_mapping.py` is a formatting self-check, not a linter you
  run separately on demand — always run it as step 7 above, on every table,
  every time. It exists because past runs shipped exactly the 4 defects it
  now checks for (unbold header source lines, stray strikethrough, JOIN
  clauses collapsed onto one line, blank mapping cells) — treat any new
  formatting requirement the user raises in review the same way: encode it
  as a check in that script, don't just fix the one file by hand.
- If a table's shape doesn't fit the assumptions above (e.g. more than 2
  source systems, or a target column with no clear source at all), inspect
  the actual extract content and template layout directly rather than
  forcing it through — ask the user if the right structure is unclear.
