#!/usr/bin/env python3
"""Create and reread a deterministic archive with exact member-set/byte checks."""

import argparse, gzip, hashlib, io, json, os, tarfile
from pathlib import Path

p = argparse.ArgumentParser()
p.add_argument("inputs", type=Path)
p.add_argument("output", type=Path)
p.add_argument("receipt", type=Path)
a = p.parse_args()
spec = json.loads(a.inputs.read_text())
files = {}
for prefix, name in spec["roots"].items():
    root = Path(name)
    if root.is_dir():
        for file in sorted(root.rglob("*")):
            if file.is_file() or file.is_symlink():
                files[f"{prefix}/{file.relative_to(root)}"] = file
    else:
        files[prefix] = root
assert "MANIFEST.json" not in files
records = {}
for name, file in files.items():
    assert (
        not name.startswith("/")
        and ".." not in Path(name).parts
        and ".git" not in Path(name).parts
    )
    data = os.readlink(file).encode() if file.is_symlink() else file.read_bytes()
    records[name] = {
        "bytes": len(data),
        "sha256": hashlib.sha256(data).hexdigest(),
        "symlink": file.is_symlink(),
        "executable": bool(file.lstat().st_mode & 0o111),
    }
manifest = (
    json.dumps(
        {"description": spec["description"], "files": records}, sort_keys=True, indent=2
    ).encode()
    + b"\n"
)
a.output.parent.mkdir(parents=True, exist_ok=True)
with a.output.open("wb") as raw, gzip.GzipFile(
    fileobj=raw, mode="wb", filename="", mtime=0, compresslevel=6
) as gz, tarfile.open(fileobj=gz, mode="w", format=tarfile.PAX_FORMAT) as tar:
    for name in sorted([*files, "MANIFEST.json"]):
        data = (
            manifest
            if name == "MANIFEST.json"
            else (
                os.readlink(files[name]).encode()
                if files[name].is_symlink()
                else files[name].read_bytes()
            )
        )
        info = tarfile.TarInfo(name)
        info.uid = info.gid = info.mtime = 0
        info.mode = 0o755 if name in records and records[name]["executable"] else 0o644
        if name in records and records[name]["symlink"]:
            info.type = tarfile.SYMTYPE
            info.linkname = data.decode()
            tar.addfile(info)
        else:
            info.size = len(data)
            tar.addfile(info, io.BytesIO(data))
with tarfile.open(a.output, "r:gz") as tar:
    members = {m.name: m for m in tar.getmembers()}
    assert set(members) == set(records) | {"MANIFEST.json"}
    assert tar.extractfile(members["MANIFEST.json"]).read() == manifest
    for name, record in records.items():
        member = members[name]
        data = (
            member.linkname.encode()
            if member.issym()
            else tar.extractfile(member).read()
        )
        assert (
            member.issym() == record["symlink"]
            and len(data) == record["bytes"]
            and hashlib.sha256(data).hexdigest() == record["sha256"]
        )
        assert bool(member.mode & 0o111) == record["executable"]
receipt = {
    "archive": str(a.output),
    "bytes": a.output.stat().st_size,
    "sha256": hashlib.sha256(a.output.read_bytes()).hexdigest(),
    "payload_members": len(records),
    "manifest_sha256": hashlib.sha256(manifest).hexdigest(),
    "exact_member_set_verified": True,
    "every_member_bytes_and_mode_verified": True,
    "description": spec["description"],
}
a.receipt.write_text(json.dumps(receipt, indent=2) + "\n")
print(json.dumps(receipt))
