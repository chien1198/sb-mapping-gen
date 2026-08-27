"""Self-check a generated mapping Excel file (mapping/Mapping_<TABLE>.xlsx)
for the formatting/structural rules gen_mapping.py is supposed to guarantee.

This is NOT a business-logic checker — it never judges whether a mapping
formula is *correct*. It only catches the class of output-formatting bugs
that have actually shipped before:

  1. Header block source lines (rows 1-4, cols E/F...) must be bold.
  2. No cell in the sheet may carry strikethrough formatting.
  3. Each JOIN-clause cell under "Điều kiện join giữa các bảng" holds
     exactly ONE JOIN clause. Multiple clauses for the same source system
     go on separate ROWS (one clause per row, one column per system) —
     mirroring the FCT_LOAN template's own worked example — never stacked
     with "\\n" inside a single cell.
  4. Every "How to mapping <SYSTEM>" cell for a real column row must be
     non-empty — blank means "forgot to decide", not "not applicable"
     (the convention for "not applicable" is the literal string "NULL").
  5. The "Điều kiện join giữa các bảng" label must sit in column D (the
     Description column), matching the current templates — not column A.
  6. A "Chú ý:" row, when present, must have both its label (col A) and its
     content (col B) in bold, with the content cell left-aligned and
     vertically centered — matching the template's own B72 example. The row
     itself must only exist when there is real note content — never
     emitted as an empty placeholder.
  7. Source header block lines (rows 1-4, cols E/F...) must be left-aligned
     — not centered — so a stack of "TABLE AS X" lines of different lengths
     reads as one consistent left-anchored list.
  8. The "Điều kiện join giữa các bảng" label row and the JOIN-clause row
     right below it must carry the template's fill (colored background) and
     border on their cells — a join section that ends up with no fill/no
     border means the template's own styling wasn't carried over.
  9. When "Chú ý" content spans multiple points (multiple lines), each line
     must be numbered "1. ", "2. ", ... in order — distinct concerns must
     stay visually separate, never run together as one paragraph — AND
     wrap_text must be OFF on that cell, so the numbered points render as
     distinct lines instead of collapsing into one dense wrapped block a
     reviewer can skim past.
  10. The "Điều kiện lấy dữ liệu" sub-row (right under the column header)
      must not reference any alias that isn't declared in this table's own
      header block. Some templates (FCT_LOAN) ship with real sample text in
      that row, and it sits outside the row range gen_mapping.py normally
      bulk-deletes — a table whose own data never uses that sub-row can end
      up leaking the template's sample content into the output unnoticed.
  11. When both CLOS and RLOS appear in the "How to mapping" headers, CLOS
      must come first (column E), RLOS second (column F) — this project's
      fixed convention across every table, so a reviewer scanning many
      files can rely on column E always being CLOS.

Usage:
    python3 scripts/validate_mapping.py <output.xlsx>

Exits 0 and prints "OK" if all checks pass. Exits 1 and prints one line per
violation (row/col reference + rule) otherwise.
"""
import re
import sys

import openpyxl

HEADER_ROW_LABEL = "Column name"
FIRST_MAPPING_COL = 5  # column E
JOIN_LABEL_COL = 4  # column D — "Điều kiện join giữa các bảng" label (Description column)


def find_layout(ws):
    header_row = None
    for r in range(1, ws.max_row + 1):
        if ws.cell(row=r, column=1).value == HEADER_ROW_LABEL:
            header_row = r
            break
    if header_row is None:
        raise ValueError("Không tìm thấy hàng header 'Column name' trong file")
    condition_row = header_row + 1
    first_data_row = header_row + 2

    join_row = None
    for r in range(first_data_row, ws.max_row + 1):
        row_values = [ws.cell(row=r, column=c).value for c in range(1, ws.max_column + 1)]
        if "Điều kiện join giữa các bảng" in row_values:
            join_row = r
            break

    # the JOIN-clause rows immediately following the label row: every
    # consecutive row that has at least one non-empty cell in the mapping
    # columns (E, F, ...) counts as a clause row; the first fully-empty row
    # (the blank separator before "Chú ý:", or end of sheet) ends the block
    join_content_rows = []
    if join_row is not None:
        r = join_row + 1
        n_cols = ws.max_column
        while r <= ws.max_row:
            has_content = any(
                ws.cell(row=r, column=c).value not in (None, "")
                for c in range(FIRST_MAPPING_COL, n_cols + 1)
            )
            if not has_content:
                break
            join_content_rows.append(r)
            r += 1

    notes_row = None
    for r in range(first_data_row, ws.max_row + 1):
        if ws.cell(row=r, column=1).value == "Chú ý:":
            notes_row = r
            break

    return header_row, condition_row, first_data_row, join_row, join_content_rows, notes_row


def check_header_block_bold(ws, header_row, errors):
    n_cols = ws.max_column
    for r in range(1, header_row):
        for c in range(FIRST_MAPPING_COL, n_cols + 1):
            cell = ws.cell(row=r, column=c)
            if cell.value is None:
                continue
            if not cell.font.bold:
                errors.append(f"{cell.coordinate}: source line không in đậm (giá trị={cell.value!r})")


