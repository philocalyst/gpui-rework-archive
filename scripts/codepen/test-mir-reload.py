#!/usr/bin/env python3
"""Exercise real compiler packets against one live Miri heap and call stack."""
import os
import re
from pathlib import Path
import select
import struct
import subprocess
import tempfile
import time

ROOT = Path(__file__).resolve().parents[2]
TOOLCHAIN = "nightly-2026-09-30"
SYSROOT = Path(subprocess.check_output(["rustup", "run", TOOLCHAIN, "rustc", "--print", "sysroot"], text=True).strip())
ENV = os.environ.copy()
ENV.pop("GPUI_CODEPEN_INCREMENTAL", None)
ENV.update(DYLD_LIBRARY_PATH=str(SYSROOT / "lib"), LD_LIBRARY_PATH=str(SYSROOT / "lib"),
           GPUI_CODEPEN_IPC="1", GPUI_CODEPEN_NONCE="probe", RUSTC_ICE="0")
FLAGS = "-Zmiri-disable-isolation -Zmiri-ignore-leaks -Zmiri-disable-validation -Zmiri-disable-stacked-borrows -Zmiri-disable-data-race-detector -Zmiri-disable-alignment-check -Zmiri-deterministic-floats -Zmiri-provenance-gc=250000 -Zmiri-preemption-rate=0 -Zmiri-address-reuse-rate=0"
SOURCE = r'''#![feature(specialization)]
struct Token;
impl Token { fn value() -> u32 { 1 } }
trait Step { fn step() -> u32; }
impl<T> Step for T { default fn step() -> u32 { 1 } }
fn once<F: std::ops::AsyncFnOnce() -> u32>(f: F) -> impl std::future::Future<Output = u32> { f() }
fn retained_future() -> impl std::future::Future<Output = u32> {
    let text = String::from("retained future");
    once(async move || {
        let saved = 1u32;
        std::future::pending::<()>().await;
        text.len() as u32 + saved
    })
}
unsafe extern "C" {
    fn gpui_codepen_receive(bytes: *mut u8, capacity: usize) -> usize;
    fn gpui_codepen_emit(bytes: *const u8, len: usize);
}
macro_rules! caller { () => { std::panic::Location::caller().line() }; }
fn callback() -> impl Fn(u32) -> u32 {
    let left = std::hint::black_box(2u32);
    let right = std::hint::black_box(3u32);
    move |value| { let _captured = left + right; value + 1 }
}
fn label() -> &'static str { "old" }
fn site() -> u32 { caller!() }
fn main() {
    let _retained_future = Box::pin(retained_future());
    let callback = Box::new(callback()) as Box<dyn Fn(u32) -> u32>;
    let original_label = label();
    let mut value = 0u32;
    unsafe { gpui_codepen_emit(std::ptr::null(), 0); }
    let mut input = [0u8; 1];
    while unsafe { gpui_codepen_receive(input.as_mut_ptr(), 1) } != 0 {
        value = callback(value);
        let mut bytes = value.to_le_bytes().to_vec();
        bytes.extend_from_slice(&site().to_le_bytes());
        bytes.extend_from_slice(original_label.as_bytes());
        bytes.extend_from_slice(label().as_bytes());
        unsafe { gpui_codepen_emit(bytes.as_ptr(), bytes.len()); }
    }
}
'''


STARTER = os.environ.get("GPUI_CODEPEN_TEST_STARTER") == "1"
if STARTER:
    SOURCE = SOURCE.replace("fn main()", "pub fn run_probe()")

