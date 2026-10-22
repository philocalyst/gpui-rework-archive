# WGPU30.0.1 presentation admission

The complete published package is retained, including both licenses, original
manifest, lock and VCS metadata. `UPSTREAM.json` records the archive checksum and
every published file's SHA-256. The published README's Markdown trailing spaces
are retained verbatim. Registry archive:
<https://static.crates.io/crates/wgpu/wgpu-30.0.1.crate>.

`src/presentation.rs` adds two related native operations:

- A safe handle-only admission query delegates platform/backend/recovery policy
  to HAL. This performs no instance/adapter/device construction or driver load.
- A target-bound adapter request owns the actual safe Surface lease, supplies
  it as `compatible_surface`, and validates the intended format, color
  space, alpha mode and concrete presentation mode before returning the paired
  unconfigured Surface/Adapter. No device, pipeline, swapchain configuration,
  acquisition or presentation occurs in this helper.

This is an optional opportunistic admission boundary. Existing explicit GPU APIs
and their backend negotiation remain available. A cheap device-file hint is not
proof of hardware or display compatibility. Software-only candidates require an
adapter probe to identify and must be rejected before requesting a device or
pipeline when used for automatic hardware upgrades.

The fork's policy lives in the matching HAL presentation module. Xlib/Xcb Vulkan
targets permit early background surface proof. The safe Surface API retains its
Arc window producer until after backend surface destruction; no borrowed/raw
handle lifetime workaround is introduced. Its existing SurfaceTarget contract
imposes main-thread creation on macOS/Metal, not Linux X11. Winit initializes
XInitThreads and retains a Send+Sync XConnection; X11 set_visible(false) sends
and flushes XUnmapWindow. A cancelled driver call cannot be interrupted; the
native owner hides/retires the visible X11 target immediately while its safe
resource lease can outlive the owner until that call returns. A minimal native
host Drop guard also hides/cancels on early failure or unwind, without relying on
CloseRequested/Exiting or joining the worker; normal field drops retire the owner.

Metal retains headless device/renderer preparation and late event-thread layer
attachment. Its target compatibility therefore remains unproved until after
pipeline work. Existing HAL ownership of injected CAMetalLayer leases is
preserved; pending pipelines never attach a covering Metal layer.

Wayland also retains the existing window-free worker/late surface path. Winit's
Wayland set_visible is currently a no-op, so retaining its target during a slow
driver call cannot promise prompt unmapping on close. A follow-up needs a legal
null-buffer unmap/reconfigure lifecycle inside Winit/WSI, with role/configure,
resize, cancellation and CPU-recovery tests. Destroying raw Wayland proxies or
tracking only a hidden flag would not establish that contract.

Windows same-HWND software recovery is unavailable after successful DXGI flip
presentation; HAL reports this before graphics construction. This does not ban
explicit DX12 rendering or claim all possible Windows composition targets have
that restriction. A distinct presentation target needs separate lifecycle proof.

The proof is tied to one live surface/adapter cohort. Configure still validates
the current dimensions; no proof survives target recreation or device loss.
The consumer commits ownership only after successfully presenting its current
frame. Neither this helper nor cheap admission acknowledges a frame.
