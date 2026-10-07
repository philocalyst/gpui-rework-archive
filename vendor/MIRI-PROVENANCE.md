# Vendored Miri

`miri/` is the complete `src/tools/miri` source tree from rust-lang/rust commit
`5c543b0b8c73c7b72bc8284ced4fb22ead15734d` (the compiler shipped in
`nightly-2026-09-30`). Source URL:
https://github.com/rust-lang/rust/tree/5c543b0b8c73c7b72bc8284ced4fb22ead15734d/src/tools/miri

The source and its dual MIT/Apache-2.0 licenses are preserved. The local changes are:

- `src/shims/foreign_items.rs`: opt-in bounded `gpui_codepen_receive` and
  `gpui_codepen_emit` transport. Input and length-delimited binary output use
  the worker's pipes; component evaluation stays in the Rust interpreter.
- `src/bin/miri.rs`: an opt-in Unix parent-lifetime watchdog prevents a running
  guest from surviving a terminated guide/compiler companion.

These additions activate only with `GPUI_CODEPEN_IPC=1`. Upstream Rust execution
is preserved. The codepen disables validation, borrowing, data-race, alignment,
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
