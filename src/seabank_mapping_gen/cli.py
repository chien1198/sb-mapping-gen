"""CLI entrypoint: extract -> map -> generate, with JSON caching in between.

Usage:
    mapping-gen extract  --database data/input/database_design/foo.docx \\
                          --datamart data/input/datamart_design/bar.xlsx
    mapping-gen build    --database-cache data/cache/database/foo.json \\
                          --datamart-cache data/cache/datamart/bar.json \\
                          --template templates/mapping_template.xlsx \\
                          --output data/output/mapping.xlsx
    mapping-gen run      --database ... --datamart ... --template ... --output ...
"""

from __future__ import annotations

from pathlib import Path

import click

from seabank_mapping_gen.extract import database_docx, datamart_xlsx
from seabank_mapping_gen.generate import generate as generate_xlsx
from seabank_mapping_gen.mapping import build_mapping
from seabank_mapping_gen.models import DatabaseDesign, DatamartDesign
from seabank_mapping_gen.utils.cache import load_json, save_json


@click.group()
def main() -> None:
    """seabank-mapping-gen: generate dim/fact mapping docs from design inputs."""


@main.command()
@click.option("--database", required=True, type=click.Path(exists=True, path_type=Path))
@click.option("--datamart", required=True, type=click.Path(exists=True, path_type=Path))
def extract(database: Path, datamart: Path) -> None:
    """Parse raw docx/xlsx inputs into cached normalized JSON."""
    db_design = database_docx.extract(database)
    db_cache_path = Path("data/cache/database") / f"{database.stem}.json"
    save_json(db_design, db_cache_path)
    click.echo(f"Database design cached -> {db_cache_path}")

    dm_design = datamart_xlsx.extract(datamart)
    dm_cache_path = Path("data/cache/datamart") / f"{datamart.stem}.json"
    save_json(dm_design, dm_cache_path)
    click.echo(f"Datamart design cached -> {dm_cache_path}")


@main.command()
@click.option("--database-cache", required=True, type=click.Path(exists=True, path_type=Path))
@click.option("--datamart-cache", required=True, type=click.Path(exists=True, path_type=Path))
@click.option("--template", required=True, type=click.Path(exists=True, path_type=Path))
@click.option("--output", required=True, type=click.Path(path_type=Path))
def build(database_cache: Path, datamart_cache: Path, template: Path, output: Path) -> None:
    """Build the mapping document from cached JSON and write it to the xlsx template."""
    db_design = load_json(DatabaseDesign, database_cache)
    dm_design = load_json(DatamartDesign, datamart_cache)

    mapping = build_mapping(db_design, dm_design)
    generate_xlsx(mapping, template, output)
    click.echo(f"Mapping document generated -> {output}")


@main.command()
@click.option("--database", required=True, type=click.Path(exists=True, path_type=Path))
@click.option("--datamart", required=True, type=click.Path(exists=True, path_type=Path))
@click.option("--template", required=True, type=click.Path(exists=True, path_type=Path))
@click.option("--output", required=True, type=click.Path(path_type=Path))
def run(database: Path, datamart: Path, template: Path, output: Path) -> None:
    """Run the full pipeline: extract -> build -> generate, in one step."""
    db_design = database_docx.extract(database)
    save_json(db_design, Path("data/cache/database") / f"{database.stem}.json")

    dm_design = datamart_xlsx.extract(datamart)
    save_json(dm_design, Path("data/cache/datamart") / f"{datamart.stem}.json")

    mapping = build_mapping(db_design, dm_design)
    generate_xlsx(mapping, template, output)
    click.echo(f"Mapping document generated -> {output}")


if __name__ == "__main__":
    main()
