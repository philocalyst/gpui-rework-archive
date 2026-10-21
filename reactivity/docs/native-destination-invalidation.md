# X11 destination validity and damage presentation

The native CPU presenter now uploads scene damage when the X11 destination is
known valid. An observed invalidation or presenter lifecycle change requires a
full submission until one succeeds. Other backends keep full presentation.
This changes transfer regions, not the canonical scene or client framebuffer.

## Ownership

The Winit patch is against vendored 0.30.13, upstream
`e9809ef54b18499bb4f2cac945719ecc2a61061b` (the archive's
`.cargo_vcs_info.json`). It adds `Window::take_redraw_invalidation()` and the
three-state `RedrawInvalidation`. `WindowEvent::RedrawRequested`, the redraw
channel, and its existing window-ID coalescing remain unchanged.

X11 stores one boolean in its existing mutex-protected `SharedState`. It starts
invalidated and latches on every Expose rectangle, MapNotify, and UnmapNotify.
The final Expose still schedules the public redraw. Latching nonfinal rectangles
also covers an explicit app redraw that occurs before the final rectangle.
Taking the hint clears only Winit's observation. Unknown backends return
`Unknown` and do not obtain the partial-presentation permission.

The host stores its independent, sticky full-repair obligation. It merges the
hint before redraw early returns; zero-sized, hidden, occluded, resized,
suspended, and attempted GPU-handoff states invalidate it. Failed CPU submits
invalidate it too. Only an accepted full submission clears it; accepting a
partial submit cannot clear an outstanding obligation. A solid server fill is a
full submission and resets client-buffer age history.

Client repair and server upload use different damage. Buffer age can require
repairing more client pixels, including the whole client image. The server
receives the original presented-to-candidate scene damage when valid, or a full
copy when invalid. Forced destination repairs are never inserted into scene
damage history. Empty scene damage uses `present_with_damage(&[])`: the reviewed
XShm path emits no image rectangle but keeps its completion barrier and client
age update. The Wire fallback still uploads the full image.

This is observed-event evidence, not atomic protection against an X server or
window manager changing visibility during a submission. An Expose generated
while the owner renders is observed on a later event-loop turn and forces the
next full repair. Application platform errors still exit through the existing
error path. The explicit test catches a real rejection and elects to retry;
production has acquired no new automatic retry promise.

## Actual layout and allocation

Both builds used Rust 1.97.1 on x86_64 Linux, `cargo rustc -p gpui --example
empty --features x11 --offline -- -Zprint-type-sizes` with
`RUSTC_BOOTSTRAP=1`. These are actual emitted type layouts, not estimates based
on neighboring fields.

| Type | Before | After | Alignment |
| --- | ---: | ---: | ---: |
| X11 SharedState | 640 B | 640 B | 8 B |
| Mutex of SharedState | 648 B | 648 B | 8 B |
| X11 UnownedWindow | 784 B | 784 B | 8 B |
| ArcInner of UnownedWindow | 800 B | 800 B | 8 B |
| NativeHost of Empty | 496 B | 496 B | 8 B |
| Driver of NativeHost of Empty | 504 B | 504 B | 8 B |

The added `Destination` and return enum each occupy one byte. Moving an already
constructed opening into `NativeHost::new` requests zero allocations and zero
bytes, asserted by `invalidation_state_adds_no_host_constructor_allocation`.
This does not measure Xlib, AccessKit, startup RSS/PSS, or compositor memory.
The X RECORD connection, reader thread, temporary full-image oracle, and transfer
ledger exist only in the explicit tests.

## Native proof

The ignored tests require actual X11 and RECORD; the first additionally requires
MIT-SHM, and the second requires it explicitly disabled. They fail rather than
silently skip if their transport is unavailable. Use a private display; normal
`x11` also enables the production accessibility profile.

```sh
Xvfb :99 -screen 0 800x600x24 -nolisten tcp -ac
DISPLAY=:99 cargo test -p gpui --features x11 --lib --offline \
  native::destination_tests::destination_invalidation_controls_actual_x11_uploads_and_failure_retry \
  -- --ignored --exact --nocapture

Xvfb :100 -screen 0 800x600x24 -nolisten tcp -ac -extension MIT-SHM
DISPLAY=:100 cargo test -p gpui --features x11 --lib --offline \
  native::destination_tests::wire_fallback_still_uploads_full_for_empty_and_partial_scene_damage \
  -- --ignored --exact --nocapture
```

One deadline covers the actual event-loop proof. It checks initial full and
empty app redraws, ordinary damage, app requests coalesced with an Expose series,
nonfinal Expose before app redraw, Expose generated during the draw callback,
real invalid-damage rejection followed by retry, actual overlay
obscuration/uncover, hidden pending state/remap, resize, suspend/resume, and
solid/normal transitions. Every stable visible phase compares all server pixels
from `surface.fetch()` against independent full `owner.render_bgrx()` output.
Hidden and failed attempts cannot acknowledge the candidate. The full repair
after Expose is checked not to contaminate scene history.

X RECORD observes drawing requests from the native window's client, excluding
the control client's corruption/cover operations. It parses actual upstream
SHM, PutImage, and PolyFillRectangle requests. Recorded image bytes are the
rectangle's pixel area times four for this 24-depth/32-bpp test profile; SHM
reads those bytes from shared memory rather than carrying them in the request.
The request-byte column counts only the recorded drawing opcode, excluding GC
changes, barriers, and other protocol traffic. A solid fill reads zero client
image bytes; it still changes the recorded destination area.

The SHM run has twelve successful image uploads and one solid fill. Initial
184×128 submission reads 94,208 image bytes; app damage 33×33 reads 4,356.
Required invalidation repairs remain full. At 208×152, resize/resume read
126,464 each; solid→normal uploads 33×65, or 8,580 image bytes, even though the
new client backing needs full repair. Empty valid redraws and the rejected
attempt emit no image request. SHM drawing requests are 40 bytes, and the one
solid-fill drawing request is 20 bytes.

With MIT-SHM disabled, initial, empty, and app-partial redraws each actually emit
one full 184×128 Wire PutImage: 94,208 pixel bytes and 94,232 drawing-request
bytes. Reduced requested damage must not be reported as reduced Wire transfer.
No latency, throughput, RSS, or zero-copy improvement is claimed by these tests.

Raw emitted drawing requests and exact commands/source pins are retained in
`native-destination-invalidation-evidence.txt` and
`native-destination-invalidation-transfers.csv`.
