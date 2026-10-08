#[path = "../src/support.rs"]
mod support;

// ## Reserve a scrolling viewport {#viewport}
// The data set has 10,000 indices, but the callback constructs only the rows
// intersecting the viewport, plus separate one-row samples for measurement.
// [`uniform_list`] maps scroll offsets to indices using one shared row height.
// The parent requests 320 logical pixels and may shrink in a short window;
// the list fills the resulting finite scrolling viewport.
//
// An unbounded height gives scrolling no useful viewport. Keep the scrolling
// region constrained even when its parent can grow.

use gpui::{
    AppContext, Context, IntoElement, Render, UniformListScrollHandle, Window, div, prelude::*, px,
    rgb, text, uniform_list,
};

struct Rows {
    scroll: UniformListScrollHandle,
}

// ## Build the requested range {#rows}
// The [`uniform_list`] callback receives a half-open index range: the start is
// included and the end is excluded. Return one row for each index, in order.
// Constructing rows in this callback avoids building 10,000 element values
// before the list knows which ones it needs.
// The callback can also receive a one-row measurement request more than once
// in a frame. Build the requested elements there; keep data loading and other
// work that should happen once on the owning view.
//
// [`UniformList::track_scroll`] connects the view-owned scroll handle to this
// list. The list ID identifies the scrolling element; row IDs identify any
// per-row interaction state. Use stable logical keys for rows when data can be
// reordered, since an index names a position rather than an item.
// Here `text!(id = ix, ...)` distinguishes labels created at the same source
// location. Only the constructed rows appear in the accessibility tree; a
// virtualized viewport does not expose all 10,000 rows at once.
//
// > [!WARNING]
// > Every row must have the same block-axis height. Wrapping text or expanding
// > one row breaks the estimate used to map offsets to indices, so visible
// > rows and scrollbar positions can be wrong. Use [list](https://docs.rs/gpui-ce/0.2.2/gpui/fn.list.html) for individually
// > measured, variable-height rows.

impl Render for Rows {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        div()
            .size_full()
            .p_6()
            .flex()
            .flex_col()
            .gap_4()
            .bg(rgb(0xf7f6f2))
            .child(
                div()
                    .text_2xl()
                    .text_color(rgb(0x202b29))
                    .child(text!("10,000 uniform rows")),
            )
            .child(
                div().h(px(320.)).min_h_0().w_full().child(
                    uniform_list("rows", 10_000, |range, _window, _cx| {
                        range
                            .map(|ix| {
                                div()
                                    .h_8()
                                    .flex()
                                    .items_center()
                                    .px_3()
                                    .bg(if ix % 2 == 0 {
                                        rgb(0xffffff)
                                    } else {
                                        rgb(0xe8efed)
                                    })
                                    .text_color(rgb(0x202b29))
                                    .child(text!(id = ix, format!("Row {ix}")))
                            })
                            .collect()
                    })
                    .size_full()
                    .track_scroll(&self.scroll),
                ),
            )
    }
}

// ## Keep the handle between renders {#run}
// Create the [`UniformListScrollHandle::new`] handle once on the view and
// pass it back on every render. A toolbar can keep a clone to call
// `scroll_to_item`; both clones control the same list position. That method
// queues a request, so the toolbar must also notify the view to draw it.
//
// Scroll halfway down, resize the viewport, then continue scrolling. The
// requested range should change while the same handle keeps the scroll
// position. For insertion, deletion, or variable-height rows, follow the
// mutation and remeasurement guidance in the [list guide](@/guides/lists.md).

fn component(_window: &mut Window, cx: &mut gpui::App) -> gpui::Entity<Rows> {
    cx.new(|_cx| Rows {
        scroll: UniformListScrollHandle::new(),
    })
}

pub fn main() {
    support::run(component);
}
