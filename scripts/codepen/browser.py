#!/usr/bin/env python3
"""Build the pinned Rust compiler and vendored Miri as a browser-local Worker.

The edited source uses ordinary GPUI. This build links the actual GPUI procedural
macros through rustc's proc-macro bridge and its existing Parley text backend.
Generated compiler sources, metadata and binaries stay under target/.
"""
import argparse
import gzip
import hashlib
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys
import tarfile
import urllib.request

ROOT = Path(__file__).resolve().parents[2]
TOOLCHAIN = "nightly-2026-09-30"
REVISION = "5c543b0b8c73c7b72bc8284ced4fb22ead15734d"
VERSION = "1.101.0-nightly (5c543b0b8 2026-09-29)"
SOURCE_HASH = "3522f62a0a3d0c5cf667c867802f7e2340ab9d7ac22887f11d9e8070846724f7"
PAGED_METADATA = os.environ.get("GPUI_CODEPEN_PAGED_METADATA", "1") != "0"
SOURCE = ROOT / "target/browser-rustc-source"
OUTPUT = ROOT / "target/codepen-browser"
MIR_OPT_LEVEL = os.environ.get("GPUI_CODEPEN_MIR_OPT_LEVEL", "2")
if MIR_OPT_LEVEL not in ("0", "1", "2", "3", "4"):
    raise SystemExit("GPUI_CODEPEN_MIR_OPT_LEVEL must be between 0 and 4")
MIRI_FLAGS = "-Zmiri-ignore-leaks -Zmiri-disable-leak-backtraces -Zmiri-disable-validation -Zmiri-disable-stacked-borrows -Zmiri-disable-data-race-detector -Zmiri-disable-alignment-check -Zmiri-disable-isolation -Zmiri-deterministic-floats -Zmiri-provenance-gc=250000 -Zmiri-preemption-rate=0 -Zmiri-address-reuse-rate=0 -Zmiri-compare-exchange-weak-failure-rate=0"


def run(args, **kwargs):
    print("+", " ".join(map(str, args)), flush=True)
    return subprocess.run(list(map(str, args)), check=True, **kwargs)


def toolchain():
    return Path(subprocess.check_output(
        ["rustup", "run", TOOLCHAIN, "rustc", "--print", "sysroot"], text=True
    ).strip())


def native_driver_env():
    env = os.environ.copy()
    sysroot = toolchain()
    env.update(RUSTC=str(sysroot / "bin/rustc"), RUSTDOC=str(sysroot / "bin/rustdoc"),
               CARGO=str(sysroot / "bin/cargo"), MIRI=str(ROOT / "vendor/miri/target/release/miri"))
    env["PATH"] = os.pathsep.join([str(sysroot / "bin"), str(sysroot / "lib"), env["PATH"]])
    variable = "DYLD_LIBRARY_PATH" if os.uname().sysname == "Darwin" else "LD_LIBRARY_PATH"
    env[variable] = os.pathsep.join([str(sysroot / "lib"), env.get(variable, "")])
    return env


def registry_source(name, version):
    matches = list((Path(os.environ.get("CARGO_HOME", str(Path.home() / ".cargo"))) / "registry/src").glob(f"*/{name}-{version}"))
    if len(matches) != 1:
        raise SystemExit(f"Fetch the locked workspace dependencies first: missing {name} {version}")
    return matches[0]


def write_changed(path, text):
    path.parent.mkdir(parents=True, exist_ok=True)
    if not path.exists() or path.read_text() != text:
        path.write_text(text)


def copy_changed(source, destination):
    source, destination = Path(source), Path(destination)
    content = source.read_bytes()
    destination.parent.mkdir(parents=True, exist_ok=True)
    if not destination.exists() or destination.read_bytes() != content:
        destination.write_bytes(content)
        shutil.copystat(source, destination)
    return str(destination)


def distribution_module(module):
    # Debug function names account for about 20 MiB of the full compiler. Keep
    # the build artifact intact for diagnosis; deploy its exact executable
    # sections without the optional names/producers sections.
    data = module.read_bytes()
    if data[:8] != b"\x00asm\x01\x00\x00\x00":
        raise SystemExit("Expected a WebAssembly 1 module")

    def leb(position):
        value, shift = 0, 0
        while position < len(data) and shift < 35:
            byte = data[position]
            position += 1
            value |= (byte & 127) << shift
            if byte < 128:
                return value, position
            shift += 7
        raise SystemExit("Invalid WebAssembly section length")

    output = bytearray(data[:8])
    position = 8
    while position < len(data):
        start = position
        kind = data[position]
        length, body = leb(position + 1)
        end = body + length
        if end > len(data):
            raise SystemExit("Truncated WebAssembly section")
        name = None
        if kind == 0:
            size, name_start = leb(body)
            if name_start + size > end:
                raise SystemExit("Truncated WebAssembly custom section name")
            name = data[name_start:name_start + size]
        if name not in (b"name", b"producers"):
            output.extend(data[start:end])
        position = end
    return output


