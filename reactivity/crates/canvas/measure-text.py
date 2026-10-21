#!/usr/bin/env python3
"""Paired fresh-process shaping/owner fixtures; build identical examples first.

Counters are requested thread-local allocation bytes, not allocator usable size
or RSS. Output/model vectors allocated outside measured stages stay excluded.
Pixel preflight compares complete output bytes before any timing is recorded.
"""
import argparse
import csv
import io
import os
from pathlib import Path
import subprocess
import tempfile


def run(binary, arguments, prefix=None):
    env = os.environ.copy()
    if prefix is not None:
        env["GPUI_TEXT_PIXELS"] = str(prefix)
    cpus = os.sched_getaffinity(0)
    cpu = 2 if 2 in cpus else min(cpus)
    result = subprocess.run(
        [str(binary), *arguments], env=env, check=True, text=True,
        stdout=subprocess.PIPE, stderr=subprocess.PIPE,
        preexec_fn=lambda: os.sched_setaffinity(0, {cpu}),
    )
    return list(csv.DictReader(io.StringIO(result.stdout)))


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    for name in ("baseline-canvas", "candidate-canvas", "baseline-owner", "candidate-owner"):
        parser.add_argument(f"--{name}", required=True, type=Path)
    parser.add_argument("--rounds", type=int, default=11)
    parser.add_argument("--output", required=True, type=Path)
    args = parser.parse_args()
    binaries = {
        "canvas": {"baseline": args.baseline_canvas, "candidate": args.candidate_canvas},
        "owner": {"baseline": args.baseline_owner, "candidate": args.candidate_owner},
    }
    with tempfile.TemporaryDirectory(prefix="gpui-text-pixels-") as temporary:
        directory = Path(temporary)
        for fixture in binaries:
            for count in (1, 1000):
                for variant, binary in binaries[fixture].items():
                    arguments = ["labels", str(count)] if fixture == "canvas" else [str(count)]
                    run(binary, arguments, directory / variant)
                stages = ["render"] if fixture == "canvas" else ["initial", "edited"]
                for stage in stages:
                    before = (directory / f"baseline.{stage}.bgrx").read_bytes()
                    after = (directory / f"candidate.{stage}.bgrx").read_bytes()
                    if before != after:
                        differences = sum(a != b for a, b in zip(before, after))
                        raise RuntimeError(f"{fixture}/{count}/{stage}: {differences} differing bytes")
    rows = []
    for index in range(args.rounds):
        for fixture in binaries:
            for count in (0, 1, 1000):
                variants = ["baseline", "candidate"] if index % 2 == 0 else ["candidate", "baseline"]
                for variant in variants:
                    arguments = ["labels", str(count)] if fixture == "canvas" else [str(count)]
                    for row in run(binaries[fixture][variant], arguments):
                        rows.append({"fixture": fixture, "variant": variant, "round": index, **row})
    keys = list(dict.fromkeys(key for row in rows for key in row))
    with args.output.open("w", newline="") as output:
        writer = csv.DictWriter(output, keys)
        writer.writeheader()
        writer.writerows(rows)
    print(f"Full-byte pixel preflight passed; wrote {len(rows)} paired rows to {args.output}")


if __name__ == "__main__":
    main()
