"""Summarize raw fixture records; no profiling instrumentation is combined."""
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parent


def combined(path):
    lines = path.read_text().splitlines()
    fields = next(line for line in lines if line.startswith("combined,"))
    row = {key: int(value) for key, value in (field.split("=") for field in fields.split(",")[1:])}
    row["retained_with_owner"] = row["retained_heap"] + row["owner_stack"]
    row["peak_with_owner"] = row["peak_heap"] + row["owner_stack"]
    row["pixels"] = [line for line in lines if line.startswith("pixels,")]
    return row


rows = []
for n in (1, 2, 8):
    reference = combined(ROOT / "baseline" / f"same-device-{n}.txt")
    for label, path in (
        ("baseline same device", ROOT / "baseline" / f"same-device-{n}.txt"),
        ("baseline per device", ROOT / "baseline" / f"per-device-{n}.txt"),
        ("final owned same device", ROOT / "final" / f"owned-same-device-{n}.txt"),
        ("final owned per device", ROOT / "final" / f"owned-per-device-{n}.txt"),
        ("final shared", ROOT / "final" / f"shared-{n}.txt"),
    ):
        row = combined(path)
        assert row.pop("pixels") == reference["pixels"], (label, n, "pixels differ")
        rows.append({"case": label, "windows": n, **row})
(ROOT / "summary.json").write_text(json.dumps(rows, indent=2) + "\n")
print("| Case | Windows | Rust requests | Net heap + owner | Peak heap + owner |")
print("| --- | ---: | ---: | ---: | ---: |")
for row in rows:
    print(f'| {row["case"]} | {row["windows"]} | {row["requests"]:,} | {row["retained_with_owner"]:,} B | {row["peak_with_owner"]:,} B |')
