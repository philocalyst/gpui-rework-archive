# Vendored Miri

`miri/` is the complete `src/tools/miri` source tree from rust-lang/rust commit
`5c543b0b8c73c7b72bc8284ced4fb22ead15734d` (the compiler shipped in
`nightly-2026-09-30`). Source URL:
https://github.com/rust-lang/rust/tree/5c543b0b8c73c7b72bc8284ced4fb22ead15734d/src/tools/miri

The source and its dual MIT/Apache-2.0 licenses are preserved. The local changes are:

- `src/shims/foreign_items.rs`: opt-in bounded `gpui_codepen_receive` and
  `gpui_codepen_emit` transport. Length-prefixed binary input and length-delimited binary output use
  the worker's pipes; component evaluation stays in the Rust interpreter.
  `gpui_codepen_rpc_start`/`gpui_codepen_rpc_read` connect the guest's actual
  GPUI platform text trait to the compiled Parley service over a separate,
  length-delimited loopback stream. An opt-in `gpui_codepen_profile` probe
  reports native elapsed time and MIR basic-block counts for frame phases.
- `src/machine.rs`: owns that platform stream, its reusable response buffer, and optional
  profiling timestamps and per-function MIR work counters.
- `src/intrinsics/mod.rs`: executes integer rotations, unchecked funnel shifts,
  and disjoint bitwise OR directly with native scalar arithmetic, preserving
  Rust's integer width, signed bit patterns, and undefined-behavior checks.
  The corresponding pass and fail fixtures compare against native Rust and
  exercise invalid shift counts and overlapping operands.
- `src/bin/miri.rs`: an opt-in Unix parent-lifetime watchdog prevents a running
  guest from surviving a terminated guide/compiler companion.

The transport additions activate only with `GPUI_CODEPEN_IPC=1`. Profiling is
opt-in through `GPUI_CODEPEN_PROFILE` (`1` for phases, `functions` for function
work). Integer intrinsic acceleration applies to all interpreted programs and
preserves the intrinsic semantics. The codepen disables validation, borrowing, data-race, alignment,
leak backtraces and isolation checks for speed, per the guide's use case. The standalone lockfile originated from
rust-lang/miri commit `5a958d4bd344147224d8d4a35d5c23a1b800123d` and was resolved
for this checkout. `cargo-miri/Cargo.lock` records its separate wrapper build.

Build with `python3 scripts/codepen/setup.py`. We disable the optional native
FFI and GenMC features; the GPUI guest needs only portable Rust. The codepen
sets `MIRI` explicitly to this built driver and puts the built cargo wrapper
first on PATH. Installing the official Miri component is not a substitute for
building the vendored driver.

Update the source, both lockfiles, toolchain in the setup/runtime, and this
provenance record together. Run the real-engine regression suite afterwards.
Miri depends on unstable rustc internals; arbitrary newer nightlies are not
compatible. Miri isolation is not a security sandbox (see upstream README).
