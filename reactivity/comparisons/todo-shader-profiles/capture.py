#!/usr/bin/env python3
"""Native controls followed by the registered 18 short shader-profile trials."""

import datetime
import fcntl
import json
import math
import os
import signal
import subprocess
import sys
import time
import traceback
from pathlib import Path

TASK = Path("/home/miles/gpui-ce3-compute-20261024")
PAYLOAD = TASK / "src/todo-shader-profiles"
EVIDENCE = TASK / "evidence/todo-shader-profiles"
RUNNER = PAYLOAD / "runner"
OUTPUT = EVIDENCE / "capture-v1"
sys.path.insert(0, str(RUNNER))
import run as runner
from presentation_audit import audit_animation

PROFILES = ("original", "certified", "banked4")
STATUS = {
    "pid": os.getpid(),
    "pgid": os.getpgrp(),
    "state": "starting",
    "completed_controls": [],
    "completed_trials": [],
    "physical_gpu_and_scanout": "unsupported",
}


def save_status():
    (OUTPUT / "status.json").write_text(json.dumps(STATUS, indent=2) + "\n")


def interrupted(signum, frame):
    raise KeyboardInterrupt(signum)


def read_ppm(path):
    magic, dimensions, maximum, pixels = Path(path).read_bytes().split(b"\n", 3)
    width, height = map(int, dimensions.split())
    assert magic == b"P6" and maximum == b"255"
    assert (width, height) == (540, 620) and len(pixels) == width * height * 3
    return pixels


def chrome_anchor(path):
    pixels = read_ppm(path)

    def region(left, top, right, bottom):
        return [
            pixels[(y * 540 + x) * 3 : (y * 540 + x) * 3 + 3]
            for y in range(top, bottom)
            for x in range(left, right)
        ]

    title = region(24, 24, 115, 62)
    field = region(24, 82, 300, 112)
    margin = region(8, 8, 20, 65)
    return (
        sum(max(pixel) < 180 for pixel in title) >= 40
        and sum(min(pixel) > 220 for pixel in title) >= 1500
        and sum(min(pixel) > 220 and max(pixel) - min(pixel) >= 3 for pixel in field)
        >= 500
        and sum(min(pixel) > 220 for pixel in margin) >= 500
    )


