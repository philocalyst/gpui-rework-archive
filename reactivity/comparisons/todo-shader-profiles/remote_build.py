#!/usr/bin/env python3
"""Build three frozen shader overlays serially, preserving fresh WGSL and ELFs."""

import datetime
import fcntl
import hashlib
import json
import os
import re
import shutil
import signal
import subprocess
import sys
import tarfile
import time
import traceback
from pathlib import Path

TASK = Path("/home/miles/gpui-ce3-compute-20261024")
PAYLOAD = TASK / "src/todo-shader-profiles"
SOURCE = PAYLOAD / "source"
TARGET = TASK / "targets/todo-shader-profiles"
EVIDENCE = TASK / "evidence/todo-shader-profiles/attempt2"
RUNNER = PAYLOAD / "runner"
sys.path.insert(0, str(RUNNER))
import todo_core as core

STATUS = {"pid": os.getpid(), "pgid": os.getpgrp(), "state": "starting", "builds": []}
STOP = False


def save():
    (EVIDENCE / "build-status.json").write_text(json.dumps(STATUS, indent=2) + "\n")


def request_stop(signum, frame):
    global STOP
    STOP = True


def verify_source(metadata):
    expected = metadata["final_files"]
    actual = {
        str(path.relative_to(SOURCE))
        for path in SOURCE.rglob("*")
        if path.is_file() or path.is_symlink()
    }
    assert actual == set(expected) | {".benchmark-upstream.json"}
    for name, record in expected.items():
        path = SOURCE / name
        assert path.is_symlink() == record["symlink"], name
        data = os.readlink(path).encode() if path.is_symlink() else path.read_bytes()
        assert len(data) == record["bytes"], name
        assert hashlib.sha256(data).hexdigest() == record["sha256"], name


def terminate_owned_compiler(helper):
    children = Path(f"/proc/{helper.pid}/task/{helper.pid}/children")
    if children.exists():
        for value in children.read_text().split():
            pid = int(value)
            try:
                if os.getpgid(pid) == pid:
                    os.killpg(pid, signal.SIGTERM)
            except ProcessLookupError:
                pass


def run_guarded_build(name):
    case = EVIDENCE / "builds" / name
    case.mkdir(parents=True, exist_ok=False)
    script = case / "build.sh"
    script.write_text(f"""#!/usr/bin/env bash
set -euo pipefail
source {TASK}/env.sh
export CARGO_HOME=/home/miles/.cargo CARGO_BUILD_JOBS=4
export CARGO_INCREMENTAL=0 CARGO_PROFILE_RELEASE_DEBUG=0
export CARGO_TARGET_DIR={TARGET}
cd {SOURCE}/reactivity
cargo clean --offline --locked --release -p gpui_gpu
python3 - <<'PY'
from pathlib import Path
assert not [p for p in Path('{TARGET}/release/build').rglob('ui.wgsl') if any(part == 'gpui_gpu' or part.startswith('gpui_gpu-') for part in p.parts)]
PY
cargo build --offline --locked --release -vv -p gpui --example todo_comparison_mapped --features x11
/nix/store/if2h609psbpg1ysf1m27dpshjk2wzpk4-patchelf-0.15.2/bin/patchelf --set-interpreter /nix/store/pqyiidz5mi73wv5f91d48s9plcqyj5bz-glibc-2.44-57/lib/ld-linux-x86-64.so.2 {TARGET}/release/examples/todo_comparison_mapped
""")
    command = case / "command.json"
    command.write_text(json.dumps(["bash", str(script)]))
    binary = TARGET / "release/examples/todo_comparison_mapped"
    started = time.time_ns()
    helper = subprocess.Popen(
        [
            sys.executable,
            str(RUNNER / "build_one.py"),
            "--source",
            str(SOURCE),
            "--binary",
            str(binary),
            "--lease",
            str(TASK / "host.lock"),
            "--receipt",
            str(case / "receipt.json"),
            "--log",
            str(case / "build.log"),
            "--command-json",
            str(command),
            "--timeout",
            "1800",
            "--disk-floor-gib",
            "8",
        ],
        start_new_session=True,
    )
    while helper.poll() is None:
        if STOP:
            terminate_owned_compiler(helper)
        time.sleep(0.5)
    if helper.returncode != 0 or STOP:
        raise RuntimeError(
            f"{name} guarded build failed: {helper.returncode}; stop={STOP}"
        )
    receipt = json.loads((case / "receipt.json").read_text())
    assert receipt["successful"]
    generated = [
        path
        for path in (TARGET / "release/build").rglob("ui.wgsl")
        if any(
            part == "gpui_gpu" or part.startswith("gpui_gpu-") for part in path.parts
        )
    ]
    assert len(generated) == 1, generated
    wgsl = generated[0]
    compile_lines = [
        line
        for line in (case / "build.log").read_text().splitlines()
        if "--crate-name gpui_gpu " in line and "OUT_DIR=" in line
    ]
    assert len(compile_lines) == 1
    compiler_out = re.search(r"\bOUT_DIR=([^ ]+)", compile_lines[0])
    assert compiler_out and Path(compiler_out.group(1)) / "ui.wgsl" == wgsl
    assert wgsl.stat().st_mtime_ns >= started - 2_000_000_000
    text = wgsl.read_text()
    expected = 4 if name == "banked4" else 16
    compact = "".join(text.split())
    assert f"array<vec4f,{expected}>" in compact
    if name == "banked4":
        assert "array<vec4f,16>" not in compact
    assert "banked_fragment" in text
    shutil.copy2(wgsl, case / "ui.wgsl")
    shutil.copy2(binary, case / "todo_comparison_mapped")
    shutil.copytree(SOURCE, case / "source")
    assert core.source_fingerprint(case / "source") == receipt["source_after"]
    assert core.file_sha256(case / "todo_comparison_mapped") == receipt["binary_sha256"]
    result = {
        "profile": name,
        "successful": True,
        "source": receipt["source_after"],
        "frozen_source_path": str(case / "source"),
        "frozen_binary_path": str(case / "todo_comparison_mapped"),
        "binary_sha256": receipt["binary_sha256"],
        "binary_bytes": binary.stat().st_size,
        "generated_wgsl_sha256": core.file_sha256(wgsl),
        "generated_wgsl_path": str(wgsl),
        "generated_wgsl_mtime_ns": wgsl.stat().st_mtime_ns,
        "build_start_realtime_ns": started,
        "expected_banked_colors": expected,
        "gpu_package_cleaned_and_old_generated_wgsl_absent": True,
    }
    (case / "freshness.json").write_text(json.dumps(result, indent=2) + "\n")
    return result


