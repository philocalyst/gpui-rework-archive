#[path = "../../shared/prelude.rs"]
mod example_prelude;

use gpui::{
    App, AppContext as _, Context, FontWeight, Render, Window, div, prelude::*, px, relative, rgb,
};

struct InlineLayoutExample;

fn inline_badge(label: &'static str, color: u32) -> impl IntoElement {
    div()
        .flex()
        .items_center()
        .gap_1()
        .px_2()
        .py_1()
        .rounded_md()
        .bg(rgb(color))
        .text_sm()
        .font_weight(FontWeight::SEMIBOLD)
        .text_color(rgb(0xffffff))
        .align_middle()
        .child(div().size_2().rounded_full().bg(rgb(0xffffff)))
        .child(label)
}

impl Render for InlineLayoutExample {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        div()
            .size_full()
            .flex()
            .justify_center()
            .items_center()
            .p_6()
            .bg(rgb(0x111827))
            .text_color(rgb(0xe5e7eb))
            .child(
                div()
                    .w_full()
                    .min_w_0()
                    .max_w(px(560.))
                    .flex()
                    .flex_col()
                    .gap_4()
                    .child(
                        div()
                            .text_2xl()
                            .font_weight(FontWeight::BOLD)
                            .child("Inline layout"),
                    )
                    .child(
                        div()
                            .inline()
                            .w_full()
                            .p_5()
                            .rounded_lg()
                            .border_1()
                            .border_color(rgb(0x374151))
                            .bg(rgb(0x1f2937))
                            .text_size(px(20.))
                            .line_height(relative(1.6))
                            .text_center()
                            .child("Parley keeps ")
                            .child(inline_badge("GPUI elements", 0x0f766e))
                            .child(" in the text flow, so they share lines and wrap with the surrounding words. A second ")
                            .child(inline_badge("inline box", 0x7c3aed))
                            .child(" continues naturally onto the next available line."),
                    )
                    .child(
                        div()
                            .text_sm()
                            .text_color(rgb(0x9ca3af))
                            .child("The badges use flex layout internally and act as atomic boxes in the paragraph."),
                    ),
            )
    }
}

fn main() {
    gpui_platform::application().run(|cx: &mut App| {
        let options = example_prelude::centered_window(720., 440., cx);
        cx.open_window(options, |_, cx| cx.new(|_| InlineLayoutExample))
            .expect("open inline layout window");
        example_prelude::init_example(cx, "Inline Layout");
    });
}
