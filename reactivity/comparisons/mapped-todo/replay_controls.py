#!/usr/bin/env python3
"""Replay all original native harness controls and sealed real-present starvation ELF."""

import datetime, fcntl, json, os, signal, subprocess, sys, time, traceback
from pathlib import Path

T = Path(os.environ.get("TODO_TASK_ROOT", "/home/miles/gpui-ce3-compute-20261024"))
D = T / "evidence/mapped-todo"
sys.path.insert(0, str(T / "src/mapped-todo-runner"))
import run as r, fault_controls
from presentation_audit import audit_animation

out = D / "replayed-controls-v1"
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
signal.alarm(240)
save()
os.environ.update(
    DISPLAY=":287",
    XDG_RUNTIME_DIR=str(T / "runtime/five-app"),
    TODO_X11_LIBRARY="/nix/store/rck9w8gj3r2w2z1xpw15g1fvpzi8iz9h-libx11-1.8.13/lib/libX11.so.6",
)
x = None
try:
    if r.active_builds():
        raise RuntimeError("builds active")
    x = subprocess.Popen(
        [
            "/nix/store/iw8dx6lhrkdc5wzszjzqzl677y68y88r-xvfb-21.1.24/bin/Xvfb",
            ":287",
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
    original_wait = r.core.wait_first_present
    try:
        sys.argv = [
            "fault_controls.py",
            "--manifest",
            str(T / "evidence/five-app/manifest.json"),
            "--output",
            str(out / "original-seven"),
            "--lease",
            str(T / "host.lock"),
            "--historical-archive",
            str(T / "evidence/five-app/historical/results-20261023.jsonl"),
        ]
        status["state"] = "original-seven-native-controls"
        save()
        rc = fault_controls.main()
        status["original_seven_exit_code"] = rc
        save()
        assert rc == 0
    finally:
        r.core.wait_first_present = original_wait
    with (T / "host.lock").open("a+") as lease:
        fcntl.flock(lease, fcntl.LOCK_EX)
        if r.active_builds():
            raise RuntimeError("builds active")
        manifest = json.loads((T / "evidence/five-app/manifest.json").read_text())
        r.core.XDOTOOL = manifest["xdotool"]
        app = {
            **manifest["apps"]["zeronsh-zgui"],
            "binary": str(
                T / "targets/mapped-todo-controls/bin/native-present-control"
            ),
            "source": str(T / "src/five-app/zeronsh-native-present-control-v1"),
        }
        r.core.EXPECTED_WINDOW_TITLES["zeronsh-zgui"] = app["title"]
        frozen = r.fingerprint({"apps": {"control": app}})
        receipt = json.loads(
            (
                T / "evidence/five-app/builds/native-present-control-v1-receipt.json"
            ).read_text()
        )
        assert (
            receipt["successful"]
            and receipt["source_after"] == frozen["control"]["source"]
            and receipt["binary_sha256"] == frozen["control"]["binary"]
        )
        cases = []
        for name, env in [
            ("positive", {}),
            (
                "actual-native-starvation",
                {"TODO_TEST_NATIVE_PRESENT_INTERVAL_MS": "200"},
            ),
        ]:
            status.update(state="actual-native-present-controls", case=name)
            save()
            case = out / name
            case.mkdir()
            row = r.run_cell(
                "zeronsh-zgui",
                {**app, "environment": {**app["environment"], **env}},
                "animation",
                1,
                case,
                6,
                2,
            )
            row.update(
                variant="zeronsh-zgui",
                mode="animation",
                repeat=1,
                performance_eligible=False,
                source_and_binary_unchanged=r.fingerprint({"apps": {"control": app}})
                == frozen,
            )
            row["original_runner_accepted"] = r.accepted(row)
            row["host_audit"] = audit_animation(row)
            controls = [
                json.loads(l.split(",", 1)[1])
                for l in Path(row["log_path"]).read_text().splitlines()
                if l.startswith("TODO_NATIVE_PRESENT_CONTROL,")
            ]
            row["native_control_receipt"] = controls
            row["control_passed"] = (
                (row["original_runner_accepted"] and row["host_audit"]["eligible"])
                if name == "positive"
                else (
                    row["original_runner_accepted"]
                    and not row["host_audit"]["eligible"]
                    and controls[0]["deferred_native_draws"] > 100
                    and row["present_frame_count"] < 60
                )
            )
            (case / "result.json").write_text(json.dumps(row, indent=2) + "\n")
            cases.append(
                {
                    "case": name,
                    "control_passed": row["control_passed"],
                    "original_accepted": row["original_runner_accepted"],
                    "host_audit_eligible": row["host_audit"]["eligible"],
                    "host_receipts": row["present_frame_count"],
                }
            )
            status["native_present_controls"] = cases
            save()
            print(json.dumps(cases[-1]), flush=True)
        status.update(
            state="complete",
            all_controls_passed=rc == 0 and all(c["control_passed"] for c in cases),
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
