# Build an element tree and render a frame

GPUI separates a component's description of the interface from the work that measures and draws it. A [`View`](crate::View) produces an [`Element`](crate::Element) tree. GPUI then requests layout, prepares interaction and accessibility data, and paints the tree into the window's scene.

Start with the component boundary that matches the component's ownership:

- Implement [`RenderOnce`](crate::RenderOnce) for an owned component assembled from parent-supplied values. It consumes the component and has no independent entity identity.
- Implement [`Render`](crate::Render) for a component stored in an [`Entity`](crate::Entity), with state that can notify and invalidate its own view through [`Context::notify`](crate::Context::notify).
- Implement [`Element`](crate::Element) when the component must control layout, prepaint, or paint. For a small custom drawing operation, [`canvas`](crate::canvas) often supplies enough control without a new element type.

These boundaries compose: a `RenderOnce` component can contain an entity handle, and a custom `Element` can contain child elements. The choice is about who owns state and when the component can participate in layout, not about how visually complex it is.

## Build a component from inputs

Derive `IntoElement` to use an owned component as a child. Its `render` method can consume fields and return the usual builder-based tree:

```rust
use gpui::{div, prelude::*, App, IntoElement, RenderOnce, SharedString, Window};

#[derive(IntoElement)]
struct Badge {
    label: SharedString,
}

impl RenderOnce for Badge {
    fn render(self, _window: &mut Window, _cx: &mut App) -> impl IntoElement {
        div().px_2().py_1().rounded_md().child(self.label)
    }
}
```

The parent creates another value when it renders again. Put durable state on an entity or use a stable element ID for a supported retained element state; a `RenderOnce` value does not receive notifications of its own. See [`RenderOnce`](crate::RenderOnce), [`Render`](crate::Render), and [`View`](crate::View).

## Give a stateful view an identity

A value implementing `Render` is stored in an entity. Embedding that entity as an element creates a view boundary: reads made while rendering are tracked, and notifying the entity invalidates its view. Rendering still describes the current tree; it is not a once-per-change callback, so do not make correctness depend on how many times `render` runs.

Each entity-backed view contributes its `EntityId` to the element identity path. Descendant state such as IDs and scroll state is scoped by that path. Do not render the same entity as two siblings under the same parent when both subtrees use retained descendant state; their paths can collide. For repeated rows, use distinct entities or stable IDs derived from each row's logical key rather than its current position. See [`View::entity_id`](crate::View::entity_id) and [`ElementId`](crate::ElementId).

### Cache a view with known dimensions

`entity.cached(style)` and `AnyView::cached(style)` opt into reusing a rendered subtree. The supplied style determines the cached root's layout; GPUI does not render the contents to measure them on a cache hit. Give the cached view a definite size that matches its role in the parent layout. Use an ordinary `.child(entity)` when the parent should measure the contents.

Cache reuse also depends on the assigned bounds, content mask, text style, resolved direction, and bidi mode. Entity notifications invalidate the cached view. `Window::refresh` forces a fresh render, and inspector picking disables the view cache. This is a rendering optimization; the view must still describe correct content whenever it is rendered. See [`Entity::cached`](crate::Entity::cached) and [`AnyView::cached`](crate::AnyView::cached).

## Understand the frame phases

For each element value, GPUI calls these phases in order:

| Phase | What GPUI knows | What the element does |
| --- | --- | --- |
| [`Element::request_layout`](crate::Element::request_layout) | Parent styles and available constraints | Creates layout nodes and returns request-layout state. |
| [`Element::prepaint`](crate::Element::prepaint) | Resolved bounds in logical pixels | Creates hitboxes and focus/accessibility data, prepares children, and returns prepaint state. |
| [`Element::paint`](crate::Element::paint) | Bounds and both phase states | Adds drawing operations and installs this frame's dispatch handlers. |

`RequestLayoutState` and `PrepaintState` connect work within that frame. They do not persist when the tree is rebuilt. Keep cross-frame values on the view/entity, in a state handle, or in element state accessed through a stable ID. [`LayoutId`](crate::LayoutId) identifies a layout node for the current layout pass; it is not an application key.

Bounds are logical [`Pixels`](crate::Pixels); GPUI accounts for the window scale when resolving and painting. A layout box does not automatically clip arbitrary drawing. Containers with scrolling overflow apply a content mask to their children. Custom paint should stay within the active mask or narrow it with [`Window::with_content_mask`](crate::Window::with_content_mask).

### Add custom drawing with `canvas`

