# Native-default preparation for GPUI `724ece73`

This directory prepares the native-default comparison approved for the frozen
GPUI source `724ece73cb665a1f6d83e97ae7d431eee11a887a` and the pinned peers
listed in `../../../../docs/research-core.md`. Its only workloads are eager 0,
eager 1,000, and virtual 250,000 rows. Each rebuilt binary must pass the exact
pixel and geometry preflight before any latency or memory capture. The preflight
script writes a unique evidence directory and refuses to overwrite one.

The current GPUI build uses feature `x11`, renderer selection `Auto`, and a
separate Cargo target directory. NanoUI is Linux CPU/Cairo and MyGo uses its
default GTK renderer. These are native Linux applications, but their renderer
implementations are not equivalent. GPUI uses bundled Noto Sans; the GTK-based
peers select the staged DejaVu Sans face. AccessKit is compiled into the GPUI
binary and MyGo includes GTK/ATK; NanoUI's pinned version has no accessibility
implementation. Compiled support does not establish that an AT-SPI consumer is
active for a run. Report any session-bus/AT probe separately from the app
preflight and timing.

The output pixel endpoint is the X server drawable on Xvfb, not compositor
presentation, vblank, scanout, or photons. Keep `:94` reserved for root's native
tests; use a private Xvfb display for preparation. Do not start timed captures
until root has approved the full verification gates and a quiet window.

Build source and fixture hashes, toolchains, and final binary hash belong in the
preflight record. The generated screenshots and observer logs are evidence, not
timing results. The observer's predicted realized virtual-row counts are
source-derived expectations, not instrumentation of each framework's internal
tree.

## Rebuild commands

GPUI is built from a detached checkout at the pin above with the fixture copied
to `reactivity/crates/gpui/examples/luna_bench.rs`:

```sh
source /tmp/gpui-native-env.sh
export CARGO_TARGET_DIR=/tmp/gpui-luna-current-native-target
export CARGO_BUILD_JOBS=1
cd /root/gpui-current-native-bench/reactivity
cargo build --offline --release -p gpui --example luna_bench --features x11
```

The comparator checkouts are pinned and their fixture sources are copied from
the benchmark's `fixtures/` directory. With the pinned Go 1.27.1 and Zig 0.17.0
toolchains:

```sh
cd /root/gpui-bench-luna/comparators/mygo
/tmp/gpui-bench-toolchains/go/bin/go build -trimpath -o /tmp/gpui-luna-mygo-native ./examples/luna-bench
cd /root/gpui-bench-luna/comparators/nanoui
/tmp/gpui-bench-toolchains/zig/zig build -Doptimize=ReleaseFast --prefix /tmp/gpui-luna-nanoui-output
```

The preflight script checks the source pins, copied fixture bytes, and exact
binary SHA-256s before launching anything. Its unique `LUNA_PREFLIGHT_ID`
directory preserves the screenshot and log for every app/workload pair.
