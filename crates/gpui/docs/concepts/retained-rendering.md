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

Retained layout nodes are claimed in the next Taffy frame and stale subtrees are
pruned at frame end. Replayed output only comes from a completed painted range;
partial layout or paint work is rebuilt. Each mount occurrence has its own
retained state, even when the same entity appears more than once in a window.

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
claims. The correctness workload and a clean-frame render counter alone do not
establish end-to-end frame-time improvements. See the [performance
guide](crate::_documentation::guides::performance) for profiling guidance.
