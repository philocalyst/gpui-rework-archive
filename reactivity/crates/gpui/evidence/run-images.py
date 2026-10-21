#!/usr/bin/env python3
"""Fresh-process image costs and paired image-free owner controls.

Run from reactivity after compiling the four explicitly pinned executables.
No build, native input process or another timed workload may share the window.
"""
import argparse
import csv
import hashlib
import io
import json
import os
from pathlib import Path
import subprocess
import time

parser = argparse.ArgumentParser()
parser.add_argument("--baseline", type=Path, required=True)
parser.add_argument("--candidate", type=Path, required=True)
parser.add_argument("--cpu-images", type=Path, required=True)
parser.add_argument("--gpu-images", type=Path, required=True)
parser.add_argument("--output", type=Path, required=True)
parser.add_argument("--cpu", type=int, default=2)
args = parser.parse_args()
os.sched_setaffinity(0, {args.cpu})
args.output.mkdir(parents=True, exist_ok=False)
executables = {key: getattr(args, key) for key in ("baseline", "candidate", "cpu_images", "gpu_images")}
manifest = {
    "base": subprocess.check_output(["git", "rev-parse", "HEAD"], text=True).strip(),
    "rustc": subprocess.check_output(["rustc", "--version"], text=True).strip(),
    "cpu": args.cpu,
    "binaries": {name: {"path": str(path), "sha256": hashlib.sha256(path.read_bytes()).hexdigest()} for name, path in executables.items()},
    "source_sha256": {},
}
for crate in ("canvas", "gpu", "gpui"):
    paths = sorted(Path("crates", crate).rglob("*.rs")) + [Path("crates", crate, "Cargo.toml")]
    for path in paths:
        manifest["source_sha256"][str(path)] = hashlib.sha256(path.read_bytes()).hexdigest()
(args.output / "manifest.json").write_text(json.dumps(manifest, indent=2) + "\n")
rows = {"owner": [], "cpu": [], "gpu": []}

def run(group, variant, case, sample):
    process = subprocess.run([str(executables[variant]), case], capture_output=True, text=True, timeout=120, check=True)
    stem = f"{group}-{variant}-{case}-{sample}"
    (args.output / f"{stem}.stdout").write_text(process.stdout)
    (args.output / f"{stem}.stderr").write_text(process.stderr)
    parsed = list(csv.DictReader(io.StringIO(process.stdout)))
    assert len(parsed) == 1, process.stdout
    row = {"sample": sample, "variant": variant, **parsed[0]}
    rows[group].append(row)
    return row

start = time.monotonic()
for case in ("empty", "labels"):
    for sample in range(5):
        order = ("baseline", "candidate") if sample % 2 == 0 else ("candidate", "baseline")
        pair = {variant: run("owner", variant, case, sample) for variant in order}
        assert pair["baseline"]["image_handle_bytes"] == "0"
        assert pair["candidate"]["image_handle_bytes"] == "8"
        assert pair["baseline"]["digest"] == pair["candidate"]["digest"]
for group, variant in (("cpu", "cpu_images"), ("gpu", "gpu_images")):
    for case in ("flat", "one", "shared48", "unique48"):
        for sample in range(3):
            row = run(group, variant, case, sample)
            resources = {"flat": 0, "one": 1, "shared48": 1, "unique48": 48}[case]
            assert int(row["resources"]) == resources
            assert int(row["payload_bytes"]) == resources * 128 * 128 * 4
            if group == "cpu":
                assert int(row["warm_allocs"]) == int(row["warm_alloc_bytes"]) == 0
                assert all(old["digest"] == row["digest"] for old in rows[group] if old["case"] == case)
            else:
                assert int(row["warm_image_upload"]) == 0
for group, values in rows.items():
    with (args.output / f"{group}.csv").open("w", newline="") as file:
        writer = csv.DictWriter(file, fieldnames=list(values[0]), lineterminator="\n")
        writer.writeheader()
        writer.writerows(values)
print(f"FINISHED {time.monotonic()-start:.3f}s;20 paired-owner rows,12 CPU rows,12 GPU rows;all guards passed", flush=True)
