# Native destination-invalidation boundary

**Recommendation:** preserve `WindowEvent::RedrawRequested` as-is and add one small Winit query that exposes a *latched, backend-qualified invalidation hint* to the host. For the first implementation, only X11 should return a known result. macOS, Windows, Wayland, and other backends return `Unknown`, which keeps current full-surface presentation. This avoids a new public event variant and its exhaustive-match breakage, avoids a new Winit event queue or side map, and lets the GPUI host keep the hint sticky until a successful full present. It is a proposal only; no production code changed.

Suggested Winit boundary:

```rust
enum RedrawInvalidation {
    /// This backend has no complete invalidation signal for the current surface.
    Unknown,
    /// This backend tracks all destination invalidations; no new one was observed since the last take.
    KnownClear,
    /// A destination invalidation was observed since the last take.
    Invalidated,
}

Window::take_redraw_invalidation(&self) -> RedrawInvalidation
```

The type can be crate-specific rather than public if the vendored host integration offers a private adapter. If GPUI must call across the Winit crate boundary, a small public core method is less intrusive than an additive `WindowEvent` variant: application `match` statements remain unchanged, and the return type states that `KnownClear` is evidence only for a backend that can prove it. It exposes no X11 types or platform-specific event to app code. `None`/`Some(bool)` is a compact equivalent, but the named three-state enum makes the unknown-versus-known-clear distinction harder to misuse.

## Source finding: why a hint is needed

