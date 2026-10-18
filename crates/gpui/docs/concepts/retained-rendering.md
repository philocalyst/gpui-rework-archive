# Retained view rendering

A normal `Entity<T>` or `AnyView` used as an element can reuse its rendered
subtree across frames when its inputs still match. You do not need to opt in for
this natural retention. Calling `Entity::cached` or `AnyView::cached` selects a
fixed root style for the retained view. A hand-built `ViewElement::new` stays
fresh because its caller may pass new properties without notifying the view
entity.

Retention changes work between frames; it does not keep the rendered
`AnyElement` tree alive. GPUI renders a view when it must rebuild, then retains
its layout subtree and typed prepaint, paint, and accessibility ranges. The
scene still owns the canonical primitives. See [the
frame](crate::_documentation::concepts::the_frame) for the full frame lifecycle
and [Scene recording](crate::_documentation::concepts::scene_performance) for
operation replay and sorting.

## What invalidates a retained view

GPUI records the entities and globals read while rendering and processing a
retained view. A nested view's reads are merged into its cached ancestors, so a
parent is invalidated when a child it contains depends on changed state. Reads
made during deferred prepaint and paint are also recorded against the cached
owners that scheduled that work. A global read is tied to that global type's
revision. When a tracked entity is notified or a tracked global revision
changes, the affected cached view rebuilds on the next frame.

A retained layout cache includes viewport and scale, `rem` and text style,
content mask, image-cache identity, focus, window activity, accessibility
activity, keyboard/touch input modality, modifiers, text direction and Unicode
bidirectional mode. Mouse position is not an unconditional cache key: GPUI
records a mouse-position dependency only when code in that retained subtree
reads it, then invalidates that subtree when the recorded position changes.
Inherited paint values such as group opacity can change how retained output is
composited without forcing its layout subtree to be rebuilt. Other bounds or
paint-environment changes can still require fresh prepaint or paint output.

`Window::refresh` forces a fresh render of the window. It is useful when a value
outside GPUI's tracked entity and global state changes what the view displays.

## Choose the view policy

Pass an entity as a child when it should size itself naturally and retain its
subtree when clean:

```rust
use gpui::{Entity, IntoElement, Render, StyleRefinement, Window, div, prelude::*, px};

struct Sidebar;

impl Render for Sidebar {
    fn render(&mut self, _window: &mut Window, _cx: &mut gpui::Context<Self>) -> impl IntoElement {
        div().child("Navigation")
    }
}

fn natural_child(sidebar: Entity<Sidebar>) -> impl IntoElement {
    div().child(sidebar)
}

fn fixed_child(sidebar: Entity<Sidebar>) -> impl IntoElement {
    div().child(sidebar.cached(StyleRefinement::default().size(px(240.))))
}
```

Use `.cached(style)` when the parent should give the retained view a fixed root
layout style. The supplied style is the retained root's layout contract; choose
dimensions and constraints that fit the surrounding layout. The child contents
are rendered to build the subtree on rebuild, but the cached root layout is not
inferred from a fresh parent render on every frame.

A `ViewElement::new(view)` is the compatibility path for manually wrapping a
`View`. It remains fresh so new parent-supplied properties are observed even if
the wrapped view exposes an entity identity. Prefer an entity or `AnyView` child
for ordinary retained views; keep the manual wrapper when its parent may change
its inputs independently.

## Measurements and frame lifetimes

The public `Window::request_measured_layout` accepts arbitrary `'static`
callbacks, which may capture state whose validity ends with the current frame. A
retained view that uses such a callback is marked frame-bound and rebuilt rather
than reusing an unsafe stale measurement. Built-in text and inline layout can
use an internal retainable measurement path when its callback owns stable inputs
and only reads the window text system. This does not make arbitrary application
measurement callbacks retainable.

`Display::default()` is `Flex`, while `Style::default()` and a default `Div` use `Block`.
The paragraph behavior below describes adjacent inline content in Block flow;
an explicit Flex display uses the flex layout path.

### Block paragraph and inline-span reuse

