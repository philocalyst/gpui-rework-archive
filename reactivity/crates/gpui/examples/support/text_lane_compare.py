#!/usr/bin/env python3
"""Run paired fresh processes, pinned to one allowed CPU; emit every sample.

Usage: python text_lane_compare.py REPEATS [--pending] baseline=/path lane=/path [...]
The same committed text_lane_measure.rs must be used for all binaries.
"""
import csv
import io
import os
import subprocess
import sys

repeats = int(sys.argv[1])
arguments = sys.argv[2:]
pending = "--pending" in arguments
variants = [entry.split("=", 1) for entry in arguments if entry != "--pending"]
cpu = min(os.sched_getaffinity(0))
os.sched_setaffinity(0, {cpu})
writer = None
fixtures = [(4096, 0), (4096, 2), (4096, 16), (4096, 1)] if pending else [(0, 0), (1, 1), (32, 1), (4096, 0), (4096, 16), (4096, 1)]
for count, every in fixtures:
    for mode in (["recording"] if pending else ["recording", "cpu"]):
        for repetition in range(repeats):
            ordered = variants if repetition % 2 == 0 else variants[::-1]
            for order, (variant, binary) in enumerate(ordered):
                result = subprocess.run(
                    [binary, str(count), str(every), mode] + (["pending"] if pending else []),
                    text=True, capture_output=True, check=True,
                )
                for row in csv.DictReader(io.StringIO(result.stdout)):
                    output = dict(variant=variant, repetition=repetition, order=order, cpu=cpu, **row)
                    if writer is None:
                        writer = csv.DictWriter(sys.stdout, fieldnames=list(output))
                        writer.writeheader()
                    writer.writerow(output)
                    sys.stdout.flush()
