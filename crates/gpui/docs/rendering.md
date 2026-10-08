# Build an element tree and render a frame

Rendering starts with the application's current state and ends with a scene
the platform can present. An entity implementing [`Render`](crate::Render)
builds an [`Element`](crate::Element) tree. Layout assigns its rectangles;
prepaint prepares interaction and accessibility; paint records drawing and
this frame's input handlers.

Start with the component boundary that matches the component's ownership:

- Implement [`RenderOnce`](crate::RenderOnce) for an owned component assembled from parent-supplied values. It consumes the component and has no independent entity identity.
- Implement [`Render`](crate::Render) for a component stored in an [`Entity`](crate::Entity), with state that can notify and invalidate its own view through [`Context::notify`](crate::Context::notify).
- Implement [`Element`](crate::Element) when the component must control layout, prepaint, or paint. For a small custom drawing operation, [`canvas`](crate::canvas) often supplies enough control without a new element type.

These boundaries compose. A `RenderOnce` component can contain an entity
handle, and a custom `Element` can contain child elements. A complicated
toolbar can therefore remain an ordinary component assembled from inputs,
while a small text editor may need custom measurement and hit testing.

## Build a component from inputs

Derive `IntoElement` to use an owned component as a child. Its `render` method can consume fields and return the usual builder-based tree:

```rust
use gpui::{div, prelude::*, text, App, IntoElement, RenderOnce, SharedString, Window};

#[derive(IntoElement)]
struct Badge {
    label: SharedString,
}

impl RenderOnce for Badge {
    fn render(self, _window: &mut Window, _cx: &mut App) -> impl IntoElement {
        div().px_2().py_1().rounded_md().child(text!(self.label))
    }
}
```

The parent creates another value when it renders again. Put durable state on an
entity, or use retained element state when its lifetime should follow the
rendered component. A `RenderOnce` value does not receive notifications of its
own.

The derived element gives `Badge` a scope based on its Rust type name. That
separates it from other component types, but not from another `Badge`. For
repeated components, wrap each in a parent with a stable record ID:

```rust
# use gpui::{App, IntoElement, RenderOnce, SharedString, Window, div, prelude::*};
# #[derive(IntoElement)]
# struct Badge { label: SharedString }
# impl RenderOnce for Badge {
#     fn render(self, _: &mut Window, _: &mut App) -> impl IntoElement { div().child(self.label) }
# }
fn badges(records: &[(u64, SharedString)]) -> impl IntoElement {
    div().children(records.iter().map(|(id, label)| {
        div().id(("badge", *id)).child(Badge { label: label.clone() })
    }))
}
```

