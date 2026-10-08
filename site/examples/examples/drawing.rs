#[path = "../src/support.rs"]
mod support;

// ## Define a view with no drawing state {#paint}
// `PaintDemo` stores no fields: the drawing below depends only on the space
// layout gives it. Its [`Render`] implementation will create a fresh canvas
// for each render. A chart with changing data would keep that data on the
// view and notify it after an update; the canvas is where the picture is built.

use gpui::{
    AppContext, Bounds, ContentMask, Context, IntoElement, Render, Window, canvas, fill, point,
    prelude::*, px, rgb, size,
};

struct PaintDemo;

// ## Paint inside the assigned bounds {#bounds}
// [`canvas`] supplies layout-resolved [`Bounds`] to both callbacks. Prepaint
// has nothing to prepare here, so it returns `()`. Paint receives that value,
// makes three quads with [`fill`], and records them with
// [`Window::paint_quad`]. The renderer consumes those commands after paint.
//
// Coordinates are logical [`Pixels`], independent of display scale. Add an
// offset to `bounds.origin` to position each rectangle inside the canvas.
// Moving the canvas through layout then moves its drawing too.
//
// The first rectangle is inset by ten pixels. The second is positioned near
// the right edge, but cannot move left of the first. On a narrow canvas the
// spacing can put it partly outside the canvas bounds.
// [`Window::with_content_mask`] crops it to the canvas rectangle.
//
// > [!NOTE]
// > Layout bounds do not clip paint. A [`ContentMask`] intersects the current
// > mask for its closure, then the helper restores the previous mask. This
// > example has no input hitboxes. An interactive canvas needs the same clip
// > during prepaint; see the [clipped-control test](https://gpui-ce.github.io/book/testing.html#check-clipping-and-input-together).
//
// Paint order is draw order: background, red, then blue. Resize the viewport
// to see the next frame recompute bounds and record the same order; the mask
// clips the overflow instead of changing either rectangle's geometry.

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
// than making it narrower.
//
// To see the difference without the window edge hiding the overflow, replace
// the canvas's `.size_full()` with `.w(px(100.)).h(px(100.))`. The blue quad
// starts at x=80 and remains 60 pixels wide, but its mask shows only 20 pixels.
// Change `Some(mask)` to `None` in `with_content_mask`: the complete quad now
// extends beyond the canvas into the rest of the window. Restore both changes
// afterward. Continue to the [drawing guide](@/guides/drawing.md) for paths and curves.

fn component(_window: &mut Window, cx: &mut gpui::App) -> gpui::Entity<PaintDemo> {
    cx.new(|_cx| PaintDemo)
}

pub fn main() {
    support::run(component);
}
