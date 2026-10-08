use gpui::{AppContext, Context, IntoElement, Render, Window, div, prelude::*, px, rgb, text};

struct LayoutDemo;

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
                    .flex_shrink_0()
                    .flex()
                    .items_center()
                    .px_3()
                    .bg(rgb(0x155b50))
                    .text_color(rgb(0xffffff))
                    .child(text!("A stable header in normal flow")),
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
                            .child(text!(
                                "This pane yields before its sibling when the row gets narrow."
                            )),
                    )
                    .child(
                        div()
                            .w(px(180.))
                            .flex_shrink_0()
                            .p_4()
                            .bg(rgb(0xffd8a8))
                            .text_color(rgb(0x202b29))
                            .child(text!("Fixed pane")),
                    ),
            )
    }
}

fn component(_window: &mut Window, cx: &mut gpui::App) -> gpui::Entity<LayoutDemo> {
    cx.new(|_cx| LayoutDemo)
}
