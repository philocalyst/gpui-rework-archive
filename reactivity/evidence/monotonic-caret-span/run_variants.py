#!/usr/bin/env python3
"""Guarded paired controls; call only in a coordinated CPU/build quiet window."""
from pathlib import Path
import argparse
import hashlib
import json
import os
import re
import statistics
import subprocess
import time

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument("--metadata", type=Path, required=True)
parser.add_argument("--output", type=Path, required=True)
args = parser.parse_args()
variants = json.loads(args.metadata.read_text())
assert 2 <= len(variants) <= 4 and next(iter(variants)) == "baseline"
args.output.mkdir(exist_ok=False)
cpu = min(os.sched_getaffinity(0))
rows = []


def idle():
    result = subprocess.run(["ps", "-C", "cargo", "-C", "rustc", "-C", "clippy-driver",
                             "-o", "pid=,stat=,comm="], text=True, capture_output=True)
    active = [line for line in result.stdout.splitlines()
              if len(line.split()) >= 3 and not line.split()[1].startswith("Z")]
    assert not active, "Build overlap: " + "\n".join(active)


def guard():
    for variant in variants.values():
        assert hashlib.sha256(Path(variant["binary"]).read_bytes()).hexdigest() == variant["sha256"]
        root = Path(variant["worktree"])
        assert all(hashlib.sha256((root / name).read_bytes()).hexdigest() == value
                   for name, value in variant["guard"].items())


def invoke(name, case, scope, mode, rounds, pair):
    idle()
    process = subprocess.run([variants[name]["binary"], case, scope, mode, str(rounds)],
                             text=True, capture_output=True, timeout=60,
                             preexec_fn=lambda: os.sched_setaffinity(0, {cpu}))
    row = {"variant": name, "case": case, "scope": scope, "mode": mode,
           "rounds": rounds, "pair": pair, "exit": process.returncode,
           "stdout": process.stdout, "stderr": process.stderr}
    rows.append(row)
    (args.output / "runs.json").write_text(json.dumps(rows, indent=2) + "\n")
    assert process.returncode == 0, row
    return dict(re.findall(r"(\w+)=([0-9a-f]+)", process.stdout))


guard()
idle()
started = time.monotonic()
summary = {"cpu": cpu, "pairs": 7, "cases": [], "variants": variants,
           "limits": "Primed process fonts; scoped shaping, not startup/RSS/UI/native latency. Fixed CPU and guarded artifacts; unrelated host activity uncontrolled. Allocation rows intentionally differ."}
for case, rounds in [("tiny", 1000), ("label", 500), ("latin", 8), ("rtl", 8),
                     ("mixed", 8), ("paragraphs", 8), ("one-grapheme", 8)]:
    for scope in ["cold", "warm"]:
        allocation = {name: invoke(name, case, scope, "alloc", 1, -1) for name in variants}
        assert len({row["checksum"] for row in allocation.values()}) == 1
        samples = {name: [] for name in variants}
        for pair in range(7):
            order = list(variants) if pair % 2 == 0 else list(reversed(variants))
            for name in order:
                row = invoke(name, case, scope, "time", rounds, pair)
                assert row["checksum"] == allocation[name]["checksum"]
                samples[name].append(int(row["ns"]) / rounds)
            guard()
        medians = {name: statistics.median(values) for name, values in samples.items()}
        row = {"case": case, "scope": scope, "rounds": rounds, "allocation": allocation,
               "samples_ns": samples, "median_ns": medians,
               "relative_to_baseline": {name: value / medians["baseline"] - 1
                                        for name, value in medians.items() if name != "baseline"}}
        summary["cases"].append(row)
        (args.output / "summary.json").write_text(json.dumps(summary, indent=2) + "\n")
        print(json.dumps({key: row[key] for key in ["case", "scope", "median_ns", "relative_to_baseline"]}), flush=True)
guard()
idle()
summary.update(wall_seconds=time.monotonic() - started, guards_passed=True)
(args.output / "summary.json").write_text(json.dumps(summary, indent=2) + "\n")
