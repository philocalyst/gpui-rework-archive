#[path = "../src/support.rs"]
mod support;

// ## Give the row a height {#frame}
// The layout has a header above two panes. Its root is a column of [`div`]
// elements; the content row takes the height left after the header, padding,
// and gap. `min_h_0` allows that row to shrink when the window is short.
//
// [`Styled`] builders describe constraints for the layout engine. Spacing such
// as `p_6` and `gap_4` follows the rem scale; `px(40.)` requests a size in logical
// pixels. Neither unit should be multiplied by the display scale factor.

use gpui::{AppContext, Context, IntoElement, Render, Window, div, prelude::*, px, rgb};

struct LayoutDemo;

// ## Let one pane yield {#constraints}
// The right pane requests 180 logical pixels and disables shrinking. The
// left pane uses [`Styled::flex_1`] to take the remaining space, then sets
// [`Styled::min_w`] to zero so its content does not impose a larger minimum.
// [`Styled::flex_shrink`] allows it to give space back when the row narrows.
//
// Resize the preview. The green pane yields while the orange pane keeps its
// width. Below the fixed pane's width plus padding and gap, the row cannot fit:
// these constraints describe a desktop layout, not a responsive breakpoint.

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

// ## Try a different constraint {#run}
// The platform helper mounts this [`Render`] view in a window. Change the
// fixed width from 180 to 100 and run again, then remove `min_w_0` from the
// flexible pane. Compare where the long label wraps and which pane yields.
// The same tree runs in the native example and browser preview.

fn component(_window: &mut Window, cx: &mut gpui::App) -> gpui::Entity<LayoutDemo> {
    cx.new(|_cx| LayoutDemo)
}

pub fn main() {
    support::run(component);
}
