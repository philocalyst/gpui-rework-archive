# Combined source-paint and CPU membership verification

Implementation `de18f040c98dbfc32d33bd1e51515bbf11bce53b` combines registered
source-to-Canvas/GPU paint coupling, exact observer transition qualification,
and the final bounds-only, contained CPU raster membership cache. The commands,
exit statuses and overlapping test counts are in [checks.json](checks.json).
All eleven gates pass. Source hashes cover all tracked first-party crate Rust
and manifests at that implementation commit.

Linux checks include the workspace; parallel Canvas; accessible X11/Wayland
GPUI units; strict all-target X11/Wayland/parallel/Vulkan Clippy; formatting;
actual X11 reactive dimensions/color and Todo pointer/edit/resize/inspection
scripts; actual Vulkan SDR/HDR readbacks; and the native header ledger. The
Todo script covers five renderer policies and compares paint patches with an
independent full GPU renderer. Vulkan is Mesa llvmpipe on Xvfb, not hardware.

Strict desktop Clippy also passes for the actual Apple aarch64 and Windows
MSVC adapters with standard-library cross-builds. These are compile checks,
not native macOS/Windows execution. Earlier Apple checking found an unused
Linux-only test wrapper. The failure log is retained; `09a9a229f1` removed that
wrapper and routed the Linux fixtures through the actual render entry point.
The final checks include both targets and preserve their required compiler env.

Source-paint updates preserve acknowledged geometry and pending full-candidate
metadata. No-op source changes and late accessibility activation cannot invent
an empty delta across an unresolved visual change. The observer regression and
fix are preserved in the [qualified-transition report](../paint-coupling/observer-qualification/manifest.json).
The [paint-coupling report](../paint-coupling/README.md) charges its Metadata,
PaintState, field/sink/edit and GPU-map storage. This path is still O(k) in the
bound destinations and coalesced GPU token gaps can rebuild the full packet.

CPU membership now survives same-alpha paint changes and contained regional
requests. Workers borrow one immutable cache and write disjoint output bands.
Canvas is 488 B, Renderer 872 B, GpuSurface 1080 B, NativeHost 688 B with both
X11/Wayland, and PreparedScene 48 B. The 80-byte lazy CPU scratch allocation
makes active header storage 16 B larger; recording-only Canvas is 64 B smaller.
The [five-way performance report](../../benchmarks/bin-miss/README.md) preserves
cold costs, intermediate losses and the causal assembly controls. This combined
campaign establishes correctness, not native latency/RSS or hardware speedups.

The same compiled accessible X11/Wayland unit executable was subsequently run
with the two exact public-style allocation/header ledger filters (one case
each, both passed). `owner-ledger.log` and `runtime-headers.log` preserve those
outputs. Runtime is 2336 B with accessibility; the plain recording owner
requests 34 allocations / 6776 B, retains 5532 B and peaks at 5692 B in this
allocator-request fixture. This is neither RSS nor native-window storage.
