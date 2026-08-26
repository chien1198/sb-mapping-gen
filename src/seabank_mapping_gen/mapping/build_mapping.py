"""Combine a normalized DatabaseDesign and DatamartDesign into a MappingDocument.

The datamart design already carries source_table/source_column/transform_logic
per target column (captured from the design doc's own mapping description).
This stage cross-references that against the database design to fill in
source data types and flag anything that doesn't resolve, so gaps are visible
before the mapping is written out to the output template.
"""

from __future__ import annotations

from seabank_mapping_gen.models import DatabaseDesign, DatamartDesign, MappingDocument, MappingRow


def build_mapping(database: DatabaseDesign, datamart: DatamartDesign) -> MappingDocument:
    column_type_index = _index_source_column_types(database)

    rows: list[MappingRow] = []
    for table in datamart.tables:
        for col in table.columns:
            source_type = column_type_index.get((col.source_table.lower(), col.source_column.lower()), "")
            notes = "" if source_type or not col.source_table else "source column not found in database design"

            rows.append(
                MappingRow(
                    target_table=table.table_name,
                    target_column=col.target_column,
                    target_data_type=col.data_type,
                    source_table=col.source_table,
                    source_column=col.source_column,
                    source_data_type=source_type,
                    transform_logic=col.transform_logic,
                    description=col.description,
                    notes=notes,
                )
            )

    return MappingDocument(database=database.source_file, datamart=datamart.source_file, rows=rows)


def _index_source_column_types(database: DatabaseDesign) -> dict[tuple[str, str], str]:
    index: dict[tuple[str, str], str] = {}
    for table in database.tables:
        for col in table.columns:
            index[(table.table_name.lower(), col.name.lower())] = col.data_type
    return index