def prepare_source():
    archive = ROOT / "target/browser-rustc-source.tar.gz"
    archive.parent.mkdir(parents=True, exist_ok=True)
    if not archive.exists():
        urllib.request.urlretrieve(f"https://codeload.github.com/rust-lang/rust/tar.gz/{REVISION}", archive)
    if hashlib.sha256(archive.read_bytes()).hexdigest() != SOURCE_HASH:
        raise SystemExit("Pinned Rust source archive checksum differs")
    stamp = SOURCE / ".gpui-browser-source"
    patch = ROOT / "scripts/codepen/browser-rustc.patch"
    page_patch = ROOT / "scripts/codepen/browser-paged-metadata.patch"
    stamp_value = REVISION + "\n" + hashlib.sha256(patch.read_bytes()).hexdigest() + "\n"
    if PAGED_METADATA:
        stamp_value += hashlib.sha256(page_patch.read_bytes()).hexdigest() + "\n"
    if not stamp.exists() or stamp.read_text() != stamp_value:
        # Restore only files this build customizes when adopting an existing tree.
        with tarfile.open(archive) as tar:
            prefix = tar.getmembers()[0].name.split("/")[0]
            if not SOURCE.exists():
                SOURCE.mkdir()
                for member in tar.getmembers():
                    # Do not mutate the TarFile's cached metadata used below.
                    import copy
                    member = copy.copy(member)
                    parts = Path(member.name).parts[1:]
                    if parts:
                        member.name = str(Path(*parts))
                        tar.extract(member, SOURCE, filter="data")
            customized = patch.read_text() + (page_patch.read_text() if page_patch.exists() else "")
            for name in set(re.findall(r"^--- a/(.*)$", customized, re.M)):
                (SOURCE / name).write_bytes(tar.extractfile(prefix + "/" + name).read())
        run(["patch", "-p1", "-i", ROOT / "scripts/codepen/browser-rustc.patch"], cwd=SOURCE)
        stamp.write_text(stamp_value)
    copy_changed(ROOT / "scripts/codepen/browser-flock.rs", SOURCE / "compiler/rustc_data_structures/src/flock/browser.rs")
    copy_changed(ROOT / "scripts/codepen/browser-float.rs", SOURCE / "compiler/rustc_const_eval/src/interpret/codepen_float.rs")
    shutil.copytree(ROOT / "vendor/miri", SOURCE / "miri", dirs_exist_ok=True,
                    copy_function=copy_changed,
                    ignore=shutil.ignore_patterns("target", ".git", "Cargo.lock", "Cargo.toml"))
    manifest = (ROOT / "vendor/miri/Cargo.toml").read_text()
    crates = re.findall(r"^extern crate (rustc_\w+);", (ROOT / "vendor/miri/src/lib.rs").read_text(), re.M)
    crates += ["rustc_driver", "rustc_interface", "rustc_log", "rustc_metadata", "rustc_session"]
    dependencies = []
    for name in sorted(set(crates)):
        if name == "rustc_apfloat":
            dependencies.append('rustc_apfloat = "0.2.0"')
        elif name == "rustc_driver":
            dependencies.append('rustc_driver = { package="rustc_driver_impl", path="../compiler/rustc_driver_impl" }')
        else:
            dependencies.append(f'{name} = {{ path="../compiler/{name}" }}')
    dependencies.append('gpui_codepen_guest = { path=' + json.dumps(str(ROOT / "crates/gpui_codepen/guest")) + ', features=["host-services"] }')
    manifest = manifest.replace("[dependencies]\n", "[dependencies]\n" + "\n".join(dependencies) + "\n", 1)
    manifest = manifest.replace("[features]\n", '[features]\ncodepen-cache-profile = ["rustc_const_eval/codepen-cache-profile"]\n', 1)
    write_changed(SOURCE / "miri/Cargo.toml", manifest)


def prepare_interpreter():
    # Keep performance patches independently versioned: changing an interpreter
    # cache must not rebuild every compiler crate or alter bootstrap defaults.
    patch = ROOT / "scripts/codepen/browser-interpreter.patch"
    stamp = SOURCE / ".gpui-browser-interpreter"
    value = REVISION + "\n" + hashlib.sha256(patch.read_bytes()).hexdigest() + "\n"
    if stamp.exists() and stamp.read_text() == value:
        return
    with tarfile.open(ROOT / "target/browser-rustc-source.tar.gz") as tar:
        prefix = tar.getmembers()[0].name.split("/")[0]
        for name in re.findall(r"^--- a/(.*)$", patch.read_text(), re.M):
            (SOURCE / name).write_bytes(tar.extractfile(prefix + "/" + name).read())
    run(["patch", "-p1", "-i", patch], cwd=SOURCE)
    stamp.write_text(value)


def invocation():
    descriptors = list((ROOT / f"target/codepen-real-miri/mir-{MIR_OPT_LEVEL}/miri").glob("*/debug/component_*"))
    descriptors = [p for p in descriptors if p.is_file() and not p.suffix]
    if not descriptors:
        raise SystemExit("Run the real-Miri component integration fixture first to build the current GPUI dependency closure")
    data = json.loads(max(descriptors, key=lambda p: p.stat().st_mtime).read_text())
    directories, externs = set(), {}
    args = data["args"]
    target = args[args.index("--target") + 1]
    for i, arg in enumerate(args):
        if arg == "-L" and args[i + 1].startswith("dependency="):
            directories.add(Path(args[i + 1].split("=", 1)[1]))
        elif arg == "--extern":
            name, path = args[i + 1].split("=", 1)
            if path.endswith(".rmeta"):
                externs[name] = Path(path)
                directories.add(Path(path).parent)
    return target, directories, externs