with tempfile.TemporaryDirectory(prefix="gpui-mir-reload-") as directory:
    directory = Path(directory)
    source = directory / "component.rs"
    packet = directory / "component.mir"
    errors = open(directory / "resident.stderr", "w+b")
    source.write_text(SOURCE)
    args = [os.environ.get("GPUI_CODEPEN_DRIVER", str(ROOT / "vendor/miri/target/release/miri")), "--sysroot", str(ROOT / "target/codepen-sysroot/mir-2"),
            "--edition=2024", "--crate-name=reload_probe", "component.rs", "-Copt-level=3", "-Zmir-opt-level=2", "-Awarnings", *FLAGS.split()]
    resident_args = args
    resident_env = ENV
    if STARTER:
        args += ["--crate-type=rlib", "--emit=metadata", "-o", str(directory / "libreload_probe.rmeta")]
        compiled = subprocess.run([arg for arg in args if not arg.startswith("-Zmiri-")], cwd=directory, env={**ENV, "MIRI_BE_RUSTC": "target", "GPUI_CODEPEN_COMPONENT": "1"}, capture_output=True, timeout=30)
        assert compiled.returncode == 0, compiled.stderr.decode(errors="replace")
        baseline = directory / "baseline.mir"
        info = subprocess.check_output([SYSROOT / "bin/rustc", "-Zls=root", directory / "libreload_probe.rmeta"], env=ENV, text=True)
        crate_hash = re.search(r"^hash ([0-9a-f]+) ", info, re.M)[1]
        compiled = subprocess.run(args, cwd=directory, env={**ENV, "GPUI_CODEPEN_EXPORT_MIR": str(baseline), "GPUI_CODEPEN_BASELINE_HASH": crate_hash}, capture_output=True, timeout=30)
        assert compiled.returncode == 0, compiled.stderr.decode(errors="replace")
        (directory / "resident.rs").write_text("fn main() { reload_probe::run_probe(); }")
        resident_args = [args[0], "--sysroot", args[2], "--edition=2024", "--crate-name=resident_probe", "resident.rs",
                         "--extern", "reload_probe=" + str(directory / "libreload_probe.rmeta"), "-Copt-level=3", "-Zmir-opt-level=2", "-Awarnings", *FLAGS.split()]
        resident_env = {**ENV, "GPUI_CODEPEN_BASELINE_MIR": str(baseline)}
    compiler_args = list(args)
    compiler_env = ENV.copy()
    if os.environ.get("GPUI_CODEPEN_TEST_INCREMENTAL") == "1":
        compiler_args += ["-Cincremental=" + str(directory / "incremental")]
        compiler_env["GPUI_CODEPEN_INCREMENTAL"] = "1"
    resident = subprocess.Popen(resident_args, cwd=directory, env=resident_env, stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=errors, bufsize=0)
    output = bytearray()

    def read_until(length=None):
        deadline = time.monotonic() + 30
        while length is not None and len(output) < length or length is None and b"\n" not in output:
            remaining = deadline - time.monotonic()
            if remaining <= 0 or not select.select([resident.stdout], [], [], max(0, remaining))[0]:
                raise AssertionError("Resident Miri transport timed out")
            chunk = os.read(resident.stdout.fileno(), 65536)
            if not chunk:
                errors.seek(0)
                raise AssertionError(errors.read().decode(errors="replace"))
            output.extend(chunk)
        count = length if length is not None else output.index(10) + 1
        result = bytes(output[:count])
        del output[:count]
        return result

    def line(prefix):
        while True:
            text = read_until()
            if text.startswith(prefix):
                return text

    def frame():
        resident.stdin.write(struct.pack("<I", 1) + b"\x01")
        header = line(b"CODEPEN_probe:FRAME:")
        length = int(header.rsplit(b":", 1)[1])
        result = read_until(length)
        assert read_until(1) == b"\n"
        return struct.unpack("<II", result[:8]), result[8:]

    def compile_patch(text):
        source.write_text(text)
        packet.unlink(missing_ok=True)
        started = time.monotonic()
        result = subprocess.run(compiler_args, cwd=directory, env={**compiler_env, "GPUI_CODEPEN_EXPORT_MIR": str(packet)}, capture_output=True, timeout=30)
        if result.returncode:
            return result, None
        data = packet.read_bytes()
        resident.stdin.write(struct.pack("<I", len(data) | 0x80000000) + data)
        accepted = line(b"CODEPEN_probe:RELOADED:").strip().endswith(b":1")
        print(f"MIR reload: {len(data)} bytes, {(time.monotonic() - started) * 1000:.0f} ms, accepted={accepted}", flush=True)
        return result, accepted

    try:
        line(b"CODEPEN_probe:READY:")
        first, labels = frame()
        expected_line = SOURCE[:SOURCE.index("caller!()")].count("\n") + 1
        assert first == (1, expected_line), first
        assert labels == b"oldold", labels
        updated = SOURCE.replace("value + 1", "value + 5").replace('"old"', '"new"').replace("fn site()", "\n\nfn site()")
        result, accepted = compile_patch(updated)
        assert result.returncode == 0, result.stderr.decode(errors="replace")
        assert accepted, "Compatible runtime bodies were rejected"
        second, labels = frame()
        expected_line = updated[:updated.index("caller!()")].count("\n") + 1
        assert second == (6, expected_line), second
        assert labels == b"oldnew", labels
        broken, accepted = compile_patch("fn main(é")
        assert broken.returncode != 0 and accepted is None
        assert frame()[0][0] == 11, "A compiler error changed the resident heap"
        incompatible = updated.replace("value + 5", "value + 8").replace("impl Fn(u32) -> u32", "impl Fn(u64) -> u64").replace("as Box<dyn Fn(u32) -> u32>", "as Box<dyn Fn(u64) -> u64>").replace("0u32", "0u64")
        result, accepted = compile_patch(incompatible)
        assert result.returncode == 0, result.stderr.decode(errors="replace")
        assert accepted is False, "A changed function ABI was installed into live state"
        assert frame()[0][0] == 16, "An incompatible packet changed the resident program"
        reordered = updated.replace("left + right", "right + left")
        result, accepted = compile_patch(reordered)
        assert result.returncode == 0, result.stderr.decode(errors="replace")
        assert accepted is False, "Same-typed capture reordering was installed into an existing closure"
        assert frame()[0][0] == 21, "Rejected captures changed the live callback"
        result, accepted = compile_patch(updated.replace("default fn step", "fn step"))
        assert result.returncode == 0, result.stderr.decode(errors="replace")
        assert accepted is False, "Associated-item defaultness changed in a resident compiler"
        assert frame()[0][0] == 26, "Rejected specialization changed the live callback"
        changed_future = updated.replace("let saved = 1u32;", "let saved = [1u32; 3];").replace("text.len() as u32 + saved", "text.len() as u32 + saved[2]")
        result, accepted = compile_patch(changed_future)
        assert result.returncode == 0, result.stderr.decode(errors="replace")
        assert accepted is False, "A changed by-move async-closure layout was installed into retained future state"
        assert frame()[0][0] == 31, "Rejected coroutine layout changed the live callback"
        print("PASS actual Miri heap, existing boxed closure/vtable, literal borrows, macro caller locations, compiler-error recovery and incompatible ABI rejection")
    finally:
        resident.stdin.close()
        try:
            resident.wait(timeout=10)
        except subprocess.TimeoutExpired:
            resident.kill()
            resident.wait()
        errors.close()
