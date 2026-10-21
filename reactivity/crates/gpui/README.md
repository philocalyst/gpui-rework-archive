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
let win = Win::demo(Counter { count: Signal::new(0) });
win.click(win.button("Increment")).unwrap();
assert_eq!(win.with_model(|m| *m.count).unwrap(), 1);
```

Run `cargo run -p gpui --example counter` from the clean-room workspace for a
complete input/layout/font/raster/inspection example. `Win` currently provides
the headless application path; native hosting and the GPU adapter are being
connected to the same prepared scene and operations.

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

Public targets have window namespaces and generations independent of preorder
or layout IDs. Unkeyed child-count changes remount the affected run. Stable
unrelated subtrees retain their targets. Layout and paint share admitted
transforms; wide ancestor composition can recover before a visible descendant
is narrowed. Failed candidate preparation preserves the preceding complete
sheet and pixel allocation; position-free text editing can recover it.

`property` exposes typed selectors and their shared reflection catalog.
`Win::inspect` explicitly addresses noninteractive sites; ordinary snapshots
only mint action targets. `set_property` adds a sparse inspector contribution;
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
or compatibility facade yet. Native submit/release barriers are distinct from
this synchronous prepared sheet. Those remain application-porting gates.

Tests cover public input/pixels/serialization, rejected resource recovery,
owner faults, reentrancy, exact/direct versus conservative branching, repeated
text sharing, target lifecycle, wide transforms, presentation recovery, and
typed override presence/validation. See the canvas and retained crates for
independent graphics oracles, exhaustive quantization and storage evidence.