def macro_wrappers():
    target, directories, _ = invocation()
    helper = OUTPUT / "extract-metadata"
    sysroot = toolchain()
    run([sysroot / "bin/rustc", ROOT / "scripts/codepen/extract_metadata.rs", "--edition=2024",
         "-L", f"native={sysroot / 'lib'}", "-C", "rpath=yes", "-o", helper])
    wrappers = SOURCE / "browser-macros"
    bindings = []
    known = {
        "gpui_macros": (ROOT / "crates/gpui_macros/src", "gpui_macros.rs", 'heck="=0.5.0"\nsyn={version="=2.0.119",features=["full","extra-traits","visit-mut"]}\n', {}),
        "derive_refineable": (ROOT / "crates/gpui_derive_refineable/src", "derive_refineable.rs", 'syn={version="=2.0.119",features=["full","extra-traits","visit-mut"]}\n', {}),
        "serde_derive": (registry_source("serde_derive", "1.0.229") / "src", "lib.rs", 'syn={version="=3.0.4",features=["clone-impls","derive","parsing","printing","proc-macro"],default-features=false}\n', {"Serialize": "derive_serialize", "Deserialize": "derive_deserialize"}),
        "schemars_derive": (registry_source("schemars_derive", "1.2.2") / "src", "lib.rs", 'syn="=3.0.4"\nserde_derive_internals="=0.30.0"\n', {"JsonSchema": "derive_json_schema_wrapper", "JsonSchema_repr": "derive_json_schema_repr_wrapper"}),
    }
    for name, (source, lib, deps, overrides) in known.items():
        directory = wrappers / name
        for file in source.rglob("*"):
            if not file.is_file():
                continue
            destination = directory / "src" / file.relative_to(source)
            if file.suffix == ".rs":
                text = re.sub(r"#\[proc_macro(?:_derive\([^\n]*\)|_attribute)?\]\n?", "", file.read_text())
                text = re.sub(r"^extern crate proc_macro;$", "extern crate rustc_proc_macro as proc_macro;", text, flags=re.M)
                if file.relative_to(source).as_posix() == lib and "extern crate rustc_proc_macro as proc_macro;" not in text:
                    text += "\nextern crate rustc_proc_macro as proc_macro;\n"
                write_changed(destination, text)
            else:
                copy_changed(file, destination)
        # Upstream macro crates include sibling documentation at compile time.
        for document in source.parent.glob("*.md"):
            copy_changed(document, directory / document.name)
        original = (source / lib).read_text()
        callbacks = dict(overrides)
        for match in re.finditer(r"#\[proc_macro_derive\((\w+)(?:,.*?)?\)\].*?pub fn (\w+)", original, re.S):
            callbacks[match[1]] = match[2]
        # Keep all original implementations/modules/cfgs; strip only the compiler
        # registration attribute to make these the same callbacks in an rlib.
        package = "browser_" + name
        manifest = f'[package]\nname="{package}"\nversion="0.0.0"\nedition="2024"\n[lib]\npath="src/{lib}"\n[features]\ninspector=[]\ndeserialize_in_place=[]\n[dependencies]\nproc-macro2="=1.0.107"\nquote="=1.0.47"\n{deps}\n'
        manifest += '[target.\'cfg(target_family="wasm")\'.dependencies]\nrustc_proc_macro={path="../../compiler/rustc_proc_macro"}\n'
        write_changed(directory / "Cargo.toml", manifest)
        files = sorted({file for directory in directories for suffix in ("dylib", "so")
                        for file in directory.glob(f"lib{name}-*.{suffix}")})
        if len(files) != 1:
            raise SystemExit(f"Expected one current macro artifact for {name}, got {files}")
        metadata = OUTPUT / "macro-metadata" / (files[0].stem + ".rmeta")
        metadata.parent.mkdir(exist_ok=True)
        info = subprocess.check_output([helper, target, files[0], metadata], text=True)
        header = subprocess.check_output([sysroot / "bin/rustc", "-Zls=root", metadata], text=True)
        crate_hash = re.search(r"^hash (\w+) ", header, re.M)[1]
        stable_id = re.search(r"stable_crate_id StableCrateId\((\d+)\)", header)[1]
        cases = []
        for line in info.splitlines():
            kind, macro, attributes = line.split("\t")
            callback = callbacks.get(macro, macro)
            client = f'ProcMacroClient::expand{2 if kind == "attr" else 1}({package}::{callback})'
            if kind == "derive":
                attrs = [a for a in attributes.split(",") if a]
                attribute_check = f'attributes.iter().map(String::as_str).eq({json.dumps(attrs)})' if attrs else 'attributes.is_empty()'
                guard = f'trait_name == {json.dumps(macro)} && {attribute_check}'
                cases.append(f'ProcMacroKind::CustomDerive {{trait_name, attributes}} if {guard} => Some({client}),')
            else:
                variant = "Attr" if kind == "attr" else "Bang"
                cases.append(f'ProcMacroKind::{variant} {{name}} if name == {json.dumps(macro)} => Some({client}),')
        bindings.append(f'({json.dumps(crate_hash)}, {stable_id}) => match kind {{\n' + "\n".join(cases) + '\n_ => None,\n},')
    module = '''// Generated from the current native metadata and original macro sources.
use rustc_data_structures::svh::Svh;
use rustc_session::StableCrateId;
use rustc_proc_macro::bridge::client::Client as ProcMacroClient;
use crate::rmeta::ProcMacroKind;
pub(crate) fn client(hash: Svh, id: StableCrateId, kind: &ProcMacroKind) -> Option<ProcMacroClient> {
    match (hash.to_string().as_str(), id.as_u64()) {
''' + "\n".join(bindings) + '\n_ => None,\n}\n}\n'
    write_changed(SOURCE / "compiler/rustc_metadata/src/browser_macros.rs", module)
    path = SOURCE / "compiler/rustc_metadata/Cargo.toml"
    text = path.read_text().split("\n# GPUI browser macro clients\n")[0]
    text += '\n# GPUI browser macro clients\n[target.\'cfg(target_family="wasm")\'.dependencies]\n'
    for name in known:
        features = ',features=["inspector"]' if name == "gpui_macros" else ''
        text += f'browser_{name}={{path="../../browser-macros/{name}"{features}}}\n'
    write_changed(path, text)

    # The generated workspace has a distinct rustc dependency graph. Seed its
    # reviewed lockfile rather than resolving current registry versions on each
    # machine building the portable interpreter.
    copy_changed(ROOT / "scripts/codepen/browser.Cargo.lock", SOURCE / "Cargo.lock")
    for name, version in [("proc-macro2", "1.0.107"), ("syn", "2.0.119"), ("syn", "3.0.4")]:
        directory = SOURCE / "browser-macros/vendor" / f"{name}-{version}"
        original = registry_source(name, version)
        # Cargo's build-std graph includes the standard proc_macro crate. Give
        # our compiler's bridge an explicit distinct extern name, including the
        # nested proc-macro2 API probes, so rustc never resolves the two by name.
        for file in original.rglob("*"):
            if not file.is_file() or file.relative_to(original).as_posix() == "Cargo.toml":
                continue
            destination = directory / file.relative_to(original)
            if file.suffix == ".rs":
                text = file.read_text()
                text = re.sub(r"^extern crate proc_macro;$", "#[cfg(target_family=\"wasm\")]\nextern crate rustc_proc_macro as proc_macro;\n#[cfg(not(target_family=\"wasm\"))]\nextern crate proc_macro;", text, flags=re.M)
                write_changed(destination, text)
            else:
                copy_changed(file, destination)
        manifest = (original / "Cargo.toml").read_text()
        manifest += '\n[target.\'cfg(target_family="wasm")\'.dependencies]\nrustc_proc_macro={path="../../../compiler/rustc_proc_macro"}\n'
        write_changed(directory / "Cargo.toml", manifest)
    workspace = '''[workspace]
resolver="2"
members=["miri"]
[profile.release]
opt-level=3
debug=0
lto="thin"
codegen-units=16
[patch.crates-io]
proc-macro2={path="browser-macros/vendor/proc-macro2-1.0.107"}
syn2={package="syn",path="browser-macros/vendor/syn-2.0.119"}
syn3={package="syn",path="browser-macros/vendor/syn-3.0.4"}
'''
    write_changed(SOURCE / "Cargo.toml", workspace)
    # Static clients are looked up by crate hash, stable identity and full macro
    # kind/helper attributes. Metadata ordering remains rustc's own ordering.
    path = SOURCE / "compiler/rustc_metadata/src/lib.rs"
    text = path.read_text()
    if "mod browser_macros;" not in text:
        text += '\n#[cfg(target_family="wasm")]\nmod browser_macros;\n'
    write_changed(path, text)
    path = SOURCE / "compiler/rustc_metadata/src/creader.rs"
    text = path.read_text()
    if '#[cfg(not(target_family="wasm"))]\n        let raw_proc_macros' not in text:
        text = text.replace('        let raw_proc_macros = if crate_root.is_proc_macro_crate()', '        #[cfg(not(target_family="wasm"))]\n        let raw_proc_macros = if crate_root.is_proc_macro_crate()', 1)
        text = text.replace('        let crate_metadata = CrateMetadata::new(', '        #[cfg(target_family="wasm")]\n        let raw_proc_macros = None;\n\n        let crate_metadata = CrateMetadata::new(', 1)
    write_changed(path, text)
    path = SOURCE / "compiler/rustc_metadata/src/locator.rs"
    text = path.read_text()
    if '// Browser macros use target MIR metadata' not in text:
        text = text.replace('        self.target = &sess.host;', '        // Browser macros use target MIR metadata; callback code is linked into the compiler.\n        #[cfg(target_family="wasm")]\n        { self.target=&sess.target; self.tuple=sess.opts.target_triple.clone(); self.filesearch=sess.target_filesearch(); self.path_kind=path_kind; return; }\n        self.target = &sess.host;', 1)
        text = text.replace('    fn needs_crate_flavor(&self, flavor: CrateFlavor) -> bool {', '    fn needs_crate_flavor(&self, flavor: CrateFlavor) -> bool {\n        #[cfg(target_family="wasm")]\n        if self.is_proc_macro { return flavor == CrateFlavor::Rmeta; }', 1)
    write_changed(path, text)
    path = SOURCE / "compiler/rustc_metadata/src/rmeta/decoder.rs"
    text = path.read_text()
    old = '        (self.raw_proc_macros.unwrap()[pos], kind.decode((self, tcx)))'
    if old in text:
        text = text.replace(old, '''        let kind = kind.decode((self, tcx));
        #[cfg(target_family="wasm")]
        {
            let Some(client) = crate::browser_macros::client(self.hash(), self.root.stable_crate_id(), &kind) else {
                tcx.sess.dcx().fatal(format!("proc macro from {} is not bundled with this GPUI interpreter", self.root.name()));
            };
            (client, kind)
        }
        #[cfg(not(target_family="wasm"))]
        (self.raw_proc_macros.unwrap()[pos], kind)''', 1)
    write_changed(path, text)

    copy_changed(ROOT / "scripts/codepen/browser-metadata.rs", SOURCE / "compiler/rustc_metadata/src/browser_metadata.rs")
    path = SOURCE / "compiler/rustc_metadata/src/lib.rs"
    text = path.read_text()
    if "mod browser_metadata;" not in text:
        text += '\n#[cfg(target_family="wasm")]\nmod browser_metadata;\n'
    if "pub fn codepen_metadata_profile()" not in text:
        text += '\n#[cfg(target_family="wasm")]\n#[doc(hidden)]\npub fn codepen_metadata_profile() -> Option<String> { browser_metadata::report() }\n'
    write_changed(path, text)
    path = SOURCE / "compiler/rustc_metadata/src/locator.rs"
    text = path.read_text()
    signature = "fn get_rmeta_metadata_section<'a, 'p>(filename: &'p Path) -> Result<OwnedSlice, MetadataError<'a>> {"
    if "fn read_rmeta_metadata_section" not in text:
        text = text.replace(signature, signature + '''
    #[cfg(target_family="wasm")]
    return crate::browser_metadata::read(filename, || read_rmeta_metadata_section(filename));
    #[cfg(not(target_family="wasm"))]
    read_rmeta_metadata_section(filename)
}

fn read_rmeta_metadata_section<'a, 'p>(filename: &'p Path) -> Result<OwnedSlice, MetadataError<'a>> {''', 1)
    write_changed(path, text)


