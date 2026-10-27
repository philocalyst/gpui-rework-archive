#!/usr/bin/env python3
"""Independent audit of the frozen rejected campaign."""
import csv
import hashlib
import json
import pathlib
import statistics

root = pathlib.Path(__file__).resolve().parent
manifest = json.loads((root / "manifest.json").read_text())
for name, digest in manifest.items():
    assert hashlib.sha256((root / name).read_bytes()).hexdigest() == digest, name
summary = json.loads((root / "paired-witness/summary.json").read_text())
quantiles = lambda values, p: sorted(values)[round((len(values) - 1) * p)]
cells = {}
for run in summary["runs"]:
    stem = f'{run["repeat"]}-{run["rows"]}-{run["variant"]}'
    base = root / "paired-witness"
    assert json.loads((base / (stem + ".status.json")).read_text())["exit"] == 0
    rows = list(csv.DictReader((base / (stem + ".csv")).open()))
    assert len(rows) == 200
    assert [int(row["batch"]) for row in rows] == list(range(200))
    assert all(int(row["rows"]) == run["rows"] and int(row["ops"]) == 10 for row in rows)
    for clock in ["cpu", "wall"]:
        values = [int(row[clock + "_ns"]) / 10 for row in rows]
        for p in [0.5, 0.95, 0.99]:
            assert quantiles(values, p) == run[clock][str(p)]
    cells[run["repeat"], run["rows"], run["variant"]] = run["cpu"]["0.5"]
assert len(cells) == 50
for rows in [0, 1, 4, 40, 400]:
    ratios = [cells[i, rows, "witness"] / cells[i, rows, "baseline"] for i in range(5)]
    recorded = summary["ratios"][str(rows)]
    assert ratios == recorded["paired_ratios"]
    assert statistics.median(ratios) == recorded["median"]
assert summary["ratios"]["40"]["median"] > 0.8
assert summary["ratios"]["400"]["median"] > 1.05
mutant = (root / "witness-negative/nightly-test.out").read_text()
assert "assertion `left == right` failed: translation=90" in mutant
assert "0 passed; 1 failed" in mutant
assert "3 passed; 0 failed" in (root / "witness-retry/test.out").read_text()
print(f"Verified {len(manifest)} payloads, 50 processes, 10000 batches; candidate rejected.")
