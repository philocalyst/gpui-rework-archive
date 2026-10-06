//! The shader gallery example, rendered headlessly so it keeps compiling and
//! drawing. Set `GPUI_SHADER_GALLERY_PNG` to a path to save the frame.
#![cfg(feature = "test-support")]

#[path = "../examples/shader_gallery/gallery.rs"]
#[allow(dead_code)]
mod gallery;

use std::sync::Arc;

use gpui::{AppContext, HeadlessAppContext, px};
use gpui_ce_wgpu::{CosmicTextSystem, WgpuHeadlessRenderer};

#[test]
fn every_gallery_paint_compiles() {
    for (name, paint) in gallery::paints(1.5) {
        if let Err(error) = paint.compile() {
            panic!("{name}: {error}");
        }
    }
}

#[test]
fn the_gallery_renders() {
    let mut cx = HeadlessAppContext::with_platform(
        Arc::new(CosmicTextSystem::new("sans-serif")),
        Arc::new(()),
        || {
            Some(Box::new(
                WgpuHeadlessRenderer::new().expect("a GPU adapter"),
            ))
        },
    );
    let window = cx
        .open_window(gpui::size(px(912.0), px(824.0)), |_, cx| {
            cx.new(|_| gallery::Gallery::frozen(1.5))
        })
        .unwrap();
    cx.update_window(window.into(), |_, window, cx| {
        window.draw(cx).clear(cx);
        assert!(window.supports_shader_paint());
    })
    .unwrap();
    let image = cx.capture_screenshot(window.into()).unwrap();
    if let Ok(path) = std::env::var("GPUI_SHADER_GALLERY_PNG") {
        image.save(path).unwrap();
    }

    // Sample the middle of each card in the first two rows: all are shader
    // paints, and none should be left transparent over the dark page.
    let scale = image.width() as f32 / 912.0;
    let page = image.get_pixel(4, 4).0;
    for (row, column) in (0..2).flat_map(|row| (0..4).map(move |column| (row, column))) {
        let x = 24.0 + column as f32 * 216.0 + 100.0;
        let y = 24.0 + 52.0 + row as f32 * 242.0 + 100.0;
        let pixel = image.get_pixel((x * scale) as u32, (y * scale) as u32).0;
        assert_ne!(pixel, page, "card ({row}, {column}) painted nothing");
    }
}
