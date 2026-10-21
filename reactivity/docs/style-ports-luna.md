# Direct reactive style ports: typed sink over the existing source fanout

Research snapshot: 2026-10-21. Local source audited at cleanroom commit
`f4aa4968b1ef3bb7955a711725a622318d533a0f` in `/root/gpui-ce3/reactivity`.
This is a design note only; no production files, builds, or timings were changed/run.

## Recommendation

Make each style builder a statically typed property sink and lower a dynamic operand to the
existing owner-relative source key plus a cold destination. Keep literal values in `El.style` and
keep dynamic binding drafts inside the existing `El.extra: Option<Box<ElementExtra>>`. During
description, resolve borrowed `&Signal<T>` values with `Sources::resolve`, then discard the
borrowed signal references. Retain no source address and add no field to `Node`, `Style`, `El`, or
`Presented`. Reuse the existing per-`FieldId` fanout and its destination vector; extend its closed
codec/value dispatch to style destinations and preserve the current text destinations.

The key precedent inside this repository is already implemented for text: `Text<'a>` distinguishes
borrowed, owned and signal inputs; a signal is read during description, resolved to `FieldId`, then
stored in `TextSite` as a field key rather than a pointer ([`source.rs`](../crates/gpui/src/source.rs#L293),
[`runtime.rs`](../crates/gpui/src/runtime.rs#L444)). The description
builds a cold `BTreeMap<FieldId, Fanout>` whose leaves are packed 32-bit destinations
([`runtime.rs`](../crates/gpui/src/runtime.rs#L1452),
[`metadata.rs`](../crates/gpui/src/runtime/metadata.rs#L10)). A direct
source operation already chooses between exact patch and whole-owner description based on
`Sources::invalidates_owner` ([`turn.rs`](../crates/gpui/src/runtime/turn.rs#L153)).
Style ports should use that machinery rather than invent a parallel subscription graph.

## API and closed typed schema

The target signatures should make type inference do the work:

```rust,ignore
div().bg(rgb(0x334155))                // literal
div().bg(&self.surface)                // &Signal<Color>
div().w(320)                           // IntoLength literal
div().w(&self.sidebar_width)           // e.g. &Signal<i32> or &Signal<f64>
```

Implement a sealed `IntoProp<'a, Sink>` for literal values, borrowed literals, direct signals, and
then the other final-law source forms. `.bg(...)` remains statically color-typed. Numeric width and
height preserve the complete existing sealed `IntoLength` set on both literal and signal paths:
`.w(320)` and a borrowed `Signal<i32>` should both compile, as should the other supported
integer and float types. A borrowed source must outlive the `El` description:
`let width = Signal::new(320); div().w(&width)`. The temporary `&Signal::new(320)` cannot be
retained past its statement under the borrowed-source law. Do not require `Signal<f32>` just
because retained `Style` stores dimensions as `Option<f32>`.

Use a monomorphized conversion adapter for each source scalar type. Conceptually,
`IntoProp<'a, Dimension>` is implemented for every sealed `T: IntoLength + Copy` literal and for
`&'a Signal<T>`; the signal form carries a `fn(&T) -> Result<f32, PropertyError>` specialized for
`T`. It applies the same `IntoLength::into_length` conversion and finite/nonnegative/f32-range
checks as the literal path, then the width sink stores `Some(f32)`. Every current `IntoLength`
primitive is `Copy`, so this reuses the by-value conversion without cloning arbitrary signal
values. Keep conversion/admission errors explicit on the dynamic path; a bad later publication
must not panic after some destinations were patched. The inspector's `Property<Option<f32>>` still
uses `None` for explicit auto sizing. Source-port absence remains distinct from inspector
`Contribution::Inherit`.

`IntoProp` must remain closed: no blanket `Fn() -> T`, user-provided source codec, or stored
closure. A small borrowed draft enum can distinguish `Literal(T)` from `Signal(&Signal<T>)`; the
signal case carries a static monomorphized codec, not a heap closure. Extend the existing static
`Property<T>` declaration—the current catalog already owns `get`, `put`, `validate`, stable
`PropertyId`, and `Impact`—with the input conversion and destination comparison needed by the
port. This keeps inspector and builder semantics tied to one schema. Use `PropertyId` as a
semantic identifier, never Rust field offsets.

The final `IntoProp` family also admits `Reader<T>`, arbitrary sealed `Source<Value=T>`, Motion,
tokens, and absence where meaningful. Do not make these aliases of the current
`Source<M,T>`: today that type is a static model-field descriptor, not the future `Source` value
algebra. The first direct-signal slice can reuse `FieldId` fanout immediately; `Reader`/Motion and
token adapters need their own typed upstream keys but should terminate in the same typed property
sink and impact metadata. `Reader` pending/fault cannot be silently mapped to a default: the
current contract retains a prior ready value while pending/fault, and surfaces verdicts through
the reader/boundary policy ([`05-async.md`](inputs/final/05-async.md), §§3, 5–6).

## Retention and publication costs

### Ordinary literals

The no-tax requirement is achievable in the current representation: literal builders only write
the existing `Style` value. No new `El`/`Node`/`Style` field, graph node, source record, allocation,
or destination is needed. `El` already has one cold optional box for exceptional payloads
([`element.rs`](../crates/gpui/src/element.rs#L201)); append dynamic style
drafts there. A literal must not cause that `Option<Box<_>>` to become `Some`.

For dynamic style operands, transient `&Signal<T>` borrows exist only while `El` is described. Once
resolved, retain only an owner-qualified `FieldId`; never store the raw address, `Rc`, `RefCell`,
or a per-node observer. One changed source then visits its subscribed destinations only. At present
each destination is 4 bytes and a distinct source pays the existing cold fanout-map entry plus its
vector capacity. Style fanouts add one 4-byte destination per bound `(node, property)`; use
`size_of`/allocation-counter tests for any additional codec/descriptor bytes rather than assuming
the current `Fanout` size remains unchanged.

Keep the 4-byte destination while carrying the actual typed sink ID, rather than spending one
nibble per property. Lay it out node-major as `[node:17 | property:13 | class:2]` in `u32`:
bits 31..15 hold the node index, 14..2 the stable property code, and 1..0 the sink class
(`Visual`, `Name`, `Description`, or `Style`). `MAX_NODES=100,000` fits in 17 node bits. The
property field admits 8192 codes (0 through 8191), so the current 12 style properties plus the
planned radius sink consume no new representation and leave a large checked range for the closed
schema. Non-style classes require property code zero; Style stores its explicit `PropertyId`.

This preserves the current packed sort's important node-major property: all destinations for one
node remain adjacent, so the existing changed-node deduplication still works. Decode node from
`packed >> 15`, class from `packed & 3`, and property only on a Style destination. Use a checked
`PropertyId::from_code` match; never transmute raw bits into an enum. Add compile-time checks that
`MAX_NODES <= 1 << 17` and every declared style ID is at most 8191, plus round-trip, illegal
class/property, max-node, max-property, and sorted-adjacency tests. If the closed property schema
ever exceeds 8191, fail the schema check and add a cold extended descriptor; never truncate.
The encoding remains 4 bytes and adds no field to a hot `Node`.

The cold binding accumulator must implement builder last-write-wins. For example,
`.bg(&a).bg(&b)` subscribes only to `b`, and `.bg(&a).bg(Color::BLACK)` removes the source sink
entirely. Fanout deduplication by node alone is wrong; the destination identity is `(node,
PropertyId)`. A dynamic style-only node allocates only in this cold extra path; a node that already
has semantic/list/image extras should be able to combine payloads without a second independently
boxed binding list. Measure both shapes before choosing `Vec`, inline-one-plus-spill, or a wrapper
around `ElementExtra`.

### Direct patch and exact work cutoffs

For each source publication, read/freeze the typed source value once, compare it at each retained
destination, and patch only unequal destinations. The destination determines the invalidation
ceiling from the static schema:

| Property | Minimum affected work |
|---|---|
| background / foreground | paint; no layout or semantic projection |
| transform | placement/geometry, hit testing and accessibility bounds |
| width / height / gap / padding / flow / font size | layout plus downstream geometry and paint |
| align / justify / wrap if included | layout plus downstream geometry and paint |
| name / description / text | existing semantic/text policies, not a style binding |

Font-size changes also invalidate the destination node's shaped-text cache. `bg`/`fg` do not.
Width-like source values must be validated against *every* subscribed property before any
destination mutates: a single `Signal<f32>` may drive both width (zero valid) and font size (zero
invalid). Existing `Property::validate` gives the right predicate; validation must be staged
atomically per source publication.

Exact equality matters. The source can be republished on every mutable access, so unchanged
values must no-op. But Color authoring preserves tagged profile and channel bits; a source sink
should use the schema's exact authoring comparator (including signed-zero behavior) rather than
blindly use `PartialEq` if `PartialEq` collapses representations the runtime promises to retain.
The existing style interner already uses `Color::same_authoring` and float bit comparisons
([`runtime/styles.rs`](../crates/gpui/src/runtime/styles.rs#L132)).
Inspector `Set(default)` presence is separate from destination equality and must stay so.

Important limit: this is View-work elimination, not constant-time rendering. Current
`present_inner` still computes/visits the full retained tree, rebuilds the scene and candidate
`Presented` vector. A Paint sink may avoid layout calculations when no layout destination is dirty,
but the current scene-recording pass is still O(N). Do not claim the final A3 zero-hit/zero-a11y
paint guarantee until the renderer has a measured sparse damage/command patch path. Keep
`Prepared`/candidate and acknowledged `Presented` cohorts separate: source change updates logical
style, then candidate render; P changes only on successful acknowledgement. A failed prepare keeps
the old P/pixels/semantic sheet authoritative.

## Inspector overlays, components, and fault authority

The current inspector layer stores sparse `Overlay { base: Style, values: BTreeMap<...> }` only for
overridden targets; ordinary nodes pay no overlay entry. `Overrides::resolve` refreshes `base` when
description runs ([`property.rs`](../crates/gpui/src/property.rs#L251)).
Direct source patching must add an operation that updates the overlay's *base* for that property
and recomputes the effective style. If the property currently has `Set(x)`, the rendered effective
value stays `x` and incurs no visual/layout work; the latest source base is still retained. A later
`Inherit` then reveals that newest source value immediately without a View rerun. Updating only
`Styles` would leave the overlay base stale.

Component bindings follow the existing `Sources` projection route. During description, resolve the
borrowed child `Signal<T>` against the root's registered source table, yielding a fully qualified
`FieldId`. `Sources::resolve` recurses through components and rejects ambiguous aliases; source
projectors are rechecked before writes. `direct_component` is the explicit promise that the parent
does not also snapshot-read child state. Tests need two siblings with the same local declaration
ID, a child direct source under `direct_component`, an ordinary `component` source that correctly
reruns the owner, and a changed projector that fails before exposing mutable state.

`Signal<T>` edits commit before projection/patch work. Thus a newly published NaN width or zero
font size cannot be rolled back by a style sink. The patch must prevalidate all destinations before
mutating any style; on rejection return the truthful post-commit error, preserve the prior P, and
invalidate the logical sheet as the current post-admission error policy does. A later valid owner
turn can rebuild. Catch user/source projection panics at the existing owner boundary and poison
the owner; do not call a user closure from patching. Reconciliation replacement should build the
new binding/fanout scratch before swapping it in, so a failed description cannot leave half-old
and half-new subscriptions.

## Motion and typed source extension

Motion should not add animation fields to every Node. Store active timeline records in a cold owner
lane keyed by the same `(node identity, PropertyId)` sink; each sampled value uses the exact same
descriptor, comparator, and impact path as a Signal write. When a target is retargeted, start from
the last presented value where the design law requires interruption continuity; keep the base
Signal value beneath the transition so removing/finishing the transition reveals the newest base.
The `Set`/`Inherit` inspector mask is another precedence layer, not the animation's base value.
Frame samples can coalesce to the latest sample per sink, but must not coalesce occurrence events.

Generic derived `Source<T>` should freeze to an owned/copy `T` value and upstream stamp before it
touches the sink. Ready values use the destination compare; Pending/Fault retain their explicit
verdict and follow the retained-previous/boundary policy. No property update may borrow a
temporary source result after its cohort ends. For Reader/Motion, add a cold binding lane only for
those sources; do not inflate ordinary `Node` or allocate a generic query edge per literal.

## What other systems teach—and what not to copy

* **Bevy ECS 0.20.0 (tag commit `b3bdd75becaffe9a16677cf5bae5bd6d198f052b`):** per-component `ComponentTicks` record add/change times; mutable access
  conservatively marks changed, while `set_if_neq` avoids a false-positive tick. Column summary
  ticks are opt-in because they make mutations more expensive while allowing change-query readers
  to skip whole columns. This supports publication epochs plus destination equality, but GPUI's
  direct property sources already declare the exact source→sink edge, so it does not need a tick in
  every Node or Bevy's ECS scheduler. Primary sources: [change-detection API](https://docs.rs/bevy/0.20.0/bevy/ecs/change_detection/),
  [Bevy 0.20 column-summary change ticks](https://bevy.org/news/bevy-0-20/), and [Bevy's
  change-detection example](https://github.com/bevyengine/bevy/blob/b3bdd75becaffe9a16677cf5bae5bd6d198f052b/examples/ecs/change_detection.rs); the implementation is in [`change_detection/mod.rs`](https://github.com/bevyengine/bevy/blob/b3bdd75becaffe9a16677cf5bae5bd6d198f052b/crates/bevy_ecs/src/change_detection/mod.rs) and [`change_detection/traits.rs`](https://github.com/bevyengine/bevy/blob/b3bdd75becaffe9a16677cf5bae5bd6d198f052b/crates/bevy_ecs/src/change_detection/traits.rs).
  The example explicitly documents that `DerefMut` marks changed whether or not equality changed.
* **Salsa 0.28.5 (tag commit `d434f8805c60ac60dce5f367ca91c5a7cd3e4c86`):** revisions and dependency edges make delayed validation/backdating correct;
  a query reruns when an input changes and can backdate if its output is equal. Tracked fields
  carry revision metadata, and IDs use index+generation for reuse. This is the right precedent for
  Reader/cohort validity and equal output pruning, but a general memoized dependency graph is
  unnecessary for a directly declared `FieldId → PropertyId` edge. Primary source: [Salsa's
  revision/red-green algorithm](https://github.com/salsa-rs/salsa/blob/d434f8805c60ac60dce5f367ca91c5a7cd3e4c86/book/src/reference/algorithm.md) and
  [tracked-struct field revisions](https://github.com/salsa-rs/salsa/blob/d434f8805c60ac60dce5f367ca91c5a7cd3e4c86/book/src/plumbing/tracked_structs.md).
* **Slint 1.17.0 (tag commit `fdde7a535305d2ab2d4072dee637bad186a49723`):** `Property<T>` lazily evaluates a binding, registers dynamic read dependencies,
  marks dependents dirty, and supports binding replacement and animation. That is a useful
  precedent for typed values and dependency invalidation, but its heap/property object model and
  callable bindings are the opposite of this runtime's direct fixed-edge, no-user-callback path.
  Primary sources: [`Property` implementation](https://github.com/slint-ui/slint/blob/fdde7a535305d2ab2d4072dee637bad186a49723/internal/core/properties.rs), [`i-slint-core::Property` API](https://docs.rs/i-slint-core/1.17.0/i_slint_core/struct.Property.html)
  and the [binding language contract](https://docs.slint.dev/1.17.0/docs/slint/reference/language/bindings/).
* **Jetpack Compose:** state reads are tracked by composition/layout/draw phase, and a later-phase
  read can invalidate only that later phase; a backwards write schedules redundant earlier work.
  This validates phase-specific impact as an important contract. GPUI should use static property
  impacts rather than execute-time ambient tracking: it can know `bg` is paint-only from the
  property descriptor. Primary source: [Compose frame phases and state-read invalidation](https://developer.android.com/develop/ui/compose/performance/backwards-write).
* **Xilem/Masonry (snapshot `271a27a6d4a930f7878d404f9014e3c50a3a9b88`):** Xilem's retained backend reconciles a short-lived typed view tree; its
  architecture docs also warn that eager view construction can dominate large trees and introduce
  `Memoize` to prune unchanged subtrees. That resembles the current coarse owner path, while
  direct style sinks are the more surgical option when one scalar's sink is already declared.
  Primary source: [Xilem architecture at pinned commit](https://github.com/linebender/xilem/blob/271a27a6d4a930f7878d404f9014e3c50a3a9b88/xilem/ARCHITECTURE.md).

These systems validate individual mechanisms, not an unmeasured speed claim. Bevy's tick and
column summary add mutation-side cost; Salsa stores graph/revision state; Slint dynamically
evaluates closures; Compose tracks runtime readers. None gives a drop-in implementation for this
borrowed owner model.

## Minimum implementation slice and conformance gates

1. Add sealed typed `IntoProp` inputs for all existing style properties: literal/by-reference
   literal and direct `&Signal<T>`. Extend the static property schema with `Impact`, validated
   conversion, exact equality, and source codec. Keep numeric `.w/.h` ergonomics through the
   existing `IntoLength` set; width signal values are `f32` and resolve to `Some(f32)`.
2. Add last-write-wins dynamic binding drafts to the cold `ElementExtra` path. At description,
   resolve/validate all bindings to `FieldId`, build destination fanouts transactionally, and store
   no borrowed references.
3. Add a direct style patch that reads one source value, validates all destinations first, updates
   override bases and effective `Styles`, then unions static impacts. Equal output is a no-op.
   Paint-only patches do not dirty layout; font-size clears shaping; geometry properties dirty hit,
   bounds and A11Y work.
4. Keep candidate/presented epochs and presentation-loss behavior unchanged. A source update may
   make logical style current while P remains the prior acknowledged cohort; failure leaves P
   intact. `Reader`/Motion/token integration comes through additional source adapters, not a second
   style system.

Conformance tests: builder literal and direct forms compile for each property; wrong source/value
types fail compilation; direct Signal updates change one/few destinations with zero `View` reruns;
publishing equal values does not dirty layout/paint; bg does zero layout and semantic work; width
and font-size trigger their exact layout/shaping work; one source feeding multiple properties is
read once and validates all sinks before mutation; `.bg(&a).bg(&b)` and `.bg(&a).bg(literal)` drop
the obsolete binding; component scopes resolve stable IDs and alias/projector changes reject;
`Set(default)` still masks source updates and `Inherit` reveals the newest source value; failed
prepare leaves P/semantic sheet intact; source panic poisons and closes through existing policy.
Run the dynamic-binding allocation ledger with 0/1/2/8 bound sinks and ordinary extra-bearing
nodes to prove there is no ordinary node/header cost.

The earliest honest performance gate is not just "no owner rerun": report source reads,
destination compares, layout computations, scene nodes visited, command bytes changed, semantic
nodes visited, allocations, and p50/p95 update-to-ack latency at 0/1/1k/10k nodes. Until there is
a sparse paint-command route, direct style binding proves View-work removal, not full sublinear
presentation.

## Sources and snapshot limits

Local implementation paths are cited inline and pinned above. The contracts come from
[`03-ports.md`](inputs/final/03-ports.md) §§2–6,
[`01-state.md`](inputs/final/01-state.md) §3, and
[`05-async.md`](inputs/final/05-async.md) §§3–6.

External primary sources were read 2026-10-21. Bevy, Salsa, Slint, and Xilem source links are
content-pinned to the commits listed above. Compose remains an official documentation page without
a revisioned URL; its statements should be treated as dated guidance, not an immutable contract.
