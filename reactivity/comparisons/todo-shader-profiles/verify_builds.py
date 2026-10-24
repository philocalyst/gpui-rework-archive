#!/usr/bin/env python3
"""Recheck complete frozen sources, fresh WGSL and each linked ELF, without apps."""

import fcntl
import hashlib
import json
import os
import sys
from pathlib import Path

TASK = Path("/home/miles/gpui-ce3-compute-20261024")
PAYLOAD = TASK / "src/todo-shader-profiles"
EVIDENCE = TASK / "evidence/todo-shader-profiles"
sys.path.insert(0, str(PAYLOAD / "runner"))
import todo_core as core


def main():
    status = json.loads((EVIDENCE / "attempt2/build-status.json").read_text())
    assert status["state"] == "complete" and status["all_builds_reaped"]
    try:
        os.kill(status["pid"], 0)
    except ProcessLookupError:
        pass
    else:
        raise RuntimeError("Build supervisor is still live.")
    results = []
    with (TASK / "host.lock").open("a+") as lease:
        fcntl.flock(lease, fcntl.LOCK_SH)
        for build in status["builds"]:
            name = build["profile"]
            case = EVIDENCE / "attempt2/builds" / name
            receipt = json.loads((case / "receipt.json").read_text())
            source = case / "source"
            metadata = json.loads((source / ".benchmark-upstream.json").read_text())
            expected = metadata["final_files"]
            actual = {
                str(path.relative_to(source))
                for path in source.rglob("*")
                if path.is_file() or path.is_symlink()
            }
            assert actual == set(expected) | {".benchmark-upstream.json"}
            assert len(expected) == 2036
            for filename, record in expected.items():
                path = source / filename
                data = (
                    os.readlink(path).encode()
                    if path.is_symlink()
                    else path.read_bytes()
                )
                assert path.is_symlink() == record["symlink"]
                assert len(data) == record["bytes"]
                assert hashlib.sha256(data).hexdigest() == record["sha256"]
            fingerprint = core.source_fingerprint(source)
            assert (
                receipt["successful"]
                and fingerprint == receipt["source_after"] == build["source"]
            )
            binary = case / "todo_comparison_mapped"
            assert (
                core.file_sha256(binary)
                == receipt["binary_sha256"]
                == build["binary_sha256"]
            )
            wgsl = (case / "ui.wgsl").read_bytes()
            assert hashlib.sha256(wgsl).hexdigest() == build["generated_wgsl_sha256"]
            assert (
                wgsl in binary.read_bytes()
            ), "Generated WGSL is absent from preserved ELF."
            compact = b"".join(wgsl.split())
            count = 4 if name == "banked4" else 16
            assert f"array<vec4f,{count}>".encode() in compact
            assert build["gpu_package_cleaned_and_old_generated_wgsl_absent"]
            assert (
                build["generated_wgsl_mtime_ns"]
                >= build["build_start_realtime_ns"] - 2_000_000_000
            )
            results.append(
                {
                    "profile": name,
                    "source_files_verified": len(expected),
                    "source_fingerprint": fingerprint,
                    "binary_sha256": build["binary_sha256"],
                    "generated_wgsl_sha256": build["generated_wgsl_sha256"],
                    "generated_wgsl_found_in_linked_elf": True,
                    "banked_colors": count,
                }
            )
    output = {
        "all_verified": len(results) == 3,
        "build_supervisor_reaped": True,
        "profiles": results,
    }
    (EVIDENCE / "verification-v1.json").write_text(json.dumps(output, indent=2) + "\n")
    print(json.dumps(output, indent=2))


if __name__ == "__main__":
    main()
