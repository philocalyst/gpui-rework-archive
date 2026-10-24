#!/usr/bin/env python3
"""Offline regression tests for campaign completeness and workload contracts."""

import importlib.util
import json
import os
from pathlib import Path
import sys
import tempfile
import unittest
from unittest.mock import patch


SCRIPT = Path(__file__).with_name("todo_core.py")
SPEC = importlib.util.spec_from_file_location("todo_benchmark", SCRIPT)
assert SPEC and SPEC.loader
benchmark = importlib.util.module_from_spec(SPEC)
sys.modules[SPEC.name] = benchmark
SPEC.loader.exec_module(benchmark)


def passing_cell(mode: str, variant: str, repeat: int) -> dict:
    row = {
        "mode": mode,
        "variant": variant,
        "repeat": repeat,
        "source_and_binary_unchanged": True,
        "error": None,
        "graceful_close": True,
        "renderer_first_present": {"backend": "fixture"},
        "window_title": benchmark.EXPECTED_WINDOW_TITLES[variant],
        "window_client_geometry": [540, 620],
    }
    if mode == "idle":
        row.update(measurement_window_complete=True, model_summary_on_close={}, present_observer_overflow=0)
    elif mode in ("busy", "heavy"):
        row["interactive_work_matched"] = True
    elif mode == "animation":
        row.update(animation_work_matched=True, present_observer_overflow=0, model_summary_on_close={})
    else:
        row["startup_work_matched"] = True
    return row


class CampaignAuditTests(unittest.TestCase):
    def test_complete_synthetic_campaign_passes(self):
        rows = [
            passing_cell(mode, variant, repeat)
            for mode in ("idle", "busy", "heavy", "animation")
            for variant in ("gpui", "zgui")
            for repeat in (1,)
        ] + [
            passing_cell("startup", variant, 1)
            for variant in ("gpui", "zgui", "gpui-auto")
        ]
        status = benchmark.audit_campaign(rows, repeats=1, startup_repeats=1)
        self.assertTrue(status["capture_complete"])
        self.assertTrue(status["workload_contract_pass"])
        self.assertTrue(status["exit_success"])

    def test_missing_cell_is_incomplete_and_fails(self):
        rows = [
            passing_cell(mode, variant, 1)
            for mode in ("idle", "busy", "heavy", "animation")
            for variant in ("gpui", "zgui")
        ] + [passing_cell("startup", variant, 1) for variant in ("gpui", "zgui", "gpui-auto")]
        rows.pop()
        status = benchmark.audit_campaign(rows, repeats=1, startup_repeats=1)
        self.assertFalse(status["capture_complete"])
        self.assertFalse(status["exit_success"])
        self.assertEqual(status["missing_cells"], [{"mode": "startup", "variant": "gpui-auto", "repeat": 1}])

    def test_duplicate_cell_is_incomplete_and_fails(self):
        rows = [
            passing_cell(mode, variant, 1)
            for mode in ("idle", "busy", "heavy", "animation")
            for variant in ("gpui", "zgui")
        ] + [passing_cell("startup", variant, 1) for variant in ("gpui", "zgui", "gpui-auto")]
        rows.append(dict(rows[0]))
        status = benchmark.audit_campaign(rows, repeats=1, startup_repeats=1)
        self.assertFalse(status["capture_complete"])
        self.assertFalse(status["exit_success"])
        self.assertEqual(status["duplicate_cells"], [{"mode": "idle", "variant": "gpui", "repeat": 1}])

    def test_preflight_source_guard_requires_matching_before_after_and_freeze(self):
        frozen = {"source": "frozen"}
        result = benchmark.attach_fingerprint_guard({}, frozen, frozen, frozen)
        self.assertTrue(result["source_and_binary_unchanged"])
        changed = benchmark.attach_fingerprint_guard({}, frozen, {"source": "changed"}, frozen)
        self.assertFalse(changed["source_and_binary_unchanged"])

    def test_captured_panic_or_missed_work_is_not_success(self):
        rows = [
            passing_cell(mode, variant, 1)
            for mode in ("idle", "busy", "heavy", "animation")
            for variant in ("gpui", "zgui")
        ] + [passing_cell("startup", variant, 1) for variant in ("gpui", "zgui", "gpui-auto")]
        broken = next(row for row in rows if row["mode"] == "animation" and row["variant"] == "gpui")
        broken.update(animation_work_matched=False, graceful_close=False, animation_skipped=None)
        status = benchmark.audit_campaign(rows, repeats=1, startup_repeats=1)
        self.assertTrue(status["capture_complete"])
        self.assertFalse(status["workload_contract_pass"])
        self.assertFalse(status["exit_success"])
        self.assertEqual(status["workload_contract_failures"][0]["variant"], "gpui")

    def test_archived_33_rows_are_complete_but_reveal_known_baseline_failures(self):
        raw_path = os.environ.get("TODO_BENCH_RECORDED_RESULTS")
        if not raw_path:
            self.skipTest("set TODO_BENCH_RECORDED_RESULTS to audit the archived campaign")
        rows = [json.loads(line) for line in Path(raw_path).read_text().splitlines() if line.strip()]
        status = benchmark.audit_campaign(rows, repeats=3, startup_repeats=3)
        self.assertEqual(len(rows), 33)
        self.assertTrue(status["capture_complete"])
        self.assertFalse(status["workload_contract_pass"])
        failures = {(r["mode"], r["variant"], r["repeat"]) for r in status["workload_contract_failures"]}
        self.assertEqual(len(failures), 6)
        self.assertIn(("animation", "gpui", 1), failures)
        self.assertIn(("heavy", "gpui", 1), failures)
        # Exercise the same report/status finalizer used by main(): completed
        # capture stays on disk, contract failure remains explicit and exits 1.
        sizes = {
            name: {"as_built_bytes": 1, "stripped_copy": {"bytes": 1}}
            for name in ("gpui", "zgui")
        }
        with tempfile.TemporaryDirectory() as tmp:
            output = Path(tmp)
            results = output / "results.jsonl"
            results.write_text(Path(raw_path).read_text())
            finalized = benchmark.finalize_campaign(output, results, sizes, rows, 3, 3)
            self.assertEqual(benchmark.campaign_exit_code(finalized), 1)
            self.assertEqual(len(results.read_text().splitlines()), 33)
            self.assertTrue((output / "campaign-status.json").is_file())
            report = (output / "report.md").read_text()
            self.assertIn("Capture complete: **True**", report)
            self.assertIn("Workload contract passed: **False**", report)
            self.assertIn("`animation/gpui/r1`", report)

    def test_child_nonzero_exit_after_close_request_is_not_graceful(self):
        class FakeProc:
            returncode = 1  # Representative GPUI close-panic process status.
            waits = 0

            def poll(self):
                return None if self.waits == 0 else self.returncode

            def wait(self, timeout=None):
                self.waits += 1
                return self.returncode

        class FakeReader:
            def join(self, timeout=None):
                pass

        with tempfile.TemporaryDirectory() as tmp:
            child = object.__new__(benchmark.Child)
            child.proc = FakeProc()
            child.window_id = 7
            child.graceful_close = False
            child.reader = FakeReader()
            child.log = open(Path(tmp) / "child.log", "w")
            with patch.object(benchmark, "send_wm_delete", return_value=True):
                child.close_window(7)
            self.assertFalse(child.graceful_close)
            self.assertEqual(child.proc.returncode, 1)


if __name__ == "__main__":
    unittest.main()
