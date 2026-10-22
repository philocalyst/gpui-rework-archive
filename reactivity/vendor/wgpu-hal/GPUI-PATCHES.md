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

The authored Vulkan `Device::shader_artifact_checks` query reads the exact live
device's Naga options and actual enabled storage-class extension where needed.
It admits only represented buffer/image Restrict-or-Unchecked policies with
local index Restrict, loop/integer-division guards, no coordinate adjustment,
and the fixed revision-two contract. Separate-entry-point workarounds remain
enabled: the consumer generates one independently validated module per stage.
It does not change native shader ownership, submission, resource lifetime or
code-generation options. Raw modules therefore retain their VkShaderModule
payload through core pipeline leases; checked Intermediate modules instead
destroy their temporary native modules after pipeline compilation. This is an
explicit artifact-route lifetime cost, not a GPU-memory reduction claim.


## Static SPIR-V stage ownership

This branch first applies exactly the Vulkan device.rs stage-ownership delta from
root ffb4b8f58035330f4034a6891ec87de6574195c0, retaining this branch's independent
artifact policy query. CompiledStage borrows the Device and destroys only its
unique temporary module on every success/error/unwind exit. Ordinary Raw module
handles remain reusable and owned by their HAL shader wrapper.

The optional shader-artifacts feature adds StaticSpirV(&'static [u32]) input and
Vulkan wrapper variants; feature-off enum shapes remain upstream. Vulkan stores
only the immutable slice recipe. Each stage use creates one native shader module
with no debug-name operation, then gives it to the borrowed CompiledStage owner.
The CString is constructed before native creation. Temporary native modules retire
after synchronous graphics/compute/ray creation, including later-stage or driver
failure. Shader-wrapper destruction has no native work for static recipes. Other
backends explicitly return a compilation error for this unsupported input; Core
already rejects them through normal error scopes before HAL.

Repeated/concurrent pipeline construction creates independent temporary modules;
static storage neither adds shared mutable state nor relaxes Vulkan host external
synchronization. HAL pipeline caches use empty creation flags (internally
synchronized Vulkan cache); imported/external cache synchronization duties remain
with their existing callers. The compositor uses cache None. Ray creation currently
passes a null deferred operation and completes synchronously: a future deferred
operation must retain all stage inputs/owners until completion before using this
local-owner implementation. No maintenance5/GPL/inline-pNext path is added.
