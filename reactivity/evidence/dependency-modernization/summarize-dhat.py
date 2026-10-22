#!/usr/bin/env python3
"""Group actual DHAT stacks by their first text-stack frame, without timings."""
import argparse
import collections
import hashlib
import json
import pathlib
import re


def summarize(path):
    raw = path.read_bytes()
    data = json.loads(raw)
    groups = collections.defaultdict(lambda: {"requested_bytes": 0, "allocation_blocks": 0})
    for point in data["pps"]:
        frames = [data["ftbl"][index] for index in point["fs"]]
        frame = next((frame for frame in frames if any(namespace in frame for namespace in
                     ["parley::", "parley_engine::", "fontique::"])), None)
        if frame is not None:
            frame = re.sub(r"0x[0-9A-Fa-f]+: ", "", frame).split(" (in ", 1)[0]
            groups[frame]["requested_bytes"] += point["tb"]
            groups[frame]["allocation_blocks"] += point["tbk"]
    return {"profile": path.name, "profile_sha256": hashlib.sha256(raw).hexdigest(),
            "command": data["cmd"],
            "totals": {label: sum(point[key] for point in data["pps"]) for label, key in [
                ("requested_bytes", "tb"), ("allocation_blocks", "tbk"),
                ("peak_live_bytes", "gb"), ("peak_live_blocks", "gbk"),
                ("end_live_bytes", "eb"), ("end_live_blocks", "ebk")]},
            "first_text_stack_frame": dict(sorted(groups.items(), key=lambda row: -row[1]["requested_bytes"]))}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("profiles", type=pathlib.Path, nargs="+")
    parser.add_argument("--output", type=pathlib.Path, required=True)
    args = parser.parse_args()
    args.output.write_text(json.dumps({"method": "First actual Parley/Engine/Fontique stack frame; addresses and binary paths removed only for grouping. Inlined frames may combine call sites. Whole-process DHAT totals include mount, render, and edit; no timing comparison.",
                                      "profiles": [summarize(path) for path in args.profiles]}, indent=2) + "\n")


if __name__ == "__main__":
    main()
