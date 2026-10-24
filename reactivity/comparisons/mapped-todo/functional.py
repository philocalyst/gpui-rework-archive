#!/usr/bin/env python3
"""Full Heavy native input, coherent-paint, and mapped-fixture negative controls."""

import ctypes, datetime, fcntl, json, math, os, signal, subprocess, sys, time, traceback
from pathlib import Path

T = Path(os.environ.get("TODO_TASK_ROOT", "/home/miles/gpui-ce3-compute-20261024"))
D = T / "evidence/mapped-todo"
sys.path.insert(0, str(T / "src/mapped-todo-runner"))
import run as r
from presentation_audit import audit_animation

out = D / "functional-v1"
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
    DISPLAY=":284",
    XDG_RUNTIME_DIR=str(T / "runtime/five-app"),
    TODO_X11_LIBRARY="/nix/store/rck9w8gj3r2w2z1xpw15g1fvpzi8iz9h-libx11-1.8.13/lib/libX11.so.6",
)
x = None
manifest = json.loads((T / "evidence/five-app/manifest.json").read_text())
r.core.XDOTOOL = manifest["xdotool"]
app = json.loads((D / "preflight-v2/app.json").read_text())
r.core.EXPECTED_WINDOW_TITLES["gpui-mapped"] = app["title"]
original_wait = r.core.wait_first_present


def command(*args):
    return (
        subprocess.run(
            [r.core.XDOTOOL, *map(str, args)],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        ).returncode
        == 0
    )


def environment(mode, policy):
    env = r.core.comparison_environment()
    env.update(app["environment"])
    env.update(
        TODO_BENCH_MODE=mode,
        TODO_BENCH_ROWS="10000" if mode == "heavy" else "1000",
        TODO_BENCH_ANIMATE="1" if mode == "animation" else "0",
        TODO_BENCH_TICK_HZ="60",
        TODO_BENCH_PRESENT_MARKER="1",
        TODO_BENCH_PRESENT_TRACE="1",
        TODO_BENCH_RENDERER=policy,
        TODO_BENCH_SECONDS="120",
    )
    return env


