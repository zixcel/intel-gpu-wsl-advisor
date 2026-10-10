"""Check community files, manifest licenses and tracked artifacts."""

import subprocess
from pathlib import Path

from policy.config import read_policy
from policy.files import check_tracked_paths
from policy.manifests import check_manifests

REQUIRED = (
    "LICENSE", "NOTICE", "CONTRIBUTING.md", "CODE_OF_CONDUCT.md", "SECURITY.md",
    ".github/pull_request_template.md", ".github/ISSUE_TEMPLATE/config.yml",
)


def main() -> None:
    """Run inside the explicit repository; never resolve sibling source trees."""
    missing = [name for name in REQUIRED if not Path(name).is_file()]
    if missing:
        raise ValueError("Missing policy files: " + ", ".join(missing))
    policy = read_policy(Path(".github/oss-policy.json"), declared_license=True)
    files = subprocess.check_output(["git", "ls-files", "-z"]).decode().split("\0")
    check_tracked_paths(files, policy)
    check_manifests(Path.cwd(), policy)
    print("Repository community, license, and artifact policy checks passed.")


if __name__ == "__main__":
    try:
        main()
    except (ValueError, OSError, subprocess.CalledProcessError) as error:
        raise SystemExit(str(error)) from None
