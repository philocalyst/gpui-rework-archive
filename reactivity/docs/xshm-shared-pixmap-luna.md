# XShm shared-pixmap audit

**Disposition (source audit, 2026-10-21): do not adopt `XShmCreatePixmap` as a general memory or copy-elimination optimization.** The pinned X11 presenter already renders into a client-mapped shared-memory segment and submits it with `XShmPutImage`, so image bytes do not travel through the X socket. The server still copies submitted pixels into the window drawable. Replacing that request with `CopyArea` from an XShm pixmap still copies pixels to the window, and a shared-memory pixmap may make that copy slower by preventing the server from caching the source pixmap in video memory. The remaining plausible experiment is to present the renderer's existing exact damage rectangles instead of a full surface, but the current Winit X11 path does not distinguish an Expose redraw from an ordinary redraw. Until that invalidation cause is represented, full-window presentation is the safe repair path.

This is a bounded source audit, not a runtime capability or performance result. No X server shared-pixmap probe, CPU capture, RSS/PSS attribution, or hardware comparison was run. In particular, the local Xvfb shared-pixmap capability is unknown.

## What the pinned implementation owns

The presenter is the vendored `softbuffer 0.4.8`, upstream commit [`d871852faa1137d4615b99b9ad31c3ba80f345b5`](https://github.com/rust-windowing/softbuffer/tree/d871852faa1137d4615b99b9ad31c3ba80f345b5), crate archive SHA-256 `aac18da81ebbf05109ab275b157c22a653bb3c12cf884450179942f81bcbf6c3`. The exact downstream file is [`x11.rs`](../vendor/softbuffer/src/backends/x11.rs); the local archive/presenter pin and patch ledger is [`PRESENTER_PATCHES.md`](../vendor/PRESENTER_PATCHES.md).

For the SHM path, each X11 surface retains one `ShmSegment`: an fd-backed allocation, a client `mmap`, its capacity, and an X server segment ID. Allocation rounds up to a power of two and reuses capacity across frames. The X server attaches to the fd-backed segment. The caller writes the mapped words; `XShmPutImage` sends the requested rectangle from that segment to the **window drawable**. The request carries offsets and dimensions, not a copy of the pixel payload in the X protocol stream. See `ShmSegment::new`/`alloc_segment` and `present_with_damage` in the pinned file (local lines 472–574, 650–682, 764–852).

The path has a real reuse barrier. After `XShmPutImage`, Softbuffer queues a small `GetInputFocus` request and waits for its reply before returning mutable access to the segment. X request ordering makes that reply a server-processing barrier for earlier image requests. This keeps client writes from racing a server read; it does not certify compositor completion, display scanout, or when pixels became visible. The safety contract and fence are explicit in `ShmBuffer::done_processing`, `begin_wait`/`finish_wait`, and `buffer_mut` (local lines 174–186, 340–350, 612–640).

On a cold surface, the full-size segment is allocated lazily on first `buffer_mut`; if dimensions change and existing power-of-two capacity is too small, it is replaced. The segment size is approximately `4 × width × height`, rounded up, plus page/metadata overhead; its pages are mapped in both client and server address spaces but can be physically shared. The window drawable is a distinct destination. Thus the current source-side allocation is already shared; XShm pixmap is not a way to remove an extra app-side full-frame copy because this code has no such second CPU pixel buffer in the SHM branch. The server-side window destination/copy remains.

The fallback is different: `Buffer::Wire(PixelBuffer)` owns a client `Vec<u32>` and `PutImage` sends the full image bytes through the X connection. Softbuffer's `present_with_damage` sends full-window `PutImage` on this branch, while the SHM branch iterates the supplied damage rectangles. `present()` itself expands to one full-surface rectangle. The display capability probe at local lines 933–959 creates, attaches, and detaches a small SHM fd segment; it does **not** query `XShmQueryVersion(..., pixmaps)` and does not establish support for shared pixmaps.

The corresponding GPUI CPU path is [`native.rs`](../crates/gpui/src/native.rs#L549): it asks `Win::render_preserved_bgrx` for the current content damage and buffer-age repair, then calls `buffer.present()` (local line 555), which submits full surface. [`SurfaceDamage`](../crates/gpui/src/runtime.rs#L553) retains three transitions and forces a complete render when buffer age is unknown or too old. It ensures the client buffer is coherent; it does not mean the server window's backing drawable is coherent after an Expose.

## Why a shared pixmap does not remove the current transfer

X.org's MIT-SHM documentation distinguishes shared-memory images from shared-memory pixmaps. `XShmQueryVersion` reports the separate `pixmaps` capability. A shared pixmap must use the server's single shared-pixmap image format, obtained from `XShmPixmapFormat`; its bit depth, bytes per line and layout must match. Some servers cannot support this because their pixmaps live in graphics hardware rather than regular virtual memory. [The MIT-SHM specification](https://xorg.freedesktop.org/archive/X11R7.7/doc/xextproto/shm.html) documents both the capability query and format/lifetime requirements.

An X pixmap is not a displayed surface. X.org's [pixmap documentation](https://www.x.org/guide/concepts/) says pixmaps are offscreen drawables and are copied to a window for display, including by `CopyArea`. It also warns that shared-memory pixmaps may prevent moving the pixmap into a faster video-memory cache, making copies to the window slower. The official NVIDIA X driver documentation gives a concrete counterexample: its `AllowSHMPixmaps` option defaults off because shared pixmaps prevent driver optimizations and can degrade performance, while ordinary MIT-SHM `XShmPutImage` remains available ([driver documentation](https://download.nvidia.com/XFree86/Linux-x86/256.25/README/xconfigoptions.html#sect-4.2.6)).

Therefore:

| Path | Client-side source | Per-frame submission | Window destination | Likely eliminated work |
|---|---|---|---|---|
| Current SHM | mapped segment, shared with X server | `XShmPutImage` request(s), no image payload over socket | still receives source pixels | avoids client-to-server socket payload/copy |
| SHM pixmap + `CopyArea` | same shared segment, now also a pixmap | `CopyArea` request(s), no pixel payload | still receives source pixels | can avoid XImage/PutImage interpretation; does not by itself remove the window copy |
| Wire fallback | client `Vec<u32>` | `PutImage` with pixel payload | still receives source pixels | none of the SHM transport savings |

This does not rule out a particular server/driver benefiting from shared-pixmap command processing. It does reject a blanket claim of fewer full-size allocations or zero-copy screen presentation. On Xorg, `XShmCreatePixmap` is capability-gated and may be slower. An adoption experiment would need to compare both paths on the named X server and GPU, count actual `CopyArea`/`ShmPutImage` bytes/regions, validate correctness across Expose/resize/occlusion, and separately account client heap, mapped pages, X server resident pages, and window backing.

## A more direct candidate: pass surface damage through

Softbuffer already implements `present_with_damage` for the SHM path. The current GPUI owner computes exact scene damage and already repairs old buffer contents from buffer-age history. Forwarding those same rectangles could reduce X-server writes to the window drawable without adding a pixmap or a full-frame copy. Windows' Softbuffer presenter also loops over those rectangles with `BitBlt`; Wayland commits buffer damage when supported. This can reduce copied area; it does not guarantee that a compositor, driver, or scanout engine does less work.

There is a concrete correctness blocker. Winit 0.30.13's X11 event processor collapses a series of `Expose` events into an ordinary `WindowEvent::RedrawRequested` when the last event arrives; it drops the expose rectangle and cause ([vendored source](../vendor/winit/src/platform_impl/linux/x11/event_processor.rs#L880-L893), upstream pin [`e9809ef54b18499bb4f2cac945719ecc2a61061b`](https://github.com/rust-windowing/winit/tree/e9809ef54b18499bb4f2cac945719ecc2a61061b)). If GPUI receives only a scene-damage region and copies only that region after the window backing was lost/uncovered, the unchanged areas may stay undefined or stale. The CPU source buffer can be perfect while the destination window is wrong.

Small safe choices, in order:

1. Keep current full present. It is the correct fallback while expose cause is unavailable.
2. Add a narrow host invalidation signal that marks destination backing unknown on X11 Expose, surface recreation, resize, and other loss events; on that redraw, submit full damage. This retains partial updates for ordinary scene changes. Winit may need an internal platform event or a host callback because its public redraw event intentionally coalesces redraw causes.
3. Only after that contract exists, pass the union of the present's complete damage to `present_with_damage`, falling back to full rect when history is unknown, region count/area is too large, or presenter capability is absent.

The current damage rectangles already account for buffer-age repair in the **source buffer**; they do not automatically account for invalid destination-window pixels. Tests must separately model an old source buffer and a lost window drawable. Useful hostile cases include: Expose after obscuring an unchanged window; Expose coincident with a small text edit; resize then expose; two or more queued Expose rectangles; a full scene update coalesced with expose; SHM unavailable; and a presenter backend that ignores or falls back from region damage. Verify final window pixels against a full-frame oracle, not just the client framebuffer.

## Platform comparison: shared backing still has a lease

| Backend in pinned Softbuffer source | Writable source storage | Presentation/reuse contract | What “shared” does not prove |
|---|---|---|---|
| X11 SHM | one fd-backed `mmap`, attached by X server | `XShmPutImage`, then an ordered server reply before next client write | no scanout fence; server window drawable remains separate |
| Wayland `wl_shm` | temp file mapped in client; `wl_shm_pool` maps same bytes in compositor | two buffers; do not mutate a buffer until `wl_buffer.release` | no promise compositor avoids texture upload/copy/composition |
| Windows GDI | `CreateDIBSection` writable pointer retained in DIB | damage rectangles copied to window DC by `BitBlt` | DIB source is not the window drawable; it is not a direct-display guarantee |
| macOS Core Graphics | fresh `Vec<u32>` each `buffer_mut`; boxed slice transferred to `CGDataProvider` and released by callback | Core Graphics provider/image/layer retains bytes for consumer lifetime; damage argument is ignored and full image is presented | ownership handoff avoids an extra Rust intermediate copy; does not prove Core Animation/GPU/display has no upload/copy |

The platform code is locally pinned with Softbuffer at the table above. Wayland's [protocol contract](https://wayland.freedesktop.org/docs/html/apa.html) explicitly says a client may reuse a buffer only after the compositor's release event. The Windows API defines `CreateDIBSection` as a writable pointer to bitmap bits ([Microsoft documentation](https://learn.microsoft.com/en-us/windows/win32/api/wingdi/nf-wingdi-createdibsection)); the local presenter still uses `BitBlt`. Apple describes [IOSurface](https://developer.apple.com/documentation/iosurface) as a framebuffer shareable across process boundaries, and warns that a CVPixelBuffer pool must not reuse an IOSurface while another process still uses it ([API contract](https://developer.apple.com/documentation/corevideo/cvpixelbuffercreatewithiosurface%28_%3A_%3A_%3A_%3A%29)). An IOSurface/Metal integration could be worth a separate platform feature, but it adds another platform buffer plus explicit consumer lifetime/synchronization; “shared” does not mean no copies or no extra storage.

## Small experiment worth keeping

The research recommendation is **not** to implement an XShm pixmap now. If partial present proceeds as a separate host feature, first prove the host exposes destination invalidation and preserve full-frame fallback. Then benchmark XShmPutImage vs XShmCreatePixmap+CopyArea only on servers that report shared-pixmap support, for sparse damage, one medium rect, and full-frame damage. Include a server with shared pixmaps disabled as the mandatory fallback case. Record request count, server and client CPU, copied area, source mapping bytes/residency, X server PSS, and visual equality after Expose/resize. Reject if the shared-pixmap path adds a source allocation, worsens full-frame results materially, or requires weaker destination-repair semantics.

## Primary sources and pins

- [MIT-SHM specification, X11R7.7](https://xorg.freedesktop.org/archive/X11R7.7/doc/xextproto/shm.html): extension support, `XShmQueryVersion` pixmap flag, shared-pixmap format, supported server memory model, and segment attach/detach.
- [X.org pixmap concepts](https://www.x.org/guide/concepts/): pixmaps are offscreen and copied to windows; shared memory may limit VRAM caching.
- [NVIDIA X driver option docs](https://download.nvidia.com/XFree86/Linux-x86/256.25/README/xconfigoptions.html#sect-4.2.6): shared pixmaps may disable optimizations/degrade performance; XShmPutImage remains distinct.
- [Softbuffer 0.4.8 source commit](https://github.com/rust-windowing/softbuffer/tree/d871852faa1137d4615b99b9ad31c3ba80f345b5), local vendored archive hash listed above.
- [Winit 0.30.13 source commit](https://github.com/rust-windowing/winit/tree/e9809ef54b18499bb4f2cac945719ecc2a61061b), local Expose coalescing source linked above.
- [Wayland protocol shared memory and release](https://wayland.freedesktop.org/docs/html/apa.html).
- [Microsoft `CreateDIBSection`](https://learn.microsoft.com/en-us/windows/win32/api/wingdi/nf-wingdi-createdibsection).
- [Apple IOSurface](https://developer.apple.com/documentation/iosurface) and [CVPixelBuffer/IOSurface lifetime warning](https://developer.apple.com/documentation/corevideo/cvpixelbuffercreatewithiosurface%28_%3A_%3A_%3A_%3A%29).
