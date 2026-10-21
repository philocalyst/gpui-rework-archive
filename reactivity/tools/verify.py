#!/usr/bin/env python3
"""Run portable implementation/lab gates and record commands/output, failing closed.

Native surface and Vulkan readback gates are explicit opt-ins requiring their
drivers/display. Their absence never produces a passing graphics result.
"""

import argparse
import json
import os
import pathlib
import re
import subprocess
import time

REPO = pathlib.Path(__file__).resolve().parents[2]
EVIDENCE = REPO / "reactivity/evidence"
MANIFEST = ["--manifest-path", "reactivity/Cargo.toml"]
PACKAGES = (
    "gpui_reactivity_core", "gpui_reactivity_state", "gpui_reactivity_host",
    "gpui_reactivity_algebra_lab", "gpui_reactivity_template_lab",
    "gpui_reactivity_coverage_lab", "gpui_reactivity_ownership_lab",
    "reactivity-api-lab",
    "gpui", "gpui_gpu", "gpui_canvas", "gpui_retained", "gpui_presenter_tests",
)
format_packages = [arg for package in PACKAGES for arg in ("-p", package)]
checks = [
    ("workspace-debug", ["cargo", "test", *MANIFEST, "--locked", "--workspace",
                         "--features", "gpui_reactivity_core/layout"]),
    ("workspace-clippy", ["cargo", "clippy", *MANIFEST, "--locked", "--workspace",
                          "--all-targets", "--features", "gpui_reactivity_core/layout",
                          "--", "-D", "warnings"]),
    ("workspace-release", ["cargo", "test", "--release", *MANIFEST, "--locked",
                           "--workspace", "--features", "gpui_reactivity_core/layout"]),
    ("loom", ["cargo", "test", "--release", *MANIFEST, "--locked", "-p",
              "gpui_reactivity_ownership_lab", "--features", "loom",
              "--test", "loom_protocol"]),
    ("question-credit", ["cargo", "test", "--release", *MANIFEST, "--locked", "-p",
                         "gpui_reactivity_ownership_lab", "--features", "loom",
                         "--test", "question_credit"]),
    ("question-mailbox", ["cargo", "test", "--release", *MANIFEST, "--locked", "-p",
                          "gpui_reactivity_ownership_lab", "--features", "loom",
                          "--test", "question_mailbox"]),
    ("native-check", ["cargo", "check", *MANIFEST, "--locked", "-p",
                      "gpui", "--features", "x11,wayland", "--all-targets"]),
    ("native-minimal-check", ["cargo", "check", *MANIFEST, "--locked", "-p",
                              "gpui", "--features", "x11-minimal,wayland-minimal", "--all-targets"]),
    ("native-clippy", ["cargo", "clippy", *MANIFEST, "--locked", "-p", "gpui",
                       "--features", "x11,wayland", "--all-targets", "--", "-D", "warnings"]),
    ("accessibility-schema", ["cargo", "test", *MANIFEST, "--locked", "-p", "gpui",
                              "--features", "x11,wayland", "--lib", "native::accessibility::"]),
    ("parallel-canvas", ["cargo", "test", *MANIFEST, "--locked", "-p",
                         "gpui_canvas", "--features", "parallel"]),
    ("layout-example", ["cargo", "run", *MANIFEST, "--locked", "-p",
                        "gpui_reactivity_core", "--features", "layout",
                        "--example", "retained_layout"]),
    ("format", ["cargo", "fmt", *MANIFEST, *format_packages, "--check"]),
]

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument("--vulkan", action="store_true", help="require actual Vulkan readback conformance")
parser.add_argument("--native-x11", action="store_true", help="require actual X11 native port/lifecycle execution")
parser.add_argument("--native-atspi", action="store_true", help="require actual AT-SPI client and absent-bus native execution")
parser.add_argument("--atspi-launcher", default=os.environ.get("GPUI_AT_SPI_LAUNCHER"),
                    help="executable at-spi-bus-launcher path for --native-atspi")
args = parser.parse_args()
if args.vulkan:
    checks.append(("gpu-vulkan", ["cargo", "test", *MANIFEST, "--locked", "-p",
                                 "gpui_gpu", "--features", "vulkan-tests", "--test", "render"]))
if args.native_x11:
    checks.append(("native-x11", ["cargo", "test", *MANIFEST, "--locked", "-p", "gpui",
                                 "--features", "x11", "native_todo_port", "--", "--ignored",
                                 "--nocapture", "--test-threads=1"]))
    checks.append(("native-remote", ["cargo", "test", *MANIFEST, "--locked", "-p", "gpui",
                                    "--features", "x11", "native_remote_results", "--", "--ignored",
                                    "--nocapture", "--test-threads=1"]))
    checks.append(("native-question", ["cargo", "test", *MANIFEST, "--locked", "-p", "gpui",
                                      "--features", "x11", "--lib",
                                      "native_question_result_and_credit_wake_without_unrelated_input",
                                      "--", "--ignored", "--nocapture", "--test-threads=1"]))
    checks.append(("native-library", ["cargo", "test", *MANIFEST, "--locked", "-p", "gpui",
                                     "--features", "x11", "native_library_250k", "--", "--ignored",
                                     "--nocapture", "--test-threads=1"]))
if args.native_atspi:
    if not args.atspi_launcher or not os.access(args.atspi_launcher, os.X_OK):
        parser.error("--native-atspi requires an executable --atspi-launcher or GPUI_AT_SPI_LAUNCHER")
    checks.append(("native-atspi", ["bash", "reactivity/tools/test_atspi.sh",
                                    str(pathlib.Path(args.atspi_launcher).resolve())]))
    checks.append(("native-no-bus", ["env", "DBUS_SESSION_BUS_ADDRESS=unix:path=/tmp/gpui-no-session-bus",
                                     "cargo", "test", *MANIFEST, "--locked", "-p", "gpui",
                                     "--features", "x11", "--lib",
                                     "native::accessibility::linux_tests::native_accessible_profile_without_session_bus_still_presents",
                                     "--", "--ignored", "--exact", "--nocapture"]))

EVIDENCE.mkdir(exist_ok=True)
report = []
for name, command in checks:
    print(f"Checking {name}", flush=True)
    start = time.monotonic()
    result = subprocess.run(command, cwd=REPO, stdout=subprocess.PIPE,
                            stderr=subprocess.STDOUT, text=True)
    log = "\n".join(line.rstrip() for line in result.stdout.splitlines()).rstrip()
    (EVIDENCE / f"{name}.txt").write_text(log + "\n" if log else "")
    entry = {"check": name, "argv": command, "exit_code": result.returncode,
             "elapsed_seconds": round(time.monotonic() - start, 3),
             "log": f"{name}.txt"}
    if name in ("gpu-vulkan", "native-x11", "native-remote", "native-question", "native-library", "question-credit", "question-mailbox",
                "native-atspi", "native-no-bus", "accessibility-schema"):
        entry["passed_tests"] = sum(int(count) for count in re.findall(
            r"test result: ok\. (\d+) passed;", log))
        if result.returncode == 0 and entry["passed_tests"] == 0:
            entry["exit_code"] = 1
            entry["failure"] = "The requested execution gate ran no tests."
    report.append(entry)
    (EVIDENCE / "checks.json").write_text(json.dumps(report, indent=2) + "\n")
    print(json.dumps(entry), flush=True)
    if entry["exit_code"]:
        print(result.stdout[-7000:], flush=True)
        raise SystemExit(entry["exit_code"])