A `Div` with `Block` display collects adjacent inline text into a paragraph
document: text, runs, style ranges, inline spans, and any atomic inline boxes.
The paragraph memo is an internal optimization for repeated plain-text paragraphs.
It does not reuse a prior frame's callback or document as current-frame state. The
Taffy paragraph node keeps a fresh measurement callback bound to the current
document and an optional memo of the previous shaping inputs and layout.

The memo key snapshots the paragraph's text style, resolved LTR direction,
normal Unicode bidi mode, font size and metrics, line height, rem size, scale,
font generation, and each span's text/box ranges and direction metadata. It also
checks the paragraph text, runs, and style ranges. Reuse is limited to paragraphs
without inline boxes whose paragraph and spans remain static LTR with normal bidi.
Encountering Auto, RTL, or non-normal bidi conservatively disables inline-text
reuse for the rest of that Window, including descendants requested later during
prepaint. A previous measurement with a truncation width or inline boxes is not
adopted from the paragraph memo. A same-options wrapped layout without truncation
can be reused; if current constraints change the layout options, truncation
width, or bidi scopes, or the font generation changes, the callback measures
again.

On a matching paragraph-node claim, GPUI checks the live Taffy node, style,
direction metadata, leaf shape, and frame-bound status before consulting the
memo. The memo then verifies the current shaping inputs and prior measurement,
and adopts the prior `Arc<InlineLayout>` only when the prior result was not
truncated or boxed. It binds that immutable layout to the current document and
measurement cache. The current callback still checks layout options, bidi scopes,
truncation width, and font generation; if those differ, it shapes the current
document normally. Borrow conflicts and stale or pruned node identities fall
back to a fresh node and layout.

Inline text spans have a separate retained-node role. Their current content,
style, direction metadata, and leaf status must match before a node ID is reused;
GPUI replaces its callback, marks the detached span node dirty, and clears
computed geometry so custom elements that query a span receive current
measurement. Thus paragraph shaping may be reused while span geometry and
callbacks remain current.

### Logical layout claims

A retained view records Taffy layout-node IDs in request order in a
`LayoutClaimLog`. On a later render, the view requests layout again and GPUI
attempts to claim the corresponding old nodes in that same order. Each claim
checks the old node's liveness, Taffy style, physical children, layout-direction
metadata, logical-child metadata, and whether measurement is frame-bound.
Inline spans can be logical claims without being physical paragraph-flow
children. Paragraph claims add the text-memo checks described above.

A scope counts as fully replayed only if it consumes its complete previous log
without becoming non-replayable. A mismatch stops reuse for the remainder of
that scope and lets the new requests create fresh nodes; the updated claim log
then describes the current request sequence. Unclaimed Taffy nodes are pruned at
frame end. This log preserves identity and catches shape changes; it does not
make layout replay constant-time.

### Using the parent-computed layout

When a retained view rebuilds its element but its complete layout-claim log
replays, GPUI may use the matching root node's layout already computed by the
current parent layout pass. The eligibility checks also require the same cached
root ID, unchanged layout environment, no frame-bound measurement, and valid
cached dependencies. The previous frame's root-bounds-size equality is not
required: the parent has computed the root for the current frame's constraints.
The element still prepaints freshly. Reuse of painted output separately requires
the exact output key, including bounds, to match; on any failed eligibility
check, GPUI takes the fresh layout path.

When a rebuilt retained layout keeps its claimed root attached to a Taffy
parent, GPUI compensates the prepaint origin from the absolute-zero origin and
the sampled structural origin. This preserves the current frame bounds and
scroll position without detaching the root; the existing eligibility guards
remain in force.

Stale Taffy subtrees are pruned at frame end. When the set of unique node IDs
claimed for the frame equals Taffy's live node count, the count check proves
there are no unclaimed nodes and skips the retained-node pruning scan. If counts
differ, GPUI scans retained parents and detaches stale direct children in one
batch per parent. It then scans the tracked live-node inventory for stale roots,
removes each stale parent before its descendants, and clears their node metadata.
It also releases frame-bound measurement closures.
The equality fast path skips only pruning's scan; frame finalization, dependency
checks, layout claims, and output replay remain separate work.

