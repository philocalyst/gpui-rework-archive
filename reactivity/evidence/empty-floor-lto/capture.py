#!/usr/bin/env python3
"""Guarded, serial capture for the two frozen empty-window executables.

This script does not create an X server or a session bus. Run it only inside a
coordinated quiet window with a persistent private Xvfb and the intended D-Bus
session already active. It validates source, fixture, lockfile and executable
hashes before every child launch. No percentile claims are emitted: 30 starts
support only a small-sample median and range.
"""
from __future__ import annotations

import argparse
import csv
import hashlib
import os
from pathlib import Path
import statistics
import subprocess
import sys
import time

HERE = Path(__file__).resolve().parent
WORKTREE = HERE.parents[1]
FROZEN = Path("/tmp/gpui-empty-floor-frozen")
MANIFEST = HERE / "manifest.json"
EXPECTED = {
    "default": ("627bab35bf73a4ac7974f1140dda37826662087411ac7a781cd44de48c056530",
                "627bab35bf73a4ac7974f1140dda37826662087411ac7a781cd44de48c056530-empty"),
    "thin_lto_cgu1": ("fa102d5bf72b947dd3fee4079c6299fa532bc639638eab7e715cfecd2cfd60ba",
                      "fa102d5bf72b947dd3fee4079c6299fa532bc639638eab7e715cfecd2cfd60ba-empty"),
}


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def require_identity(name: str, expected_display: str) -> tuple[Path, str]:
    if name not in EXPECTED:
        raise ValueError(f"unknown binary name: {name}")
    digest, relative = EXPECTED[name]
    binary = (FROZEN / relative).resolve(strict=True)
    if sha256(binary) != digest:
        raise RuntimeError(f"binary SHA mismatch for {name}: {binary}")
    if os.environ.get("DISPLAY") != expected_display:
        raise RuntimeError(f"DISPLAY must be exactly {expected_display!r}; got {os.environ.get('DISPLAY')!r}")
    if expected_display == ":94":
        raise RuntimeError("refusing shared test display :94; choose a private Xvfb")
    if not os.environ.get("DBUS_SESSION_BUS_ADDRESS"):
        raise RuntimeError("no D-Bus session detected; run inside dbus-run-session")
    return binary, digest


def fixture_guards() -> None:
    import json

    data = json.loads(MANIFEST.read_text())
    if data["source_commit"] != "88d65eae0a0e832e51a8c7156f236b1e3a8ec5dd":
        raise RuntimeError("unexpected source pin")
    ancestor = subprocess.run(["git", "-C", str(WORKTREE), "merge-base", "--is-ancestor",
                               data["source_commit"], "HEAD"], check=False)
    if ancestor.returncode != 0:
        raise RuntimeError(f"pinned source commit is not an ancestor of worktree HEAD: {data['source_commit']}")
    compiled_paths = ["Cargo.toml", "Cargo.lock", "crates", "vendor", ".cargo",
                      "rust-toolchain.toml", "build.rs"]
    source_delta = subprocess.run(["git", "-C", str(WORKTREE), "diff", "--quiet",
                                   data["source_commit"], "--", *compiled_paths], check=False)
    if source_delta.returncode != 0:
        raise RuntimeError("compiled source/manifests/config differ from the pinned source tree")
    untracked = subprocess.check_output(["git", "-C", str(WORKTREE), "status", "--porcelain",
                                         "--untracked-files=all", "--", *compiled_paths], text=True)
    if untracked.strip():
        raise RuntimeError(f"untracked compiled source/config paths exist:\n{untracked}")
    expected = {
        "crates/gpui/examples/empty.rs": "419d6b422a034f213419cda3f09f794b5ac0d76320cdaa42d5e1f26b42044da8",
        "crates/gpui/examples/support/renderer.rs": "38eac98311473da85d2abefa16e0af384c358a8d5fed2aa60dfc77aeef4298f2",
        "Cargo.lock": "d4835c0d54448d6c5560b9fde1a3a43a9b5497e0d707140ce7c58f13b81ce99f",
    }
    for rel, digest in expected.items():
        if sha256(WORKTREE / rel) != digest:
            raise RuntimeError(f"source/fixture identity mismatch: {rel}")


def read_first_present(child: subprocess.Popen[str], timeout_s: float) -> tuple[int, str, list[str]]:
    deadline = time.monotonic() + timeout_s
    lines: list[str] = []
    assert child.stderr is not None
    while time.monotonic() < deadline:
        # readline is normally quick, but a blocked pipe read would defeat the
        # deadline. poll() the fd and read only when the marker is available.
        import select
        ready, _, _ = select.select([child.stderr], [], [], max(0.0, deadline - time.monotonic()))
        if not ready:
            break
        line = child.stderr.readline()
        if not line:
            break
        lines.append(line.rstrip("\n"))
        if line.startswith("GPUI_PRESENT,"):
            fields = line.rstrip("\n").split(",")
            if len(fields) != 5:
                raise RuntimeError(f"malformed presentation marker: {line!r}")
            return time.monotonic_ns(), line.rstrip("\n"), lines
    raise RuntimeError(f"no first-present marker; exit={child.poll()} stderr={lines!r}")


def stop(child: subprocess.Popen[str]) -> None:
    if child.poll() is None:
        child.terminate()
        try:
            child.wait(timeout=3)
        except subprocess.TimeoutExpired:
            child.kill()
            child.wait(timeout=3)
    if child.stderr:
        child.stderr.close()


