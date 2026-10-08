#!/usr/bin/env python3
"""Serve the checked documentation artifact, Miri workbench, and live reload."""

from __future__ import annotations

import argparse
import hashlib
import http.client
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
import os
import json
from pathlib import Path
import re
import shutil
import signal
import subprocess
import sys
import threading
import time
from urllib.parse import urlsplit
from workbench import start as start_workbench

ROOT = Path(__file__).resolve().parents[2]
PUBLIC = ROOT / "site/public"
STAGING = ROOT / "target/documentation-dev-build"

RELOAD_SCRIPT = """<script>(async()=>{let previous;for(;;){try{const response=await fetch('/documentation-build.json',{cache:'no-store'});if(response.ok){const build=await response.json();if(previous&&build.source_digest!==previous)location.reload();previous=build.source_digest}}catch(_){}await new Promise(resolve=>setTimeout(resolve,1000))}})()</script>"""


class DocumentationHandler(SimpleHTTPRequestHandler):
    workbench_address = None

    def __init__(self, *args, directory=PUBLIC, **kwargs):
        super().__init__(*args, directory=str(directory), **kwargs)

    def do_GET(self):
        if urlsplit(self.path).path == "/api/workbench":
            data = json.dumps({"backend": "miri" if self.workbench_address else None}).encode()
            self.send_response(200 if self.workbench_address else 503)
            self.send_header("Content-Type", "application/json")
            self.send_header("Cache-Control", "no-store")
            self.send_header("Content-Length", str(len(data)))
            self.end_headers()
            self.wfile.write(data)
            return
        path = Path(self.translate_path(urlsplit(self.path).path))
        if path.is_dir():
            path /= "index.html"
        if path.is_file() and path.suffix == ".html":
            data = path.read_bytes().replace(b"</body>", (RELOAD_SCRIPT + "</body>").encode(), 1)
            self.send_response(200)
            self.send_header("Content-Type", "text/html; charset=utf-8")
            self.send_header("Cache-Control", "no-store")
            self.send_header("Content-Length", str(len(data)))
            self.end_headers()
            self.wfile.write(data)
            return
        super().do_GET()

    def do_POST(self):
        route = urlsplit(self.path).path
        if route not in {"/api/render", "/api/cancel"}:
            self.send_error(404)
            return
        port = self.server.server_port
        hosts = {f"127.0.0.1:{port}", f"localhost:{port}"}
        origins = {"http://" + host for host in hosts}
        if self.headers.get("Host") not in hosts or self.headers.get("Origin") not in origins | {None}:
            self.send_error(403, "Use this server's localhost URL.")
            return
        if not self.workbench_address:
            self.send_error(503, "The Miri companion is not running.")
            return
        if self.headers.get("Content-Type") != "application/json":
            self.send_error(415, "application/json required")
            return
        try:
            length = int(self.headers.get("Content-Length", "-1"))
        except ValueError:
            length = -1
        if not 0 <= length <= 512 * 1024:
            self.send_error(413, "Request exceeds the workbench limit.")
            return
        connection = http.client.HTTPConnection(*self.workbench_address, timeout=600)
        try:
            headers = {"Content-Type": "application/json"}
            for name in ("Origin", "Accept"):
                if self.headers.get(name):
                    headers[name] = self.headers[name]
            connection.request("POST", route, self.rfile.read(length), headers)
            response = connection.getresponse()
            # Frame bytes plus the binary envelope and bounded diagnostics.
            max_reply = 64 * 1024 * 1024 + 64 * 1024 + 32
            data = response.read(max_reply + 1)
            if len(data) > max_reply:
                raise ValueError("Miri response exceeds the frame limit")
            self.send_response(response.status)
            self.send_header("Content-Type", response.getheader("Content-Type", "application/octet-stream"))
            self.send_header("Cache-Control", "no-store")
            self.send_header("Content-Length", str(len(data)))
            self.end_headers()
            self.wfile.write(data)
        except (OSError, http.client.HTTPException, ValueError) as error:
            if not isinstance(error, BrokenPipeError):
                self.send_error(502, f"Miri companion unavailable: {error}")
        finally:
            connection.close()

    def log_message(self, *_args):
        pass