Use [`canvas`](crate::canvas) when layout can be described by style and only the prepaint/paint callbacks are custom. Prepaint runs after layout and can return frame-local data, such as a hitbox. Paint receives that value and records drawing commands. Both closures are consumed once for that element value, so construct a new canvas when the view renders again. The [drawing walkthrough](https://gpui-ce.github.io/examples/drawing/#paint) shows custom quads and masks; the [custom-element walkthrough](https://gpui-ce.github.io/examples/custom-element/) shows when to implement all three `Element` phases.

Implement [`Element`](crate::Element) directly when custom measurement or layout, accessibility hooks, or the timing of child preparation is part of the behavior. In `request_layout`, request child layout IDs and combine them into the parent node. In `prepaint`, query each child's resolved bounds and prepare hitboxes or frame state. In `paint`, consume that prepared state. A useful element walkthrough should make each value's lifetime explicit.

## Choose a layout constraint

GPUI uses a Taffy-backed layout engine. A definite available size constrains a dimension. [`AvailableSpace::MinContent`](crate::AvailableSpace::MinContent) and [`AvailableSpace::MaxContent`](crate::AvailableSpace::MaxContent) ask for intrinsic sizes; they do not mean zero and infinity as final element sizes. A custom measured element should return a size appropriate to both the dimensions already known and the available-space query. Parent constraints and min/max styles can still limit the final size.

Scrolling content needs a finite viewport. A flexible text pane may need `.min_w_0()` so its intrinsic width does not prevent it from shrinking. The [layout walkthrough](https://gpui-ce.github.io/examples/layout/#constraints) shows a fixed sidebar beside a flexible pane. [`container_query`](crate::container_query) chooses its child after its own bounds are assigned, so that child cannot affect the query element's size; size the query container through its style or parent.

## Render large lists lazily

Use [`list`](crate::list) when row heights can differ. Keep its [`ListState`](crate::ListState) on the owning view and update the state when the data changes: splice/reset when rows are inserted, removed, or replaced; remeasure when existing rows may have changed height. By default, the list measures visible rows plus overdraw. `measure_all` makes the initial total height more accurate at the cost of measuring every item; uniform height hints estimate the scrollbar while rows are measured as they become visible.

`ListSizingBehavior::Infer` sizes the list from its items, while `Auto` leaves size resolution to its style and parent constraints. Choose `Infer` when content should determine the list's measured size; a scroll view still needs a bounded viewport to scroll. See [`ListSizingBehavior`](crate::ListSizingBehavior).

Use [`uniform_list`](crate::uniform_list) when all rows share one height. It measures one row and lays out the requested range arithmetically, avoiding per-row Taffy layout. The callback receives a half-open range and must return one element per index, in the same order, with the same block-axis size as the measured row. The list is virtualized: do not expect the callback to run for every item.

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

For horizontal sizing, [`ListHorizontalSizingBehavior::FitList`](crate::ListHorizontalSizingBehavior::FitList) keeps each row within the list width. `Unconstrained` allows a wide row to determine the horizontal content size and makes the uniform list horizontally scrollable.

For variable-height lists, [`ListAlignment::Bottom`](crate::ListAlignment::Bottom) is useful for chat-like content, and follow-tail behavior is managed by [`ListState::set_follow_mode`](crate::ListState::set_follow_mode). See the [list walkthrough](https://gpui-ce.github.io/examples/lists/#rows) for visible ranges and scrolling.

## Load and paint images

[`img`](crate::img) accepts a resource path/URI, already decoded renderer or CPU image data, or a caller-owned loader. Resource images use GPUI's asset system. A cache can be supplied directly, inherited from an ancestor [`image_cache`](crate::image_cache) element, or resolved through the global default. A pending resource load returns no image until it completes; the built-in retain-all cache schedules a notification so the owning view can render again. A custom loader must arrange notification when its result becomes available. Optional loading content appears after a short delay, and fallback content is used for a load error. Give animated images a stable ID so their frame index and timing persist and can schedule later frames. See [`ImageSource`](crate::ImageSource), [`ImageCache`](crate::ImageCache), and [`StyledImage`](crate::StyledImage).

[`svg`](crate::svg) loads an SVG resource or raw bytes and can transform the rendered image without changing its layout box or hitbox. [`surface`](crate::surface) composites a platform surface or GPU texture supported by the build target. Both are styled elements, but surface source variants are platform/feature dependent. Use [`ObjectFit`](crate::ObjectFit) to control how image content fits its bounds.

## Other element helpers

- [`anchored`](crate::anchored) places a subtree relative to a parent point or window point, then flips its anchor or snaps it into the window when it would overflow.
- [`deferred`](crate::deferred) keeps a child's layout but paints it in the deferred pass, after its ancestors. Use it for overlays that need to appear above surrounding content; deferred work has a depth limit.
- [`AnimationExt`](crate::AnimationExt) animates a component or element under a stable ID. The ID retains animation state between frames. These helpers respect reduced-motion settings; repeating animations keep scheduling frames while their element remains in the tree.

These helpers compose with `Div`, but their timing still matters: `container_query` chooses content after its size is known, `anchored` positions after child layout, and `deferred` changes paint order without removing the child from layout.

## Accessibility and interaction

An element enters the accessibility tree when it has a stable ID and either an accessibility role or is explicitly hidden. Hidden containers can omit their subtree from assistive technology. Synthetic accessibility children let a custom element expose content that has no corresponding GPUI element; add them after prepaint and provide the parent ID and role/hidden contract. See the [accessibility guide](crate::_accessibility).

`Div` combines style, children, and interaction. Event handlers are retained by the current element value, so bind them while building the tree and keep state in an entity or captured handle. Capture handlers run from the window toward the target; ordinary handlers bubble back toward the root. Methods with a button or typed payload apply that filter, while `*_all` methods expose the dispatch phase and hitbox. Assign a stable ID before using the stateful interaction builders. See [`InteractiveElement`](crate::InteractiveElement), [`StatefulInteractiveElement`](crate::StatefulInteractiveElement), and the [actions walkthrough](https://gpui-ce.github.io/examples/actions/#focus).

## Scene and renderer boundary

Element painting adds primitives to a [`Scene`](crate::Scene); renderer backends consume the resulting render plan. Preserve tree paint order when elements overlap. The [testing guide](https://gpui-ce.github.io/guides/testing/) explains how to exercise state, layout, and dispatch in a controlled app and when a platform run is still needed.