The retained Scene path accumulates adjacent replay ranges as one pending range.
At frame finish, a nonempty range covering the complete previous Scene can be
transferred only when the destination is pristine and the source Scene is
finished. Those eligibility checks read range/Scene state, and the transfer
swaps Scene ownership rather than copying paint operations. Otherwise GPUI
flushes the pending range through ordinary Scene replay and finishes the
destination Scene. This makes a qualifying whole-Scene handoff constant-time;
it does not make a frame constant-time. Partial Scene replay and all layout,
state, dependency, and preparation work still scale with their inputs.

The BoundsTree uses height-aware insertion to keep its spatial tree balanced;
its structural tests bound height logarithmically for increasing leaf counts.
Balancing limits traversal depth, but an intersection query can still visit many
branches and has an `O(N)` worst case when bounds overlap broadly. Replayed output
still comes only from completed painted ranges; partial layout or paint work is
rebuilt. Each mount occurrence has its own retained state, even when the same
entity appears more than once in a window.

Paragraph reuse skips some shaping, not paragraph collection: when an owner
rebuilds, GPUI still collects text, runs, spans, and styles and compares the memo
inputs. That work grows with paragraph length and span/style count.

## Work grows with tracked inputs and retained output

Retention avoids rerunning a clean view's `Render` implementation, but a hit
still has validation and replay work. Validation visits the dependencies
recorded for the retained subtree, including entity and global revision
checks; replay walks the cached operation ranges needed to reproduce output.
Both costs can grow with the number of tracked dependencies and retained
operations. Invalidation, fresh layout, paint, or accessibility work adds its
own cost. Retention is therefore not a universal constant-time guarantee; use
the paired correctness and profiling guidance below for the workload you care
about.

## Check correctness before measuring speed

The retained regression suite compares natural retained output with
forced-refresh output across deterministic update histories. It also checks
manual fresh views, dependency invalidation including deferred reads, repeated
mounts, layout pruning, and text-direction changes. Run it with:

```sh
cargo test -p gpui-ce --no-default-features --lib retained_
```

A paired baseline/candidate workload is required before making performance
claims. A source-level architecture comparison can describe retained-view
ownership and invalidation tradeoffs, but it does not establish whole-framework
simplicity or runtime speed. The correctness workload and a clean-frame render
counter alone do not establish end-to-end frame-time improvements. See the
[performance guide](crate::_documentation::guides::performance) for profiling
guidance.

## Paired measurements and scope

An exploratory CPU/headless comparison against pinned gpui-fast
`37f3959732d13404989e58e89c4e37ec9489e3f5` has valid per-profile results for
three workloads. CE is the baseline and Fast the candidate; ratios above 1 mean
CE took longer. The per-profile geometric-mean CE/Fast wall-time p50 ratios
were 1.139544 for owned image-cache work, 1.824318 for dependency fanout, and
6.051998 for the supplemental test-mode viewport. Each profile used 10 paired
runs, 50 measured samples and 10 warmups per scenario, with CPU affinity 2.
These values are exploratory at this sample count and are separate per-profile
summaries, not a combined aggregate. The source and workloads cover CPU-side
update/layout and quad-scene work with empty text rasterizers; they do not
measure text-sprite rendering throughput.

The full nine-scenario primary aggregate is unavailable. The coalesced viewport
profile is excluded because Fast failed geometry at sample 25 / reorder. Tall
is excluded because the engines had semantic scene mismatches in three
scenarios. No glyph-rendering performance result is available. The per-profile
data and methodology, including all scenarios, p99 results, intervals, and raw
receipt links, are in
`final-sync/benchmarks/retained-core/evidence/retained-analysis-valid-profiles-20261018/valid-profiles-02-04.md`
and the adjacent JSON companion. These results show CE slower on the three valid
profiles; they do not support a claim that the retained core is faster overall or simpler as
a whole framework.
