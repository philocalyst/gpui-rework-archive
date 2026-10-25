"""Alternate fresh-process baseline/packed measurements, including actual X11 CPU presentation."""
import argparse
import csv
import os
from pathlib import Path
import selectors
import signal
import subprocess
import time


def capture_native(executable, record):
    process = subprocess.Popen(
        [str(executable), "--cpu", "--startup"],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.PIPE,
        text=True,
        start_new_session=True,
    )
    selector = selectors.DefaultSelector()
    selector.register(process.stderr, selectors.EVENT_READ)
    deadline = time.monotonic() + 10
    try:
        while time.monotonic() < deadline:
            if not selector.select(timeout=max(0, deadline - time.monotonic())):
                break
            line = process.stderr.readline()
            if not line:
                raise RuntimeError(f"native process exited: {process.poll()}")
            if not line.startswith("GPUI_PRESENT,"):
                continue
            fields = line.strip().split(",")
            if fields[1] != "ReferenceCpu":
                raise RuntimeError(f"expected ReferenceCpu feedback: {fields}")
            setting = "cpu,AT disabled"
            record("native", "todos", setting, "first_ack", fields[-1], "us")
            for line in Path(f"/proc/{process.pid}/smaps_rollup").read_text().splitlines():
                key = line.split(":", 1)[0]
                if key in ["Rss", "Pss", "Private_Dirty", "Anonymous"]:
                    record("native", "todos", setting, key, line.split()[1], "KiB")
            return
        raise RuntimeError("native first-presentation deadline exceeded")
    finally:
        os.killpg(process.pid, signal.SIGTERM)
        process.wait(timeout=5)
        selector.close()


def capture(executables, record):
    for name in ["color_cost", "first_frame", "cpu", "parallel"]:
        output = subprocess.check_output([str(executables / name)], text=True)
        rows = list(csv.reader(output.splitlines()))
        if name == "color_cost":
            section = ""
            for row in rows:
                if row[0] in ["headers", "operation", "styles"]:
                    section = row[0]
                elif section == "headers":
                    for key, value in zip(["Color", "Style", "El", "Canvas"], row[1:]):
                        record(name, key, "", "size", value, "bytes")
                elif section == "operation":
                    record(name, row[0], row[1], "cost", row[2], "ns/color")
                else:
                    kind = "unique" if row[0] == "true" else "repeated"
                    metrics = ["prepare", "retained", "peak", "allocations", "nodes"]
                    for key, value, unit in zip(metrics, row[2:], ["us", "bytes", "bytes", "count", "count"]):
                        record(name, kind, row[1], key, value, unit)
        elif name == "first_frame":
            for index, row in enumerate(rows[1:]):
                for key, value, unit in zip(["prepare", "raster", "draws"], row[1:], ["us", "us", "count"]):
                    record(name, row[0], index // 2, key, value, unit)
        else:
            start = next(index for index, row in enumerate(rows) if row[0] == "scene")
            header = rows[start]
            for row in rows[start + 1:]:
                for key, value in zip(header[2:], row[2:]):
                    unit = "us" if "us" in key else "count/bytes"
                    record(name, row[0], row[1], key, value, unit)
    capture_native(executables / "workbench", record)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("baseline", type=Path, help="directory containing color_cost, first_frame, cpu, parallel, workbench")
    parser.add_argument("packed", type=Path)
    parser.add_argument("output", type=Path)
    parser.add_argument("--samples", type=int, default=5)
    args = parser.parse_args()
    if args.samples < 1:
        parser.error("--samples must be positive")
    variants = [("legacy20", args.baseline.resolve()), ("packed16", args.packed.resolve())]
    with args.output.open("w") as output:
        writer = csv.writer(output, lineterminator="\n")
        writer.writerow(["variant", "sample", "suite", "case", "setting", "metric", "value", "unit"])
        for sample in range(args.samples):
            for variant, directory in variants if sample % 2 == 0 else reversed(variants):
                def record(suite, case, setting, metric, value, unit):
                    writer.writerow([variant, sample, suite, case, setting, metric, value, unit])
                capture(directory, record)
                output.flush()
                print(variant, sample, flush=True)


if __name__ == "__main__":
    main()