def animation_phase(path):
    pixels = read_ppm(path)

    def rgb(x, y):
        return pixels[(y * 540 + x) * 3 : (y * 540 + x) * 3 + 3]

    encoded = 0
    valid = True
    for bit in range(32):
        pixel = rgb(476 + bit % 8 * 7 + 2, 18 + bit // 8 * 7 + 2)
        if min(pixel) >= 224:
            encoded |= 1 << bit
        elif max(pixel) > 31:
            valid = False
    valid = valid and encoded.bit_count() % 2 == 0
    revision = encoded & 0x7FFFFFFF

    def button(y):
        return all(
            abs(actual - wanted) <= 6
            for actual, wanted in zip(rgb(30, y), (226, 232, 240))
        )

    edges = [
        y
        for y in range(146, 185)
        if button(y - 1) and not button(y) and not button(y + 1)
    ]
    observed = edges[0] if len(edges) == 1 else None
    expected = 165.792 + 12 * math.sin(revision / 60 * math.tau)
    return {
        "marker_valid": valid,
        "revision": revision,
        "first_row_bottom": observed,
        "expected_bottom_if_no_scheduler_skips": expected,
        "phase_error_pixels": (
            abs(observed - expected) if observed is not None else None
        ),
        "scope": "single coherent final drawable; phase diagnostic only, no scanout claim",
    }


def screenshot(row, suffix):
    matches = [
        item["path"]
        for item in row.get("screenshots", [])
        if item.get("path", "").endswith(suffix)
    ]
    return matches[0] if len(matches) == 1 else None


def app_configurations():
    verification = json.loads((EVIDENCE / "verification-v1.json").read_text())
    assert verification["all_verified"] and verification["build_supervisor_reaped"]
    builds = json.loads((EVIDENCE / "attempt2/build-status.json").read_text())
    assert builds["state"] == "complete" and builds["all_builds_reaped"]
    try:
        os.kill(builds["pid"], 0)
    except ProcessLookupError:
        pass
    else:
        raise RuntimeError("Shader build supervisor is still live.")
    base = json.loads((TASK / "evidence/five-app/manifest.json").read_text())
    runner.core.XDOTOOL = base["xdotool"]
    apps = {}
    for profile in PROFILES:
        case = EVIDENCE / "attempt2/builds" / profile
        name = f"gpu-{profile}"
        apps[name] = {
            **base["apps"]["gpui"],
            "source": str(case / "source"),
            "binary": str(case / "todo_comparison_mapped"),
            "build_receipt": str(case / "receipt.json"),
        }
        runner.core.EXPECTED_WINDOW_TITLES[name] = apps[name]["title"]
    return apps


def execute_cell(profile, mode, repeat, directory, apps, frozen, fault=None):
    directory.mkdir()
    name = f"gpu-{profile}"
    app = dict(apps[name])
    if fault:
        app["environment"] = {**app["environment"], **fault}
    if runner.active_builds():
        raise RuntimeError("A compiler appeared during the exclusive runtime lease.")
    assert runner.fingerprint({"apps": apps}) == frozen
    subprocess.run(
        [runner.core.XDOTOOL, "mousemove", "--sync", "1100", "900"], check=True
    )
    try:
        duration = 6 if mode == "animation" else 2
        row = runner.run_cell(name, app, mode, repeat, directory, duration, 1)
        row.update(
            variant=name,
            profile=profile,
            mode=mode,
            repeat=repeat,
            spawn_renderer_policy="gpu",
            source_and_binary_unchanged=runner.fingerprint({"apps": apps}) == frozen,
            instrumented_cpu_profile=False,
            short_registered_trial=True,
        )
        row["original_runner_accepted"] = runner.accepted(row)
        row["host_audit"] = audit_animation(row)
        records = [
            json.loads(line.split(",", 1)[1])
            for line in Path(row["log_path"]).read_text().splitlines()
            if line.startswith("TODO_REACTIVITY,")
        ]
        row["reactivity"] = records[0] if len(records) == 1 else None
        row["mapped_description_gate"] = mode != "animation" or (
            bool(row["reactivity"])
            and row["reactivity"]["owner_descriptions_after_first_present"] == 0
            and row["reactivity"]["row_descriptions_after_first_present"] == 0
        )
        final = screenshot(row, "-final.ppm")
        row["final_chrome_anchor"] = bool(final) and chrome_anchor(final)
        if mode == "animation" and final:
            row["coherent_final_phase"] = animation_phase(final)
            row["coherent_final_phase"]["phase_comparison_applicable"] = (
                row.get("animation_skipped") == 0
            )
        row["qualified"] = (
            row["original_runner_accepted"]
            and row["host_audit"]["eligible"]
            and row["mapped_description_gate"]
            and row["final_chrome_anchor"]
        )
    except Exception as error:
        row = {
            "variant": name,
            "profile": profile,
            "mode": mode,
            "repeat": repeat,
            "qualified": False,
            "error": repr(error),
            "traceback": traceback.format_exc(),
        }
    finally:
        runner.core.close_active_children()
    row["source_and_binary_unchanged_after_reap"] = (
        runner.fingerprint({"apps": apps}) == frozen
    )
    row["qualified"] = (
        row["qualified"] and row["source_and_binary_unchanged_after_reap"]
    )
    row["performance_eligible"] = row["qualified"] and fault is None
    (directory / "result.json").write_text(json.dumps(row, indent=2) + "\n")
    return row


def run_controls(apps, frozen):
    baseline_pixels = None
    for profile in PROFILES:
        for label, fault in (
            ("positive", None),
            ("suppressed-complete", {"TODO_TEST_SUPPRESS_COMPLETE": "1"}),
            ("stale-marker", {"TODO_TEST_STALE_MARKER": "1"}),
        ):
            STATUS.update(
                state="controls", current={"profile": profile, "control": label}
            )
            save_status()
            case = OUTPUT / f"control-{profile}-{label}"
            row = execute_cell(profile, "busy", 0, case, apps, frozen, fault)
            if label == "positive":
                passed = row["qualified"]
                initial = screenshot(row, "-initial.ppm")
                if initial:
                    pixels = read_ppm(initial)
                    if baseline_pixels is None:
                        baseline_pixels = pixels
                    deltas = [
                        abs(left - right)
                        for left, right in zip(baseline_pixels, pixels)
                    ]
                    row["initial_static_pixel_comparison"] = {
                        "reference": "original profile positive-control initial client drawable",
                        "changed_channels": sum(delta != 0 for delta in deltas),
                        "maximum_channel_delta": max(deltas),
                        "initial_chrome_anchor": chrome_anchor(initial),
                        "diagnostic_only": True,
                    }
            elif label == "suppressed-complete":
                passed = (
                    not row.get("original_runner_accepted")
                    and row.get("ordered_callbacks_matched") is False
                    and row.get("drawable_work_acknowledged") is False
                )
            else:
                passed = (
                    not row.get("original_runner_accepted")
                    and row.get("full_model_matched") is True
                    and row.get("ordered_callbacks_matched") is True
                    and row.get("drawable_work_acknowledged") is False
                )
            row.update(control=label, control_passed=passed, performance_eligible=False)
            (case / "result.json").write_text(json.dumps(row, indent=2) + "\n")
            with (OUTPUT / "controls.jsonl").open("a") as stream:
                stream.write(json.dumps(row) + "\n")
            result = {
                "profile": profile,
                "control": label,
                "passed": passed,
                "error": row.get("error"),
            }
            STATUS["completed_controls"].append(result)
            save_status()
            print(json.dumps(result), flush=True)
    assert all(
        item["passed"] for item in STATUS["completed_controls"]
    ), "Native control qualification failed."


def run_trials(apps, frozen):
    orders = (PROFILES, tuple(reversed(PROFILES)), ("certified", "original", "banked4"))
    schedule = []
    for repeat, order in enumerate(orders, start=1):
        modes = ("busy", "animation") if repeat % 2 else ("animation", "busy")
        for mode in modes:
            for profile in order:
                schedule.append({"profile": profile, "mode": mode, "repeat": repeat})
    (OUTPUT / "schedule.json").write_text(json.dumps(schedule, indent=2) + "\n")
    for index, cell in enumerate(schedule):
        STATUS.update(state="trials", current=cell)
        save_status()
        case = OUTPUT / f"{index:02}-{cell['profile']}-{cell['mode']}-r{cell['repeat']}"
        row = execute_cell(
            cell["profile"], cell["mode"], cell["repeat"], case, apps, frozen
        )
        with (OUTPUT / "results.jsonl").open("a") as stream:
            stream.write(json.dumps(row) + "\n")
        result = {**cell, "qualified": row["qualified"], "error": row.get("error")}
        STATUS["completed_trials"].append(result)
        save_status()
        print(json.dumps(result), flush=True)


def main():
    OUTPUT.mkdir(exist_ok=False)
    save_status()
    os.environ.update(
        DISPLAY=":292",
        XDG_RUNTIME_DIR=str(TASK / "runtime/five-app"),
        TODO_X11_LIBRARY="/nix/store/rck9w8gj3r2w2z1xpw15g1fvpzi8iz9h-libx11-1.8.13/lib/libX11.so.6",
    )
    with (TASK / "host.lock").open("a+") as lease:
        fcntl.flock(lease, fcntl.LOCK_EX)
        assert not runner.active_builds()
        apps = app_configurations()
        frozen = runner.fingerprint({"apps": apps})
        for name, app in apps.items():
            receipt = json.loads(Path(app["build_receipt"]).read_text())
            assert (
                receipt["successful"]
                and frozen[name]["source"] == receipt["source_after"]
            )
            assert frozen[name]["binary"] == receipt["binary_sha256"]
        historical = runner.mandatory_historical_audit(
            TASK / "evidence/five-app/historical/results-20261023.jsonl"
        )
        old_controls = json.loads(
            (TASK / "evidence/mapped-todo/replayed-controls-v1/status.json").read_text()
        )
        assert old_controls["all_controls_passed"]
        manifest = {
            "apps": apps,
            "freeze": frozen,
            "historical_audit": historical,
            "unchanged_replayed_native_present_control": old_controls,
            "core_pin": "0062bf589829c4f28807ad0fde3e13285379294c",
            "fixture_commit": "739c074f1dbd07d35d976fb64cd33a9c15030051",
        }
        (OUTPUT / "manifest.json").write_text(json.dumps(manifest, indent=2) + "\n")
        harness = {
            str(path): runner.core.file_sha256(path)
            for path in (
                RUNNER / "run.py",
                RUNNER / "todo_core.py",
                RUNNER / "presentation_audit.py",
                Path(__file__),
            )
        }
        (OUTPUT / "harness-freeze.json").write_text(
            json.dumps(harness, indent=2) + "\n"
        )
        xvfb = subprocess.Popen(
            [
                "/nix/store/iw8dx6lhrkdc5wzszjzqzl677y68y88r-xvfb-21.1.24/bin/Xvfb",
                ":292",
                "-screen",
                "0",
                "1280x1024x24",
                "-nolisten",
                "tcp",
            ],
            stdout=(OUTPUT / "xvfb.log").open("wb"),
            stderr=subprocess.STDOUT,
            start_new_session=True,
        )
        try:
            time.sleep(1)
            run_controls(apps, frozen)
            run_trials(apps, frozen)
            STATUS.update(
                state="complete",
                source_and_binary_unchanged=runner.fingerprint({"apps": apps})
                == frozen,
                harness_unchanged=all(
                    runner.core.file_sha256(Path(path)) == value
                    for path, value in harness.items()
                ),
                all_trials_qualified=all(
                    item["qualified"] for item in STATUS["completed_trials"]
                ),
            )
        finally:
            runner.core.close_active_children()
            if xvfb.poll() is None:
                os.killpg(xvfb.pid, signal.SIGTERM)
                xvfb.wait(timeout=10)


if __name__ == "__main__":
    for signum in (signal.SIGINT, signal.SIGTERM, signal.SIGALRM):
        signal.signal(signum, interrupted)
    signal.alarm(900)
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
        if OUTPUT.exists():
            save_status()
