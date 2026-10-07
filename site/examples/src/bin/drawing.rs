#[path = "../support.rs"]
mod support;

// docs:step paint | Paint in the canvas bounds
// A canvas is an element with a request-layout callback and a paint callback.
// The second callback receives the rectangle GPUI assigned to the canvas. Keep
// drawing relative to that rectangle: a preview window, a resized native
// window, and a nested panel then all use the same code. `fill` creates a
// paint quad; `Window::paint_quad` records it for this frame.
//
// The coordinates below are logical pixels. `point` and `size` make the unit
// visible at the call site, while `bounds.origin` keeps the drawing anchored
// when the canvas moves. The colors are ordinary opaque sRGB values. Nothing
// here owns a GPU resource or a second coordinate system.
// docs:api gpui::canvas gpui::fill gpui::Window::paint_quad gpui::Bounds gpui::Pixels
// docs:code
use gpui::{
    AppContext, Bounds, Context, IntoElement, Render, Window, canvas, fill, point, prelude::*, px,
    rgb, size,
};

struct PaintDemo;
// docs:end

// docs:step bounds | Make geometry follow layout
// `canvas` does not guess a viewport for you. Its paint closure gets the final
// bounds after layout, so derive every rectangle from `bounds.origin` and
// `bounds.size`. Here the first square is inset by ten pixels and the second
// square is placed from the available width. If the canvas is narrower than
// the design, `max` keeps the second square from moving back over the first.
//
// `paint_quad` records draw order in callback order. That makes the blue square
// appear above the background if the rectangles overlap. The callback runs
// again when the window is invalidated or resized, so painting stays a pure
// description of the current frame.
// That separation also makes the example easy to lift into a larger view:
// layout decides the rectangle, and the paint closure decides its pixels.
// docs:api gpui::Render gpui::canvas gpui::Bounds gpui::Window::paint_quad
// docs:code
impl Render for PaintDemo {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        canvas(
            |_bounds, _window, _cx| {},
            |bounds: Bounds<gpui::Pixels>, _state, window, _cx| {
                window.paint_quad(fill(bounds, rgb(0xf4f1ea)));
                let left = bounds.origin + point(px(10.), px(10.));
                let right_x = (bounds.origin.x + bounds.size.width - px(70.))
                    .max(left.x + px(70.));
                window.paint_quad(fill(
                    Bounds::new(left, size(px(60.), px(40.))),
                    rgb(0xe05a47),
                ));
                window.paint_quad(fill(
                    Bounds::new(point(right_x, left.y), size(px(60.), px(40.))),
                    rgb(0x3478c8),
                ));
            },
        )
        .size_full()
    }
}
// docs:end

// docs:step launch | Put the view in a window
// `support::run` opens one window on the native or web platform and keeps the
// application alive. `cx.new` transfers ownership of `PaintDemo` to GPUI and
// returns the entity used as the window's root view. The canvas is therefore
// laid out like any other element, but its pixels are recorded directly during
// prepaint.
//
// Try resizing the window. The background and both squares remain inside the
// assigned canvas bounds; this is the useful boundary between layout and
// custom painting. For a longer path example, continue to the drawing guide.
// docs:api gpui::AppContext::new gpui::Application::run
// docs:code
pub fn main() {
    support::run(|_window, cx| cx.new(|_cx| PaintDemo));
}
// docs:end
