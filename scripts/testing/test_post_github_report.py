import base64
import copy
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


def fixture_manifest(*, title="Gallery", metrics=None, status="unchanged", pixel=False, scene=False, changes=None):
    return {
        "schema_version": 1,
        "backend": "cpu",
        "environment": {"renderer": "gpui-ce-cpu", "font_pack": "bundled", "git_sha": None},
        "changes": list(changes or []),
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


def add_native_replay(manifest):
    manifest["native_replay"] = {
        "adapter": "adapter <trusted>", "driver": "driver &amp; info", "backend": "Vulkan", "device_type": "Discrete GPU",
        "timestamp_reason": None,
    }
    manifest["scenarios"][0]["checkpoints"][0]["native"] = {
        "png": "gallery/initial.native.png",
        "diff_png": "gallery/initial.native.diff.png",
        "metrics": {
            "samples": 4,
            "encode_submit_completion": {"p50_ns": 1_000_000, "p95_ns": 1_200_000, "p99_ns": 1_300_000},
            "gpu": {"p50_ns": 800_000, "p95_ns": 900_000, "p99_ns": 1_000_000},
            "tracked_owned_bytes": 8192, "device_allocated_bytes": None,
            "allocation_scope": "per checkpoint", "device_allocation_scope": None,
            "allocation_reason": "allocator unavailable",
        },
        "difference": {
            "changed_pixels": 12, "total_pixels": 64000,
            "max_channel_error": 8, "mean_channel_error": 0.125,
        },
    }
    return manifest


def add_platform_checks(manifest):
    manifest["platform_checks"] = {
        "schema_version": 1,
        "platform": "Linux <runner>", "status": "passed",
        "capabilities": {
            "native_visibility": True, "focus_handle": True, "native_render_capture": True,
            "resize_callback": True, "two_window_close": False,
        },
        "events": [{"name": "window <visible>", "polls": 3, "elapsed_ms": 12}],
        "frame": {
            "render_count": 2, "quads": 3, "monochrome_sprites": 1, "subpixel_sprites": 1,
            "polychrome_sprites": 1, "capture_width": 320, "capture_height": 200, "painted_pixels": 12000,
        },
        "resize": {"callback_count": 1, "width": 640.0, "height": 480.0},
        "errors": [],
    }
    return manifest


def write_report(root: Path, manifest: dict, *, png=PNG, scene=b'{"scene":1}') -> Path:
    root.mkdir(parents=True, exist_ok=True)
    (root / "gallery").mkdir(exist_ok=True)
    (root / "gallery/initial.png").write_bytes(png)
    (root / "gallery/initial.scene.json").write_bytes(scene)
    if manifest["scenarios"][0]["checkpoints"][0].get("before_png"):
        (root / "gallery/initial.before.png").write_bytes(PNG)
        (root / "gallery/initial.diff.png").write_bytes(PNG)
    native = manifest["scenarios"][0]["checkpoints"][0].get("native")
    if native:
        (root / native["png"]).write_bytes(PNG)
        (root / native["diff_png"]).write_bytes(PNG)
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
    def test_recorded_report_head_is_optional_but_must_match_when_present(self):
        manifest = fixture_manifest()
        support.validate_report_head(manifest, "a" * 40)
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
            self.assertEqual(support.comparison_summary(loaded), ([], True))

            viewer = support.trusted_index(loaded).decode()
            self.assertIn("adapter &lt;trusted&gt;", viewer)
            self.assertIn("Native GPU replay", viewer)
            self.assertIn("Native minus CPU", viewer)
            self.assertIn("0.80 ms", viewer)  # GPU timings are nanoseconds, converted to milliseconds.
            self.assertIn("8192", viewer)
            self.assertIn("allocator unavailable", viewer)
            self.assertIn("CPU captures determine correctness", viewer)

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
            self.assertIn("Linux &lt;runner&gt;", viewer)
            self.assertIn("window &lt;visible&gt;", viewer)
            self.assertIn("<td>Frame</td>", viewer)
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

    def test_trusted_viewer_escapes_content_and_shows_semantic_comparison(self):
        manifest = fixture_manifest(
            title="</h2><script>alert(1)</script>",
            status="changed",
            scene=True,
            metrics={"scene_build_p50_ns": 1_500_000, "bitmap_storage_bytes": 4096},
        )
        viewer = support.trusted_index(manifest).decode()
        self.assertIn("&lt;/h2&gt;&lt;script&gt;", viewer)
        self.assertNotIn("<script>", viewer)
        self.assertIn("<figcaption>Current</figcaption>", viewer)
        self.assertIn("<figcaption>Before</figcaption>", viewer)
        self.assertIn("<figcaption>Difference</figcaption>", viewer)
        self.assertIn("Scene JSON", viewer)
        self.assertIn('src="metrics.svg"', viewer)
        self.assertIn("<tr><th>Bitmap bytes</th><td>4096</td></tr>", viewer)
        self.assertIn("<tr><th>Scene build p50</th><td>1.50 ms</td></tr>", viewer)
        self.assertIn("n/a", viewer)
        self.assertNotIn("<script", viewer)
        table = support.markdown_metrics_table(manifest)
        self.assertIn("Scene build p50/p95/p99", table)
        self.assertIn("| Bitmap bytes |", table)
        self.assertNotIn("GPU memory", table)
        self.assertIn("4096", table)
        self.assertIn("1.50 ms", table)
        cpu_header = next(line for line in table.splitlines() if line.startswith("| Scenario / checkpoint |"))
        self.assertEqual(len(cpu_header.strip("|").split("|")), 8)
        self.assertIn("changed", table)

    def test_platform_only_report_omits_empty_cpu_table(self):
        manifest = add_platform_checks(fixture_manifest())
        manifest["scenarios"] = []
        manifest["changes"] = []
        table = support.markdown_metrics_table(manifest)
        self.assertNotIn("Scenario / checkpoint", table)
        self.assertIn("Platform integration checks", table)

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

        with patch.dict("os.environ", {"GITHUB_API_URL": "https://github.enterprise/api/v3", "GITHUB_SERVER_URL": "https://github.enterprise"}), patch.object(support, "urlopen", side_effect=fake_urlopen):
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

        with patch.object(support, "urlopen", side_effect=fake_urlopen):
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
        manifest["scenarios"][0]["checkpoints"] = checkpoints
        comment = github_report.make_comment(
            "owner/repo", "7", "42", "d" * 40, manifest,
            "https://pages.example/runs/sha/index.html", [], True,
        )

        self.assertIn("gallery/checkpoint-7.before.png", comment)
        self.assertIn("gallery/checkpoint-7.png", comment)
        self.assertIn("gallery/checkpoint-7.diff.png", comment)
        self.assertIn("gallery/checkpoint-7.native.png", comment)
        self.assertLess(
            comment.index("gallery/checkpoint-7.before.png"),
            comment.index("gallery/checkpoint-0.native.png"),
        )
        self.assertEqual(comment.count("![Current image]"), 6)
        self.assertIn("2 more checkpoint images are in the [hosted report]", comment)

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

    def test_github_rejects_mismatched_report_provenance_before_any_writes(self):
        current_sha = "a" * 40
        calls = []
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary) / "report"
            manifest = fixture_manifest()
            manifest["environment"]["git_sha"] = "b" * 40
            write_report(root, manifest)
            env = {
                "GH_TOKEN": "token", "REPOSITORY": "owner/repo", "PR_NUMBER": "7",
                "HEAD_SHA": current_sha, "RUN_ID": "42", "PAGES_BRANCH": "visual-results",
                "PAGES_URL": "https://pages.example/site",
            }

            def fake_api(method, endpoint, token, payload=None):
                calls.append((method, endpoint))
                return {"head": {"sha": current_sha}}

            with patch.dict("os.environ", env, clear=True), patch.object(github_report.sys, "argv", ["publisher", str(root)]), patch.object(github_report, "api", side_effect=fake_api):
                with self.assertRaisesRegex(ValueError, "does not match"):
                    github_report.main()

        self.assertEqual(calls, [("GET", "repos/owner/repo/pulls/7")])

    def test_gitlab_rejects_mismatched_report_provenance_before_any_writes(self):
        current_sha = "a" * 40
        calls = []
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            report_root = root / "visual-report"
            manifest = fixture_manifest()
            manifest["environment"]["git_sha"] = "b" * 40
            write_report(report_root, manifest)
            env = {
                "GITLAB_API_TOKEN": "token", "CI_API_V4_URL": "https://gitlab.example/api/v4",
                "CI_PROJECT_ID": "group/project", "CI_MERGE_REQUEST_IID": "9", "CI_COMMIT_SHA": current_sha,
                "GPUI_GITLAB_BOT_USERNAME": "gpui-bot", "GPUI_VISUAL_REPORT_URL": "https://gitlab.example/artifacts",
            }

            def fake_api(method, endpoint, token, payload=None):
                calls.append((method, endpoint))
                return {"sha": current_sha}

            old_cwd = Path.cwd()
            try:
                import os
                os.chdir(root)
                with patch.dict("os.environ", env, clear=True), patch.object(gitlab_report, "api", side_effect=fake_api):
                    with self.assertRaisesRegex(ValueError, "does not match"):
                        gitlab_report.main()
            finally:
                os.chdir(old_cwd)

        self.assertEqual(calls, [("GET", "https://gitlab.example/api/v4/projects/group%2Fproject/merge_requests/9")])


if __name__ == "__main__":
    unittest.main()
