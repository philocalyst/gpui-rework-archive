# GPUI clean-room application kernel

This independent `gpui` crate connects ordinary borrowed Rust views to typed
owner-relative state operations, Cephal layout, real font shaping, prepared
graphics, input geometry, and typed inspection. It has no dependency on legacy
GPUI. It is an implementation in progress, not a GPUI 1.0 compatibility claim.

```rust
use gpui::prelude::*;
struct Counter { count: Signal<u32> }
impl Counter {
    const COUNT: Source<Self, u32> = Source::new(
        FieldId::new(1), "count", |m| &m.count, |m| &mut m.count,
    );
}
impl View for Counter {
    fn sources() -> Sources<Self> { Sources::new().direct(Self::COUNT) }
    fn view(&self) -> El<'_> {
        column((text(&self.count), button("Increment")
            .on_click(Self::COUNT.update(|count| *count += 1))))
    }
}
let mut win = Win::demo(Counter { count: Signal::new(0) });
win.click(win.button("Increment")).unwrap();
assert_eq!(win.with_model(|m| *m.count).unwrap(), 1);
```

From this workspace, run the native application ports with:

```sh
cargo run -p gpui --features x11 --example counter
cargo run -p gpui --features x11 --example workbench -- --gpu
cargo run -p gpui --features x11 --example graphics
```

Linux can instead enable `wayland`; macOS/Windows use `native`.
`Application::run(root)` opens a default document window;
`Application::run_window(Window::document(root).title("Todos").size(540, 620))`
configures it. `RendererPolicy::Auto` presents software first, initializes a
hardware backend on an owned worker, and switches only after presenting the
latest complete scene successfully. No source state or input authority belongs
to that worker. Suspension cancels pending admission without joining on the UI
thread. On Linux, absence of ordinary render/NVIDIA/WSL device nodes skips the
probe entirely; unusual/remote ICD deployments can choose explicit `Gpu`.
`ReferenceCpu` never initializes Wgpu. `--cpu`, `--gpu` and `--auto` select these
policies in the examples.

The Todo model is shared unchanged by the native example and
`tests/ports.rs`: add, complete, filter, delete, undo and serialization use the
ordinary library operations. `counter` without native features runs headlessly.

The GPU backend uses `wgsl-rs` shaders and Wgpu over the vendored Winit callback
adapter. Native surfaces are currently opaque sRGB8; offscreen linear
RGBA16Float does not imply OS HDR negotiation. Components retain no GPU/Winit
handles. Native recording allocates no CPU output image; `with_pixels` opts in.

Submission borrows the complete scene and acknowledges its token after actual
surface presentation. New geometry cannot accept coordinate input beforehand.
Surface detach revokes that authority; exposure redraws reuse commands without
description/layout. Resize retains the owner and Target namespace. Device
recovery replaces one graphics resource cohort; late errors from the previous
device generation cannot invalidate it. Surface recovery is bounded; timeouts
back off. Ordinary idle windows use `ControlFlow::Wait` without a timer.

Recoverable runtime presentation errors retain accepted source edits and the
preceding sheet. Focused backspace can repair a shaping failure.
`Window::on_presentation_error` observes these failures (default: stderr).
GPU admission/device/platform faults currently return `NativeError`.

`Sources::field` conservatively invalidates the owner, including ordinary Rust
branches and formatting. `direct` explicitly declares that edits only affect
installed direct operands. Shared Signal reads have no hidden dependency
collector. Arbitrary owner callbacks always refresh the owner. Signals retain
inline values; bindings retain field keys rather than movable application
addresses. Same-field fanout shares one promoted immutable text allocation.

`Win::set` returns `SetError::Rejected` with the original value when admission
fails. `Committed` reports the source/presentation epochs after a successful
source edit whose derived presentation failed. `OwnerFault` reports a consumed
operation that panicked; arbitrary Rust values/destructors cannot be rolled
back. Ordinary handler panic quarantines the owner and revokes its targets.

Public targets combine a window namespace and a never-reused retained ID,
independent of preorder or layout IDs. Unkeyed child-count changes remount the affected run. Stable
unrelated subtrees retain their targets. Layout and paint share admitted
transforms; wide ancestor composition can recover before a visible descendant
is narrowed. Failed candidate preparation preserves the preceding complete
sheet and pixel allocation; position-free text editing can recover it.

`property` exposes typed selectors and their shared reflection catalog.
`Win::inspect` explicitly addresses noninteractive sites; ordinary snapshots
only expose action targets. Target queries allocate no capability table.
`set_property` adds a sparse inspector contribution;
`Contribution::Inherit` removes it and reveals the latest component declaration.
An explicit automatic width is `WIDTH` with `Set(None)`, distinct from inheritance.
Paint/transform edits skip owner description and Cephal. No duplicate base style
is retained for nodes without overrides. These public operations are the testing
interface too; no private test scheduler is involved.

Current boundaries are explicit: one root owner; full scene preparation on a
visual/hit change; layout topology rebuilds after structural changes; Cephal
depth bounded to 128; viewport clipping; the canvas's documented text/script
limits; append and Unicode-scalar backspace rather than selection/IME; no
integrated async graph, virtualized collections, embedded native/web content,
or compatibility facade yet. GPU completion is distinct from presentation
acknowledgement; Wgpu retains submitted resource leases. Multiwindow device
sharing, native HDR and the remaining primitives remain porting gates.

Tests cover public input/pixels/serialization, rejected resource recovery,
owner faults, reentrancy, exact/direct versus conservative branching, repeated
text sharing, target lifecycle, wide transforms, presentation recovery, and
typed override presence/validation. See the canvas and retained crates for
independent graphics oracles, exhaustive quantization and storage evidence.

`cargo test -p gpui` runs public headless acceptance and port tests. The native
lifecycle test additionally needs a real X11 display and Vulkan driver (Xvfb
and Mesa llvmpipe are sufficient):

```sh
cargo test -p gpui --features x11 native_todo_port -- --ignored --nocapture --test-threads=1
```

It submits actual surface frames, exercises the keyboard/pointer adapter,
resizes, edits a typed inspector property and suspends/recreates the surface.
The model and targets survive; unsupported shaping repairs through backspace.
The GPU crate has separate actual readback conformance tests.
