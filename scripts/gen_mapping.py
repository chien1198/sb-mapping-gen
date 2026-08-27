"""Fill a mapping template (references/Mapping_*_template.xlsx) with data
produced by the mapping-gen skill, preserving the template's styling.

Usage:
    python3 scripts/gen_mapping.py <data.json> <template.xlsx> <output.xlsx>

data.json shape — see .claude/skills/mapping-gen/SKILL.md for the full
contract. Summary:

{
  "table_name": "DIM_LOS_APPLICATION",
  "table_description": "...",
  "key_note": "Bao gồm các trường màu đỏ",
  "frequency": "Chạy dữ liệu FULL hàng ngày",          # optional, FCT only
  "sources": [                                          # header block, per source column
    {"column": "E", "lines": ["NG_SB_CLOS_CUST_INFO AS A", "NG_SB_CLOS_APPROVAL AS B"]},
    {"column": "F", "lines": ["NG_SB_RLOS_APPLICANT_GENERAL AS A"]}
  ],
  "mapping_headers": ["How to mapping CLOS", "How to mapping RLOS"],  # E, F... labels
  "table_condition": ["A.EXP_DATE IS NULL OR ..."],   # optional, one per mapping_headers
                                                        # entry — written into the FIXED
                                                        # "Điều kiện lấy dữ liệu" sub-row
                                                        # (E6/F6...) right under the header,
                                                        # for a filter that applies to the
                                                        # WHOLE table (not one column). The
                                                        # "Điều kiện lấy dữ liệu" label itself
                                                        # already lives in D6 in every template
                                                        # and is never touched by this script.
  "columns": [
    {
      "name": "DIMENSION_KEY",
      "type": "NUMBER",
      "item_name": "Surrogate Key",
      "description": "",
      "is_key": true,
      "condition": null,                # optional per-column condition NOTE row inserted
                                          # directly above this one column (Description
                                          # column only) — NOT the same thing as
                                          # "table_condition" above; use this only when a
                                          # single specific column needs a called-out filter,
                                          # not for a table-wide WHERE clause
      "mapping": ["SEQ_DIM_LOS_APPLICATION.NEXTVAL", null]   # one per mapping_headers entry
    },
    ...
  ],
  "join_conditions": [                  # one entry per source column (E, F, ...), or null
    ["LEFT JOIN B.WI_NAME = A.WI_NAME", "LEFT JOIN C.WI_NAME = A.WI_NAME"],
    null
  ],
  "notes": [                             # optional; list = numbered points, or a plain string
    "Các khóa nghiệp vụ của NG_SB_CLOS_CUST_INFO... đang CẦN XÁC NHẬN",
    "RESULT_MAIN_CARD_ID và FIRST_APPROVED_* không có lineage tương ứng, đã bỏ qua"
  ]
}

Each entry in "join_conditions" is a LIST of individual JOIN clauses for
that source system. The script lays these out as separate ROWS below the
label row — clause[0] for every system on the first row, clause[1] for
every system on the second row, and so on — mirroring the FCT_LOAN
template's own worked example (its "Điều kiện join" section spans two
rows, one JOIN clause per source system per row). It never concatenates
multiple clauses into one cell with embedded newlines. Lists across
systems don't need to be the same length — a system with fewer JOIN
clauses just leaves that row's cell blank for the remaining rows. The
script writes the "Điều kiện join giữa các bảng" label into column D (the
Description column) on the first (label) row, matching the current
templates.

Any mapping cell with no ETL logic for that source system (the column simply
isn't produced there) must use the literal string "NULL", never a blank/null
JSON value — this mirrors the template's own convention (see the LOAN
template's literal NULL cells) and keeps "not applicable" visually distinct
from "forgot to fill in".

"notes", when present, renders as a "Chú ý:" row with both the label and
the content in bold — and the row is only emitted at all when "notes" is
truthy; leave the key out (or empty) to skip it entirely rather than
emitting a blank placeholder row. Pass a LIST when there is more than one
distinct point to flag — each item is numbered "1. ", "2. ", ... on its own
line within the single B-column cell, deliberately WITHOUT wrap_text (wrap
would collapse the numbered points into one dense visual block a reviewer
can skim past; leaving it off keeps each line legible on its own) — so
unrelated concerns (e.g. an unconfirmed source key vs. a column skipped for
lack of lineage) stay visually separate instead of running together in one
paragraph. A single string still works for a lone note and renders
unnumbered, as
before.

The script never invents mapping logic — it only places already-decided
strings into the right cells. All analysis happens in the agent turn before
this script runs.
"""
import copy
import json
import sys
from pathlib import Path

