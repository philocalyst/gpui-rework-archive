# Show long lists and scroll

A container that scrolls needs an [`ElementId`] and an overflow setting. For
long lists, render only the rows on screen: [`uniform_list`] when every row has
the same height, or [`list`] with a [`ListState`] when rows vary in height.

## Scroll a container

Give a [`Div`] an ID, set its overflow to scroll and track it with a
[`ScrollHandle`]. Keep the handle on your view, so you can read and change the
position later:

```rust
# use gpui::*;
struct Log {
    scroll: ScrollHandle,
    lines: Vec<String>,
}

impl Render for Log {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        div()
            .id("log")
            .h(px(300.))
            .overflow_y_scroll()
            .track_scroll(&self.scroll)
            .children(self.lines.iter().enumerate().map(|(ix, line)| {
                div().id(ix).h(px(24.)).child(line.clone())
            }))
    }
}
```

Every child is laid out on every frame. That is fine for dozens or a few hundred
rows. For thousands, use one of the list elements below.

## Read and set the scroll position

[`ScrollHandle`] reads the state from the last frame, and changes it for the next:

- [`ScrollHandle::offset`] is the distance from the top of the container to the
  top of its first child. It is zero or negative, and it becomes more negative
  as you scroll down.
- [`ScrollHandle::max_offset`] is how far the content can scroll, as a positive
  distance.
- [`ScrollHandle::set_offset`] sets the offset directly.
- [`ScrollHandle::scroll_to_bottom`] and [`ScrollHandle::scroll_to_item`] are
  applied when the next frame is prepared. `scroll_to_item` scrolls the least
  amount that makes the child fully visible. [`ScrollHandle::scroll_to_top_of_item`]
  puts the child at the top instead.
- [`ScrollHandle::top_item`] and [`ScrollHandle::bottom_item`] return the indices
  of the children at the edges of the viewport.

```rust
# use gpui::*;
# struct Log {
#     scroll: ScrollHandle,
# }
# impl Render for Log {
#     fn render(&mut self, _: &mut Window, _: &mut Context<Self>) -> impl IntoElement {
#         div()
#             .id("log")
#             .h(px(300.))
#             .overflow_y_scroll()
#             .track_scroll(&self.scroll)
#             .children((0..200).map(|ix| div().id(ix).h(px(24.)).child(format!("line {ix}"))))
#     }
# }
# let mut app = TestApp::new();
# let mut window = app.open_window(|_, _| Log { scroll: ScrollHandle::new() });
window.update(|log, _window, _cx| log.scroll.scroll_to_bottom());
window.draw();
window.read(|log, _| assert!(log.scroll.offset().y < px(0.)));
```

## Scroll equal-height rows with `uniform_list`

[`uniform_list`] renders only the visible range. Its callback receives the
`Range<usize>` of the indices on screen and returns those rows. Every row must have the
same height, because the list finds a row's position from its index. Use
[`Context::processor`] to reach your view from the callback:

```rust
# use gpui::*;
# use std::ops::Range;
struct Contacts {
    names: Vec<String>,
    scroll: UniformListScrollHandle,
}

impl Render for Contacts {
    fn render(&mut self, _window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        uniform_list(
            "contacts",
            self.names.len(),
            cx.processor(|this, range: Range<usize>, _window, _cx| {
                range
                    .map(|ix| div().id(ix).h(px(32.)).child(this.names[ix].clone()))
                    .collect::<Vec<_>>()
            }),
        )
        .track_scroll(&self.scroll)
        .size_full()
    }
}
# let mut app = TestApp::new();
# let mut window = app.open_window(|_, _| Contacts {
#     names: (0..1000).map(|ix| format!("Contact {ix}")).collect(),
#     scroll: UniformListScrollHandle::new(),
# });
# window.update(|contacts, _window, _cx| contacts.scroll.scroll_to_item(500, ScrollStrategy::Top));
# window.draw();
```

Keep the [`UniformListScrollHandle`] on your view, and call
[`UniformListScrollHandle::scroll_to_item`] with a [`ScrollStrategy`]. The
strategy decides where the row lands when the list has to move:

- [`ScrollStrategy::Nearest`] moves the least amount. Use it for keyboard selection.
- [`ScrollStrategy::Top`], [`ScrollStrategy::Center`] and [`ScrollStrategy::Bottom`]
  put the row at that edge of the viewport, or as close as the list allows.
