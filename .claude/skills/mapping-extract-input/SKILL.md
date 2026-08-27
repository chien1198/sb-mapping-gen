---
name: mapping-extract-input
description: Convert raw docx/xlsx design docs in input/ into per-table Markdown files in extract/, to save tokens on later reads. Use when the user asks to extract, convert, or refresh extract/ from input/, or after new/updated files are uploaded to input/.
---

# Extract input documents

Converts the raw design documents in `input/` into small, per-table Markdown
files in `extract/` — one file per database table / datamart sheet — so later
steps (building mapping, answering questions about a specific table) only
need to read the one file they need instead of the full docx/xlsx.

## When to use

- User uploaded or changed a file in `input/` and wants `extract/` refreshed.
- User asks to "extract", "convert" the input docs, or mentions optimizing
  tokens when reading the design docs.

## How it works

Sources handled by `scripts/extract_input.py`:

- `input/*.docx` (database design) → `extract/database/<TABLE_NAME>.md`
  - Detected by heading pattern `"<n> Bảng <TABLE_NAME>"` (docx Heading 3)
    immediately followed by a table. Non-standard tables (revision history,
    sign-off block, glossary) are skipped automatically since they don't
    match this pattern.
  - `extract/database/_index.json` lists every table extracted: name, file,
    source section, column count.

- `input/*.xlsx` (datamart/datamodel design) → `extract/datamart/<SHEET_NAME>.md`
  - Each real table sheet has a metadata block (Loại bảng, Grain, Khóa, Bảng
    nguồn CDC, Quy tắc ghi, ...) followed by a blank row then the column
    table (`STT | Tên cột | Kiểu dữ liệu | ... | Mô tả`). The `Mô tả` column
    carries the actual transform/lineage logic (`1:1 —`, `PHÁI SINH —`,
    `KỸ THUẬT —`) — this is preserved verbatim, never summarized or cut.
  - The xlsx also mixes in reference/explainer sheets that aren't tables at
    all (design rationale, load order, business rules, glossaries — usually
    named `00_...` but not guaranteed to be). These are **skipped
    entirely**, not extracted in any form: a sheet only gets extracted if
    its name matches a table already known from the docx
    (`extract/database/_index.json`), since only the docx's table-heading
    pattern reliably identifies "this is a real table". This is a
    whitelist by table name, not by sheet-name pattern, so it keeps working
    if the doc author adds another explainer sheet under a different name
    later — no hardcoded sheet-name list to maintain. Because of this, docx
    extraction always runs before xlsx in the same invocation (see
    `main()`); don't reorder that.
  - `extract/datamart/_index.json` lists every sheet extracted: name, file,
    table type (DIM/FCT), column count.

Database and datamart are kept as **separate directories** — a table like
`DIM_LOS_APPLICATION` that exists in both sources gets two files (one per
source), not merged, since the docx only covers static schema while the
xlsx additionally covers lineage/transform logic and may cover a different
table scope (e.g. the docx also has ~40 PDTD_DTM tables the xlsx doesn't).

Temp/lock files (`~$*.xlsx`) and non-source files are ignored automatically.

## Re-running on updated input (important)

Output file names are always derived from the **table name as it appears in
the latest input document** (`slugify(table_name)`), not from any prior
extract run. This means re-running after the user uploads a revised
`input/` document is always safe and always reflects the newest content:

- **Table content changed, name unchanged** → its `.md` file is overwritten
  with the new content. No stale data left behind.
- **Table renamed or removed from the source doc** → the extractor detects
  this: any `.md` file in `extract/database/` or `extract/datamart/` whose
  name is not in the freshly extracted set gets deleted automatically
  (`clear_stale_markdown` in the script), so old/renamed tables never linger
  alongside the new ones.
- **New table added** → a new `.md` file simply appears.

So the correct flow when the user says the input document changed is just:
re-run step 2 below. Don't hand-edit files under `extract/` to patch in a
change — re-run the extractor on the updated `input/` file instead, so the
file name and content both stay derived from the source of truth.

## Steps

1. Ensure the project venv has the two required packages (only needed once,
   or after a fresh clone):
   ```bash
   test -d .venv || python3 -m venv .venv
   .venv/bin/pip install --quiet python-docx openpyxl
   ```
2. Run the extractor:
   ```bash
   .venv/bin/python scripts/extract_input.py
   ```
3. Report to the user what was extracted (counts per source, output dirs) —
   the script itself prints a one-line summary per source file.

## After running

- Point the user at `extract/database/_index.json` and
  `extract/datamart/_index.json` to look up which file covers which table,
  instead of listing the whole directory.
- If the user later adds a new `input/` file or a table's layout doesn't
  match the expected pattern (extractor prints 0 tables for a source, or a
  table is missing from the index), inspect the actual heading/sheet
  structure with a quick Python check before touching the regex/parsing
  logic in `scripts/extract_input.py` — don't guess at the format.
