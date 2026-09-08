"""Convert raw design docs in input/ into per-table Markdown files in extract/.

Sources handled (only files directly under input/, not in subdirectories
like input/oldversions/ or input/srs_report/):
  - Design_Database_PDTD_DTM_*.docx  -> extract/database/<TABLE>.md
  - DATAMODEL_DWH_LOS_*.xlsx         -> extract/SB_DWH/<SHEET>.md
  - DATAMODEL_DTM_PDTD_*.xlsx        -> extract/PDTD_DTM/<SHEET>.md

Each source also gets an _index.json listing every table/sheet extracted,
so a later step can look up "where is table X" without reading every file.

Each xlsx source mixes real DIM/FCT table sheets with reference/explainer
sheets (design rationale, load order, business rules, glossaries — usually
named "00_..." but not necessarily). Only sheets whose name matches a table
already known from the docx (extract/database/_index.json) get extracted;
everything else is skipped outright — it isn't a table and isn't needed for
mapping generation. This requires docx extraction to run before xlsx in the
same invocation (see main()), which it does.

Run:
    .venv/bin/python scripts/extract_input.py
"""

from __future__ import annotations

import json
import re
from pathlib import Path
from typing import Callable

import openpyxl
from docx import Document

REPO_ROOT = Path(__file__).resolve().parent.parent
INPUT_DIR = REPO_ROOT / "input"
EXTRACT_DIR = REPO_ROOT / "extract"

DOCX_TABLE_HEADING_RE = re.compile(r"^[\d.]+\s+Bảng\s+(.+)$")


def slugify(name: str) -> str:
    name = name.strip()
    name = re.sub(r"[^\w\-.]+", "_", name, flags=re.UNICODE)
    return name.strip("_")


def table_to_markdown(table) -> str:
    rows = [[cell.text.strip().replace("\n", " ") for cell in row.cells] for row in table.rows]
    if not rows:
        return ""
    header, *body = rows
    lines = ["| " + " | ".join(header) + " |", "| " + " | ".join(["---"] * len(header)) + " |"]
    for row in body:
        lines.append("| " + " | ".join(row) + " |")
    return "\n".join(lines)


def clear_stale_markdown(out_dir: Path, keep_files: set[str]) -> None:
    """Remove .md files left over from a previous run whose table no longer
    exists / was renamed in the latest source document."""
    for existing in out_dir.glob("*.md"):
        if existing.name not in keep_files:
            existing.unlink()


def extract_docx(docx_path: Path, out_dir: Path) -> list[dict]:
    out_dir.mkdir(parents=True, exist_ok=True)
    doc = Document(docx_path)

    body_items = list(doc.element.body)
    tables_by_id = {id(t._element): t for t in doc.tables}

    index: list[dict] = []
    pending_heading: str | None = None
    pending_section: str | None = None

    for item in body_items:
        if item.tag.endswith("}p"):
            para = next((p for p in doc.paragraphs if p._element is item), None)
            if para is not None and para.style is not None and para.style.name.startswith("Heading"):
                text = para.text.strip()
                match = DOCX_TABLE_HEADING_RE.match(text)
                if match:
                    pending_heading = match.group(1).strip()
                    pending_section = text
        elif item.tag.endswith("}tbl"):
            table = tables_by_id.get(id(item))
            if table is None or pending_heading is None:
                continue

            table_name = pending_heading
            slug = slugify(table_name)
            md_table = table_to_markdown(table)
            n_rows = max(len(table.rows) - 1, 0)

            content = f"# {table_name}\n\nNguồn: docx section \"{pending_section}\"\n\n{md_table}\n"
            (out_dir / f"{slug}.md").write_text(content, encoding="utf-8")

            index.append(
                {
                    "table": table_name,
                    "file": f"{slug}.md",
                    "section": pending_section,
                    "columns": n_rows,
                }
            )
            pending_heading = None

    clear_stale_markdown(out_dir, {t["file"] for t in index})

    (out_dir / "_index.json").write_text(
        json.dumps({"source": docx_path.name, "tables": index}, ensure_ascii=False, indent=2),
        encoding="utf-8",
    )
    return index


def cell_value(ws, row: int, col: int):
    cell = ws.cell(row=row, column=col)
    for merged in ws.merged_cells.ranges:
        if cell.coordinate in merged:
            top_left = ws.cell(row=merged.min_row, column=merged.min_col)
            return top_left.value
    return cell.value