def coherent_pixels(draw, w):
    im = draw.x.XGetImage(draw.display, w, 0, 0, 540, 620, ctypes.c_ulong(-1).value, 2)
    if not im:
        raise RuntimeError("coherent XGetImage failed")
    try:
        a = im.contents
        assert a.bits_per_pixel == 32 and a.byte_order == 0
        raw = ctypes.string_at(a.data, a.bytes_per_line * a.height)

        def rgb(x, y):
            p = raw[y * a.bytes_per_line + x * 4 : y * a.bytes_per_line + x * 4 + 3]
            return (p[2], p[1], p[0])

        encoded = 0
        valid = True
        for bit in range(32):
            p = rgb(476 + bit % 8 * 7 + 2, 18 + bit // 8 * 7 + 2)
            if min(p) >= 224:
                encoded |= 1 << bit
            elif max(p) > 31:
                valid = False
        valid = valid and encoded.bit_count() % 2 == 0
        revision = encoded & 0x7FFFFFFF

        def button(y):
            return all(abs(a - b) <= 6 for a, b in zip(rgb(30, y), (226, 232, 240)))

        gaps = [
            y
            for y in range(146, 185)
            if button(y - 1) and not button(y) and not button(y + 1)
        ]
        observed = gaps[0] if len(gaps) == 1 else None
        expected = 165.792 + 12 * math.sin(revision / 60 * math.tau)
        return {
            "marker_valid": valid,
            "revision": revision,
            "observed_first_row_bottom": observed,
            "expected_bottom_if_no_scheduler_skips": expected,
            "phase_error_pixels": (
                abs(observed - expected) if observed is not None else None
            ),
            "heading_dark_pixels": sum(
                max(rgb(x, y)) < 180 for y in range(24, 62) for x in range(24, 115)
            ),
            "nonblack": any(raw),
        }
    finally:
        draw.x.XDestroyImage(im)


try:
    with (T / "host.lock").open("a+") as lease:
        fcntl.flock(lease, fcntl.LOCK_EX)
        if r.active_builds():
            raise RuntimeError("builds active")
        frozen = r.fingerprint({"apps": {"mapped": app}})
        (out / "freeze.json").write_text(json.dumps(frozen, indent=2))
        x = subprocess.Popen(
            [
                "/nix/store/iw8dx6lhrkdc5wzszjzqzl677y68y88r-xvfb-21.1.24/bin/Xvfb",
                ":284",
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
        heavy = []
        for policy in ("gpu", "auto"):
            status.update(state="slow-full-heavy", policy=policy)
            save()
            case = out / f"heavy-{policy}"
            case.mkdir()
            draw = r.Drawable()
            child = None
            record = {"policy": policy, "actions": [], "performance_eligible": False}
            try:
                child = r.core.Child(
                    Path(app["binary"]), environment("heavy", policy), case / "app.log"
                )
                r.core.wait_first_present(child)
                w, *_ = r.core.wait_window(child.proc.pid, app["title"])
                child.window_id = w
                assert command("windowfocus", "--sync", w)
                time.sleep(5)
                draw.save(w, case / "settled.ppm")
                record["settled_ui"] = coherent_pixels(draw, w)
                assert record["settled_ui"]["heading_dark_pixels"] >= 40
                callbacks = 0
                for slot, kind in enumerate(r.core.BUSY_MACRO):
                    assert command(
                        "mousemove",
                        "--sync",
                        "--window",
                        w,
                        *app["controls"]["input" if kind == "type" else kind],
                    )
                    time.sleep(0.05)
                    if kind == "type":
                        assert command("click", "1")
                        time.sleep(0.05)
                    region = (
                        (24, 82, 280, 42)
                        if kind in ("type", "add")
                        else (
                            (24, 500, 300, 38)
                            if kind in ("active", "done", "all")
                            else (24, 128, 492, 360)
                        )
                    )
                    before = draw.digest(w, region)
                    before_marker = draw.marker(w)
                    draw.save(w, case / f"{slot}-{kind}-before.ppm")
                    started = time.monotonic()
                    injected = (
                        command("type", "--clearmodifiers", "--delay", "1", "bench-000")
                        if kind == "type"
                        else command("click", "1")
                    )
                    callbacks += int(kind != "type")
                    deadline = started + 12
                    while True:
                        after = draw.digest(w, region)
                        m = draw.marker(w)
                        events = [
                            json.loads(l.split(",", 1)[1])
                            for l in child.log_lines()
                            if l.startswith("TODO_ACTION,")
                        ]
                        ok = (
                            injected
                            and before != after
                            and m.get("valid")
                            and m["revision"] == callbacks
                            and len(events) == callbacks
                            and (kind == "type" or events[-1]["action"] == kind)
                        )
                        if ok or time.monotonic() >= deadline:
                            break
                        time.sleep(0.02)
                    draw.save(w, case / f"{slot}-{kind}-after.ppm")
                    record["actions"].append(
                        {
                            "action": kind,
                            "passed": ok,
                            "elapsed_seconds_diagnostic": time.monotonic() - started,
                            "region": region,
                            "before": before,
                            "after": after,
                            "marker_before": before_marker,
                            "marker_after": m,
                            "callbacks": events,
                        }
                    )
                    assert ok, kind
                child.close_window(w)
                record.update(r.semantic_receipts(case / "app.log", "heavy", 2))
                record["qualified"] = (
                    record["full_model_matched"]
                    and record["ordered_callbacks_matched"]
                    and child.graceful_close
                )
            except BaseException as error:
                record.update(
                    qualified=False, error=repr(error), traceback=traceback.format_exc()
                )
            finally:
                r.core.close_active_children()
                draw.close()
            (case / "result.json").write_text(json.dumps(record, indent=2) + "\n")
            heavy.append(
                {
                    "policy": policy,
                    "qualified": record["qualified"],
                    "error": record.get("error"),
                }
            )
            status["heavy"] = heavy
            save()
            print("Heavy", json.dumps(heavy[-1]), flush=True)
        paint = []
        for policy in ("gpu", "auto"):
            status.update(state="coherent-animation-paint", policy=policy)
            save()
            case = out / f"paint-{policy}"
            case.mkdir()
            draw = r.Drawable()
            record = {"policy": policy, "samples": [], "performance_eligible": False}
            try:
                child = r.core.Child(
                    Path(app["binary"]),
                    environment("animation", policy),
                    case / "app.log",
                )
                r.core.wait_first_present(child)
                w, *_ = r.core.wait_window(child.proc.pid, app["title"])
                child.window_id = w
                time.sleep(1)
                for i in range(24):
                    sample = coherent_pixels(draw, w)
                    sample["monotonic_ns"] = time.monotonic_ns()
                    record["samples"].append(sample)
                    draw.save(w, case / f"{i:02}.ppm")
                    time.sleep(0.071)
                child.close_window(w)
                logs = child.log_lines()
                worker = [
                    json.loads(l.split(",", 1)[1])
                    for l in logs
                    if l.startswith("TODO_ANIMATION,")
                ][0]
                record["worker"] = worker
                record["revisions_distinct"] = len(
                    {s["revision"] for s in record["samples"]}
                )
                bottoms = [
                    s["observed_first_row_bottom"]
                    for s in record["samples"]
                    if s["observed_first_row_bottom"] is not None
                ]
                record["observed_translation_range"] = (
                    max(bottoms) - min(bottoms) if bottoms else 0
                )
                record["phase_correlation_applicable"] = worker["skipped"] == 0
                record["phase_matches"] = (
                    all(
                        s["phase_error_pixels"] is not None
                        and s["phase_error_pixels"] <= 2
                        for s in record["samples"]
                    )
                    if record["phase_correlation_applicable"]
                    else None
                )
                record["qualified"] = (
                    child.graceful_close
                    and all(
                        s["marker_valid"]
                        and s["heading_dark_pixels"] >= 40
                        and s["observed_first_row_bottom"] is not None
                        for s in record["samples"]
                    )
                    and record["revisions_distinct"] >= 12
                    and record["observed_translation_range"] >= 18
                    and (record["phase_matches"] is True if policy == "auto" else True)
                )
                record.update(r.semantic_receipts(case / "app.log", "animation", 0))
            except BaseException as error:
                record.update(
                    qualified=False, error=repr(error), traceback=traceback.format_exc()
                )
            finally:
                r.core.close_active_children()
                draw.close()
            (case / "result.json").write_text(json.dumps(record, indent=2) + "\n")
            paint.append(
                {
                    "policy": policy,
                    "qualified": record["qualified"],
                    "phase_matches": record.get("phase_matches"),
                    "observed_translation_range": record.get(
                        "observed_translation_range"
                    ),
                    "error": record.get("error"),
                }
            )
            status["paint"] = paint
            save()
            print("Paint", json.dumps(paint[-1]), flush=True)
        cases = []
        r.core.wait_first_present = lambda child, timeout=90: original_wait(child, 10)
        for name, mode, fault in [
            ("positive", "busy", {}),
            ("suppressed-complete", "busy", {"TODO_TEST_SUPPRESS_COMPLETE": "1"}),
            ("stale-marker", "busy", {"TODO_TEST_STALE_MARKER": "1"}),
            ("duplicate-ticks", "animation", {"TODO_TEST_DUPLICATE_TICKS": "1"}),
            ("observer-overflow", "animation", {"TODO_TEST_OBSERVER_CAP": "1"}),
            (
                "missing-first-receipt",
                "idle",
                {"TODO_TEST_SUPPRESS_FIRST_RECEIPT": "1"},
            ),
        ]:
            status.update(state="mapped-specific-negative-controls", case=name)
            save()
            case = out / name
            case.mkdir()
            a = {**app, "environment": {**app["environment"], **fault}}
            try:
                row = r.run_cell("gpui-mapped", a, mode, 1, case, 2, 0)
                row.update(
                    variant="gpui-mapped",
                    mode=mode,
                    repeat=1,
                    source_and_binary_unchanged=r.fingerprint({"apps": {"mapped": app}})
                    == frozen,
                    performance_eligible=False,
                )
                row["original_runner_accepted"] = r.accepted(row)
                row["host_audit"] = audit_animation(row)
            except BaseException as error:
                row = {
                    "original_runner_accepted": False,
                    "error": repr(error),
                    "traceback": traceback.format_exc(),
                    "performance_eligible": False,
                }
            gate = {
                "positive": row.get("original_runner_accepted") is True,
                "suppressed-complete": row.get("ordered_callbacks_matched") is False
                and row.get("drawable_work_acknowledged") is False,
                "stale-marker": row.get("full_model_matched") is True
                and row.get("ordered_callbacks_matched") is True
                and row.get("drawable_work_acknowledged") is False,
                "duplicate-ticks": row.get("animation_delivery_matches") is False,
                "observer-overflow": row.get("present_observer_overflow", 0) > 0,
                "missing-first-receipt": "first successful present marker not observed"
                in row.get("error", ""),
            }[name]
            row["control_passed"] = gate and (
                name == "positive" or not row["original_runner_accepted"]
            )
            (case / "result.json").write_text(json.dumps(row, indent=2) + "\n")
            cases.append(
                {
                    "case": name,
                    "control_passed": row["control_passed"],
                    "error": row.get("error"),
                }
            )
            status["negative_controls"] = cases
            save()
            print("Control", json.dumps(cases[-1]), flush=True)
        status.update(
            state="complete",
            all_functional_qualification_passed=all(
                c["qualified"] for c in heavy + paint
            )
            and all(c["control_passed"] for c in cases),
            source_and_binary_unchanged=r.fingerprint({"apps": {"mapped": app}})
            == frozen,
        )
except BaseException as error:
    status.update(state="failed", error=repr(error), traceback=traceback.format_exc())
finally:
    r.core.wait_first_present = original_wait
    r.core.close_active_children()
    if x and x.poll() is None:
        os.killpg(x.pid, signal.SIGTERM)
        x.wait(timeout=10)
    status["completed_utc"] = datetime.datetime.now(datetime.timezone.utc).isoformat()
    save()
