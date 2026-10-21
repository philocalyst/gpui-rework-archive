#!/usr/bin/env python3
"""Run the combined experiment gates and save exact commands/output, failing closed."""

import json
import pathlib
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
    ("native-check", ["cargo", "check", *MANIFEST, "--locked", "-p",
                      "gpui_reactivity_host", "--features", "x11,wayland"]),
    ("layout-example", ["cargo", "run", *MANIFEST, "--locked", "-p",
                        "gpui_reactivity_core", "--features", "layout",
                        "--example", "retained_layout"]),
    ("format", ["cargo", "fmt", *MANIFEST, *format_packages, "--check"]),
]

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
    report.append(entry)
    (EVIDENCE / "checks.json").write_text(json.dumps(report, indent=2) + "\n")
    print(json.dumps(entry), flush=True)
    if result.returncode:
        print(result.stdout[-7000:], flush=True)
        raise SystemExit(result.returncode)