def extract_xlsx_table_sheet(ws) -> tuple[dict, str]:
    max_row = ws.max_row
    max_col = ws.max_column

    # Metadata block: rows from top until first fully-blank row.
    metadata: dict[str, str] = {}
    header_row = None
    row = 1
    while row <= max_row:
        key = cell_value(ws, row, 1)
        val = cell_value(ws, row, 2)
        if key is None and val is None:
            row += 1
            break
        if key is not None and val is not None and row > 1:
            metadata[str(key).strip()] = str(val).strip()
        row += 1

    # Skip additional blank rows, then find the column-table header row.
    while row <= max_row and all(cell_value(ws, row, c) is None for c in range(1, max_col + 1)):
        row += 1
    header_row = row

    headers = [str(cell_value(ws, header_row, c) or "").strip() for c in range(1, max_col + 1)]
    while headers and headers[-1] == "":
        headers.pop()

    body_rows = []
    for r in range(header_row + 1, max_row + 1):
        vals = [cell_value(ws, r, c) for c in range(1, len(headers) + 1)]
        if all(v is None for v in vals):
            continue
        body_rows.append(["" if v is None else str(v).strip().replace("\n", " ") for v in vals])

    return {"metadata": metadata, "headers": headers, "rows": body_rows}, ws.title


def sheet_data_to_markdown(table_name: str, data: dict, source_file: str) -> str:
    lines = [f"# {table_name}", "", f"Nguồn: xlsx sheet \"{table_name}\" ({source_file})", ""]
    if data["metadata"]:
        for k, v in data["metadata"].items():
            lines.append(f"- {k}: {v}")
        lines.append("")

    headers = data["headers"]
    if headers:
        lines.append("| " + " | ".join(headers) + " |")
        lines.append("| " + " | ".join(["---"] * len(headers)) + " |")
        for row in data["rows"]:
            lines.append("| " + " | ".join(row) + " |")
    return "\n".join(lines) + "\n"


def load_known_table_names() -> set[str]:
    """Table names already extracted from the docx (extract/database/_index.json).
    Used as a whitelist to tell a real DIM/FCT table sheet apart from a
    reference/explainer sheet (e.g. "00_..." sheets covering design
    rationale, load order, business rules) — those aren't tables and don't
    feed mapping generation, so they're skipped entirely rather than parsed
    as if they were one."""
    index_path = EXTRACT_DIR / "database" / "_index.json"
    if not index_path.exists():
        return set()
    data = json.loads(index_path.read_text(encoding="utf-8"))
    return {t["table"] for t in data.get("tables", [])}


def extract_report_sheet(ws) -> dict:
    """Report traceability sheets (Reports_*.xlsx): row1 title, row2 note,
    row3 blank, row4 header, data from row5 — no metadata block, every
    sheet is a real report (no reference/explainer sheets to filter out)."""
    max_row = ws.max_row
    max_col = ws.max_column

    title = str(cell_value(ws, 1, 1) or "").strip()
    note = str(cell_value(ws, 2, 1) or "").strip()

    header_row = 4
    headers = [str(cell_value(ws, header_row, c) or "").strip() for c in range(1, max_col + 1)]
    while headers and headers[-1] == "":
        headers.pop()

    body_rows = []
    for r in range(header_row + 1, max_row + 1):
        vals = [cell_value(ws, r, c) for c in range(1, len(headers) + 1)]
        if all(v is None for v in vals):
            continue
        body_rows.append(["" if v is None else str(v).strip().replace("\n", " ") for v in vals])

    return {"title": title, "note": note, "headers": headers, "rows": body_rows}


def report_sheet_to_markdown(sheet_name: str, data: dict, source_file: str) -> str:
    lines = [f"# {data['title'] or sheet_name}", "", f"Nguồn: xlsx sheet \"{sheet_name}\" ({source_file})", ""]
    if data["note"]:
        lines.append(data["note"])
        lines.append("")

    headers = data["headers"]
    if headers:
        lines.append("| " + " | ".join(headers) + " |")
        lines.append("| " + " | ".join(["---"] * len(headers)) + " |")
        for row in data["rows"]:
            lines.append("| " + " | ".join(row) + " |")
    return "\n".join(lines) + "\n"