def prepare_paged_metadata():
    if not PAGED_METADATA:
        return
    library = SOURCE / "compiler/rustc_metadata/src/lib.rs"
    if "mod browser_paged_metadata;" not in library.read_text():
        run(["patch", "-p1", "-i", ROOT / "scripts/codepen/browser-paged-metadata.patch"], cwd=SOURCE)
    for filename, helper in (("browser_metadata.rs", "browser-page-cache.rs"),
                             ("browser_paged_metadata.rs", "browser-paged-metadata.rs"),
                             ("browser_paged_hash_map.rs", "browser-paged-hash-map.rs")):
        copy_changed(ROOT / "scripts/codepen" / helper,
                     SOURCE / "compiler/rustc_metadata/src" / filename)


def build():
    sysroot = toolchain()
    run(["rustup", "target", "add", "--toolchain", TOOLCHAIN, "wasm32-wasip1"])
    env = os.environ.copy()
    env.update(RUSTC=str(sysroot / "bin/rustc"), RUSTDOC=str(sysroot / "bin/rustdoc"),
               RUSTC_BOOTSTRAP="1", CFG_RELEASE_CHANNEL="nightly", CFG_RELEASE="1.101.0-nightly",
               CFG_VERSION=VERSION, CFG_VER_HASH=REVISION, CFG_VER_DATE="2026-09-29",
               CFG_COMPILER_HOST_TRIPLE="wasm32-wasip1", CFG_DEFAULT_CODEGEN_BACKEND="dummy",
               RUSTC_INSTALL_BINDIR="bin",
               RUSTFLAGS="-C link-arg=-zstack-size=33554432 -Cpanic=unwind -Ctarget-feature=+exception-handling")
    env["CARGO_TARGET_DIR"] = str(SOURCE / "target")
    env.setdefault("CARGO_BUILD_JOBS", "2")
    env.pop("CARGO_ENCODED_RUSTFLAGS", None)
    env.pop("RUSTC_WRAPPER", None)
    features = "stack-cache"
    if os.environ.get("GPUI_CODEPEN_CACHE_PROFILE") == "1":
        features += ",codepen-cache-profile"
    run(["cargo", "build", "-Zbuild-std=std,panic_unwind", "--locked", "--manifest-path", SOURCE / "Cargo.toml", "-p", "miri", "--target",
         "wasm32-wasip1", "--release", "--no-default-features", "--features", features], env=env, cwd=ROOT)