import openpyxl

HEADER_ROW_LABEL = "Column name"
FIRST_MAPPING_COL = 5  # column E
JOIN_LABEL_COL = 4  # column D — "Điều kiện join giữa các bảng" label (Description column)


def find_layout(ws):
    """Locate the fixed rows in the template: header row, condition sub-row,
    first data row, and the 'Điều kiện join giữa các bảng' row if present."""
    header_row = None
    for r in range(1, ws.max_row + 1):
        if ws.cell(row=r, column=1).value == HEADER_ROW_LABEL:
            header_row = r
            break
    if header_row is None:
        raise ValueError("Không tìm thấy hàng header 'Column name' trong template")

    condition_row = header_row + 1
    first_data_row = header_row + 2

    join_row = None
    for r in range(first_data_row, ws.max_row + 1):
        if ws.cell(row=r, column=JOIN_LABEL_COL).value == "Điều kiện join giữa các bảng":
            join_row = r
            break

    notes_row = None
    for r in range(first_data_row, ws.max_row + 1):
        if ws.cell(row=r, column=1).value == "Chú ý:":
            notes_row = r
            break

    return header_row, condition_row, first_data_row, join_row, notes_row


def capture_row_style(ws, row, max_col=6):
    """Snapshot per-cell style objects for a row so they can be re-applied
    after the row's original position has been deleted/overwritten."""
    styles = []
    for c in range(1, max_col + 1):
        cell = ws.cell(row=row, column=c)
        styles.append({
            "font": copy.copy(cell.font),
            "fill": copy.copy(cell.fill),
            "border": copy.copy(cell.border),
            "alignment": copy.copy(cell.alignment),
            "number_format": cell.number_format,
        })
    return styles, ws.row_dimensions[row].height


def apply_row_style(ws, row, styles, height, max_col=6):
    for c in range(1, max_col + 1):
        cell = ws.cell(row=row, column=c)
        s = styles[c - 1]
        cell.font = copy.copy(s["font"])
        cell.fill = copy.copy(s["fill"])
        cell.border = copy.copy(s["border"])
        cell.alignment = copy.copy(s["alignment"])
        cell.number_format = s["number_format"]
    if height is not None:
        ws.row_dimensions[row].height = height


def set_key_font(cell, is_key):
    f = copy.copy(cell.font)
    f.color = openpyxl.styles.colors.Color(rgb="FFFF0000") if is_key else openpyxl.styles.colors.Color(rgb="FF000000")
    cell.font = f


def fill_header_block(ws, data):
    ws.cell(row=1, column=2).value = data["table_name"]
    ws.cell(row=2, column=2).value = data.get("table_description", "")
    ws.cell(row=3, column=2).value = data.get("key_note", "Bao gồm các trường màu đỏ")
    if data.get("frequency"):
        ws.cell(row=4, column=2).value = data["frequency"]

    # E1 always carries the template's intended "source line" style (bold,
    # no strikethrough) — use it as the single source of truth for every
    # source line cell instead of trusting whatever style each individual
    # template row/col happens to already have (some are blank-but-styled,
    # some are blank-and-unstyled, inconsistently).
    source_font = copy.copy(ws.cell(row=1, column=5).font)
    source_font.strike = False
    source_font.bold = True

    # left-align every source line so the stacked "TABLE AS X" entries read
    # as one consistent left-anchored list, instead of the template's
    # default centered alignment which looked inconsistent across lines of
    # different length. Vertical alignment follows the template's own
    # label-column style (A1) rather than a hardcoded guess.
    source_alignment = openpyxl.styles.Alignment(
        horizontal="left", vertical=ws.cell(row=1, column=1).alignment.vertical
    )

    # clear any pre-existing source lines from the template rows 1..12, cols E..F,
    # resetting their font so no leftover styling (e.g. strikethrough) survives
    for r in range(1, 13):
        for c in (5, 6):
            cell = ws.cell(row=r, column=c)
            cell.value = None
            cell.font = copy.copy(source_font)
            cell.alignment = source_alignment

    for src in data.get("sources", []):
        col = openpyxl.utils.column_index_from_string(src["column"])
        for i, line in enumerate(src["lines"]):
            cell = ws.cell(row=1 + i, column=col)
            cell.value = line
            cell.font = copy.copy(source_font)
            cell.alignment = source_alignment


