"""Falsify receipt acceptance independently of correct model/tick delivery."""
import copy
import unittest

import presentation_audit as audit
import run as original


def animation():
    times = [index * 1_000_000_000 // 60 for index in range(2102)]
    start, end = 5_000_000_000, 35_000_000_000
    subset = [time for time in times if start <= time <= end]
    return {
        "variant": "gpui", "mode": "animation", "repeat": 1,
        "measurement_requested_duration_s": 30,
        "measurement_start_monotonic_ns": start,
        "measurement_end_monotonic_ns": end,
        "present_measurement_window_elapsed_ns": [start, end],
        "first_present_internal_elapsed_ns": 0,
        "first_present_internal_pipe_receipt_monotonic_ns": 0,
        "present_frame_times_elapsed_ns": times,
        "present_frame_times_in_measurement_window_ns": subset,
        "present_frame_count": len(subset),
        "present_observer_overflow": 0,
        "source_and_binary_unchanged": True,
        "animation_work_matched": True,
        "graceful_close": True,
        "renderer_first_present": "host-submit-ack",
        "model_summary_on_close": {},
        "window_title": original.core.EXPECTED_WINDOW_TITLES["gpui"],
        "window_client_geometry": [540, 620],
        "drawable_work_acknowledged": True,
        "full_model_matched": True,
        "ordered_callbacks_matched": True,
    }


class PresentationAudit(unittest.TestCase):
    def test_regular_schedule_passes_without_claiming_visible_ticks(self):
        result = audit.audit_animation(animation())
        self.assertTrue(result["eligible"])
        self.assertFalse(result["cadence_warning"])
        self.assertEqual(result["minimum_host_receipts"], 1798)
        self.assertEqual(result["every_tick_visible"], "not-established")

    def test_original_runner_accepts_starvation_but_independent_audit_rejects_it(self):
        row = animation()
        row["present_frame_times_elapsed_ns"] = [0, 6_000_000_000, 20_000_000_000, 34_000_000_000]
        row["present_frame_times_in_measurement_window_ns"] = row["present_frame_times_elapsed_ns"][1:]
        row["present_frame_count"] = 3
        self.assertTrue(original.accepted(row))
        result = audit.audit_animation(row)
        self.assertFalse(result["eligible"])
        self.assertEqual(result["observed_host_receipts"], 3)
        self.assertTrue(result["cadence_warning"])

    def test_two_frame_count_allowance_has_a_fixed_boundary(self):
        row = animation()
        for remaining in (1798, 1797):
            changed = copy.deepcopy(row)
            removed = len(row["present_frame_times_in_measurement_window_ns"]) - remaining
            del changed["present_frame_times_elapsed_ns"][301:301 + removed]
            changed["present_frame_times_in_measurement_window_ns"] = [
                time for time in changed["present_frame_times_elapsed_ns"]
                if 5_000_000_000 <= time <= 35_000_000_000
            ]
            changed["present_frame_count"] = len(changed["present_frame_times_in_measurement_window_ns"])
            self.assertEqual(audit.audit_animation(changed)["eligible"], remaining == 1798)

    def test_reordered_duplicates_nonintegers_and_booleans_are_rejected(self):
        for replacement in (1, -1, 1.0, True):
            row = animation()
            row["present_frame_times_elapsed_ns"][4] = replacement
            self.assertFalse(audit.audit_animation(row)["eligible"])

    def test_subset_count_window_first_epoch_overflow_and_short_duration_cannot_be_forged(self):
        faults = {
            "present_frame_times_in_measurement_window_ns": [],
            "present_frame_count": 9999,
            "present_measurement_window_elapsed_ns": [5_000_000_000, 34_000_000_000],
            "first_present_internal_elapsed_ns": 1,
            "first_present_internal_pipe_receipt_monotonic_ns": 1,
            "present_observer_overflow": 1,
            "measurement_end_monotonic_ns": 34_999_999_999,
        }
        for key, value in faults.items():
            with self.subTest(key=key):
                row = animation()
                row[key] = value
                self.assertFalse(audit.audit_animation(row)["eligible"])

    def test_cadence_warning_survives_sufficient_counts(self):
        row = animation()
        # Keep the count, but bunch two frames after a real gap.
        row["present_frame_times_elapsed_ns"][500] += 25_000_000
        row["present_frame_times_elapsed_ns"][501] += 10_000_000
        row["present_frame_times_in_measurement_window_ns"] = [
            time for time in row["present_frame_times_elapsed_ns"]
            if 5_000_000_000 <= time <= 35_000_000_000
        ]
        result = audit.audit_animation(row)
        self.assertTrue(result["eligible"])
        self.assertTrue(result["cadence_warning"])
        self.assertEqual(result["gaps_longer_than_two_periods"], 1)

    def test_missing_evidence_fails_and_other_modes_are_explicit(self):
        self.assertFalse(audit.audit_animation({"mode": "animation"})["eligible"])
        self.assertEqual(audit.audit_animation({"mode": "idle"})["status"], "not-applicable")


if __name__ == "__main__":
    unittest.main()
