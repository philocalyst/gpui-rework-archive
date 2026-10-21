#!/usr/bin/env python3
"""Capture fresh-process serial CPU controls; reject stale linkage or pixel drift.

Build this exact example in baseline/candidate worktrees with separate target
folders, copy the linked executables, and supply their recorded SHA256 values.
The candidate must contain the actual axis renderer and baseline must not.
"""
import argparse
import csv
import hashlib
import json
import os
from pathlib import Path
import statistics
import subprocess
import time

CASES = ["flat", "one", "shared48", "unique48", "p3", "premul", "hdr",
         "nearest", "shear", "reflected", "tiny", "p3-48", "premul-48", "hdr-48"]
FIELDS = ["round", "variant", "case", "frame", "us", "allocs", "alloc_bytes",
          "retained", "peak", "queries", "boundary_pixels", "digest"]

def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("baseline")
    parser.add_argument("candidate")
    parser.add_argument("baseline_sha256")
    parser.add_argument("candidate_sha256")
    parser.add_argument("--nm", required=True)
    parser.add_argument("--cpu", type=int, default=2)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    binaries = {"baseline": args.baseline, "candidate": args.candidate}
    for variant, expected in [("baseline", args.baseline_sha256),
                              ("candidate", args.candidate_sha256)]:
        assert sha(binaries[variant]) == expected, (variant, "binary SHA mismatch")
        symbols = subprocess.check_output([args.nm, "-C", binaries[variant]], text=True)
        assert ("canvas::image_axis::render" in symbols) == (variant == "candidate")
    args.output.mkdir(parents=True, exist_ok=True)
    rows = []
    began = time.monotonic()
    with (args.output / "raw.csv").open("w", newline="") as output:
        writer = csv.DictWriter(output, fieldnames=FIELDS)
        writer.writeheader()
        for run in range(5):
            for case in CASES if run % 2 == 0 else reversed(CASES):
                pair = {}
                for variant in (["baseline", "candidate"] if run % 2 == 0
                                else ["candidate", "baseline"]):
                    command = ["taskset", "-c", str(args.cpu), binaries[variant], case]
                    result = subprocess.run(command, capture_output=True, text=True,
                                            check=True, timeout=30)
                    assert not result.stderr, result.stderr
                    records = list(csv.reader(result.stdout.splitlines()))
                    assert len(records) == 9
                    assert [int(r[1]) for r in records] == list(range(9))
                    assert all(r[0] == case for r in records)
                    assert len({r[9] for r in records}) == 1
                    assert all(r[3:5] == ["0", "0"] for r in records[2:]), case
                    pair[variant] = records
                    for record in records:
                        row = dict(zip(FIELDS, [run, variant] + record))
                        writer.writerow(row)
                        rows.append(row)
                    output.flush()
                base, new = pair["baseline"], pair["candidate"]
                assert base[0][9] == new[0][9], (case, "pixel mismatch")
                assert base[0][5:7] == new[0][5:7], (case, "retained/peak change")
                if case in ["flat", "shear"]:
                    assert base[0][7] == new[0][7], (case, "unexpected activation")
                else:
                    assert int(new[0][7]) < int(base[0][7]), (case, "axis inactive")
            print(f"round {run + 1}/5 complete", flush=True)
    with (args.output / "summary.csv").open("w", newline="") as output:
        fields = ["case", "baseline_p50_us", "candidate_p50_us", "candidate_p95_us",
                  "candidate_p99_us", "paired_median_percent", "paired_min_percent",
                  "paired_max_percent", "retained", "peak", "baseline_queries",
                  "candidate_queries", "digest"]
        writer = csv.DictWriter(output, fieldnames=fields)
        writer.writeheader()
        for case in CASES:
            samples = {v: [r for r in rows if r["case"] == case and r["variant"] == v
                           and int(r["frame"]) >= 2] for v in binaries}
            us = {v: sorted(float(r["us"]) for r in samples[v]) for v in binaries}
            paired = []
            for run in range(5):
                medians = {v: statistics.median(float(r["us"]) for r in samples[v]
                                               if int(r["round"]) == run) for v in binaries}
                paired.append(100 * (medians["candidate"] / medians["baseline"] - 1))
            first = {v: samples[v][0] for v in binaries}
            data = [case, statistics.median(us["baseline"]), statistics.median(us["candidate"]),
                    us["candidate"][int(.95 * len(us["candidate"]))], us["candidate"][-1],
                    statistics.median(paired), min(paired), max(paired),
                    first["candidate"]["retained"], first["candidate"]["peak"],
                    first["baseline"]["queries"], first["candidate"]["queries"],
                    first["candidate"]["digest"]]
            writer.writerow(dict(zip(fields, data)))
    (args.output / "capture.json").write_text(json.dumps({
        "argv": vars(args) | {"output": str(args.output)},
        "elapsed_seconds": time.monotonic() - began,
        "rows": len(rows), "warm_frames_per_variant_case": 35,
        "warm_frames": "frames 2..8; cold frames retained, excluded from quantiles",
        "cpu_affinity": args.cpu, "logical_cpus": os.cpu_count(),
        "binary_sha256": {v: sha(path) for v, path in binaries.items()},
        "runner_sha256": sha(__file__),
    }, indent=2) + "\n")

if __name__ == "__main__":
    main()
