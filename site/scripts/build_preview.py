#!/usr/bin/env python3
"""Build the checked-in examples into the local browser preview bundle."""

from __future__ import annotations

import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parents[2]
EXAMPLES = ROOT / "site" / "examples"
OUT = ROOT / "site" / "static" / "preview" / "pkg"


def digest_paths(roots: tuple[Path, ...]) -> str:
    h = hashlib.sha256()
    paths = []
    for root in roots:
        if root.exists():
            paths.extend(path for path in root.rglob("*") if path.is_file() and "target" not in path.parts)
    for path in sorted(paths):
        h.update(str(path.relative_to(ROOT)).encode())
        h.update(path.read_bytes())
    for path in (ROOT / "Cargo.toml", ROOT / "Cargo.lock"):
        if path.is_file():
            h.update(str(path.relative_to(ROOT)).encode())
            h.update(path.read_bytes())
    return h.hexdigest()


def digest_inputs() -> str:
    return digest_paths((ROOT / "crates", EXAMPLES, ROOT / "assets"))


def file_digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest() if path.exists() else "missing"


def copy_runtime() -> None:
    """Publish the full browser runtime, including matching canonical starters."""
    source = ROOT / "target/codepen-browser/miri"
    manifest_path = source / "assets.json"
    if not manifest_path.is_file():
        raise RuntimeError("Browser Miri bundle is missing. Build scripts/codepen/browser.py all --starter-dir site/static/components first.")
    manifest = json.loads(manifest_path.read_text())
    if manifest.get("protocol") != 8:
        raise RuntimeError("Browser Miri frame protocol differs from this preview build.")
    starters = {item["source"] for item in manifest.get("starters", [])}
    for path in sorted((ROOT / "site/static/components").glob("*.rs")):
        if path.read_text() not in starters:
            raise RuntimeError(f"Browser Miri starter is stale: {path.name}. Rebuild the runtime bundle.")
    files = [manifest["module"], *manifest.get("metadata_parts", [manifest["metadata"]]),
             "runtime.js", "worker.js", "bootstrap.js", "wasi-clock.js", "wasi/index.js"]
    if manifest.get("metadata_paging"):
        files.append("metadata-files.js")
        files.extend(chunk for entry in manifest["files"] for chunk in entry.get("chunks", []))
    for name in files:
        path = (source / name).resolve()
        if not path.is_relative_to(source.resolve()) or not path.is_file():
            raise RuntimeError(f"Browser Miri asset is missing or outside its bundle: {name}")
    destination = OUT.parent / "miri"
    fresh = destination.with_name("miri.tmp")
    if fresh.exists():
        shutil.rmtree(fresh)
    shutil.copytree(source, fresh)
    if destination.exists():
        shutil.rmtree(destination)
    fresh.replace(destination)


def rust_toolchain_env() -> dict[str, str]:
    env = os.environ.copy()
    toolchain = env.get("GPUI_DOCS_RUST_TOOLCHAIN")
    if not toolchain:
        for name in ("rust-toolchain.toml", "rust-toolchain"):
            path = ROOT / name
            if path.is_file():
                text = path.read_text()
                toolchain = text.split('channel = "', 1)[1].split('"', 1)[0] if 'channel = "' in text else text.strip()
                break
    toolchain = toolchain or "1.98.1"
    rustup = shutil.which("rustup")
    if rustup and toolchain:
        cargo = subprocess.run([rustup, "which", "cargo", "--toolchain", toolchain], capture_output=True, text=True, check=False)
        rustc = subprocess.run([rustup, "which", "rustc", "--toolchain", toolchain], capture_output=True, text=True, check=False)
        if cargo.returncode == 0 and rustc.returncode == 0:
            env["CARGO"] = cargo.stdout.strip()
            env["RUSTC"] = rustc.stdout.strip()
            rustc_path = Path(env["RUSTC"]).resolve()
            llvm = next((ancestor / "lib" / "libLLVM.dylib" for ancestor in rustc_path.parents if (ancestor / "lib" / "libLLVM.dylib").is_file()), None)
            if llvm is not None:
                env["DYLD_LIBRARY_PATH"] = f'{llvm.parent}:{env.get("DYLD_LIBRARY_PATH", "")}'.rstrip(":")
    return env


def main() -> int:
    OUT.parent.mkdir(parents=True, exist_ok=True)
    copy_runtime()
    digest = digest_inputs()
    metadata_path = OUT.parent / "build.json"
    if metadata_path.exists():
        try:
            metadata = json.loads(metadata_path.read_text())
            entry = metadata.get("entry", "")
            wasm = metadata.get("wasm", "")
            if (metadata.get("digest") == digest and entry and wasm
                    and (OUT / entry).is_file() and (OUT / wasm).is_file()):
                return 0
        except (OSError, ValueError):
            pass
    trunk = shutil.which("trunk")
    if not trunk:
        print("trunk is required to build the checked-in preview", file=sys.stderr)
        return 2
    with tempfile.TemporaryDirectory(prefix="gpui-preview-") as staging:
        command = [trunk, "build", "--release", "--dist", staging, "--public-url", "./"]
        build_env = rust_toolchain_env()
        # Trunk expects NO_COLOR to be a boolean when the variable is present.
        if build_env.get("NO_COLOR") == "1":
            build_env["NO_COLOR"] = "true"
        build_env.setdefault("CARGO_BUILD_JOBS", "4")
        build_env.setdefault("CARGO_PROFILE_RELEASE_LTO", "off")
        build_env.setdefault("CARGO_PROFILE_RELEASE_INCREMENTAL", "true")
        result = subprocess.run(command, cwd=EXAMPLES, env=build_env, check=False)
        if result.returncode:
            return result.returncode
        fresh = OUT.with_name(OUT.name + ".tmp")
        if fresh.exists():
            shutil.rmtree(fresh)
        shutil.copytree(staging, fresh)
        if OUT.exists():
            shutil.rmtree(OUT)
        fresh.replace(OUT)
    entries = sorted(OUT.glob("*.js"))
    entry = next((path.name for path in entries if not path.name.endswith("_bg.js")), entries[0].name if entries else "")
    wasm_entries = sorted(OUT.glob("*.wasm"))
    wasm = wasm_entries[0].name if wasm_entries else ""
    if not entry or not wasm:
        print("Trunk produced no JavaScript/WASM preview artifacts", file=sys.stderr)
        return 3
    (OUT.parent / "build.json").write_text(json.dumps({
        "digest": digest,
        "source": str(EXAMPLES),
        "source_digest": digest_paths((EXAMPLES,)),
        "workspace_digest": digest_paths((ROOT / "crates", ROOT / "assets")),
        "lock_digest": file_digest(ROOT / "Cargo.lock"),
        "entry": entry,
        "wasm": wasm,
    }))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
