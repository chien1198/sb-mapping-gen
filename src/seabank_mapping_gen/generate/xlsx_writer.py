"""Write a MappingDocument into the standard xlsx mapping template, preserving
the template's existing styles/headers.

NOTE: This is a skeleton. `TEMPLATE_HEADER_ROW` and `START_ROW` must be
confirmed against the real template file in templates/ before this is used
for a real run.
"""

from __future__ import annotations

from pathlib import Path

from openpyxl import load_workbook

from seabank_mapping_gen.models import MappingDocument

TEMPLATE_SHEET_NAME = "Mapping"
START_ROW = 2  # first data row, right after the header row

# Column letter -> MappingRow field, in the order the template expects.
COLUMN_MAP = {
    "A": "target_table",
    "B": "target_column",
    "C": "target_data_type",
    "D": "source_table",
    "E": "source_column",
    "F": "source_data_type",
    "G": "transform_logic",
    "H": "description",
    "I": "notes",
}


def generate(mapping: MappingDocument, template_path: Path, output_path: Path) -> None:
    workbook = load_workbook(str(template_path))
    sheet = workbook[TEMPLATE_SHEET_NAME] if TEMPLATE_SHEET_NAME in workbook.sheetnames else workbook.active

    for i, row in enumerate(mapping.rows):
        row_idx = START_ROW + i
        for col_letter, field_name in COLUMN_MAP.items():
            sheet[f"{col_letter}{row_idx}"] = getattr(row, field_name)

    output_path.parent.mkdir(parents=True, exist_ok=True)
    workbook.save(str(output_path))