def proc_values(path: Path) -> dict[str, int]:
    found: dict[str, int] = {}
    for line in path.read_text().splitlines():
        key, sep, value = line.partition(":")
        words = value.split()
        if sep and words and words[0].isdigit():
            found[key] = int(words[0])
    return found


def mapping_totals(proc: Path) -> dict[str, int]:
    # RSS/PSS here are the kernel's mapping accounting, not live allocator
    # bytes. Classify the rollup by Linux's explicit Pss_* counters.
    vals = proc_values(proc / "smaps_rollup")
    status = proc_values(proc / "status")
    stat_tail = (proc / "stat").read_text().rpartition(")")[2].split()
    return {
        "rss_kib": vals.get("Rss", 0), "pss_kib": vals.get("Pss", 0),
        "pss_anon_kib": vals.get("Pss_Anon", 0), "pss_file_kib": vals.get("Pss_File", 0),
        "pss_shmem_kib": vals.get("Pss_Shmem", 0), "private_clean_kib": vals.get("Private_Clean", 0),
        "private_dirty_kib": vals.get("Private_Dirty", 0), "shared_clean_kib": vals.get("Shared_Clean", 0),
        "shared_dirty_kib": vals.get("Shared_Dirty", 0), "anonymous_kib": vals.get("Anonymous", 0),
        "threads": status.get("Threads", 0), "vmsize_kib": status.get("VmSize", 0),
        "cpu_ticks": int(stat_tail[11]) + int(stat_tail[12]),
    }


def start_child(name: str, display: str, timeout_s: float):
    binary, digest = require_identity(name, display)
    spawned_ns = time.monotonic_ns()
    child = subprocess.Popen([str(binary), "--auto", "--startup"], stdout=subprocess.DEVNULL,
                             stderr=subprocess.PIPE, text=True, bufsize=1)
    try:
        marker_ns, marker, prior = read_first_present(child, timeout_s)
        fields = marker.split(",")
        return child, binary, digest, spawned_ns, marker_ns, fields, prior
    except BaseException:
        stop(child)
        raise


def startup(path: Path, display: str, repeats: int, timeout_s: float) -> None:
    with path.open("w", newline="") as f:
        writer = csv.writer(f)
        writer.writerow(["variant", "round", "binary_sha256", "display", "renderer", "source_epoch",
                         "presentation_epoch", "parent_spawn_to_marker_ns", "fixture_reported_us", "endpoint"])
        vals: dict[str, list[int]] = {key: [] for key in EXPECTED}
        # Alternate process order on every round to reduce slow drift bias.
        for i in range(repeats):
            order = list(EXPECTED) if i % 2 == 0 else list(reversed(EXPECTED))
            for name in order:
                child, binary, digest, spawned, marked, fields, _ = start_child(name, display, timeout_s)
                elapsed = marked - spawned
                vals[name].append(elapsed)
                writer.writerow([name, i + 1, digest, display, fields[1], fields[2], fields[3], elapsed,
                                 fields[4], "parent spawn to first GPUI_PRESENT stderr marker; not X pixel/scanout"])
                f.flush()
                stop(child)
        for name, samples in vals.items():
            print(f"{name}: n={len(samples)} median_ns={int(statistics.median(samples))} min_ns={min(samples)} max_ns={max(samples)}", file=sys.stderr)


def residency(path: Path, display: str, repeats: int, timeout_s: float, target_ms: int) -> None:
    with path.open("w", newline="") as f:
        writer = csv.writer(f)
        metric_names = ["rss_kib", "pss_kib", "pss_anon_kib", "pss_file_kib", "pss_shmem_kib",
                        "private_clean_kib", "private_dirty_kib", "shared_clean_kib", "shared_dirty_kib",
                        "anonymous_kib", "threads", "vmsize_kib", "cpu_ticks"]
        writer.writerow(["variant", "round", "binary_sha256", "display", "renderer", "pid",
                         "spawn_to_marker_ns", "marker_to_sample_ns", "spawn_to_sample_ns", *metric_names])
        for i in range(repeats):
            order = list(EXPECTED) if i % 2 == 0 else list(reversed(EXPECTED))
            for name in order:
                child, binary, digest, spawned, marked, fields, _ = start_child(name, display, timeout_s)
                sample_deadline = marked + target_ms * 1_000_000
                while time.monotonic_ns() < sample_deadline:
                    if child.poll() is not None:
                        raise RuntimeError(f"{name} exited before memory sample")
                    time.sleep(min(0.01, max(0.0, (sample_deadline - time.monotonic_ns()) / 1e9)))
                proc = Path("/proc") / str(child.pid)
                vals = mapping_totals(proc)
                writer.writerow([name, i + 1, digest, display, fields[1], child.pid,
                                 marked - spawned, time.monotonic_ns() - marked,
                                 time.monotonic_ns() - spawned,
                                 *vals.values()])
                f.flush()
                stop(child)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("mode", choices=("startup", "residency"))
    parser.add_argument("output", type=Path)
    parser.add_argument("--display", required=True, help="must be a private persistent Xvfb display")
    parser.add_argument("--repeats", type=int, default=None)
    parser.add_argument("--timeout", type=float, default=20.0)
    parser.add_argument("--sample-ms", type=int, default=750)
    args = parser.parse_args()
    fixture_guards()
    if args.mode == "startup":
        startup(args.output, args.display, args.repeats or 30, args.timeout)
    else:
        residency(args.output, args.display, args.repeats or 5, args.timeout, args.sample_ms)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
