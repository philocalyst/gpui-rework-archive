#!/usr/bin/env python3
"""Sample Linux resident/proportional memory of already-built native examples.

Uses the inherited display/driver configuration. No Rust build process is
included. Timed samples are observations, not proof that startup is complete.
"""
import csv
import argparse
import pathlib
import subprocess
import sys
import time


def numbers(path):
    values = {}
    for line in path.read_text().splitlines():
        key, _, value = line.partition(":")
        fields = value.split()
        if fields and fields[0].isdigit():
            values[key] = int(fields[0])
    return values


def sample(binary, writer, renderer):
    child = subprocess.Popen([str(binary), f"--{renderer}"], stdout=subprocess.DEVNULL,
                             stderr=subprocess.PIPE, text=True)
    try:
        started = time.monotonic()
        for seconds in (1, 3, 5):
            time.sleep(max(0, started + seconds - time.monotonic()))
            if child.poll() is not None:
                raise RuntimeError(f"{binary}: exited {child.returncode}: {child.stderr.read()}")
            proc = pathlib.Path("/proc") / str(child.pid)
            memory = numbers(proc / "smaps_rollup")
            status = numbers(proc / "status")
            # Parentheses may contain spaces in Linux task names.
            stat = (proc / "stat").read_text().rpartition(")")[2].split()
            writer.writerow([binary.name, renderer, seconds * 1000,
                             *[memory[key] for key in ("Rss", "Pss", "Private_Clean",
                                                       "Private_Dirty", "Shared_Clean", "Anonymous")],
                             status["Threads"], status["VmSize"],
                             int(stat[11]) + int(stat[12])])
            sys.stdout.flush()
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
    parser.add_argument("binaries", nargs="+", type=pathlib.Path)
    arguments = parser.parse_args()
    writer = csv.writer(sys.stdout, lineterminator="\n")
    writer.writerow(["program", "renderer", "delay_ms", "rss_kib", "pss_kib", "private_clean_kib",
                     "private_dirty_kib", "shared_clean_kib", "anonymous_kib", "threads",
                     "virtual_kib", "cpu_ticks"])
    for binary in arguments.binaries:
        sample(binary.resolve(), writer, arguments.renderer)
