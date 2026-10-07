#!/usr/bin/env python3
"""Start the real-GPUI Miri companion used by the documentation workbench."""
from __future__ import annotations

import os
from pathlib import Path
import socket
import subprocess
import sys
import time

ROOT = Path(__file__).resolve().parents[2]
TOOLCHAIN = "nightly-2026-09-30"


def start(env: dict[str, str], site_port: int):
    env = env.copy()
    env.setdefault("GPUI_CODEPEN_MIR_OPT_LEVEL", "2")
    root = Path(env.get("GPUI_DOCS_MIRI_ROOT", ROOT)).resolve()
    setup = root / "scripts/codepen/setup.py"
    if not setup.is_file():
        raise RuntimeError("The real-GPUI Miri workbench prerequisites are missing from this checkout.")
    driver = root / "vendor/miri/target/release/miri"
    if not driver.is_file():
        subprocess.run([sys.executable, str(setup)], cwd=root, env=env, check=True)
    service_env = env.copy()
    service_env["GPUI_CODEPEN_ALLOWED_ORIGINS"] = f"http://127.0.0.1:{site_port},http://localhost:{site_port}"
    target = root / "target/documentation-miri-host"
    service_env["CARGO_TARGET_DIR"] = str(target)
    subprocess.run(["cargo", "build", "--locked", "-p", "gpui_ce_codepen", "--bin", "gpui-codepen-server"],
                   cwd=root, env=service_env, check=True)
    with socket.socket() as probe:
        probe.bind(("127.0.0.1", 0))
        port = probe.getsockname()[1]
    service_env["GPUI_CODEPEN_PORT"] = str(port)
    process = subprocess.Popen([str(target / "debug/gpui-codepen-server")], cwd=root,
                               env=service_env, start_new_session=True)
    deadline = time.monotonic() + 15
    while time.monotonic() < deadline:
        if process.poll() is not None:
            raise RuntimeError("The Miri companion stopped during startup.")
        try:
            with socket.create_connection(("127.0.0.1", port), timeout=.2):
                return process, ("127.0.0.1", port)
        except OSError:
            time.sleep(.1)
    process.terminate()
    process.wait(timeout=5)
    raise RuntimeError("The Miri companion did not begin listening.")