def starters(target, directories, externs, miri_sysroot, extra_directories=()):
    # The guide's built-in Rust is compiled ahead of time to the same MIR that
    # the full interpreter executes. Exact source identity selects this path;
    # editing any byte goes through the ordinary compiler/incremental cache.
    lessons = (ROOT / "crates/gpui_codepen/src/lessons.rs").read_text()
    sources = re.findall(r'\bsource:\s*r(#+)"(.*?)"\1\s*,', lessons, re.S)
    if not sources or len(sources) != len(re.findall(r'^\s+Lesson\s*\{', lessons, re.M)):
        raise SystemExit("Every built-in guide component must have a raw Rust source literal")
    env = native_driver_env()
    env["MIRI_BE_RUSTC"] = "target"
    env["GPUI_CODEPEN_COMPONENT"] = "1"
    driver = ROOT / "vendor/miri/target/release/miri"
    common = [driver, "--sysroot", miri_sysroot, "--target", target, "--edition=2024",
              "--crate-type=rlib", "--emit=metadata", "-Cdebug-assertions=no", "-Copt-level=3",
              f"-Zmir-opt-level={MIR_OPT_LEVEL}", "-Znext-solver=globally", "-Zpolonius=next", "-Zremap-cwd-prefix=/gpui-codepen", "-Awarnings"]
    for directory in sorted(directories):
        common += ["-L", "dependency=" + str(directory)]
    for name in ("gpui", "gpui_codepen_guest"):
        common += ["--extern", name + "=" + str(externs[name])]
    wrapper = "\npub fn __gpui_codepen_start() { gpui_codepen_guest::run(component); }\n"
    # Include the entire ordered compiler invocation. Normalize installation
    # paths so identical builds can share a starter identity across machines.
    # The driver digest also invalidates metadata when its MIR providers change.
    normalized = {str(driver): "/miri", str(miri_sysroot): "/sysroot"}
    for index, dependency in enumerate(sorted(directories)):
        normalized["dependency=" + str(dependency)] = f"dependency=/deps/search-{index}"
    for name in ("gpui", "gpui_codepen_guest"):
        normalized[name + "=" + str(externs[name])] = name + "=/deps/" + externs[name].name
    canonical_args = [normalized.get(str(arg), str(arg)) for arg in common]
    identity = hashlib.sha256(json.dumps({"revision": REVISION, "version": VERSION,
        "args": canonical_args, "wrapper": wrapper, "format": "codepen-mir-3",
        "component": env["GPUI_CODEPEN_COMPONENT"],
        "source_path": "/gpui-codepen/component.rs"}, sort_keys=True).encode())
    with driver.open("rb") as executable:
        identity.update(hashlib.file_digest(executable, "sha256").digest())
    for artifact in sorted((miri_sysroot / "lib/rustlib" / target / "lib").glob("lib*.rmeta")):
        identity.update(artifact.name.encode())
        identity.update(artifact.read_bytes())
    for name in ("gpui", "gpui_codepen_guest"):
        identity.update(externs[name].read_bytes())
    programs = [source for _, source in sources]
    for directory in extra_directories:
        paths = sorted(Path(directory).glob("*.rs"))
        if not paths:
            raise SystemExit(f"No initial Rust components in {directory}")
        programs.extend(path.read_text() for path in paths)
    result = []
    for source in dict.fromkeys(programs):
        if len(source.encode()) > 64 * 1024:
            raise SystemExit("Initial Rust component exceeds 64 KiB")
        fingerprint = identity.copy()
        fingerprint.update(source.encode())
        name = "gpui_starter_" + fingerprint.hexdigest()[:20]
        directory = OUTPUT / "starters" / name
        directory.mkdir(parents=True, exist_ok=True)
        code = directory / "component.rs"
        write_changed(code, source + wrapper)
        metadata = directory / ("lib" + name + ".rmeta")
        if not metadata.exists() or code.stat().st_mtime > metadata.stat().st_mtime:
            # file!(), track_caller and GPUI's text! identity are part of the
            # compiled program. Match the editable Worker's virtual filename,
            # including constants embedded in promoted MIR and allocations.
            run(common + ["--crate-name", name, code, "-o", metadata], env=env, cwd=directory)
        packet = directory / (name + ".mir")
        if not packet.exists() or code.stat().st_mtime > packet.stat().st_mtime or driver.stat().st_mtime > packet.stat().st_mtime:
            export_env = env.copy()
            export_env.pop("MIRI_BE_RUSTC", None)
            metadata_info = subprocess.check_output([toolchain() / "bin/rustc", "-Zls=root", metadata], env=env, text=True)
            crate_hash = re.search(r"^hash ([0-9a-f]+) ", metadata_info, re.M)
            if not crate_hash: raise SystemExit("Cannot identify starter metadata hash")
            export_env.update(GPUI_CODEPEN_IPC="1", GPUI_CODEPEN_EXPORT_MIR=str(packet), GPUI_CODEPEN_BASELINE_HASH=crate_hash[1])
            run(common + ["--crate-name", name, code, "-o", metadata], env=export_env, cwd=directory)
        result.append({"source": source, "crate": name, "path": "/deps/" + metadata.name,
                       "packet": "/deps/" + packet.name, "artifact": metadata, "packet_artifact": packet})
    return result



