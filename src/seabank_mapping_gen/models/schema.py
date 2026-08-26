"""Intermediate normalized schema shared by extract, mapping, and generate stages.

Raw inputs (docx database design, xlsx datamart design) are parsed once into
these models and cached as JSON under data/cache/. Downstream stages read the
cached JSON instead of re-parsing the original documents, which keeps repeat
runs cheap and deterministic.
"""

from __future__ import annotations

from pydantic import BaseModel, Field


class ColumnDef(BaseModel):
    name: str
    data_type: str
    nullable: bool = True
    is_primary_key: bool = False
    is_foreign_key: bool = False
    references: str | None = None  # "schema.table.column" if FK
    description: str = ""


class TableDef(BaseModel):
    schema_name: str = ""
    table_name: str
    table_type: str = ""  # e.g. "source", "staging", "dim", "fact"
    description: str = ""
    columns: list[ColumnDef] = Field(default_factory=list)


class DatabaseDesign(BaseModel):
    """Normalized form of the source database design (from .docx)."""

    source_file: str
    tables: list[TableDef] = Field(default_factory=list)


class DatamartColumnLogic(BaseModel):
    """One target column in a dim/fact table, with its transform/mapping logic."""

    target_column: str
    data_type: str = ""
    source_table: str = ""
    source_column: str = ""
    transform_logic: str = ""  # free-text business/transform rule from the design doc
    description: str = ""


class DatamartTableDef(BaseModel):
    table_name: str
    table_type: str = ""  # "dim" or "fact"
    grain: str = ""
    description: str = ""
    columns: list[DatamartColumnLogic] = Field(default_factory=list)


class DatamartDesign(BaseModel):
    """Normalized form of the datamart design (from .xlsx), incl. mapping logic."""

    source_file: str
    tables: list[DatamartTableDef] = Field(default_factory=list)


class MappingRow(BaseModel):
    """One row of the final mapping output, matching the target xlsx template."""

    target_table: str
    target_column: str
    target_data_type: str = ""
    source_table: str = ""
    source_column: str = ""
    source_data_type: str = ""
    transform_logic: str = ""
    description: str = ""
    notes: str = ""


class MappingDocument(BaseModel):
    database: str = ""
    datamart: str = ""
    rows: list[MappingRow] = Field(default_factory=list)