This outer ID is active when `Badge::render` runs, so it scopes both child IDs
and state hooks inside that method. Adding an ID to the returned element cannot
scope a state hook that has already run. See
[`RenderOnce`](crate::RenderOnce) and the
[identity rules](crate::_ownership_and_data_flow#give-retained-element-state-an-identity).

## Give a stateful view an identity

A value implementing `Render` is stored in an entity. Embedding that entity as an element creates a view boundary: reads made while rendering are tracked, and notifying the entity invalidates its view. Rendering still describes the current tree; it is not a once-per-change callback, so do not make correctness depend on how many times `render` runs.

Each entity-backed view contributes its `EntityId` to the element identity path. Descendant state such as IDs and scroll state is scoped by that path. Do not render the same entity as two siblings under the same parent when both subtrees use retained descendant state; their paths can collide. For repeated rows, use distinct entities or stable IDs derived from each row's logical key rather than its current position. See [`View::entity_id`](crate::View::entity_id) and [`ElementId`](crate::ElementId).

### Cache a view with known dimensions

`entity.cached(style)` and `AnyView::cached(style)` opt into reusing a rendered subtree. The supplied style determines the cached root's layout; GPUI does not render the contents to measure them on a cache hit. Give the cached view a definite size that matches its role in the parent layout. Use an ordinary `.child(entity)` when the parent should measure the contents.

Cache reuse also depends on the assigned bounds, content mask, text style,
resolved direction, and bidi mode. Notifying the view invalidates its cache.
`Window::refresh` forces a fresh render, and inspector picking disables the
view cache. See [`Entity::cached`](crate::Entity::cached) and
[`AnyView::cached`](crate::AnyView::cached).

**A redraw request is not the same as view invalidation.** Reading a shared
model during rendering tracks a dependency for the window. If the model changes,
the window can draw again while this cached view remains clean. Retain an
observation that calls `cx.notify()` on the view when the model notifies. Use
`observe_global` for global inputs, and notify the view when a parent changes
its fields. Reused input handlers keep their previous captures too. The
[cached-view test](https://gpui-ce.github.io/guides/testing/#check-that-a-shared-model-invalidates-a-cached-view)
shows the subscription and checks both reuse and the new painted color.

## Understand the frame phases

For each element value, GPUI calls these phases in order:

| Phase | What GPUI knows | What the element does |
| --- | --- | --- |
| [`Element::request_layout`](crate::Element::request_layout) | The element's style and inherited context | Registers layout nodes and optional measurement callbacks; returns request-layout state. |
| [`Element::prepaint`](crate::Element::prepaint) | Resolved bounds in logical pixels | Creates hitboxes and focus/accessibility data, prepares children, and returns prepaint state. |
| [`Element::paint`](crate::Element::paint) | Bounds and both phase states | Adds drawing operations and installs this frame's dispatch handlers. |

`RequestLayoutState` and `PrepaintState` connect work within that frame. They do not persist when the tree is rebuilt. Keep cross-frame values on the view/entity, in a state handle, or in element state accessed through a stable ID. [`LayoutId`](crate::LayoutId) identifies a layout node for the current layout pass; it is not an application key.

Layout runs between the request and prepaint. A requested width is an input
to that calculation; the resolved width is its result. A measured element
receives the available-space query through
[`Window::request_measured_layout`](crate::Window::request_measured_layout)'s
callback, which can run more than once. Construct the tree and register
measurements during `request_layout`; use the resulting bounds during
`prepaint` and `paint`.

Bounds are logical [`Pixels`](crate::Pixels); GPUI accounts for the window scale when resolving and painting. A layout box does not automatically clip arbitrary drawing. Containers with scrolling overflow apply a content mask to their children. Custom paint should stay within the active mask or narrow it with [`Window::with_content_mask`](crate::Window::with_content_mask).

### Add custom drawing with `canvas`

Use [`canvas`](crate::canvas) when layout can be described by style and only the prepaint/paint callbacks are custom. Prepaint runs after layout and can return frame-local data, such as a hitbox. Paint receives that value and records drawing commands. Both closures are consumed once for that element value, so construct a new canvas when the view renders again. The [drawing walkthrough](https://gpui-ce.github.io/examples/drawing/#paint) shows custom quads and masks; the [custom-element walkthrough](https://gpui-ce.github.io/examples/custom-element/) shows when to implement all three `Element` phases.

Implement [`Element`](crate::Element) directly when custom measurement or
layout, accessibility hooks, or child preparation is part of the behavior:

1. In `request_layout`, request the children's layout IDs and combine them
   into the parent node. Keep the child element values in the request state.
2. In `prepaint`, prepare those children using their resolved bounds and
   create hitboxes or other frame state.
3. In `paint`, paint the children and record the parent's drawing and handlers
   in their intended order.

The [custom-element walkthrough](https://gpui-ce.github.io/examples/custom-element/#draw)
implements a swatch with an empty request state and a prepared quad as its
prepaint state. Adding a child or a listener changes what those states must
carry; it does not change the phase order.

## Choose a layout constraint

GPUI uses a Taffy-backed layout engine. A definite available size gives it a
finite reference for a dimension; an explicitly sized child can still overflow.
[`AvailableSpace::MinContent`](crate::AvailableSpace::MinContent) and
[`AvailableSpace::MaxContent`](crate::AvailableSpace::MaxContent) ask for
intrinsic sizes; they do not mean zero and infinity as final element sizes.
A custom measured element should return a size appropriate to both the
dimensions already known and the available-space query. Parent constraints
and min/max styles can still limit the final size.

Scrolling content needs a finite viewport. A flexible text pane may need `.min_w_0()` so its intrinsic width does not prevent it from shrinking. The [layout walkthrough](https://gpui-ce.github.io/examples/layout/#constraints) shows a fixed sidebar beside a flexible pane. [`container_query`](crate::container_query) chooses its child after its own bounds are assigned, so that child cannot affect the query element's size; size the query container through its style or parent.

## Render large lists lazily

Use [`list`](crate::list) when row heights can differ. Keep its
[`ListState`](crate::ListState) on the owning view alongside the row data.
Splice or reset its row records when the data's shape changes; remeasure
existing rows when their height may have changed. Notify the owning view
after the update. The [`ListState` example](crate::ListState#keep-measurements-in-step-with-the-data) shows
both an append and an edited row.

By default, the list measures visible rows plus overdraw: extra content
prepared beyond the viewport to reduce work during scrolling. `measure_all`
measures every row, including again after invalidation. Uniform height hints
estimate unmeasured rows while actual measurements replace those estimates.

`ListSizingBehavior::Infer` sizes the list from its items, while `Auto` leaves size resolution to its style and parent constraints. Choose `Infer` when content should determine the list's measured size; a scroll view still needs a bounded viewport to scroll. See [`ListSizingBehavior`](crate::ListSizingBehavior).

Use [`uniform_list`](crate::uniform_list) when all rows share one height. It measures a representative row to calculate the visible range, then lays out that range. The callback receives a half-open range and must return one element per index, in the same order, with the same height as the measured row. It also receives separate one-item measurement requests. Do not expect one callback per frame or a callback for every item. Choose the representative row with [`UniformList::with_width_from_item`](crate::UniformList::with_width_from_item) when horizontal scrolling needs the widest content.

```rust
use gpui::{div, prelude::*, px, uniform_list, IntoElement, ParentElement};

let result_count = 10;
let rows = uniform_list("search-results", result_count, move |range, _window, _cx| {
    range
        .map(|index| div().h(px(28.)).child(format!("Result {index}")))
        .collect::<Vec<_>>()
});
```

Keep the list ID stable across frames. If rows can reorder and retain their own state, give each row a stable logical key or a distinct entity identity. Bind a [`UniformListScrollHandle`](crate::UniformListScrollHandle) with `.track_scroll(&handle)` when another element needs scroll state or controls. [`ScrollStrategy::Nearest`](crate::ScrollStrategy::Nearest) leaves an already visible item in place; when an item is outside the viewport it aligns above items to the top and below items to the bottom. Offset variants reserve space above the target for `Top` and `Center`; `Bottom` ignores the offset.

For horizontal sizing, [`ListHorizontalSizingBehavior::FitList`](crate::ListHorizontalSizingBehavior::FitList) supplies the viewport width to each row; it does not force an explicitly wider row to shrink. `Unconstrained` enables horizontal scrolling using the representative row's measured width. Wider unmeasured rows do not automatically enlarge that extent. Use `.w_full()` when a row's background or hit target should fill the available width.

For variable-height lists, [`ListAlignment::Bottom`](crate::ListAlignment::Bottom) is useful for chat-like content, and follow-tail behavior is managed by [`ListState::set_follow_mode`](crate::ListState::set_follow_mode). The [lists chapter](crate::_documentation::lists) connects sizing, scroll anchoring, data edits, and focus retention. See the [list walkthrough](https://gpui-ce.github.io/examples/lists/#rows) for a complete equal-height example.

## Load and paint images

[`img`](crate::img) accepts a resource key, file path, URI, encoded
[`Image`](crate::Image), decoded [`RenderImage`](crate::RenderImage), or
caller-owned loader. A pending load paints no image until it completes.
Assign a stable ID for delayed loading content or animation, and provide a
fallback for errors when an empty image would be confusing.

Resource images use an explicit or ancestor [`ImageCache`](crate::ImageCache)
when one is provided, and the app's typed asset cache otherwise. A custom
loader supplies its own completion notification. The
[assets chapter](crate::_documentation::assets) explains those ownership and
retry choices; [`StyledImage`](crate::StyledImage) configures fitting and
replacement content.

[`svg`](crate::svg) loads an SVG resource or raw bytes and can transform the
rendered image without changing its layout box or hitbox. [`surface`](crate::surface)
composites a platform surface or GPU texture supported by the selected renderer.
It needs a layout size; its source dimensions do not supply an intrinsic size.
See [GPU-owned images](crate::_documentation::drawing#composite-an-image-already-owned-by-the-gpu)
for device sharing, resizing, and redraws. [`ObjectFit`](crate::ObjectFit)
controls placement within a box, while a content mask controls clipping.

## Other element helpers

- [`anchored`](crate::anchored) places a subtree relative to a parent point or window point, then flips its anchor or snaps it into the window when it would overflow.
- [`deferred`](crate::deferred) draws above the main tree and escapes enclosing clipping while retaining the child's layout and keyboard dispatch parent. Use `content_mask` when the overlay needs an explicit clip. The [drawing chapter](crate::_documentation::drawing#choose-what-should-paint-above-what) combines deferral with anchored positioning.
- [`AnimationExt`](crate::AnimationExt) animates a component or element under a stable ID. The ID retains animation state between frames. These helpers respect reduced-motion settings; repeating animations keep scheduling frames while their element remains in the tree.

These helpers compose with `Div`, but their timing still matters: `container_query` chooses content after its size is known, `anchored` positions after child layout, and `deferred` changes paint order without removing the child from layout.

## Accessibility and interaction

An element enters the accessibility tree when it has a stable ID and either an accessibility role or is explicitly hidden. Hidden containers can omit their subtree from assistive technology. Synthetic accessibility children let a custom element expose content that has no corresponding GPUI element; add them after prepaint and provide the parent ID and role/hidden contract. See the [accessibility guide](crate::_accessibility).

`Div` combines style, children, and interaction. Attach handlers while building
the element tree; painting installs them in that frame's dispatch tree. A
later render must attach them again. Keep the state they update on an entity
or captured handle. Keyboard handlers follow the focus path; pointer handlers
run in paint order during capture and reverse paint order during bubble, with
element builders applying hitbox filters. Methods with a button or typed
payload apply that filter, while `*_all` methods expose the dispatch phase and
hitbox. Assign a stable ID before using the stateful interaction builders.
See [`InteractiveElement`](crate::InteractiveElement),
[`StatefulInteractiveElement`](crate::StatefulInteractiveElement), and the
[actions walkthrough](https://gpui-ce.github.io/examples/actions/#focus).

## Scene and renderer boundary

Element painting adds primitives to a [`Scene`](crate::Scene); renderer backends consume the resulting render plan. Preserve tree paint order when elements overlap. The [testing guide](https://gpui-ce.github.io/guides/testing/) explains how to exercise state, layout, and dispatch in a controlled app and when a platform run is still needed.
