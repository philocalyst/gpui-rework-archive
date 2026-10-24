#!/usr/bin/env python3
"""Native full-app qualification for the separate mapped API spike. No performance reuse."""

import ctypes, datetime, fcntl, json, os, signal, subprocess, sys, time, traceback
from pathlib import Path

T = Path(os.environ.get("TODO_TASK_ROOT", "/home/miles/gpui-ce3-compute-20261024"))
D = T / "evidence/mapped-todo"
sys.path.insert(0, str(T / "src/mapped-todo-runner"))
import run as r

sys.path.insert(0, str(T / "src/mapped-todo-runner"))
from presentation_audit import audit_animation

out = D / "preflight-v2"
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
signal.alarm(600)
save()
os.environ.update(
    DISPLAY=":281",
    XDG_RUNTIME_DIR=str(T / "runtime/five-app"),
    TODO_X11_LIBRARY="/nix/store/rck9w8gj3r2w2z1xpw15g1fvpzi8iz9h-libx11-1.8.13/lib/libX11.so.6",
)
x = None
manifest = json.loads((T / "evidence/five-app/manifest.json").read_text())
r.core.XDOTOOL = manifest["xdotool"]
base = manifest["apps"]["gpui"]
app = {
    **base,
    "source": str(T / "src/mapped-todo"),
    "binary": str(T / "targets/mapped-todo/release/examples/todo_comparison_mapped"),
    "build_receipt": str(D / "todo_comparison_mapped-v2-receipt.json"),
}
r.core.EXPECTED_WINDOW_TITLES["gpui-mapped"] = app["title"]
frozen = {}


def summarize(log):
    data = [
        json.loads(l.split(",", 1)[1])
        for l in Path(log).read_text().splitlines()
        if l.startswith("TODO_REACTIVITY,")
    ]
    return data[0] if len(data) == 1 else None


try:
    with (T / "host.lock").open("a+") as lease:
        fcntl.flock(lease, fcntl.LOCK_EX)
        if r.active_builds():
            raise RuntimeError("builds active")
        frozen = r.fingerprint({"apps": {"gpui-mapped": app}})
        receipt = json.loads(Path(app["build_receipt"]).read_text())
        assert (
            receipt["successful"]
            and receipt["source_after"] == frozen["gpui-mapped"]["source"]
            and receipt["binary_sha256"] == frozen["gpui-mapped"]["binary"]
        )
        (out / "freeze.json").write_text(json.dumps(frozen, indent=2))
        (out / "app.json").write_text(json.dumps(app, indent=2))
        x = subprocess.Popen(
            [
                "/nix/store/iw8dx6lhrkdc5wzszjzqzl677y68y88r-xvfb-21.1.24/bin/Xvfb",
                ":281",
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
        for mode, seconds in [("idle", 2), ("busy", 2), ("animation", 6)]:
            status.update(state="smoke", mode=mode)
            save()
            case = out / mode
            case.mkdir()
            try:
                row = r.run_cell("gpui-mapped", app, mode, 1, case, seconds, 1)
                row.update(
                    variant="gpui-mapped",
                    mode=mode,
                    repeat=1,
                    source_and_binary_unchanged=r.fingerprint(
                        {"apps": {"gpui-mapped": app}}
                    )
                    == frozen,
                    performance_eligible=False,
                )
                row["original_runner_accepted"] = r.accepted(row)
                row["host_audit"] = audit_animation(row)
                row["reactivity"] = summarize(row["log_path"])
                row["mapped_description_gate"] = mode != "animation" or (
                    bool(row["reactivity"])
                    and row["reactivity"]["owner_descriptions_after_first_present"] == 0
                    and row["reactivity"]["row_descriptions_after_first_present"] == 0
                    and row["reactivity"]["initial_row_descriptions"] >= 1000
                )
                row["qualified"] = (
                    row["original_runner_accepted"]
                    and row["host_audit"]["eligible"]
                    and row["mapped_description_gate"]
                )
            except BaseException as error:
                row = {
                    "variant": "gpui-mapped",
                    "mode": mode,
                    "qualified": False,
                    "error": repr(error),
                    "traceback": traceback.format_exc(),
                    "performance_eligible": False,
                }
            (case / "result.json").write_text(json.dumps(row, indent=2) + "\n")
            cases.append(
                {
                    "mode": mode,
                    "qualified": row["qualified"],
                    "original_accepted": row.get("original_runner_accepted"),
                    "host_audit": row.get("host_audit"),
                    "reactivity": row.get("reactivity"),
                    "error": row.get("error"),
                }
            )
            status["cases"] = cases
            save()
            print(json.dumps(cases[-1]), flush=True)
        status.update(
            state="complete", all_smokes_passed=all(c["qualified"] for c in cases)
        )
except BaseException as error:
    status.update(state="failed", error=repr(error), traceback=traceback.format_exc())
finally:
    r.core.close_active_children()
    if x and x.poll() is None:
        os.killpg(x.pid, signal.SIGTERM)
        x.wait(timeout=10)
    status["completed_utc"] = datetime.datetime.now(datetime.timezone.utc).isoformat()
    save()
