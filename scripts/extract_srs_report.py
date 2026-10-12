#!/usr/bin/env python3
"""Extract input/srs_report/*.docx into extract/srs_report/*.md.

Each SRS report docx (BC1..BC11) follows a fixed structure:
  - doc.tables[6]: use-case info (Tên/Mô tả/Tác nhân/Trigger/Điều kiện trước/sau)
  - doc.tables[7]: Business Rules (Hoạt động/Mã BR/Mô tả), row for "BR 1.2"
    has a nested table (cell.tables[0]) listing source tables + join
    aliases ("Tên bảng" / "Điều kiện Join")
  - doc.tables[8]: report fields (STT/Trường/Ý nghĩa/Cách lấy dữ liệu)

Both the join-alias table and the field table may contain "section marker"
rows where every cell holds the same text (e.g. "Nguồn RLOS" repeated) —
these split the table into named subsections (used by multi-source reports
like BC9/KPI). Rendered as "### <section>" headings.

Re-run anytime input/srs_report/*.docx changes; each output file is fully
regenerated (overwritten), so there's no stale content left behind.
"""

import re
import sys
from pathlib import Path

from docx import Document

INPUT_DIR = Path(__file__).resolve().parent.parent / "input" / "srs_report"
OUTPUT_DIR = Path(__file__).resolve().parent.parent / "extract" / "srs_report"


def cell_text(cell) -> str:
    """Flatten a table cell's text to a single markdown-table-safe line."""
    text = cell.text.strip()
    text = re.sub(r"\s*\n\s*", " ", text)
    text = re.sub(r" {2,}", " ", text)
    text = text.replace("|", "\\|")
    return text


def is_section_marker(cells: list[str]) -> bool:
    non_empty = [c for c in cells if c]
    return bool(non_empty) and len(set(non_empty)) == 1 and len(non_empty) == len(cells)


def extract_usecase(table) -> list[str]:
    lines = ["## Use case", ""]
    label_map = {
        "Tên": "Tên",
        "Mô tả": "Mô tả",
        "Tác nhân": "Tác nhân",
        "Trigger": "Trigger",
        "Điều kiện trước": "Điều kiện trước",
        "Điều kiện sau": "Điều kiện sau",
    }
    for row in table.rows:
        cells = [c.text.strip() for c in row.cells]
        if len(cells) < 2:
            continue
        label, value = cells[0], cells[1]
        if label in label_map:
            lines.append(f"- **{label}**: {value}")
    lines.append("")
    return lines


def extract_business_rules(table) -> tuple[list[str], list[str]]:
    """Returns (business_rules_lines, join_alias_lines)."""
    br_lines = ["## Business Rules", ""]
    header = [c.text.strip() for c in table.rows[0].cells]
    br_lines.append(f"- **{header[0]}**: {header[1]} | {header[2]}")

    join_lines: list[str] = []

    for row in table.rows[1:]:
        cells = row.cells
        texts = [c.text.strip() for c in cells]
        br_lines.append(f"- ****: {texts[1]} | {texts[2]}")

        # Look for a nested join-alias table in any cell of this BR row
        for cell in cells:
            if cell.tables:
                join_lines = extract_join_aliases(cell.tables[0])

    br_lines.append("")
    return br_lines, join_lines


