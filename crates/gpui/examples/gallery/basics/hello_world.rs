#![cfg_attr(target_family = "wasm", no_main)]

#[path = "../../shared/prelude.rs"]
mod example_prelude;

use gpui::{
    App, AppContext as _, Context, Hsla, SharedString, Window, div, prelude::*, px, rgb, size,
};
use std::time::Duration;

struct HelloWorld {
    text: SharedString,
}

fn swatch(color: Hsla, outline: Hsla) -> impl IntoElement {
    div()
        .size_8()
        .bg(color)
        .border_1()
        .border_dashed()
        .rounded_md()
        .border_color(outline)
}

impl Render for HelloWorld {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        div()
            .flex()
            .flex_col()
            .gap_3()
            .bg(rgb(0x505050))
            .size(px(500.0))
            .justify_center()
            .items_center()
            .shadow_lg()
            .border_1()
            .border_color(rgb(0x0000ff))
            .text_xl()
            .text_color(rgb(0xffffff))
            .child(format!("Hello, {}!", self.text))
            .child(div().flex().gap_2().children([
                swatch(gpui::red(), gpui::white()),
                swatch(gpui::green(), gpui::white()),
                swatch(gpui::blue(), gpui::white()),
                swatch(gpui::yellow(), gpui::white()),
                swatch(gpui::black(), gpui::white()),
                swatch(gpui::white(), gpui::black()),
            ]))
    }
}

fn hello_scenario() -> anyhow::Result<gpui_test::Scenario<HelloWorld>> {
    gpui_test::Scenario::new(
        "hello-world",
        "Hello World",
        size(px(500.), px(500.)),
        |_, cx: &mut App| {
            cx.new(|_| HelloWorld {
                text: "World".into(),
            })
        },
    )?
    .checkpoint("default", "First window", Duration::ZERO)
}

#[cfg(not(target_family = "wasm"))]
fn main() {
    example_prelude::run_example(hello_scenario().expect("valid hello scenario"))
        .expect("run hello world example");
}

#[cfg(target_family = "wasm")]
#[wasm_bindgen::prelude::wasm_bindgen(start)]
pub fn start() {
    gpui_platform::web_init();
    example_prelude::run_example(hello_scenario().expect("valid hello scenario"))
        .expect("run hello world example");
}
