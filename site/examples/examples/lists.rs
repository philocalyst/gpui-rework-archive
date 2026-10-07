#[path = "../src/support.rs"]
mod support;

// ## Reserve a scrolling viewport {#viewport}
// The list contains 10,000 rows but constructs only the range needed near the
// viewport. [`uniform_list`] can compute that range because each row has the
// same height. The parent reserves 320 logical pixels; the list fills it.
//
// An unbounded height gives scrolling no useful viewport. Keep the scrolling
// region constrained even when its parent can grow.

use gpui::{
    AppContext, Context, IntoElement, Render, UniformListScrollHandle, Window, div, prelude::*, px,
    rgb, uniform_list,
};

struct Rows {
    scroll: UniformListScrollHandle,
}

// ## Build the requested range {#rows}
// The [`uniform_list`] callback receives a half-open range of indices.
// Return one row per index, in that order. Building these rows inside the
// callback avoids first constructing a vector of all 10,000 elements.
//
// [`UniformList::track_scroll`] attaches the view's handle to this list.
// The list's stable ID retains its interaction state. Give interactive rows
// their own logical IDs when that state should follow reordered data.
//
// > [!WARNING]
// > Every row must have the same height. Wrapping text or expanding a row can
// > violate that rule and produce incorrect scroll positions. Use a measured,
// > variable-height list for those layouts.

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
                    .child("10,000 uniform rows"),
            )
            .child(
                div().h(px(320.)).w_full().child(
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

// ## Keep the handle between renders {#run}
// Create the [`UniformListScrollHandle::new`] handle once on the view and
// pass it back on every render. A toolbar can keep a clone to call
// `scroll_to_item`; both clones control the same list position.
//
// Scroll halfway down, resize, and continue scrolling. The visible range
// changes while the handle and 10,000-item extent remain. Read the
// [list guide](@/guides/lists.md) when row heights need to vary.

fn component(_window: &mut Window, cx: &mut gpui::App) -> gpui::Entity<Rows> {
    cx.new(|_cx| Rows {
        scroll: UniformListScrollHandle::new(),
    })
}

pub fn main() {
    support::run(component);
}
