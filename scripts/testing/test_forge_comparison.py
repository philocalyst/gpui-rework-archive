"""Forge comparison contracts."""
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
    def test_exact_and_visible_difference_metadata_and_heatmap_asset(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary) / "report"
            manifest = fixture_manifest(status="changed", pixel=True)
            checkpoint = manifest["scenarios"][0]["checkpoints"][0]
            checkpoint.update(
                before_time_ns=10,
                heatmap_png="gallery/initial.heatmap.png",
                difference={
                    "changed_pixels": 10, "total_pixels": 64000,
                    "max_channel_error": 255, "mean_channel_error": 12.5,
                    "bounds": {"x": 2, "y": 3, "width": 4, "height": 5},
                    "visible": {"changed_pixels": 3, "max_channel_error": 120.5, "mean_channel_error": 22.25},
                    "size_changed": False,
                },
            )
            write_report(root, manifest)
            loaded, report_root = support.load_report(root)
            assets = support.report_assets(loaded, report_root)
            self.assertIn("gallery/initial.heatmap.png", assets)
            viewer = support.trusted_index(loaded).decode()
            self.assertIn('differenceText("CPU vs baseline"', viewer)
            self.assertIn("some exact changes have no visible color or alpha error", viewer)
            self.assertIn("before_time_ns", viewer)
            self.assertIn("Visible magnitude heatmap", viewer)

            checkpoint["heatmap_png"] = "gallery/another.heatmap.png"
            (root / "manifest.json").write_text(json.dumps(manifest), encoding="utf-8")
            with self.assertRaisesRegex(ValueError, "heatmap_png must be"):
                support.load_report(root)

            checkpoint["heatmap_png"] = "gallery/initial.heatmap.png"
            checkpoint["difference"]["visible"]["mean_channel_error"] = float("nan")
            (root / "manifest.json").write_text(json.dumps(manifest), encoding="utf-8")
            with self.assertRaisesRegex(ValueError, "visible mean_channel_error"):
                support.load_report(root)

    def test_motion_metadata_requires_adjacent_matched_frames_and_valid_statistics(self):
        def manifest_with_motion():
            manifest = fixture_manifest(status="unchanged")
            checkpoints = manifest["scenarios"][0]["checkpoints"]
            previous = checkpoints[0]
            previous.update(time_ns=10, before_time_ns=100)
            current = copy.deepcopy(previous)
            current.update(
                id="next", name="Next", time_ns=30, before_time_ns=140,
                status="changed", scene_json="gallery/next.scene.json", png="gallery/next.png",
                motion={
                    "previous_checkpoint_id": "initial", "before_duration_ns": 40,
                    "current_duration_ns": 20,
                    "diff_png": "gallery/next.motion.diff.png",
                    "heatmap_png": "gallery/next.motion.heatmap.png",
                    "difference": {
                        "total_pixels": 64000, "changed_pixels": 100,
                        "max_channel_error": 510, "mean_channel_error": 17.25,
                        "bounds": {"x": 4, "y": 5, "width": 10, "height": 12},
                    },
                },
            )
            checkpoints.append(current)
            return manifest

        def load(candidate):
            with tempfile.TemporaryDirectory() as temporary:
                root = Path(temporary) / "report"
                write_report(root, candidate)
                return support.load_report(root)[0]

        manifest = manifest_with_motion()
        loaded = load(manifest)
        motion = loaded["scenarios"][0]["checkpoints"][1]["motion"]
        self.assertEqual(motion["difference"]["max_channel_error"], 510)
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary) / "report"
            write_report(root, manifest)
            loaded, report_root = support.load_report(root)
            assets = support.report_assets(loaded, report_root)
            self.assertIn("gallery/next.motion.diff.png", assets)
            self.assertIn("gallery/next.motion.heatmap.png", assets)
            self.assertIn(b"[Transition red](gallery/next.motion.diff.png)", assets["report.md"])
            self.assertIn(b"Transition error: 100/64000", assets["report.md"])
        viewer = support.trusted_index(loaded).decode()
        self.assertIn("Transition error · previous frame", viewer)
        self.assertIn("pixels_changed === false ? 0", viewer)

        malformed = [
            (lambda m: m["scenarios"][0]["checkpoints"][1]["motion"].update(previous_checkpoint_id="other"), "immediately previous"),
            (lambda m: m["scenarios"][0]["checkpoints"][1]["motion"].update(current_duration_ns=19), "durations must match"),
            (lambda m: m["scenarios"][0]["checkpoints"][1]["motion"]["difference"].update(changed_pixels=64001), "exceeds total_pixels"),
            (lambda m: m["scenarios"][0]["checkpoints"][1]["motion"]["difference"].update(max_channel_error=510.1), "between 0 and 510"),
            (lambda m: m["scenarios"][0]["checkpoints"][1]["motion"]["difference"].update(mean_channel_error=float("nan")), "between 0 and 510"),
            (lambda m: m["scenarios"][0]["checkpoints"][1]["motion"]["difference"].update(bounds={"x": 1, "y": 1, "width": 320, "height": 201}), "bounds area exceeds total_pixels"),
            (lambda m: m["scenarios"][0]["checkpoints"][1]["motion"].update(diff_png="gallery/wrong.png"), "motion diff_png must be"),
            (lambda m: m["scenarios"][0]["checkpoints"][1]["motion"]["difference"].update(changed_pixels=0), "requires changed pixels"),
        ]
        for mutate, message in malformed:
            with self.subTest(message=message):
                candidate = manifest_with_motion()
                mutate(candidate)
                with self.assertRaisesRegex(ValueError, message):
                    load(candidate)

        resized = manifest_with_motion()
        resized["scenarios"][0]["checkpoints"][1]["motion"]["difference"]["bounds"] = {"x": 319, "y": 199, "width": 2, "height": 2}
        self.assertEqual(load(resized)["scenarios"][0]["checkpoints"][1]["motion"]["difference"]["bounds"]["width"], 2)

        equal_time = manifest_with_motion()
        frames = equal_time["scenarios"][0]["checkpoints"]
        frames[0].update(time_ns=30, before_time_ns=140)
        frames[1]["motion"].update(before_duration_ns=0, current_duration_ns=0)
        self.assertEqual(load(equal_time)["scenarios"][0]["checkpoints"][1]["motion"]["current_duration_ns"], 0)

        candidate = manifest_with_motion()
        candidate["scenarios"][0]["checkpoints"][1]["status"] = "new"
        with self.assertRaisesRegex(ValueError, "matched baseline/current"):
            load(candidate)

    def test_motion_only_frames_lead_shared_forge_previews(self):
        manifest = add_native_replay(fixture_manifest(status="unchanged"))
        scenario = manifest["scenarios"][0]
        first = scenario["checkpoints"][0]
        motion = copy.deepcopy(first)
        motion.update(id="motion", name="Motion only", status="unchanged", pixels_changed=False)
        motion.pop("native")
        motion["motion"] = {
            "previous_checkpoint_id": "initial", "before_duration_ns": 1, "current_duration_ns": 1,
            "diff_png": "gallery/motion.motion.diff.png", "heatmap_png": "gallery/motion.motion.heatmap.png",
            "difference": {"total_pixels": 64000, "changed_pixels": 12, "max_channel_error": 9,
                           "mean_channel_error": 1.5, "bounds": None},
        }
        changed = copy.deepcopy(first)
        changed.update(id="changed", name="Changed", status="changed")
        scenario["checkpoints"] = [first, motion, changed]
        previews = support.preview_checkpoints(manifest, True)
        self.assertEqual([checkpoint["id"] for _scenario, checkpoint in previews], ["motion", "changed", "initial"])
        self.assertIn("Transition error: 12/64000", support.checkpoint_preview_text(motion))

    def test_native_replay_validation_rejects_paths_and_pixel_error_out_of_range(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            manifest = add_native_replay(fixture_manifest())
            checkpoint = manifest["scenarios"][0]["checkpoints"][0]
            checkpoint["native"]["png"] = "https://example.invalid/native.png"
            (root / "manifest.json").write_text(json.dumps(manifest), encoding="utf-8")
            with self.assertRaisesRegex(ValueError, "report path"):
                support.load_report(root)

            checkpoint["native"]["png"] = "gallery/initial.native.png"
            checkpoint["native"]["difference"]["total_pixels"] = 64001
            (root / "manifest.json").write_text(json.dumps(manifest), encoding="utf-8")
            with self.assertRaisesRegex(ValueError, "total_pixels"):
                support.load_report(root)

            checkpoint["native"]["difference"]["total_pixels"] = 64000
            checkpoint["native"]["difference"]["mean_channel_error"] = float("nan")
            (root / "manifest.json").write_text(json.dumps(manifest), encoding="utf-8")
            with self.assertRaisesRegex(ValueError, "finite"):
                support.load_report(root)

    def test_native_timestamp_reason_matches_optional_gpu_timings(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            manifest = add_native_replay(fixture_manifest())
            manifest["native_replay"]["timestamp_reason"] = "adapter does not expose timestamp queries"
            manifest["scenarios"][0]["checkpoints"][0]["native"]["metrics"]["gpu"] = None
            write_report(root, manifest)
            loaded, _root = support.load_report(root)
            self.assertIn("unavailable:", support.markdown_metrics_table(loaded))

            manifest["scenarios"][0]["checkpoints"][0]["native"]["metrics"]["gpu"] = {
                "p50_ns": 800_000, "p95_ns": 900_000, "p99_ns": 1_000_000,
            }
            (root / "manifest.json").write_text(json.dumps(manifest), encoding="utf-8")
            with self.assertRaisesRegex(ValueError, "conflicts"):
                support.load_report(root)

    def test_supported_adapter_may_have_a_clear_only_checkpoint_without_gpu_timings(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            manifest = add_native_replay(fixture_manifest())
            checkpoint = manifest["scenarios"][0]["checkpoints"][0]
            checkpoint["native"]["metrics"]["gpu"] = None
            write_report(root, manifest)
            loaded, _report_root = support.load_report(root)
            table = support.markdown_metrics_table(loaded)
            self.assertIn("GPU timestamps: available", table)
            self.assertIn("n/a/n/a/n/a", table)

    def test_native_timing_requires_samples_and_monotonic_percentiles(self):
        manifest = add_native_replay(fixture_manifest())
        metrics = manifest["scenarios"][0]["checkpoints"][0]["native"]["metrics"]
        metrics["samples"] = 0
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            (root / "manifest.json").write_text(json.dumps(manifest), encoding="utf-8")
            with self.assertRaisesRegex(ValueError, "samples must be greater"):
                support.load_report(root)

            metrics["samples"] = 1
            metrics["encode_submit_completion"]["p50_ns"] = 2_000_000
            (root / "manifest.json").write_text(json.dumps(manifest), encoding="utf-8")
            with self.assertRaisesRegex(ValueError, "must be monotonic"):
                support.load_report(root)

    def test_platform_checks_are_validated_and_rendered_as_escaped_summary(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            manifest = add_platform_checks(fixture_manifest())
            write_report(root, manifest)
            loaded, _report_root = support.load_report(root)
            viewer = support.trusted_index(loaded).decode()
            self.assertIn(r"Linux \u003crunner>", viewer)
            self.assertIn(r"window \u003cvisible>", viewer)
            self.assertIn("checks.frame.capture_width", viewer)
            summary = support.markdown_metrics_table(loaded)
            self.assertIn("Platform integration checks", summary)
            self.assertIn("native visibility", summary)
            self.assertIn("painted pixels", summary)

            manifest["platform_checks"]["capabilities"]["focus_handle"] = "yes"
            (root / "manifest.json").write_text(json.dumps(manifest), encoding="utf-8")
            with self.assertRaisesRegex(ValueError, "capability values"):
                support.load_report(root)

            manifest = add_platform_checks(fixture_manifest())
            manifest["platform_checks"]["frame"]["painted_pixels"] = 64001
            (root / "manifest.json").write_text(json.dumps(manifest), encoding="utf-8")
            with self.assertRaisesRegex(ValueError, "painted_pixels"):
                support.load_report(root)

    def test_missing_or_malformed_metrics_render_as_na(self):
        self.assertIsNone(support.metric({"metrics": {}}, "cpu_render_p50_ns"))
        self.assertIsNone(support.metric({"metrics": "invalid"}, "frame_count"))
        self.assertIsNone(support.metric({"metrics": {"frame_count": True}}, "frame_count"))
        self.assertEqual(support.format_ms(None), "n/a")
