use gpui::{
    AppContext, Bounds, ContentMask, Context, IntoElement, Render, Window, canvas, fill, point,
    prelude::*, px, rgb, size,
};

struct PaintDemo;

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

fn component(_window: &mut Window, cx: &mut gpui::App) -> gpui::Entity<PaintDemo> {
    cx.new(|_cx| PaintDemo)
}
