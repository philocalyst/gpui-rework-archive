# Retained scroll viewports

Ordinary component trees can declare a viewport with `.scroll(Axis::X)`,
`.scroll(Axis::Y)`, or `.scroll(Axis::BOTH)`. Both dimensions clip in every mode.
Content uses its normal layout; a finite viewport constrains the aperture,
without inserting a spacer or changing the content's source state.

```rust
use gpui::prelude::*;
fn details() -> El<'static> {
    column((0..32).map(|n| button(format!("Record {n}")).w(160).h(32)))
        .scroll(Axis::BOTH).w(96).h(96).name("Records")
}
```

Run the interactive example with `cargo run -p gpui --example panes --features
x11` from `reactivity/`. The ordinary X11 profile includes AccessKit/AT-SPI.
Use `wayland` for Wayland, or `desktop` on macOS/Windows. `x11-minimal` is the
explicit accessibility-disabled diagnostic profile. Pass `-- --cpu` to select
the reference CPU presenter through the examples' shared renderer selector.

`.scroll` accepts ordinary containers, preserving their annotations, children,
handler and style. It rejects buttons, inputs, text, images, virtual-list roots,
and deferred Reader roots; wrap those in a container. Use `try_scroll` for a
returned `ScrollError::UnsupportedElement`; the convenience builder panics for
an invalid declaration. `.pan(...)` gesture arbitration is a separate future
capability, not this API.

`Win::viewport(target)` and `Part::viewport()` borrow immutable acknowledged
metadata: enabled axes, local offsets, inclusive min/max offsets, and aperture
size. A newer pending or failed preparation does not replace those values.
Foreign/removed capabilities, closed owners and invalidated presentations fail.

`scroll_by(target, ScrollDelta)` and `scroll_to(target, ScrollOffset)` operate in
the viewport's local logical axes. Negative transformed overflow can yield
negative minimum offsets. Disabled axes clamp to zero; all offsets clamp to the
current range. Nonfinite displacements/offsets and absolute values above 2^40
are rejected before staging. Derived finite range coordinates and aperture sizes
also have the 2^40 cap. Existing Canvas geometry/resource admission still applies.
Resize, source rebuilding and property changes recompute/clamp ranges; ordinary
scroll/resize/paint-only overrides retain the logical tree and do not call View.
Virtual lists still materialize rows. A window containing any actual virtual list
uses one description pass for scrolling, including ordinary-ancestor scrolling,
to retire hidden virtual-row capabilities and mint fresh ones when they return.
This is a conservative mixed-window cost; ordinary-only scroll needs no View.

`scroll_at_2d(physical_point, ScrollDelta)` uses a physical window point and
window-logical displacement, matching native pixel-wheel normalization. It
starts at the topmost actually hit paint/input node, then lets each ancestor
viewport consume only the enabled displacement it can scroll. The remaining
vector reaches the next ancestor. Translation never affects displacement;
scale, reflection and device scale are applied exactly once. An overlay outside
a viewport blocks scrolling through it. One input stages at most one candidate,
even when both a virtual list and multiple ordinary ancestors consume it.
The older `scroll`/`scroll_at` methods remain vertical conveniences.

`scroll_into_view(target)` reveals a retained descendant as far as the ancestor
ranges permit, using its full bounds; oversized targets align the nearer needed
edge. Keyboard Tab/ReverseTab use this same operation when traversing a viewport
subtree. Explicit `focus(target)` and the accessibility Focus action remain
position-free logical focus operations; they do not implicitly scroll.
Accessibility advertises ScrollIntoView separately.

Source epochs do not change for scrolling. A recording/native owner publishes
new offsets, bounds and accessibility metadata only after the exact candidate
is acknowledged. Coordinate mutation requires a current acknowledged frame;
mutation during a pending/failed candidate returns `PresentationStale`.
Focus is live interaction state, not frozen geometry. A completed candidate
that retires a virtual-row target also clears its focus, matching virtual input
admission before acknowledgement; a failed preparation does not publish that
candidate. Publication revalidates focus again before native observation.
Ordinary offscreen descendants remain retained/focusable. Existing valid targets
for ordinary descendants survive leaving/reentering the aperture. A removed/recreated node receives a fresh capability. Uniform-list
unrealized rows retain their existing bounded-lifetime policy.

Ordinary fully clipped descendants remain in P for full accessibility bounds,
programmatic reveal and keyboard navigation. They neither paint nor receive
pointer hits outside original-space ancestor aperture predicates. A nested
viewport contributes only its aperture to an ancestor's overflow extent; hidden
nested content does not enlarge the ancestor. Child transforms can expand
positive or negative overflow without relayout.

Viewport transforms must be axis-aligned in window space. Device scales,
reflections, fractional translations and arbitrary transformed descendants are
supported. Rotated/sheared viewport transforms fail preparation with
`ScrollError::UnsupportedTransform`, preserving old P. The raster clip is
lowered to the Canvas 4×4 sample lattice with the existing exact inverse-based
helper. It is not the continuous pointer/accessibility geometry. No arbitrary
transformed clipping, drag gesture, touch inertia or elastic overscroll is
claimed.

The runtime reuses the cold viewport/list ownership lane and adds no ordinary
Node, Presented or Runtime fields. Frozen columns have typed compact list and
scroll rows; an indexed identity check reads dimensions from the same P cohort.
No alternate tree or per-node shared owner is introduced. The wheel plan itself
uses two borrowed ancestry passes without allocation. Whole preparation still
allocates its normal candidate/scratch columns; see the separate evidence ledger
for measured costs and the explicit first-list storage increase.

The native AccessKit tree uses flat physical bounds without ancestor transforms.
Its scroll offsets/ranges therefore use signed physical displacement (with range
endpoints sorted under reflection); native SetScrollOffset converts back through
the same acknowledged diagonal map. Native cardinal directions flip under a
reflected axis. This conversion belongs to the bridge: public Win actions remain
viewport-local. Nonfinite native offset payloads are ignored before enqueueing.
