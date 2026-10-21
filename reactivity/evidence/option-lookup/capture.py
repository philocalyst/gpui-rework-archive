"""Guarded three-way owner-operation controls; use a fresh output directory."""
from pathlib import Path
import csv
import hashlib
import io
import json
import os
import re
import statistics
import subprocess
import sys
import time

HERE = Path(__file__).resolve().parent
MANIFEST = json.loads((HERE / "frozen.json").read_text())
OUT = Path(sys.argv[1])
OUT.mkdir(parents=True, exist_ok=False)
NAMES = ["original", "narrow", "candidate"]


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def git(item, *args):
    return ["git", "-c", "safe.directory=" + item["worktree"], "-C", item["worktree"], *args]


def launch(name, kind):
    item = MANIFEST["variants"][name]
    assert subprocess.check_output(git(item, "rev-parse", "HEAD"), text=True).strip() == item["source"]
    # Reject tracked edits anywhere and untracked production input. Evidence is
    # deliberately outside crates/vendor; no ancestor-only source guard is used.
    subprocess.run(git(item, "diff", "--exit-code", "HEAD"), check=True, stdout=subprocess.DEVNULL)
    untracked = subprocess.check_output(
        git(item, "ls-files", "--others", "--exclude-standard", "--", "reactivity/crates", "reactivity/vendor"),
        text=True,
    )
    assert not untracked, untracked
    tree = Path(item["worktree"])
    assert sha(tree / MANIFEST["fixture"]) == MANIFEST["fixture_sha256"]
    assert sha(tree / "reactivity/Cargo.lock") == MANIFEST["lock_sha256"]
    executable = item[kind]
    assert sha(executable["path"]) == executable["sha256"]
    command = [executable["path"]]
    if kind == "apps":
        command += ["runtime::style_ledger::retained_style_cost", "--exact", "--ignored", "--nocapture"]
    return subprocess.check_output(command, text=True, preexec_fn=lambda: os.sched_setaffinity(0, {2}))


def order(round_index):
    rotated = NAMES[round_index % 3:] + NAMES[:round_index % 3]
    return rotated if round_index % 2 == 0 else rotated[::-1]


def write_csv(name, rows):
    with (OUT / name).open("w", newline="") as stream:
        writer = csv.DictWriter(stream, fieldnames=list(rows[0]), lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)


def changes(values, baseline, rounds):
    paired = [(values["candidate"][p] / values[baseline][p] - 1) * 100 for p in range(rounds)]
    return dict(
        baseline=baseline,
        baseline_ns=statistics.median(values[baseline].values()),
        candidate_ns=statistics.median(values["candidate"].values()),
        paired_change_median=statistics.median(paired),
        paired_change_min=min(paired),
        paired_change_max=max(paired),
    )


start = time.monotonic()
rows = []
for pair in range(7):
    for name in order(pair):
        output = launch(name, "fixture")
        (OUT / f"raw-{pair:02}-{name}.csv").write_text(output)
        part = list(csv.DictReader(io.StringIO(output)))
        assert len(part) == 90
        assert len({(row["pattern"], row["count"], row["stage"]) for row in part}) == 90
        for row in part:
            if row["stage"] == "drop":
                assert int(row["retained"]) == 0
            if row["stage"].startswith(("focus_", "property_")):
                assert all(int(row[key]) == 0 for key in ["allocations", "requested", "delta", "peak"])
            rows.append(dict(pair=pair, binary=name, **row))
assert len(rows) == 1890
write_csv("paired.csv", rows)
summary = []
for pattern, count, stage in dict.fromkeys((r["pattern"], r["count"], r["stage"]) for r in rows):
    selected = [r for r in rows if (r["pattern"], r["count"], r["stage"]) == (pattern, count, stage)]
    values = {}
    storage = {}
    for name in NAMES:
        part = [r for r in selected if r["binary"] == name]
        assert len(part) == 7
        values[name] = {int(r["pair"]): int(r["ns"]) / int(r["operations"]) for r in part}
    for key in ["retained", "allocations", "requested", "delta", "peak"]:
        observed = {int(r[key]) for r in selected}
        assert len(observed) == 1, (pattern, count, stage, key, observed)
        storage[key] = observed.pop()
    for baseline in NAMES[:2]:
        summary.append(dict(pattern=pattern, count=count, stage=stage, **changes(values, baseline, 7), **storage))
write_csv("summary.csv", summary)

apps = []
for pair in range(5):
    for name in order(pair):
        output = launch(name, "apps")
        (OUT / f"apps-{pair:02}-{name}.txt").write_text(output)
        assert "test result: ok. 1 passed;" in output
        costs = re.findall(r"cost,([^,\n]+),([0-9]+),([0-9]+)", output)
        assert len(costs) == 75
        for index, (operation, count, ns) in enumerate(costs):
            apps.append(dict(pair=pair, binary=name, batch=index // 25, operation=operation, count=int(count), ns=int(ns), ns_per_call=int(ns) / int(count)))
assert len(apps) == 1125
write_csv("apps-paired.csv", apps)
summary = []
for operation in dict.fromkeys(row["operation"] for row in apps):
    values = {}
    for name in NAMES:
        part = [r for r in apps if r["operation"] == operation and r["binary"] == name]
        assert len(part) == 15
        values[name] = {p: statistics.median(r["ns_per_call"] for r in part if r["pair"] == p) for p in range(5)}
    for baseline in NAMES[:2]:
        summary.append(dict(operation=operation, **changes(values, baseline, 5)))
write_csv("apps-summary.csv", summary)
capture = dict(
    elapsed_seconds=time.monotonic() - start,
    cpu=2,
    fixture_rounds=7,
    apps_rounds=5,
    fixture_orders=[order(p) for p in range(7)],
    apps_orders=[order(p) for p in range(5)],
    frozen_manifest_sha256=sha(HERE / "frozen.json"),
    scope="Public owner-operation CPU controls; no native startup/transfer/scanout or GPU latency measurements.",
    raw_sha256={p.name: sha(p) for p in sorted(OUT.iterdir()) if p.is_file()},
)
(OUT / "capture.json").write_text(json.dumps(capture, indent=2) + "\n")
print(json.dumps(capture))
