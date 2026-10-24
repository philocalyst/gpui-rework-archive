#!/usr/bin/env python3
"""Keep failed short-trial resources diagnostic and qualified comparisons separate."""

import argparse
import collections
import hashlib
import json
import statistics
from pathlib import Path


def distribution(values):
    numeric = [value for value in values if type(value) in (int, float)]
    if not numeric:
        return None
    return {
        "values": numeric,
        "median": statistics.median(numeric),
        "min": min(numeric),
        "max": max(numeric),
        "sample_stdev": statistics.stdev(numeric) if len(numeric) > 1 else None,
    }


def summarize(rows):
    groups = collections.defaultdict(list)
    for row in rows:
        groups[(row["profile"], row["mode"])].append(row)
    summaries = []
    for (profile, mode), captured in sorted(groups.items()):
        qualified = [row for row in captured if row.get("performance_eligible")]
        entry = {
            "profile": profile,
            "mode": mode,
            "captured": len(captured),
            "qualified": len(qualified),
            "failed_repeats": [
                row["repeat"] for row in captured if not row.get("performance_eligible")
            ],
            "host_receipts": [row.get("present_frame_count") for row in captured],
            "model_ticks": [row.get("animation_ticks") for row in captured],
            "skipped_ticks": [row.get("animation_skipped") for row in captured],
            "host_audit_errors": [
                row.get("host_audit", {}).get("errors", []) for row in captured
            ],
            "long_host_gap_counts": [
                row.get("host_audit", {}).get("gaps_longer_than_two_periods")
                for row in captured
            ],
            "mapped_description_receipts": [row.get("reactivity") for row in captured],
            "final_phase_diagnostics": [
                row.get("coherent_final_phase") for row in captured
            ],
        }
        for field in (
            "process_cpu_percent_one_core_100",
            "pss_kb_peak",
            "rss_kb_peak",
            "private_kb_peak",
        ):
            entry[field] = {
                "qualified": distribution(
                    [row.get("process_metrics", {}).get(field) for row in qualified]
                ),
                "all_raw_diagnostic": distribution(
                    [row.get("process_metrics", {}).get(field) for row in captured]
                ),
            }
        summaries.append(entry)
    return summaries


def raw_comparison_sets(rows):
    comparisons = []
    for mode in ("busy", "animation"):
        for repeat in (1, 2, 3):
            selected = [
                row for row in rows if row["mode"] == mode and row["repeat"] == repeat
            ]
            comparisons.append(
                {
                    "mode": mode,
                    "repeat": repeat,
                    "all_profiles_performance_eligible": len(selected) == 3
                    and all(row.get("performance_eligible") for row in selected),
                    "profiles": {
                        row["profile"]: {
                            "performance_eligible": row.get("performance_eligible"),
                            "cpu_percent_one_core_100": row.get(
                                "process_metrics", {}
                            ).get("process_cpu_percent_one_core_100"),
                            "pss_kib_peak": row.get("process_metrics", {}).get(
                                "pss_kb_peak"
                            ),
                            "rss_kib_peak": row.get("process_metrics", {}).get(
                                "rss_kb_peak"
                            ),
                            "process_cpu_seconds": row.get("process_metrics", {}).get(
                                "process_cpu_s"
                            ),
                            "process_sample_elapsed_s": row.get(
                                "process_metrics", {}
                            ).get("sample_elapsed_s"),
                            "measurement_elapsed_s": row.get("measurement_elapsed_s"),
                            "requested_events": row.get(
                                "interactive_requested_deadline_events"
                            ),
                            "completed_injector_events": row.get(
                                "interactive_completed_injector_events"
                            ),
                            "button_callbacks": (
                                row.get("model_summary_on_close") or {}
                            ).get("callbacks"),
                            "ordered_callbacks_matched": row.get(
                                "ordered_callbacks_matched"
                            ),
                            "full_model_matched": row.get("full_model_matched"),
                            "graceful_close": row.get("graceful_close"),
                            "host_receipts": row.get("present_frame_count"),
                            "model_ticks": row.get("animation_ticks"),
                            "model_skips": row.get("animation_skipped"),
                        }
                        for row in selected
                    },
                }
            )
    return comparisons


