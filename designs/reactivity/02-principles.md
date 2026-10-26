# 02 — Principles and Honest Limits

These principles govern the retained substrate. Authoring spellings live in
[07-the-ladder.md](07-the-ladder.md); undo/redo in [08-history.md](08-history.md);
text in [09-text.md](09-text.md); color in [runtime/color.md](runtime/color.md);
the pipeline and turn protocol in [03-hybrid-plan.md](03-hybrid-plan.md) and
[04-less-is-more.md](04-less-is-more.md). The approach subdirectories are historical
design explorations and may intentionally show a more extreme point in the design space.

## Principles

### P1 — Retained identity before fine-grained reactivity

A property binding is useful only if its destination survives the frame. Retain element, layout,
dispatch, accessibility, and paint identities first; then wire state directly to property slots.
`with_element_state` retains auxiliary state but does not retain the frame-arena element or Taffy
node, so it is an adapter seam, not the new substrate.

### P2 — Cost follows actual change through every stage

Local state invalidation is not enough. A paint-only change must avoid structural work and layout;
a transform-only scroll should avoid primitive encoding and redraw only exposed pixels where the
backend permits; a resident-key row update should not scan or remount the list. Count work at graph,
traversal, layout, text, scene, hit-test, accessibility, renderer, and event-loop layers.

### P3 — Plain Rust is the complete API

Components are ordinary functions. `State<T>` is a copyable, non-owning typed key; a generated model
bundle exposes its fields with normal Rust member syntax. Literals, keys, and expressions satisfy a
sealed `Property<T>` installation bound and disappear into retained slots at mount. Explicit
`show`/`switch`/keyed primitives mark tree-shape changes. Proc macros can improve diagnostics and
spelling later, but cannot be required for correctness or peak performance.

### P4 — Local by default; concurrency at an explicit boundary

The hot graph is `!Send + !Sync`, owned by the UI runtime, and uses no locks or atomics for local
access. Background work receives owned inputs or an explicit immutable `Snapshot<T>` and returns a
typed result. `compute/resource/action` own the common freeze/request/delivery edge; a raw
`Snapshot<T>`/`Sender<T>` remains the stream, service, or unusual conflict-policy escape. Only data
and callables that actually cross threads require `Send + 'static`; local state, callbacks, motion,
canvas, and local futures do not. Universal MVCC and transparent cross-thread signals are not free
safety features.

### P5 — Writes mark; the host settles

A state write creates an isolated draft; it never mutates published state or recursively runs user
computation. The host settles a sparse logical draft after each separately dispatched event and
atomically publishes it. Multiple writes in one handler coalesce. Effects run after publication and
start later transactions. Presentation is a second sparse draft with sealed, bounded geometry
feedback and its own atomic interaction/frame publication.

### P6 — The type system guards real API boundaries

Use `Scope`, `Update`, inferred dynamic `Read`, and advanced phase contexts so invalid operations are
absent from a phase's API. Keys have no read/write methods and own no runtime pointer; resolving one
requires the right capability, which supplies and validates the runtime. Generated fields are direct
slots, so separate public read/write projections are unnecessary. Keep contained internal branded
arena views after generational-id validation. Do not advertise
compile-time guarantees for dynamic dependency cycles, use-after-disposal of stored generational
handles, or protocols that span independently dispatched callbacks; make their runtime state
machines immediate, named, and inspectable.

### P7 — Structure has explicit identity and lifetime policy

Dynamic collections are keyed. Moves preserve owner/node/local state. Resident-key value updates do
not imply remount. Branch replacement resets by default; `keep_alive` is explicit and budgeted.
Virtualization automatically retains rows for focus, IME, pointer capture, drag, transitions, and
accessibility; application code does not repeat those reasons in a `.pin` declaration. Duplicate
keys and ids fail with source locations.

### P8 — Styling keeps its ergonomics and gains a schema

