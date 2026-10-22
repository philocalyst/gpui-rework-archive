#!/usr/bin/env python3
"""Preserve a Cargo JSON executable before a subsequent control build."""
import hashlib
import json
import pathlib
import shutil
import subprocess
import sys

source, destination, repository = map(pathlib.Path, sys.argv[1:])
rows = [json.loads(line) for line in source.read_text().splitlines()]
row = next(row for row in rows if row.get("executable"))
executable = pathlib.Path(row["executable"])
shutil.copy2(executable, destination)
record = {
    "source_commit": subprocess.check_output(
        ["git", "-C", str(repository), "rev-parse", "HEAD"], text=True).strip(),
    "manifest_sha256": hashlib.sha256((repository / "reactivity/Cargo.toml").read_bytes()).hexdigest(),
    "gpui_manifest_sha256": hashlib.sha256((repository / "reactivity/crates/gpui/Cargo.toml").read_bytes()).hexdigest(),
    "lock_sha256": hashlib.sha256((repository / "reactivity/Cargo.lock").read_bytes()).hexdigest(),
    "target": row["target"],
    "features": row["features"],
    "features_sha256": hashlib.sha256(json.dumps(sorted(row["features"]), separators=(",", ":")).encode()).hexdigest(),
    "profile": row["profile"],
    "executable": str(destination),
    "executable_sha256": hashlib.sha256(destination.read_bytes()).hexdigest(),
    "executable_bytes": destination.stat().st_size,
}
destination.with_suffix(".json").write_text(json.dumps(record, indent=2) + "\n")
