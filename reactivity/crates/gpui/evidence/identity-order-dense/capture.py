"""Guarded serialized public-operation controls. Supply a fresh output directory."""
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


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def launch(name, kind):
    item = MANIFEST["variants"][name]
    assert subprocess.check_output(
        ["git", "-C", item["worktree"], "rev-parse", "HEAD"], text=True
    ).strip() == item["source"]
    subprocess.run(
        ["git", "-C", item["worktree"], "diff", "--exit-code", "HEAD"],
        check=True, stdout=subprocess.DEVNULL,
    )
    assert sha(Path(item["worktree"]) / MANIFEST["fixture"]) == MANIFEST["fixture_sha256"]
    executable = item[kind]
    assert sha(executable["path"]) == executable["sha256"]
    command = [executable["path"]]
    if kind == "apps":
        command += ["runtime::style_ledger::retained_style_cost", "--exact", "--ignored", "--nocapture"]
    return subprocess.check_output(
        command, text=True, preexec_fn=lambda: os.sched_setaffinity(0, {2})
    )


def write_csv(name, rows):
    with (OUT / name).open("w", newline="") as stream:
        writer = csv.DictWriter(stream, fieldnames=list(rows[0]), lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)


start = time.monotonic()
rows = []
for pair in range(7):
    for name in (["baseline", "candidate"] if pair % 2 == 0 else ["candidate", "baseline"]):
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
assert len(rows) == 1260
write_csv("paired.csv", rows)
summary = []
for pattern, count, stage in dict.fromkeys((r["pattern"], r["count"], r["stage"]) for r in rows):
    selected = [r for r in rows if (r["pattern"], r["count"], r["stage"]) == (pattern, count, stage)]
    item = dict(pattern=pattern, count=count, stage=stage)
    values = {}
    for name in ["baseline", "candidate"]:
        part = [r for r in selected if r["binary"] == name]
        assert len(part) == 7
        values[name] = {int(r["pair"]): int(r["ns"]) / int(r["operations"]) for r in part}
        item[name + "_ns"] = statistics.median(values[name].values())
        for key in ["retained", "allocations", "requested", "peak"]:
            observed = {int(r[key]) for r in part}
            assert len(observed) == 1, (pattern, count, stage, key, observed)
            item[name + "_" + key] = observed.pop()
    paired = [(values["candidate"][p] / values["baseline"][p] - 1) * 100 for p in range(7)]
    item.update(paired_change_median=statistics.median(paired), paired_change_min=min(paired), paired_change_max=max(paired))
    summary.append(item)
write_csv("summary.csv", summary)

apps = []
for pair in range(5):
    for name in (["baseline", "candidate"] if pair % 2 == 0 else ["candidate", "baseline"]):
        output = launch(name, "apps")
        (OUT / f"apps-{pair:02}-{name}.txt").write_text(output)
        assert "test result: ok. 1 passed;" in output
        costs = re.findall(r"cost,([^,\n]+),([0-9]+),([0-9]+)", output)
        assert len(costs) == 75
        for index, (operation, count, ns) in enumerate(costs):
            apps.append(dict(pair=pair, binary=name, batch=index // 25, operation=operation, count=int(count), ns=int(ns), ns_per_call=int(ns) / int(count)))
assert len(apps) == 750
write_csv("apps-paired.csv", apps)
summary = []
for operation in dict.fromkeys(row["operation"] for row in apps):
    item = dict(operation=operation)
    values = {}
    for name in ["baseline", "candidate"]:
        part = [r for r in apps if r["operation"] == operation and r["binary"] == name]
        assert len(part) == 15
        item[name + "_ns"] = statistics.median(r["ns_per_call"] for r in part)
        values[name] = {p: statistics.median(r["ns_per_call"] for r in part if r["pair"] == p) for p in range(5)}
    paired = [(values["candidate"][p] / values["baseline"][p] - 1) * 100 for p in range(5)]
    item.update(paired_change_median=statistics.median(paired), paired_change_min=min(paired), paired_change_max=max(paired))
    summary.append(item)
write_csv("apps-summary.csv", summary)
capture = dict(
    elapsed_seconds=time.monotonic() - start,
    cpu=2, fixture_pairs=7, apps_pairs=5, frozen_manifest_sha256=sha(HERE / "frozen.json"),
    scope="Public owner-operation elapsed CPU controls; headless, no native transfer, scheduling, startup, scanout or photon measurements.",
    raw_sha256={p.name: sha(p) for p in sorted(OUT.iterdir()) if p.is_file()},
)
(OUT / "capture.json").write_text(json.dumps(capture, indent=2) + "\n")
print(json.dumps(capture))
