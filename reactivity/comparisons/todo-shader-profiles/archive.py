#!/usr/bin/env python3
"""Partition complete evidence into raw and source/ELF capsules, then verify both."""

import argparse
import gzip
import hashlib
import io
import json
import os
import shutil
import stat
import tarfile
from pathlib import Path

PROFILES = ("original", "certified", "banked4")


def files_under(root):
    return {path for path in root.rglob("*") if path.is_file() or path.is_symlink()}


def contents(path):
    return os.readlink(path).encode() if path.is_symlink() else path.read_bytes()


def write_archive(output, file_map, description):
    records = {}
    for name, path in sorted(file_map.items()):
        assert not name.startswith("/") and ".." not in Path(name).parts
        assert ".git" not in Path(name).parts
        data = contents(path)
        records[name] = {
            "sha256": hashlib.sha256(data).hexdigest(),
            "bytes": len(data),
            "symlink": path.is_symlink(),
            "mode": stat.S_IMODE(path.lstat().st_mode),
        }
    manifest = (
        json.dumps(
            {"description": description, "files": records}, indent=2, sort_keys=True
        ).encode()
        + b"\n"
    )
    with output.open("wb") as raw:
        with gzip.GzipFile(
            fileobj=raw, mode="wb", filename="", mtime=0, compresslevel=6
        ) as zipped:
            with tarfile.open(
                fileobj=zipped, mode="w", format=tarfile.PAX_FORMAT
            ) as archive:
                for name in sorted([*file_map, "MANIFEST.json"]):
                    data = (
                        manifest
                        if name == "MANIFEST.json"
                        else contents(file_map[name])
                    )
                    info = tarfile.TarInfo(name)
                    info.uid = info.gid = info.mtime = 0
                    info.mode = records[name]["mode"] if name in records else 0o644
                    if name in records and records[name]["symlink"]:
                        info.type = tarfile.SYMTYPE
                        info.linkname = data.decode()
                        archive.addfile(info)
                    else:
                        info.size = len(data)
                        archive.addfile(info, io.BytesIO(data))
    with tarfile.open(output, "r:gz") as archive:
        entries = archive.getmembers()
        members = {entry.name: entry for entry in entries}
        assert len(members) == len(entries)
        assert set(members) == set(records) | {"MANIFEST.json"}
        assert archive.extractfile(members["MANIFEST.json"]).read() == manifest
        for name, record in records.items():
            entry = members[name]
            data = (
                entry.linkname.encode()
                if entry.issym()
                else archive.extractfile(entry).read()
            )
            assert entry.issym() == record["symlink"]
            assert (
                len(data) == record["bytes"]
                and hashlib.sha256(data).hexdigest() == record["sha256"]
            )
            assert entry.mode == record["mode"]
    return {
        "archive": str(output),
        "bytes": output.stat().st_size,
        "sha256": hashlib.sha256(output.read_bytes()).hexdigest(),
        "payload_members": len(records),
        "manifest_sha256": hashlib.sha256(manifest).hexdigest(),
        "exact_member_set_verified": True,
        "all_member_bytes_and_modes_verified": True,
        "description": description,
    }


def partition(evidence, payload):
    complete = files_under(evidence)
    source_evidence = set()
    source_map = {}
    for profile in PROFILES:
        case = evidence / "attempt2/builds" / profile
        for path in files_under(case / "source"):
            source_evidence.add(path)
            source_map[f'source/{profile}/{path.relative_to(case / "source")}'] = path
        for filename in ("todo_comparison_mapped", "ui.wgsl"):
            path = case / filename
            assert path.is_file()
            source_evidence.add(path)
            source_map[f"artifacts/{profile}/{filename}"] = path
    for path in complete:
        if path.name.endswith(".previous-binary"):
            source_evidence.add(path)
            source_map[f"quarantine/{path.relative_to(evidence)}"] = path
    for path in payload.glob("*.py"):
        source_map[f"orchestration/{path.name}"] = path
    for path in (payload / "runner").glob("*.py"):
        source_map[f"runner/{path.name}"] = path
    for path in files_under(payload / "profiles"):
        source_map[f'profiles/{path.relative_to(payload / "profiles")}'] = path
    for filename in ("common-base.tar", "fixture.patch", "manifest.json"):
        source_map[f"provenance/{filename}"] = payload / filename
    raw_files = complete - source_evidence
    assert not (raw_files & source_evidence) and complete == raw_files | source_evidence
    raw_map = {f"evidence/{path.relative_to(evidence)}": path for path in raw_files}
    return raw_map, source_map


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("evidence", type=Path)
    parser.add_argument("payload", type=Path)
    parser.add_argument("output", type=Path)
    args = parser.parse_args()
    raw, source = partition(args.evidence, args.payload)
    args.output.parent.mkdir(parents=True, exist_ok=True)
    maximum_output = sum(
        path.lstat().st_size for path in list(raw.values()) + list(source.values())
    )
    assert (
        shutil.disk_usage(args.output.parent).free
        >= 8 * 1024**3 + maximum_output + 1024**2
    )
    args.output.mkdir(exist_ok=False)
    receipts = {}
    for name, mapping, description in (
        (
            "raw-evidence",
            raw,
            "Every raw setup failure, build receipt/log, native control and registered short trial; source/ELF bytes are in the disjoint source capsule.",
        ),
        (
            "source-and-elfs",
            source,
            "Complete three frozen 0062+739c source scopes, actual WGSL and linked ELFs, prior-binary quarantines, source overlays and orchestration/runner sources; no Git internals or build cache.",
        ),
    ):
        receipt = write_archive(args.output / f"{name}.tar.gz", mapping, description)
        (args.output / f"{name}-receipt.json").write_text(
            json.dumps(receipt, indent=2) + "\n"
        )
        receipts[name] = receipt
    (args.output / "receipts.json").write_text(json.dumps(receipts, indent=2) + "\n")
    print(json.dumps(receipts, indent=2))


if __name__ == "__main__":
    main()
