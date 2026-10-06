import base64
import json
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch
from xml.parsers import expat

import post_github_report as github_report
import post_gitlab_comment as gitlab_report
import report_support as support

PNG = b"\x89PNG\r\n\x1a\nfixture"


def fixture_manifest(*, title="Gallery", metrics=None, status="unchanged", pixel=False, scene=False):
    return {
        "schema_version": 1,
        "backend": "cpu",
        "environment": {"renderer": "gpui-ce-cpu", "font_pack": "bundled", "git_sha": None},
        "scenarios": [{
            "id": "gallery", "title": title, "viewport": {"width": 320, "height": 200, "scale_factor": 1.0},
            "status": status,
            "checkpoints": [{
                "id": "initial", "name": "Initial", "time_ns": 0, "status": status,
                "pixels_changed": pixel, "scene_changed": scene, "metadata_changed": False,
                "scene_json": "gallery/initial.scene.json", "png": "gallery/initial.png",
                "before_png": "gallery/initial.before.png" if status == "changed" else None,
                "diff_png": "gallery/initial.diff.png" if status == "changed" else None,
                "metrics": metrics,
            }],
        }],
    }


def write_report(root: Path, manifest: dict, *, png=PNG, scene=b'{"scene":1}') -> Path:
    root.mkdir(parents=True, exist_ok=True)
    (root / "gallery").mkdir(exist_ok=True)
    (root / "gallery/initial.png").write_bytes(png)
    (root / "gallery/initial.scene.json").write_bytes(scene)
    if manifest["scenarios"][0]["checkpoints"][0].get("before_png"):
        (root / "gallery/initial.before.png").write_bytes(PNG)
        (root / "gallery/initial.diff.png").write_bytes(PNG)
    (root / "manifest.json").write_text(json.dumps(manifest), encoding="utf-8")
    return root


class Response:
    def __init__(self, payload: bytes):
        self.payload = payload

    def __enter__(self):
        return self

    def __exit__(self, *args):
        return False

    def read(self):
        return self.payload


