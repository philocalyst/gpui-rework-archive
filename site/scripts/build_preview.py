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


def digest_inputs() -> str:
    h = hashlib.sha256()
    for path in sorted(EXAMPLES.rglob("*.rs")) + [EXAMPLES / "Cargo.toml", EXAMPLES / "Cargo.lock"]:
        if "target" in path.parts:
            continue
        h.update(str(path.relative_to(ROOT)).encode())
        h.update(path.read_bytes())
    return h.hexdigest()


def file_digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest() if path.exists() else "missing"


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


def main() -> int:
    OUT.parent.mkdir(parents=True, exist_ok=True)
    digest = digest_inputs()
    if (OUT.parent / "build.json").exists():
        try:
            if json.loads((OUT.parent / "build.json").read_text()).get("digest") == digest:
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
    entry = next((path.name for path in entries if path.name.endswith("_bg.js") is False), entries[0].name if entries else "")
    (OUT.parent / "build.json").write_text(json.dumps({
        "digest": digest,
        "source": str(EXAMPLES),
        "source_digest": digest,
        "workspace_digest": file_digest(ROOT / "Cargo.lock"),
        "lock_digest": file_digest(EXAMPLES / "Cargo.lock"),
        "entry": entry,
    }))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
