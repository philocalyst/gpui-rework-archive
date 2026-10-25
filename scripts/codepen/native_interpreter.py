#!/usr/bin/env python3
"""Build Miri with the same interpreter caches used by the browser runtime.

Only the interpreter is rebuilt. The pinned rustc_driver retains its upstream
CTFE providers, query types and cancellation handler. All outputs are local to
target/ and the vendored Miri build directory.
"""
import hashlib
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys
import tarfile
import tempfile
import urllib.request

ROOT = Path(__file__).resolve().parents[2]
TOOLCHAIN = "nightly-2026-09-30"
REVISION = "5c543b0b8c73c7b72bc8284ced4fb22ead15734d"
SOURCE_HASH = "3522f62a0a3d0c5cf667c867802f7e2340ab9d7ac22887f11d9e8070846724f7"
CRATE = "gpui_codepen_const_eval"
EXE = ".exe" if os.name == "nt" else ""


def run(args, **kwargs):
    print("+", " ".join(map(str, args)), flush=True)
    return subprocess.run(list(map(str, args)), check=True, **kwargs)


def toolchain():
    sysroot = Path(subprocess.check_output(
        ["rustup", "run", TOOLCHAIN, "rustc", "--print", "sysroot"], text=True).strip())
    version = subprocess.check_output([sysroot / ("bin/rustc" + EXE), "-vV"], text=True)
    fields = dict(line.split(": ", 1) for line in version.splitlines() if ": " in line)
    if fields.get("commit-hash") != REVISION:
        raise SystemExit("The native interpreter requires the exact pinned rustc commit")
    return sysroot, fields["host"]


def one_artifact(directory, pattern):
    matches = list(directory.glob(pattern))
    if len(matches) != 1:
        raise SystemExit(f"Expected one rustc-dev artifact {pattern} under {directory}; run setup.py")
    return matches[0]


def interpreter(sysroot, host):
    # Hash the exact native-relevant base patch, rather than unrelated compiler
    # paging changes. No previously generated target/ source is a build input.
    base = (ROOT / "scripts/codepen/browser-rustc.patch").read_text()
    base = "".join(section for section in re.split(r"(?=^--- a/)", base, flags=re.M)
                   if section.startswith("--- a/compiler/rustc_const_eval/"))
    patch = (ROOT / "scripts/codepen/browser-interpreter.patch").read_bytes()
    float_source = (ROOT / "scripts/codepen/browser-float.rs").read_bytes()
    flags = ["-Copt-level=3", "-Cdebug-assertions=no", "-Cpanic=unwind"]
    hostlib = sysroot / "lib/rustlib" / host / "lib"
    suffix = "dll" if os.name == "nt" else "dylib" if sys.platform == "darwin" else "so"
    metadata = sorted([*hostlib.glob("*.rmeta"), *hostlib.glob(f"*rustc_macros-*.{suffix}")])
    if not metadata:
        raise SystemExit("Pinned rustc-dev metadata is missing; run setup.py")
    metadata_hashes = [(path.name, hashlib.sha256(path.read_bytes()).hexdigest()) for path in metadata]
    inputs = [REVISION.encode(), SOURCE_HASH.encode(), host.encode(), base.encode(), patch,
              float_source, Path(__file__).read_bytes(), "\n".join(flags).encode(),
              json.dumps(metadata_hashes, separators=(",", ":")).encode()]
    key = hashlib.sha256(b"\0".join(inputs)).hexdigest()[:24]
    output = ROOT / "target/codepen-native-interpreter" / key
    artifact = output / f"lib{CRATE}.rlib"
    stamp = output / "complete.json"
    if artifact.is_file() and stamp.is_file():
        try:
            saved = json.loads(stamp.read_text())
            if hashlib.sha256(artifact.read_bytes()).hexdigest() == saved["artifact_sha256"]:
                return artifact
        except (OSError, ValueError, KeyError, TypeError):
            pass  # An interrupted/damaged cache entry is rebuilt from source.
    if not shutil.which("patch"):
        raise SystemExit("Building the native interpreter requires the patch utility (GNU or BSD patch)")
    archive = ROOT / f"target/codepen-rustc-source-{REVISION}-{SOURCE_HASH[:12]}.tar.gz"
    archive.parent.mkdir(parents=True, exist_ok=True)
    if archive.exists() and hashlib.sha256(archive.read_bytes()).hexdigest() != SOURCE_HASH:
        archive.unlink()  # A damaged generated cache is downloaded again below.
    if not archive.exists():
        previous = ROOT / "target/browser-rustc-source.tar.gz"
        with tempfile.NamedTemporaryFile(dir=archive.parent, delete=False) as download:
            temporary_archive = Path(download.name)
        try:
            if previous.is_file() and hashlib.sha256(previous.read_bytes()).hexdigest() == SOURCE_HASH:
                shutil.copyfile(previous, temporary_archive)
            else:
                urllib.request.urlretrieve(f"https://codeload.github.com/rust-lang/rust/tar.gz/{REVISION}", temporary_archive)
            if hashlib.sha256(temporary_archive.read_bytes()).hexdigest() != SOURCE_HASH:
                raise SystemExit("Pinned Rust source archive checksum differs")
            temporary_archive.replace(archive)
        finally:
            temporary_archive.unlink(missing_ok=True)
    if hashlib.sha256(archive.read_bytes()).hexdigest() != SOURCE_HASH:
        raise SystemExit("Pinned Rust source archive checksum differs")
    output.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix="source-", dir=output) as temporary:
        stage = Path(temporary)
        with tarfile.open(archive) as tar:
            prefix = tar.getmembers()[0].name.split("/")[0] + "/"
            for member in tar.getmembers():
                name = member.name.removeprefix(prefix)
                if name.startswith("compiler/rustc_const_eval/") and member.isfile():
                    destination = stage / name
                    destination.parent.mkdir(parents=True, exist_ok=True)
                    destination.write_bytes(tar.extractfile(member).read())
        for number, content in enumerate((base.encode(), patch)):
            filename = stage / f"interpreter-{number}.patch"
            filename.write_bytes(content)
            run(["patch", "--batch", "-p1", "-i", filename], cwd=stage)
        crate = stage / "compiler/rustc_const_eval"
        (crate / "src/interpret/codepen_float.rs").write_bytes(float_source)
        source = crate / "src/lib.rs"
        # rustc's own build sets this feature globally. A standalone crate must
        # opt into loading the installed rustc-private metadata explicitly.
        source.write_text("#![feature(rustc_private)]\n" + source.read_text())
        staged_artifact = stage / artifact.name
        command = [sysroot / ("bin/rustc" + EXE), "--crate-name", CRATE, "--edition=2024",
                   source, "--crate-type=rlib", "-o", staged_artifact, f"-Cmetadata=codepen_{key}",
                   "--remap-path-prefix", str(stage) + "=/gpui-codepen/rustc/" + REVISION,
                   *flags, "-L", "dependency=" + str(hostlib), "-L", "native=" + str(sysroot / "lib"),
                   "--check-cfg", "cfg(bootstrap)", "--check-cfg", 'cfg(feature,values("codepen-cache-profile"))']
        dependencies = (crate / "Cargo.toml").read_text().split("[dependencies]", 1)[1].split("[features]", 1)[0]
        for name in sorted(set(re.findall(r"^([a-z0-9_]+)\s*=", dependencies, re.M))):
            pattern = (f"*{name}-*.{suffix}" if name == "rustc_macros" else f"lib{name}-*.rmeta")
            dependency = one_artifact(hostlib, pattern)
            command += ["--extern", name + "=" + str(dependency)]
        run(command, cwd=stage)
        staged_artifact.replace(artifact)
    with tempfile.NamedTemporaryFile(mode="w", dir=output, delete=False) as pending:
        json.dump({"revision": REVISION, "host": host, "key": key,
                   "metadata": metadata_hashes,
                   "artifact_sha256": hashlib.sha256(artifact.read_bytes()).hexdigest()}, pending, indent=2)
        pending.write("\n")
    Path(pending.name).replace(stamp)
    return artifact


