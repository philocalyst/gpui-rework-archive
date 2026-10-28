#!/usr/bin/env python3
"""Linux/X11 paired ReferenceCpu first-submit and post-ack resident observations.

Build the same empty/workbench/library examples with x11-minimal on both sides.
AT is disabled in this diagnostic profile. Uses inherited DISPLAY/libraries;
warm OS caches, no eviction. The marker follows actual native submit plus P ack,
not monitor scanout. Memory is sampled 100ms after that marker. No build runs.
"""
import argparse
import csv
import os
from pathlib import Path
import queue
import subprocess
import threading
import time


def numbers(path):
    result = {}
    for line in path.read_text().splitlines():
        key, _, value = line.partition(":")
        fields = value.split()
        if fields and fields[0].isdigit():
            result[key] = int(fields[0])
    return result


def run(binary):
    cpus = os.sched_getaffinity(0)
    cpu = 2 if 2 in cpus else min(cpus)
    start = time.perf_counter_ns()
    child = subprocess.Popen(
        [str(binary), "--cpu", "--startup"], stdout=subprocess.DEVNULL,
        stderr=subprocess.PIPE, text=True,
        preexec_fn=lambda: os.sched_setaffinity(0, {cpu}),
    )
    lines = queue.SimpleQueue()

    def read():
        for line in child.stderr:
            lines.put((time.perf_counter_ns(), line))
        lines.put((time.perf_counter_ns(), None))

    reader = threading.Thread(target=read, daemon=True)
    reader.start()
    try:
        deadline = time.monotonic() + 15
        while True:
            detected, line = lines.get(timeout=max(0, deadline - time.monotonic()))
            if line is None:
                raise RuntimeError(f"{binary} exited before actual presentation")
            if line.startswith("GPUI_PRESENT,"):
                _, renderer, source, presented, main_us = line.strip().split(",")
                if renderer != "ReferenceCpu" or source != presented:
                    raise RuntimeError(f"invalid first presentation: {line}")
                break
        time.sleep(0.1)
        proc = Path("/proc") / str(child.pid)
        memory = numbers(proc / "smaps_rollup")
        status = numbers(proc / "status")
        stat = (proc / "stat").read_text().rpartition(")")[2].split()
        return {
            "main_to_present_us": int(main_us), "spawn_to_present_us": (detected - start) // 1000,
            "rss_kib": memory["Rss"], "pss_kib": memory["Pss"],
            "private_dirty_kib": memory["Private_Dirty"], "anonymous_kib": memory["Anonymous"],
            "threads": status["Threads"], "minor_faults": int(stat[7]), "major_faults": int(stat[9]),
        }
    finally:
        child.terminate()
        try:
            child.wait(timeout=5)
        except subprocess.TimeoutExpired:
            child.kill()
            child.wait()
        reader.join(timeout=5)
        child.stderr.close()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--baseline", required=True, type=Path)
    parser.add_argument("--candidate", required=True, type=Path)
    parser.add_argument("--rounds", default=11, type=int)
    parser.add_argument("--output", required=True, type=Path)
    args = parser.parse_args()
    rows = []
    for index in range(args.rounds):
        for fixture in ("empty", "workbench", "library"):
            variants = ["baseline", "candidate"] if index % 2 == 0 else ["candidate", "baseline"]
            for variant in variants:
                rows.append({"fixture": fixture, "variant": variant, "round": index,
                             **run(getattr(args, variant).resolve() / fixture)})
    with args.output.open("w", newline="") as output:
        writer = csv.DictWriter(output, rows[0])
        writer.writeheader()
        writer.writerows(rows)
    print(f"Wrote {len(rows)} actual native first-present/resident observations to {args.output}")


if __name__ == "__main__":
    main()
