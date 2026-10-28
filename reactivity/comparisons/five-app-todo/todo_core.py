#!/usr/bin/env python3
"""Counterbalanced native Todo comparison runner.

Build both release binaries first, source /tmp/gpui-native-env.sh, then run
this script on the owned Xvfb display. This script records process and host
present data; Linux in this environment has no hardware render node, so it
does not claim GPU utilization or physical scanout smoothness.
"""

from __future__ import annotations

import argparse
import atexit
import ctypes
import ctypes.util
import hashlib
import json
import os
import platform
import shutil
import signal
import statistics
import subprocess
import sys
import threading
import time
import traceback
from dataclasses import asdict, dataclass
from pathlib import Path
from typing import Any


XDOTOOL = shutil.which("xdotool") or "/nix/store/qvckv6m6ycsa8f26w0f20mzk5w4v9ciq-xdotool-4.20260303.1/bin/xdotool"
TICK_HZ = 60
EXPECTED_WINDOW_TITLES = {"gpui": "GPUI Todo comparison", "zgui": "Todos", "gpui-auto": "GPUI Todo comparison"}
ANIMATION_ROWS = 1_000
HEAVY_ROWS = 10_000
BUSY_SECONDS = 30.0
BUSY_SLOT_SECONDS = 0.25
BINUTILS_DIR = Path("/nix/store/ddk8rvjihg4vhh1k6x9rc65y1zb1kx34-binutils-2.46/bin")
DBUS_LIBDIR = "/nix/store/8pr51y4c1a72yr4fd7g561g1vk5m5k1p-dbus-1.16.2-lib/lib"
BUSY_MACRO = [
    "type",  # focus the input and type one deterministic draft
    "add",
    "complete",
    "active",
    "done",
    "all",
    "delete",
    "undo",
]
ACTIVE_CHILDREN: set["Child"] = set()


@dataclass
class ProcSample:
    t_ns: int
    cpu_ticks: int
    minor_faults: int
    major_faults: int
    rss_kb: int | None
    pss_kb: int | None
    private_kb: int | None


def _status_kb(path: Path, key: str) -> int | None:
    try:
        for line in path.read_text().splitlines():
            if line.startswith(key + ":"):
                return int(line.split()[1])
    except (OSError, ValueError, IndexError):
        return None
    return None


class XClientMessageData(ctypes.Union):
    _fields_ = [("b", ctypes.c_char * 20), ("s", ctypes.c_short * 10), ("l", ctypes.c_long * 5)]


class XClientMessageEvent(ctypes.Structure):
    _fields_ = [
        ("type", ctypes.c_int),
        ("serial", ctypes.c_ulong),
        ("send_event", ctypes.c_int),
        ("display", ctypes.c_void_p),
        ("window", ctypes.c_ulong),
        ("message_type", ctypes.c_ulong),
        ("format", ctypes.c_int),
        ("data", XClientMessageData),
    ]


class XEvent(ctypes.Union):
    _fields_ = [("type", ctypes.c_int), ("xclient", XClientMessageEvent), ("pad", ctypes.c_long * 24)]


def send_wm_delete(window_id: int) -> bool:
    """Ask the client to close through the X11 WM_DELETE_WINDOW protocol."""
    library = os.environ.get("TODO_X11_LIBRARY") or ctypes.util.find_library("X11") or "libX11.so.6"
    try:
        x11 = ctypes.CDLL(library)
        x11.XOpenDisplay.restype = ctypes.c_void_p
        x11.XOpenDisplay.argtypes = [ctypes.c_char_p]
        x11.XInternAtom.restype = ctypes.c_ulong
        x11.XInternAtom.argtypes = [ctypes.c_void_p, ctypes.c_char_p, ctypes.c_int]
        x11.XSendEvent.restype = ctypes.c_int
        x11.XSendEvent.argtypes = [ctypes.c_void_p, ctypes.c_ulong, ctypes.c_int, ctypes.c_long, ctypes.POINTER(XEvent)]
        x11.XFlush.argtypes = [ctypes.c_void_p]
        x11.XCloseDisplay.argtypes = [ctypes.c_void_p]
        display = x11.XOpenDisplay(None)
        if not display:
            return False
        event = XEvent()
        event.xclient.type = 33  # ClientMessage
        event.xclient.serial = 0
        event.xclient.send_event = 1
        event.xclient.display = display
        event.xclient.window = window_id
        event.xclient.message_type = x11.XInternAtom(display, b"WM_PROTOCOLS", 0)
        event.xclient.format = 32
        event.xclient.data.l[0] = x11.XInternAtom(display, b"WM_DELETE_WINDOW", 0)
        event.xclient.data.l[1] = 0  # CurrentTime
        sent = x11.XSendEvent(display, window_id, 0, 0, ctypes.byref(event))
        x11.XFlush(display)
        x11.XCloseDisplay(display)
        return bool(sent)
    except (OSError, AttributeError):
        return False


def proc_sample(pid: int) -> ProcSample | None:
    proc = Path("/proc") / str(pid)
    try:
        raw = (proc / "stat").read_text()
        tail = raw[raw.rfind(")") + 2 :].split()  # fields start at proc stat field 3
        cpu_ticks = int(tail[11]) + int(tail[12])
        minor_faults = int(tail[7])
        major_faults = int(tail[9])
    except (OSError, ValueError, IndexError):
        return None
    rss_kb = _status_kb(proc / "status", "VmRSS")
    pss_kb = None
    private_kb = None
    try:
        for line in (proc / "smaps_rollup").read_text().splitlines():
            fields = line.split()
            if len(fields) >= 2 and fields[0] == "Pss:":
                pss_kb = int(fields[1])
            elif len(fields) >= 2 and fields[0] in ("Private_Clean:", "Private_Dirty:"):
                private_kb = (private_kb or 0) + int(fields[1])
    except (OSError, ValueError, IndexError):
        pass
    return ProcSample(time.monotonic_ns(), cpu_ticks, minor_faults, major_faults, rss_kb, pss_kb, private_kb)


class Child:
    def __init__(self, binary: Path, env: dict[str, str], log_path: Path):
        self.started_ns = time.monotonic_ns()
        self.proc = subprocess.Popen(
            [str(binary)],
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            env=env,
            text=True,
            bufsize=1,
            start_new_session=True,
        )
        self.events: list[tuple[int, str]] = []
        self.lock = threading.Lock()
        self.log = log_path.open("w", buffering=1)
        self.reader = threading.Thread(target=self._read, daemon=True)
        self.reader.start()
        self.graceful_close = False
        self.window_id: int | None = None
        ACTIVE_CHILDREN.add(self)

    def _read(self) -> None:
        assert self.proc.stdout is not None
        for line in self.proc.stdout:
            seen_ns = time.monotonic_ns()
            self.log.write(line)
            with self.lock:
                self.events.append((seen_ns, line.rstrip("\n")))

    def first_present_ns(self) -> int | None:
        with self.lock:
            for seen_ns, line in self.events:
                if line.startswith("TODO_FIRST_PRESENT,"):
                    return seen_ns
        return None

    def first_internal_present_event(self) -> tuple[int, int] | None:
        with self.lock:
            for seen_ns, line in self.events:
                if line.startswith("TODO_FIRST_PRESENT,"):
                    try:
                        return seen_ns, int(line.split(",", 1)[1])
                    except ValueError:
                        return None
        return None

    def close_window(self, window_id: int | None) -> None:
        if window_id is None:
            window_id = self.window_id
        close_sent = False
        self.close_escalated = False
        if window_id is not None and self.proc.poll() is None:
            close_sent = send_wm_delete(window_id)
        try:
            self.proc.wait(timeout=8)
        except subprocess.TimeoutExpired:
            self.close_escalated = True
            # Fallback only after asking the native window to close normally.
            os.killpg(self.proc.pid, signal.SIGTERM)
            try:
                self.proc.wait(timeout=3)
            except subprocess.TimeoutExpired:
                os.killpg(self.proc.pid, signal.SIGKILL)
                self.proc.wait()
        self.graceful_close = close_sent and self.proc.returncode == 0 and not self.close_escalated
        self.reader.join(timeout=2)
        self.log.close()
        ACTIVE_CHILDREN.discard(self)

    def log_lines(self) -> list[str]:
        with self.lock:
            return [line for _, line in self.events]


def close_active_children() -> None:
    """Reap any child left behind by an exceptional trial or interpreter exit."""
    for child in list(ACTIVE_CHILDREN):
        try:
            child.close_window(child.window_id)
        except Exception:
            if child.proc.poll() is None:
                child.proc.kill()
                child.proc.wait()


atexit.register(close_active_children)


def wait_window(pid: int, expected_title: str, timeout: float = 40.0) -> tuple[int, str, int, int, int, int]:
    deadline = time.monotonic() + timeout
    while time.monotonic() < deadline:
        found = subprocess.run([XDOTOOL, "search", "--onlyvisible", "--pid", str(pid)], capture_output=True, text=True)
        if found.returncode == 0 and found.stdout.strip():
            window_id = int(found.stdout.strip().splitlines()[0])
            title = subprocess.run([XDOTOOL, "getwindowname", str(window_id)], check=True, capture_output=True, text=True).stdout.strip()
            if title != expected_title:
                time.sleep(0.05)
                continue
            geom = subprocess.run([XDOTOOL, "getwindowgeometry", "--shell", str(window_id)], check=True, capture_output=True, text=True).stdout
            data = dict(line.split("=", 1) for line in geom.splitlines() if "=" in line)
            return window_id, title, int(data["X"]), int(data["Y"]), int(data["WIDTH"]), int(data["HEIGHT"])
        time.sleep(0.05)
    raise TimeoutError("Todo window did not appear")


