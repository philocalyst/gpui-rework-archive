#!/usr/bin/env python3
"""Verify exact anchored build-source coverage and every exported byte."""

import argparse, hashlib, json, os
from pathlib import Path

p = argparse.ArgumentParser()
p.add_argument("source", type=Path)
p.add_argument("manifest", type=Path)
a = p.parse_args()
m = json.loads(a.manifest.read_text())
expected = m["final_files"]
actual = {
    str(f.relative_to(a.source))
    for f in a.source.rglob("*")
    if f.is_file() or f.is_symlink()
}
assert actual == set(expected) | {".benchmark-upstream.json"}, {
    "missing": sorted(set(expected) - actual),
    "extra": sorted(actual - set(expected) - {".benchmark-upstream.json"}),
}
for name, record in expected.items():
    f = a.source / name
    expected_mode = int(m["upstream_files"].get(name, {"mode": "100644"})["mode"], 8)
    assert bool(f.lstat().st_mode & 0o111) == bool(expected_mode & 0o111), name
    assert f.is_symlink() == record["symlink"], name
    data = os.readlink(f).encode() if f.is_symlink() else f.read_bytes()
    assert (
        len(data) == record["bytes"]
        and hashlib.sha256(data).hexdigest() == record["sha256"]
    ), name
assert (
    m["pin"] == "0062bf589829c4f28807ad0fde3e13285379294c"
    and m["core_production_files_unchanged_from_pin"]
)
assert not [
    n
    for n in expected
    if any(
        part in (".git", "__pycache__", "target", ".zig-cache", "zig-out")
        for part in Path(n).parts
    )
]
print(
    json.dumps(
        {
            "all_files_verified": len(expected),
            "exact_set_verified": True,
            "core_pin": m["pin"],
            "build_scope": m["scope"],
            "full_repository_claim": False,
        }
    )
)
