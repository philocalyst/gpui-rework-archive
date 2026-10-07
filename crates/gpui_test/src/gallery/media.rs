//! Self-contained SVG and raster inputs for the media examples and regression gallery.

use std::sync::{Arc, LazyLock};

use gpui::{
    Render, RenderImage, Transformation, Window, div, img, prelude::*, px, radians, rgb, svg,
};

const MARK: &[u8] = br##"<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64"><path fill="currentColor" d="M32 3 60 57H4z"/><circle cx="32" cy="39" r="8" fill="#fff"/></svg>"##;
static RASTER: LazyLock<Arc<RenderImage>> = LazyLock::new(|| {
    // Keep one image identity across frames so the image cache tests pixels, not churn.
    let image = image::RgbaImage::from_fn(64, 64, |x, y| {
        let dx = x as i32 - 32;
        let dy = y as i32 - 32;
        let ring = (dx * dx + dy * dy).abs() < 850 && (dx * dx + dy * dy) > 350;
        let cross =
            (x > 12 && x < 52 && (y > 28 && y < 36)) || (y > 12 && y < 52 && (x > 28 && x < 36));
        if ring || cross {
            image::Rgba([30, 41, 59, 255])
        } else {
            image::Rgba([226, 232, 240, 255])
        }
    });
    Arc::new(RenderImage::new(vec![image::Frame::new(image)]))
});

#[derive(Default)]
pub struct MediaScenario;

impl Render for MediaScenario {
    fn render(&mut self, _window: &mut Window, _cx: &mut gpui::Context<Self>) -> impl IntoElement {
        div()
            .id("media-scenario")
            .flex()
            .flex_col()
            .gap_3()
            .p_4()
            .size_full()
            .bg(rgb(0xf1f5f9))
            .child(
                div()
                    .text_lg()
                    .font_weight(gpui::FontWeight::BOLD)
                    .child("Bundled media"),
            )
            .child(
                div()
                    .flex()
                    .items_center()
                    .gap_4()
                    .child(
                        div()
                            .size(px(100.))
                            .overflow_hidden()
                            .rounded_full()
                            .bg(rgb(0xcbd5e1))
                            .child(
                                svg()
                                    .data(MARK)
                                    .size(px(100.))
                                    .text_color(rgb(0x334155))
                                    .with_transformation(Transformation::rotate(radians(0.12))),
                            ),
                    )
                    .child(
                        div()
                            .size(px(100.))
                            .overflow_hidden()
                            .rounded_xl()
                            .bg(rgb(0xffffff))
                            .child(img(RASTER.clone()).size(px(100.))),
                    ),
            )
            .child(
                div().text_sm().child(
                    "Inline monochrome SVG and procedural raster, clipped to rounded frames.",
                ),
            )
    }
}

/// Asset source for the standalone SVG example; the bytes are embedded in the package.
pub struct MediaAssets;

impl gpui::AssetSource for MediaAssets {
    fn load(&self, path: &str) -> anyhow::Result<Option<std::borrow::Cow<'static, [u8]>>> {
        Ok((path == "media/mark.svg").then(|| std::borrow::Cow::Borrowed(MARK)))
    }

    fn list(&self, path: &str) -> anyhow::Result<Vec<gpui::SharedString>> {
        Ok(if path.is_empty() || path == "media" {
            vec!["media/mark.svg".into()]
        } else {
            Vec::new()
        })
    }
}
