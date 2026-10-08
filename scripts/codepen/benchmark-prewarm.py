#!/usr/bin/env python3
"""Compare identical real-browser edits with and without idle compiler warmup.

Arms alternate across fresh processes, sharing only the immutable input bundle.
Every trial verifies entire native GPUI frames and retention of the live heap.
Run without other compiler builds or execution probes for useful timings.
"""
import argparse
import json
import math
import os
from pathlib import Path
import statistics
import subprocess

ROOT = Path(__file__).resolve().parents[2]


def distribution(values):
    ordered = sorted(values)
    return {"samples": len(values), "median_ms": round(statistics.median(values), 1),
            "p95_ms": round(ordered[math.ceil(len(ordered) * .95) - 1], 1)}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("bundle", type=Path)
    parser.add_argument("--output", type=Path, default=ROOT / "target/codepen-prewarm-benchmark")
    parser.add_argument("--rounds", type=int, default=2)
    parser.add_argument("--trials", type=int, default=3)
    parser.add_argument("--overlap", action="store_true")
    args = parser.parse_args()
    if not 1 <= args.rounds <= 10 or not 1 <= args.trials <= 20:
        parser.error("Use 1–10 rounds and 1–20 trials")
    args.output.mkdir(parents=True, exist_ok=True)
    runs = []
    for round_ in range(args.rounds):
        for enabled in ([False, True] if round_ % 2 == 0 else [True, False]):
            name = f"{round_ + 1}-{'warm' if enabled else 'cold'}"
            measurements = args.output / (name + ".json")
            env = os.environ.copy()
            env.update(GPUI_CODEPEN_TEST_PREWARM=str(int(enabled)), GPUI_CODEPEN_TEST_INCREMENTAL="1",
                       GPUI_CODEPEN_BENCHMARK_TRIALS=str(args.trials),
                       GPUI_CODEPEN_MEASUREMENTS=str(measurements.resolve()))
            for key in ("GPUI_CODEPEN_PROFILE", "GPUI_CODEPEN_PROFILE_METADATA", "GPUI_CODEPEN_PROFILE_MODULE",
                        "GPUI_CODEPEN_PROFILE_CONTRACT", "GPUI_CODEPEN_CPU_PROFILE_GENERATION"):
                env.pop(key, None)
            command = ["node", "scripts/codepen/probe-browser-reload.mjs", str(args.bundle.resolve()),
                       "--documentation-counter", "--prewarm-benchmark"]
            if args.overlap:
                command.append("--prewarm-overlap")
            print(f"Running {name}: {args.trials} verified trials", flush=True)
            with (args.output / (name + ".log")).open("w") as log:
                subprocess.run(command, env=env, cwd=ROOT, stdout=log, stderr=subprocess.STDOUT, check=True)
            run = json.loads(measurements.read_text())
            assert run["passed"] and run["prewarm_compiler"] == enabled
            runs.append(run)
    result = {"bundle": str(args.bundle.resolve()), "overlap": args.overlap}
    for enabled in (False, True):
        samples = {key: [] for key in ("first_frame", "click", "edit", "edited_click", "edit_compile", "warm_compile", "warm_cpu")}
        active_at_click = active_at_edit = 0
        for run in runs:
            if run["prewarm_compiler"] != enabled:
                continue
            for trial in run["benchmark_trials"]:
                generations = run["generations"]
                for key, sequence in (("first_frame", "initial"), ("click", "click"),
                                      ("edit", "edit"), ("edited_click", "updated_click")):
                    samples[key].append(generations[str(trial[sequence + "_generation"])]["total_ms"])
                samples["edit_compile"].append(generations[str(trial["edit_generation"])]["compile_ms"])
                warm = generations[str(trial["initial_generation"])]
                if enabled:
                    samples["warm_compile"].append(warm["compile_ms"])
                    if "compiler_cpu_ms" in warm:
                        samples["warm_cpu"].append(warm["compiler_cpu_ms"])
                active_at_click += trial["background_active_before_click"]
                active_at_edit += trial["background_active_before_edit"]
        result["warm" if enabled else "cold"] = {key: distribution(values) for key, values in samples.items() if values}
        result["warm" if enabled else "cold"].update(background_active_before_click=active_at_click,
                                                   background_active_before_edit=active_at_edit)
    (args.output / "summary.json").write_text(json.dumps(result, indent=2) + "\n")
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
