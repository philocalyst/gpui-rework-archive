#!/usr/bin/env python3
"""Untimed, same-core full animation policy probes, never primary performance data."""

import datetime, fcntl, json, os, signal, subprocess, sys, time, traceback
from pathlib import Path

T = Path(os.environ.get("TODO_TASK_ROOT", "/home/miles/gpui-ce3-compute-20261024"))
D = T / "evidence/mapped-todo"
sys.path.insert(0, str(T / "src/mapped-todo-runner"))
import run as r
from presentation_audit import audit_animation

out = D / "auto-macro-probes-v1"
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
signal.alarm(180)
save()
os.environ.update(
    DISPLAY=":286",
    XDG_RUNTIME_DIR=str(T / "runtime/five-app"),
    TODO_X11_LIBRARY="/nix/store/rck9w8gj3r2w2z1xpw15g1fvpzi8iz9h-libx11-1.8.13/lib/libX11.so.6",
)
x = None
original = r.core.Child
base = json.loads((T / "evidence/five-app/manifest.json").read_text())
r.core.XDOTOOL = base["xdotool"]
apps = {}
for name, example in [
    ("gpui-mapped", "todo_comparison_mapped"),
    ("gpui-control", "todo_comparison_five"),
]:
    apps[name] = {
        **base["apps"]["gpui"],
        "source": str(T / "src/mapped-todo"),
        "binary": str(T / "targets/mapped-todo/release/examples" / example),
        "build_receipt": str(D / f"{example}-v2-receipt.json"),
    }
    r.core.EXPECTED_WINDOW_TITLES[name] = apps[name]["title"]
try:
    with (T / "host.lock").open("a+") as lease:
        fcntl.flock(lease, fcntl.LOCK_EX)
        if r.active_builds():
            raise RuntimeError("builds active")
        frozen = r.fingerprint({"apps": apps})
        (out / "freeze.json").write_text(json.dumps(frozen, indent=2))
        x = subprocess.Popen(
            [
                "/nix/store/iw8dx6lhrkdc5wzszjzqzl677y68y88r-xvfb-21.1.24/bin/Xvfb",
                ":286",
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
        cases = []
        for name, policy, mode in [
            ("gpui-mapped", "auto", "busy"),
            ("gpui-control", "auto", "busy"),
            ("gpui-mapped", "auto", "heavy"),
            ("gpui-control", "auto", "heavy"),
        ]:
            status.update(state="probing", variant=name, policy=policy, mode=mode)
            save()
            case = out / f"{name}-{policy}-{mode}"
            case.mkdir()

            def child(binary, env, log):
                return original(binary, {**env, "TODO_BENCH_RENDERER": policy}, log)

            r.core.Child = child
            try:
                row = r.run_cell(name, apps[name], mode, 1, case, 2, 1)
                row.update(
                    variant=name,
                    mode=mode,
                    repeat=1,
                    source_and_binary_unchanged=r.fingerprint({"apps": apps}) == frozen,
                    performance_eligible=False,
                    spawn_renderer_policy=policy,
                )
                row["original_runner_accepted"] = r.accepted(row)
                row["host_audit"] = audit_animation(row)
                records = [
                    json.loads(l.split(",", 1)[1])
                    for l in Path(row["log_path"]).read_text().splitlines()
                    if l.startswith("TODO_REACTIVITY,")
                ]
                row["reactivity"] = records[0] if len(records) == 1 else None
                row["mapped_description_gate"] = (
                    mode != "animation"
                    or name != "gpui-mapped"
                    or (
                        bool(row["reactivity"])
                        and row["reactivity"]["owner_descriptions_after_first_present"]
                        == 0
                        and row["reactivity"]["row_descriptions_after_first_present"]
                        == 0
                    )
                )
                row["qualified"] = (
                    row["original_runner_accepted"]
                    and row["host_audit"]["eligible"]
                    and row["mapped_description_gate"]
                )
            except BaseException as error:
                row = {
                    "variant": name,
                    "policy": policy,
                    "mode": mode,
                    "qualified": False,
                    "error": repr(error),
                    "traceback": traceback.format_exc(),
                    "performance_eligible": False,
                }
            finally:
                r.core.Child = original
            (case / "result.json").write_text(json.dumps(row, indent=2) + "\n")
            cases.append(
                {
                    "variant": name,
                    "policy": policy,
                    "mode": mode,
                    "qualified": row["qualified"],
                    "ticks": row.get("animation_ticks"),
                    "skipped": row.get("animation_skipped"),
                    "host_receipts": row.get("present_frame_count"),
                    "renderer": row.get("renderer_first_present"),
                    "original_accepted": row.get("original_runner_accepted"),
                    "host_audit_eligible": row.get("host_audit", {}).get("eligible"),
                    "reactivity": row.get("reactivity"),
                    "error": row.get("error"),
                }
            )
            status["cases"] = cases
            save()
            print(json.dumps(cases[-1]), flush=True)
        status["state"] = "complete"
except BaseException as error:
    status.update(state="failed", error=repr(error), traceback=traceback.format_exc())
finally:
    r.core.close_active_children()
    r.core.Child = original
    if x and x.poll() is None:
        os.killpg(x.pid, signal.SIGTERM)
        x.wait(timeout=10)
    status["completed_utc"] = datetime.datetime.now(datetime.timezone.utc).isoformat()
    save()
