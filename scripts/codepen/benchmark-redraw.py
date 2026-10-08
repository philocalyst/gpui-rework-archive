#!/usr/bin/env python3
"""Compare full Miri redraws in fresh production Workers, with native parity."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import shutil
import statistics
import subprocess

ROOT = Path(__file__).resolve().parents[2]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("control", type=Path)
    parser.add_argument("candidate", type=Path)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--pairs", type=int, default=2)
    parser.add_argument("--node", default="node")
    args = parser.parse_args()
    if not 1 <= args.pairs <= 10:
        parser.error("--pairs must be between 1 and 10")
    node = shutil.which(args.node)
    if not node:
        parser.error("Node.js with WebAssembly JSPI support is required")
    output = args.output.resolve()
    output.mkdir(parents=True, exist_ok=True)
    if (output / "summary.json").exists():
        parser.error("Use a fresh output directory to preserve earlier measurements")
    bundles = {"control": args.control.resolve(), "candidate": args.candidate.resolve()}
    identities = {}
    for name, directory in bundles.items():
        manifest = json.loads((directory / "assets.json").read_text())
        identities[name] = {"bundle": str(directory), "module": manifest["module"],
                            "manifest_sha256": hashlib.sha256((directory / "assets.json").read_bytes()).hexdigest()}
    results = []
    # Alternating pair order controls for host warmup/thermal drift. Every arm
    # gets a new process, asset cache, full rustc/Miri Worker and actual GPUI app.
    for pair in range(args.pairs):
        order = ("control", "candidate") if pair % 2 == 0 else ("candidate", "control")
        for arm in order:
            stem = f"{pair + 1}-{arm}"
            measurement = output / (stem + ".json")
            env = os.environ.copy()
            env.update(GPUI_CODEPEN_TEST_PREWARM="0", GPUI_CODEPEN_TEST_INCREMENTAL="1",
                       GPUI_CODEPEN_MEASUREMENTS=str(measurement))
            for variable in ("GPUI_CODEPEN_PROFILE", "GPUI_CODEPEN_PROFILE_MODULE",
                             "GPUI_CODEPEN_CPU_PROFILE_GENERATION", "GPUI_CODEPEN_PROFILE_METADATA",
                             "GPUI_CODEPEN_PROFILE_CONTRACT", "GPUI_CODEPEN_SOFT_FLOAT"):
                env.pop(variable, None)
            command = [node, str(ROOT / "scripts/codepen/probe-browser-reload.mjs"),
                       str(bundles[arm]), "--documentation-counter", "--redraw-benchmark"]
            print(f"Running {stem}: 20 real counter interactions, 21 complete native frame comparisons", flush=True)
            with (output / (stem + ".log")).open("w") as log:
                subprocess.run(command, cwd=ROOT, env=env, stdout=log, stderr=subprocess.STDOUT,
                               check=True, timeout=300)
            report = json.loads(measurement.read_text())
            assert report["passed"] and report["vmBoots"] == 1, report
            frames = [report["generations"][str(index)] for index in range(2, 22)]
            assert len(report["generations"]) == 21
            assert all(frame["compile_ms"] == 0 and frame["frame_bytes"] > 0 for frame in frames)
            record = {"arm": arm, "pair": pair + 1,
                      "startup_ms": report["generations"]["1"]["total_ms"],
                      "redraw_ms": [frame["total_ms"] for frame in frames],
                      "execution_ms": [frame["execution_ms"] for frame in frames]}
            if all("vm_cpu_ms" in frame for frame in frames):
                record["cpu_ms"] = [frame["vm_cpu_ms"] for frame in frames]
            results.append(record)
            print(f"  Median redraw {statistics.median(record['redraw_ms']):.1f} ms", flush=True)
    arms = {}
    for arm in bundles:
        trials = [result for result in results if result["arm"] == arm]
        arms[arm] = {"trials": len(trials), "redraws": 20 * len(trials),
                     "startup_median_ms": statistics.median(result["startup_ms"] for result in trials)}
        for key in ("redraw_ms", "execution_ms", "cpu_ms"):
            if all(key in result for result in trials):
                values = [value for result in trials for value in result[key]]
                late = [value for result in trials for value in result[key][-10:]]
                arms[arm][key] = {"median": statistics.median(values),
                                  "mean": statistics.mean(values),
                                  "late_median": statistics.median(late)}
    summary = {"node": subprocess.check_output([node, "--version"], text=True).strip(),
               "bundles": identities, "arms": arms, "trials": results,
               "note": "Fresh process per arm; prewarm/profile disabled; incremental ICH enabled; all frames match native; one VM per arm."}
    (output / "summary.json").write_text(json.dumps(summary, indent=2) + "\n")
    print(json.dumps(arms, indent=2))


if __name__ == "__main__":
    main()
