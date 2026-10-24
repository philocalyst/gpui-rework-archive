#!/usr/bin/env python3
"""Inspect only frozen anonymous executable snapshots from the owned child."""

import argparse, bisect, collections, hashlib, json, subprocess
from pathlib import Path

p = argparse.ArgumentParser()
p.add_argument("diagnostic", type=Path)
p.add_argument("--objdump", type=Path, required=True)
a = p.parse_args()
raw = json.loads((a.diagnostic / "raw-perf-samples.json").read_text())
inventory = json.loads((a.diagnostic / "jit-code-inventory.json").read_text())
assert inventory["actual_bytes"] <= inventory["byte_cap"] == 8 * 1024 * 1024
snapshots = raw["timeline"]
times = [s["monotonic_ns"] for s in snapshots]
resolved = []
counts = collections.Counter()
hot = collections.Counter()
for sample in raw["in_measurement_window"]:
    i = bisect.bisect_right(times, sample["monotonic_ns"]) - 1
    if i < 0:
        resolved.append((sample, None))
        continue
    mapping = None
    for line in snapshots[i]["maps"].splitlines():
        f = line.split(None, 5)
        lo, hi = [int(n, 16) for n in f[0].split("-")]
        if lo <= sample["ip"] < hi and "x" in f[1]:
            mapping = {
                "lo": lo,
                "hi": hi,
                "offset": int(f[2], 16),
                "permissions": f[1],
                "module": f[5] if len(f) > 5 else "[anonymous]",
            }
            break
    counts[mapping["module"] if mapping else "[unresolved]"] += 1
    if mapping and mapping["module"] == "[anonymous]":
        hot[sample["ip"]] += 1
    resolved.append((sample, mapping))
assemblies = []
directory = a.diagnostic / "code-analysis"
directory.mkdir(exist_ok=True)
for snap in inventory["snapshots"]:
    assert (
        snap["owned_pid"] == inventory["owned_pid"]
        and snap["permissions"] == "r-xp"
        and snap["pathname"] is None
    )
    file = a.diagnostic / "jit-code" / Path(snap["path"]).name
    data = file.read_bytes()
    assert (
        len(data) == snap["bytes"]
        and hashlib.sha256(data).hexdigest() == snap["sha256"]
    )
for ip, count in hot.most_common(20):
    snap = next(
        (s for s in inventory["snapshots"] if s["start"] <= ip < s["end"]), None
    )
    if not snap:
        continue
    file = a.diagnostic / "jit-code" / Path(snap["path"]).name
    output = directory / f"{ip:x}.asm"
    command = [
        str(a.objdump),
        "-D",
        "-b",
        "binary",
        "-m",
        "i386:x86-64",
        f"--adjust-vma={snap['start']}",
        f"--start-address={ip}",
        f"--stop-address={min(ip+192,snap['end'])}",
        str(file.relative_to(a.diagnostic)),
    ]
    assembly = subprocess.check_output(command, text=True, cwd=a.diagnostic)
    output.write_text(assembly)
    assemblies.append(
        {
            "ip": ip,
            "samples": count,
            "snapshot_sha256": snap["sha256"],
            "snapshot_monotonic_ns": snap["snapshot_monotonic_ns"],
            "output": str(output.relative_to(a.diagnostic)),
            "command": command,
        }
    )
result = {
    "resolution": "latest preceding /proc maps snapshot; executable mappings only",
    "samples": len(raw["in_measurement_window"]),
    "module_leaf_samples": dict(counts),
    "inventory_bytes": inventory["actual_bytes"],
    "inventory_errors": inventory["errors"],
    "assembly_windows": assemblies,
    "scope": "only owned-child anonymous RX bytes; each window begins at a sampled instruction IP",
    "limits": [
        "Byte snapshots represent their recorded capture times, not proof that every sample saw identical code.",
        "Raw machine instructions have no established function or shader-stage names.",
        "Samples are software CPU-clock statistical observations and may skid, not cycle-exact instruction cost or whole-program attribution.",
    ],
}
(a.diagnostic / "code-analysis.json").write_text(json.dumps(result, indent=2) + "\n")
