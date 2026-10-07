#!/usr/bin/env python3
"""Build the checked-in Miri driver with its matching rustc, and warm its sysroot."""
import os
import json
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parents[2]
TOOLCHAIN = "nightly-2026-09-30"
EXE = ".exe" if sys.platform == "win32" else ""

def run(args, **kwargs):
    print("+", " ".join(map(str, args)), flush=True)
    return subprocess.run(list(map(str, args)), check=True, **kwargs)

def main():
    if not shutil.which("rustup"):
        raise SystemExit("Install rustup (https://rustup.rs), then run this script again.")
    # Do not change the user's default toolchain or install custom global binaries.
    run(["rustup", "toolchain", "install", TOOLCHAIN, "--no-self-update", "--profile", "minimal",
         "--component", "rust-src,rustc-dev,llvm-tools-preview"])
    sysroot = Path(subprocess.check_output(["rustup", "run", TOOLCHAIN, "rustc", "--print", "sysroot"], text=True).strip())
    env = os.environ.copy()
    env["RUSTC"] = str(sysroot / f"bin/rustc{EXE}")
    env["RUSTDOC"] = str(sysroot / f"bin/rustdoc{EXE}")
    env["RUSTFLAGS"] = f"-L native={sysroot / 'lib'} -C rpath=yes"
    env.pop("CARGO_ENCODED_RUSTFLAGS", None)
    env.pop("RUSTC_WRAPPER", None)
    cargo = ["rustup", "run", TOOLCHAIN, "cargo"]
    run(cargo + ["build", "--release", "--locked", "--manifest-path", ROOT / "vendor/miri/Cargo.toml", "--no-default-features", "--features", "stack-cache"], env=env, cwd=ROOT)
    run(cargo + ["build", "--locked", "--manifest-path", ROOT / "vendor/miri/cargo-miri/Cargo.toml"], env=env, cwd=ROOT)
    # Fetch only the fixed SDK dependencies. Per-edit builds use --offline.
    run(cargo + ["fetch", "--locked", "--manifest-path", ROOT / "Cargo.toml"], env=env, cwd=ROOT)
    env["MIRI"] = str(ROOT / f"vendor/miri/target/release/miri{EXE}")
    env["PATH"] = os.pathsep.join([str(ROOT / "vendor/miri/cargo-miri/target/debug"), str(sysroot / "bin"), str(sysroot / "lib"), env["PATH"]])
    run(cargo + ["miri", "setup"], env=env, cwd=ROOT)
    # Compile the fixed SDK once into the same cache used by component workers.
    # This keeps the first lesson from spending seconds rebuilding serde.
    env["CARGO_TARGET_DIR"] = str(ROOT / "target/codepen-miri")
    env["RUSTFLAGS"] = "-Cdebug-assertions=no -Awarnings"
    env["MIRIFLAGS"] = "-Zmiri-ignore-leaks -Zmiri-disable-leak-backtraces -Zmiri-disable-validation -Zmiri-disable-stacked-borrows -Zmiri-disable-data-race-detector -Zmiri-disable-alignment-check -Zmiri-disable-isolation"
    with tempfile.TemporaryDirectory(prefix="gpui-codepen-warmup-") as temporary:
        warmup = Path(temporary)
        sdk = ROOT / "crates/gpui_codepen/guest"
        (warmup / "Cargo.toml").write_text('[workspace]\n[package]\nname="codepen_warmup"\nversion="0.0.0"\nedition="2024"\n[dependencies]\ngpui_codepen_guest={path=' + json.dumps(str(sdk)) + '}\n[[bin]]\nname="codepen_warmup"\npath="warmup.rs"\n[profile.dev]\ndebug=0\n')
        shutil.copy2(sdk / "Cargo.lock", warmup / "Cargo.lock")
        (warmup / "warmup.rs").write_text('fn main() { use gpui_codepen_guest::*; let _ = wire::encode(&Frame { version: PROTOCOL_VERSION, root: div().child("ready").into(), state: json!(null) }); }')
        run(cargo + ["miri", "run", "--offline", "--quiet"], env=env, cwd=warmup)
    print("Ready. Run: cargo run -p gpui_ce_codepen --bin gpui-guide")

if __name__ == "__main__":
    main()
