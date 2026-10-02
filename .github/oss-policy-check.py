"""Check repository community files, license declarations, and tracked artifacts."""
import json
import subprocess
import tomllib
from pathlib import Path

required = ["LICENSE", "NOTICE", "CONTRIBUTING.md", "CODE_OF_CONDUCT.md", "SECURITY.md",
            ".github/pull_request_template.md", ".github/ISSUE_TEMPLATE/config.yml"]
missing = [name for name in required if not Path(name).is_file()]
if missing:
    raise SystemExit("Missing policy files: " + ", ".join(missing))
files = subprocess.check_output(["git", "ls-files", "-z"]).decode().split("\0")
policy = json.loads(Path(".github/oss-policy.json").read_text())
expected_license = policy["license"]
allowed = policy.get("allowed_vendor_archives", [])
allowed_source = set(policy.get("allowed_source_files", []))
for name in filter(None, files):
    parts = Path(name).parts
    forbidden = parts[0] in {"registration", "state", ".local", ".state", ".data",
        "secrets", "credentials", "target", "node_modules", "dist", "build", "coverage",
        ".cache", ".pytest_cache", ".ruff_cache", ".mypy_cache", ".tox", ".nox", "htmlcov"}
    forbidden |= "node_modules" in parts or "__pycache__" in parts
    forbidden |= name.endswith((".pyc", ".tsbuildinfo", ".tgz")) and name not in allowed
    forbidden |= len(parts) == 1 and name.endswith((".tar.gz", ".zip", ".whl", ".crate", ".profraw", ".profdata"))
    forbidden |= parts[0].startswith(".env") and parts[0] not in {".env.example", ".env.sample", ".env.template"}
    if forbidden and name not in allowed_source:
        raise SystemExit("Excluded local data or generated artifact is tracked: " + name)
if Path("package.json").is_file():
    assert json.loads(Path("package.json").read_text())["license"] == expected_license
for manifest in ["Cargo.toml", "pyproject.toml"]:
    if Path(manifest).is_file():
        doc = tomllib.loads(Path(manifest).read_text())
        package = doc.get("package", doc.get("project", {}))
        if "name" in package:
            license_value = package.get("license")
            if isinstance(license_value, dict):
                license_value = license_value.get("text")
            assert license_value == expected_license, "Manifest license disagrees with OSS policy"
print("Repository community, license, and artifact policy checks passed.")
