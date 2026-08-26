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
  - Overview/index sheets (`00_Muc_luc`, `00_Nguon_CDC`, `00_Sinh_khoa`) are
    merged into a single `extract/datamart/_overview.md` instead of one file
    each, since they're reference material rather than table schemas.
  - `extract/datamart/_index.json` lists every sheet extracted: name, file,
    table type (DIM/FCT), column count.

Database and datamart are kept as **separate directories** — a table like
`DIM_LOS_APPLICATION` that exists in both sources gets two files (one per
source), not merged, since the docx only covers static schema while the
xlsx additionally covers lineage/transform logic and may cover a different
table scope (e.g. the docx also has ~40 PDTD_DTM tables the xlsx doesn't).

Temp/lock files (`~$*.xlsx`) and non-source files are ignored automatically.

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
