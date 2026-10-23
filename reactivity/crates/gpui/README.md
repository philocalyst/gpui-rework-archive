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
cargo run -p gpui --features x11 --example reactive_styles -- --cpu
cargo run -p gpui --features x11 --example workbench -- --gpu
cargo run -p gpui --features x11 --example graphics
cargo run -p gpui --features x11 --example library -- --cpu
cargo run -p gpui --features x11 --example property_editor -- --cpu
```

Direct typed style sources and borrowed Flex fields use the same public ports;
see [style inputs and limits](STYLE_PORTS.md). The `reactive_styles` example also
runs headlessly with no native feature.

Inputs support [grapheme-safe selection and replacement](TEXT_SELECTION.md),
pointer dragging, visual arrows with Shift extension, and actual selection and
caret painting through the ordinary window and native input paths.

Linux can instead enable `wayland`; macOS/Windows use `desktop`.
These normal desktop profiles include the real native AccessKit adapter.
`native` includes accessibility too. `x11-minimal` and `wayland-minimal` are
explicitly AT-disabled transport diagnostics; the default headless build remains
dependency-light. See
[native accessibility](ACCESSIBILITY.md) for ownership, action quotas, actual
AT-SPI proof commands, measured costs and the remaining OS/virtual-item limits.
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
The Library uses the same public interface over 250,000 app-owned identifiers;
its [keyed viewport](VIRTUAL_LIST.md) retains only realized rows. It is a
catalogue/play-request surface, with no audio decoder or database integration.

Flex recipes configure ordinary containers with literal layout values:

```rust
use gpui::prelude::*;
let toolbar = row((button("Back"), button("Play")))
    .w(320).h(48)
    .layout(Flex::row().align(Align::Center).justify(Justify::SpaceBetween).wrap(true));
```

`align` selects cross-axis start/end/center/stretch/baseline; `justify` selects
main-axis start/end/center or space-between/around/evenly. Wrapping follows the
container's main axis. A recipe changes its flow and only the optional fields
it specifies, preserving previous gap/alignment/distribution/wrap declarations.
The typed inspector selectors `property::{ALIGN, JUSTIFY, WRAP}` edit those
same destinations with `Contribution::Set`/`Inherit`; layout, pixels, pointer
queries and native accessibility receive the resulting geometry through the
ordinary presentation barrier. Reactive recipe inputs, reverse wrapping and
per-item alignment remain outside this literal surface.

[Typed questions](QUESTION_INPUTS.md) freeze declared Sources or earlier Ready
Reader answers for application-owned workers. Source pairs borrow their values
together; earlier Reader dependencies settle at the same owner barrier. Library
uses this API for cancellable query/order search. Tests drive the same delivery
and query interfaces. Cross-turn results remain progressive; this is not a
general atomic cohort graph.

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

`win.semantics()?.write_json(writer)?` streams the acknowledged semantic sheet
without cloning nodes or strings. The same borrowed `Part` values exposed by
`visit` implement Serde `Serialize`. Source/presentation epochs distinguish pending
edits from displayed content; retained target IDs are process-local diagnostics.
Use `source_json` for source persistence. See [the testing interface](../../TESTING.md).

`Sources::field` conservatively invalidates the owner, including ordinary Rust
branches and formatting. `direct` explicitly declares that edits only affect
installed direct operands. Shared Signal reads have no hidden dependency
collector. Arbitrary owner callbacks always refresh the owner. Signals retain
inline values; bindings retain field keys rather than movable application
addresses. Same-field fanout shares one immutable text promotion. Private retained
text uses one-word ArcStr leases; empty text allocates nothing, while nonempty
headers and measured CPU costs are charged in [the ownership ledger](evidence/thin-text.md).

`Component::source` composes a child library's declaration through nested
registered components. The resulting typed path works with `Win::read`,
`Win::set`, source-bound actions and Question inputs. For example,
`Page::LEFT.source(&Counter::COUNT)` needs no duplicated parent Signal or
projector. A static input family can be borrowed to keep its controller small.
Paths name current registered fields; presentation targets and keyed row
identity retain their separate authority. See the ordinary
[component_sources example](examples/component_sources.rs).

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

Contained tools use [property selection and state replies](../../docs/property-state-routes.md)
through ordinary typed click methods. `property_selection` supplies the mounted
activation Target on the stack; `property_action` edits through the same kernel.
Both reply with canonical logical value and exact stored contribution before
normal source reconciliation. The public `property_editor` composes selection,
editable values, Apply, Inherit and Refresh without storing a Win in its model.

[Typed bounded inboxes](REMOTE.md) move worker-owned values to this same owner
barrier. A static lane chain retains concrete message/callback types; it does
not box each lane or message. Delivery freezes a fair bounded batch before
application code and applies it in one source operation. Native wake delivery
uses the event loop rather than periodic polling. Closing or quarantining the
owner closes receivers before model destruction. The private exclusive borrow
guard enforces this lifecycle without a shared revocation allocation or a
per-send revocation atomic. This is a delivery primitive; the complete Reader,
input-version and cohort graph remains outstanding.

Current boundaries are explicit: one root owner; full scene preparation on a
visual/hit change; layout topology rebuilds after structural changes; Cephal
depth bounded to 128; viewport clipping; the canvas's documented text/script
limits; IME, clipboard, vertical selection and autoscroll remain; no
complete async graph, embedded native/web content,
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
cargo test -p gpui --features x11 native_remote_results -- --ignored --nocapture --test-threads=1
cargo test -p gpui --features x11 native_library_250k -- --ignored --nocapture --test-threads=1
```

It submits actual surface frames, exercises the keyboard/pointer adapter,
resizes, edits a typed inspector property and suspends/recreates the surface.
The model and targets survive; unsupported shaping repairs through backspace.
The GPU crate has separate actual readback conformance tests.
The remote script verifies real worker wakes and committed-error repair without
a polling timer. The Library script exercises actual surface acknowledgements,
line/pixel wheel routing, stable and revoked row targets, pointer activation,
resize, suspend/resume and complete server-pixel equality against the CPU oracle.

The CPU host first queries the canonical zero-command solid-color certificate.
On X11 it can present that opaque sRGB SDR color using a checked server fill,
without allocating a client transport image. Other scenes/backends use the
ordinary software buffer. Both paths acknowledge the exact prepared owner token
only after their actual native presentation succeeds. An unsupported solid hook
does not acknowledge anything.

The same native test now checks complete X11 window readback for solid colors,
regular gradient images and damaged updates, invalid-color admission, buffer
age across both transitions, actual resize and suspend/resume. It reports
`GPUI_SOLID_MEMORY` measurements of the client's named softbuffer SHM mappings.
These exclude diagnostic readback vectors, the server's window storage and the
OS compositor. X11's transient 4KiB SHM capability probe is unchanged. Both
MIT-SHM and disabled-MIT-SHM wire presentation are exercised independently;
only the former has a client SHM mapping to measure.

[Recorded mapping measurements](evidence-native-solid.csv) on Xvfb 21.1.24 at
800×600 show 2,097,152 mapped bytes, 1,876 KiB RSS and 938 KiB PSS for the ordinary
buffer after a server readback barrier. Initial solid presentation and the return
to solid both retain zero client SHM mappings. Actual resize to 400×300 and
suspend/resume remain at zero. These are transport-mapping measurements in one
native test process, not whole-application memory or startup-latency claims.
The wire rows measure SHM only; ordinary wire presentation still owns a pixel
vector until solid presentation releases it.
