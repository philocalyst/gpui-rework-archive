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
import selectors
import subprocess
import sys
import time


def run(binary, policy, timeout):
    started = time.perf_counter_ns()
    child = subprocess.Popen([str(binary), f"--{policy}", "--startup"],
                             stdout=subprocess.DEVNULL, stderr=subprocess.PIPE, text=True)
    try:
        deadline = time.monotonic() + timeout
        with selectors.DefaultSelector() as selector:
            selector.register(child.stderr, selectors.EVENT_READ)
            while True:
                remaining = deadline - time.monotonic()
                if remaining <= 0 or not selector.select(remaining):
                    raise TimeoutError(f"{binary}: no first-present marker")
                line = child.stderr.readline()
                if not line:
                    raise RuntimeError(f"{binary}: exited before first present ({child.poll()})")
                if line.startswith("GPUI_PRESENT,"):
                    elapsed_us = (time.perf_counter_ns() - started) // 1000
                    _, renderer, source, presented, main_us = line.strip().split(",")
                    return [renderer, source, presented, int(main_us), elapsed_us]
    finally:
        child.terminate()
        try:
            child.wait(timeout=5)
        except subprocess.TimeoutExpired:
            child.kill()
            child.wait()
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