SYSTEM_ORDER = ["CLOS", "RLOS"]


def check_mapping_header_system_order(ws, header_row, errors):
    """Across this project's tables, the two source systems are always
    ordered CLOS then RLOS in the "How to mapping <SYSTEM>" headers — a
    reviewer scanning many files relies on column E always being CLOS.
    Only enforced when both systems are present in the header labels; a
    table naming some other pair of systems isn't checked here."""
    n_cols = ws.max_column
    seen = []
    for c in range(FIRST_MAPPING_COL, n_cols + 1):
        val = ws.cell(row=header_row, column=c).value
        if not val:
            continue
        for system in SYSTEM_ORDER:
            if system in val:
                seen.append((c, system))
                break
    present = [s for _, s in seen]
    if set(SYSTEM_ORDER).issubset(set(present)):
        expected = SYSTEM_ORDER
        actual = [s for _, s in sorted(seen, key=lambda x: x[0])]
        if actual != expected:
            errors.append(
                f"Row {header_row}: thứ tự hệ nguồn trong header là {actual}, "
                f"không đúng chuẩn {expected} (CLOS luôn đứng trước RLOS trong toàn dự án)"
            )


def check_no_strikethrough(ws, errors):
    for row in ws.iter_rows():
        for cell in row:
            if cell.font is not None and cell.font.strike:
                errors.append(f"{cell.coordinate}: cell bị gạch ngang (strikethrough), giá trị={cell.value!r}")


def check_join_conditions_one_per_cell(ws, join_content_rows, errors):
    n_cols = ws.max_column
    for r in join_content_rows:
        for c in range(FIRST_MAPPING_COL, n_cols + 1):
            cell = ws.cell(row=r, column=c)
            val = cell.value
            if not val:
                continue
            join_count = (
                val.upper().count("LEFT JOIN")
                + val.upper().count("INNER JOIN")
                + val.upper().count("RIGHT JOIN")
                + val.upper().count("JOIN:")
            )
            if join_count > 1 or "\n" in val:
                errors.append(
                    f"{cell.coordinate}: nhiều câu JOIN bị gộp chung 1 cell — mỗi câu JOIN phải "
                    f"nằm ở 1 hàng riêng (theo mẫu FCT_LOAN template), không nối bằng \\n trong 1 ô"
                )


def check_mapping_cells_not_blank(ws, header_row, first_data_row, join_row, errors):
    n_cols = ws.max_column
    last_data_row = (join_row - 1) if join_row else ws.max_row
    for r in range(first_data_row, last_data_row + 1):
        name = ws.cell(row=r, column=1).value
        if not name or name in ("Điều kiện join giữa các bảng", "Chú ý:"):
            continue
        # skip pure "Điều kiện lấy dữ liệu" sub-rows (no column name, only a
        # description in col D)
        for c in range(FIRST_MAPPING_COL, n_cols + 1):
            cell = ws.cell(row=r, column=c)
            if cell.value is None or (isinstance(cell.value, str) and cell.value.strip() == ""):
                header_label = ws.cell(row=header_row, column=c).value
                errors.append(
                    f"{cell.coordinate}: ô '{header_label}' của cột '{name}' bị bỏ trống — "
                    f"phải là công thức mapping hoặc literal \"NULL\""
                )


def check_join_label_column(ws, join_row, errors):
    if join_row is None:
        return
    cell = ws.cell(row=join_row, column=JOIN_LABEL_COL)
    if cell.value != "Điều kiện join giữa các bảng":
        errors.append(
            f"{cell.coordinate}: nhãn 'Điều kiện join giữa các bảng' không nằm ở cột D "
            f"(Description) như template hiện tại quy định"
        )


def check_notes_row(ws, notes_row, errors):
    if notes_row is None:
        return
    label_cell = ws.cell(row=notes_row, column=1)
    value_cell = ws.cell(row=notes_row, column=2)
    if not value_cell.value or (isinstance(value_cell.value, str) and value_cell.value.strip() == ""):
        errors.append(
            f"{label_cell.coordinate}: hàng 'Chú ý:' được sinh ra nhưng không có nội dung — "
            f"chỉ nên sinh hàng này khi thực sự có ghi chú"
        )
        return
    if not label_cell.font.bold:
        errors.append(f"{label_cell.coordinate}: nhãn 'Chú ý:' chưa in đậm")
    if not value_cell.font.bold:
        errors.append(f"{value_cell.coordinate}: nội dung Chú ý chưa in đậm")

    # must match the template's own B72 alignment (left/center) — a common
    # regression when the notes row is written without inheriting the
    # template's style first
    if value_cell.alignment.horizontal != "left":
        errors.append(
            f"{value_cell.coordinate}: nội dung Chú ý không căn trái như template "
            f"(hiện tại: {value_cell.alignment.horizontal})"
        )
    if value_cell.alignment.vertical != "center":
        errors.append(
            f"{value_cell.coordinate}: nội dung Chú ý không căn giữa theo chiều dọc như template "
            f"(hiện tại: {value_cell.alignment.vertical})"
        )

    lines = value_cell.value.split("\n")
    if len(lines) > 1:
        # deliberately NOT wrapped — wrap_text collapses numbered points
        # into one dense visual block that's easy to skim past during
        # review; each "\n"-separated point should stay on its own
        # unwrapped line instead
        if value_cell.alignment.wrap_text:
            errors.append(
                f"{value_cell.coordinate}: Chú ý nhiều ý nhưng đang bật wrap_text — "
                f"tắt wrap_text để mỗi ý là 1 dòng riêng dễ scan, tránh gộp thành khối đặc"
            )
        for i, line in enumerate(lines, start=1):
            if not line.startswith(f"{i}. "):
                errors.append(
                    f"{value_cell.coordinate}: dòng {i} của Chú ý không đánh số đúng thứ tự "
                    f"(kỳ vọng bắt đầu bằng '{i}. ') — mỗi ý cần đánh số riêng, không gộp thành đoạn văn"
                )


