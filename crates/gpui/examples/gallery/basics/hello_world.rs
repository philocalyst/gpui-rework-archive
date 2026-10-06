#![cfg_attr(target_family = "wasm", no_main)]

#[path = "../../shared/prelude.rs"]
mod example_prelude;
#[path = "../../example_support/fonts.rs"]
mod example_support;

use gpui::{App, AppContext as _, Context, Hsla, SharedString, Window, div, prelude::*, px, rgb};
use gpui_platform::application;

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

fn run_example() {
    application().run(|cx: &mut App| {
        if !example_support::load_fonts(cx) {
            return;
        }
        let options = example_prelude::centered_window(500., 500., cx);
        cx.open_window(options, |_, cx| {
            cx.new(|_| HelloWorld {
                text: "World".into(),
            })
        })
        .expect("open hello world window");
        example_prelude::init_example(cx, "Hello World");
    });
}

#[cfg(not(target_family = "wasm"))]
fn main() {
    env_logger::init();
    run_example();
}

#[cfg(target_family = "wasm")]
#[wasm_bindgen::prelude::wasm_bindgen(start)]
pub fn start() {
    gpui_platform::web_init();
    run_example();
}
