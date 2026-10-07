#[path = "../src/support.rs"]
mod support;

// ## Use the rectangle layout assigned {#paint}
// A [`canvas`] has prepaint and paint callbacks, both with layout-resolved
// [`Bounds`]. This example needs no prepaint state. Its paint callback uses
// [`fill`] to create three quads and [`Window::paint_quad`] to record them.
//
// Coordinates are logical [`Pixels`]. Adding an offset to `bounds.origin`
// anchors each rectangle to the canvas, so moving the canvas moves its paint.

use gpui::{
    AppContext, Bounds, ContentMask, Context, IntoElement, Render, Window, canvas, fill, point,
    prelude::*, px, rgb, size,
};

struct PaintDemo;

// ## Clip the overflow {#bounds}
// The first rectangle is inset by ten pixels. The second follows the right
// edge until doing so would put it over the first. In a narrow canvas, that
// spacing pushes the second rectangle past the layout bounds.
// [`Window::with_content_mask`] crops it to the canvas rectangle.
//
// > [!NOTE]
// > Layout bounds do not clip paint. A [`ContentMask`] intersects the current
// > mask for its closure, then the helper restores the previous mask.
//
// Paint order is draw order: background, red, then blue. A new frame records
// those quads from its current bounds.

impl Render for PaintDemo {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        canvas(
            |_bounds, _window, _cx| {},
            |bounds: Bounds<gpui::Pixels>, _state, window, _cx| {
                let mask = ContentMask {
                    bounds,
                    fade_out: Default::default(),
                };
                window.with_content_mask(Some(mask), |window| {
                    window.paint_quad(fill(bounds, rgb(0xf4f1ea)));
                    let left = bounds.origin + point(px(10.), px(10.));
                    let right_x =
                        (bounds.origin.x + bounds.size.width - px(70.)).max(left.x + px(70.));
                    window.paint_quad(fill(
                        Bounds::new(left, size(px(60.), px(40.))),
                        rgb(0xe05a47),
                    ));
                    window.paint_quad(fill(
                        Bounds::new(point(right_x, left.y), size(px(60.), px(40.))),
                        rgb(0x3478c8),
                    ));
                });
            },
        )
        .size_full()
    }
}

// ## Compare clipping with resizing {#launch}
// The platform helper creates this view with [`AppContext::new`]. Resize the
// preview until the blue rectangle reaches the edge. The mask crops it rather
// than making it narrower. Remove the mask and run again to compare.
// Continue to the [drawing guide](@/guides/drawing.md) for paths and curves.

fn component(_window: &mut Window, cx: &mut gpui::App) -> gpui::Entity<PaintDemo> {
    cx.new(|_cx| PaintDemo)
}

pub fn main() {
    support::run(component);
}
