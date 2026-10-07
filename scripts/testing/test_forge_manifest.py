"""Forge manifest contracts."""
import base64
import copy
import gzip
import json
import os
import shutil
import subprocess
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch
from xml.parsers import expat
import post_github_report as github_report
import post_gitlab_comment as gitlab_report
import report_support as support
from forge_fixtures import PNG, fixture_manifest, add_native_replay, add_platform_checks, write_report, Response

class ReportSupportTests(unittest.TestCase):
    def test_viewer_module_imports_without_a_document_global(self):
        candidates = [shutil.which("node"), os.environ.get("NODE_BINARY"),
                      "/Users/mileswirht/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/bin/node"]
        node = next((candidate for candidate in candidates if candidate and Path(candidate).is_file()), None)
        if node is None:
            self.skipTest("Node.js is not available")
        source = (Path(__file__).resolve().parents[2] / "crates/gpui_test/assets/report/viewer.js").read_bytes()
        encoded = base64.b64encode(source).decode("ascii")
        command = f'const viewer = await import("data:text/javascript;base64,{encoded}"); if (typeof viewer.renderReport !== "function") process.exit(1);'
        subprocess.run([node, "--input-type=module", "-e", command], check=True, capture_output=True, text=True)

    def test_recorded_report_head_is_optional_but_must_match_when_present(self):
        manifest = fixture_manifest()
        support.validate_report_head(manifest, "a" * 40)
        with self.assertRaisesRegex(ValueError, "expected publication head"):
            support.validate_report_head(manifest, "bad")
        manifest["environment"]["git_sha"] = "A" * 40
        support.validate_report_head(manifest, "a" * 40)
        manifest["environment"]["git_sha"] = "not-a-full-sha"
        with self.assertRaisesRegex(ValueError, "full commit SHA"):
            support.validate_report_head(manifest, "a" * 40)
        manifest["environment"]["git_sha"] = "b" * 40
        with self.assertRaisesRegex(ValueError, "does not match"):
            support.validate_report_head(manifest, "a" * 40)

    def test_paths_reject_traversal_and_platform_separators(self):
        for path in ("../secret.png", "/tmp/image.png", "scenario\\image.png", "gallery/a b.png", "scene.html"):
            with self.subTest(path=path), self.assertRaises(ValueError):
                support.validate_relative(path, (".png",))

    def test_load_report_rejects_duplicate_ids_and_malformed_status(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            manifest = fixture_manifest()
            manifest["scenarios"].append(dict(manifest["scenarios"][0]))
            (root / "manifest.json").write_text(json.dumps(manifest))
            with self.assertRaisesRegex(ValueError, "duplicate"):
                support.load_report(root)
            manifest["scenarios"].pop()
            manifest["scenarios"][0]["checkpoints"][0]["scene_changed"] = "false"
            (root / "manifest.json").write_text(json.dumps(manifest))
            with self.assertRaisesRegex(ValueError, "boolean"):
                support.load_report(root)

            manifest["scenarios"][0]["checkpoints"][0]["scene_changed"] = False
            manifest["changes"] = [{"kind": "mystery", "scenario_id": "gallery", "checkpoint_id": None, "detail": "bad"}]
            (root / "manifest.json").write_text(json.dumps(manifest))
            with self.assertRaisesRegex(ValueError, "unknown kind"):
                support.load_report(root)

            del manifest["changes"]
            (root / "manifest.json").write_text(json.dumps(manifest))
            with self.assertRaisesRegex(ValueError, "changes must be a list"):
                support.load_report(root)

    def test_scene_json_raw_and_gzip_assets_are_both_validated_and_linked(self):
        scene = b'{"scene":"compressed"}'
        with tempfile.TemporaryDirectory() as temporary:
            raw_root = Path(temporary) / "raw"
            raw_manifest = fixture_manifest()
            write_report(raw_root, raw_manifest, scene=scene)
            raw, raw_report_root = support.load_report(raw_root)
            self.assertEqual(support.report_assets(raw, raw_report_root)["gallery/initial.scene.json"], scene)
            self.assertIn("gallery/initial.scene.json", support.trusted_index(raw).decode())

            gzip_root = Path(temporary) / "gzip"
            gzip_manifest = fixture_manifest()
            gzip_manifest["scenarios"][0]["checkpoints"][0]["scene_json"] = "gallery/initial.scene.json.gz"
            write_report(gzip_root, gzip_manifest, scene=scene)
            (gzip_root / "gallery/initial.scene.json").unlink(missing_ok=True)
            compressed = gzip.compress(scene, mtime=0)
            (gzip_root / "gallery/initial.scene.json.gz").write_bytes(compressed)
            normalized, gzip_report_root = support.load_report(gzip_root)
            assets = support.report_assets(normalized, gzip_report_root)
            self.assertEqual(assets["gallery/initial.scene.json.gz"], compressed)
            viewer = support.trusted_index(normalized).decode()
            self.assertIn("gallery/initial.scene.json.gz", viewer)
            self.assertIn("Captured scene JSON (gzip)", viewer)

    def test_scene_json_gzip_rejects_invalid_truncated_and_expanded_overlimit(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary) / "report"
            manifest = fixture_manifest()
            manifest["scenarios"][0]["checkpoints"][0]["scene_json"] = "gallery/initial.scene.json.gz"
            write_report(root, manifest)
            (root / "gallery/initial.scene.json").unlink(missing_ok=True)
            compressed_path = root / "gallery/initial.scene.json.gz"
            for payload in (b"not gzip", gzip.compress(b'{"scene":1}')[:-2]):
                compressed_path.write_bytes(payload)
                normalized, report_root = support.load_report(root)
                with self.assertRaisesRegex(ValueError, "gzip is invalid"):
                    support.report_assets(normalized, report_root)

            compressed_path.write_bytes(gzip.compress(b" " * (support.common.MAX_FILE_BYTES + 1), mtime=0))
            normalized, report_root = support.load_report(root)
            with self.assertRaisesRegex(ValueError, "expanded scene JSON exceeds"):
                support.report_assets(normalized, report_root)

    def test_asset_symlinks_are_rejected(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary) / "report"
            root.mkdir()
            (root / "gallery").mkdir()
            outside = Path(temporary) / "outside.png"
            outside.write_bytes(PNG)
            (root / "gallery/initial.png").symlink_to(outside)
            (root / "gallery/initial.scene.json").write_text("{}")
            (root / "manifest.json").write_text(json.dumps(fixture_manifest()))
            manifest, report_root = support.load_report(root)
            with self.assertRaisesRegex(ValueError, "symbolic links"):
                support.report_assets(manifest, report_root)

    def test_manifest_parent_symlink_is_rejected(self):
        with tempfile.TemporaryDirectory() as temporary:
            outer = Path(temporary)
            root = outer / "artifact"
            root.mkdir()
            actual = outer / "actual"
            actual.mkdir()
            (actual / "manifest.json").write_text(json.dumps(fixture_manifest()))
            (root / "visual-report").symlink_to(actual, target_is_directory=True)
            with self.assertRaisesRegex(ValueError, "linked"):
                support.load_report(root)

    def test_asset_parent_symlink_is_rejected(self):
        with tempfile.TemporaryDirectory() as temporary:
            outer = Path(temporary)
            root, outside = outer / "report", outer / "outside"
            root.mkdir()
            (outside / "gallery").mkdir(parents=True)
            (outside / "gallery/initial.png").write_bytes(PNG)
            (outside / "gallery/initial.scene.json").write_text("{}")
            (root / "gallery").symlink_to(outside / "gallery", target_is_directory=True)
            (root / "manifest.json").write_text(json.dumps(fixture_manifest()))
            manifest, report_root = support.load_report(root)
            with self.assertRaisesRegex(ValueError, "symbolic links"):
                support.report_assets(manifest, report_root)

    def test_typed_scene_only_change_and_unchanged_status_are_authoritative(self):
        unchanged = fixture_manifest(status="unchanged")
        changes, baseline_available = support.comparison_summary(unchanged)
        self.assertEqual(changes, [])
        self.assertTrue(baseline_available)

        scene_only = fixture_manifest(
            status="changed",
            scene=True,
            changes=[{
                "kind": "scene_changed", "scenario_id": "gallery", "checkpoint_id": "initial",
                "detail": "serialized scene differs",
            }],
        )
        changes, baseline_available = support.comparison_summary(scene_only)
        self.assertTrue(baseline_available)
        self.assertEqual(changes[0]["label"], "Scene-only change")
        self.assertEqual(changes[0]["subject"], "gallery/initial")

        pixels_and_scene = fixture_manifest(
            status="changed",
            changes=[
                {"kind": "pixels_changed", "scenario_id": "gallery", "checkpoint_id": "initial", "detail": "decoded pixels differ"},
                {"kind": "scene_changed", "scenario_id": "gallery", "checkpoint_id": "initial", "detail": "serialized scene differs"},
            ],
        )
        changes, _ = support.comparison_summary(pixels_and_scene)
        self.assertEqual([change["label"] for change in changes], ["Pixels changed", "Scene and pixels changed"])

    def test_added_removed_and_metadata_changes_are_distinct(self):
        manifest = fixture_manifest(status="changed", changes=[
            {"kind": "scenario_removed", "scenario_id": "old_scene", "checkpoint_id": None, "detail": "removed from suite"},
            {"kind": "scenario_added", "scenario_id": "new_scene", "checkpoint_id": None, "detail": "added to suite"},
            {"kind": "checkpoint_removed", "scenario_id": "gallery", "checkpoint_id": "removed", "detail": "checkpoint removed"},
            {"kind": "checkpoint_added", "scenario_id": "gallery", "checkpoint_id": "added", "detail": "checkpoint added"},
            {"kind": "checkpoint_metadata_changed", "scenario_id": "gallery", "checkpoint_id": "initial", "detail": "timeline changed"},
        ])
        changes, baseline_available = support.comparison_summary(manifest)
        self.assertTrue(baseline_available)
        self.assertEqual(
            [(change["kind"], change["subject"]) for change in changes],
            [
                ("scenario_removed", "old_scene"),
                ("scenario_added", "new_scene"),
                ("checkpoint_removed", "gallery/removed"),
                ("checkpoint_added", "gallery/added"),
                ("checkpoint_metadata_changed", "gallery/initial"),
            ],
        )

    def test_baseline_unavailable_status_and_rust_pixel_policy(self):
        unavailable = fixture_manifest(status="baseline_unavailable")
        changes, baseline_available = support.comparison_summary(unavailable)
        self.assertEqual(changes, [])
        self.assertFalse(baseline_available)

        unchanged = fixture_manifest(status="unchanged")
        # The PNG and scene bytes may differ in encoding or serialization details;
        # the typed Rust comparison is the sole source of change policy.
        self.assertEqual(support.comparison_summary(unchanged), ([], True))

    def test_native_replay_assets_are_optional_diagnostic_data(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            manifest = add_native_replay(fixture_manifest(status="unchanged"))
            write_report(root, manifest)
            loaded, report_root = support.load_report(root)
            assets = support.report_assets(loaded, report_root)
            self.assertIn("gallery/initial.native.png", assets)
            self.assertIn("gallery/initial.native.diff.png", assets)
            self.assertIn("gallery/initial.native.heatmap.png", assets)
            self.assertEqual(support.comparison_summary(loaded), ([], True))

            viewer = support.trusted_index(loaded).decode()
            self.assertIn(r"adapter \u003ctrusted>", viewer)
            self.assertIn("Native GPU replay", viewer)
            self.assertIn("Native minus CPU · exact RGBA changes", viewer)
            self.assertIn("Native minus CPU · visible magnitude heatmap", viewer)
            self.assertIn("Exact red", viewer)
            self.assertIn("Magnitude heatmap", viewer)
            self.assertIn("nativeMetrics.device_allocated_bytes", viewer)
            self.assertIn("CPU captures determine baseline status", viewer)

            table = support.markdown_metrics_table(loaded)
            self.assertIn("Native replay diagnostics", table)
            self.assertIn("GPU timestamps: available", table)
            self.assertIn("0.80 ms/0.90 ms/1.00 ms", table)
            self.assertIn("1.00 ms/1.20 ms/1.30 ms", table)
            self.assertIn("n/a", table)  # Device allocation is unavailable, not zero.
            self.assertIn("native minus CPU", table)
            second = copy.deepcopy(loaded["scenarios"][0]["checkpoints"][0])
            second.update(id="second", name="Second")
            second["native"]["png"] = "gallery/second.native.png"
            second["native"]["diff_png"] = "gallery/second.native.diff.png"
            loaded["scenarios"][0]["checkpoints"].append(second)
            table = support.markdown_metrics_table(loaded)
            native_header = next(line for line in table.splitlines() if "GPU p50/p95/p99" in line)
            self.assertEqual(len(native_header.strip("|").split("|")), 8)
            self.assertEqual(table.count("per checkpoint"), 1)
            self.assertEqual(table.count("allocator unavailable"), 1)
            self.assertIn("12/64000", table)
            self.assertIn("8/0.125", table)
