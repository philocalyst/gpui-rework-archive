# Vendored Miri

`miri/` is the complete `src/tools/miri` source tree from rust-lang/rust commit
`5c543b0b8c73c7b72bc8284ced4fb22ead15734d` (the compiler shipped in
`nightly-2026-09-30`). Source URL:
https://github.com/rust-lang/rust/tree/5c543b0b8c73c7b72bc8284ced4fb22ead15734d/src/tools/miri

The source and its dual MIT/Apache-2.0 licenses are preserved. The local changes are:

- `src/shims/foreign_items.rs`: opt-in bounded `gpui_codepen_receive` and
  `gpui_codepen_emit` transport. The native guide uses a dedicated loopback
  control stream; standalone fixtures can use pipes. Component evaluation stays
  in the Rust interpreter. Guest stdin/stdout never carry guide control traffic.
  `gpui_codepen_rpc_start`/`gpui_codepen_rpc_read` connect the guest's actual
  GPUI platform text trait to the compiled Parley service over a separate,
  length-delimited loopback stream. An opt-in `gpui_codepen_profile` probe
  reports native elapsed time and MIR basic-block counts for frame phases.
- `src/machine.rs`: owns that platform stream, its reusable response buffer, and optional
  profiling timestamps and per-function MIR work counters.
- `src/codepen_reload.rs`: exports analyzed Rust MIR and installs compatible
  body generations in the resident compiler arena. Stable definition identities,
  signatures, type layouts, generic/trait contracts, capture identities/order,
  const/promoted MIR and coroutine layouts guard existing state. Source maps and
  hygiene remain generation-specific. Initial rlib packets are bound to their
  bundled metadata hash; active calls retain their old body until they return.
- `src/codepen_browser.rs`: JSPI input, frame, patch and cancellation boundaries,
  plus the existing compiled GPUI platform text service inside the WASM module.
- `src/concurrency/scheduler.rs`: bounded ordinary-statement batches avoid
  rescheduling between statements while retaining Miri's actual step semantics.
- `src/intrinsics/mod.rs`: executes integer rotations, unchecked funnel shifts,
  and disjoint bitwise OR directly with native scalar arithmetic, preserving
  Rust's integer width, signed bit patterns, and undefined-behavior checks.
  The corresponding pass and fail fixtures compare against native Rust and
  exercise invalid shift counts and overlapping operands.
- `src/bin/miri.rs`: an opt-in Unix parent-lifetime watchdog prevents a running
  guest from surviving a terminated guide/compiler companion. Compiler-only
  packet export can finalize rustc's incremental query cache. Component MIR
  disables inlining across local function boundaries so later calls can reload.
- `cargo-miri/src/phases.rs`: the opt-in native incremental Codepen path removes
  Cargo's executable/dep-info emission requests before metadata-only Miri startup.
  This keeps the resident VM's compiler contract identical to subsequent exports.

`scripts/codepen/browser.py` builds the pinned compiler source as WASM with the
patches in `browser-rustc.patch`. It links the original procedural macro callbacks
through rustc's macro bridge, caches immutable metadata bytes, and reuses the
single browser thread registry across fresh compiler sessions. Its opt-in Miri
machine hook executes deterministic f32/f64 arithmetic/comparisons with host IEEE
operations; NaNs, remainder, f16/f128 and other unsupported operations retain
rustc's software path. `test-browser-float.rs` compares host results against the
pinned APFloat implementation. Full production-worker probes are separate from
the mocked browser transport tests. The rustc patch resets arena-address-keyed
stable-hash TLS caches between compiler sessions. `browser-paged-metadata.patch`
and its backing-store helpers retain immutable initialized 16 KiB pages, using
the existing opaque encoding and decoder-local scratch for spanning reads.
Mutable compiler output retains its original owned storage. The browser's
content-addressed range assets preserve the entire metadata byte stream.
`browser-paged-hash-map.rs` probes the pinned ODHT definition hash tables directly
from those pages, retaining the original header, key encoding and probe sequence.
It avoids the contiguous table copy while native metadata retains upstream ODHT.
The differential tests compare sparse/dense, colliding, wrapping and short tables
with the pinned implementation and check lazy page initialization.

`browser-interpreter.patch` caches successful call metadata, field/local layouts,
trivially-sized local classification, required-constant checks, and always-live
local sets. Keys include the generic instance and immutable MIR body identity
where revisions can change results. Frame-local handles avoid repeated map
lookups; aggregate caps fall back to ordinary interpretation. Profiling counters
are excluded from normal builds. JSPI cancellation checkpoints sample work at
bounded intervals and set their timestamp after resumption to avoid a yield storm.

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
