#[path = "../src/support.rs"]
mod support;

// ## Give the row a height {#frame}
// The layout has a header above two panes. Its root is a column of [`div`]
// elements; the content row takes the height left after the header, padding,
// and gap. `min_h_0` removes the row's automatic minimum-content floor, so it
// can shrink when the window is short instead of forcing overflow.
//
// [`Styled`] builders describe constraints for the layout engine. Spacing such
// as `p_6` and `gap_4` uses the rem scale; `px(40.)` uses logical pixels. GPUI
// applies the window scale factor at the platform boundary, so do not multiply
// either value by the monitor's device-pixel ratio yourself.

use gpui::{AppContext, Context, IntoElement, Render, Window, div, prelude::*, px, rgb};

struct LayoutDemo;

// ## Let one pane yield {#constraints}
// The right pane requests 180 logical pixels and disables shrinking. The left
// pane uses [`Styled::flex_1`] to take the remaining width, sets
// [`Styled::min_w`] to zero so its text's min-content width does not force the
// row wider, and permits shrinking through [`Styled::flex_shrink`]. These
// constraints work together: flex growth allocates remaining space; shrink
// and minimum size govern what happens when the row has too little.
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
// fixed width from 180 to 100 and observe the flexible pane gain room. Then
// remove `min_w_0`: the long text's minimum-content width can keep the row from
// shrinking as far. This shows how intrinsic content size interacts with flex
// sizing; it is not a responsive breakpoint.

fn component(_window: &mut Window, cx: &mut gpui::App) -> gpui::Entity<LayoutDemo> {
    cx.new(|_cx| LayoutDemo)
}

pub fn main() {
    support::run(component);
}