def source_snapshot():
    """Ignore generated chapters and includes; watch changes to their inputs."""
    directories = [ROOT / "book", ROOT / "site/content", ROOT / "site/examples", ROOT / "site/templates", ROOT / "site/editor",
                   ROOT / "site/scripts", ROOT / "scripts/docs", ROOT / "scripts/codepen", ROOT / "crates", ROOT / "assets",
                   ROOT / "vendor/miri/src", ROOT / "vendor/miri/cargo-miri/src"]
    files = {ROOT / "Cargo.toml", ROOT / "Cargo.lock", ROOT / "site/examples.toml", ROOT / "site/zola.toml", ROOT / "site/package.json", ROOT / "site/package-lock.json",
             ROOT / "vendor/miri/Cargo.toml", ROOT / "vendor/miri/Cargo.lock",
             ROOT / "vendor/miri/cargo-miri/Cargo.toml", ROOT / "vendor/miri/cargo-miri/Cargo.lock"}
    files.update(path for directory in directories for path in directory.rglob("*") if path.is_file())
    # Also watch authored front-end files, without compiler/preview output.
    files.update(path for path in (ROOT / "site/static").rglob("*") if path.is_file()
                 and "pkg" not in path.parts and "builds" not in path.parts and path.name != "build.json"
                 and not path.is_relative_to(ROOT / "site/static/workbench"))
    snapshot = {}
    for path in files:
        if not path.is_file():
            continue
        relative = path.relative_to(ROOT)
        if any(part in {"target", "__pycache__", ".live"} for part in relative.parts):
            continue
        if str(relative) == "site/static/api-examples.json":
            continue
        if str(relative) == "site/examples/src/components.rs":
            continue
        if str(relative).startswith(("site/content/examples/", "site/content/sources/", "site/static/examples/", "site/static/components/")) and path.name != "_index.md":
            continue
        if "/src/docs/examples/" in "/" + str(relative):
            continue
        if path.suffix == ".rs":
            # sync_links owns these bounded attributes; their input is already watched.
            source = re.sub(r"// docs:examples:begin.*?// docs:examples:end", "", path.read_text(), flags=re.S)
            snapshot[path] = hashlib.sha256(source.encode()).digest()
        else:
            snapshot[path] = path.stat().st_mtime_ns
    return snapshot


def stop_workbench(companion):
    if companion is not None and companion.poll() is None:
        os.killpg(companion.pid, signal.SIGTERM)
        try:
            companion.wait(timeout=5)
        except subprocess.TimeoutExpired:
            os.killpg(companion.pid, signal.SIGKILL)
            companion.wait()


def rebuild(env, base):
    for script in ("scripts/docs/generate.py", "scripts/docs/sync_links.py"):
        result = subprocess.run([sys.executable, str(ROOT / script)], cwd=ROOT, env=env)
        if result.returncode:
            return False
    result = subprocess.run([sys.executable, str(ROOT / "site/scripts/build.py"), "--with-api",
                             "--base-url", base, "--output-dir", str(STAGING)], cwd=ROOT, env=env)
    if result.returncode:
        print("Documentation rebuild failed; keeping the last checked artifact.", file=sys.stderr)
        return False
    backup = ROOT / "target/documentation-dev-previous"
    if backup.exists():
        shutil.rmtree(backup)
    if PUBLIC.exists():
        PUBLIC.replace(backup)
    STAGING.replace(PUBLIC)
    if backup.exists():
        shutil.rmtree(backup)
    return True


def restart_workbench(companion, env, port):
    try:
        replacement, address = start_workbench(env, port)
    except (subprocess.CalledProcessError, RuntimeError, OSError) as error:
        print(f"Miri rebuild failed; keeping the running workbench: {error}", file=sys.stderr)
        return companion
    DocumentationHandler.workbench_address = address
    stop_workbench(companion)
    return replacement


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--native-companion", action="store_true",
                        help="also start the native Miri development service; not browser-only execution")
    args = parser.parse_args()
    env = os.environ.copy()
    port = int(env.get("GPUI_DOCS_SITE_PORT", "1111"))
    base = f"http://127.0.0.1:{port}"
    if not rebuild(env, base):
        return 1
    server = ThreadingHTTPServer(("127.0.0.1", port), DocumentationHandler)
    companion = None
    server_thread = threading.Thread(target=server.serve_forever, daemon=True)
    server_thread.start()
    print(f"Documentation and checkout API: {base}", flush=True)
    previous = source_snapshot()
    try:
        if args.native_companion:
            companion, DocumentationHandler.workbench_address = start_workbench(env, port)
            print("Native Miri companion ready (development only).", flush=True)
        while True:
            if companion is not None and companion.poll() is not None:
                print("The native Miri companion stopped.", file=sys.stderr)
                return companion.returncode or 1
            time.sleep(0.35)
            current = source_snapshot()
            if current == previous:
                continue
            time.sleep(0.3)
            inputs = source_snapshot()
            if rebuild(env, base):
                changed = {path for path in inputs.keys() | previous.keys() if inputs.get(path) != previous.get(path)}
                runtime_roots = (ROOT / "crates", ROOT / "vendor", ROOT / "scripts/codepen")
                if args.native_companion and any(path.is_relative_to(directory) for path in changed for directory in runtime_roots):
                    companion = restart_workbench(companion, env, port)
            # If an author saved during the build, the next loop rebuilds again.
            previous = inputs
    except KeyboardInterrupt:
        return 130
    finally:
        server.shutdown()
        server.server_close()
        DocumentationHandler.workbench_address = None
        stop_workbench(companion)


if __name__ == "__main__":
    raise SystemExit(main())
