"""Decode untrusted JSON configuration into the dedicated policy contract."""

import json
from pathlib import Path
from typing import cast

from .types import RepositoryPolicy


def object_fields(value: object, context: str) -> dict[str, object]:
    """Reject non-object input instead of relying on unchecked dictionary access."""
    if not isinstance(value, dict) or not all(isinstance(key, str) for key in value):
        raise ValueError(f"{context} must be an object with string keys")
    return cast(dict[str, object], value)


def string_set(value: object, context: str) -> frozenset[str]:
    """Validate exception lists before converting them to immutable sets."""
    if not isinstance(value, list) or not all(isinstance(item, str) for item in value):
        raise ValueError(f"{context} must be an array of strings")
    return frozenset(cast(list[str], value))


def read_policy(path: Path, *, declared_license: bool) -> RepositoryPolicy:
    """Keep the repository's existing license policy and exceptions unchanged."""
    fields = object_fields(cast(object, json.loads(path.read_text())), "OSS policy")
    license_value = fields.get("license") if declared_license else "Apache-2.0"
    if not isinstance(license_value, str) or not license_value.strip():
        raise ValueError("OSS policy license must be a non-empty string")
    return RepositoryPolicy(
        license_value,
        string_set(fields.get("allowed_vendor_archives", []), "allowed_vendor_archives"),
        string_set(fields.get("allowed_source_files", []), "allowed_source_files")
        if declared_license else frozenset(),
    )
