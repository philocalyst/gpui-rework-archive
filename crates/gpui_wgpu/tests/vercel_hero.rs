//! The hero example, rendered headlessly with a simulated pointer. Set
//! `GPUI_HERO_PNG` to a path prefix to save the frames.
#![cfg(feature = "test-support")]

#[path = "../examples/vercel_hero/hero.rs"]
mod hero;

use std::{sync::Arc, time::Duration};

use gpui::{AnyWindowHandle, AppContext, HeadlessAppContext, point, px};
use gpui_ce_wgpu::{CosmicTextSystem, WgpuHeadlessRenderer};
use image::RgbaImage;

const WIDTH: f32 = 1280.0;
const HEIGHT: f32 = 800.0;

/// Move the pointer to (`x`, `y`) and keep drawing until the eased light
/// settles, then capture the frame.
fn settle_at(cx: &mut HeadlessAppContext, window: AnyWindowHandle, x: f32, y: f32) -> RgbaImage {
    for _ in 0..40 {
        cx.update_window(window, |_, window, cx| {
            window.simulate_mouse_move(point(px(x), px(y)), cx);
            window.draw(cx).clear(cx);
        })
        .unwrap();
        std::thread::sleep(Duration::from_millis(15));
    }
    cx.capture_screenshot(window).unwrap()
}

/// Mean brightness of a small patch centered `outset` logical pixels outside
/// the midpoint of the prism's left or right edge.
fn edge_brightness(image: &RgbaImage, right: bool) -> f32 {
    let scale = image.width() as f32 / WIDTH;
    let center = (WIDTH * 0.5, HEIGHT * 0.47);
    let radius = (HEIGHT * 0.17).clamp(60.0, 180.0);
    let side = if right { 1.0 } else { -1.0 };
    // The midpoint between the apex and a base corner, pushed out along the normal.
    let midpoint = (side * radius * 0.433, -radius * 0.25);
    let normal = (side * 0.866, -0.5);
    let outset = 6.0;
    let (x, y) = (
        center.0 + midpoint.0 + normal.0 * outset,
        center.1 + midpoint.1 + normal.1 * outset,
    );
    let mut total = 0.0;
    for dy in -2..=2 {
        for dx in -2..=2 {
            let pixel = image.get_pixel(
                ((x + dx as f32) * scale) as u32,
                ((y + dy as f32) * scale) as u32,
            );
            total += pixel.0[0] as f32;
        }
    }
    total / 25.0
}

#[test]
fn the_light_hides_away_from_the_pointer() {
    let mut cx = HeadlessAppContext::with_platform(
        Arc::new(CosmicTextSystem::new("sans-serif")),
        Arc::new(()),
        || {
            Some(Box::new(
                WgpuHeadlessRenderer::new().expect("a GPU adapter"),
            ))
        },
    );
    let window: AnyWindowHandle = cx
        .open_window(gpui::size(px(WIDTH), px(HEIGHT)), |_, cx| {
            cx.new(|_| hero::Hero)
        })
        .unwrap()
        .into();

    let lower_left = settle_at(&mut cx, window, WIDTH * 0.2, HEIGHT * 0.8);
    let lower_right = settle_at(&mut cx, window, WIDTH * 0.8, HEIGHT * 0.8);
    if let Ok(prefix) = std::env::var("GPUI_HERO_PNG") {
        lower_left.save(format!("{prefix}-left.png")).unwrap();
        lower_right.save(format!("{prefix}-right.png")).unwrap();
    }

    // Pointing from the lower left pushes the light up and to the right.
    let (left, right) = (
        edge_brightness(&lower_left, false),
        edge_brightness(&lower_left, true),
    );
    assert!(right > left * 1.3, "right edge {right} vs left edge {left}");
    let (left, right) = (
        edge_brightness(&lower_right, false),
        edge_brightness(&lower_right, true),
    );
    assert!(left > right * 1.3, "left edge {left} vs right edge {right}");
    // The prism's face stays black.
    let scale = lower_left.width() as f32 / WIDTH;
    let face = lower_left.get_pixel((WIDTH * 0.5 * scale) as u32, (HEIGHT * 0.5 * scale) as u32);
    assert!(face.0[0] < 8, "face {face:?}");
}
