"""Validate manifest licenses even when Python assertion optimization is enabled."""

import json
import tomllib
from pathlib import Path
from typing import cast

from .config import object_fields
from .types import RepositoryPolicy


def require_license(value: object, policy: RepositoryPolicy) -> None:
    """A runtime comparison cannot be disabled by python -O or PYTHONOPTIMIZE."""
    if value != policy.license:
        raise ValueError("Manifest license disagrees with OSS policy")


def check_manifests(root: Path, policy: RepositoryPolicy) -> None:
    """Honor existing Cargo, npm and Python license declarations."""
    npm = root / "package.json"
    if npm.is_file():
        fields = object_fields(cast(object, json.loads(npm.read_text())), "package.json")
        require_license(fields.get("license"), policy)
    for name in ("Cargo.toml", "pyproject.toml"):
        path = root / name
        if not path.is_file():
            continue
        document = object_fields(cast(object, tomllib.loads(path.read_text())), name)
        package = object_fields(document.get("package", document.get("project", {})), name)
        if "name" not in package:
            continue
        value = package.get("license")
        if isinstance(value, dict):
            value = object_fields(value, "license").get("text")
        require_license(value, policy)