def metadata_closure(candidates, roots):
    # rustc records its complete transitive dependency table, including macros
    # and conditional dependencies. Decode that table with the same compiler
    # that produced it rather than guessing dependencies from Cargo directories.
    compiler = toolchain() / "bin/rustc"
    env = native_driver_env()
    decoded = {}

    def info(artifact):
        if artifact not in decoded:
            text = subprocess.check_output([compiler, "-Zls=root", artifact], env=env, text=True)
            identity = re.search(r"^name (\S+)\nhash ([0-9a-f]+) ", text, re.M)
            if not identity or "=External Dependencies=" not in text:
                raise SystemExit(f"Cannot decode pinned compiler metadata for {artifact}")
            dependencies = {}
            for name, crate_hash in re.findall(r"^\d+ (\S+) hash ([0-9a-f]+) host_hash ", text, re.M):
                if dependencies.setdefault(name, crate_hash) != crate_hash:
                    raise SystemExit(f"Conflicting dependency metadata identity for {name} in {artifact}")
            decoded[artifact] = (identity[1], identity[2], dependencies)
        return decoded[artifact]

    required = {}
    for artifact in roots:
        name, crate_hash, dependencies = info(artifact)
        for dependency, expected_hash in [(name, crate_hash), *dependencies.items()]:
            previous = required.setdefault(dependency, expected_hash)
            if previous != expected_hash:
                raise SystemExit(f"Conflicting compiler metadata identity for {dependency}")
    by_name = {}
    for virtual, artifact in candidates.items():
        by_name.setdefault(artifact.stem.removeprefix("lib"), []).append((virtual, artifact))
    selected = {}
    for name, expected_hash in sorted(required.items()):
        choices = by_name.get(name, [])
        if not choices:
            raise SystemExit(f"Required compiler dependency is missing: {name}")
        matches = []
        for virtual, artifact in choices:
            actual_name, actual_hash, _ = info(artifact)
            if actual_name == name and actual_hash == expected_hash:
                matches.append((virtual, artifact))
        if not matches:
            raise SystemExit(f"Required compiler dependency hash differs: {name}")
        # Prefer the sysroot's location for its own libraries. Other references
        # resolve through /deps. Equivalent copies need not be shipped twice.
        matches.sort(key=lambda entry: (not entry[0].startswith("/sysroot/"), entry[0]))
        if len(matches) > 1:
            expected_bytes = matches[0][1].read_bytes()
            if any(artifact.read_bytes() != expected_bytes for _, artifact in matches[1:]):
                raise SystemExit(f"Divergent copies of compiler metadata for {name}")
        selected[matches[0][0]] = matches[0][1]
    print(f"Metadata closure: {len(selected)} of {len(candidates)} files", flush=True)
    return selected


