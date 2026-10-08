# Lists, measurement, and scroll position

A large collection should not require a large element tree. GPUI's list
elements build rows as they need them, keeping a small viewport over data
owned by your application. Choosing between them comes down to one question:
can a single measured height describe every row?

| Content | Start with | Keep on the owning view |
| --- | --- | --- |
| Equal-height search results, file names, or table rows | [`uniform_list`](crate::uniform_list) | A [`UniformListScrollHandle`](crate::UniformListScrollHandle) when controls need to scroll or inspect geometry |
| Wrapped messages, expanding details, or mixed row heights | [`list`](crate::list) | A [`ListState`](crate::ListState), alongside the row data |

The [10,000-row walkthrough](https://gpui-ce.github.io/examples/lists/#viewport)
shows the equal-height case. Change its viewport width, scroll far into the
collection, and inspect the requested range. The number of rows in the data
does not dictate the number of elements constructed for a frame.

## Give the collection a viewport

A viewport is the rectangle through which the reader sees the collection.
Its height must be smaller than the content height for vertical scrolling to
help. Set that height directly, or let a bounded parent assign it through
flex layout. In a column, a shrinking list may also need `.min_h_0()` so its
minimum size does not resist the parent's constraint. See the
[layout chapter](crate::_documentation::layout) for available space and flex
minimums.

Both list types default to [`ListSizingBehavior::Auto`](crate::ListSizingBehavior::Auto):
their style and parent resolve the viewport size. `Infer` instead supplies
an intrinsic content size. A uniform list multiplies one row height by its
count; a variable-height list sums the measurements and estimates it has.
Definite available height caps that inferred height. Without a finite
constraint, the list can grow to its content height and lose the benefit of
virtualization.

Rows lay out as separate roots. Having the viewport width *available* does
not make a row fill it. Use `.w_full()` when its background, selection, or
click target should span the list. For horizontal scrolling in a uniform
list, choose [`ListHorizontalSizingBehavior::Unconstrained`](crate::ListHorizontalSizingBehavior::Unconstrained)
and select a suitably wide representative row with
[`with_width_from_item`](crate::UniformList::with_width_from_item). The list
does not discover the widest row by measuring the whole collection.

## Keep uniform rows uniform

[`uniform_list`](crate::uniform_list) asks its callback for a half-open range:
`12..20` means eight elements, in order, for indices 12 through 19. It also
asks for individual rows to measure. A callback can therefore run several
times in one frame. Return elements; keep tasks, subscriptions, and persistent
row state on their owning entities rather than creating them on each request.

The representative row supplies the height used for every index calculation.
All rows must resolve to that same positive height at the current width.
The height may change between frames if it changes consistently for all rows.

> [!WARNING]
> Equal heights are a requirement, not an optimization hint. One wrapped label
> or expanded details panel can invalidate the mapping from scroll distance to
> row index. Constrain the content to a shared height, or use [`list`](crate::list)
> and let each row contribute its own measurement.

The uniform list requests rows intersecting the viewport, including partially
visible rows, and separate measurement samples. It has no configurable
overdraw region. The variable-height list's `overdraw` setting belongs to
[`ListState::new`](crate::ListState::new).

## Queue a scroll, then render it

A retained handle lets a toolbar and list refer to the same scroll position.
Create it with the view, bind it each render, and notify after queuing a
programmatic scroll. The request becomes geometry during the next prepaint;
reading the handle immediately after the request still returns the previous
geometry.

```rust
use gpui::{
    div, prelude::*, px, uniform_list, Context, IntoElement, Role, ScrollStrategy,
    UniformListScrollHandle, Window,
};

struct Results {
    scroll: UniformListScrollHandle,
}

impl Results {
    fn new() -> Self {
        Self { scroll: UniformListScrollHandle::new() }
    }
}

impl Render for Results {
    fn render(&mut self, _window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        div().flex().flex_col().w(px(320.)).h(px(240.))
            .child(
                div().id("jump-to-result").child("Show result 5,000")
                    .role(Role::Button).aria_label("Show result 5,000").tab_index(0)
                    .focus_visible(|style| style.ring_2()).cursor_pointer()
                    .on_click(cx.listener(|view, _event, _window, cx| {
                        view.scroll.scroll_to_item(5_000, ScrollStrategy::Center);
                        cx.notify();
                    })),
            )
            .child(
                uniform_list("results", 10_000, |range, _window, _cx| {
                    range.map(|index| {
                        div().w_full().h(px(28.)).child(format!("Result {index}"))
                    }).collect::<Vec<_>>()
                })
                .flex_1().min_h_0().track_scroll(&self.scroll),
            )
    }
}
```

[`scroll_to_item`](crate::UniformListScrollHandle::scroll_to_item) leaves a
fully visible item where it is. For an offscreen item, the strategy chooses
its alignment. Use the strict variant to align an already visible item too.
[`ScrollStrategy::Nearest`](crate::ScrollStrategy::Nearest) always leaves a
visible item in place and otherwise moves only far enough to reveal it.
All strategies clamp at the collection's ends.

Handle clones share one pending item request; a later request replaces an
earlier unconsumed one. Reuse a handle for one list, and use separate handles
for independent lists. For an unflipped list, the underlying pixel offset is
negative as content moves upward. With
[`y_flipped`](crate::UniformList::y_flipped), item requests still use logical
indices while rows appear in reverse order. Check each geometry method's
coordinate convention: physical bottom and logical end are then different
places.

## Keep measured rows in step with data

A [`ListState`](crate::ListState) remembers row geometry, focus handles, and
scroll position. It does not own the collection. If the data changes without
a matching state update, old measurements can be attached to new rows.
Change both, then notify the owning view.

> [!WARNING]
> The row renderer and scroll handler run while `ListState` is mutably borrowed.
> Querying or changing that same state from either callback panics. Build rows
> from the supplied index and your view's data; inspect scrolling through the
> event's fields. Use [`Window::defer`](crate::Window::defer) for a state change
> that must follow one of those callbacks, and request a redraw afterward.

| Change to the data or presentation | Update the retained state |
| --- | --- |
| Insert, remove, or replace a contiguous range | [`splice`](crate::ListState::splice), or `splice_focusable` for rows that need focus retention |
| Replace the entire collection | [`reset`](crate::ListState::reset) |
| Edit a row whose height may change | [`remeasure_items`](crate::ListState::remeasure_items) |
| Scale the same rows after a font or zoom change | [`remeasure`](crate::ListState::remeasure) |
| Change the viewport width | Measurements are invalidated automatically |

The [append and edit example](crate::ListState#keep-measurements-in-step-with-the-data)
keeps the collection and row records together. `splice` preserves records
outside the replacement range and shifts a later scroll anchor with them.
`reset` discards every row record and clears the explicit scroll anchor. The
configured alignment and follow policy choose the next position; use a reset
when retaining old geometry would make no sense.

Remeasurement also needs an anchoring rule. Suppose the viewport starts
40 pixels into a 100-pixel row, and that row shrinks to 50 pixels.
`remeasure` preserves the fraction: the new offset is 20 pixels.
`remeasure_items` preserves the absolute offset, clamping if necessary:
the new offset remains 40 pixels. This makes the latter useful for a message
that grows as text arrives. Neither operation changes the row count.

By default, the variable-height list measures visible rows and extra content
above and below them, set by `overdraw`. Unknown heights mean its scrollbar
geometry can change as more rows are measured. A
[`uniform height hint`](crate::ListState::with_uniform_item_height) gives
unmeasured rows an estimate; actual measurements replace it.
[`measure_all`](crate::ListState::measure_all) instead measures every row on
the first pass and after measurement resets. That can be expensive. It does
not restart a completed eager pass on `splice` alone; see the method's
invalidation contract before relying on exact total geometry after an append.

## Separate an item's key from its index

An index answers “where is this item now?” A stable key answers “which item
is this?” Inserting at index zero changes every later index without changing
those items' identities. Use indices to read current data and stable keys
for stateful row IDs. Keep entity-backed row state on those same logical
items so filtering or reordering does not transfer an editor, animation, or
selection to a different row. The
[ownership chapter](crate::_ownership_and_data_flow#give-retained-element-state-an-identity)
explains how element IDs retain state across frames.

Virtualization also removes offscreen rows from the ordinary element tree.
For a variable-height list, register row focus handles with
[`splice_focusable`](crate::ListState::splice_focusable) and attach each
handle to its row's keyboard target. The list then keeps a row containing
focus in the rendered tree even outside the viewport. Registering the handle
does not focus the row or install keyboard handlers. See
[input and focus](crate::_documentation::input) for those steps.

## Follow new content without trapping the reader

[`ListAlignment::Bottom`](crate::ListAlignment::Bottom) chooses a default
anchor. [`scroll_to_end`](crate::ListState::scroll_to_end) requests the end
once. [`FollowMode::Tail`](crate::FollowMode::Tail) adds a policy: stay at the
end as content grows, pause when the reader scrolls toward earlier rows, and
resume when they return to the bottom.

Set tail-following when the user chooses it. Setting it on every render would
repeatedly undo their attempt to read older content. Use
[`pause_following_tail`](crate::ListState::pause_following_tail) when an
application-driven size change should leave the reader in place while
keeping the return-to-bottom policy enabled.

Test the resulting viewport, not just a successful call to a scroll method.
Draw after a data edit or queued scroll, then assert which rows or geometry
the reader sees. For a variable-height list, include an edited top row, an
insertion before the viewport, and a reader who has paused tail-following.
For a uniform list, resize the viewport and verify a distant row remains
reachable. The
[painted-row test](https://gpui-ce.github.io/book/testing.html#check-the-row-after-a-scroll-request)
does this with row 5,000, then resizes the same window and checks its new bounds.
