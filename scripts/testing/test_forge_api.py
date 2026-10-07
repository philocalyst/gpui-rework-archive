"""Forge api contracts."""
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
