#!/usr/bin/env python3
"""Six-second instrumented userspace CPU diagnosis, never performance evidence.

Uses Linux perf_event_open software CPU-clock sampling on owned child threads,
excluding kernel/hypervisor; no kernel settings, executable or source changes.
ABI: https://raw.githubusercontent.com/torvalds/linux/master/include/uapi/linux/perf_event.h
"""

import collections, ctypes, datetime, fcntl, json, mmap, os, platform, signal, struct, subprocess, sys, time, traceback
from pathlib import Path

T = Path(os.environ.get("TODO_TASK_ROOT", "/home/miles/gpui-ce3-compute-20261024"))
D = T / "evidence/mapped-todo"
sys.path.insert(0, str(T / "src/mapped-todo-runner"))
import run as r
from presentation_audit import audit_animation


class Sampler:
    def __init__(self):
        self.events = {}
        self.timeline = []
        self.samples = []
        self.lost = 0
        self.errors = []
        self.lib = ctypes.CDLL(None, use_errno=True)
        self.pagesize = os.sysconf("SC_PAGESIZE")

    def attach(self, tid):
        attr = ctypes.create_string_buffer(128)
        # IP,TID,TIME,CALLCHAIN; disabled,exclude kernel/HV/kernel-callchains,use CLOCK_MONOTONIC.
        struct.pack_into(
            "IIQQQQQ",
            attr,
            0,
            1,
            128,
            0,
            10_000_000,
            39,
            0,
            1 | 32 | 64 | (1 << 21) | (1 << 25),
        )
        struct.pack_into("i", attr, 92, 1)
        struct.pack_into("H", attr, 108, 64)
        fd = self.lib.syscall(298, ctypes.byref(attr), tid, -1, -1, 8)
        if fd < 0:
            self.errors.append(
                {
                    "tid": tid,
                    "stage": "perf_event_open",
                    "errno": ctypes.get_errno(),
                    "reason": os.strerror(ctypes.get_errno()),
                }
            )
            self.events[tid] = None
            return
        try:
            mem = mmap.mmap(
                fd,
                self.pagesize * 17,
                flags=mmap.MAP_SHARED,
                prot=mmap.PROT_READ | mmap.PROT_WRITE,
            )
            fcntl.ioctl(fd, 0x2400, 0)
            self.events[tid] = (fd, mem)
        except BaseException as e:
            os.close(fd)
            self.events[tid] = None
            self.errors.append({"tid": tid, "stage": "mmap-enable", "reason": repr(e)})

    def drain(self, tid, pair):
        if pair is None:
            return
        fd, mem = pair
        head = struct.unpack_from("Q", mem, 1024)[0]
        tail = struct.unpack_from("Q", mem, 1032)[0]
        offset, size = struct.unpack_from("QQ", mem, 1040)
        if not size:
            offset = self.pagesize
            size = self.pagesize * 16
        if head - tail > size:
            self.errors.append(
                {"tid": tid, "stage": "reader-overrun", "bytes": head - tail}
            )
            struct.pack_into("Q", mem, 1032, head)
            return

        def data(at, n):
            start = at % size
            first = min(n, size - start)
            return (
                mem[offset + start : offset + start + first]
                + mem[offset : offset + n - first]
            )

        while tail < head:
            header = data(tail, 8)
            kind, misc, n = struct.unpack("IHH", header)
            if n < 8 or n > size or tail + n > head:
                self.errors.append(
                    {"tid": tid, "stage": "invalid-record", "kind": kind, "bytes": n}
                )
                tail = head
                break
            record = data(tail, n)
            tail += n
            if kind == 9:
                ip, pid, event_tid, stamp, nr = struct.unpack_from("QIIQQ", record, 8)
                assert nr <= 64 and 40 + 8 * nr <= n
                chain = list(struct.unpack_from(f"{nr}Q", record, 40))
                self.samples.append(
                    {
                        "tid": event_tid,
                        "ip": ip,
                        "monotonic_ns": stamp,
                        "callchain": chain,
                        "misc": misc,
                    }
                )
            elif kind == 2:
                self.lost += struct.unpack_from("Q", record, 16)[0]
        struct.pack_into("Q", mem, 1032, tail)

    def poll(self, pid):
        now = time.monotonic_ns()
        threads = []
        for p in Path(f"/proc/{pid}/task").iterdir():
            try:
                tid = int(p.name)
                raw = (p / "stat").read_text()
                a = raw[raw.rfind(")") + 2 :].split()
                threads.append(
                    {
                        "tid": tid,
                        "name": (p / "comm").read_text().strip(),
                        "state": a[0],
                        "user_ticks": int(a[11]),
                        "system_ticks": int(a[12]),
                        "wchan": (p / "wchan").read_text().strip(),
                    }
                )
                if tid not in self.events:
                    self.attach(tid)
            except (OSError, ValueError):
                continue
        try:
            maps = Path(f"/proc/{pid}/maps").read_text()
        except OSError:
            maps = ""
        self.timeline.append({"monotonic_ns": now, "threads": threads, "maps": maps})
        for tid, pair in self.events.items():
            self.drain(tid, pair)

    def close(self):
        for tid, pair in self.events.items():
            if pair is None:
                continue
            fd, mem = pair
            try:
                fcntl.ioctl(fd, 0x2401, 0)
                self.drain(tid, pair)
            finally:
                mem.close()
                os.close(fd)