def fill_mapping_headers(ws, header_row, mapping_headers, last_mapping_col):
    for i, label in enumerate(mapping_headers):
        ws.cell(row=header_row, column=FIRST_MAPPING_COL + i).value = label
    # some templates ship with more "How to mapping <SYSTEM>" header cells
    # than this table actually uses (e.g. FCT_LOAN's own 2-system header
    # when this table only needs 1) — clear any leftover header label past
    # what mapping_headers declares, or it survives into the output looking
    # like a real (but unfilled) source system
    for c in range(FIRST_MAPPING_COL + len(mapping_headers), last_mapping_col + 1):
        ws.cell(row=header_row, column=c).value = None


def build(data, template_path, output_path):
    wb = openpyxl.load_workbook(template_path)
    ws = wb["Mapping"]

    header_row, condition_row, first_data_row, join_row, notes_row = find_layout(ws)

    mapping_headers = data["mapping_headers"]
    n_sources = len(mapping_headers)
    last_mapping_col = max(6, FIRST_MAPPING_COL + n_sources - 1)

    # snapshot the styles we need to reuse before wiping the template's
    # sample data rows (data_style from the first data row, condition_style
    # from the sub-row right below the header, join_label_style/
    # join_content_style from the template's own "Điều kiện join" rows,
    # notes_style from the template's own "Chú ý:" row, if present — so the
    # output keeps their fill/border/alignment instead of ending up unstyled)
    data_style, data_height = capture_row_style(ws, first_data_row, max_col=last_mapping_col)
    condition_style, condition_height = capture_row_style(ws, condition_row, max_col=last_mapping_col)
    if join_row is not None:
        join_label_style, join_label_height = capture_row_style(ws, join_row, max_col=last_mapping_col)
        join_content_style, join_content_height = capture_row_style(ws, join_row + 1, max_col=last_mapping_col)
    else:
        join_label_style = join_content_style = None
        join_label_height = join_content_height = None
    if notes_row is not None:
        notes_style, notes_height = capture_row_style(ws, notes_row, max_col=2)
    else:
        notes_style = notes_height = None

    # wipe every template sample row from first_data_row to the end of the
    # sheet so no stale sample content survives, regardless of how many rows
    # this table's data ends up needing
    if ws.max_row >= first_data_row:
        ws.delete_rows(first_data_row, ws.max_row - first_data_row + 1)

    # condition_row (the "Điều kiện lấy dữ liệu" sub-row right under the
    # header) sits ABOVE first_data_row, so the delete_rows above never
    # touches it — some templates (e.g. FCT_LOAN) ship with real sample
    # content in that row's mapping cells. Clear its values now (style was
    # already captured above) so that content only reappears if this
    # table's own data actually uses a "condition" sub-row; otherwise a
    # past table's leftover condition text would silently survive into
    # every table that doesn't need one. Column D (the "Điều kiện lấy dữ
    # liệu" label itself) is preserved — every template ships it already
    # and this script never touches that label, only the mapping columns
    # (E, F, ...) which carry the actual filter expression per source.
    for c in range(1, last_mapping_col + 1):
        if c == 4:
            continue
        ws.cell(row=condition_row, column=c).value = None

    fill_header_block(ws, data)
    fill_mapping_headers(ws, header_row, mapping_headers, last_mapping_col)

    # table-wide row filter (e.g. STG_DTM's EXP_DATE/DAYID window) goes into
    # the FIXED condition_row's mapping columns, one value per source
    # system — never a new row, and never column D (that's the label).
    table_condition = data.get("table_condition")
    if table_condition:
        for j, cond in enumerate(table_condition):
            if cond:
                ws.cell(row=condition_row, column=FIRST_MAPPING_COL + j).value = cond

    row = first_data_row
    columns = data["columns"]

    for col in columns:
        if col.get("condition"):
            apply_row_style(ws, row, condition_style, condition_height, max_col=last_mapping_col)
            ws.cell(row=row, column=4).value = col["condition"]
            row += 1

        apply_row_style(ws, row, data_style, data_height, max_col=last_mapping_col)
        ws.cell(row=row, column=1).value = col["name"]
        ws.cell(row=row, column=2).value = col.get("type", "")
        ws.cell(row=row, column=3).value = col.get("item_name", "")
        ws.cell(row=row, column=4).value = col.get("description", "")
        set_key_font(ws.cell(row=row, column=1), col.get("is_key", False))

        mapping_vals = col.get("mapping", [])
        for j in range(n_sources):
            val = mapping_vals[j] if j < len(mapping_vals) else None
            # a source system with no ETL logic for this column uses the
            # literal "NULL" (matches the template's own convention), never
            # a blank cell — blank would read as "not decided yet"
            ws.cell(row=row, column=FIRST_MAPPING_COL + j).value = val if val else "NULL"

        row += 1

    # blank separator row, then join conditions row(s), then notes
    join_conditions = data.get("join_conditions")
    if join_conditions:
        row += 1
        if join_label_style is not None:
            apply_row_style(ws, row, join_label_style, join_label_height, max_col=last_mapping_col)
        join_label_cell = ws.cell(row=row, column=JOIN_LABEL_COL)
        join_label_cell.value = "Điều kiện join giữa các bảng"
        join_label_cell.font = openpyxl.styles.Font(
            name=join_label_cell.font.name, bold=True, color=join_label_cell.font.color
        )
        row += 1

        # one clause per ROW (not stacked with \n in a single cell), one
        # column per source system — matches the FCT_LOAN template's own
        # multi-row JOIN example (clause[0] of every system on the first
        # row, clause[1] on the next, ...)
        max_clauses = max((len(c) for c in join_conditions if c), default=0)
        for clause_idx in range(max_clauses):
            if join_content_style is not None:
                apply_row_style(ws, row, join_content_style, join_content_height, max_col=last_mapping_col)
            for j, conds in enumerate(join_conditions):
                if conds and clause_idx < len(conds):
                    ws.cell(row=row, column=FIRST_MAPPING_COL + j).value = conds[clause_idx]
            row += 1

    notes = data.get("notes")
    if notes:
        row += 2
        if notes_style is not None:
            apply_row_style(ws, row, notes_style, notes_height, max_col=2)
        label_cell = ws.cell(row=row, column=1)
        value_cell = ws.cell(row=row, column=2)
        label_cell.value = "Chú ý:"
        if isinstance(notes, list):
            # deliberately NOT wrap_text: with wrap on, multiple numbered
            # points collapse visually into one tall cell and a reviewer
            # can miss a point while skimming — leaving wrap off means each
            # "\n"-separated line still renders as its own visual line in
            # Excel's default row height behavior, keeping points scannable
            value_cell.value = "\n".join(f"{i}. {n}" for i, n in enumerate(notes, start=1))
        else:
            value_cell.value = notes
        label_cell.font = openpyxl.styles.Font(name=label_cell.font.name, bold=True, color=label_cell.font.color)
        value_cell.font = openpyxl.styles.Font(name=value_cell.font.name, bold=True, color=value_cell.font.color)

    Path(output_path).parent.mkdir(parents=True, exist_ok=True)
    wb.save(output_path)


def main():
    if len(sys.argv) != 4:
        print(__doc__)
        sys.exit(1)
    data_path, template_path, output_path = sys.argv[1:4]
    with open(data_path, encoding="utf-8") as f:
        data = json.load(f)
    build(data, template_path, output_path)
    print(f"OK -> {output_path}")


if __name__ == "__main__":
    main()
