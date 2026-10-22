#!/usr/bin/env python3
"""Recreate summary.csv from the immutable observer rows in this directory."""
import csv
import math
from pathlib import Path

ROOT = Path(__file__).resolve().parent
VARIANTS = ("gpui-control", "gpui-direct", "mygo", "nanoui")
QUANTILES = ((50, 0.50), (95, 0.95), (99, 0.99))
FIELDS = (
    "variant", "workload", "starts", "clicks", "idle_samples",
    "startup_p50_ms", "startup_p95_ms", "startup_p99_ms",
    "click_p50_ms", "click_p95_ms", "click_p99_ms",
    "idle_rss_min_kib", "idle_rss_max_kib", "idle_pss_min_kib",
    "idle_pss_max_kib", "idle_threads",
)


def quantile(values, probability):
    # Matches Rust f64::round in the pinned observer for nonnegative indexes:
    # nearest order statistic at round((n - 1) * p), half rounded upward.
    index = math.floor((len(values) - 1) * probability + 0.5)
    return values[index]


def observer_summary(lines, label):
    return {
        name: int(parts[2])
        for line in lines
        if line.startswith(label + "_P")
        for parts in [line.split(",")]
        for name in [parts[0]]
    }


rows = []
for path in sorted(ROOT.glob("*.raw")):
    variant = next(v for v in VARIANTS if path.stem.startswith(v + "-"))
    workload = path.stem[len(variant) + 1 :]
    lines = path.read_text().splitlines()
    startup = sorted(int(line.split(",")[2]) for line in lines if line.startswith("STARTUP,"))
    clicks = sorted(int(line.split(",")[3]) for line in lines if line.startswith("CLICK,"))
    idle = [line.split(",") for line in lines if line.startswith("IDLE,")]
    if (len(startup), len(clicks), len(idle)) != (100, 1000, 5):
        raise SystemExit(f"unexpected sample count in {path.name}")
    if any(line.startswith(("ERROR", "FAIL")) for line in lines):
        raise SystemExit(f"observer error in {path.name}")

    result = {
        "variant": variant,
        "workload": workload,
        "starts": len(startup),
        "clicks": len(clicks),
        "idle_samples": len(idle),
    }
    for label, values in (("STARTUP", startup), ("CLICK", clicks)):
        for percentile, probability in QUANTILES:
            key = f"{label}_P{percentile}_NS"
            result[f"{label.lower()}_p{percentile}_ms"] = f"{quantile(values, probability) / 1_000_000:.6f}"
            if observer_summary(lines, label).get(key) != quantile(values, probability):
                raise SystemExit(f"summary mismatch in {path.name}: {key}")

    rss = [int(row[2]) for row in idle]
    pss = [int(row[3]) for row in idle]
    threads = sorted({int(row[4]) for row in idle})
    result.update(
        idle_rss_min_kib=min(rss), idle_rss_max_kib=max(rss),
        idle_pss_min_kib=min(pss), idle_pss_max_kib=max(pss),
        idle_threads="/".join(map(str, threads)),
    )
    rows.append(result)

with (ROOT / "summary.csv").open("w", newline="") as stream:
    writer = csv.DictWriter(stream, fieldnames=FIELDS)
    writer.writeheader()
    writer.writerows(rows)
print(f"summarized {len(rows)} cells; sample counts and observer quantiles verified")