def qualified_pair_differences(rows):
    result = []
    for mode in ("busy", "animation"):
        for profile in ("certified", "banked4"):
            pairs = []
            for repeat in (1, 2, 3):
                selected = {
                    row["profile"]: row
                    for row in rows
                    if row["mode"] == mode and row["repeat"] == repeat
                }
                if not all(
                    selected[name].get("performance_eligible")
                    for name in ("original", profile)
                ):
                    continue
                pairs.append((selected["original"], selected[profile]))
            result.append(
                {
                    "mode": mode,
                    "candidate": profile,
                    "qualified_pairs": len(pairs),
                    "cpu_percentage_point_differences": distribution(
                        [
                            candidate["process_metrics"][
                                "process_cpu_percent_one_core_100"
                            ]
                            - original["process_metrics"][
                                "process_cpu_percent_one_core_100"
                            ]
                            for original, candidate in pairs
                        ]
                    ),
                    "cpu_second_differences": distribution(
                        [
                            candidate["process_metrics"]["process_cpu_s"]
                            - original["process_metrics"]["process_cpu_s"]
                            for original, candidate in pairs
                        ]
                    ),
                    "pss_kib_differences": distribution(
                        [
                            candidate["process_metrics"]["pss_kb_peak"]
                            - original["process_metrics"]["pss_kb_peak"]
                            for original, candidate in pairs
                        ]
                    ),
                    "uncertainty_method": "All three repetitions and descriptive sample standard deviation; no significance or population-confidence claim.",
                }
            )
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("capture", type=Path)
    parser.add_argument("output", type=Path)
    args = parser.parse_args()
    args.output.mkdir(parents=True, exist_ok=True)
    results = args.capture / "results.jsonl"
    rows = [json.loads(line) for line in results.read_text().splitlines()]
    controls = [
        json.loads(line)
        for line in (args.capture / "controls.jsonl").read_text().splitlines()
    ]
    summary = {
        "schema": 1,
        "raw_results_sha256": hashlib.sha256(results.read_bytes()).hexdigest(),
        "raw_controls_sha256": hashlib.sha256(
            (args.capture / "controls.jsonl").read_bytes()
        ).hexdigest(),
        "captured_trials": len(rows),
        "qualified_trials": sum(bool(row.get("performance_eligible")) for row in rows),
        "native_controls": len(controls),
        "native_controls_passed": sum(
            bool(row.get("control_passed")) for row in controls
        ),
        "short_windows_only": {"busy_s": 2, "animation_s": 6, "warmup_s": 1},
        "hardware_gpu_and_scanout": "unsupported",
        "failed_resources_are_diagnostic_only": True,
        "groups": summarize(rows),
        "all_raw_interleaved_sets": raw_comparison_sets(rows),
        "qualified_pair_differences": qualified_pair_differences(rows),
        "failed_trial_gates": [
            {
                "profile": row["profile"],
                "mode": row["mode"],
                "repeat": row["repeat"],
                "error": row.get("error"),
                "gates": {
                    key: row.get(key)
                    for key in (
                        "original_runner_accepted",
                        "full_model_matched",
                        "ordered_callbacks_matched",
                        "drawable_work_acknowledged",
                        "graceful_close",
                        "animation_delivery_matches",
                        "animation_count_matches_lifetime",
                        "animation_work_matched",
                        "animation_skipped",
                        "host_audit",
                        "mapped_description_gate",
                        "final_chrome_anchor",
                    )
                },
            }
            for row in rows
            if not row.get("performance_eligible")
        ],
        "static_initial_pixel_diagnostics": [
            {
                "profile": row["profile"],
                "comparison": row.get("initial_static_pixel_comparison"),
            }
            for row in controls
            if row["control"] == "positive"
        ],
    }
    (args.output / "summary.json").write_text(json.dumps(summary, indent=2) + "\n")


if __name__ == "__main__":
    main()