The chainable Tailwind-like API remains. Static chains run once at mount because nodes are retained;
reactive values bind individual fields. A generated schema supplies field ids/diffs, while explicit
metadata declares layout/paint/composite/semantics consequences. `tw!` may parse literals on stable
Rust and emit the same operations. Const folding is an optimization, not a semantic dependency.

### P9 — Placement, text, work, media, motion, and custom graphics are not footnotes

Text editing owns selection, composition, revisions, and edit origin; its undo *track* is
the document's `History`, not a second stack inside the field. Resources own
request tickets, cancellation, and stale completion policy. Arbitrary geometry relationships use a
sparse placement graph rather than contaminating normal flow. Time-sampled timed/spring/keyframe/
gesture/FLIP motion is classified into paint, composite, placement, layout, shader, and structural
tiers. Retained canvas/shader passes keep typed inputs, bounds, hazards, damage, resource lifetime,
and tooling. Images/video accept ordinary embedded/path/HTTP/provider inputs but lower through
typed, budgeted acquisition/decode/variant/residency stages; native frames are renderer-imported and
fence-owned, never manual widget memory. These cases define whether a UI architecture is usable, so
they are part of the core plan and benchmark suite.

### P10 — Incrementality has a full oracle and bounded caches

During development, incremental layout, hit testing, accessibility, and paint are checked against
full recomputation. Every retained cache has a budget, eviction telemetry, and correctness-safe miss
path. A bulk renderer frontend negotiates capabilities per operation and always retains full packet/
upload fallbacks. Device loss, unsupported native media import, and unsupported partial presentation
promote to conservative work without visual corruption or platform handles leaking into core types.

### P11 — Inspection and deterministic testing are part of the design

Work counters, live gauges, latency marks, damage visualization, dependency/owner inspection, and
“why did this update?” traces land with each layer. One epoch-tagged snapshot/delta protocol powers
the inspector and tests; synthetic input must traverse real hit/focus/IME/event paths. A virtual
clock, controlled work completion, semantic locators, actionability, reference renderer, and failure
trace make integration tests deterministic without sleeps. A counter of work avoided is paired with
a counter of work performed and a test that proves both can move. Performance claims require stored
same-machine comparisons and tail latency, not anecdotes or isolated microbenchmarks.

### P12 — Stable contracts, replaceable mechanisms

GPUI owns its key/property/structure vocabulary. Graph engine, dirty traversal, order maintenance,
layout adapter, renderer tier, and optional macros remain behind seams. Stable Rust is the floor.
When a frontier mechanism loses to a simpler one in measurement, retain the invariant and replace
the mechanism.

### P13 — The model records; the UI tags

Undo is not a stack of closures and not a per-widget private history. A `History` owner
captures serialisable `Delta`s (prior states *and* transitions) on a revision DAG; the UI
tags which captured revisions are one press of Cmd-Z; focus selects a `Track` over that DAG.
Ordinary mutation on a non-`History` owner allocates nothing. External effects are never
falsely undone. Sudden Termination recovers tagged values, which is why captured blocks are
forbidden. Selective undo, branching, and collaboration origins are transformations on the
same algebra ([08-history.md](08-history.md)).

## Non-goals

- Proving a dynamic reactive graph entirely in Rust types.
- Per-glyph reactive nodes; text uses edit/line/paragraph granularity and caches.
- Making every state value thread-safe or versioned.
- Hiding meaningful authority. Passing/capturing a key needs no context; dereferencing it does.
  Mount, update access, dynamic tracking, thread-host selection, layout, and paint retain
  explicit capabilities.
- Treating invisibility, offscreen status, disposal, and caching as the same state.
- Promising a speedup before the gates in [performance.md](performance.md) run.
- Preserving every current internal API. The project is greenfield enough to refactor the substrate.
- Capturing undo as blocks, invocation trampolines, or "register the inverse by performing it."
  History is values, or it is not history ([08-history.md](08-history.md)).
