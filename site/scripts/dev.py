#!/usr/bin/env python3
"""Run the local compiler, generator, and Zola server as one process tree."""

from __future__ import annotations

import os
from pathlib import Path
import signal
import subprocess
import sys
import time

ROOT = Path(__file__).resolve().parents[2]


def spawn(command: list[str], cwd: Path, env: dict[str, str]) -> subprocess.Popen[bytes]:
    return subprocess.Popen(command, cwd=cwd, env=env, start_new_session=True)


def stop(process: subprocess.Popen[bytes]) -> None:
    if process.poll() is None:
        try:
            os.killpg(process.pid, signal.SIGTERM)
            process.wait(timeout=5)
        except (ProcessLookupError, subprocess.TimeoutExpired):
            try:
                os.killpg(process.pid, signal.SIGKILL)
            except ProcessLookupError:
                pass


def source_snapshot() -> dict[Path, int]:
    roots = [ROOT / "site" / "content", ROOT / "site" / "examples" / "src", ROOT / "site" / "templates"]
    return {
        path: path.stat().st_mtime_ns
        for root in roots
        for path in root.rglob("*")
        if path.is_file() and "target" not in path.parts
    }


def watch_generator(env: dict[str, str], stop_event: object) -> None:
    previous = source_snapshot()
    while not getattr(stop_event, "is_set")():
        time.sleep(0.35)
        current = source_snapshot()
        if current == previous:
            continue
        previous = current
        # Debounce editor save bursts before asking the generator to rewrite files.
        time.sleep(0.25)
        subprocess.run([sys.executable, str(ROOT / "site/scripts/generate.py")], cwd=ROOT, env=env, check=False)


def main() -> int:
    env = os.environ.copy()
    env.setdefault("GPUI_DOCS_SITE_PORT", "1111")
    env.setdefault("GPUI_DOCS_COMPILER_PORT", "1117")
    processes: list[subprocess.Popen[bytes]] = []
    import threading
    stop_event = threading.Event()
    try:
        preview = subprocess.run([sys.executable, str(ROOT / "site/scripts/build_preview.py")], cwd=ROOT, env=env)
        if preview.returncode:
            return preview.returncode
        result = subprocess.run([sys.executable, str(ROOT / "site/scripts/generate.py")], cwd=ROOT, env=env, check=False)
        if result.returncode:
            return result.returncode
        compiler = spawn([sys.executable, str(ROOT / "site/scripts/compiler.py")], ROOT, env)
        processes.append(compiler)
        zola = spawn(["zola", "serve", "--interface", "127.0.0.1", "--port", env["GPUI_DOCS_SITE_PORT"], str(ROOT / "site")], ROOT, env)
        processes.append(zola)
        watcher = threading.Thread(target=watch_generator, args=(env, stop_event), daemon=True)
        watcher.start()
        while True:
            for process in processes:
                if process.poll() is not None:
                    return process.returncode or 1
            time.sleep(0.25)
    except KeyboardInterrupt:
        return 130
    finally:
        stop_event.set()
        for process in reversed(processes):
            stop(process)


if __name__ == "__main__":
    raise SystemExit(main())
