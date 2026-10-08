#!/usr/bin/env python3
"""Serve the GPUI guide with its full browser-local Rust compiler and Miri."""
import argparse
import html
import json
import os
from pathlib import Path
import shutil
import signal
import socket
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parents[2]
TOOLCHAIN = "nightly-2026-09-30"


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--build-runtime", action="store_true", help="Build and bundle the pinned WASM compiler first")
    parser.add_argument("--native-companion", action="store_true", help="Explicit native compiler development mode")
    args = parser.parse_args()
    if not shutil.which("trunk"):
        raise SystemExit("Install Trunk: cargo install --locked trunk")
    if args.build_runtime:
        subprocess.run([sys.executable, ROOT / "scripts/codepen/browser.py", "all"], cwd=ROOT, check=True)
    bundle = ROOT / "target/codepen-browser/miri"
    if not args.native_companion and not (bundle / "assets.json").is_file():
        raise SystemExit("Browser compiler bundle is missing. Run python3 scripts/codepen/browser.py all (requires the native Miri setup and current GPUI metadata).")
    metadata = json.loads(subprocess.check_output(["cargo", "metadata", "--no-deps", "--format-version", "1"], cwd=ROOT))
    sysroot = Path(subprocess.check_output(["rustup", "run", TOOLCHAIN, "rustc", "--print", "sysroot"], text=True).strip())
    env = os.environ.copy()
    env["PATH"] = os.pathsep.join([str(sysroot / "bin"), env["PATH"]])
    env["RUSTC"] = str(sysroot / "bin/rustc")
    env["RUSTDOC"] = str(sysroot / "bin/rustdoc")
    env.pop("NO_COLOR", None)  # Trunk requires a bool rather than Cargo's empty value.
    env["CARGO_TARGET_DIR"] = metadata["target_directory"] if "CARGO_TARGET_DIR" in os.environ else str(ROOT / "target/codepen-web")
    server = preview = None
    port = None
    if args.native_companion:
        subprocess.run(["cargo", "build", "-p", "gpui_ce_codepen", "--bin", "gpui-codepen-server"], cwd=ROOT, check=True)
        server_path = Path(metadata["target_directory"]) / "debug" / ("gpui-codepen-server.exe" if os.name == "nt" else "gpui-codepen-server")
        with socket.socket() as probe:
            probe.bind(("127.0.0.1", 0))
            port = probe.getsockname()[1]
        server_env = os.environ.copy()
        server_env["GPUI_CODEPEN_PORT"] = str(port)
        server = subprocess.Popen([server_path], cwd=ROOT, env=server_env)

    def stop(*_):
        if preview is not None and preview.poll() is None:
            preview.terminate()
        if server is not None and server.poll() is None:
            server.terminate()

    signal.signal(signal.SIGTERM, stop)
    try:
        web = ROOT / "crates/gpui_codepen/web"
        source = (web / "index.html").read_text()
        if args.native_companion:
            source = source.replace(' data-cargo-features="browser-miri"', '')
            source = '\n'.join(line for line in source.splitlines() if 'rel="copy-dir"' not in line and 'src="./miri/' not in line)
        with tempfile.TemporaryDirectory(prefix="gpui-codepen-web-") as temporary:
            temporary = Path(temporary).resolve()
            # Trunk treats asset hrefs as paths relative to the source HTML,
            # including hrefs beginning with '/'. Use actual relative paths.
            cargo_href = html.escape(os.path.relpath(web.parent / "Cargo.toml", temporary), quote=True)
            bundle_href = html.escape(os.path.relpath(bundle, temporary), quote=True)
            source = source.replace('href="../Cargo.toml"', f'href="{cargo_href}"')
            source = source.replace('../../../target/codepen-browser/miri', bundle_href)
            index = temporary / "index.html"
            index.write_text(source)
            config = (web / "Trunk.toml").read_text()
            config = config.replace('target = "index.html"', 'target = ' + json.dumps(str(index)))
            config = config.replace('dist = "dist"', 'dist = ' + json.dumps(str(web / "dist")))
            if server is not None:
                config += f'\n[[proxy]]\nbackend = "http://127.0.0.1:{port}/api/"\n'
            config_path = temporary / "Trunk.toml"
            config_path.write_text(config)
            preview = subprocess.Popen(["trunk", "serve", "--config", config_path, "--cargo-profile", "codepen-web", "--minify", "false", "--watch", ROOT / "crates", "--ignore", web / "dist"], cwd=ROOT, env=env)
            backend = "native compiler development companion" if server else "Rust compiler and Miri entirely in the browser"
            print(f"Open http://127.0.0.1:8080 — {backend}. Ctrl+C stops the preview.", flush=True)
            while preview.poll() is None:
                if server is not None and server.poll() is not None:
                    raise SystemExit("Compiler companion stopped. See its diagnostics above.")
                try:
                    preview.wait(timeout=1)
                except subprocess.TimeoutExpired:
                    pass
            if preview.returncode:
                raise SystemExit(preview.returncode)
    except KeyboardInterrupt:
        pass
    finally:
        stop()
        if preview is not None:
            preview.wait()
        if server is not None:
            server.wait()


if __name__ == "__main__":
    main()
