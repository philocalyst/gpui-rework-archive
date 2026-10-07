#![cfg_attr(target_family = "wasm", no_main)]

#[path = "../shared/prelude.rs"]
mod example_prelude;

use std::sync::Arc;

use gpui::{
    App, Background, ColorSpace, Context, Path, PathBuilder, Pixels, Render, Window, canvas, div,
    linear_color_stop, linear_gradient, point, prelude::*, px, rgb, size,
};

const COLUMNS: usize = 16;
const ROWS: usize = 16;
const CELL_WIDTH: f32 = 58.;
const CELL_HEIGHT: f32 = 43.;

struct PaintingViewer {
    paths: Arc<Vec<(Path<Pixels>, Background)>>,
}

impl PaintingViewer {
    fn new(_cx: &mut Context<Self>) -> Self {
        let fills = [
            linear_gradient(
                135.,
                linear_color_stop(rgb(0xfacc15), 0.1),
                linear_color_stop(rgb(0xea580c), 1.),
            )
            .color_space(ColorSpace::Oklab),
            linear_gradient(
                40.,
                linear_color_stop(rgb(0x38bdf8), 0.),
                linear_color_stop(rgb(0x4f46e5), 1.),
            )
            .color_space(ColorSpace::Oklab),
            linear_gradient(
                110.,
                linear_color_stop(rgb(0x4ade80), 0.),
                linear_color_stop(rgb(0x047857), 1.),
            )
            .color_space(ColorSpace::Oklab),
        ];

        // Tessellate once; each frame measures painting 256 bounded, varied paths rather than
        // allocating thousands of identical stars during render.
        let mut paths = Vec::with_capacity(COLUMNS * ROWS);
        for row in 0..ROWS {
            for column in 0..COLUMNS {
                let x = 38. + column as f32 * CELL_WIDTH;
                let y = 22. + row as f32 * CELL_HEIGHT;
                let variant = (row * 3 + column) % 3;
                let path = match variant {
                    0 => concave_path(x, y),
                    1 => curved_path(x, y),
                    _ => open_stroke(x, y),
                };
                let fill = fills[variant].clone();
                paths.push((path.build().expect("valid benchmark path"), fill));
            }
        }

        Self {
            paths: Arc::new(paths),
        }
    }
}

fn concave_path(x: f32, y: f32) -> PathBuilder {
    let mut path = PathBuilder::fill();
    path.move_to(point(px(x + 28.), px(y + 2.)));
    path.line_to(point(px(x + 35.), px(y + 15.)));
    path.line_to(point(px(x + 55.), px(y + 17.)));
    path.line_to(point(px(x + 40.), px(y + 28.)));
    path.line_to(point(px(x + 45.), px(y + 40.)));
    path.line_to(point(px(x + 28.), px(y + 33.)));
    path.line_to(point(px(x + 12.), px(y + 40.)));
    path.line_to(point(px(x + 17.), px(y + 27.)));
    path.line_to(point(px(x + 2.), px(y + 17.)));
    path.line_to(point(px(x + 21.), px(y + 15.)));
    path.close();
    path
}

fn curved_path(x: f32, y: f32) -> PathBuilder {
    let mut path = PathBuilder::fill();
    path.move_to(point(px(x + 4.), px(y + 20.)));
    path.cubic_bezier_to(
        point(px(x + 28.), px(y + 1.)),
        point(px(x + 10.), px(y + 1.)),
        point(px(x + 13.), px(y + 2.)),
    );
    path.cubic_bezier_to(
        point(px(x + 54.), px(y + 20.)),
        point(px(x + 49.), px(y + 2.)),
        point(px(x + 54.), px(y + 9.)),
    );
    path.cubic_bezier_to(
        point(px(x + 4.), px(y + 20.)),
        point(px(x + 54.), px(y + 34.)),
        point(px(x + 10.), px(y + 39.)),
    );
    path.close();
    path
}

fn open_stroke(x: f32, y: f32) -> PathBuilder {
    let mut path = PathBuilder::stroke(px(2.5));
    path.move_to(point(px(x + 4.), px(y + 32.)));
    path.cubic_bezier_to(
        point(px(x + 54.), px(y + 10.)),
        point(px(x + 13.), px(y + 2.)),
        point(px(x + 46.), px(y + 42.)),
    );
    path
}

impl Render for PaintingViewer {
    fn render(&mut self, _window: &mut Window, _: &mut Context<Self>) -> impl IntoElement {
        let paths = Arc::clone(&self.paths);
        div().size_full().child(
            canvas(
                |_, _, _| {},
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

#[cfg(not(target_family = "wasm"))]
fn main() {
    example_prelude::run_example(
        "Path rendering stress",
        size(px(1024.), px(768.)),
        |_, cx: &mut App| cx.new(PaintingViewer::new),
    );
}

#[cfg(target_family = "wasm")]
#[wasm_bindgen::prelude::wasm_bindgen(start)]
pub fn start() {
    gpui_platform::web_init();
    example_prelude::run_example(
        "Path rendering stress",
        size(px(1024.), px(768.)),
        |_, cx: &mut App| cx.new(PaintingViewer::new),
    );
}
