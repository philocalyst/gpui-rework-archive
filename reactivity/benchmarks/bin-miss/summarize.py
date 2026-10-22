#!/usr/bin/env python3
"""Preserve all captured phase costs; no outlier filtering or exclusions."""
import argparse
import csv
import json
from pathlib import Path
import statistics

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument("capture", type=Path)
args = parser.parse_args()
rows = []
for run in json.loads((args.capture / "runs.json").read_text()):
    for line in (args.capture / run["log"]).read_text().splitlines():
        if not line.startswith("phase,"):
            continue
        _, phase, *cells = line.split(",")
        row = {"repeat": run["repeat"], "label": run["label"], "phase": phase}
        row.update({key: int(value) for key, value in (cell.split("=", 1) for cell in cells)})
        rows.append(row)
with (args.capture / "phases.csv").open("w", newline="") as stream:
    writer = csv.DictWriter(stream, fieldnames=list(rows[0]))
    writer.writeheader()
    writer.writerows(rows)
summary = {}
for phase in dict.fromkeys(row["phase"] for row in rows):
    groups = {}
    for label in dict.fromkeys(row["label"] for row in rows):
        cells = [row for row in rows if row["phase"] == phase and row["label"] == label]
        times = [row["ns_each"] for row in cells]
        groups[label] = {"median_ns": statistics.median(times), "min_ns": min(times),
                         "max_ns": max(times), "samples": len(times),
                         "requests": [row["requests"] for row in cells],
                         "requested_bytes": [row["requested_bytes"] for row in cells],
                         "live_bytes": [row["live_bytes"] for row in cells]}
    for group in groups.values():
        group["versus_parent_percent"] = (group["median_ns"] / groups["parent"]["median_ns"] - 1) * 100
        group["versus_lazy_percent"] = (group["median_ns"] / groups["lazy"]["median_ns"] - 1) * 100
    summary[phase] = groups
(args.capture / "summary.json").write_text(json.dumps(summary, indent=2) + "\n")
for phase, groups in summary.items():
    print(phase + ": " + ", ".join(f"{label}={cells['median_ns']} ns" for label, cells in groups.items()))
