#!/usr/bin/env python3
"""Paired finite/exceptional/admission controls and ordinary Part visitors."""
import argparse
import csv
import hashlib
import json
import platform
import subprocess
from pathlib import Path

p = argparse.ArgumentParser()
p.add_argument("--baseline-core", required=True)
p.add_argument("--candidate-core", required=True)
p.add_argument("--baseline-gpui", required=True)
p.add_argument("--candidate-gpui", required=True)
p.add_argument("--baseline-copies", required=True)
p.add_argument("--candidate-copies", required=True)
p.add_argument("--output", required=True)
p.add_argument("--pairs", type=int, default=7)
p.add_argument("--cpu", type=int, default=2)
a = p.parse_args()
programs = {
    "baseline": (a.baseline_core, a.baseline_gpui, a.baseline_copies),
    "candidate": (a.candidate_core, a.candidate_gpui, a.candidate_copies),
}
rows = []
digests = {}
for pair in range(a.pairs):
    order = ("baseline", "candidate") if pair % 2 == 0 else ("candidate", "baseline")
    for variant in order:
        core, gpui, copies = programs[variant]
        for mode in ("finite", "composed", "empty", "fallback", "visit", "make", "compose_direct", "compose_composed", "same", "copy"):
            if mode == "visit":
                command = [gpui, "4096", "100"]
            elif mode in ("make", "compose_direct", "compose_composed", "same", "copy"):
                command = [copies, mode, "250000"]
            else:
                command = [core, mode, "5000"]
            result = subprocess.run(["taskset", "-c", str(a.cpu), *command], check=True,
                                    capture_output=True, text=True)
            for line in result.stdout.splitlines():
                if not line.startswith("cost,"):
                    continue
                _, label, count, elapsed, digest = line.split(",")
                case = f"visit_{label}" if mode == "visit" else (f"producer_{label}" if command[0] == copies else f"core_{label}")
                previous = digests.setdefault(case, digest)
                assert digest == previous, (case, previous, digest)
                rows.append((pair, variant, case, int(count), int(elapsed), digest))
assert len(rows) == a.pairs * 2 * 12
with Path(a.output).open("w") as f:
    writer = csv.writer(f)
    writer.writerow(("pair", "variant", "case", "operations", "elapsed_ns", "digest"))
    writer.writerows(rows)
pins = {name: [{"path": path, "sha256": hashlib.sha256(Path(path).read_bytes()).hexdigest()}
               for path in paths] for name, paths in programs.items()}
Path(a.output).with_suffix(".json").write_text(json.dumps({
    "executables": pins, "cpu": a.cpu, "pairs": a.pairs, "platform": platform.platform(),
    "source": subprocess.check_output(["git", "rev-parse", "HEAD"], text=True).strip(),
    "scope": "Core public calls and ordinary downstream Win::visit. Mount/raster/native startup are outside timed loops.",
}, indent=2) + "\n")
