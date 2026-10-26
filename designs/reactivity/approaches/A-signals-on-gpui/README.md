# Approach A — Signals on Today's GPUI

Status: **exploration, superseded as an implementation sequence**. Its public state/value ideas feed
the final plan, but direct property binding cannot precede retained elements. See
[../../03-hybrid-plan.md](../../03-hybrid-plan.md).

## Original hypothesis

Add a `gpui_reactive` graph beside entities, store subscriptions in existing element-state slots,
reuse cached subtrees, and let signals patch text/style/layout properties without first replacing
GPUI's frame-rebuilt substrate. This promised the fastest migration and smallest core diff.

## What survives

- GPUI-owned copyable `State<T>` keys, generated field bundles, derived slots, and owner scopes.
- No process/thread-local current runtime and no owning/refcounted signal handle: `Scope`/`Update`/
  inferred `Read` supply access authority and validate inert keys.
- Writes mark and wake; the host settles after events/before frames.
- One sealed generic `Property<T>` installer for literals, keys, and expressions; mount deforests it
  without a universal stored value enum.
- Direct adapters between state and existing entities at migration boundaries.
- Explicit structural regions and keyed collections.
- Located generational/disposal diagnostics and owned task cleanup.

The final surface is close in spirit:

```rust
fn counter(scope: &mut Scope<'_>) -> impl IntoElement {
    let count = scope.state(0u64);
    div()
        .child(text(count.mul(2)))
        .child(button("+").on_click(move |_, update| update.edit(count, |n| *n += 1)))
}
```

## Why the layering order fails

`Window::with_element_state` retains auxiliary state by element id, and `.cached()` can replay
recorded ranges for a whole subtree. The element itself is allocated in a frame arena, the Taffy
tree is cleared for a draw, and dispatch/scene structures are rebuilt or range-replayed. An effect
stored in auxiliary state therefore has no stable width/color/text destination to patch between
frames.

An A-style implementation could make signals call `notify` and rebuild smaller cached islands. That
is useful compatibility, but it is not property-level reactivity and risks becoming a second
permanent architecture. The correct dependency order is:

```text
retained node identity
  -> persistent layout/dispatch/a11y/fragment destinations
  -> direct property bindings
  -> legacy entity/render adapters
```

No multiplier can be predicted from adding the graph. Current zgui already has retained properties,
layout, paint recordings, damage, and pixels; current Floem already has retained views and Taffy
nodes. Performance comes from the entire retained pipeline and must pass
[../../performance.md](../../performance.md).

## Corrected API details

The early `ReadValue<T>` sketch should not use overlapping blanket implementations. The final plan
uses a framework-sealed generic installer; constants allocate no graph node and generated model
fields route directly to their own cells without projection nodes.

The selected `list(rows.keyed_by(key), row)` over a signal/vector source is an O(n) convenience
reconcile. It preserves a resident row on move,
but a row that captured a plain `T` does not update just because the vector contains a new `T` for
the same key. Large lists use `KeyedList<K, V>` with separate structural and resident-row revisions.

Cross-thread code does not write a local state handle. It sends an owned command through `Sender<T>`
or returns a revision-tagged result from an explicit snapshot.

## Compatibility role

Once the retained substrate exists, `LegacyView<T: Render>` can host current views. Entity
notifications rebuild only that island and reconcile at its boundary. Signal/entity adapters make
migration incremental, while counters expose build/allocation/full-subtree cost so compatibility
does not become invisible.

## Examples

The sketches remain useful as desired ergonomics, not compilable API commitments:

- [examples/counter.rs](examples/counter.rs)
- [examples/task_board.rs](examples/task_board.rs)

Where they mention pre-retention property effects or `Signal<Vec<T>>` scaling, interpret them using
the corrected contracts above.
