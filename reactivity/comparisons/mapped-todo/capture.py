#!/usr/bin/env python3
"""Registered conditional successor capture; original five-app observations stay immutable."""

import datetime, fcntl, hashlib, json, os, signal, subprocess, sys, time, traceback
from pathlib import Path

T = Path(os.environ.get("TODO_TASK_ROOT", "/home/miles/gpui-ce3-compute-20261024"))
D = T / "evidence/mapped-todo"
R = T / "src/mapped-todo-runner"
sys.path.insert(0, str(R))
import run as r
from presentation_audit import audit_animation

out = D / "capture-v1"
out.mkdir(exist_ok=False)
status = {
    "pid": os.getpid(),
    "pgid": os.getpgrp(),
    "state": "starting",
    "original_five_app_capture_modified": False,
    "core_pin": "0062bf589829c4f28807ad0fde3e13285379294c",
    "completed_cells": [],
}


def save():
    (out / "status.json").write_text(json.dumps(status, indent=2) + "\n")


def stop(s, f):
    raise KeyboardInterrupt(s)


for s in (signal.SIGINT, signal.SIGTERM, signal.SIGALRM):
    signal.signal(s, stop)
signal.alarm(1500)
save()
os.environ.update(
    DISPLAY=":290",
    XDG_RUNTIME_DIR=str(T / "runtime/five-app"),
    TODO_X11_LIBRARY="/nix/store/rck9w8gj3r2w2z1xpw15g1fvpzi8iz9h-libx11-1.8.13/lib/libX11.so.6",
)
x = None
original = r.core.Child


def chrome(path):
    raw = Path(path).read_bytes().split(b"\n", 3)[3]

    def pixels(x0, y0, x1, y1):
        return [
            raw[(y * 540 + x) * 3 : (y * 540 + x) * 3 + 3]
            for y in range(y0, y1)
            for x in range(x0, x1)
        ]

    title = pixels(24, 24, 115, 62)
    field = pixels(24, 82, 300, 112)
    margin = pixels(8, 8, 20, 65)
    return (
        sum(max(p) < 180 for p in title) >= 40
        and sum(min(p) > 220 for p in title) >= 1500
        and sum(min(p) > 220 and max(p) - min(p) >= 3 for p in field) >= 500
        and sum(min(p) > 220 for p in margin) >= 500
    )


