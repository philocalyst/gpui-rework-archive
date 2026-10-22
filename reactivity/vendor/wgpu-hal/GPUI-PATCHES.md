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

`src/presentation.rs` additionally owns cheap automatic presentation admission:
Linux render-device filesystem hints, backend masks, target preparation order,
and the Win32 same-HWND GDI recovery exclusion. The query never constructs a
graphics instance or loads a driver. Xlib/Xcb use Vulkan with early worker-safe
unconfigured surface proof; Metal and Wayland keep late target creation. Wayland
needs a qualified unmap/reconfigure lifecycle before a worker may retain its
window through an uninterruptible driver call. The paired WGPU boundary and
remaining platform limits are documented in `../wgpu/GPUI-PATCHES.md`.

Vulkan stage-local shader modules now have scoped ownership. Previously render,
compute and ray-tracing pipeline construction destroyed these modules only
after successful driver creation; an earlier stage or driver error skipped the
cleanup. `CompiledStage` now borrows the device and owns a temporary-module
guard. Reusable `Raw` shader modules retain their original owner and lifetime.
Entry-point CString validation precedes native module creation. No renderer,
window or device ownership field or reference count is added. The dispatch
boundary regression covers success, early returns and unwind; it is a fake
device lifetime test, separate from actual Vulkan rendering conformance.
The [Vulkan lifetime rule](https://docs.vulkan.org/refpages/latest/refpages/source/vkDestroyShaderModule.html)
permits destroying shader modules while their created pipelines remain in use.