def extract_report_xlsx(xlsx_path: Path, out_dir: Path) -> list[dict]:
    out_dir.mkdir(parents=True, exist_ok=True)
    wb = openpyxl.load_workbook(xlsx_path, data_only=True)

    index: list[dict] = []
    for sheet_name in wb.sheetnames:
        ws = wb[sheet_name]
        data = extract_report_sheet(ws)
        slug = slugify(sheet_name)
        content = report_sheet_to_markdown(sheet_name, data, xlsx_path.name)
        (out_dir / f"{slug}.md").write_text(content, encoding="utf-8")
        index.append(
            {
                "table": sheet_name,
                "file": f"{slug}.md",
                "source": xlsx_path.name,
                "columns": len(data["rows"]),
            }
        )
    return index


def extract_xlsx(xlsx_path: Path, out_dir: Path) -> list[dict]:
    out_dir.mkdir(parents=True, exist_ok=True)
    wb = openpyxl.load_workbook(xlsx_path, data_only=True)

    known_tables = load_known_table_names()
    index: list[dict] = []
    skipped: list[str] = []

    for sheet_name in wb.sheetnames:
        if sheet_name not in known_tables:
            skipped.append(sheet_name)
            continue

        ws = wb[sheet_name]
        data, table_name = extract_xlsx_table_sheet(ws)
        slug = slugify(table_name)
        content = sheet_data_to_markdown(table_name, data, xlsx_path.name)
        (out_dir / f"{slug}.md").write_text(content, encoding="utf-8")
        index.append(
            {
                "table": table_name,
                "file": f"{slug}.md",
                "source": xlsx_path.name,
                "loai_bang": data["metadata"].get("Loại bảng", ""),
                "columns": len(data["rows"]),
            }
        )

    if skipped:
        print(f"  (bỏ qua {len(skipped)} sheet không phải bảng: {', '.join(skipped)})")

    return index


XLSX_ROUTES = [
    (re.compile(r"DATAMODEL_DWH_LOS", re.IGNORECASE), "SB_DWH", extract_xlsx),
    (re.compile(r"DATAMODEL_DTM_PDTD", re.IGNORECASE), "PDTD_DTM", extract_xlsx),
    (re.compile(r"^Reports", re.IGNORECASE), "Report", extract_report_xlsx),
]


def route_xlsx(xlsx_path: Path) -> tuple[str, Callable[[Path, Path], list[dict]]]:
    for pattern, out_name, extractor in XLSX_ROUTES:
        if pattern.search(xlsx_path.stem):
            return out_name, extractor
    raise ValueError(
        f"Không xác định được thư mục output cho {xlsx_path.name} — "
        f"tên file phải chứa 'DATAMODEL_DWH_LOS' (-> SB_DWH/), "
        f"'DATAMODEL_DTM_PDTD' (-> PDTD_DTM/), hoặc bắt đầu bằng 'Reports' (-> Report/)."
    )


def main() -> None:
    docx_files = [p for p in INPUT_DIR.glob("*.docx") if not p.name.startswith("~$")]
    xlsx_files = [p for p in INPUT_DIR.glob("*.xlsx") if not p.name.startswith("~$")]

    if not docx_files and not xlsx_files:
        print(f"Không tìm thấy file .docx/.xlsx nào trong {INPUT_DIR}")
        return

    for docx_path in docx_files:
        out_dir = EXTRACT_DIR / "database"
        tables = extract_docx(docx_path, out_dir)
        print(f"[docx] {docx_path.name}: {len(tables)} bảng -> {out_dir}/")

    xlsx_by_out_dir: dict[Path, list[tuple[Path, Callable[[Path, Path], list[dict]]]]] = {}
    for xlsx_path in xlsx_files:
        out_name, extractor = route_xlsx(xlsx_path)
        out_dir = EXTRACT_DIR / out_name
        xlsx_by_out_dir.setdefault(out_dir, []).append((xlsx_path, extractor))

    for out_dir, entries in xlsx_by_out_dir.items():
        all_tables: list[dict] = []
        for xlsx_path, extractor in entries:
            tables = extractor(xlsx_path, out_dir)
            print(f"[xlsx] {xlsx_path.name}: {len(tables)} sheet -> {out_dir}/")
            all_tables.extend(tables)

        clear_stale_markdown(out_dir, {t["file"] for t in all_tables})
        (out_dir / "_index.json").write_text(
            json.dumps(
                {
                    "sources": sorted({t["source"] for t in all_tables}),
                    "tables": all_tables,
                },
                ensure_ascii=False,
                indent=2,
            ),
            encoding="utf-8",
        )


if __name__ == "__main__":
    main()