try:
    with (T / "host.lock").open("a+") as lease:
        fcntl.flock(lease, fcntl.LOCK_EX)
        if r.active_builds():
            raise RuntimeError("builds active")
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
        frozen = r.fingerprint({"apps": apps})
        (out / "freeze.json").write_text(json.dumps(frozen, indent=2))
        manifest = {
            "schema": 1,
            "core_pin": status["core_pin"],
            "fixture_commit": "739c074f1dbd07d35d976fb64cd33a9c15030051",
            "apps": apps,
            "hardware": base.get("hardware", {}),
            "build_profiles": "unchanged release debug0 incrementalfalse x11 includesnormalaccessibility; samecorecontrol andmappedapp",
            "original_five_app_results_reused": False,
            "policy_profiles_pooled": False,
            "startup_definition": "warmspawn→hostsubmissionack, separatefromvisibleUI",
            "physical_gpu_and_scanout": "unsupportedsoftwareheadlesshost",
            "schedule": [],
            "skipped_for_failed_native_preflight": [],
        }

        manifest["skipped_for_failed_native_preflight"] = [
            {
                "variant": "gpui-mapped",
                "policy": "gpu",
                "mode": "animation",
                "reason": "6s delivery/skip/host-receipt failure; no30scapture",
            },
            {
                "variant": "gpui-mapped",
                "policy": "gpu",
                "mode": "heavy",
                "reason": "strict2s8eventnative macro failure; slowsemanticmacro passingdoesnotqualifydeadlines",
            },
        ] + [
            {
                "variant": n,
                "policy": "auto",
                "mode": "heavy",
                "reason": "strict2s8eventnative macro failure; no30scapture",
            }
            for n in apps
        ]
        for name, a in apps.items():
            receipt = json.loads(Path(a["build_receipt"]).read_text())
            assert (
                receipt["successful"]
                and receipt["source_after"] == frozen[name]["source"]
                and receipt["binary_sha256"] == frozen[name]["binary"]
            )
        assert json.loads((D / "functional-v1/status.json").read_text())[
            "all_functional_qualification_passed"
        ]
        assert json.loads((D / "replayed-controls-v1/status.json").read_text())[
            "all_controls_passed"
        ]
        r.mandatory_historical_audit(
            T / "evidence/five-app/historical/results-20261023.jsonl"
        )
        auto = json.loads((D / "auto-macro-probes-v1/status.json").read_text())["cases"]
        policy = json.loads((D / "policy-probes-v1/status.json").read_text())["cases"]
        gpu = json.loads((D / "preflight-v2/status.json").read_text())["cases"]
        assert all(
            next(c for c in auto if c["variant"] == n and c["mode"] == "busy")[
                "qualified"
            ]
            for n in apps
        )
        assert all(
            next(c for c in policy if c["variant"] == n and c["policy"] == "auto")[
                "qualified"
            ]
            for n in apps
        )
        assert all(
            next(c for c in gpu if c["mode"] == mode)["qualified"]
            for mode in ("idle", "busy")
        )
        schedule = []
        for rep in (1, 2, 3):
            for mode in (("idle", "busy") if rep % 2 else ("busy", "idle")):
                schedule.append(
                    {
                        "variant": "gpui-mapped",
                        "policy": "gpu",
                        "mode": mode,
                        "repeat": rep,
                    }
                )
            for mode in (("busy", "animation") if rep % 2 else ("animation", "busy")):
                for name in (
                    ("gpui-mapped", "gpui-control")
                    if rep % 2
                    else ("gpui-control", "gpui-mapped")
                ):
                    schedule.append(
                        {"variant": name, "policy": "auto", "mode": mode, "repeat": rep}
                    )
            schedule.append(
                {
                    "variant": "gpui-mapped",
                    "policy": "gpu",
                    "mode": "startup",
                    "repeat": rep,
                }
            )
        manifest["schedule"] = schedule
        (out / "manifest.json").write_text(json.dumps(manifest, indent=2) + "\n")
        harness = {
            str(p): r.core.file_sha256(p)
            for p in (
                R / "run.py",
                R / "todo_core.py",
                R / "presentation_audit.py",
                Path(__file__),
            )
        }
        (out / "harness-freeze.json").write_text(json.dumps(harness, indent=2) + "\n")
        status["expected_cells"] = len(schedule)
        save()
        x = subprocess.Popen(
            [
                "/nix/store/iw8dx6lhrkdc5wzszjzqzl677y68y88r-xvfb-21.1.24/bin/Xvfb",
                ":290",
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
        for i, cell in enumerate(schedule):
            if r.active_builds():
                raise RuntimeError("build appeared during exclusivecapture")
            if r.fingerprint({"apps": apps}) != frozen:
                raise RuntimeError("source/ELF changed beforecell")
            name, policy, mode, rep = (
                cell[k] for k in ("variant", "policy", "mode", "repeat")
            )
            status.update(state="measuring", current=cell)
            save()
            case = out / f"{i:02}-{name}-{policy}-{mode}-r{rep}"
            case.mkdir()

            def child(binary, env, log):
                return original(binary, {**env, "TODO_BENCH_RENDERER": policy}, log)

            r.core.Child = child
            try:
                row = r.run_cell(name, apps[name], mode, rep, case, 30, 5)
                row.update(
                    variant=name,
                    mode=mode,
                    repeat=rep,
                    source_and_binary_unchanged=r.fingerprint({"apps": apps}) == frozen,
                    spawn_renderer_policy=policy,
                    profile="mapped-API-spike-0062-same-core",
                    instrumented_cpu_profile=False,
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
                    name != "gpui-mapped"
                    or mode != "animation"
                    or (
                        bool(row["reactivity"])
                        and row["reactivity"]["owner_descriptions_after_first_present"]
                        == 0
                        and row["reactivity"]["row_descriptions_after_first_present"]
                        == 0
                    )
                )
                final = [
                    s
                    for s in row["screenshots"]
                    if "path" in s and "-final." in s["path"]
                ]
                row["final_chrome_anchor"] = len(final) == 1 and chrome(
                    final[0]["path"]
                )
                row["qualified"] = (
                    row["original_runner_accepted"]
                    and row["host_audit"]["eligible"]
                    and row["mapped_description_gate"]
                    and row["final_chrome_anchor"]
                )
                row["performance_eligible"] = row["qualified"]
            except BaseException as error:
                row = {
                    **cell,
                    "qualified": False,
                    "performance_eligible": False,
                    "error": repr(error),
                    "traceback": traceback.format_exc(),
                }
            finally:
                r.core.Child = original
                r.core.close_active_children()
            (case / "result.json").write_text(json.dumps(row, indent=2) + "\n")
            (out / "results.jsonl").open("a").write(json.dumps(row) + "\n")
            status["completed_cells"].append(
                {**cell, "qualified": row["qualified"], "error": row.get("error")}
            )
            save()
            print(json.dumps(status["completed_cells"][-1]), flush=True)
        status.update(
            state="complete",
            harness_unchanged=all(
                r.core.file_sha256(Path(p)) == sha for p, sha in harness.items()
            ),
            source_and_binary_unchanged=r.fingerprint({"apps": apps}) == frozen,
            all_workloads_qualified=all(
                c["qualified"] for c in status["completed_cells"]
            ),
        )
except BaseException as error:
    status.update(state="failed", error=repr(error), traceback=traceback.format_exc())
finally:
    r.core.Child = original
    r.core.close_active_children()
    if x and x.poll() is None:
        os.killpg(x.pid, signal.SIGTERM)
        x.wait(timeout=10)
    status["completed_utc"] = datetime.datetime.now(datetime.timezone.utc).isoformat()
    save()
