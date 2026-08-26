"""Read/write helpers for the JSON cache that sits between extract and the
later pipeline stages. Caching avoids re-parsing the original docx/xlsx
(and re-spending tokens on them) on every run."""

from __future__ import annotations

import json
from pathlib import Path

from pydantic import BaseModel


def save_json(model: BaseModel, path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(model.model_dump_json(indent=2), encoding="utf-8")


def load_json(model_cls: type[BaseModel], path: Path) -> BaseModel:
    data = json.loads(path.read_text(encoding="utf-8"))
    return model_cls.model_validate(data)


def is_cache_fresh(source_path: Path, cache_path: Path) -> bool:
    """True if cache_path exists and is newer than source_path."""
    if not cache_path.exists():
        return False
    return cache_path.stat().st_mtime >= source_path.stat().st_mtime