def extract_join_aliases(table) -> list[str]:
    lines = [
        "## Bảng nguồn sử dụng & điều kiện Join (alias map)",
        "",
        '> **Lưu ý quan trọng**: nếu có nhiều mục (section) dưới đây (vd. '
        '"Nguồn CLOS" / "Nguồn RLOS" / "KPI Khối (RLOS)" / "KPI Khối (CLOS)"), '
        "alias (a, b, c...) được TÁI SỬ DỤNG với Ý NGHĨA KHÁC NHAU ở mỗi "
        "section — không được tra alias xuyên section.",
        "",
    ]

    rows = list(table.rows)
    header = [cell_text(c) for c in rows[0].cells]  # Tên bảng | Điều kiện Join

    def emit_section_table(section_rows, section_name):
        lines.append(f"### {section_name}")
        lines.append("")
        lines.append("| Alias | Bảng nguồn | Điều kiện Join |")
        lines.append("|---|---|---|")
        for cells in section_rows:
            full_table, join_cond = cells[0], cells[1]
            m = re.match(r"^(.*)\(([^()]+)\)\s*$", full_table)
            if m:
                table_name, alias = m.group(1).strip(), m.group(2).strip()
            else:
                table_name, alias = full_table, ""
            lines.append(f"| {alias} | {table_name} | {join_cond} |")
        lines.append("")

    data_rows = [[cell_text(c) for c in r.cells] for r in rows[1:]]

    sections: list[tuple[str, list[list[str]]]] = []
    current_name = "(mặc định)"
    current_rows: list[list[str]] = []
    for cells in data_rows:
        if is_section_marker(cells):
            if current_rows:
                sections.append((current_name, current_rows))
            current_name = cells[0]
            current_rows = []
        else:
            current_rows.append(cells)
    if current_rows:
        sections.append((current_name, current_rows))

    for name, srows in sections:
        emit_section_table(srows, name)

    return lines


def extract_fields(table) -> list[str]:
    lines = ["## Danh sách trường báo cáo & logic lấy dữ liệu", ""]

    rows = list(table.rows)
    header = [cell_text(c) for c in rows[0].cells]
    data_rows = [[cell_text(c) for c in r.cells] for r in rows[1:]]

    def emit_section_table(section_rows, section_name=None):
        if section_name:
            lines.append(f"### {section_name}")
            lines.append("")
        lines.append(f"| {' | '.join(header)} |")
        lines.append("|" + "---|" * len(header))
        for cells in section_rows:
            lines.append(f"| {' | '.join(cells)} |")
        lines.append("")

    sections: list[tuple[str | None, list[list[str]]]] = []
    current_name = None
    current_rows: list[list[str]] = []
    has_sections = any(is_section_marker(c) for c in data_rows)

    if not has_sections:
        emit_section_table(data_rows)
        return lines

    for cells in data_rows:
        if is_section_marker(cells):
            if current_rows:
                sections.append((current_name, current_rows))
            current_name = cells[0]
            current_rows = []
        else:
            current_rows.append(cells)
    if current_rows:
        sections.append((current_name, current_rows))

    for name, srows in sections:
        emit_section_table(srows, name)

    return lines


def extract_one(docx_path: Path, code: str) -> str:
    doc = Document(docx_path)
    tables = doc.tables
    if len(tables) < 9:
        raise ValueError(f"{docx_path.name}: expected >=9 top-level tables, got {len(tables)}")

    usecase_table = tables[6]
    br_table = tables[7]
    fields_table = tables[8]

    lines = [
        f"# {code} — SRS extract (nguồn: input/srs_report/{docx_path.name})",
        "",
        "> Auto-extracted. Dùng để đối chiếu logic SRS (STG_LOS -> báo cáo) "
        "với LLD (STG_LOS -> SB_DWH -> STG_DTM -> PDTD_DTM -> báo cáo).",
        "",
    ]
    lines += extract_usecase(usecase_table)

    br_lines, join_lines = extract_business_rules(br_table)
    lines += br_lines
    lines += join_lines

    lines += extract_fields(fields_table)

    return "\n".join(lines).rstrip() + "\n"


def main():
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    docx_files = sorted(
        INPUT_DIR.glob("BC*_PDTD_DTM_SRS_v1.0.docx"),
        key=lambda p: int(re.match(r"BC(\d+)_", p.name).group(1)),
    )
    if not docx_files:
        print("No SRS docx files found in", INPUT_DIR)
        sys.exit(1)

    for docx_path in docx_files:
        m = re.match(r"(BC\d+)_", docx_path.name)
        code = m.group(1)
        try:
            content = extract_one(docx_path, code)
        except Exception as e:
            print(f"FAILED {docx_path.name}: {e}")
            continue
        out_path = OUTPUT_DIR / f"{code}.md"
        out_path.write_text(content, encoding="utf-8")
        n_lines = content.count("\n")
        print(f"{code}: {docx_path.name} -> {out_path.relative_to(OUTPUT_DIR.parent.parent)} ({n_lines} lines)")


if __name__ == "__main__":
    main()
