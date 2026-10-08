use gpui::{AppContext, Context, IntoElement, Render, Window, div, prelude::*, px, rgb, text};

struct TextView;

impl Render for TextView {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        div()
            .size_full()
            .flex()
            .items_center()
            .justify_center()
            .bg(rgb(0xf7f6f2))
            .child(
                div()
                    .w(px(280.))
                    .flex_shrink_0()
                    .text_size(px(18.))
                    .line_height(px(28.))
                    .text_color(rgb(0x202b29))
                    .child(text!("Café — Straße — GPUI wraps shaped text here.")),
            )
    }
}

fn component(_window: &mut Window, cx: &mut gpui::App) -> gpui::Entity<TextView> {
    cx.new(|_cx| TextView)
}