class ReportSupportTests(unittest.TestCase):
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

    def test_scene_only_change_is_separate_and_unchanged_is_quiet(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            old_manifest = fixture_manifest()
            old = write_report(root / "old", old_manifest)
            unchanged = write_report(root / "same", fixture_manifest())
            self.assertEqual(support.compare_manifests(old_manifest, unchanged, old_manifest, old), [])
            changed_manifest = fixture_manifest(status="changed", scene=True)
            changed = write_report(root / "changed", changed_manifest, scene=b'{"scene":2}')
            changes = support.compare_manifests(changed_manifest, changed, old_manifest, old)
            self.assertIn(("scene_changed", "Scene changed gallery/initial"), changes)
            self.assertFalse(any(kind == "pixels_changed" for kind, _ in changes))

    def test_added_removed_and_metadata_changes_are_distinct(self):
        old = fixture_manifest()
        current = fixture_manifest(status="changed")
        old["scenarios"][0]["checkpoints"].append({"id": "removed", "name": "Gone", "time_ns": 0, "scene_json": "gallery/removed.scene.json", "png": "gallery/removed.png"})
        current["scenarios"][0]["checkpoints"][0]["name"] = "Changed label"
        current["scenarios"][0]["checkpoints"].append({"id": "added", "name": "New", "time_ns": 0, "scene_json": "gallery/added.scene.json", "png": "gallery/added.png"})
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            old_root = write_report(root / "old", old)
            current_root = write_report(root / "current", current)
            changes = support.compare_manifests(current, current_root, old, old_root)
        kinds = [kind for kind, _ in changes]
        self.assertIn("checkpoint_removed", kinds)
        self.assertIn("checkpoint_added", kinds)
        self.assertIn("checkpoint_metadata_changed", kinds)

    def test_missing_or_malformed_metrics_render_as_na(self):
        self.assertIsNone(support.metric({"metrics": {}}, "cpu_render_p50_ns"))
        self.assertIsNone(support.metric({"metrics": "invalid"}, "frame_count"))
        self.assertIsNone(support.metric({"metrics": {"frame_count": True}}, "frame_count"))
        self.assertEqual(support.format_ms(None), "n/a")

    def test_trusted_viewer_escapes_content_and_shows_semantic_comparison(self):
        manifest = fixture_manifest(title="</h2><script>alert(1)</script>", status="changed", scene=True)
        viewer = support.trusted_index(manifest).decode()
        self.assertIn("&lt;/h2&gt;&lt;script&gt;", viewer)
        self.assertNotIn("<script>", viewer)
        self.assertIn("<figcaption>Current</figcaption>", viewer)
        self.assertIn("<figcaption>Before</figcaption>", viewer)
        self.assertIn("<figcaption>Difference</figcaption>", viewer)
        self.assertIn("Scene JSON", viewer)
        self.assertIn('src="metrics.svg"', viewer)
        self.assertIn("n/a", viewer)
        self.assertNotIn("<script", viewer)

    def test_svg_filter_removes_scripts_and_links(self):
        source = b'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 12 8"><script>alert(1)</script><a href="https://bad"><text>bad</text></a><text>chart</text><path d="M0 0"/></svg>'
        result = support.sanitize_svg(source).decode()
        self.assertIn("<path", result)
        parsed = expat.ParserCreate(namespace_separator="}")
        elements = []
        parsed.StartElementHandler = lambda tag, attrs: elements.append((tag, attrs))
        parsed.Parse(result.encode(), True)
        self.assertEqual(elements[0][1]["viewBox"], "0 0 12 8")
        self.assertTrue(any(tag == "http://www.w3.org/2000/svg}path" for tag, _attrs in elements))
        self.assertIn("chart", result)
        self.assertNotIn("bad", result)
        self.assertNotIn("script", result)
        self.assertNotIn("href", result)
        self.assertNotIn("https://bad", result)

    def test_svg_filter_rejects_dtd_and_removes_remote_paint(self):
        with self.assertRaisesRegex(ValueError, "DTD"):
            support.sanitize_svg(b'<!DOCTYPE svg [<!ENTITY x "bad">]><svg xmlns="http://www.w3.org/2000/svg"/>')
        result = support.sanitize_svg(b'<svg xmlns="http://www.w3.org/2000/svg"><rect fill="url(https://bad/x)" onclick="alert(1)"/></svg>').decode()
        self.assertNotIn("url(", result)
        self.assertNotIn("onclick", result)
        expat.ParserCreate(namespace_separator="}").Parse(result.encode(), True)

    def test_latest_and_pr_indexes_keep_immutable_run_links(self):
        sha_old, sha_new = "a" * 40, "b" * 40
        records = [{"sha": sha_old, "pr": "7"}, {"sha": sha_new, "pr": "7"}, {"sha": "c" * 40, "pr": "8"}]
        root = support.pages_index(records, "https://pages.example/site").decode()
        pr = support.pull_index(records, "7", "https://pages.example/site").decode()
        self.assertIn("/pulls/7/index.html", root)
        self.assertIn(sha_new, root)
        self.assertIn(sha_old, root)
        self.assertLess(pr.index(sha_new), pr.index(sha_old))


class ForgeAdapterTests(unittest.TestCase):
    def test_github_api_supports_ghe_api_and_server_urls_with_mock_http(self):
        seen = {}

        def fake_urlopen(request, timeout):
            seen["request"] = request
            seen["timeout"] = timeout
            return Response(b'{"ok":true}')

        with patch.dict("os.environ", {"GITHUB_API_URL": "https://github.enterprise/api/v3", "GITHUB_SERVER_URL": "https://github.enterprise"}), patch.object(github_report, "urlopen", side_effect=fake_urlopen):
            result = github_report.api("POST", "repos/owner/repo/issues/8/comments", "secret", {"body": "report"})
            server_url = github_report.github_server_url()
        self.assertEqual(result, {"ok": True})
        self.assertEqual(seen["request"].full_url, "https://github.enterprise/api/v3/repos/owner/repo/issues/8/comments")
        self.assertEqual(server_url, "https://github.enterprise")
        self.assertEqual(json.loads(seen["request"].data), {"body": "report"})

    def test_pages_registry_accepts_newline_wrapped_base64_from_github(self):
        sha = "a" * 40
        registry = json.dumps([{"sha": sha, "pr": "17"}]).encode()
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

    def test_gitlab_api_uses_private_token_with_mock_http(self):
        seen = {}

        def fake_urlopen(request, timeout):
            seen["request"] = request
            return Response(b'[]')

        with patch.object(gitlab_report, "urlopen", side_effect=fake_urlopen):
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
            result = github_report.publish_pages("owner/repo", "visual-results", current_sha, "7", "https://pages.example/site", {"gallery/initial.png": PNG}, manifest, "token")
        tree_payload = next(payload for method, endpoint, payload in calls if endpoint.endswith("git/trees") and method == "POST")
        entries = {item["path"]: item["sha"] for item in tree_payload["tree"]}
        self.assertIn(f"runs/{current_sha}/gallery/initial.png", entries)
        self.assertIn("index.html", entries)
        self.assertIn("pulls/7/index.html", entries)
        self.assertIn("runs.json", entries)
        patch_payload = next(payload for method, endpoint, payload in calls if method == "PATCH")
        self.assertFalse(patch_payload["force"])
        self.assertEqual(result, f"https://pages.example/site/runs/{current_sha}/index.html")
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
        changes = [("scene_changed", "Scene changed gallery/initial")]
        comment = github_report.make_comment("owner/repo", "7", "42", "d" * 40, manifest, "https://pages.example/runs/sha/index.html", changes, True)
        self.assertIn("Scene-only change", comment)
        self.assertIn("&lt;img&gt;", comment)
        self.assertIn("![Timing graph](https://pages.example/runs/sha/metrics.svg)", comment)
        self.assertIn("Bitmap bytes", comment)
        self.assertIn("4096", comment)
        self.assertIn("GPU memory", comment)
        self.assertIn("| n/a |", comment)
        self.assertIn("n/a", comment)
        self.assertNotIn("0.00 ms", comment)

    def test_pages_url_rejects_credentials_and_script_schemes(self):
        for value in ("javascript:alert(1)", "https://user:password@pages.example/site", "https://pages.example/site?query=1"):
            with self.subTest(value=value), self.assertRaises(ValueError):
                github_report.validate_pages_url(value)

    def test_github_and_gitlab_skip_stale_reviews_before_reading_reports(self):
        sha = "e" * 40
        github_env = {"GH_TOKEN": "token", "REPOSITORY": "owner/repo", "PR_NUMBER": "7", "HEAD_SHA": sha, "RUN_ID": "42"}
        with patch.dict("os.environ", github_env, clear=True), patch.object(github_report.sys, "argv", ["publisher", "missing"]), patch.object(github_report, "api", return_value={"head": {"sha": "f" * 40}}) as github_api:
            self.assertEqual(github_report.main(), 0)
        github_api.assert_called_once()

        gitlab_env = {
            "GITLAB_API_TOKEN": "token", "CI_API_V4_URL": "https://gitlab.example/api/v4",
            "CI_PROJECT_ID": "group/subgroup/repo", "CI_MERGE_REQUEST_IID": "9", "CI_COMMIT_SHA": sha,
            "GPUI_GITLAB_BOT_USERNAME": "gpui-bot", "GPUI_VISUAL_REPORT_URL": "https://gitlab.example/job/artifacts",
        }
        with patch.dict("os.environ", gitlab_env, clear=True), patch.object(gitlab_report, "api", return_value={"sha": "f" * 40}) as gitlab_api:
            self.assertEqual(gitlab_report.main(), 0)
        self.assertIn("projects/group%2Fsubgroup%2Frepo/merge_requests/9", gitlab_api.call_args.args[1])
        gitlab_api.assert_called_once()


if __name__ == "__main__":
    unittest.main()
