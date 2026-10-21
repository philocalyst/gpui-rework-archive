# Combined graphics, scroll and public semantics

[checks.json](checks.json) pins implementation `f01947e679` and records eleven
successful gates after integrating literal Flex, borrowed semantic streaming,
ordinary scroll panes and rounded geometry. [source-sha256.json](source-sha256.json)
records the exact first-party Rust/configuration files checked against that pin.

The default workspace passes 568 cases/doctests. Accessible Linux native unit
tests pass 115; parallel Canvas passes 123; GPU passes seven unit tests and 33
actual Vulkan readbacks. These suites overlap; their counts are not additive.
Strict all-target Clippy covers accessible X11/Wayland, parallel Canvas and Vulkan
fixtures. First-party formatting and the actual native header ledger pass.

Actual X11 Todo runs the renderer policies, pointer/keyboard edits, resize,
suspend/recovery, packet replay and rounded-shape GPU-to-CPU fallback. The
ordinary-scroll script exercises both wheel axes, reveal, pointer activation,
resize and resume, comparing complete server pixels with the CPU oracle.
Vulkan uses Mesa llvmpipe. These are execution/correctness checks, not hardware
performance, scanout latency or memory-floor measurements.

Strict all-target cross-compilation also passes for the actual macOS aarch64
and Windows MSVC desktop adapters. Their OS execution and Wayland execution
remain separate gates. A Parley dependency deprecation warning remains visible
in the raw logs; first-party strict Clippy passes.

The measured headers are Node40, Presented80, Runtime2384, El176, Style88 and
Canvas552 bytes. The test NativeHost with both X11 and Wayland features is 688
bytes; the X11-only historical 680-byte figure is a different configuration.
Rounded geometry adds an eight-byte optional pointer only to existing Metadata
owners. The scroll evidence separately charges the first virtual-list cohort's
104-byte retained increase. See the isolated [scroll](../ordinary-scroll/README.md)
and [rounded](../rounded-geometry/README.md) reports for allocation details and
numerical limits. No universal CPU/GPU rounded sample-membership equivalence is
claimed.

An initial unqualified `--exact` header filter executed zero tests. It was
excluded and replaced by the fully qualified `layout-final` gate, which executes
one case. The manifest records the excluded attempt explicitly.
