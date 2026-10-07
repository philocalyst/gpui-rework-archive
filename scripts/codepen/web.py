#!/usr/bin/env python3
"""Run the local compiler companion and the GPUI WASM guide together."""
import os
import json
from pathlib import Path
import shutil
import signal
import socket
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[2]
TOOLCHAIN = "nightly-2026-09-30"

def main():
    if not shutil.which("trunk"):
        raise SystemExit("Install Trunk: cargo install --locked trunk")
    subprocess.run(["cargo", "build", "-p", "gpui_ce_codepen", "--bin", "gpui-codepen-server"], cwd=ROOT, check=True)
    metadata = json.loads(subprocess.check_output(["cargo", "metadata", "--no-deps", "--format-version", "1"], cwd=ROOT))
    server_path = Path(metadata["target_directory"]) / "debug" / ("gpui-codepen-server.exe" if os.name == "nt" else "gpui-codepen-server")
    sysroot = Path(subprocess.check_output(["rustup", "run", TOOLCHAIN, "rustc", "--print", "sysroot"], text=True).strip())
    env = os.environ.copy()
    env["PATH"] = os.pathsep.join([str(sysroot / "bin"), env["PATH"]])
    env["RUSTC"] = str(sysroot / "bin/rustc")
    env["RUSTDOC"] = str(sysroot / "bin/rustdoc")
    env.pop("NO_COLOR", None) # Trunk's clap parser requires a bool, unlike Cargo.
    # Keep browser artifacts separate from native dev builds, which may use a
    # different compiler. Both processes stay loopback-only.
    env["CARGO_TARGET_DIR"] = metadata["target_directory"] if "CARGO_TARGET_DIR" in os.environ else str(ROOT / "target/codepen-web")
    # Choose an available companion port without disturbing other local tools.
    with socket.socket() as probe:
        probe.bind(("127.0.0.1", 0))
        port = probe.getsockname()[1]
    server_env = os.environ.copy()
    server_env["GPUI_CODEPEN_PORT"] = str(port)
    server = subprocess.Popen([server_path], cwd=ROOT, env=server_env)
    preview = None
    def stop(*_):
        if preview is not None: preview.terminate()
        server.terminate()
    signal.signal(signal.SIGTERM, stop)
    try:
        web = ROOT / "crates/gpui_codepen/web"
        config = (web / "Trunk.toml").read_text()
        config = config.replace('target = "index.html"', 'target = ' + json.dumps(str(web / "index.html")))
        config = config.replace('dist = "dist"', 'dist = ' + json.dumps(str(web / "dist")))
        config = config.replace('http://127.0.0.1:8092/api/', f'http://127.0.0.1:{port}/api/')
        with tempfile.TemporaryDirectory(prefix="gpui-codepen-web-") as temporary:
            config_path = Path(temporary) / "Trunk.toml"
            config_path.write_text(config)
            preview = subprocess.Popen(["trunk", "serve", "--config", config_path, "--cargo-profile", "codepen-web", "--minify", "false", "--watch", ROOT / "crates", "--ignore", web / "dist"], cwd=ROOT, env=env)
            print("Open http://127.0.0.1:8080 — Ctrl+C stops both services.", flush=True)
            while preview.poll() is None:
                if server.poll() is not None:
                    raise SystemExit("Compiler companion stopped. See its diagnostics above.")
                try: preview.wait(timeout=1)
                except subprocess.TimeoutExpired: pass
    except KeyboardInterrupt:
        pass
    finally:
        stop()
        if preview is not None: preview.wait()
        server.wait()

if __name__ == "__main__":
    main()
