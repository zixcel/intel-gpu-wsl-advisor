"""Behavioral regression tests for policy enforcement, including optimized Python."""

import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

from policy.config import read_policy
from policy.files import check_tracked_paths
from policy.manifests import check_manifests
from policy.types import RepositoryPolicy


class PolicyTests(unittest.TestCase):
    """Test failure modes rather than duplicating implementation details."""

    def setUp(self) -> None:
        self.policy = RepositoryPolicy("Apache-2.0", frozenset(), frozenset())

    def test_tracked_secret_and_nested_cache_rejected(self) -> None:
        for path in (".env.local", "state/cache.json", "src/node_modules/module.js"):
            with self.subTest(path=path), self.assertRaises(ValueError):
                check_tracked_paths([path], self.policy)

    def test_templates_and_source_are_accepted(self) -> None:
        check_tracked_paths([".env.example", "src/main.rs", "tests/data.json", ""], self.policy)

    def test_archive_exceptions_are_narrow(self) -> None:
        policy = RepositoryPolicy("Apache-2.0", frozenset({"vendor/one.tgz"}), frozenset())
        check_tracked_paths(["vendor/one.tgz"], policy)
        with self.assertRaises(ValueError):
            check_tracked_paths(["vendor/two.tgz"], policy)

    def test_non_apache_license_and_source_exception(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "policy.json"
            path.write_text('{"license":"MIT","allowed_source_files":["build/config.js"]}')
            policy = read_policy(path, declared_license=True)
            self.assertEqual(policy.license, "MIT")
            check_tracked_paths(["build/config.js"], policy)

    def test_invalid_exception_input_rejected(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "policy.json"
            for value in ('"*.tgz"', '[1]', 'null'):
                path.write_text('{"allowed_vendor_archives":' + value + '}')
                with self.subTest(value=value), self.assertRaises(ValueError):
                    read_policy(path, declared_license=False)

    def test_cargo_and_python_manifest_mismatch_rejected(self) -> None:
        for name, section in (("Cargo.toml", "package"), ("pyproject.toml", "project")):
            with tempfile.TemporaryDirectory() as directory:
                root = Path(directory)
                (root / name).write_text(f'[{section}]\nname="fixture"\nlicense="MIT"\n')
                with self.subTest(name=name), self.assertRaises(ValueError):
                    check_manifests(root, self.policy)

    def test_optimized_python_still_rejects_bad_license(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "package.json").write_text('{"license":"MIT"}')
            code = (
                "from pathlib import Path; from policy.manifests import check_manifests; "
                "from policy.types import RepositoryPolicy; "
                "check_manifests(Path(__import__('sys').argv[1]), "
                "RepositoryPolicy('Apache-2.0', frozenset(), frozenset()))"
            )
            result = subprocess.run([sys.executable, "-O", "-c", code, str(root)],
                                    cwd=Path.cwd(), capture_output=True, text=True)
            self.assertNotEqual(result.returncode, 0)
            self.assertIn("Manifest license disagrees", result.stderr)


if __name__ == "__main__":
    unittest.main()
