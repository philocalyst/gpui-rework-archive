use gpui::{AppContext, Context, IntoElement, Render, Window, div, prelude::*, rgb};

struct Greeting;

impl Render for Greeting {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        div()
            .size_full()
            .flex()
            .items_center()
            .justify_center()
            .bg(rgb(0xf7f6f2))
            .text_color(rgb(0x155b50))
            .text_2xl()
            .child("Hello, GPUI")
    }
}

fn component(_window: &mut Window, cx: &mut gpui::App) -> gpui::Entity<Greeting> {
    cx.new(|_cx| Greeting)
}
