#![cfg_attr(target_family = "wasm", no_main)]

#[path = "../shared/prelude.rs"]
mod example_prelude;
#[path = "../example_support/fonts.rs"]
mod example_support;

use std::sync::Arc;

use gpui::{
    App, AppContext as _, Background, ColorSpace, Context, Path, PathBuilder, Pixels, Render,
    TitlebarOptions, Window, canvas, div, linear_color_stop, linear_gradient, point, prelude::*,
    px, rgb,
};
use gpui_platform::application;

const DEFAULT_WINDOW_WIDTH: Pixels = px(1024.0);
const DEFAULT_WINDOW_HEIGHT: Pixels = px(768.0);

struct PaintingViewer {
    paths: Arc<Vec<(Path<Pixels>, Background)>>,
}

impl PaintingViewer {
    fn new(_window: &mut Window, _cx: &mut Context<Self>) -> Self {
        // Repeating one path shape isolates the cost of issuing many path draws.
        let mut paths = Vec::with_capacity(2_000);
        for _ in 0..2_000 {
            let mut builder = PathBuilder::fill();
            builder.move_to(point(px(350.), px(100.)));
            builder.line_to(point(px(370.), px(160.)));
            builder.line_to(point(px(430.), px(160.)));
            builder.line_to(point(px(380.), px(200.)));
            builder.line_to(point(px(400.), px(260.)));
            builder.line_to(point(px(350.), px(220.)));
            builder.line_to(point(px(300.), px(260.)));
            builder.line_to(point(px(320.), px(200.)));
            builder.line_to(point(px(270.), px(160.)));
            builder.line_to(point(px(330.), px(160.)));
            builder.line_to(point(px(350.), px(100.)));
            let path = builder.build().unwrap();
            paths.push((
                path,
                linear_gradient(
                    180.,
                    linear_color_stop(rgb(0xFACC15), 0.7),
                    linear_color_stop(rgb(0xD56D0C), 1.),
                )
                .color_space(ColorSpace::Oklab),
            ));
        }

        Self {
            paths: Arc::new(paths),
        }
    }
}

impl Render for PaintingViewer {
    fn render(&mut self, window: &mut Window, _: &mut Context<Self>) -> impl IntoElement {
        // Keep the frame stream active so the same workload can be profiled continuously.
        window.request_animation_frame();
        let paths = Arc::clone(&self.paths);
        div().size_full().child(
            canvas(
                move |_, _, _| {},
                move |_, _, window, _| {
                    for (path, color) in paths.iter() {
                        window.paint_path(path.clone(), color.clone());
                    }
                },
            )
            .size_full(),
        )
    }
}

fn run_example() {
    application().run(|cx: &mut App| {
        if !example_support::load_fonts(cx) {
            return;
        }
        let options = example_prelude::centered_window(
            DEFAULT_WINDOW_WIDTH.as_f32(),
            DEFAULT_WINDOW_HEIGHT.as_f32(),
            cx,
        )
        .titlebar(Some(TitlebarOptions {
            title: Some("Path Rendering Stress".into()),
            ..Default::default()
        }))
        .focus(true);
        cx.open_window(options, |window, cx| {
            cx.new(|cx| PaintingViewer::new(window, cx))
        })
        .expect("open path rendering stress");
        example_prelude::init_example(cx, "Path Rendering Stress");
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
