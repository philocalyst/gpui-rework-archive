"""Meaningful SemVer and dependency-scope fixtures; no network is used."""
import importlib.util
import io
import json
import pathlib
import unittest
from unittest import mock

SPEC = importlib.util.spec_from_file_location("audit", pathlib.Path(__file__).with_name("audit_dependencies.py"))
audit = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(audit)


class DependencyAuditTests(unittest.TestCase):
    def test_stable_semver_handles_later_old_major_and_build_metadata(self):
        versions = ["0.3.5+spec-1.1.0", "0.4.0", "1.0.0-alpha.1"]
        response = {"crate": {"newest_version": versions[0]}, "versions": [
            {"num": v, "yanked": False, "checksum": "fixture"} for v in versions]}
        with mock.patch.object(audit.urllib.request, "urlopen", return_value=io.BytesIO(json.dumps(response).encode())):
            name, result = audit.latest("fixture")
        self.assertEqual(name, "fixture")
        self.assertEqual(result["latest_stable"], "0.4.0")
        self.assertEqual(audit.version_key("1.1.2+spec-1.1.0"), (1, 1, 2))

    def test_existing_prerelease_family_checks_exact_latest_without_selecting_it_for_stable(self):
        beta = {"latest_stable": None, "latest_release": "0.1.0-beta.10"}
        self.assertEqual(audit.comparison("0.1.0-beta.6", beta), "behind_latest_prerelease_only")
        self.assertEqual(audit.comparison("0.1.0-beta.10", beta), "at_latest_prerelease_only")
        self.assertEqual(audit.comparison("1.0.0-alpha.1", {"latest_stable": "0.4.0"}), "ahead_of_latest_stable")
        self.assertEqual(audit.comparison("1.0.0-beta.1", {"latest_stable": "1.0.0"}), "behind_latest_stable")

    def test_normal_build_closure_keeps_targets_and_excludes_dev_only(self):
        def package(name, source="registry+fixture"):
            return {"id": name, "name": name, "version": "0.3.5", "source": source,
                    "manifest_path": str(audit.ROOT / "Cargo.toml"), "dependencies": []}
        root = package("root", None)
        root["dependencies"] = [
            {"name": "normal", "req": "^0.3", "kind": None, "target": None, "optional": False},
            {"name": "platform", "req": "^0.3", "kind": "build", "target": "cfg(windows)", "optional": False}]
        def edge(name, kind, target=None):
            return {"pkg": name, "dep_kinds": [{"kind": kind, "target": target}]}
        metadata = {"workspace_members": ["root"], "packages": [root, package("normal"), package("platform"), package("dev")],
                    "resolve": {"nodes": [{"id": "root", "deps": [edge("normal", None), edge("platform", "build", "cfg(windows)"), edge("dev", "dev")]},
                                           *[{"id": name, "deps": []} for name in ["normal", "platform", "dev"]]]}}
        cache = {name: {"latest_stable": "0.4.0"} for name in ["normal", "platform"]}
        with mock.patch.object(audit, "latest", side_effect=AssertionError("unexpected network")):
            result = audit.audit(metadata, cache, None)
        rows = {row["name"]: row for row in result["packages"]}
        self.assertEqual(set(rows), {"normal", "platform"})
        self.assertEqual(rows["normal"]["comparison"], "behind_latest_stable")
        self.assertEqual(rows["platform"]["parents"][0]["declarations"][0]["target"], "cfg(windows)")
        self.assertTrue(rows["normal"]["parents"][0]["workspace_direct"])


if __name__ == "__main__":
    unittest.main()
