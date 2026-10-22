This public offscreen fixture freezes the owned renderer control before the shared-context refactor. `owned.rs` remains unchanged when the shared case is added. It checks different window dimensions, packets, image identities/pixels and glyph masks against Canvas pixels, then checks retained redraw bytes. It creates no native windows and makes no native multiwindow claim.

Run each mode/count in a fresh process, with the native build environment sourced:

```sh
CARGO_TARGET_DIR=/tmp/gpui-shared-gpu-sol-target CARGO_BUILD_JOBS=2 cargo build --release --offline --manifest-path benchmarks/gpu-owner/Cargo.toml --bin owned
/tmp/gpui-shared-gpu-sol-target/release/owned same-device 1
/tmp/gpui-shared-gpu-sol-target/release/owned same-device 2
/tmp/gpui-shared-gpu-sol-target/release/owned same-device 8
```

Also run `per-device` at all three counts. That is the ordinary request-per-window case. The stronger `same-device` control uses one device and queue with multiple existing `Renderer::new` calls; it already avoids multiple devices but repeats shader/pipeline construction.

Instance/adapter discovery and Canvas/font/scene ownership are outside the measured GPU-owner scope. Cold includes device requests, full renderer ownership, the window Vec allocation, and output texture/view ownership. Warm includes each first full render and an indefinite device poll. Every window keeps its buffers, atlas, images, scratch and packet. The Vec header is reported separately as stack storage; each Window header is already inside the measured Vec allocation. Combined peak is `max(cold_peak, cold_retained + warm_peak)`, not the sum of two peaks. The final drop observation also includes releases caused by the later unmeasured readback checks and is not a balanced leak detector.

`allocation-counter` measures Rust allocator requests on the calling thread only. It excludes driver C allocations, background worker allocation and GPU allocations. Values are net current-thread accounting, not process RSS or full GPU residency. Device polls do not establish that every background Rust destructor runs on this thread. No elapsed-time numbers are collected.

Build with `--features counts` into a separate target directory for native live-object diagnostics. This changes WGPU instrumentation and is not used for default-feature allocation comparisons. Native counters measure live objects, not historical constructor calls. The fixture reports successful constructor calls separately: one device request per selected device, and one module/pipeline construction per successful renderer constructor, as established by the pinned constructor source. Temporary shader handles may already have been released before live counters are sampled.