def build_miri(env=None):
    sysroot, host = toolchain()
    artifact = interpreter(sysroot, host)
    wrapper_source = ROOT / "scripts/codepen/native-rustc-wrapper.rs"
    wrapper_key = hashlib.sha256(wrapper_source.read_bytes() + REVISION.encode() + host.encode()).hexdigest()[:20]
    wrapper = ROOT / "target/codepen-native-interpreter" / ("rustc-wrapper-" + wrapper_key + EXE)
    if not wrapper.exists():
        run([sysroot / ("bin/rustc" + EXE), wrapper_source, "--edition=2024", "-O", "-o", wrapper])
    # Wrapper/externs belong only to this build. setup.py's Cargo-Miri/sysroot/
    # SDK builds receive their original environment and pinned rustc unchanged.
    env = dict(os.environ if env is None else env)
    env.pop("RUSTFLAGS", None)
    env.update(RUSTC=str(sysroot / ("bin/rustc" + EXE)), RUSTDOC=str(sysroot / ("bin/rustdoc" + EXE)),
               CARGO_ENCODED_RUSTFLAGS="\x1f".join(["-L", "native=" + str(sysroot / "lib"), "-C", "rpath=yes"]),
               RUSTC_WRAPPER=str(wrapper),
               CODEPEN_INTERPRETER_SEARCH="dependency=" + str(artifact.parent),
               CODEPEN_INTERPRETER_EXTERN="rustc_const_eval=" + str(artifact),
               CODEPEN_DRIVER_CONST_EVAL_EXTERN="codepen_rustc_const_eval_original=" + str(one_artifact(
                   sysroot / "lib/rustlib" / host / "lib", "librustc_const_eval-*.rmeta")))
    env.pop("RUSTC_WORKSPACE_WRAPPER", None)
    env["CARGO_TARGET_DIR"] = str(artifact.parent / ("miri-" + wrapper_key))
    run([sysroot / ("bin/cargo" + EXE), "build", "--release", "--locked", "--manifest-path",
         ROOT / "vendor/miri/Cargo.toml", "--no-default-features", "--features", "stack-cache"], env=env, cwd=ROOT)
    binary = Path(env["CARGO_TARGET_DIR"]) / ("release/miri" + EXE)
    destination = ROOT / "vendor/miri/target/release" / ("miri" + EXE)
    destination.parent.mkdir(parents=True, exist_ok=True)
    temporary = destination.with_suffix(".new" + EXE)
    shutil.copy2(binary, temporary)
    temporary.replace(destination)
    return destination


if __name__ == "__main__":
    print(build_miri())
