#!/usr/bin/env python3
"""Summarize only qualified rows; retain every rejected row and paired outcome."""

import argparse, collections, hashlib, json, statistics
from pathlib import Path


def main():
    p = argparse.ArgumentParser()
    p.add_argument("capture", type=Path)
    p.add_argument("output", type=Path)
    a = p.parse_args()
    a.output.mkdir(parents=True, exist_ok=True)
    rows = [
        json.loads(s) for s in (a.capture / "results.jsonl").read_text().splitlines()
    ]
    groups = collections.defaultdict(list)
    for row in rows:
        groups[
            (
                row.get("spawn_renderer_policy", row.get("policy", "unknown")),
                row["variant"],
                row["mode"],
            )
        ].append(row)
    summary = []

    def distribution(values):
        values = [
            v for v in values if isinstance(v, (float, int)) and not isinstance(v, bool)
        ]
        return (
            {
                "median": statistics.median(values),
                "min": min(values),
                "max": max(values),
                "values": values,
            }
            if values
            else None
        )

    for (policy, name, mode), rs in sorted(groups.items()):
        good = [r for r in rs if r.get("performance_eligible") is True]
        entry = {
            "policy": policy,
            "variant": name,
            "mode": mode,
            "captured": len(rs),
            "qualified": len(good),
            "failed_repeats": [
                r["repeat"] for r in rs if not r.get("performance_eligible")
            ],
        }
        for field, sub in [
            ("process_cpu_percent_one_core_100", "process_metrics"),
            ("pss_kb_peak", "process_metrics"),
            ("rss_kb_peak", "process_metrics"),
            ("private_kb_peak", "process_metrics"),
            ("warm_page_cache_exec_to_first_present_s", None),
            ("present_frame_count", None),
            ("present_interval_p95_us", None),
        ]:
            entry[field] = distribution(
                [(r.get(sub) or {}).get(field) if sub else r.get(field) for r in good]
            )
        entry["cadence_warning_repeats"] = [
            r["repeat"] for r in rs if r.get("host_audit", {}).get("cadence_warning")
        ]
        entry["maximum_host_gap_ns"] = distribution(
            [r.get("host_audit", {}).get("maximum_internal_gap_ns") for r in good]
        )
        summary.append(entry)
    pairs = []
    for mode in ("busy", "animation"):
        for rep in (1, 2, 3):
            same = [
                r
                for r in rows
                if r.get("spawn_renderer_policy") == "auto"
                and r["mode"] == mode
                and r["repeat"] == rep
            ]
            byname = {r["variant"]: r for r in same}
            eligible = len(byname) == 2 and all(
                r.get("performance_eligible") for r in same
            )
            item = {"mode": mode, "repeat": rep, "qualified": eligible}
            if eligible:
                for field in ("process_cpu_percent_one_core_100", "pss_kb_peak"):
                    mapped = byname["gpui-mapped"]["process_metrics"][field]
                    control = byname["gpui-control"]["process_metrics"][field]
                    item[field] = {
                        "mapped": mapped,
                        "control": control,
                        "mapped_minus_control": mapped - control,
                        "mapped_percent_of_control": (
                            100 * mapped / control if control else None
                        ),
                    }
            pairs.append(item)
    failures = [
        {
            "variant": r["variant"],
            "policy": r.get("spawn_renderer_policy", r.get("policy")),
            "mode": r["mode"],
            "repeat": r["repeat"],
            "error": r.get("error"),
            "gates": {
                k: r.get(k)
                for k in (
                    "original_runner_accepted",
                    "full_model_matched",
                    "ordered_callbacks_matched",
                    "drawable_work_acknowledged",
                    "graceful_close",
                    "interactive_work_matched",
                    "animation_work_matched",
                    "animation_delivery_matches",
                    "animation_count_matches_lifetime",
                    "animation_skipped",
                    "host_audit",
                    "mapped_description_gate",
                    "final_chrome_anchor",
                )
            },
            "animation_ticks": r.get("animation_ticks"),
            "animation_expected_ticks_from_lifetime": r.get(
                "animation_expected_ticks_from_lifetime"
            ),
            "present_frame_count": r.get("present_frame_count"),
        }
        for r in rows
        if not r.get("performance_eligible")
    ]
    result = {
        "schema": 1,
        "core_pin": "0062bf589829c4f28807ad0fde3e13285379294c",
        "raw_results_sha256": hashlib.sha256(
            (a.capture / "results.jsonl").read_bytes()
        ).hexdigest(),
        "all_captured": len(rows),
        "all_qualified": sum(r.get("performance_eligible") is True for r in rows),
        "groups": summary,
        "failed_rows": failures,
        "auto_same_core_pairs": pairs,
        "policies_pooled": False,
        "failed_rows_excluded_from_performance": True,
    }
    (a.output / "summary.json").write_text(json.dumps(result, indent=2) + "\n")
    lines = [
        "| Policy | Fixture | Mode | Qualified / captured | CPU % | Peak PSS MiB | Host receipts |",
        "| --- | --- | --- | ---: | ---: | ---: | ---: |",
    ]

    def fmt(x, div=1):
        return f"{x['median']/div:.2f}" if x else "unavailable"

    for e in summary:
        lines.append(
            f"| {e['policy']} | {e['variant']} | {e['mode']} | {e['qualified']} / {e['captured']} | {fmt(e['process_cpu_percent_one_core_100'])} | {fmt(e['pss_kb_peak'],1024)} | {fmt(e['present_frame_count'])} |"
        )
    (a.output / "resources.md").write_text("\n".join(lines) + "\n")


if __name__ == "__main__":
    main()
