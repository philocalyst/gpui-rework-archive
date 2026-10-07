"""Forge viewer contracts."""
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

class ForgeAdapterTests(unittest.TestCase):
    def test_github_api_supports_ghe_api_and_server_urls_with_mock_http(self):
        seen = {}

        def fake_urlopen(request, timeout):
            seen["request"] = request
            seen["timeout"] = timeout
            return Response(b'{"ok":true}')

        with patch.dict("os.environ", {"GITHUB_API_URL": "https://github.enterprise/api/v3", "GITHUB_SERVER_URL": "https://github.enterprise"}), patch.object(support.common, "urlopen", side_effect=fake_urlopen):
            result = github_report.api("POST", "repos/owner/repo/issues/8/comments", "secret", {"body": "report"})
            server_url = github_report.github_server_url()
        self.assertEqual(result, {"ok": True})
        self.assertEqual(seen["request"].full_url, "https://github.enterprise/api/v3/repos/owner/repo/issues/8/comments")
        self.assertEqual(server_url, "https://github.enterprise")
        self.assertEqual(json.loads(seen["request"].data), {"body": "report"})

    def test_pages_registry_accepts_newline_wrapped_base64_from_github(self):
        sha = "a" * 40
        registry = json.dumps([{"sha": sha, "pr": 17}]).encode()
        wrapped = base64.b64encode(registry).decode()
        wrapped = "\n".join(wrapped[index:index + 12] for index in range(0, len(wrapped), 12))

        def fake_api(method, endpoint, token, payload=None):
            if endpoint.endswith("git/trees/tree"):
                return {"tree": [{"path": "runs.json", "type": "blob", "sha": "registry"}]}
            if endpoint.endswith("git/blobs/registry"):
                return {"encoding": "base64", "content": wrapped}
            raise AssertionError(f"unexpected API call: {endpoint}")

        with patch.object(github_report, "api", side_effect=fake_api):
            self.assertEqual(github_report._read_registry("owner/repo", "tree", "token"), [{"sha": sha, "pr": "17"}])

        bad_registry = base64.b64encode(json.dumps([{"sha": sha, "pr": True}]).encode()).decode()

        def bad_api(method, endpoint, token, payload=None):
            if endpoint.endswith("git/trees/tree"):
                return {"tree": [{"path": "runs.json", "type": "blob", "sha": "registry"}]}
            return {"encoding": "base64", "content": bad_registry}

        with patch.object(github_report, "api", side_effect=bad_api), self.assertRaisesRegex(ValueError, "invalid entry"):
            github_report._read_registry("owner/repo", "tree", "token")

    def test_gitlab_api_uses_private_token_with_mock_http(self):
        seen = {}

        def fake_urlopen(request, timeout):
            seen["request"] = request
            return Response(b'[]')

        with patch.object(support.common, "urlopen", side_effect=fake_urlopen):
            gitlab_report.api("GET", "https://gitlab.example/api/v4/projects/3/merge_requests/9", "secret")
        self.assertEqual(seen["request"].get_header("Private-token"), "secret")

    def test_pages_api_keeps_all_runs_and_updates_root_and_pr_indexes(self):
        old_sha, current_sha = "a" * 40, "b" * 40
        calls = []

        def fake_api(method, endpoint, token, payload=None):
            calls.append((method, endpoint, payload))
            if endpoint.endswith("git/ref/heads/visual-results"):
                return {"object": {"sha": "parent"}}
            if endpoint.endswith("git/commits/parent"):
                return {"tree": {"sha": "tree-parent"}}
            if endpoint.endswith("git/trees/tree-parent"):
                return {"tree": [{"path": "runs.json", "type": "blob", "sha": "registry"}]}
            if endpoint.endswith("git/blobs/registry"):
                data = json.dumps([{"sha": old_sha, "pr": "7"}]).encode()
                return {"encoding": "base64", "content": base64.b64encode(data).decode()}
            if endpoint.endswith("git/trees/tree-parent"):
                return {"tree": [{"path": "runs.json", "type": "blob", "sha": "registry"}]}
            if endpoint.endswith("git/blobs/registry"):
                registry = json.dumps([{"sha": old_sha, "pr": "7"}]).encode()
                return {"encoding": "base64", "content": base64.b64encode(registry).decode()}
            if endpoint.endswith("git/blobs"):
                return {"sha": f"blob-{len(calls)}"}
            if endpoint.endswith("git/trees"):
                return {"sha": "tree-new"}
            if endpoint.endswith("git/commits"):
                return {"sha": "commit-new"}
            return {}

        manifest = fixture_manifest()
        with patch.object(github_report, "api", side_effect=fake_api):
            result = github_report.publish_pages("owner/repo", "visual-results", current_sha, "7", "https://pages.example/site", {
                "gallery/initial.png": PNG,
                "gallery/copy.png": PNG,
            }, manifest, "token")
        tree_payload = next(payload for method, endpoint, payload in calls if endpoint.endswith("git/trees") and method == "POST")
        entries = {item["path"]: item["sha"] for item in tree_payload["tree"]}
        self.assertIn(f"runs/{current_sha}/gallery/initial.png", entries)
        self.assertEqual(entries[f"runs/{current_sha}/gallery/initial.png"], entries[f"runs/{current_sha}/gallery/copy.png"])
        self.assertIn("index.html", entries)
        self.assertIn("pulls/7/index.html", entries)
        self.assertIn("runs.json", entries)
        patch_payload = next(payload for method, endpoint, payload in calls if method == "PATCH")
        self.assertFalse(patch_payload["force"])
        self.assertEqual(result, f"https://pages.example/site/runs/{current_sha}/index.html")
        png_blob_posts = [payload for method, endpoint, payload in calls
                          if method == "POST" and endpoint.endswith("git/blobs")
                          and payload.get("content") == base64.b64encode(PNG).decode()]
        self.assertEqual(len(png_blob_posts), 1, "identical asset bytes should be uploaded only once")
        registry = None
        for method, endpoint, payload in calls:
            if method != "POST" or not endpoint.endswith("git/blobs") or not isinstance(payload, dict):
                continue
            try:
                candidate = json.loads(base64.b64decode(payload["content"]))
            except (ValueError, UnicodeDecodeError):
                continue
            if isinstance(candidate, list):
                registry = candidate
                break
        self.assertEqual([item["sha"] for item in registry], [old_sha, current_sha])

    def test_github_comment_reports_scene_only_and_missing_metrics(self):
        manifest = fixture_manifest(title="<img>", metrics=None)
        manifest["scenarios"][0]["checkpoints"][0]["metrics"] = {"bitmap_storage_bytes": 4096}
        changes = [{
            "kind": "scene_changed", "label": "Scene-only change", "scenario_id": "gallery",
            "checkpoint_id": "initial", "subject": "gallery/initial", "detail": "serialized scene differs",
        }]
        comment = github_report.make_comment("owner/repo", "7", "42", "d" * 40, manifest, "https://pages.example/runs/sha/index.html", changes, True)
        self.assertIn("Scene-only change", comment)
        self.assertIn("gallery/initial", comment)
        self.assertIn("&lt;img&gt;", comment)
        self.assertIn("![Timing graph](https://pages.example/runs/sha/metrics.svg)", comment)
        self.assertIn("Bitmap bytes", comment)
        self.assertIn("4096", comment)
        self.assertNotIn("GPU memory", comment)
        self.assertIn("| n/a |", comment)
        self.assertIn("n/a", comment)
        self.assertNotIn("0.00 ms", comment)

    def test_forge_comment_metrics_table_caps_rows_and_keeps_changes_and_slowest(self):
        manifest = fixture_manifest(status="unchanged")
        checkpoints = []
        for index in range(60):
            checkpoint = copy.deepcopy(manifest["scenarios"][0]["checkpoints"][0])
            checkpoint.update(id=f"frame-{index:02d}", name=f"Frame {index:02d}",
                              scene_json=f"gallery/frame-{index:02d}.scene.json", png=f"gallery/frame-{index:02d}.png",
                              metrics={"frame_count": 1, "cpu_render_p95_ns": index * 1_000_000})
            checkpoints.append(checkpoint)
        checkpoints[58]["motion"] = {"difference": {"changed_pixels": 10}}
        checkpoints[59]["status"] = "changed"
        checkpoints[0]["status"] = "new"
        manifest["scenarios"][0]["checkpoints"] = checkpoints
        markdown = support.markdown_metrics_table(manifest, limit=20)
        self.assertIn("Showing 20 of 60 CPU checkpoints", markdown)
        self.assertIn("Frame 59", markdown)
        self.assertIn("Frame 58", markdown)
        self.assertIn("Frame 57", markdown)
        self.assertNotIn("Frame 00", markdown)
        changes = [{
            "label": "Pixels changed", "subject": f"gallery/frame-{index:02d}",
            "detail": ("long generated detail " + str(index) + " ") * 100,
        } for index in range(300)]
        comment = github_report.make_comment("owner/repo", "7", "42", "d" * 40, manifest, None, changes, True)
        self.assertLess(len(comment.encode()), 65_000)
        self.assertIn("300 baseline changes", comment)
        self.assertIn("275 more change details omitted", comment)
        self.assertIn("gallery/frame-00", comment)
        self.assertNotIn("gallery/frame-25", comment)

    def test_gitlab_comment_previews_motion_only_transition_assets(self):
        sha = "a" * 40
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            manifest = fixture_manifest(status="unchanged")
            checkpoints = manifest["scenarios"][0]["checkpoints"]
            checkpoints[0].update(time_ns=10, before_time_ns=100)
            next_frame = copy.deepcopy(checkpoints[0])
            next_frame.update(id="next", name="Motion only", time_ns=20, before_time_ns=120,
                              scene_json="gallery/next.scene.json", png="gallery/next.png", pixels_changed=False)
            next_frame["motion"] = {
                "previous_checkpoint_id": "initial", "before_duration_ns": 20, "current_duration_ns": 10,
                "diff_png": "gallery/next.motion.diff.png", "heatmap_png": "gallery/next.motion.heatmap.png",
                "difference": {"total_pixels": 64000, "changed_pixels": 90, "max_channel_error": 30,
                               "mean_channel_error": 4.5, "bounds": None},
            }
            checkpoints.append(next_frame)
            write_report(root / "visual-report", manifest)
            env = {
                "GITLAB_API_TOKEN": "token", "CI_API_V4_URL": "https://gitlab.example/api/v4",
                "CI_PROJECT_ID": "group/project", "CI_MERGE_REQUEST_IID": "9", "CI_COMMIT_SHA": sha,
                "GPUI_GITLAB_BOT_USERNAME": "gpui-bot", "GPUI_VISUAL_REPORT_URL": "https://gitlab.example/job/report/index.html",
            }
            updated = {}
            def fake_api(method, endpoint, _token, payload=None):
                if "/notes?" in endpoint:
                    return [{"id": 8, "author": {"username": "gpui-bot"}, "body": gitlab_report.MARKER}]
                if method == "PUT":
                    updated["body"] = payload["body"]
                    return {}
                return {"sha": sha}
            old_cwd = Path.cwd()
            try:
                os.chdir(root)
                with patch.dict("os.environ", env, clear=True), patch.object(gitlab_report, "api", side_effect=fake_api):
                    self.assertEqual(gitlab_report.main(), 0)
            finally:
                os.chdir(old_cwd)
        self.assertIn("Transition error: 90/64000", updated["body"])
        self.assertIn("![Transition mask", updated["body"])
        self.assertIn("https://gitlab.example/job/report/gallery/next.motion.diff.png", updated["body"])
        self.assertIn("https://gitlab.example/job/report/gallery/next.motion.heatmap.png", updated["body"])

    def test_comment_preview_prioritizes_changed_cpu_images_over_earlier_native_diagnostics(self):
        manifest = add_native_replay(fixture_manifest())
        template = manifest["scenarios"][0]["checkpoints"][0]
        checkpoints = []
        for index in range(8):
            checkpoint = copy.deepcopy(template)
            checkpoint.update({
                "id": f"checkpoint-{index}",
                "name": f"Checkpoint {index}",
                "png": f"gallery/checkpoint-{index}.png",
                "scene_json": f"gallery/checkpoint-{index}.scene.json",
                "before_png": None,
                "diff_png": None,
                "status": "unchanged",
            })
            checkpoint["native"].update({
                "png": f"gallery/checkpoint-{index}.native.png",
                "diff_png": f"gallery/checkpoint-{index}.native.diff.png",
            })
            checkpoints.append(checkpoint)

        changed = checkpoints[-1]
        changed.update({
            "status": "changed",
            "before_png": "gallery/checkpoint-7.before.png",
            "diff_png": "gallery/checkpoint-7.diff.png",
        })
        motion_only = checkpoints[6]
        motion_only["pixels_changed"] = False
        motion_only["heatmap_png"] = "gallery/checkpoint-6.heatmap.png"
        motion_only["motion"] = {
            "previous_checkpoint_id": "checkpoint-5", "before_duration_ns": 2_000_000,
            "current_duration_ns": 1_000_000,
            "diff_png": "gallery/checkpoint-6.motion.diff.png",
            "heatmap_png": "gallery/checkpoint-6.motion.heatmap.png",
            "difference": {"total_pixels": 64000, "changed_pixels": 32,
                           "max_channel_error": 80, "mean_channel_error": 2.5, "bounds": None},
        }
        manifest["scenarios"][0]["checkpoints"] = checkpoints
        comment = github_report.make_comment(
            "owner/repo", "7", "42", "d" * 40, manifest,
            "https://pages.example/runs/sha/index.html", [], True,
        )

        self.assertIn("gallery/checkpoint-7.before.png", comment)
        self.assertIn("gallery/checkpoint-7.png", comment)
        self.assertIn("gallery/checkpoint-7.diff.png", comment)
        self.assertIn("gallery/checkpoint-6.png", comment)
        self.assertIn("Transition error: 32/64000", comment)
        self.assertIn("gallery/checkpoint-6.heatmap.png", comment)
        self.assertIn("Transition changes in red", comment)
        self.assertIn("Transition magnitude heatmap", comment)
        self.assertIn("gallery/checkpoint-7.native.png", comment)
        self.assertLess(
            comment.index("gallery/checkpoint-7.before.png"),
            comment.index("gallery/checkpoint-0.native.png"),
        )
        self.assertEqual(comment.count("![Current image]"), 6)
        self.assertIn("2 more checkpoint images are in the [hosted report]", comment)
