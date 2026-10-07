"""Forge diagnostics contracts."""
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
    def test_trusted_viewer_escapes_content_and_shows_semantic_comparison(self):
        manifest = fixture_manifest(
            title="{{SCRIPT}}</h2><script>alert(1)</script>",
            status="changed",
            scene=True,
            metrics={"scene_build_p50_ns": 1_500_000, "bitmap_storage_bytes": 4096},
        )
        viewer = support.trusted_index(manifest).decode()
        self.assertIn(r"{{SCRIPT}}\u003c/h2>\u003cscript>alert(1)\u003c/script>", viewer)
        self.assertNotIn("</h2><script>alert(1)</script>", viewer)
        self.assertIn("Current capture", viewer)
        self.assertIn("Before baseline", viewer)
        self.assertIn("Exact RGBA differences in red", viewer)
        self.assertIn("Before/current wipe position", viewer)
        self.assertIn("Play timeline", viewer)
        self.assertIn("Step next · timestamps need steps", viewer)
        self.assertIn("checkpoint.pixels_changed === false", viewer)
        self.assertIn("checkpoint.before_time_ns", viewer)
        self.assertIn("Timestamps are equal, descending, or unavailable", viewer)
        self.assertIn("next.time_ns - current.time_ns", viewer)
        self.assertIn("Before: ${beforeImg ? imageSize(beforeImg)", viewer)
        self.assertIn("Captured scene JSON (gzip)", viewer)
        self.assertIn('href="metrics.svg"', viewer)
        self.assertIn("metrics.bitmap_storage_bytes", viewer)
        self.assertIn("metrics.scene_build_p50_ns", viewer)
        self.assertIn("doc.createElement", viewer)
        self.assertIn("node.textContent", viewer)
        self.assertIn(r"\u003c", viewer)
        self.assertNotIn("innerHTML", viewer)
        self.assertNotIn("fetch(", viewer)
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
