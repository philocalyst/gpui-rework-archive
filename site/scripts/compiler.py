#!/usr/bin/env python3
"""Small, local-only compiler service for the interactive GPUI examples.

The service deliberately accepts one request shape and one loopback origin. It is
intended for a developer's browser, not as a general Rust build service.
"""

from __future__ import annotations

import hashlib
import json
import os
from pathlib import Path
import secrets
import shutil
import signal
import subprocess
import tempfile
import threading
import time
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from urllib.parse import unquote, urlparse

ROOT = Path(__file__).resolve().parents[2]
EXAMPLES = ROOT / "site" / "examples"
PREVIEW = ROOT / "static" / "preview"
BUILDS = PREVIEW / "builds"
HOST = os.environ.get("GPUI_DOCS_COMPILER_HOST", "127.0.0.1")
PORT = int(os.environ.get("GPUI_DOCS_COMPILER_PORT", "1117"))
SITE_PORT = int(os.environ.get("GPUI_DOCS_SITE_PORT", "1111"))
MAX_SOURCE = 64 * 1024
MAX_RESPONSE = 64 * 1024
TOKEN = secrets.token_urlsafe(24)
VERSION = "1"
BUILD_LOCK = threading.Lock()


def _loopback(value: str) -> bool:
    return value in {"localhost", "127.0.0.1", "[::1]", "::1"}


def allowed_origin(value: str | None) -> bool:
    if not value:
        return False
    parsed = urlparse(value)
    return parsed.scheme in {"http", "https"} and _loopback(parsed.hostname or "") and parsed.port in {None, SITE_PORT}


def request_ok(handler: BaseHTTPRequestHandler) -> bool:
    origin = handler.headers.get("Origin")
    host = handler.headers.get("Host", "").split(":", 1)[0]
    return _loopback(host) and (origin is None or allowed_origin(origin))


def workspace_digest(source: str) -> str:
    digest = hashlib.sha256()
    digest.update(source.encode())
    for path in sorted((ROOT / "crates").rglob("*.rs")):
        digest.update(str(path.relative_to(ROOT)).encode())
        digest.update(path.read_bytes())
    for path in (ROOT / "Cargo.lock", EXAMPLES / "Cargo.toml", EXAMPLES / "Cargo.lock"):
        if path.exists():
            digest.update(str(path.relative_to(ROOT)).encode())
            digest.update(path.read_bytes())
    return digest.hexdigest()


def file_digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest() if path.exists() else "missing"


def workspace_source_digest() -> str:
    digest = hashlib.sha256()
    for path in sorted((ROOT / "crates").rglob("*.rs")):
        digest.update(str(path.relative_to(ROOT)).encode())
        digest.update(path.read_bytes())
    return digest.hexdigest()


def bounded_run(command: list[str], cwd: Path, timeout: float = 180.0, env: dict[str, str] | None = None) -> tuple[int, str]:
    """Run without shell interpolation, bounding output and killing descendants."""
    with tempfile.TemporaryFile(mode="w+b") as output_file:
        process = subprocess.Popen(command, cwd=cwd, stdout=output_file, stderr=subprocess.STDOUT, start_new_session=True, env=env)
        def output() -> str:
            output_file.seek(max(0, output_file.seek(0, 2) - MAX_RESPONSE))
            return output_file.read(MAX_RESPONSE).decode(errors="replace")
        try:
            process.wait(timeout=timeout)
        except subprocess.TimeoutExpired:
            os.killpg(process.pid, signal.SIGKILL)
            process.wait()
            return 124, output() + "\nprocess timed out"
        return process.returncode, output()


def compiler_command() -> str:
    return os.environ.get("GPUI_DOCS_RUST", "cargo")


def rust_toolchain_env() -> dict[str, str]:
    env = os.environ.copy()
    toolchain = env.get("GPUI_DOCS_RUST_TOOLCHAIN", "1.98.1")
    rustup = shutil.which("rustup")
    if rustup:
        cargo = subprocess.run([rustup, "which", "cargo", "--toolchain", toolchain], capture_output=True, text=True, check=False)
        rustc = subprocess.run([rustup, "which", "rustc", "--toolchain", toolchain], capture_output=True, text=True, check=False)
        if cargo.returncode == 0 and rustc.returncode == 0:
            env["CARGO"] = cargo.stdout.strip()
            env["RUSTC"] = rustc.stdout.strip()
    return env


