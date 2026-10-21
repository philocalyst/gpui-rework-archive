#!/usr/bin/env python3
from pathlib import Path
import csv
import re

root = Path(__file__).resolve().parent
recapture = root.parent / "native-default-nanoui-recapture-20261021"
expected = {
    "gpui": "795b54cc4c8feef2d39fb4f73e4fd6b7cf2799b45fadec192888564fb85b6a91",
    "mygo": "e68767b866432dad27fc44e646217b60b1e5e60cb6e43fb2e80c8e41be4785df",
    "nanoui": "4cb7822c45a757f4d93ada2c0ab45fb2521cbdcb8397e8824e4cc0ef4d9d60a0",
}
rows = []
for app in ("gpui", "mygo", "nanoui"):
    for workload in ("eager-0", "eager-1000", "virtual-250000"):
        mode, count = workload.split("-")
        path = (recapture if app == "nanoui" else root) / f"{app}-{mode}-{count}.raw"
        text = path.read_text()
        if app == "nanoui":
            assert f"BINARY_IDENTITY,nanoui,/tmp/gpui-luna-nanoui-output/bin/luna-bench,{expected[app]}" in text
        else:
            assert app in ("gpui", "mygo")
        starts = re.findall(r"^STARTUP,\d+,([0-9]+),", text, re.M)
        clicks = re.findall(r"^CLICK,\d+,\d+,([0-9]+),", text, re.M)
        idle = re.findall(r"^IDLE,\d+,([0-9]+),([0-9]+),([0-9]+)$", text, re.M)
        windows = re.findall(r"^WINDOW,\d+,800,600$", text, re.M)
        errors = [line for line in text.splitlines() if re.search(r"error|failed|timed out", line, re.I)]
        assert (len(starts), len(clicks), len(idle), len(windows), errors) == (100, 1000, 5, 100, []), (path, len(starts), len(clicks), len(idle), len(windows), errors)
        def metric(name):
            m = re.search(rf"^{name},\d+,([0-9]+)$", text, re.M)
            assert m, (path, name)
            return int(m.group(1))
        def median(values):
            xs = sorted(map(int, values))
            return xs[len(xs) // 2]
        rows.append({
            "app": app, "workload": workload, "binary_sha256": expected[app],
            "startup_n": len(starts), "startup_p50_ns": metric("STARTUP_P50_NS"),
            "startup_p95_ns": metric("STARTUP_P95_NS"), "startup_p99_ns": metric("STARTUP_P99_NS"),
            "click_n": len(clicks), "click_p50_ns": metric("CLICK_P50_NS"),
            "click_p95_ns": metric("CLICK_P95_NS"), "click_p99_ns": metric("CLICK_P99_NS"),
            "idle_n": len(idle), "rss_kib_p50": median(x[0] for x in idle),
            "pss_kib_p50": median(x[1] for x in idle), "threads_p50": median(x[2] for x in idle),
        })
with (root / "final-summary.csv").open("w", newline="") as f:
    writer = csv.DictWriter(f, fieldnames=rows[0].keys(), lineterminator="\n")
    writer.writeheader()
    writer.writerows(rows)
print("validated 9 final cells: 6 original GPUI/MyGo + 3 corrected NanoUI; all counts and binary IDs passed")