def bundle(extra_directories=()):
    target, directories, externs = invocation()
    destination = OUTPUT / ("miri-full" if PAGED_METADATA else "miri")
    destination.mkdir(parents=True, exist_ok=True)
    shutil.copytree(ROOT / "crates/gpui_codepen/web/miri", destination, dirs_exist_ok=True)
    shutil.copytree(ROOT / "vendor/browser_wasi_shim/dist", destination / "wasi", dirs_exist_ok=True)
    for license in (ROOT / "vendor/browser_wasi_shim").glob("LICENSE*"):
        shutil.copy2(license, destination / "wasi" / license.name)
    payload = bytearray()
    files, included = [], {}

    def include(path, content):
        if path in included:
            if included[path] != hashlib.sha256(content).digest():
                raise SystemExit(f"Conflicting metadata files at {path}")
            return
        included[path] = hashlib.sha256(content).digest()
        files.append({"path": path, "offset": len(payload), "length": len(content)})
        payload.extend(content)

    helper = OUTPUT / "extract-metadata"
    candidates = {}
    def candidate(virtual, artifact):
        previous = candidates.get(virtual)
        if previous is not None and previous.read_bytes() != artifact.read_bytes():
            raise SystemExit(f"Conflicting metadata files at {virtual}")
        candidates[virtual] = artifact
    for directory in sorted(directories):
        for artifact in sorted(directory.glob("lib*.rmeta")):
            candidate("/deps/" + artifact.name, artifact)
        for artifact in sorted({file for suffix in ("dylib", "so") for file in directory.glob(f"*.{suffix}")}):
            metadata = OUTPUT / "macro-metadata" / (artifact.stem + ".rmeta")
            if not metadata.exists():
                run([helper, target, artifact, metadata], stdout=subprocess.DEVNULL)
            candidate("/deps/" + metadata.name, metadata)
    env = native_driver_env()
    env.update(GPUI_CODEPEN_SYSROOT_MIR_OPT_LEVEL=MIR_OPT_LEVEL, MIRI_SYSROOT=str(ROOT / f"target/codepen-sysroot/mir-{MIR_OPT_LEVEL}"))
    miri_sysroot = Path(subprocess.check_output(
        [ROOT / "vendor/miri/cargo-miri/target/debug/cargo-miri", "miri", "setup", "--print-sysroot"],
        env=env, text=True).strip())
    for artifact in sorted((miri_sysroot / "lib/rustlib" / target / "lib").glob("lib*.rmeta")):
        candidate(f"/sysroot/lib/rustlib/{target}/lib/{artifact.name}", artifact)
    initial_programs = starters(target, directories, externs, miri_sysroot, extra_directories)
    roots = [externs["gpui"], externs["gpui_codepen_guest"]]
    for program in initial_programs:
        artifact = program.pop("artifact")
        roots.append(artifact)
        candidate(program["path"], artifact)
    selected = metadata_closure(candidates, roots)
    starter_paths = {program["path"] for program in initial_programs}
    for virtual, artifact in selected.items():
        if virtual not in starter_paths:
            include(virtual, artifact.read_bytes())
    for name in ("gpui", "gpui_codepen_guest"):
        if "/deps/" + externs[name].name not in included:
            raise SystemExit(f"Current {name} metadata was not bundled")
    metadata = gzip.compress(payload, compresslevel=6, mtime=0)
    metadata_name = "metadata-" + hashlib.sha256(metadata).hexdigest()[:20] + ".bin.gz"
    (destination / metadata_name).write_bytes(metadata)
    metadata_parts = [metadata_name]
    # Lesson edits must not invalidate the large immutable SDK archive. Each
    # starter's compiled MIR has its own content address and persistent cache.
    metadata_bytes = len(metadata)
    for program in initial_programs:
        content = selected[program["path"]].read_bytes()
        include(program["path"], content)
        packet = program.pop("packet_artifact").read_bytes()
        include(program["packet"], packet)
        content += packet
        compressed = gzip.compress(content, compresslevel=6, mtime=0)
        name = "metadata-starter-" + hashlib.sha256(compressed).hexdigest()[:20] + ".bin.gz"
        (destination / name).write_bytes(compressed)
        metadata_parts.append(name)
        metadata_bytes += len(compressed)
    module = Path(os.environ.get("GPUI_CODEPEN_MODULE", str(SOURCE / "target/wasm32-wasip1/release/miri.wasm")))
    if not module.exists():
        raise SystemExit("Build the full browser Miri driver before bundling")
    executable = distribution_module(module)
    compressed_module = gzip.compress(executable, compresslevel=6, mtime=0)
    module_name = "miri-" + hashlib.sha256(compressed_module).hexdigest()[:20] + ".wasm.gz"
    (destination / module_name).write_bytes(compressed_module)
    args = ["miri", "--sysroot", "/sysroot", "--target", target, "--edition=2024", "--crate-name", "gpui_component",
            "-L", "dependency=/deps", "/component.rs", "--emit=metadata", "-Cdebug-assertions=no", "-Copt-level=3", f"-Zmir-opt-level={MIR_OPT_LEVEL}",
            "-Znext-solver=globally", "-Zpolonius=next", "-Zremap-cwd-prefix=/gpui-codepen", "-Awarnings"]
    for name in ("gpui", "gpui_codepen_guest"):
        args += ["--extern", name + "=/deps/" + externs[name].name]
    # Pin bootstrap defaults and normalize the tracked working directory.
    # A compiler built outside nightly bootstrap otherwise silently changes
    # solver/borrow-checker defaults, rejecting compatible native starter MIR.
    # The VM adds only its selected starter to the tiny bootstrap crate.
    args += MIRI_FLAGS.split()
    manifest = {"version": VERSION, "protocol": 8, "module": module_name, "module_compression": "gzip", "metadata": metadata_name,
                "incremental_compiler": True, "incremental_verify_ich": True,
                "metadata_parts": metadata_parts, "files": files, "args": args, "starters": initial_programs}
    write_changed(destination / "assets.json", json.dumps(manifest, separators=(",", ":")))
    # Trunk copies this entire directory. Retain only the assets named by the
    # committed manifest so old full compiler bundles cannot bloat the page.
    for pattern in ("miri-*.wasm", "miri-*.wasm.gz", "metadata-*.bin.gz"):
        for stale in destination.glob(pattern):
            if stale.name not in {module_name, *metadata_parts}:
                stale.unlink()
    print(f"Browser bundle: {len(compressed_module) / 1024**2:.1f} MiB compressed driver ({len(executable) / 1024**2:.1f} MiB executable), {metadata_bytes / 1024**2:.1f} MiB compressed metadata ({len(files)} files)")
    if PAGED_METADATA:
        # Keep the exact full SDK available for diagnostics and parity tests.
        # The measured plan affects prefetch only: all other bytes remain
        # available in independently cached immutable ranges.
        run([sys.executable, ROOT / "scripts/codepen/page-metadata.py", destination, OUTPUT / "miri",
             "--profile", ROOT / "scripts/codepen/browser-metadata-prefetch.json"])
        destination = OUTPUT / "miri"
    print(destination)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("command", choices=["prepare", "build", "bundle", "all"])
    parser.add_argument("--starter-dir", type=Path, action="append", default=[],
                        help="Also ship precompiled MIR for each initial component .rs in this directory")
    args = parser.parse_args()
    OUTPUT.mkdir(parents=True, exist_ok=True)
    if args.command in ("prepare", "all"):
        prepare_source()
        prepare_interpreter()
        macro_wrappers()
        prepare_paged_metadata()
    if args.command in ("build", "all"):
        build()
    if args.command in ("bundle", "all"):
        bundle(args.starter_dir)


if __name__ == "__main__":
    main()
