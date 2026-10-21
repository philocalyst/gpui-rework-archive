#!/usr/bin/env python3
from pathlib import Path
import csv
import re

root = Path(__file__).resolve().parent
captured_binary = {
    "gpui": "795b54cc4c8feef2d39fb4f73e4fd6b7cf2799b45fadec192888564fb85b6a91",
    "mygo": "e68767b866432dad27fc44e646217b60b1e5e60cb6e43fb2e80c8e41be4785df",
    "nanoui": "b2d9c6f4ce2745a1e8d9b68c07f831ab2f7756eb349ed14a2c50891403f513a8",
}
preflight_binary = {
    "gpui": "795b54cc4c8feef2d39fb4f73e4fd6b7cf2799b45fadec192888564fb85b6a91",
    "mygo": "e68767b866432dad27fc44e646217b60b1e5e60cb6e43fb2e80c8e41be4785df",
    "nanoui": "4cb7822c45a757f4d93ada2c0ab45fb2521cbdcb8397e8824e4cc0ef4d9d60a0",
}
rows = []
for path in sorted(root.glob("*.raw")):
    text = path.read_text()
    starts = re.findall(r"^STARTUP,\d+,([0-9]+),", text, re.M)
    clicks = re.findall(r"^CLICK,\d+,\d+,([0-9]+),", text, re.M)
    idle = re.findall(r"^IDLE,\d+,([0-9]+),([0-9]+),([0-9]+)$", text, re.M)
    windows = re.findall(r"^WINDOW,\d+,800,600$", text, re.M)
    failures = [line for line in text.splitlines() if re.search(r"error|failed|timed out", line, re.I)]
    assert (len(starts), len(clicks), len(idle), len(windows), failures) == (100, 1000, 5, 100, []), (path.name, len(starts), len(clicks), len(idle), len(windows), failures)
    app, mode, rows_count = path.stem.split("-")
    def metric(name):
        match = re.search(rf"^{name},\d+,([0-9]+)$", text, re.M)
        assert match, (path.name, name)
        return int(match.group(1))
    def median(values):
        xs = sorted(map(int, values))
        return xs[len(xs) // 2]
    rows.append({
        "app": app, "workload": f"{mode}-{rows_count}",
        "capture_binary_sha256": captured_binary[app],
        "preflight_binary_sha256": preflight_binary[app],
        "validity": "valid" if captured_binary[app] == preflight_binary[app] else "invalid_binary_mismatch",
        "startup_n": len(starts), "startup_p50_ns": metric("STARTUP_P50_NS"),
        "startup_p95_ns": metric("STARTUP_P95_NS"), "startup_p99_ns": metric("STARTUP_P99_NS"),
        "click_n": len(clicks), "click_p50_ns": metric("CLICK_P50_NS"),
        "click_p95_ns": metric("CLICK_P95_NS"), "click_p99_ns": metric("CLICK_P99_NS"),
        "idle_n": len(idle), "rss_kib_p50": median(x[0] for x in idle),
        "pss_kib_p50": median(x[1] for x in idle), "threads_p50": median(x[2] for x in idle),
    })
with (root / "summary.csv").open("w", newline="") as output:
    writer = csv.DictWriter(output, fieldnames=rows[0].keys(), lineterminator="\n")
    writer.writeheader()
    writer.writerows(rows)
invalid = sum(row["validity"] != "valid" for row in rows)
print(f"validated {len(rows)} raw cells; {invalid} have executable identity mismatch and are invalid for comparison")