out = D / "cpu-diagnostic-jit-v2"
out.mkdir(exist_ok=False)
status = {
    "pid": os.getpid(),
    "pgid": os.getpgrp(),
    "state": "starting",
    "performance_eligible": False,
}


def save():
    (out / "status.json").write_text(json.dumps(status, indent=2) + "\n")


def stop(s, f):
    raise KeyboardInterrupt(s)


for s in (signal.SIGINT, signal.SIGTERM, signal.SIGALRM):
    signal.signal(s, stop)
signal.alarm(120)
save()
os.environ.update(
    DISPLAY=":285",
    XDG_RUNTIME_DIR=str(T / "runtime/five-app"),
    TODO_X11_LIBRARY="/nix/store/rck9w8gj3r2w2z1xpw15g1fvpzi8iz9h-libx11-1.8.13/lib/libX11.so.6",
)
x = None
sampler = Sampler()
original = r.core.proc_sample
try:
    with (T / "host.lock").open("a+") as lease:
        fcntl.flock(lease, fcntl.LOCK_EX)
        if r.active_builds():
            raise RuntimeError("builds active")
        assert platform.machine() == "x86_64"
        manifest = json.loads((T / "evidence/five-app/manifest.json").read_text())
        r.core.XDOTOOL = manifest["xdotool"]
        app = json.loads((D / "preflight-v2/app.json").read_text())
        (out / "jit-symbols").mkdir()
        (out / "perf-buildid").mkdir()
        app = {
            **app,
            "environment": {
                **app["environment"],
                "JIT_SYMBOL_MAP_DIR": str(out / "jit-symbols"),
                "PERF_BUILDID_DIR": str(out / "perf-buildid"),
            },
        }
        r.core.EXPECTED_WINDOW_TITLES["gpui-mapped"] = app["title"]
        frozen = r.fingerprint({"apps": {"mapped": app}})
        (out / "freeze.json").write_text(json.dumps(frozen, indent=2))

        def sample(pid):
            sampler.poll(pid)
            return original(pid)

        r.core.proc_sample = sample
        x = subprocess.Popen(
            [
                "/nix/store/iw8dx6lhrkdc5wzszjzqzl677y68y88r-xvfb-21.1.24/bin/Xvfb",
                ":285",
                "-screen",
                "0",
                "1280x1024x24",
                "-nolisten",
                "tcp",
            ],
            stdout=(out / "xvfb.log").open("wb"),
            stderr=subprocess.STDOUT,
            start_new_session=True,
        )
        time.sleep(1)
        row = r.run_cell("gpui-mapped", app, "animation", 1, out, 6, 1)
        row.update(
            mode="animation",
            source_and_binary_unchanged=r.fingerprint({"apps": {"mapped": app}})
            == frozen,
            performance_eligible=False,
        )
        row["original_runner_accepted"] = r.accepted(row)
        row["host_audit"] = audit_animation(row)
        sampler.close()
        owned_pid = sampler.timeline[0]["threads"][0]["tid"]
        jit_files = []
        for suffix in (".map", ".map.asm"):
            path = Path(f"/tmp/perf-{owned_pid}" + suffix)
            if path.exists():
                target = out / "jit-symbols" / path.name
                target.write_bytes(path.read_bytes())
                jit_files.append(
                    {
                        "path": str(path),
                        "copied_to": str(target),
                        "bytes": path.stat().st_size,
                        "mtime_ns": path.stat().st_mtime_ns,
                    }
                )
        (out / "jit-output-inventory.json").write_text(
            json.dumps(
                {
                    "owned_child_pid": owned_pid,
                    "jit_files": jit_files,
                    "directory_files": [
                        str(p) for p in (out / "jit-symbols").iterdir()
                    ],
                    "environment": {
                        "JIT_SYMBOL_MAP_DIR": str(out / "jit-symbols"),
                        "PERF_BUILDID_DIR": str(out / "perf-buildid"),
                    },
                    "correctness_disable_flags_set": False,
                },
                indent=2,
            )
            + "\n"
        )
        a, b = (
            row["measurement_start_monotonic_ns"],
            row["measurement_end_monotonic_ns"],
        )
        inside = [p for p in sampler.samples if a <= p["monotonic_ns"] <= b]
        maps = []
        for snap in sampler.timeline:
            if snap["maps"]:
                for line in snap["maps"].splitlines():
                    fields = line.split(None, 5)
                    lo, hi = [int(x, 16) for x in fields[0].split("-")]
                    maps.append(
                        (
                            lo,
                            hi,
                            int(fields[2], 16),
                            fields[5] if len(fields) > 5 else "[anonymous]",
                            fields[1],
                        )
                    )
        maps = list(dict.fromkeys(maps))
        bytid = collections.Counter()
        bymodule = collections.Counter()
        byip = collections.Counter()
        for p in inside:
            module = next((m for m in maps if m[0] <= p["ip"] < m[1]), None)
            p["module"] = module[3] if module else "[unmapped]"
            p["module_relative_ip"] = (
                p["ip"] - module[0] + module[2] if module else None
            )
            bytid[p["tid"]] += 1
            bymodule[p["module"]] += 1
            byip[(p["module"], p["module_relative_ip"])] += 1
        selected = [s for s in sampler.timeline if a <= s["monotonic_ns"] <= b]
        threadcpu = []
        for tid in sampler.events:
            values = [
                (s["monotonic_ns"], t)
                for s in selected
                for t in s["threads"]
                if t["tid"] == tid
            ]
            if len(values) >= 2:
                first, last = values[0], values[-1]
                delta = (
                    last[1]["user_ticks"]
                    + last[1]["system_ticks"]
                    - first[1]["user_ticks"]
                    - first[1]["system_ticks"]
                )
                threadcpu.append(
                    {
                        "tid": tid,
                        "name": last[1]["name"],
                        "cpu_ticks_delta": delta,
                        "cpu_seconds": delta / os.sysconf("SC_CLK_TCK"),
                        "elapsed_sampled_s": (last[0] - first[0]) / 1e9,
                        "user_cpu_clock_samples": bytid[tid],
                    }
                )
        threadcpu.sort(key=lambda t: t["cpu_seconds"], reverse=True)
        summary = {
            "instrumented_diagnostic_only": True,
            "source_and_binary_unchanged": row["source_and_binary_unchanged"],
            "sample_method": "owned per-thread perf_event_open PERF_TYPE_SOFTWARE CPU_CLOCK,10msperiod, userspace IP+callchains; CLOCK_MONOTONIC; kernel/hypervisor excluded",
            "kernel_settings_changed": False,
            "lost_samples": sampler.lost,
            "errors": sampler.errors,
            "measurement_window_samples": len(inside),
            "module_leaf_samples": dict(bymodule),
            "threads": threadcpu,
            "top_instruction_addresses": [
                {"module": k[0], "relative_ip": k[1], "samples": n}
                for k, n in byip.most_common(60)
            ],
            "host_receipts": row["present_frame_count"],
            "model_ticks": row["animation_ticks"],
            "model_skipped": row["animation_skipped"],
            "limits": [
                "Software CPU-clock IP sample counts are statistical, not cycle-exact.",
                "Short-lived threads may be missed before100msdiscovery.",
                "Callchains may truncate without frame pointers; raw IPs/maps retained.",
                "Visible marker samples record presented revisions, not every internal model event.",
                "These instrumented observations are excluded from performance medians.",
            ],
        }
        (out / "result.json").write_text(json.dumps(row, indent=2) + "\n")
        (out / "raw-perf-samples.json").write_text(
            json.dumps(
                {
                    "all_samples": sampler.samples,
                    "in_measurement_window": inside,
                    "timeline": sampler.timeline,
                    "lost_samples": sampler.lost,
                    "errors": sampler.errors,
                },
                indent=2,
            )
            + "\n"
        )
        (out / "summary.json").write_text(json.dumps(summary, indent=2) + "\n")
        status.update(
            state="complete",
            samples=len(inside),
            lost=sampler.lost,
            host_receipts=row["present_frame_count"],
        )
        print(json.dumps(summary), flush=True)
except BaseException as error:
    status.update(state="failed", error=repr(error), traceback=traceback.format_exc())
finally:
    r.core.proc_sample = original
    r.core.close_active_children()
    if x and x.poll() is None:
        os.killpg(x.pid, signal.SIGTERM)
        x.wait(timeout=10)
    status["completed_utc"] = datetime.datetime.now(datetime.timezone.utc).isoformat()
    save()
