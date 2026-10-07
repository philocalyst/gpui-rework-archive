#[path = "../support.rs"]
mod support;

// docs:step frame | Start with a flow and a stable anchor
// A layout is a tree of ordinary elements. `div()` creates a `Div`; the fluent
// `Styled` methods below describe the constraints that Taffy resolves. The root
// fills the window, then lays its children out in a column with a fixed gap.
//
// The `id` on the content pane is stable across frames. It gives GPUI one
// identity for that position, so hit testing and any descendant state follow
// the pane when its text or parent constraints change. Watch the preview while
// resizing the window: the header stays at the top and the content pane keeps
// the remaining height because the root uses `flex_1` on that child.
//
// The values are logical pixels. `p_6` and `gap_4` come from GPUI's rem-based
// spacing scale, while `h(px(40.))` and `w(px(180.))` state exact constraints.
// That mix is useful in real interfaces: a rhythm can follow the text scale,
// while a toolbar or a control column can still reserve a known width.
// docs:api gpui::Styled gpui::Div gpui::div
// docs:code
use gpui::{AppContext, Context, IntoElement, Render, Window, div, prelude::*, px, rgb};

struct LayoutDemo;
// docs:end

// docs:step constraints | Make a narrow pane behave
// The two children share a row. The flexible pane is allowed to shrink to zero
// in the inline axis with `min_w_0`; without that lower bound, a long unbroken
// label can force the row wider than its parent. `flex_shrink_1` lets it give
// space back when the fixed pane needs its 180 logical pixels. The fixed pane
// opts out of shrinking, so its controls remain usable.
//
// Try making the preview narrower than both panes together. The left pane
// yields first, while the right pane keeps its width. The background colors make
// the constraint boundary visible without hiding the actual layout behavior.
// docs:api gpui::Styled::min_w gpui::Styled::flex_shrink gpui::Styled::flex_1
// docs:code
impl Render for LayoutDemo {
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
                    .h(px(40.))
                    .flex()
                    .items_center()
                    .px_3()
                    .bg(rgb(0x155b50))
                    .text_color(rgb(0xffffff))
                    .child("A stable header in normal flow"),
            )
            .child(
                div()
                    .id("content")
                    .flex_1()
                    .min_h_0()
                    .flex()
                    .gap_4()
                    .child(
                        div()
                            .flex_1()
                            .min_w_0()
                            .flex_shrink_1()
                            .p_4()
                            .bg(rgb(0xdbeee8))
                            .text_color(rgb(0x202b29))
                            .child("This pane yields before its sibling when the row gets narrow."),
                    )
                    .child(
                        div()
                            .w(px(180.))
                            .flex_shrink_0()
                            .p_4()
                            .bg(rgb(0xffd8a8))
                            .text_color(rgb(0x202b29))
                            .child("Fixed pane"),
                    ),
            )
    }
}
// docs:end

// docs:step run | Open the same view on every platform
// The example's view is plain Rust. `support::run` selects the native or web
// platform, opens a window, and mounts the entity created by `cx.new`. No
// layout code changes between the two previews, so resizing the browser and a
// native window exercises the same constraints.
//
// The complete program is intentionally small: the interesting part is the
// relationship between flow, stable identity, and competing width constraints.
// Open the example and drag the window edge slowly. Notice that the header is
// still part of normal flow; nothing is positioned by a screen coordinate. The
// content pane receives whatever height remains after padding, gap, and header,
// which is the same rule you can reuse for an editor beside a sidebar.
// docs:api gpui::Render gpui::Context gpui::AppContext
// docs:code
pub fn main() {
    support::run(|_window, cx| cx.new(|_cx| LayoutDemo));
}
// docs:end
