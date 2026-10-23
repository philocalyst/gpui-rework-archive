#!/usr/bin/env python3
"""Execute the frozen proposal only after root grants a quiet timing window."""
import argparse
import hashlib
import json
import math
import os
from pathlib import Path
import statistics
import subprocess
import time


def sha(data):
    return hashlib.sha256(data).hexdigest()


def load(path):
    return json.loads(path.read_text())


def guard(config, base):
    checks = {}
    for name, expected in config["artifacts"].items():
        checks[name] = sha((base / name).read_bytes()) == expected
    for role, filename in (("indexed", "control-results.json"),
                           ("partial", "candidate-results.json")):
        evidence = load(base / filename)
        for name, entry in evidence["binaries"].items():
            checks[f"{role}:binary:{name}"] = sha(Path(entry["path"]).read_bytes()) == entry["sha256"]
        for name, expected in evidence["input_guard"].items():
            checks[f"{role}:fixture:{name}"] = sha((Path(evidence["fixture"]) / name).read_bytes()) == expected
        for name, expected in evidence["source_guard"].items():
            if role == "partial":
                data = (Path(evidence["worktree"]) / name).read_bytes()
            else:
                data = subprocess.check_output([
                    "git", "-c", f"safe.directory={evidence['worktree']}",
                    "-C", evidence["worktree"], "show", f"{evidence['source']}:{name}"])
            checks[f"{role}:source:{name}"] = sha(data) == expected
        checks[f"{role}:config"] = sha(Path(config["root_config"]).read_bytes()) == evidence["config_sha256"]
    assert all(checks.values()), [name for name, ok in checks.items() if not ok]
    assert config["cpu"] in os.sched_getaffinity(0)
    return {"count": len(checks), "all_passed": True}


def capture(config, base, output):
    output.mkdir(parents=False, exist_ok=False)
    metadata = {"config_sha256": sha((base / "pair.json").read_bytes()),
                "runner_sha256": sha(Path(__file__).read_bytes()),
                "start_unix": time.time(), "guard_before": guard(config, base)}
    (output / "start.json").write_text(json.dumps(metadata, indent=2) + "\n")
    started = time.monotonic()
    rows = []
    try:
        for pair in range(config["pairs"]):
            order = ["indexed", "partial"] if pair % 2 == 0 else ["partial", "indexed"]
            for case in config["cases"]:
                for scope in config["scopes"]:
                    rounds = config["rounds"]["short" if case in ("tiny", "label") else "bulk"][scope]
                    for role in order:
                        remaining = config["hard_cap_seconds"] - (time.monotonic() - started)
                        assert remaining > 0, "hard cap exhausted; preserve incomplete run"
                        binary = config["binaries"][role]
                        result = subprocess.run([binary, case, scope, "time", str(rounds)],
                                                text=True, capture_output=True, timeout=remaining,
                                                preexec_fn=lambda: os.sched_setaffinity(0, {config["cpu"]}))
                        row = {"pair": pair, "case": case, "scope": scope, "role": role,
                               "rounds": rounds, "stdout": result.stdout,
                               "stderr": result.stderr, "exit": result.returncode}
                        with (output / "raw.jsonl").open("a") as stream:
                            stream.write(json.dumps(row) + "\n")
                        assert result.returncode == 0, row
                        fields = result.stdout.strip().split(",")
                        assert fields[:3] == ["time", case, scope], row
                        values = dict(item.split("=", 1) for item in fields[3:])
                        assert int(values["rounds"]) == rounds, row
                        assert values["checksum"] == config["checksums"][case], row
                        row["ns_per_round"] = int(values["ns"]) / rounds
                        rows.append(row)
        cells = []
        for case in config["cases"]:
            for scope in config["scopes"]:
                ratios = []
                for pair in range(config["pairs"]):
                    samples = {r["role"]: r["ns_per_round"] for r in rows
                               if (r["case"], r["scope"], r["pair"]) == (case, scope, pair)}
                    ratios.append(samples["partial"] / samples["indexed"])
                cells.append({"case": case, "scope": scope, "paired_ratios": ratios,
                              "median_paired_ratio": statistics.median(ratios),
                              "min_ratio": min(ratios), "max_ratio": max(ratios)})
        bulk = [c["median_paired_ratio"] for c in cells if c["case"] in config["gate"]["bulk_cases"]]
        bulk_ratio = math.exp(sum(map(math.log, bulk)) / len(bulk))
        summary = {"cells": cells, "bulk_geometric_ratio": bulk_ratio,
                   "gate_passed": all(c["median_paired_ratio"] <= config["gate"]["max_cell_ratio"] for c in cells)
                                  and bulk_ratio <= config["gate"]["max_bulk_geometric_ratio"],
                   "elapsed_seconds": time.monotonic() - started,
                   "guard_after": guard(config, base)}
        (output / "summary.json").write_text(json.dumps(summary, indent=2) + "\n")
    except BaseException as error:
        (output / "failure.json").write_text(json.dumps({"type": type(error).__name__, "message": str(error),
                                                        "elapsed_seconds": time.monotonic() - started}, indent=2) + "\n")
        raise


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("output", type=Path)
    parser.add_argument("--root-authorized", action="store_true", required=True)
    arguments = parser.parse_args()
    base = Path(__file__).resolve().parent
    capture(load(base / "pair.json"), base, arguments.output)