- [`UniformListScrollHandle::scroll_to_item`] does nothing when the row is
  already fully visible. [`UniformListScrollHandle::scroll_to_item_strict`]
  applies the strategy every time, even then.

```rust
# use gpui::*;
# struct Contacts {
#     scroll: UniformListScrollHandle,
# }
# impl Contacts {
fn select_row(&mut self, ix: usize, cx: &mut Context<Self>) {
    self.scroll.scroll_to_item(ix, ScrollStrategy::Nearest);
    cx.notify();
}
# }
```

## Scroll rows of different heights with `list`

[`list`] takes rows of any height. It keeps a [`ListState`] on your view, which
records each row's measured height and the scroll position as an index and an
offset inside that row. The render callback runs only for rows that are visible
or in the overdraw region:

```rust
# use gpui::*;
# use std::rc::Rc;
struct Feed {
    state: ListState,
    items: Rc<Vec<String>>,
}

impl Feed {
    fn new() -> Self {
        let items = vec!["Welcome".to_string()];
        Self {
            state: ListState::new(items.len(), ListAlignment::Top, px(200.)),
            items: Rc::new(items),
        }
    }

    fn push(&mut self, text: String, cx: &mut Context<Self>) {
        let old_count = self.items.len();
        Rc::make_mut(&mut self.items).push(text);
        self.state.splice(old_count..old_count, 1);
        cx.notify();
    }
}

impl Render for Feed {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        let items = self.items.clone();
        list(self.state.clone(), move |ix, _window, _cx| {
            div().p_2().child(items[ix].clone()).into_any_element()
        })
        .size_full()
    }
}
# let mut app = TestApp::new();
# let mut window = app.open_window(|_, _| Feed::new());
# window.update(|feed, _window, cx| feed.push("Hello".to_string(), cx));
# window.draw();
# window.read(|feed, _| assert_eq!(feed.state.item_count(), 2));
```

A [`ListState`] is cheap to clone, and clones share the same state. Keep one on
your view and pass a clone to [`list`]. The overdraw passed to [`ListState::new`]
is extra space rendered above and below the viewport, which hides rows popping in
while you scroll.

Tell the state what changed:

- [`ListState::splice`] replaces a range of items with a number of new ones. Use
  it when items are added, removed or moved. `splice(old_count..old_count, 1)`
  appends one.
- [`ListState::reset`] replaces every item and drops the scroll position.
- [`ListState::remeasure_items`] marks a range for re-measurement when its content
  changes height but the items stay, such as streaming text. It keeps the scroll
  position.
- [`ListState::remeasure`] re-measures everything and keeps the position
  proportionally, for when the font size changes.

Other methods:

- [`ListAlignment::Bottom`] anchors the list to the bottom, as a chat log does.
  With [`FollowMode::Tail`], set through [`ListState::set_follow_mode`], the list
  keeps the newest item in view until the user scrolls up.
- [`ListState::scroll_to_reveal_item`] scrolls one item fully into view.
- [`ListState::scroll_to_end`] scrolls past the last item. Use it when that item
  is still growing.
- [`ListState::logical_scroll_top`] returns the current [`ListOffset`].

## How virtualization works, and what it costs

Both list elements lay out and paint only the rows in the viewport, plus the
overdraw. Scrolling a long list costs about the same as scrolling a short one,
because the work depends on the rows on screen, not on the total count.

The costs are these:

- [`uniform_list`] measures one row and assumes every row matches it. A row that
  is taller than the others pushes the rows below it out of place.
- [`list`] does not know a row's height until it renders the row. Until then it
  counts the row as zero pixels tall, so the scrollbar thumb can change size as
  you scroll. [`ListState::measure_all`] measures every row on the first frame,
  which is expensive for a large list. [`ListState::with_uniform_item_height`]
  and [`ListState::reset_with_uniform_height`] give unrendered rows an estimated
  height instead.
- Rows that are off screen are not rendered, so state held by row elements is
  dropped. Keep data on your view, not in rows.
- A row that holds keyboard focus stays rendered while it is off screen, if you
  add it with [`ListState::splice_focusable`].

## See also

- [List example](crate::_documentation::examples::list), a 10,000-row
  `uniform_list` with keyboard selection. Run it with `cargo run --example list`.
- [Layout and style](crate::_documentation::concepts::layout_and_style) for how
  a container's size is decided.
- [The frame](crate::_documentation::concepts::the_frame) for when layout and
  paint run.
- [Performance](crate::_documentation::guides::performance) for finding slow frames.
