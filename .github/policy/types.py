"""Shared policy contracts; runtime code validates every external value."""

from dataclasses import dataclass


@dataclass(frozen=True)
class RepositoryPolicy:
    """Immutable license and explicit artifact exceptions for one repository."""

    license: str
    allowed_vendor_archives: frozenset[str]
    allowed_source_files: frozenset[str]