def click(window_id: int, x: int, y: int) -> bool:
    result = subprocess.run([XDOTOOL, "mousemove", "--sync", "--window", str(window_id), str(x), str(y), "click", "1"], check=False, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    return result.returncode == 0


def busy_action(window_id: int, action: str, cycle: int, targets: dict[str, list[int]]) -> bool:
    if action == "type":
        focused = click(window_id, *targets["input"])
        typed = subprocess.run([XDOTOOL, "type", "--clearmodifiers", "--delay", "1", f"bench-{cycle:03d}"], check=False, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        return focused and typed.returncode == 0
    return click(window_id, *targets[action])


def macro_counts(requested: int) -> tuple[int, int]:
    inputs = sum(1 for slot in range(requested) if BUSY_MACRO[slot % len(BUSY_MACRO)] == "type")
    return inputs, requested - inputs


def wait_first_present(child: Child, timeout: float = 90.0) -> int:
    deadline = time.monotonic() + timeout
    while time.monotonic() < deadline:
        present = child.first_present_ns()
        if present is not None:
            return present
        if child.proc.poll() is not None:
            child.close_window(None)
            raise RuntimeError(f"app exited before first present: {child.log_lines()[-10:]}")
        time.sleep(0.01)
    child.close_window(None)
    raise TimeoutError("first successful present marker not observed; child was reaped")


def summarize_samples(samples: list[ProcSample]) -> dict[str, Any]:
    if len(samples) < 2:
        return {"samples": len(samples)}
    first, last = samples[0], samples[-1]
    elapsed_s = (last.t_ns - first.t_ns) / 1e9
    ticks_per_second = os.sysconf(os.sysconf_names["SC_CLK_TCK"])
    cpu_s = (last.cpu_ticks - first.cpu_ticks) / ticks_per_second
    pss = [sample.pss_kb for sample in samples if sample.pss_kb is not None]
    rss = [sample.rss_kb for sample in samples if sample.rss_kb is not None]
    private = [sample.private_kb for sample in samples if sample.private_kb is not None]
    return {
        "samples": len(samples),
        "sample_elapsed_s": elapsed_s,
        "process_cpu_s": cpu_s,
        "process_cpu_percent_one_core_100": 100.0 * cpu_s / elapsed_s if elapsed_s else None,
        "minor_faults_delta": last.minor_faults - first.minor_faults,
        "major_faults_delta": last.major_faults - first.major_faults,
        "rss_kb_peak": max(rss) if rss else None,
        "pss_kb_peak": max(pss) if pss else None,
        "pss_kb_median": statistics.median(pss) if pss else None,
        "private_kb_peak": max(private) if private else None,
    }


def file_sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as source:
        for chunk in iter(lambda: source.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def git_head(path: Path) -> str | None:
    result = subprocess.run(["git", "-C", str(path), "rev-parse", "HEAD"], capture_output=True, text=True)
    return result.stdout.strip() if result.returncode == 0 else None


def source_fingerprint(path: Path) -> dict[str, Any]:
    """Hash the exact checkout, including benchmark-only untracked files."""
    portable = path / ".benchmark-upstream.json"
    if portable.is_file():
        metadata = json.loads(portable.read_text())
        digest = hashlib.sha256()
        files = 0
        for source in sorted(path.rglob("*")):
            relative = source.relative_to(path)
            if any(part in (".git", "__pycache__", "target", ".zig-cache", "zig-out") for part in relative.parts):
                continue
            if source.is_symlink():
                content = os.readlink(source).encode()
                if source.resolve().is_file():
                    content += bytes.fromhex(file_sha256(source.resolve()))
            elif source.is_file():
                content = bytes.fromhex(file_sha256(source))
            else:
                continue
            digest.update(str(relative).encode() + b"\0" + content)
            digest.update(str(source.lstat().st_mode & 0o111).encode())
            files += 1
        return {"head": metadata["pin"], "status": "portable build-source export plus sealed adapter", "sha256": digest.hexdigest(), "files": files, "upstream_tree": metadata["tree"], "base_archive_sha256": metadata["source_tar_sha256"], "adapter_patch_sha256": metadata.get("adapter_patch_sha256")}
    head = git_head(path)
    status = subprocess.run(
        ["git", "-C", str(path), "status", "--porcelain=v1", "-z"],
        check=True,
        capture_output=True,
    ).stdout
    diff = subprocess.run(
        ["git", "-C", str(path), "diff", "HEAD", "--binary"],
        check=True,
        capture_output=True,
    ).stdout
    untracked = subprocess.run(
        ["git", "-C", str(path), "ls-files", "--others", "--exclude-standard", "-z"],
        check=True,
        capture_output=True,
    ).stdout.split(b"\0")
    digest = hashlib.sha256()
    digest.update((head or "").encode())
    digest.update(status)
    digest.update(diff)
    for raw_name in sorted(name for name in untracked if name):
        source = path / raw_name.decode(errors="surrogateescape")
        if source.is_file():
            digest.update(raw_name)
            digest.update(bytes.fromhex(file_sha256(source)))
    supplemental = {}
    staged = subprocess.run(["git", "-C", str(path), "ls-files", "--stage", "-z"], check=True, capture_output=True).stdout
    for entry in staged.split(b"\0"):
        if not entry: continue
        metadata, raw_name = entry.split(b"\t", 1)
        mode = metadata.split()[0]
        name = raw_name.decode(errors="surrogateescape")
        source = path / name
        if mode == b"120000":
            target = source.resolve()
            supplemental[name] = {"target": str(target), "sha256": file_sha256(target) if target.is_file() else None}
        elif mode == b"160000":
            supplemental[name] = source_fingerprint(source) if (source / ".git").exists() else {"uninitialized_submodule": True}
    digest.update(json.dumps(supplemental, sort_keys=True).encode())
    return {"head": head, "status": status.decode(errors="replace"), "sha256": digest.hexdigest(), "supplemental": supplemental}


def trial_fingerprint(gpui_source: Path, zgui_source: Path, binaries: dict[str, Path]) -> dict[str, Any]:
    return {
        "gpui_source": source_fingerprint(gpui_source),
        "zgui_source": source_fingerprint(zgui_source),
        "binaries": {name: file_sha256(path) for name, path in binaries.items()},
    }


def stripped_size(binary: Path, variant: str, output: Path) -> dict[str, Any]:
    strip_tool = str(BINUTILS_DIR / "strip")
    if not strip_tool:
        return {"bytes": None, "tool": None, "error": "strip tool unavailable"}
    copy = output / "size" / f"{variant}.stripped"
    copy.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(binary, copy)
    result = subprocess.run([strip_tool, "--strip-all", str(copy)], capture_output=True, text=True)
    if result.returncode != 0:
        copy.unlink(missing_ok=True)
        return {"bytes": None, "tool": strip_tool, "error": result.stderr.strip()}
    return {"bytes": copy.stat().st_size, "sha256": file_sha256(copy), "tool": strip_tool, "copy": str(copy)}


def elf_dependencies(binary: Path, runtime_environment=None) -> dict[str, Any]:
    readelf = shutil.which("readelf") or str(BINUTILS_DIR / "readelf")
    ldd = shutil.which("ldd")
    result: dict[str, Any] = {}
    if readelf:
        dynamic = subprocess.run([readelf, "-d", str(binary)], capture_output=True, text=True)
        result["readelf_tool"] = readelf
        result["readelf_dynamic"] = dynamic.stdout.strip() if dynamic.returncode == 0 else None
        if runtime_environment is not None:
            program = subprocess.run([readelf, "-l", str(binary)], capture_output=True, text=True)
            interpreter = next((line.split("Requesting program interpreter:",1)[1].strip().rstrip("]") for line in program.stdout.splitlines() if "Requesting program interpreter:" in line), None)
            result["runtime_loader"] = interpreter
            result["runtime_library_path"] = runtime_environment.get("LD_LIBRARY_PATH")
            if interpreter:
                loaded = subprocess.run([interpreter,"--list",str(binary)],env={**os.environ,**runtime_environment},capture_output=True,text=True)
                result["qualified_ldd_equivalent"] = {"command":[interpreter,"--list",str(binary)],"exit_code":loaded.returncode,"stdout":loaded.stdout,"stderr":loaded.stderr,"missing_loader_warnings":[line for line in (loaded.stdout+loaded.stderr).splitlines() if "not found" in line or "error" in line.lower()],"scope":"ELF dependencies under measured environment; late dlopen libraries are separately pinned in manifest runtime closure"}
            else:result["qualified_ldd_equivalent"]={"error":"ELF interpreter was not found"}
    if ldd:
        linked = subprocess.run([ldd, str(binary)], capture_output=True, text=True)
        result["ldd_tool"] = ldd
        result["ldd"] = linked.stdout.strip() if linked.returncode == 0 else None
    return result


def dbus_build_input(output: Path) -> dict[str, Any]:
    source = Path("/tmp/gpui-zgui-todo-pc/dbus-1.pc")
    if not source.is_file():
        return {"pc_file": str(source), "error": "local metadata shim not found"}
    archived = output / "build-inputs" / "dbus-1.pc"
    archived.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(source, archived)
    content = source.read_text()
    fields = dict(line.split("=", 1) for line in content.splitlines() if "=" in line and not line.startswith("Name:") and not line.startswith("Description:") and not line.startswith("Version:") and not line.startswith("Libs:") and not line.startswith("Cflags:"))
    prefix = fields.get("prefix", "")
    library = Path(prefix) / "lib" / "libdbus-1.so.3"
    resolved = library.resolve() if library.exists() else library
    return {
        "pc_file": str(source),
        "archived_copy": str(archived),
        "pc_sha256": file_sha256(source),
        "pc_content": content,
        "runtime_library": str(resolved),
        "runtime_library_sha256": file_sha256(resolved) if resolved.is_file() else None,
    }


def comparison_environment() -> dict[str, str]:
    env = os.environ.copy()
    library_dirs = env.get("LD_LIBRARY_PATH", "").split(os.pathsep)
    if DBUS_LIBDIR not in library_dirs:
        library_dirs.append(DBUS_LIBDIR)
    env["LD_LIBRARY_PATH"] = os.pathsep.join(path for path in library_dirs if path)
    return env


def run_sample(binary_name: str, binary: Path, mode: str, repeat: int, output: Path, duration: float, warmup: float, trace: bool, controls: dict[str, list[int]]) -> dict[str, Any]:
    env = comparison_environment()
    seed_rows = HEAVY_ROWS if mode == "heavy" else ANIMATION_ROWS if mode == "animation" else 0
    env.update({
        "TODO_BENCH_MODE": mode,
        "TODO_BENCH_ROWS": str(seed_rows),
        "TODO_BENCH_ANIMATE": "1" if mode == "animation" else "0",
        "TODO_BENCH_TICK_HZ": str(TICK_HZ),
        "TODO_BENCH_PRESENT_MARKER": "1",
        "TODO_BENCH_PRESENT_TRACE": "1" if trace else "0",
        "TODO_BENCH_RENDERER": "gpu",
        # Keep framework-side animation/watchdog budgets longer than the
        # externally timed window, whose 5s settle begins after first present.
        "TODO_BENCH_SECONDS": "120",
        "LP_NUM_THREADS": "4",
    })
    # Empty means trace is disabled. zgui checks presence, so remove it unless
    # this run needs frame intervals.
    if not trace:
        env.pop("TODO_BENCH_PRESENT_TRACE", None)
    log_path = output / "logs" / f"{binary_name}-{mode}-r{repeat}.log"
    log_path.parent.mkdir(parents=True, exist_ok=True)
    child = Child(binary, env, log_path)
    start_sample = proc_sample(child.proc.pid)
    present_ns = wait_first_present(child)
    try:
        window_id, window_title, _x, _y, width, height = wait_window(child.proc.pid, EXPECTED_WINDOW_TITLES[binary_name])
    except Exception:
        child.close_window(None)
        raise
    child.window_id = window_id
    if (width, height) != (540, 620):
        child.close_window(window_id)
        raise RuntimeError(f"window client geometry differs from the required 540x620: {width}x{height}")
    focused = subprocess.run([XDOTOOL, "windowfocus", "--sync", str(window_id)], check=False, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    if focused.returncode != 0:
        child.close_window(window_id)
        raise RuntimeError("could not focus Todo window before settling")
    time.sleep(warmup)
    measure_start_ns = time.monotonic_ns()
    samples: list[ProcSample] = []
    scheduled = completed = missed = 0
    injector_failures = 0
    dispatch_lateness_us: list[int] = []
    dispatched_actions: list[dict[str, Any]] = []
    next_slot_ns = measure_start_ns
    next_sample_ns = measure_start_ns
    sample_period_ns = 100_000_000
    deadline_ns = measure_start_ns + int(duration * 1e9)
    requested = int(duration / BUSY_SLOT_SECONDS)
    while time.monotonic_ns() < deadline_ns and child.proc.poll() is None:
        now = time.monotonic_ns()
        if now >= next_sample_ns:
            sample = proc_sample(child.proc.pid)
            if sample is not None:
                samples.append(sample)
            while next_sample_ns <= now:
                next_sample_ns += sample_period_ns
        if mode in ("busy", "heavy") and now >= next_slot_ns and scheduled + missed < requested:
            slot = max(scheduled + missed, (now - measure_start_ns) // int(BUSY_SLOT_SECONDS * 1e9))
            missed += int(slot) - (scheduled + missed)
            action = BUSY_MACRO[int(slot) % len(BUSY_MACRO)]
            action_deadline_ns = measure_start_ns + int(slot) * int(BUSY_SLOT_SECONDS * 1e9)
            lateness = max(0, (now - action_deadline_ns) // 1000)
            dispatch_lateness_us.append(lateness)
            success = busy_action(window_id, action, int(slot) // len(BUSY_MACRO), controls)
            dispatched_actions.append({"slot": int(slot), "action": action, "lateness_us": lateness, "xdotool_success": success})
            if success:
                completed += 1
            else:
                injector_failures += 1
            scheduled += 1
            next_slot_ns = measure_start_ns + (scheduled + missed) * int(BUSY_SLOT_SECONDS * 1e9)
        wake_ns = min(deadline_ns, next_sample_ns)
        if mode in ("busy", "heavy") and scheduled + missed < requested:
            wake_ns = min(wake_ns, next_slot_ns)
        time.sleep(max(0.001, (wake_ns - time.monotonic_ns()) / 1e9))
    end_ns = time.monotonic_ns()
    if mode in ("busy", "heavy"):
        missed += requested - scheduled - missed
    end_sample = proc_sample(child.proc.pid)
    if end_sample is not None:
        samples.append(end_sample)
    close_request_ns = time.monotonic_ns()
    child.close_window(window_id)
    close_complete_ns = time.monotonic_ns()
    logs = child.log_lines()
    model_summary = None
    frame_intervals_us: list[int] = []
    frame_count = None
    observer_overflow = None
    frame_times: list[int] = []
    internal_first_present_ns = None
    internal_first_present_receipt_ns = None
    internal_measure_start_ns = None
    internal_measure_end_ns = None
    measured_frame_times: list[int] = []
    renderer_info = None
    animation_worker = None
    for line in logs:
        if line.startswith("TODO_RENDERER,") and renderer_info is None:
            renderer_info = line.split(",", 1)[1]
        if line.startswith("TODO_MODEL,"):
            try:
                model_summary = json.loads(line.split(",", 1)[1])
            except (ValueError, json.JSONDecodeError):
                pass
        if line.startswith("TODO_FRAMES,"):
            try:
                frame_data = json.loads(line.split(",", 1)[1])
                frame_times = frame_data.get("elapsed_ns", [])
                frame_count = len(frame_times)
                observer_overflow = frame_data.get("observer_overflow")
                frame_intervals_us = [(right - left) // 1000 for left, right in zip(frame_times, frame_times[1:])]
            except (ValueError, json.JSONDecodeError):
                pass
        if line.startswith("TODO_FIRST_PRESENT,"):
            try:
                internal_first_present_ns = int(line.split(",", 1)[1])
            except ValueError:
                pass
        if line.startswith("TODO_ANIMATION,"):
            try:
                animation_worker = json.loads(line.split(",", 1)[1])
            except (ValueError, json.JSONDecodeError):
                pass
    if internal_first_present_ns is not None:
        # Align the buffered framework clock to the external marker receipt,
        # then retain only frames within the exact post-settle measurement.
        internal_event = child.first_internal_present_event()
        internal_first_present_receipt_ns = internal_event[0] if internal_event else child.started_ns
        internal_measure_start_ns = internal_first_present_ns + (measure_start_ns - internal_first_present_receipt_ns)
        internal_measure_end_ns = internal_measure_start_ns + int(duration * 1e9)
        measured_frame_times = [t for t in frame_times if internal_measure_start_ns <= t <= internal_measure_end_ns]
        frame_count = len(measured_frame_times)
        frame_intervals_us = [
            (right - left) // 1000
            for left, right in zip(measured_frame_times, measured_frame_times[1:])
        ]
    input_requested, button_requested = macro_counts(requested)
    cycle_count = requested // len(BUSY_MACRO)
    expected_done = sum(index % 3 == 1 for index in range(seed_rows)) + (cycle_count % 2)
    expected_first = (
        {"id": 0, "title": "Task 0001", "done": bool(cycle_count % 2)}
        if seed_rows
        else {"id": 0, "title": "bench-000", "done": bool(cycle_count % 2)}
    )
    expected_last = {
        "id": seed_rows + input_requested - 1,
        "title": f"bench-{input_requested - 1:03d}",
        "done": bool(cycle_count % 2) if seed_rows == 0 and input_requested == 1 else False,
    }
    input_dispatched = sum(action["action"] == "type" for action in dispatched_actions)
    input_completed = sum(action["action"] == "type" and action["xdotool_success"] for action in dispatched_actions)
    button_dispatched = len(dispatched_actions) - input_dispatched
    button_completed = sum(action["action"] != "type" and action["xdotool_success"] for action in dispatched_actions)
    animation_ticks = model_summary.get("animation_ticks") if model_summary else None
    animation_skipped = (
        model_summary.get("animation_skipped") if model_summary else None
    )
    if animation_skipped is None and animation_worker is not None:
        animation_skipped = animation_worker.get("skipped")
    if animation_ticks is None and animation_worker is not None:
        animation_ticks = animation_worker.get("enqueued")
    animation_lifetime_s = (
        max(0, close_request_ns - present_ns) / 1e9 if mode == "animation" else None
    )
    expected_animation_ticks = (
        int(animation_lifetime_s * TICK_HZ) if animation_lifetime_s is not None else None
    )
    animation_tolerance_ticks = (
        max(3, int(expected_animation_ticks * 0.01))
        if expected_animation_ticks is not None
        else None
    )
    animation_count_matches_lifetime = (
        expected_animation_ticks is not None
        and animation_ticks is not None
        and abs(animation_ticks - expected_animation_ticks) <= animation_tolerance_ticks
    )
    animation_delivery_matches = (
        animation_worker.get("enqueued") == model_summary.get("animation_ticks")
        if animation_worker is not None and model_summary is not None
        else animation_worker is None
    )
    animation_work_matched = (
        mode == "animation"
        and animation_count_matches_lifetime
        and animation_delivery_matches
        and animation_skipped == 0
        and (end_ns - measure_start_ns) >= int(duration * 0.98e9)
    ) if mode == "animation" else None
    result = {
        "variant": binary_name,
        "binary": str(binary),
        "binary_bytes": binary.stat().st_size,
        "binary_sha256": file_sha256(binary),
        "mode": mode,
        "repeat": repeat,
        "start_to_first_present_pipe_ns": present_ns - child.started_ns,
        "host_first_present_event_ns": present_ns,
        "process_start_monotonic_ns": child.started_ns,
        "first_present_pipe_receipt_monotonic_ns": present_ns,
        "first_present_internal_elapsed_ns": internal_first_present_ns,
        "first_present_internal_pipe_receipt_monotonic_ns": internal_first_present_receipt_ns,
        "measurement_start_monotonic_ns": measure_start_ns,
        "measurement_end_monotonic_ns": end_ns,
        "close_request_monotonic_ns": close_request_ns,
        "close_complete_monotonic_ns": close_complete_ns,
        "measurement_requested_duration_s": duration,
        "warmup_after_first_present_s": warmup,
        "measurement_elapsed_s": (end_ns - measure_start_ns) / 1e9,
        "measurement_window_complete": (end_ns - measure_start_ns) >= int(duration * 0.98e9),
        "start_proc_sample": asdict(start_sample) if start_sample else None,
        "process_metrics": summarize_samples(samples),
        "proc_sampling_interval_s": sample_period_ns / 1e9,
        "proc_samples": [asdict(sample) for sample in samples],
        "interactive_requested_deadline_events": requested if mode in ("busy", "heavy") else None,
        "interactive_dispatched_events": scheduled if mode in ("busy", "heavy") else None,
        "interactive_completed_injector_events": completed if mode in ("busy", "heavy") else None,
        "interactive_injector_failures": injector_failures if mode in ("busy", "heavy") else None,
        "interactive_missed_deadlines": missed if mode in ("busy", "heavy") else None,
        "interactive_dispatch_lateness_us": dispatch_lateness_us if mode in ("busy", "heavy") else None,
        "model_summary_on_close": model_summary,
        "animation_worker_summary": animation_worker,
        "animation_ticks": animation_ticks if mode == "animation" else None,
        "animation_skipped": animation_skipped if mode == "animation" else None,
        "animation_lifetime_s": animation_lifetime_s,
        "animation_expected_ticks_from_lifetime": expected_animation_ticks,
        "animation_tick_tolerance": animation_tolerance_ticks,
        "animation_delivery_matches": animation_delivery_matches if mode == "animation" else None,
        "animation_count_matches_lifetime": animation_count_matches_lifetime if mode == "animation" else None,
        "animation_work_matched": animation_work_matched,
        "close_escalated": child.close_escalated,
        "child_exit_code": child.proc.returncode,
        "graceful_close": child.graceful_close and model_summary is not None,
        "interactive_input_requested": input_requested if mode in ("busy", "heavy") else None,
        "interactive_input_dispatched": input_dispatched if mode in ("busy", "heavy") else None,
        "interactive_input_completed": input_completed if mode in ("busy", "heavy") else None,
        "interactive_button_requested": button_requested if mode in ("busy", "heavy") else None,
        "interactive_button_dispatched": button_dispatched if mode in ("busy", "heavy") else None,
        "interactive_button_completed": button_completed if mode in ("busy", "heavy") else None,
        "interactive_expected_button_callbacks": button_requested if mode in ("busy", "heavy") else None,
        "interactive_expected_model": ({
            "filter": "all",
            "next_id": seed_rows + input_requested,
            "rows": seed_rows + input_requested,
            "done": expected_done,
            "first_task": expected_first,
            "last_task": expected_last,
            "draft": "",
            "deleted": None,
        } if mode in ("busy", "heavy") else None),
        "interactive_dispatched_actions": dispatched_actions if mode in ("busy", "heavy") else None,
        "interactive_work_matched": (
            completed == requested
            and missed == 0
            and injector_failures == 0
            and child.graceful_close
            and window_title == EXPECTED_WINDOW_TITLES[binary_name]
            and [width, height] == [540, 620]
            and (end_ns - measure_start_ns) >= int(duration * 0.98e9)
            and model_summary is not None
            and model_summary.get("callbacks") == button_requested
            and model_summary.get("rows") == seed_rows + input_requested
            and model_summary.get("done") == expected_done
            and str(model_summary.get("filter", "")).lower() == "all"
            and model_summary.get("next_id") == seed_rows + input_requested
            and model_summary.get("first_task") == expected_first
            and model_summary.get("last_task") == expected_last
            and model_summary.get("draft") == ""
            and model_summary.get("deleted") is None
        ) if mode in ("busy", "heavy") else None,
        "present_intervals_us": frame_intervals_us,
        "present_frame_count": frame_count,
        "present_frame_times_elapsed_ns": frame_times,
        "present_frame_times_in_measurement_window_ns": measured_frame_times,
        "present_measurement_window_elapsed_ns": (
            [internal_measure_start_ns, internal_measure_end_ns]
            if internal_measure_start_ns is not None and internal_measure_end_ns is not None
            else None
        ),
        "present_observer_overflow": observer_overflow,
        "renderer_first_present": renderer_info,
        "present_interval_p50_us": statistics.median(frame_intervals_us) if frame_intervals_us else None,
        "present_interval_p95_us": sorted(frame_intervals_us)[int(0.95 * (len(frame_intervals_us) - 1))] if frame_intervals_us else None,
        "window_client_geometry": [width, height],
        "window_title": window_title,
        "log_path": str(log_path),
    }
    return result


def startup_sample(binary_name: str, binary: Path, repeat: int, output: Path, renderer: str | None = None) -> dict[str, Any]:
    env = comparison_environment()
    env.update({
        "TODO_BENCH_MODE": "idle",
        "TODO_BENCH_ROWS": "0",
        "TODO_BENCH_ANIMATE": "0",
        "TODO_BENCH_PRESENT_MARKER": "1",
        "TODO_BENCH_SECONDS": "120",
        "TODO_BENCH_TICK_HZ": str(TICK_HZ),
        "LP_NUM_THREADS": "4",
    })
    if renderer is not None:
        env["TODO_BENCH_RENDERER"] = renderer
    else:
        env["TODO_BENCH_RENDERER"] = "gpu"
    log_path = output / "logs" / f"{binary_name}-startup-r{repeat}.log"
    log_path.parent.mkdir(parents=True, exist_ok=True)
    child = Child(binary, env, log_path)
    first = proc_sample(child.proc.pid)
    present_ns = wait_first_present(child)
    startup_sample_now = proc_sample(child.proc.pid)
    try:
        window_id, window_title, _x, _y, width, height = wait_window(child.proc.pid, EXPECTED_WINDOW_TITLES[binary_name])
    except Exception:
        child.close_window(None)
        raise
    child.window_id = window_id
    if (width, height) != (540, 620):
        child.close_window(window_id)
        raise RuntimeError(f"startup window client geometry differs from 540x620: {width}x{height}")
    child.close_window(window_id)
    lines = child.log_lines()
    renderer_info = next((line.split(",", 1)[1] for line in lines if line.startswith("TODO_RENDERER,")), None)
    model_summary = next((json.loads(line.split(",", 1)[1]) for line in lines if line.startswith("TODO_MODEL,")), None)
    startup_work_matched = (
        child.graceful_close
        and window_title == EXPECTED_WINDOW_TITLES[binary_name]
        and [width, height] == [540, 620]
        and renderer_info is not None
        and model_summary is not None
    )
    return {
        "variant": binary_name,
        "renderer_requested": renderer,
        "renderer_first_present": renderer_info,
        "binary": str(binary),
        "binary_bytes": binary.stat().st_size,
        "binary_sha256": file_sha256(binary),
        "repeat": repeat,
        "warm_page_cache_exec_to_first_present_s": (present_ns - child.started_ns) / 1e9,
        "warm_page_cache_cpu_faults_to_first_present": {
            "cpu_ticks_total_at_first_present": startup_sample_now.cpu_ticks if startup_sample_now else None,
            "minor_faults_total_at_first_present": startup_sample_now.minor_faults if startup_sample_now else None,
            "major_faults_total_at_first_present": startup_sample_now.major_faults if startup_sample_now else None,
            "cpu_ticks_delta": startup_sample_now.cpu_ticks - first.cpu_ticks if first and startup_sample_now else None,
            "minor_faults_delta": startup_sample_now.minor_faults - first.minor_faults if first and startup_sample_now else None,
            "major_faults_delta": startup_sample_now.major_faults - first.major_faults if first and startup_sample_now else None,
        },
        "proc_sample_at_exec": asdict(first) if first else None,
        "proc_sample_at_first_present": asdict(startup_sample_now) if startup_sample_now else None,
        "first_present_pipe_receipt_monotonic_ns": present_ns,
        "first_present_internal_elapsed_ns": child.first_internal_present_event()[1]
        if child.first_internal_present_event()
        else None,
        "window_client_geometry": [width, height],
        "window_title": window_title,
        "close_escalated": child.close_escalated,
        "child_exit_code": child.proc.returncode,
        "graceful_close": child.graceful_close,
        "model_summary": model_summary,
        "startup_work_matched": startup_work_matched,
        "log_path": str(log_path),
    }


def _median(values: list[float | int]) -> float | None:
    return statistics.median(values) if values else None


def _workload_contract_passes(row: dict[str, Any], mode: str) -> bool:
    """Whether one recorded cell completed the preregistered workload contract."""
    if row.get("error") is not None or row.get("source_and_binary_unchanged") is not True:
        return False
    if mode == "idle":
        return (
            row.get("graceful_close") is True
            and row.get("measurement_window_complete") is True
            and row.get("renderer_first_present") is not None
            and row.get("model_summary_on_close") is not None
            and row.get("window_title") == EXPECTED_WINDOW_TITLES[row.get("variant")]
            and row.get("window_client_geometry") == [540, 620]
        )
    if mode in ("busy", "heavy"):
        return row.get("interactive_work_matched") is True
    if mode == "animation":
        return (
            row.get("animation_work_matched") is True
            and row.get("present_observer_overflow") == 0
            and row.get("graceful_close") is True
            and row.get("renderer_first_present") is not None
            and row.get("model_summary_on_close") is not None
            and row.get("window_title") == EXPECTED_WINDOW_TITLES[row.get("variant")]
            and row.get("window_client_geometry") == [540, 620]
        )
    if mode == "startup":
        return (
            row.get("startup_work_matched") is True
            and row.get("graceful_close") is True
            and row.get("renderer_first_present") is not None
            and row.get("window_title") == EXPECTED_WINDOW_TITLES[row.get("variant")]
            and row.get("window_client_geometry") == [540, 620]
        )
    return False


def audit_campaign(
    rows: list[dict[str, Any]], repeats: int, startup_repeats: int, skip_startup: bool = False
) -> dict[str, Any]:
    """Separate complete data capture from successful execution of every required cell."""
    expected = {
        (mode, variant, repeat)
        for mode in ("idle", "busy", "heavy", "animation")
        for variant in ("gpui", "zgui")
        for repeat in range(1, repeats + 1)
    }
    if not skip_startup:
        expected |= {
            ("startup", variant, repeat)
            for variant in ("gpui", "zgui", "gpui-auto")
            for repeat in range(1, startup_repeats + 1)
        }
    observed: dict[tuple[str, str, int], list[dict[str, Any]]] = {}
    for row in rows:
        row_mode = row.get("mode") or ("startup" if row.get("startup_work_matched") is not None else None)
        key = (row_mode, row.get("variant"), row.get("repeat"))
        observed.setdefault(key, []).append(row)
    missing = sorted(expected - observed.keys())
    unexpected = sorted(observed.keys() - expected)
    duplicates = sorted(key for key, cell_rows in observed.items() if len(cell_rows) != 1)
    captured_contract_failures = []
    for key in sorted(expected & observed.keys()):
        cell_rows = observed[key]
        if len(cell_rows) != 1 or not _workload_contract_passes(cell_rows[0], key[0]):
            reason = "duplicate rows" if len(cell_rows) != 1 else _cell_failure_reason(cell_rows[0], key[0])
            captured_contract_failures.append({
                "mode": key[0], "variant": key[1], "repeat": key[2], "reason": reason,
            })
    capture_complete = not missing and not unexpected and not duplicates and len(rows) == len(expected)
    return {
        "expected_cells": len(expected),
        "captured_rows": len(rows),
        "capture_complete": capture_complete,
        "workload_contract_pass": capture_complete and not captured_contract_failures,
        "missing_cells": [_key_json(key) for key in missing],
        "unexpected_cells": [_key_json(key) for key in unexpected],
        "duplicate_cells": [_key_json(key) for key in duplicates],
        "workload_contract_failures": captured_contract_failures,
        "exit_success": capture_complete and not captured_contract_failures,
    }


def _key_json(key: tuple[Any, Any, Any]) -> dict[str, Any]:
    return {"mode": key[0], "variant": key[1], "repeat": key[2]}


def _cell_failure_reason(row: dict[str, Any], mode: str) -> str:
    if row.get("error") is not None:
        return f"runner error: {row['error']}"
    boolean_fields = {
        "idle": ("graceful_close", "measurement_window_complete"),
        "busy": ("interactive_work_matched",),
        "heavy": ("interactive_work_matched",),
        "animation": ("animation_work_matched", "graceful_close"),
        "startup": ("startup_work_matched", "graceful_close"),
    }.get(mode, ())
    evidence_fields = {
        "idle": ("renderer_first_present", "model_summary_on_close"),
        "animation": ("renderer_first_present", "model_summary_on_close"),
        "startup": ("renderer_first_present",),
    }.get(mode, ())
    failed = [field for field in boolean_fields if row.get(field) is not True]
    failed.extend(field for field in evidence_fields if row.get(field) is None)
    if row.get("present_observer_overflow") != 0 and mode == "animation":
        failed.append("present_observer_overflow")
    if row.get("window_title") != EXPECTED_WINDOW_TITLES.get(row.get("variant")):
        failed.append("window_title")
    if row.get("window_client_geometry") != [540, 620]:
        failed.append("window_client_geometry")
    if row.get("source_and_binary_unchanged") is not True:
        failed.append("source_and_binary_unchanged")
    return "failed contract: " + ", ".join(failed or ["required evidence missing"])


def write_campaign_status(output: Path, status: dict[str, Any]) -> None:
    (output / "campaign-status.json").write_text(json.dumps(status, indent=2, sort_keys=True) + "\n")
    report = output / "report.md"
    if report.is_file():
        content = report.read_text()
        block = [
            "## Campaign validation",
            "",
            f"- Capture complete: **{status['capture_complete']}** ({status['captured_rows']}/{status['expected_cells']} expected rows).",
            f"- Workload contract passed: **{status['workload_contract_pass']}**.",
        ]
        if status["workload_contract_failures"]:
            block.extend(["", "Captured cells that failed their workload contract:"])
            block.extend(
                f"- `{failure['mode']}/{failure['variant']}/r{failure['repeat']}`: {failure['reason']}"
                for failure in status["workload_contract_failures"]
            )
        if status["missing_cells"]:
            block.extend(["", "Missing cells:"])
            block.extend(f"- `{cell['mode']}/{cell['variant']}/r{cell['repeat']}`" for cell in status["missing_cells"])
        report.write_text(content.rstrip() + "\n\n" + "\n".join(block) + "\n")


def finalize_campaign(
    output: Path,
    results_path: Path,
    app_sizes: dict[str, Any],
    rows: list[dict[str, Any]],
    repeats: int,
    startup_repeats: int,
    skip_startup: bool = False,
) -> dict[str, Any]:
    status = audit_campaign(rows, repeats, startup_repeats, skip_startup)
    write_report(output, results_path, app_sizes)
    write_campaign_status(output, status)
    return status


def campaign_exit_code(status: dict[str, Any]) -> int:
    return 0 if status.get("capture_complete") is True and status.get("workload_contract_pass") is True else 1


def attach_fingerprint_guard(
    row: dict[str, Any], before: dict[str, Any], after: dict[str, Any], expected: dict[str, Any]
) -> dict[str, Any]:
    row["source_and_binary_fingerprint_before"] = before
    row["source_and_binary_fingerprint_after"] = after
    row["source_and_binary_unchanged"] = before == after == expected
    return row


def write_report(output: Path, results_path: Path, app_sizes: dict[str, Any]) -> None:
    rows = [json.loads(line) for line in results_path.read_text().splitlines() if line.strip()]

    def selected(mode: str, variant: str | None = None) -> list[dict[str, Any]]:
        return [
            row
            for row in rows
            if (row.get("mode") == mode or (mode == "startup" and row.get("startup_work_matched") is not None))
            and (variant is None or row.get("variant") == variant)
        ]

    def valid_run(row: dict[str, Any]) -> bool:
        if not row.get("source_and_binary_unchanged"):
            return False
        if row.get("mode") in ("busy", "heavy"):
            return row.get("interactive_work_matched") is True
        if row.get("mode") == "animation":
            return (
                row.get("animation_work_matched") is True
                and row.get("present_observer_overflow") == 0
                and row.get("graceful_close") is True
            )
        if row.get("mode") == "idle":
            return (
                row.get("error") is None
                and row.get("graceful_close") is True
                and row.get("measurement_window_complete") is True
                and row.get("renderer_first_present") is not None
                and row.get("model_summary_on_close") is not None
                and row.get("window_client_geometry") == [540, 620]
            )
        if row.get("startup_work_matched") is not None:
            return row.get("startup_work_matched") is True and row.get("source_and_binary_unchanged") is True
        return (
            row.get("error") is None
            and row.get("graceful_close") is True
            and row.get("renderer_first_present") is not None
            and row.get("window_client_geometry") == [540, 620]
        )

    def spread(values: list[float | int], digits: int = 2) -> str:
        if not values:
            return "unavailable"
        return (
            f"median {statistics.median(values):.{digits}f}"
            f" (range {min(values):.{digits}f}–{max(values):.{digits}f})"
        )

    def spread_n(values: list[float | int], digits: int = 2) -> str:
        return f"n={len(values)}; {spread(values, digits)}" if values else "n=0; unavailable"

    def paired(mode: str) -> dict[str, list[dict[str, Any]]]:
        by_variant = {
            variant: {
                row.get("repeat"): row
                for row in selected(mode, variant)
                if valid_run(row)
            }
            for variant in ("gpui", "zgui")
        }
        common_repeats = set(by_variant["gpui"]) & set(by_variant["zgui"])
        return {
            variant: [by_variant[variant][repeat] for repeat in sorted(common_repeats)]
            for variant in ("gpui", "zgui")
        }

    lines = [
        "# Todo comparison results",
        "",
        "Each value is the median of the valid paired runs listed in `results.jsonl`. Busy/heavy results are ranked only when requested events, callbacks, and final model state all match. Raw failed or unmatched trials remain in the JSONL file.",
        "A first launch attempt exposed an incorrect GPUI window-title assumption and a non-executable zgui copy; it is archived separately and contributes no values below. The earlier idle-only launch preflight did not exercise seeded-animation shutdown; the seeded animation cells below include the resulting close failures.",
        "",
        "| Category | GPUI | zgui | Valid trials |",
        "| --- | ---: | ---: | ---: |",
    ]
    for mode, title in (("idle", "CPU idle"), ("busy", "CPU busy"), ("heavy", "CPU heavy"), ("animation", "CPU animation")):
        pair_results = paired(mode)
        cells = []
        for variant in ("gpui", "zgui"):
            valid = pair_results[variant]
            values = [row.get("process_metrics", {}).get("process_cpu_percent_one_core_100") for row in valid]
            values = [value for value in values if value is not None]
            if values and mode == "animation":
                ticks = [row.get("animation_ticks") for row in valid if row.get("animation_ticks") is not None]
                skipped = [row.get("animation_skipped") for row in valid if row.get("animation_skipped") is not None]
                cells.append(f"{spread(values)}%; ticks {spread(ticks, 0)}; skipped {spread(skipped, 0)}")
            else:
                cells.append(f"{spread(values)}%" if values else "unmatched / unavailable")
        valid_pairs = min(len(pair_results["gpui"]), len(pair_results["zgui"]))
        lines.append(f"| {title} (one core = 100%) | {cells[0]} | {cells[1]} | {valid_pairs} matched pairs |")
    for mode, title in (("busy", "GPU busy"), ("heavy", "GPU heavy"), ("animation", "GPU animation")):
        lines.append(f"| {title} | N/A | N/A | Not measurable on this host: no render node; Mesa llvmpipe CPU rendering |")
    for mode, title in (("idle", "Memory idle"), ("heavy", "Memory heavy"), ("animation", "Memory animation")):
        pair_results = paired(mode)
        values_by_variant = {}
        for variant in ("gpui", "zgui"):
            valid = pair_results[variant]
            pss = [row.get("process_metrics", {}).get("pss_kb_peak") for row in valid]
            rss = [row.get("process_metrics", {}).get("rss_kb_peak") for row in valid]
            private = [row.get("process_metrics", {}).get("private_kb_peak") for row in valid]
            pss = [value for value in pss if value is not None]
            rss = [value for value in rss if value is not None]
            private = [value for value in private if value is not None]
            values_by_variant[variant] = (
                f"PSS {spread(pss, 0)} / RSS {spread(rss, 0)} / private {spread(private, 0)} KiB"
                if pss and rss and private
                else "unavailable"
            )
        lines.append(f"| {title} (median peak PSS / RSS / private) | {values_by_variant['gpui']} | {values_by_variant['zgui']} | {len(pair_results['gpui'])} matched pairs |")
    for mode, title in (("busy", "Smoothness busy"), ("heavy", "Smoothness heavy"), ("animation", "Smoothness animation")):
        pair_results = paired(mode)
        values_by_variant = {}
        for variant in ("gpui", "zgui"):
            valid = [row for row in pair_results[variant] if row.get("present_observer_overflow") == 0]
            p95 = [row.get("present_interval_p95_us") for row in valid]
            p95 = [value for value in p95 if value is not None]
            frame_counts = [row.get("present_frame_count") for row in valid if row.get("present_frame_count") is not None]
            values_by_variant[variant] = (
                f"p95 submit interval {spread(p95, 0)} µs; frames {spread(frame_counts, 0)}"
                if p95 and frame_counts
                else "unmatched / unavailable"
            )
        valid_pairs = len(pair_results["gpui"])
        lines.append(f"| {title} (not physical scanout) | {values_by_variant['gpui']} | {values_by_variant['zgui']} | {valid_pairs} matched pairs |")
    startup_pairs = paired("startup")
    startups = startup_pairs
    startup_cells = []
    for variant in ("gpui", "zgui"):
        launches = startups[variant]
        values = [row.get("warm_page_cache_exec_to_first_present_s") for row in launches]
        values = [value for value in values if value is not None]
        cpu = [row.get("warm_page_cache_cpu_faults_to_first_present", {}).get("cpu_ticks_total_at_first_present") for row in launches]
        cpu = [value for value in cpu if value is not None]
        faults = [row.get("warm_page_cache_cpu_faults_to_first_present", {}).get("minor_faults_total_at_first_present") for row in launches]
        faults = [value for value in faults if value is not None]
        startup_cells.append((
            f"{spread([value * 1000 for value in values], 1)} ms; "
            f"CPU ticks {spread(cpu, 0)}; minor faults {spread(faults, 0)}"
            if values and cpu and faults
            else "unavailable"
        ))
    lines.append(f"| Startup work (warm cache; exec→host submit, CPU ticks, minor faults) | {startup_cells[0]} | {startup_cells[1]} | {len(startups['gpui'])} paired launch sets |")
    gpui_auto = [row for row in selected("startup", "gpui-auto") if row.get("error") is None and row.get("source_and_binary_unchanged")]
    auto_values = [row.get("warm_page_cache_exec_to_first_present_s") for row in gpui_auto]
    auto_display = f"{spread([value * 1000 for value in auto_values], 1)} ms" if auto_values else "unavailable"
    lines.append(f"| GPUI auto-renderer startup (supplemental) | {auto_display} | — | n={len(auto_values)}; separate from binary-default series |")
    lines.append(f"| App size (as-built) | {app_sizes['gpui']['as_built_bytes']:,} B | {app_sizes['zgui']['as_built_bytes']:,} B | SHA-256 in metadata |")
    strip_sizes = [app_sizes[name].get("stripped_copy", {}).get("bytes") for name in ("gpui", "zgui")]
    strip_gpui = f"{strip_sizes[0]:,} B" if strip_sizes[0] is not None else "unavailable"
    strip_zgui = f"{strip_sizes[1]:,} B" if strip_sizes[1] is not None else "unavailable"
    lines.append(f"| App size (stripped copy) | {strip_gpui} | {strip_zgui} | Copy-only stripping; binaries remain unmodified |")
    lines.extend([
        "",
        "## Heavy-load observations",
        "",
        "These descriptive rows include every captured Heavy and Animation trial, including overload runs excluded from matched-work rankings. They show resources and delivered work together; they do not declare a resource winner when delivery differs.",
        "",
        "| Workload | Framework | Matched cells | CPU % (one core=100) | Peak PSS / RSS KiB | Callbacks / ticks | Skipped ticks | p95 host-present interval µs | Host presents / rate Hz |",
        "| --- | --- | ---: | --- | --- | --- | --- | --- | --- |",
    ])
    for mode in ("heavy", "animation"):
        for variant in ("gpui", "zgui"):
            captured = selected(mode, variant)
            valid_count = sum(valid_run(row) for row in captured)
            cpu = [row.get("process_metrics", {}).get("process_cpu_percent_one_core_100") for row in captured]
            pss = [row.get("process_metrics", {}).get("pss_kb_peak") for row in captured]
            rss = [row.get("process_metrics", {}).get("rss_kb_peak") for row in captured]
            frames = [row.get("present_frame_count") for row in captured if row.get("present_frame_count") is not None]
            p95 = [row.get("present_interval_p95_us") for row in captured if row.get("present_interval_p95_us") is not None]
            rates = [
                row["present_frame_count"] / row["measurement_elapsed_s"]
                for row in captured
                if row.get("present_frame_count") is not None and row.get("measurement_elapsed_s", 0) > 0
            ]
            if mode == "heavy":
                work = [
                    (row.get("model_summary_on_close") or {}).get("callbacks")
                    for row in captured
                    if (row.get("model_summary_on_close") or {}).get("callbacks") is not None
                ]
                work_text = f"callbacks {spread_n(work, 0)}; ticks n=0"
                skipped_text = "n=0; not applicable"
            else:
                ticks = [row.get("animation_ticks") for row in captured if row.get("animation_ticks") is not None]
                skipped = [row.get("animation_skipped") for row in captured if row.get("animation_skipped") is not None]
                callbacks = [
                    (row.get("model_summary_on_close") or {}).get("callbacks")
                    for row in captured
                    if (row.get("model_summary_on_close") or {}).get("callbacks") is not None
                ]
                work_text = f"callbacks {spread_n(callbacks, 0)}; ticks {spread_n(ticks, 0)}"
                skipped_text = spread_n(skipped, 0)
            cpu = [value for value in cpu if value is not None]
            pss = [value for value in pss if value is not None]
            rss = [value for value in rss if value is not None]
            lines.append(
                f"| {mode} | {variant} | {valid_count}/{len(captured)} | "
                f"{spread_n(cpu)}% | PSS {spread_n(pss, 0)} / RSS {spread_n(rss, 0)} | "
                f"{work_text} | {skipped_text} | {spread_n(p95, 0)} | "
                f"frames {spread_n(frames, 0)}; rate {spread_n(rates, 2)} |"
            )
    lines.extend([
        "",
        "GPUI Heavy callback deficits and GPUI Animation deadline/present deficits are overload observations. Their CPU and memory samples remain visible above even though the corresponding requested work did not match. zgui's cells matched their required callbacks/ticks; compare the delivered-work columns before interpreting resource use. Present intervals are host-submit pacing proxies, not physical scanout or input latency.",
    ])
    lines.extend([
        "",
        "GPU utilization is unavailable: the host exposes an ASPEED display adapter without a render node and uses Mesa llvmpipe. Successful-present intervals are host submission/acknowledgement intervals, not scanout or perceived smoothness. CPU includes llvmpipe worker threads and excludes Xvfb. Page cache remained warm. App-size includes zgui's default X11+Wayland dependency feature set while the GPUI comparison build is X11-only; see ELF dependencies and hashes in `metadata.json`.",
        "",
        "Busy requests 120 absolute-deadline events over 30 seconds (15 text operations and 105 button activations); heavy uses the same sequence with 10,000 seeded rows. The runner preserves overload and failed-work samples without treating them as matched performance wins.",
        "",
    ])
    (output / "report.md").write_text("\n".join(lines))


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--gpui-bin", required=True, type=Path)
    parser.add_argument("--zgui-bin", required=True, type=Path)
    parser.add_argument("--gpui-source", required=True, type=Path)
    parser.add_argument("--controls", type=Path, default=Path("comparisons/todo/controls.json"))
    parser.add_argument("--output", required=True, type=Path)
    parser.add_argument("--gpui-build-log", type=Path)
    parser.add_argument("--gpui-fingerprint", type=Path)
    parser.add_argument("--zgui-build-log", type=Path)
    parser.add_argument("--zgui-fingerprint", type=Path)
    parser.add_argument("--duration", type=float, default=30.0)
    parser.add_argument("--warmup", type=float, default=5.0)
    parser.add_argument("--repeats", type=int, default=3)
    parser.add_argument("--startup-repeats", type=int, default=3)
    parser.add_argument("--skip-startup", action="store_true")
    parser.add_argument("--preflight-only", action="store_true", help="launch each frozen app once, verify first-present, exact window geometry/title and orderly model receipt, then exit without timing cells")
    args = parser.parse_args()
    if any(not path.is_file() or not os.access(path, os.X_OK) for path in (args.gpui_bin, args.zgui_bin)):
        parser.error("both benchmark binaries must exist and be executable")
    if not os.environ.get("DISPLAY"):
        parser.error("DISPLAY must point to the owned Xvfb display")
    if shutil.which("perf"):
        perf = "available"
    else:
        perf = "unavailable"
    if args.output.exists() and any(args.output.iterdir()):
        parser.error("--output must be a fresh or empty directory so trial data is never overwritten")
    args.output.mkdir(parents=True, exist_ok=True)
    results_path = args.output / "results.jsonl"
    zgui_source = Path(__file__).resolve().parents[1]
    controls = json.loads(args.controls.read_text())
    for variant in ("gpui", "zgui"):
        required_controls = {"input", "add", "complete", "active", "done", "all", "delete", "undo"}
        if not required_controls.issubset(controls.get(variant, {})):
            parser.error(f"--controls must provide {variant} points for {sorted(required_controls)}")
    if args.preflight_only:
        if args.output.exists() and any(args.output.iterdir()):
            parser.error("--output must be a fresh or empty directory for preflight evidence")
        args.output.mkdir(parents=True, exist_ok=True)
        preflight_rows = []
        binaries = {"gpui": args.gpui_bin, "zgui": args.zgui_bin}
        preflight_fingerprint = trial_fingerprint(args.gpui_source, zgui_source, binaries)
        for name, binary in (("gpui", args.gpui_bin), ("zgui", args.zgui_bin)):
            fingerprint_before = trial_fingerprint(args.gpui_source, zgui_source, binaries)
            try:
                row = startup_sample(name, binary, 0, args.output)
                row.update({"preflight_kind": "startup", "mode": "startup"})
            except Exception as error:
                close_active_children()
                row = {"variant": name, "mode": "startup", "repeat": 0, "preflight_kind": "startup", "error": repr(error), "traceback": traceback.format_exc()}
            fingerprint_after = trial_fingerprint(args.gpui_source, zgui_source, binaries)
            attach_fingerprint_guard(row, fingerprint_before, fingerprint_after, preflight_fingerprint)
            preflight_rows.append(row)
            print(f"PREFLIGHT {name} startup: title={row.get('window_title')!r} geometry={row.get('window_client_geometry')} close={row.get('graceful_close')} renderer={row.get('renderer_first_present') is not None} model={row.get('model_summary') is not None}", flush=True)
            fingerprint_before = trial_fingerprint(args.gpui_source, zgui_source, binaries)
            try:
                # This also exercises seeded-row shutdown, which caught the
                # GPUI late-work panic missed by the original idle-only check.
                row = run_sample(name, binary, "animation", 0, args.output, 2.0, 0.0, trace=True, controls=controls[name])
                row.update({"preflight_kind": "seeded-animation"})
            except Exception as error:
                close_active_children()
                row = {"variant": name, "mode": "animation", "repeat": 0, "preflight_kind": "seeded-animation", "error": repr(error), "traceback": traceback.format_exc()}
            fingerprint_after = trial_fingerprint(args.gpui_source, zgui_source, binaries)
            attach_fingerprint_guard(row, fingerprint_before, fingerprint_after, preflight_fingerprint)
            preflight_rows.append(row)
            print(f"PREFLIGHT {name} seeded-animation: title={row.get('window_title')!r} geometry={row.get('window_client_geometry')} close={row.get('graceful_close')} animation={row.get('animation_work_matched')} model={row.get('model_summary_on_close') is not None}", flush=True)
        (args.output / "preflight.json").write_text(json.dumps(preflight_rows, indent=2) + "\n")
        preflight_ok = all(
            _workload_contract_passes(row, row["mode"])
            for row in preflight_rows
        )
        preflight_status = {
            "preflight_pass": preflight_ok,
            "source_and_binary_fingerprint_unchanged": all(row.get("source_and_binary_unchanged") is True for row in preflight_rows),
            "rows": len(preflight_rows),
            "frozen_fingerprint": preflight_fingerprint,
        }
        (args.output / "preflight-status.json").write_text(json.dumps(preflight_status, indent=2) + "\n")
        if not preflight_ok:
            print("PREFLIGHT FAILED; startup and seeded-animation closure/receipts must pass; no timing cells run", file=sys.stderr)
            return 2
        print(f"PREFLIGHT PASSED; evidence: {args.output / 'preflight.json'}", flush=True)
        return 0
    results_path.write_text("")
    app_sizes = {
        "gpui": {"as_built_bytes": args.gpui_bin.stat().st_size, "as_built_sha256": file_sha256(args.gpui_bin), "stripped_copy": stripped_size(args.gpui_bin, "gpui", args.output)},
        "zgui": {"as_built_bytes": args.zgui_bin.stat().st_size, "as_built_sha256": file_sha256(args.zgui_bin), "stripped_copy": stripped_size(args.zgui_bin, "zgui", args.output)},
    }
    lockfiles = {
        "gpui": args.gpui_source / "Cargo.lock",
        "zgui": zgui_source / "Cargo.lock",
    }
    binaries = {"gpui": args.gpui_bin, "zgui": args.zgui_bin}
    campaign_fingerprint = trial_fingerprint(args.gpui_source, zgui_source, binaries)
    builds = {}
    for name, log_path, fingerprint_path in (
        ("gpui", args.gpui_build_log, args.gpui_fingerprint),
        ("zgui", args.zgui_build_log, args.zgui_fingerprint),
    ):
        builds[name] = {
            "log_path": str(log_path) if log_path else None,
            "log_sha256": file_sha256(log_path) if log_path and log_path.is_file() else None,
            "fingerprint_path": str(fingerprint_path) if fingerprint_path else None,
            "fingerprint_json": json.loads(fingerprint_path.read_text()) if fingerprint_path and fingerprint_path.is_file() else None,
        }
    font_assets = []
    font_dir = zgui_source / "crates/zgui-desktop/examples/support/todo_fonts"
    for font_path in sorted(font_dir.glob("*.ttf")):
        font_assets.append({"name": font_path.name, "bytes": font_path.stat().st_size, "sha256": file_sha256(font_path)})
    for name, binary in binaries.items():
        app_sizes[name]["elf_dependencies"] = elf_dependencies(binary)
    host_files = {
        "cpuinfo": Path("/proc/cpuinfo"),
        "meminfo": Path("/proc/meminfo"),
        "cpu_governor": Path("/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor"),
        "cpu_epp": Path("/sys/devices/system/cpu/cpu0/cpufreq/energy_performance_preference"),
    }
    host_details = {key: path.read_text()[:16000].strip() if path.is_file() else None for key, path in host_files.items()}
    vk_driver_files = os.environ.get("VK_DRIVER_FILES") or os.environ.get("VK_ICD_FILENAMES")
    icd_details = None
    if vk_driver_files:
        icd_path = Path(vk_driver_files.split(os.pathsep)[0])
        if icd_path.is_file():
            icd_details = {"path": str(icd_path), "sha256": file_sha256(icd_path), "json": icd_path.read_text()}
    rustc = subprocess.run(["rustc", "-Vv"], capture_output=True, text=True)
    cargo = subprocess.run(["cargo", "--version"], capture_output=True, text=True)
    metadata = {
        "date_utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
        "host": {"platform": platform.platform(), "uname": platform.uname()._asdict(), "details": host_details},
        "render_environment": {"VK_DRIVER_FILES": vk_driver_files, "icd": icd_details, "LD_LIBRARY_PATH": comparison_environment().get("LD_LIBRARY_PATH"), "dbus_library_dir": DBUS_LIBDIR, "LP_NUM_THREADS": "4"},
        "display": os.environ.get("DISPLAY"),
        "mesa_threads": 4,
        "perf_binary": perf,
        "workloads": {
            "idle": "matched empty Todo comparison view after a 5s settle",
            "busy": "30s absolute-deadline UI macro (one text operation plus seven button activations every 2s)",
            "heavy": f"{HEAVY_ROWS} seeded, nonvirtualized Todo rows plus the same 30s UI macro",
            "animation": f"{ANIMATION_ROWS} seeded, nonvirtualized Todo rows, 60Hz deadline-sampled list translation, 12px amplitude",
            "startup": "warm page cache, exec to successful host PresentationStatus::Presented marker; binary-default series plus separate GPUI auto-renderer subset",
        },
        "limitations": [
            "GPU utilization unavailable: this host exposes an ASPEED display adapter without a render node; rendering uses Mesa llvmpipe.",
            "Present intervals measure successful host submit intervals, not physical scanout or perceptual smoothness.",
            "CPU percent is normalized so 100 means one fully occupied logical core; process threads include llvmpipe workers.",
            "Xvfb process CPU is outside these per-app proc samples.",
            "Page cache is warm; no cache drop is attempted.",
        ],
        "source": {
            "gpui_revision": git_head(args.gpui_source),
            "zgui_revision": git_head(zgui_source),
            "gpui_lock_sha256": file_sha256(lockfiles["gpui"]) if lockfiles["gpui"].is_file() else None,
            "zgui_lock_sha256": file_sha256(lockfiles["zgui"]) if lockfiles["zgui"].is_file() else None,
        },
        "toolchain": {"rustc_vv": rustc.stdout.strip(), "cargo": cargo.stdout.strip()},
        "build_profile": {
            "profile": "release",
            "opt_level": 3,
            "lto": "thin",
            "codegen_units": 1,
            "debug": 0,
            "strip": "none",
            "rustflags": ["-C symbol-mangling-version=v0", "--cfg tokio_unstable"],
            "binaries": app_sizes,
            "cargo_evidence": builds,
            "dbus_build_input": dbus_build_input(args.output),
            "embedded_font_assets": font_assets,
            "control_points_path": str(args.controls.resolve()),
            "control_points_sha256": file_sha256(args.controls),
        },
        "campaign_fingerprint": campaign_fingerprint,
    }
    (args.output / "metadata.json").write_text(json.dumps(metadata, indent=2) + "\n")
    variants = [("gpui", args.gpui_bin), ("zgui", args.zgui_bin)]
    def save(result: dict[str, Any]) -> None:
        with results_path.open("a") as output_file:
            output_file.write(json.dumps(result, sort_keys=True) + "\n")
            output_file.flush()
            os.fsync(output_file.fileno())

    # Reverse order on odd repeats to reduce launch/order drift.
    for mode in ("idle", "busy", "heavy", "animation"):
        for repeat in range(args.repeats):
            pair = variants if repeat % 2 == 0 else list(reversed(variants))
            for name, binary in pair:
                print(f"RUN {mode} {name} repeat={repeat + 1}/{args.repeats}", flush=True)
                fingerprint_before = trial_fingerprint(args.gpui_source, zgui_source, binaries)
                if fingerprint_before != campaign_fingerprint:
                    result = {"variant": name, "mode": mode, "repeat": repeat + 1, "error": "source or binary changed since campaign freeze"}
                else:
                    try:
                        result = run_sample(name, binary, mode, repeat + 1, args.output, args.duration, args.warmup, trace=mode != "idle", controls=controls[name])
                    except Exception as error:
                        close_active_children()
                        result = {
                            "variant": name,
                            "mode": mode,
                            "repeat": repeat + 1,
                            "error": repr(error),
                            "traceback": traceback.format_exc(),
                            "log_path": str(args.output / "logs" / f"{name}-{mode}-r{repeat + 1}.log"),
                        }
                current_fingerprint = trial_fingerprint(args.gpui_source, zgui_source, binaries)
                attach_fingerprint_guard(result, fingerprint_before, current_fingerprint, campaign_fingerprint)
                save(result)
    if not args.skip_startup:
        for repeat in range(args.startup_repeats):
            pair = variants if repeat % 2 == 0 else list(reversed(variants))
            for name, binary in pair:
                print(f"RUN startup {name} repeat={repeat + 1}/{args.startup_repeats}", flush=True)
                fingerprint_before = trial_fingerprint(args.gpui_source, zgui_source, binaries)
                if fingerprint_before != campaign_fingerprint:
                    result = {"variant": name, "mode": "startup", "repeat": repeat + 1, "error": "source or binary changed since campaign freeze"}
                else:
                    try:
                        result = startup_sample(name, binary, repeat + 1, args.output)
                    except Exception as error:
                        close_active_children()
                        result = {
                            "variant": name,
                            "mode": "startup",
                            "repeat": repeat + 1,
                            "error": repr(error),
                            "traceback": traceback.format_exc(),
                            "log_path": str(args.output / "logs" / f"{name}-startup-r{repeat + 1}.log"),
                        }
                current_fingerprint = trial_fingerprint(args.gpui_source, zgui_source, binaries)
                attach_fingerprint_guard(result, fingerprint_before, current_fingerprint, campaign_fingerprint)
                save(result)
        for repeat in range(args.startup_repeats):
            print(f"RUN startup gpui-auto repeat={repeat + 1}/{args.startup_repeats}", flush=True)
            fingerprint_before = trial_fingerprint(args.gpui_source, zgui_source, binaries)
            if fingerprint_before != campaign_fingerprint:
                result = {"variant": "gpui-auto", "mode": "startup", "repeat": repeat + 1, "error": "source or binary changed since campaign freeze"}
            else:
                try:
                    result = startup_sample("gpui-auto", args.gpui_bin, repeat + 1, args.output, renderer="auto")
                except Exception as error:
                    close_active_children()
                    result = {
                        "variant": "gpui-auto",
                        "mode": "startup",
                        "repeat": repeat + 1,
                        "error": repr(error),
                        "traceback": traceback.format_exc(),
                        "log_path": str(args.output / "logs" / f"gpui-auto-startup-r{repeat + 1}.log"),
                    }
            current_fingerprint = trial_fingerprint(args.gpui_source, zgui_source, binaries)
            attach_fingerprint_guard(result, fingerprint_before, current_fingerprint, campaign_fingerprint)
            save(result)
    rows = [json.loads(line) for line in results_path.read_text().splitlines() if line.strip()]
    status = finalize_campaign(
        args.output, results_path, app_sizes, rows, args.repeats, args.startup_repeats, args.skip_startup
    )
    print(f"WROTE {results_path} and {args.output / 'report.md'}", flush=True)
    if campaign_exit_code(status) != 0:
        print(
            f"CAMPAIGN FAILED: capture_complete={status['capture_complete']} "
            f"workload_contract_pass={status['workload_contract_pass']}; see campaign-status.json",
            file=sys.stderr,
            flush=True,
        )
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
