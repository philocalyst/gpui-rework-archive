#!/usr/bin/env python3
"""Run only in a coordinated quiet window; fail closed on source/binary drift."""
import csv
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess

HERE = Path(__file__).resolve().parent
VARIANTS = {
    "baseline": (Path("/root/gpui-question-inputs-base"), "724ece73cb665a1f6d83e97ae7d431eee11a887a", Path("/tmp/gpui-question-inputs-base-target/release/deps/question_input_cost-6dd33f31329ddedb")),
    "candidate": (Path("/root/gpui-question-inputs"), "d94d3da171a144eb3b9c264f89c31301131e67c3", Path("/tmp/gpui-question-inputs-target/release/deps/question_input_cost-6dd33f31329ddedb")),
}
PATHS = ["Cargo.toml", "Cargo.lock", "crates/gpui/Cargo.toml", "crates/gpui/src/reader.rs", "crates/gpui/src/reader/inputs.rs", "crates/gpui/src/reader/question.rs", "crates/gpui/src/reader/linear_mailbox.rs", "crates/gpui/src/runtime/turn.rs", "crates/gpui/src/runtime/delivery.rs", "crates/gpui/src/remote.rs", "crates/gpui/tests/question_input_cost.rs"]

def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest() if path.exists() else None

def state():
    return {label: {"source_commit": commit, "sources": {p: sha(root / "reactivity" / p) for p in PATHS}, "executable": str(binary), "executable_sha256": sha(binary)} for label, (root, commit, binary) in VARIANTS.items()}

if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument("--freeze", action="store_true")
    args = parser.parse_args()
    if args.freeze:
        metadata = state()
        assert metadata["baseline"]["sources"][PATHS[-1]] == metadata["candidate"]["sources"][PATHS[-1]]
        metadata["machine"] = {"uname": list(os.uname()), "affinity": sorted(os.sched_getaffinity(0)), "cpu": next(line.strip() for line in Path("/proc/cpuinfo").read_text().splitlines() if line.startswith("model name")), "rustc": subprocess.check_output(["rustc", "--version"], text=True).strip(), "profile": "workspace release (default features), Cargo defaults, no RUSTFLAGS", "target_directories": ["/tmp/gpui-question-inputs-base-target", "/tmp/gpui-question-inputs-target"]}
        (HERE / "pins.json").write_text(json.dumps(metadata, indent=2) + "\n")
        raise SystemExit()
    pins = json.loads((HERE / "pins.json").read_text())
    assert {k: pins[k] for k in VARIANTS} == state(), "pre-capture source/binary drift"
    assert not (HERE / "paired.csv").exists(), "preserve prior captures"
    cpu = min(os.sched_getaffinity(0))
    rows, transcripts = [], []
    for round_ in range(7):
        for label in (["baseline", "candidate"] if round_ % 2 == 0 else ["candidate", "baseline"]):
            executable = VARIANTS[label][2]
            output = subprocess.check_output([str(executable), "--ignored", "--exact", "one_source_operation_cost", "--nocapture", "--test-threads=1"], text=True, preexec_fn=lambda: os.sched_setaffinity(0, {cpu}))
            transcripts.append(f"round={round_},variant={label}\n{output}")
            parsed = re.findall(r"(exact_unrelated|coalesced_freeze|completion_and_refresh),(\d+),(\d+),(\d+)$", output, re.M)
            assert len(parsed) == 3, output
            for case, iterations, ns, checksum in parsed:
                assert int(checksum) == (20_000 if case == "exact_unrelated" else 19_999)
                rows.append([round_, label, case, int(iterations), int(ns), int(ns)/int(iterations), int(checksum)])
    assert {k: pins[k] for k in VARIANTS} == state(), "post-capture source/binary drift"
    with (HERE / "paired.csv").open("w") as f:
        writer = csv.writer(f)
        writer.writerow(["round", "variant", "case", "iterations", "ns_total", "ns_per_operation", "checksum"])
        writer.writerows(rows)
    (HERE / "paired-stdout.txt").write_text("\n".join(transcripts))
    (HERE / "capture.json").write_text(json.dumps({"rows": len(rows), "pairs": 7, "cpu": cpu, "source_binary_guards": "pre/post exact", "checksums": "all 42 passed", "kind": "three one-source owner-operation controls, not frame time"}, indent=2) + "\n")
