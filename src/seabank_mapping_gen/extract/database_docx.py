"""Extract table/column definitions from a database design .docx file into
the normalized DatabaseDesign model.

NOTE: This is a skeleton. The actual table layout in the real .docx template
needs to be inspected before the parsing logic below can be finalized —
run against a sample file and adjust `_parse_table` to match the real
column order/headings.
"""

from __future__ import annotations

from pathlib import Path

from docx import Document

from seabank_mapping_gen.models import ColumnDef, DatabaseDesign, TableDef

# Expected header names in each docx table (case-insensitive, adjust to match
# the real template once seen).
EXPECTED_HEADERS = ["column name", "data type", "nullable", "key", "description"]


def extract(docx_path: Path) -> DatabaseDesign:
    document = Document(str(docx_path))
    tables: list[TableDef] = []

    current_table_name = ""
    for table in document.tables:
        table_def = _parse_table(table, current_table_name)
        if table_def is not None:
            tables.append(table_def)

    return DatabaseDesign(source_file=str(docx_path), tables=tables)


def _parse_table(table, fallback_name: str) -> TableDef | None:
    if len(table.rows) < 2:
        return None

    header_cells = [c.text.strip().lower() for c in table.rows[0].cells]
    if not any(h in header_cells for h in EXPECTED_HEADERS):
        return None  # not a column-definition table

    columns: list[ColumnDef] = []
    for row in table.rows[1:]:
        cells = [c.text.strip() for c in row.cells]
        if not any(cells):
            continue
        columns.append(_row_to_column(header_cells, cells))

    return TableDef(table_name=fallback_name or "UNKNOWN", columns=columns)


def _row_to_column(headers: list[str], cells: list[str]) -> ColumnDef:
    values = dict(zip(headers, cells))
    return ColumnDef(
        name=values.get("column name", ""),
        data_type=values.get("data type", ""),
        nullable=values.get("nullable", "").lower() not in ("n", "no", "false"),
        is_primary_key="pk" in values.get("key", "").lower(),
        is_foreign_key="fk" in values.get("key", "").lower(),
        description=values.get("description", ""),
    )
