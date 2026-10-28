#!/usr/bin/env python3
"""Guarded five-way CPU phase capture; run only in a coordinated quiet window."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import platform
import subprocess
import time


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def guard(inputs):
    for item in inputs:
        worktree = item["worktree"]
        head = subprocess.check_output(
            ["git", "-c", f"safe.directory={worktree}", "-C", worktree, "rev-parse", "HEAD"],
            text=True,
        ).strip()
        if head != item["source"]:
            raise RuntimeError(f"source changed: {item['label']}")
        subprocess.run(
            ["git", "-c", f"safe.directory={worktree}", "-C", worktree,
             "diff", "--exit-code", "HEAD", "--", "."], check=True, capture_output=True,
        )
        if sha(item["binary"]) != item["binary_sha256"]:
            raise RuntimeError(f"binary changed: {item['label']}")
        fixture = Path(worktree) / "reactivity/crates/canvas/tests/bin_phase.rs"
        if sha(fixture) != item["fixture_sha256"]:
            raise RuntimeError(f"fixture changed: {item['label']}")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("manifest", type=Path)
    parser.add_argument("output", type=Path)
    parser.add_argument("--rounds", type=int, default=3)
    args = parser.parse_args()
    inputs = json.loads(args.manifest.read_text())
    if args.rounds <= 0:
        parser.error("rounds must be positive")
    args.output.mkdir(parents=True, exist_ok=False)
    guard(inputs)
    affinity = sorted(os.sched_getaffinity(0))
    # All five binaries inherit the same single available CPU. This records
    # owner-thread phase cost rather than a renderer-pool throughput claim.
    os.sched_setaffinity(0, {affinity[0]})
    before = {"manifest_sha256": sha(args.manifest), "platform": platform.platform(),
              "cpu": Path("/proc/cpuinfo").read_text().split("model name", 1)[-1].splitlines()[0],
              "available_cpus": affinity, "capture_cpu": affinity[0],
              "started_utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())}
    (args.output / "before.json").write_text(json.dumps(before, indent=2) + "\n")
    runs = []
    oracle = None
    for repeat in range(args.rounds):
        order = inputs if repeat % 2 == 0 else list(reversed(inputs))
        for item in order:
            guard(inputs)
            command = [item["binary"], "--ignored", "--exact", "bin_phase_probe",
                       "--nocapture", "--test-threads=1"]
            begin = time.monotonic_ns()
            result = subprocess.run(command, check=True, capture_output=True, text=True)
            elapsed = time.monotonic_ns() - begin
            output = result.stdout + result.stderr
            log = f"{repeat + 1}-{item['label']}.log"
            (args.output / log).write_text(output)
            digests = [line for line in output.splitlines() if line.startswith("digest,")]
            if len(digests) != 6:
                raise RuntimeError(f"missing digest: {log}: {digests}")
            if oracle is None:
                oracle = digests
            elif digests != oracle:
                raise RuntimeError(f"pixel oracle differs: {log}")
            phases = [line for line in output.splitlines() if line.startswith("phase,")]
            if len(phases) != 7:
                raise RuntimeError(f"missing phase: {log}")
            runs.append({"repeat": repeat + 1, "label": item["label"],
                         "log": log, "command": command, "elapsed_ns": elapsed,
                         "log_sha256": sha(args.output / log)})
    guard(inputs)
    (args.output / "runs.json").write_text(json.dumps(runs, indent=2) + "\n")
    (args.output / "after.json").write_text(json.dumps({
        "guards": "PASS", "oracle": oracle,
        "finished_utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    }, indent=2) + "\n")


if __name__ == "__main__":
    main()
