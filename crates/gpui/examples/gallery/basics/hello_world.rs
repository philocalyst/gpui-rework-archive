#![cfg_attr(target_family = "wasm", no_main)]

#[path = "../../shared/prelude.rs"]
mod example_prelude;

use gpui::{App, AppContext as _, Context, Entity, Render, Window, div, prelude::*, px, size};

/// A `Render` value describes the contents of one GPUI window.
struct HelloWorld;

impl Render for HelloWorld {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        div()
            .size_full()
            .flex()
            .items_center()
            .justify_center()
            .child("Hello, world!")
    }
}

// The app owns the view entity; the window asks it to render each frame.
fn hello_world(_window: &mut Window, cx: &mut App) -> Entity<HelloWorld> {
    cx.new(|_| HelloWorld)
}

#[cfg(not(target_family = "wasm"))]
fn main() {
    example_prelude::run_example("Hello World", size(px(320.), px(180.)), hello_world);
}

#[cfg(target_family = "wasm")]
#[wasm_bindgen::prelude::wasm_bindgen(start)]
pub fn start() {
    gpui_platform::web_init();
    example_prelude::run_example("Hello World", size(px(320.), px(180.)), hello_world);
}