def check_source_header_alignment(ws, errors):
    n_cols = ws.max_column
    for r in range(1, 5):
        for c in range(FIRST_MAPPING_COL, n_cols + 1):
            cell = ws.cell(row=r, column=c)
            if cell.value is None:
                continue
            if cell.alignment.horizontal != "left":
                errors.append(
                    f"{cell.coordinate}: dòng nguồn '{cell.value}' không căn trái "
                    f"(hiện tại: {cell.alignment.horizontal})"
                )


def check_join_row_fill_and_border(ws, join_row, join_content_rows, errors):
    if join_row is None:
        return
    n_cols = ws.max_column
    for r in [join_row] + join_content_rows:
        for c in range(1, n_cols + 1):
            cell = ws.cell(row=r, column=c)
            if cell.border.left.style is None:
                errors.append(
                    f"{cell.coordinate}: ô trong vùng 'Điều kiện join' thiếu border như template"
                )
    label_cell = ws.cell(row=join_row, column=JOIN_LABEL_COL)
    if label_cell.fill is None or label_cell.fill.patternType is None:
        errors.append(
            f"{label_cell.coordinate}: hàng nhãn 'Điều kiện join giữa các bảng' thiếu màu nền (fill) như template"
        )


def check_condition_row_not_leftover(ws, condition_row, errors):
    """The 'Điều kiện lấy dữ liệu' sub-row sits ABOVE first_data_row, outside
    the range gen_mapping.py bulk-deletes. Some templates (e.g. FCT_LOAN)
    ship with real sample text in that row's mapping cells; if this table's
    own data never wrote to it, template leftover text can survive
    unnoticed. Detect it generically: collect every alias declared in the
    header block (rows 1-12, "TABLE AS X" lines) and flag any "X." token in
    the condition row that references an alias never declared — that can
    only be sample content from the template, since this table's own
    formulas only ever reference its own declared aliases."""
    declared_aliases = set()
    n_cols = ws.max_column
    for r in range(1, 13):
        for c in range(FIRST_MAPPING_COL, n_cols + 1):
            val = ws.cell(row=r, column=c).value
            if val:
                declared_aliases.update(re.findall(r"\bAS\s+([A-Z])\b", val))

    for c in range(FIRST_MAPPING_COL, n_cols + 1):
        cell = ws.cell(row=condition_row, column=c)
        val = cell.value
        if not val:
            continue
        used_aliases = set(re.findall(r"\b([A-Z])\.[A-Z_]", val))
        stray = used_aliases - declared_aliases
        if stray:
            errors.append(
                f"{cell.coordinate}: hàng 'Điều kiện lấy dữ liệu' tham chiếu alias "
                f"{sorted(stray)} chưa từng khai báo ở header block — nghi ngờ là "
                f"nội dung mẫu còn sót lại từ template, chưa bị xóa"
            )


def validate(path):
    wb = openpyxl.load_workbook(path)
    if "Mapping" not in wb.sheetnames:
        return [f"Thiếu sheet 'Mapping' trong {path}"]
    ws = wb["Mapping"]

    errors = []
    header_row, condition_row, first_data_row, join_row, join_content_rows, notes_row = find_layout(ws)

    check_header_block_bold(ws, header_row, errors)
    check_no_strikethrough(ws, errors)
    check_join_conditions_one_per_cell(ws, join_content_rows, errors)
    check_mapping_cells_not_blank(ws, header_row, first_data_row, join_row, errors)
    check_join_label_column(ws, join_row, errors)
    check_notes_row(ws, notes_row, errors)
    check_source_header_alignment(ws, errors)
    check_join_row_fill_and_border(ws, join_row, join_content_rows, errors)
    check_condition_row_not_leftover(ws, condition_row, errors)
    check_mapping_header_system_order(ws, header_row, errors)

    return errors


def main():
    if len(sys.argv) != 2:
        print(__doc__)
        sys.exit(1)
    path = sys.argv[1]
    errors = validate(path)
    if not errors:
        print(f"OK -> {path} passed all self-checks")
        sys.exit(0)
    print(f"FAILED -> {path}: {len(errors)} vi phạm")
    for e in errors:
        print(f"  - {e}")
    sys.exit(1)


if __name__ == "__main__":
    main()