def compile_source(source: str) -> dict[str, object]:
    if len(source.encode()) > MAX_SOURCE:
        return {"ok": False, "error": "source exceeds 64 KiB"}
    digest = workspace_digest(source)
    out = BUILDS / digest
    marker = out / "build.json"
    if marker.exists() and any(out.glob("*.wasm")):
        return {"ok": True, "digest": digest, "url": f"/preview/builds/{digest}/index.html"}
    with BUILD_LOCK:
        if marker.exists() and any(out.glob("*.wasm")):
            return {"ok": True, "digest": digest, "url": f"/preview/builds/{digest}/index.html"}
        out.parent.mkdir(parents=True, exist_ok=True)
        with tempfile.TemporaryDirectory(prefix="gpui-doc-compile-") as temp:
            project = Path(temp)
            (project / "src").mkdir()
            (project / "src/main.rs").write_text(source)
            (project / "Cargo.toml").write_text(
                f'''[package]\nname = "gpui-preview"\nversion = "0.0.0"\nedition = "2024"\n[dependencies]\n'''
                f'''gpui = {{ package = "gpui-ce", path = "{ROOT / 'crates/gpui'}", default-features = false }}\n'''
                f'''gpui_web = {{ package = "gpui_ce_web", path = "{ROOT / 'crates/gpui_web'}", default-features = false }}\n'''
                "wasm-bindgen = \"0.2\"\n"
                "web-sys = { version = \"0.3\", features = [\"Window\", \"Location\", \"console\"] }\n"
            )
            env = rust_toolchain_env()
            env["CARGO_TARGET_DIR"] = str(project / "target")
            code, output = bounded_run(
                [env.get("CARGO", compiler_command()), "build", "--release", "--target", "wasm32-unknown-unknown", "--manifest-path", str(project / "Cargo.toml")],
                project,
                env=env,
            )
            if code:
                return {"ok": False, "digest": digest, "diagnostics": output}
            wasm = project / "target/wasm32-unknown-unknown/release/gpui-preview.wasm"
            bindgen = os.environ.get("WASM_BINDGEN", shutil.which("wasm-bindgen"))
            if not bindgen:
                return {"ok": False, "digest": digest, "diagnostics": output + "\nwasm-bindgen executable not found"}
            staged = project / "pkg"
            code, bind_output = bounded_run([bindgen, str(wasm), "--target", "web", "--out-dir", str(staged)], project, env=env)
            if code:
                return {"ok": False, "digest": digest, "diagnostics": bind_output}
            tmp_out = out.with_name(out.name + ".tmp")
            if tmp_out.exists():
                shutil.rmtree(tmp_out)
            shutil.copytree(staged, tmp_out)
            (tmp_out / "index.html").write_text('<script type="module">import init from "./gpui_preview.js"; init();</script>')
            (tmp_out / "build.json").write_text(json.dumps({
                "digest": digest,
                "source_bytes": len(source.encode()),
                "source_digest": hashlib.sha256(source.encode()).hexdigest(),
                "workspace_digest": workspace_source_digest(),
                "lock_digest": file_digest(EXAMPLES / "Cargo.lock"),
                "created": time.time(),
            }))
            tmp_out.replace(out)
    return {"ok": True, "digest": digest, "url": f"/preview/builds/{digest}/index.html"}


class Handler(BaseHTTPRequestHandler):
    server_version = "gpui-docs-compiler/1"

    def _json(self, status: int, value: dict[str, object]) -> None:
        data = json.dumps(value).encode()
        if len(data) > MAX_RESPONSE:
            data = b'{"ok":false,"error":"response exceeds 64 KiB"}'
            status = 500
        self.send_response(status)
        self.send_header("Content-Type", "application/json")
        origin = self.headers.get("Origin")
        if origin and allowed_origin(origin):
            self.send_header("Access-Control-Allow-Origin", origin)
            self.send_header("Vary", "Origin")
        self.send_header("Content-Length", str(len(data)))
        self.end_headers()
        self.wfile.write(data)

    def do_OPTIONS(self) -> None:
        if not request_ok(self):
            self._json(403, {"ok": False, "error": "loopback origin required"})
            return
        self.send_response(204)
        self.send_header("Access-Control-Allow-Origin", self.headers.get("Origin", ""))
        self.send_header("Access-Control-Allow-Headers", "Content-Type, X-GPUI-Compiler-Token")
        self.send_header("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
        self.end_headers()

    def do_GET(self) -> None:
        if not request_ok(self):
            self._json(404, {"ok": False, "error": "not found"})
            return
        if self.path == "/health":
            self._json(200, {"ok": True, "ready": True, "token": TOKEN, "version": VERSION})
            return
        prefix = "/preview/builds/"
        if self.path.startswith(prefix):
            relative = unquote(self.path[len(prefix):])
            candidate = (BUILDS / relative).resolve()
            if candidate.is_file() and BUILDS.resolve() in candidate.parents:
                data = candidate.read_bytes()
                if len(data) > MAX_RESPONSE * 16:
                    self.send_error(413, "artifact too large")
                    return
                mime = {".wasm": "application/wasm", ".js": "text/javascript", ".html": "text/html", ".json": "application/json"}.get(candidate.suffix, "application/octet-stream")
                self.send_response(200)
                self.send_header("Content-Type", mime)
                self.send_header("Content-Length", str(len(data)))
                self.end_headers()
                self.wfile.write(data)
                return
        self._json(404, {"ok": False, "error": "not found"})

    def do_POST(self) -> None:
        if self.path != "/compile" or not request_ok(self):
            self._json(403, {"ok": False, "error": "loopback origin required"})
            return
        if self.headers.get("X-GPUI-Compiler-Token") != TOKEN:
            self._json(403, {"ok": False, "error": "invalid compiler token"})
            return
        try:
            length = int(self.headers.get("Content-Length", "-1"))
            if length < 0 or length > MAX_SOURCE + 4096:
                raise ValueError("request exceeds 64 KiB")
            body = json.loads(self.rfile.read(length))
            source = body["source"]
            if not isinstance(source, str):
                raise ValueError("source must be a string")
            result = compile_source(source)
            self._json(200 if result.get("ok") else 422, result)
        except (ValueError, KeyError, json.JSONDecodeError) as error:
            self._json(400, {"ok": False, "error": str(error)})

    def log_message(self, *_args: object) -> None:
        return


def main() -> None:
    if not _loopback(HOST):
        raise SystemExit("compiler host must be loopback")
    BUILDS.mkdir(parents=True, exist_ok=True)
    server = ThreadingHTTPServer((HOST, PORT), Handler)
    print(f"compiler listening on http://{HOST}:{PORT}", flush=True)
    server.serve_forever()


if __name__ == "__main__":
    main()