def main():
    EVIDENCE.mkdir(parents=True, exist_ok=True)
    save()
    with (TASK / "host.lock").open("a+") as lease:
        fcntl.flock(lease, fcntl.LOCK_SH)
        previous = TASK / "evidence/todo-shader-profiles/builds/original/receipt.json"
        receipt = json.loads(previous.read_text())
        assert receipt["successful"]
        assert core.source_fingerprint(SOURCE) == receipt["source_after"]
        assert (
            core.file_sha256(TARGET / "release/examples/todo_comparison_mapped")
            == receipt["binary_sha256"]
        )
        if shutil.disk_usage(TASK).free < 8.5 * 1024**3:
            raise RuntimeError(
                "Need 8.5 GiB before continuation; build floor remains 8 GiB."
            )
        STATUS["state"] = "reuse-guarded-attempt1-cache"
        save()
        for name in ("original", "certified", "banked4"):
            if STOP:
                raise RuntimeError("Build supervisor interrupted before next profile.")
            STATUS.update(state="building", profile=name)
            save()
            with tarfile.open(PAYLOAD / "common-base.tar") as archive:
                for filename in (
                    "reactivity/crates/gpu/src/renderer.rs",
                    "reactivity/crates/gpu/src/shader.rs",
                ):
                    archive.extract(filename, SOURCE, filter="data")
            patch = PAYLOAD / "profiles" / f"{name}.patch"
            if patch.stat().st_size:
                subprocess.run(["git", "apply", str(patch)], cwd=SOURCE, check=True)
            metadata = json.loads((PAYLOAD / "profiles" / f"{name}.json").read_text())
            (SOURCE / ".benchmark-upstream.json").write_text(
                json.dumps(metadata, indent=2) + "\n"
            )
            verify_source(metadata)
            result = run_guarded_build(name)
            verify_source(metadata)
            STATUS["builds"].append(result)
            save()
        STATUS.update(state="complete", all_builds_reaped=True)


if __name__ == "__main__":
    signal.signal(signal.SIGINT, request_stop)
    signal.signal(signal.SIGTERM, request_stop)
    try:
        main()
    except BaseException as error:
        STATUS.update(
            state="failed", error=repr(error), traceback=traceback.format_exc()
        )
    finally:
        STATUS["completed_utc"] = datetime.datetime.now(
            datetime.timezone.utc
        ).isoformat()
        save()
