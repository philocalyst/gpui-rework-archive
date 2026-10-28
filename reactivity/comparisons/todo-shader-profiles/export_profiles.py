#!/usr/bin/env python3
"""Freeze shader-only overlays on the already verified 0062 + 739c app source."""

import hashlib
import json
import os
import shutil
import subprocess
from pathlib import Path

CORE = "0062bf589829c4f28807ad0fde3e13285379294c"
PROFILES = {
    "original": CORE,
    "certified": "7ccc65d2673a64499d805f41aaa0e423f15de2ce",
    "banked4": "1a553e6726417309c424fa55327a7eddc88109ff",
}
GPU_FILES = [
    "reactivity/crates/gpu/src/renderer.rs",
    "reactivity/crates/gpu/src/shader.rs",
]
ROOT = Path(__file__).resolve().parents[3]
PREVIOUS = Path("/tmp/gpui-mapped-todo-benchmark-sol-build")
BUILD = Path("/tmp/gpui-todo-shader-profiles-sol-build")
PAYLOAD = BUILD / "payload"


def git(*arguments):
    return subprocess.check_output(["git", "-C", str(ROOT), *arguments])


def sha256(data):
    return hashlib.sha256(data).hexdigest()


def main():
    PAYLOAD.mkdir(exist_ok=False)
    profiles = PAYLOAD / "profiles"
    profiles.mkdir()
    for old_name, new_name in [
        ("0062-scoped-base.tar", "common-base.tar"),
        ("todo-overlay.patch", "fixture.patch"),
    ]:
        os.link(PREVIOUS / old_name, PAYLOAD / new_name)

    base = json.loads((PREVIOUS / "source-manifest.json").read_text())
    assert base["pin"] == CORE
    assert base["fixture_commit"] == "739c074f1dbd07d35d976fb64cd33a9c15030051"
    assert base["archive_sha256"] == sha256((PAYLOAD / "common-base.tar").read_bytes())
    assert base["overlay_sha256"] == sha256((PAYLOAD / "fixture.patch").read_bytes())
    manifest = {
        "core_pin": CORE,
        "fixture_commit": base["fixture_commit"],
        "profiles": {},
    }

    for name, pin in PROFILES.items():
        metadata = json.loads(json.dumps(base))
        overrides = {}
        raw_commit = git("cat-file", "commit", pin)
        assert (
            hashlib.sha1(
                b"commit " + str(len(raw_commit)).encode() + b"\0" + raw_commit
            ).hexdigest()
            == pin
        )
        for filename in GPU_FILES:
            data = git("show", f"{pin}:{filename}")
            blob = git("rev-parse", f"{pin}:{filename}").decode().strip()
            assert (
                hashlib.sha1(
                    b"blob " + str(len(data)).encode() + b"\0" + data
                ).hexdigest()
                == blob
            )
            record = {"sha256": sha256(data), "bytes": len(data), "symlink": False}
            metadata["final_files"][filename] = record
            overrides[filename] = {**record, "git_blob": blob}

        patch = git("diff", "--binary", CORE, pin, "--", *GPU_FILES)
        (profiles / f"{name}.patch").write_bytes(patch)
        metadata.update(
            shader_profile=name,
            gpu_source_pin=pin,
            gpu_source_raw_commit=raw_commit.decode(),
            gpu_source_overrides=overrides,
            gpu_patch_sha256=sha256(patch),
            core_production_files_unchanged_from_pin=name == "original",
            permitted_production_override_paths=GPU_FILES if name != "original" else [],
            all_other_source_and_fixture_bytes_equal_739c=True,
        )
        original_files = base["final_files"]
        changed = {
            filename
            for filename, record in metadata["final_files"].items()
            if record != original_files[filename]
        }
        assert changed <= set(GPU_FILES)
        assert len(metadata["final_files"]) == 2036
        (profiles / f"{name}.json").write_text(json.dumps(metadata, indent=2) + "\n")
        manifest["profiles"][name] = {
            "gpu_source_pin": pin,
            "changed_source_paths": sorted(changed),
            "metadata_sha256": sha256((profiles / f"{name}.json").read_bytes()),
            "gpu_patch_sha256": sha256(patch),
            "gpu_files": overrides,
        }

    runner = PAYLOAD / "runner"
    runner.mkdir()
    for filename in (ROOT / "reactivity/comparisons/five-app-todo").glob("*.py"):
        shutil.copy2(filename, runner / filename.name)
    for filename in Path(__file__).parent.glob("*.py"):
        if filename.name != Path(__file__).name:
            shutil.copy2(filename, PAYLOAD / filename.name)
    (PAYLOAD / "manifest.json").write_text(json.dumps(manifest, indent=2) + "\n")
    print(json.dumps(manifest, indent=2))


if __name__ == "__main__":
    main()
