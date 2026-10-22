# wgpu-hal 30.0.1

Published archive: https://static.crates.io/crates/wgpu-hal/wgpu-hal-30.0.1.crate

SHA-256: `b6b7fb58561a792bc237628ba0792e332de418fefe145f13b5ed8201e6d52f58`.
Upstream commit: `40f4a34ebaf56f9a046231f54125ad046239d3f3`, directory
`wgpu-hal`. The full package, licenses, original manifest and VCS provenance
are retained. Its published standalone lock is upstream data; the containing
reactivity workspace lock resolves this path patch and its local dependency.

The local Metal repair from 29.0.4 is rebased onto this release: retain an
explicit cleanup lease only for layers injected by raw-window-metal. Surface
destruction detaches those layers on the main thread, asynchronously when a
worker drops the surface. Caller-owned and pre-existing layers stay attached.
The two manifests enable dispatch2 and CATransaction for that boundary. The
existing `tests/apple_layers.rs` main-thread harness is preserved unchanged.

Linux strict checks, all 40 Vulkan oracle tests, actual X11 Todo and inspector
presentation tests, and Apple AArch64/Windows MSVC desktop all-target compile
checks pass. Cross-compilation does not execute the AppKit harness; it still
requires macOS through the existing presenter test package. See
`../../evidence/wgpu30-upgrade/` for source hashes and unaltered logs.