The pinned Winit is 0.30.13 at upstream commit [`e9809ef54b18499bb4f2cac945719ecc2a61061b`](https://github.com/rust-windowing/winit/tree/e9809ef54b18499bb4f2cac945719ecc2a61061b). Its public [`WindowEvent::RedrawRequested`](https://github.com/rust-windowing/winit/blob/e9809ef54b18499bb4f2cac945719ecc2a61061b/src/event.rs) intentionally combines OS invalidation and an application `Window::request_redraw`; the event docs say Winit aggregates duplicate redraw requests. The public [`request_redraw` API](https://github.com/rust-windowing/winit/blob/e9809ef54b18499bb4f2cac945719ecc2a61061b/src/window.rs) also says redraw delivery timing and ordering vary by platform.

The pinned X11 backend has exactly the lost distinction at two layers. Its `EventProcessor::expose` observes XExpose only after the final rectangle (`count == 0`) and synthesizes an ordinary `RedrawRequested` ([local source](../vendor/winit/src/platform_impl/linux/x11/event_processor.rs#L880-L893)). `drain_events` routes every such event through the same `redraw_sender` used by `Window::request_redraw` ([local source](../vendor/winit/src/platform_impl/linux/x11/mod.rs#L577-L597); request sender at [`window.rs`](../vendor/winit/src/platform_impl/linux/x11/window.rs#L1838-L1846)). At the end of the event-poll phase, Winit drains that channel into a `HashSet<WindowId>` and dispatches one redraw per window ([`mod.rs`](../vendor/winit/src/platform_impl/linux/x11/mod.rs#L554-L569)). A redraw from an expose and an explicit redraw therefore coalesce exactly as the same event. A cause bit must survive independently of the request queue's ID-only deduplication.

Winit already selects X11 `EXPOSURE`, `STRUCTURE_NOTIFY`, and `VISIBILITY_CHANGE` on each created window ([`window.rs`](../vendor/winit/src/platform_impl/linux/x11/window.rs#L260-L275)). The X11 protocol defines Expose as being generated when regions have no valid contents under the stated visibility/backing-store conditions, sends the rectangles as a contiguous series for each exposure action, and defines `count == 0` as no more Expose events for that action ([X11 protocol, Expose event](https://xorg.freedesktop.org/archive/current/doc/xproto/x11protocol.pdf)). Thus the existing final-event point is an appropriate place to latch one “destination may be invalid” bit. Winit discards the X/Y/width/height at that point, so this first API can only trigger a full-surface server copy; preserving the expose rectangle is a later, finer optimization.

The GPUI software presenter separates the client-buffer repair state from server-window validity. `SurfaceDamage` retains scene transitions for old or aged CPU buffers; `render_preserved_bgrx` returns the scene damage and repairs the client image. The native loop then calls full `buffer.present()` ([`native.rs`](../crates/gpui/src/native.rs#L549-L557)), and Softbuffer's X11 backend expands that into a full-surface `XShmPutImage` ([`x11.rs`](../vendor/softbuffer/src/backends/x11.rs#L563-L574)). Forwarding only scene damage could leave an uncovered but unchanged part of the server window stale after Expose. Host-buffer age is not destination-window validity.

## Ownership and race protocol

The proposed evidence has two owners with separate lifetimes:

1. **Winit owns events observed but not yet consumed.** Put `expose_pending` in the existing X11 `SharedState` that is already behind a per-window mutex ([definition](../vendor/winit/src/platform_impl/linux/x11/window.rs#L39-L66)). Set it at the final Expose in `EventProcessor::expose`, before the redraw request can be coalesced. The query takes/clears this bit under that mutex while running on the event-loop owner. This adds no window, channel, `HashMap`, heap allocation, or queued payload. It may add a byte or use existing alignment; check actual `size_of::<SharedState>()` before claiming a zero-byte footprint. Winit has platform-specific bitflag fields on Windows, but not an existing cross-platform invalidation bitmap; do not misdescribe those Windows flags as reusable X11 storage.
2. **The host owns destination truth across attempts.** Add one sticky `destination_valid`/`force_full_present` bit to `NativeHost` (which currently has `occluded: bool`; [`native.rs`](../crates/gpui/src/native.rs#L293-L318)). Start with `force_full = true`; resize, scale change, surface/device recreation, suspension/resume, and any backend `Unknown` redraw set it true. On each X11 redraw, merge `Invalidated` into it. Keep it set through rendering and any failed submission; clear it only after an accepted full-frame native present. If a partial submission fails, mark destination unknown before any retry. After a successful partial present, a previously valid destination stays valid.

The Winit `take` clears only its observed-event bit, never the host's sticky repair state. Both execute on the same event-loop owner. X events are drained before Winit drains/coalesces the redraw channel, so when Expose is already in that polled X event batch its bit is set before the corresponding redraw callback. If another client causes an exposure after the poll has ended, Winit observes it in a later poll and the later redraw forces full repair. The event loop cannot process X events concurrently while GPUI renders, so there is no data race in either bool. An event generated during rendering may be handled only on the next iteration; this means the current submitted frame could precede the repair, but once the Expose is delivered the next frame must fully repair. Do not claim atomicity against asynchronous window-manager events or monitor scanout.

On non-X11 backends, `Unknown` means the host uses the existing full-present behavior. That is deliberate until each backend proves equivalent negative evidence. Windows Winit drives redraw from `WM_PAINT`, which is used both for app-requested paint and OS update regions ([Winit docs](https://github.com/rust-windowing/winit/blob/e9809ef54b18499bb4f2cac945719ecc2a61061b/src/window.rs), [Microsoft painting contract](https://learn.microsoft.com/en-us/windows/win32/learnwin32/painting-the-window)); macOS uses AppKit invalidation and redraw scheduling but has no equivalent tracked invalidation signal in the reviewed Winit path ([Apple `NSView` invalidation docs](https://developer.apple.com/documentation/appkit/nsview/invalidating)); Wayland frame callbacks throttle redraw and do not themselves tell the client that a destination rectangle is invalid ([Wayland protocol](https://wayland.freedesktop.org/docs/html/apa.html)). Returning `KnownClear` on those backends without more source work would be an unsupported guarantee.

## Why prefer a take-query over a new event variant

An additive event such as `SurfaceContentsInvalidated` is semantically clear and works for immediate host state updates. However, Winit's `WindowEvent` is not marked `non_exhaustive`; adding a new variant forces downstream exhaustive matches to change. It also still needs correct ordering with the coalesced redraw request, and the GPUI host must retain the invalidation through any failed present. An inline `RedrawRequested { invalidated: bool }` payload is another option, but X11's existing `HashSet<WindowId>` coalescer would have to become a reason-OR aggregation. The take-query keeps the event and deduplicator untouched and uses the already-owned per-window X11 state to retain exactly one bit until the next draw.

The take-query itself must return three states. Returning only `bool` would let `false` accidentally mean either “X11 proved clear” or “this is macOS/Windows/Wayland and Winit has no evidence.” A method that returns `Option<bool>` is adequate if its documentation is strict: `Some(false)` is a complete negative only for implementations that track all relevant invalidations; `None` means use full presentation. Prefer the named enum if it remains small.

## Untimed Xvfb event probe

I ran a minimal direct-Xlib probe on a private Xvfb 21.1.24 at `:97` (800×600×24; no window manager). It selected `ExposureMask | StructureNotifyMask | VisibilityChangeMask`, mapped a 320×200 window, drained events, unmapped it, and mapped it again. Source: [`probe.c`](../benchmarks/x11-invalidation-probe/probe.c). Raw output: [`trace-xvfb-21.1.24.txt`](../benchmarks/x11-invalidation-probe/trace-xvfb-21.1.24.txt).

```text
initial-map MapNotify
initial-map VisibilityNotify state=0
initial-map Expose x=0 y=0 w=320 h=200 count=0
unmap UnmapNotify
remap MapNotify
remap VisibilityNotify state=0
remap Expose x=0 y=0 w=320 h=200 count=0
```

This is a protocol behavior check on Xvfb, not a timing measurement and not a test of Winit's queue. The source audit establishes Winit's event coalescing; this probe confirms initial/remap exposure and event order on the available X server. It does not establish that all Xorg compositing configurations send identical map/visibility traffic; use the X11 protocol, not this one server trace, for the general rule.

The actual build used the session's pinned Clang 21.1.8 wrapper and X11 1.8.13 headers/library plus xorgproto 2025.1: `clang probe.c -I/nix/store/2mcjx364ls9id3ngdjxd707j2az2aid2-libx11-1.8.13-dev/include -I/nix/store/zhqvgsbq8ridrhr67qbxnq8rrbx6hvfj-xorgproto-2025.1/include -L/nix/store/4wkicwb2jx5h63d79g5qyp9kn4vx27yb-libx11-1.8.13/lib -lX11 -o /tmp/gpui-x11-invalidation-probe`, then `DISPLAY=:97 /tmp/gpui-x11-invalidation-probe`. Xvfb command: `/nix/store/iw8dx6lhrkdc5wzszjzqzl677y68y88r-xvfb-21.1.24/bin/Xvfb :97 -screen 0 800x600x24 -nolisten tcp -ac`. The private server was stopped after collecting the trace.

## Required host/presenter tests

Keep renderer damage and destination invalidation as independent inputs. A useful host decision is:

```text
full = first_frame || resize_or_surface_loss || backend_unknown
       || destination_invalidated || prior_submit_failed
present_region = full ? whole_surface : renderer_damage
```

Before implementation, pin these protocol tests:

1. **Initial map:** host starts force-full; first full successful submit makes destination valid. Initial Xvfb trace above shows Map/Visibility/Expose before first contents.
2. **Normal app redraw:** known-valid X11 destination plus renderer damage produces a partial submit. Duplicate app redraw requests still produce one draw.
3. **Expose coalesced with own redraw:** enqueue an explicit request, then deliver one or multiple Expose rectangles before Winit drains redraw requests; get exactly one callback, and `Invalidated` must survive ID deduplication.
4. **Expose series:** one or more `count > 0` rectangles followed by `count == 0` latch invalidation once; two distinct exposure actions before draw still force only one full repair.
5. **Failure and retry:** consuming Winit's bit followed by failed present leaves host force-full set; next attempt submits full. A partial-present error invalidates destination even if the old contents were assumed valid.
6. **Expose during a draw:** process the event only after current synchronous draw returns; next event iteration's draw must force full. Validate final server pixels against a full-frame oracle.
7. **Resize, scale, hidden/unmapped, surface/device recreation:** full repair is required regardless of renderer damage; old scene damage history cannot certify the server destination.
8. **Unsupported backend:** `Unknown` always takes full-present fallback. Do not turn off fallback until native Win32/macOS/Wayland tests establish a complete negative-invalidation contract.
9. **X11 `KnownClear`:** only after a previous successful full frame, no resize/loss, and no pending final Expose; test obscuration/uncover, map/unmap, and multiple queued redraw causes.

The native oracle must inspect the actual target window after the server processes the draw, not only the client's Softbuffer buffer. The X server destination and client's retained image are distinct resources.

## Platform boundary verdict

The smallest useful boundary is a *queryable, latched invalidation fact*, not platform event details or a second graphics buffer. On X11, it is derived from the existing `EXPOSURE` subscription and stored in the current per-window `SharedState`; application redraw coalescing remains untouched. GPUI owns the higher-level rule that a full frame is needed until a successful full native present. All other platforms keep the current full present until separately proven. This creates a measurable X11-only route to partial transfer without changing the app-facing event loop or weakening the surface-damage correctness contract.
