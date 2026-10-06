#![cfg_attr(target_family = "wasm", no_main)]

#[path = "../../shared/prelude.rs"]
mod example_prelude;
#[path = "../../example_support/fonts.rs"]
mod example_support;

use gpui::{App, AppContext as _, Context, Render, Window, div, img, prelude::*};
use gpui_platform::application;
use std::path::PathBuf;

struct GifViewer {
    gif_path: PathBuf,
}

impl GifViewer {
    fn new(gif_path: PathBuf) -> Self {
        Self { gif_path }
    }
}

impl Render for GifViewer {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        div().size_full().child(
            img(self.gif_path.clone())
                .size_full()
                .object_fit(gpui::ObjectFit::Contain)
                .id("gif"),
        )
    }
}

fn run_example() {
    application().run(|cx: &mut App| {
        if !example_support::load_fonts(cx) {
            return;
        }
        let gif_path = PathBuf::from(env!("CARGO_MANIFEST_DIR"))
            .join("examples/gallery/rendering/image/black-cat-typing.gif");

        let options = example_prelude::centered_window(640., 480., cx).focus(true);
        cx.open_window(options, |_, cx| cx.new(|_| GifViewer::new(gif_path)))
            .expect("open animated GIF viewer");
        example_prelude::init_example(cx, "GIF Viewer");
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
