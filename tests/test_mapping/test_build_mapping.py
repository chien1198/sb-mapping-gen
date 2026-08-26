from seabank_mapping_gen.mapping import build_mapping
from seabank_mapping_gen.models import (
    ColumnDef,
    DatabaseDesign,
    DatamartColumnLogic,
    DatamartDesign,
    DatamartTableDef,
    TableDef,
)


def test_build_mapping_fills_source_data_type_from_database_design():
    database = DatabaseDesign(
        source_file="db.docx",
        tables=[
            TableDef(
                table_name="customer",
                columns=[ColumnDef(name="customer_id", data_type="INT")],
            )
        ],
    )
    datamart = DatamartDesign(
        source_file="dm.xlsx",
        tables=[
            DatamartTableDef(
                table_name="dim_customer",
                table_type="dim",
                columns=[
                    DatamartColumnLogic(
                        target_column="customer_id",
                        source_table="customer",
                        source_column="customer_id",
                    )
                ],
            )
        ],
    )

    mapping = build_mapping(database, datamart)

    assert len(mapping.rows) == 1
    row = mapping.rows[0]
    assert row.source_data_type == "INT"
    assert row.notes == ""


def test_build_mapping_flags_unresolved_source_column():
    database = DatabaseDesign(source_file="db.docx", tables=[])
    datamart = DatamartDesign(
        source_file="dm.xlsx",
        tables=[
            DatamartTableDef(
                table_name="dim_customer",
                columns=[
                    DatamartColumnLogic(
                        target_column="customer_id",
                        source_table="customer",
                        source_column="customer_id",
                    )
                ],
            )
        ],
    )

    mapping = build_mapping(database, datamart)

    assert mapping.rows[0].notes == "source column not found in database design"
