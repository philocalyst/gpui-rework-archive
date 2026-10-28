# Combined core, graphics, typed catalog and inspector

Frozen library source `6d77c71c1227bd2609518cc5f3a49e37fc176f82` combines
shared GPU context/layout authority, designer gamut operations, lazy headless
images, and the typed property catalog with its native inspector controls.
The existing native text/layout/presentation work is included. Only evidence
and research documentation changed after this source freeze.

- 43 core tests pass with Cephal layout-cache verification.
- 493 GPUI tests/docs pass; 25 environment-gated cases remain ignored by that
  command. Six explicit native cases below execute separately.
- 182 all-feature Canvas tests/docs pass (four ignored).
- 57 GPU tests/docs pass, including 44 Vulkan pixel oracle cases.
- Strict GPUI/core/GPU/Canvas all-target Clippy and six-library formatting pass.
- Apple AArch64 and Windows MSVC desktop/parallel all-target compilation passes
  through the actual platform adapters, using Rust build-std.
- Five external typed-catalog/component-library cases and nine native-feature
  Hummingbird tests pass.
- Six actual X11 cases pass: target admission and close/drop with a worker-held
  surface lease; the five-policy Todo pixel/input/resize script; all catalog
  inspector controls and invalid-edit recovery; late AT-SPI provider lifecycle;
  real registry Unicode range/selection/editing/actions; and no-session-bus
  presentation.
- The actual Hummingbird executable passes both its headless SQL/public-owner
  transcript and private X11/AT-SPI transcript. The native port uses ReferenceCpu
  in this transcript; GPU cases are qualified separately. SQL resort preserves
  Play identity, keyboard search replaces the text lease, Unicode accessible
  editing selects the new provider, and playback requests database ID44.

Drivers hash library/vendor/application sources and copied actual Cargo
executables around cases, own their Xvfb/private bus, and stop their displays.
Cargo's emitted artifact identifies each executable. Full source guards, raw
logs, driver code and exact commands are retained. A wrong exact header-test
filter ran zero cases; its log is preserved, and the corrected driver requires
one passed case. It did not expose a library failure.

The full native-feature owner ledger reports a plain lazy headless owner at
21 allocations / 5,652 requested retained Rust bytes, and the owner with its 28-node inspector panel (31 total nodes)
at 250 / 64,878 bytes: 59,226 bytes of active-tool increment including text,
font, layout and paint resources. One hundred warm idle operations allocate
nothing. Node 40, Presented 80, Metadata 264, Inspector 24, Handler 16 and WindowAction 4
are unchanged; Runtime 1904 is this full-feature profile (default is 1888).
These are current-thread allocator requests, not RSS or native blank-window
memory. The separately matched lazy-image control proves the removed
1,792,000-byte image allocation; that claim retains its own source pin.

The shipping first-party core count is **28,403** non-test code lines, including
13 build-script lines. It excludes comments, blanks, tests, vendors, tools and
application ports. The preceding 8ea count was 27,696; original GPUI is 56,922 under
the same rule. Features are not yet equivalent and this is not a final-size
prediction. The complete Syn/Tokei report is archived.

The earlier normal parallel Canvas fallback run passes 172 cases/three ignored
after fixing its test-only global font counter race. Relevant Canvas/core/Parley
sources and workspace manifests/lock are unchanged through this freeze; its
original log is supplemental, not a newly executable-guarded capture.

Individual allocation/assembly controls remain source-qualified under
`../gpu-shared-owner`, `../gpu-layout-identity`, `../designer-gamut`,
`../headless-image-lazy` and `../typed-catalog`. The lattice/adaptive gamut
alternatives remain experiments; the fixed solver is integrated. Offline
shader passthrough and acknowledged wrapped text geometry are not part of this
freeze. They continue in isolated worktrees with separate proof/cost gates.

Linux uses Xvfb and Mesa 26.1.4 llvmpipe. Foreign compile checks do not run
AppKit, VoiceOver, UIA, Windows or Wayland. This campaign establishes no hardware
performance, startup latency, GPU residency, screen-reader audit or complete
GPUI/Hummingbird parity. Accessible character/caret geometry and clipping,
IME/clipboard, native HDR negotiation, complete component schemas/contained-owner
editing, Future/stream/optimistic adapters, embedding and the remaining original
application/framework contracts are still required.
