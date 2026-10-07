#[path = "../support.rs"]
mod support;

// docs:step viewport | Give a virtual list a real viewport
// A large collection should not create one element per row. `uniform_list`
// receives the item count and renders only the visible range plus a small amount
// of overdraw. Its own scroll style needs a definite height, so the parent
// gives it a 320 logical-pixel viewport and lets the list fill that space.
//
// Every row below uses the same `h_8` height. That invariant is what lets
// `UniformList` compute the visible range without measuring all 10,000 rows.
// Resize the preview and scroll: the callback keeps receiving a narrow range,
// while the scrollbar still represents the complete collection.
//
// The viewport is deliberately outside the list. That boundary is where a
// parent decides how much screen space scrolling may consume; the list then
// owns the scroll offset and virtual children inside it. If the parent offers
// unbounded height, there is no useful viewport to virtualize against.
// docs:api gpui::uniform_list gpui::UniformList gpui::Styled
// docs:code
use gpui::{
    AppContext, Context, IntoElement, Render, UniformListScrollHandle, Window, div, prelude::*, px,
    rgb, uniform_list,
};

struct Rows {
    scroll: UniformListScrollHandle,
}
// docs:end

// docs:step rows | Render only the requested indices
// The callback receives a half-open `Range<usize>`. Return rows in that same
// order; GPUI associates each element with its index and uses the measured item
// height to place the range. The row text is deliberately simple so the example
// keeps attention on virtualization and the viewport constraint.
//
// `track_scroll` connects the view-owned handle to the list. Keep that handle
// in the view, as shown here, when another control needs to scroll or inspect
// the list. The row identity comes from the list's stable `id` string.
//
// This callback does not receive an application model or a prebuilt vector. It
// receives indices, creates only those elements, and lets the list discard them
// when they leave the overdraw window. That is the important difference from
// mapping 10,000 values into one large `Vec<Div>` before rendering.
// docs:api gpui::uniform_list gpui::UniformListScrollHandle::new gpui::UniformList::track_scroll
// docs:code
impl Render for Rows {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        div()
            .size_full()
            .p_6()
            .flex()
            .flex_col()
            .gap_4()
            .bg(rgb(0xf7f6f2))
            .child(div().text_2xl().text_color(rgb(0x202b29)).child("10,000 uniform rows"))
            .child(
                div()
                    .h(px(320.))
                    .w_full()
                    .child(
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
                                        .child(format!("Row {ix}"))
                                })
                                .collect()
                        })
                        .size_full()
                        .track_scroll(&self.scroll),
                    ),
            )
    }
}
// docs:end

// docs:step run | Keep state with the view
// `cx.new` creates the entity that owns the scroll handle. Re-rendering passes
// the same handle back to the list, so a scroll position survives frames. The
// support harness opens the same program natively and in the browser preview.
//
// Scroll to the middle, resize the window, and scroll again. The list will ask
// for the new visible range while retaining the same 10,000-item extent.
// The handle is cheap to clone, so a toolbar can keep another clone and call
// `scroll_to_item` later without changing the row callback. The list remains
// responsible for translating that request into the next visible range.
// docs:api gpui::Render gpui::Context gpui::AppContext
// docs:code
pub fn main() {
    support::run(|_window, cx| {
        cx.new(|_cx| Rows {
            scroll: UniformListScrollHandle::new(),
        })
    });
}
// docs:end
