#!/usr/bin/env python3
"""Measure process spawn to the first native present callback of a built example.

The example marker runs after present/acknowledgement. This is submitted content,
not monitor scanout. Main-to-callback time is recorded separately. Builds and
GPU upgrades after the first frame are excluded. Runs use the inherited display
and driver configuration; page-cache/cold-start conditions must be reported.
"""
import argparse
import csv
import pathlib
import queue
import subprocess
import sys
import threading
import time


def run(binary, policy, timeout):
    started = time.perf_counter_ns()
    child = subprocess.Popen([str(binary), f"--{policy}", "--startup"],
                             stdout=subprocess.DEVNULL, stderr=subprocess.PIPE, text=True)
    # Windows selectors cannot wait on anonymous subprocess pipes. A reader
    # works on all native platforms; timestamp detection before queue delivery.
    lines = queue.SimpleQueue()

    def read():
        for line in child.stderr:
            lines.put((time.perf_counter_ns(), line))
        lines.put((time.perf_counter_ns(), None))

    reader = threading.Thread(target=read, daemon=True)
    reader.start()
    try:
        deadline = time.monotonic() + timeout
        while True:
            try:
                detected, line = lines.get(timeout=max(0, deadline - time.monotonic()))
            except queue.Empty:
                raise TimeoutError(f"{binary}: no first-present marker") from None
            if line is None:
                raise RuntimeError(f"{binary}: exited before first present ({child.poll()})")
            if line.startswith("GPUI_PRESENT,"):
                _, renderer, source, presented, main_us = line.strip().split(",")
                if source != presented:
                    raise RuntimeError(f"{binary}: first presentation is stale")
                if policy in ("auto", "cpu") and renderer != "ReferenceCpu":
                    raise RuntimeError(f"{binary}: expected software-first presentation")
                return [renderer, source, presented, int(main_us), (detected - started) // 1000]
    finally:
        child.terminate()
        try:
            child.wait(timeout=5)
        except subprocess.TimeoutExpired:
            child.kill()
            child.wait()
        reader.join(timeout=5)
        child.stderr.close()


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--renderer", choices=("auto", "gpu", "cpu"), default="auto")
    parser.add_argument("--runs", type=int, default=10)
    parser.add_argument("--timeout", type=float, default=15)
    parser.add_argument("binaries", nargs="+", type=pathlib.Path)
    arguments = parser.parse_args()
    writer = csv.writer(sys.stdout, lineterminator="\n")
    writer.writerow(["program", "policy", "run", "realized_renderer", "source_epoch",
                     "presentation_epoch", "main_to_present_us", "spawn_to_present_us"])
    for binary in arguments.binaries:
        for index in range(arguments.runs):
            writer.writerow([binary.name, arguments.renderer, index,
                             *run(binary.resolve(), arguments.renderer, arguments.timeout)])
            sys.stdout.flush()
