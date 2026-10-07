#![cfg(feature = "cpu")]

use gpui::{
    Bounds, ContentMask, DevicePixels, Hsla, PlatformHeadlessRenderer as _, Quad, ScaledPixels,
    Scene, Size, point, solid_background,
};
use gpui_ce_render::cpu::{CpuAtlas, CpuRenderer, render_scene_to_image};
use proptest::prelude::*;

fn rect(x: f32, y: f32, width: f32, height: f32) -> Bounds<ScaledPixels> {
    Bounds {
        origin: point(ScaledPixels(x), ScaledPixels(y)),
        size: Size {
            width: ScaledPixels(width),
            height: ScaledPixels(height),
        },
    }
}

fn solid(bounds: Bounds<ScaledPixels>, color: Hsla) -> Quad {
    Quad {
        bounds,
        content_mask: ContentMask {
            bounds,
            ..Default::default()
        },
        background: solid_background(color),
        ..Default::default()
    }
}

fn filled_triangle(
    points: [(f32, f32); 3],
    color: Hsla,
    clip: Bounds<ScaledPixels>,
) -> gpui::Path<ScaledPixels> {
    filled_triangle_with_background(points, solid_background(color), clip)
}

fn filled_triangle_with_background(
    points: [(f32, f32); 3],
    background: gpui::Background,
    clip: Bounds<ScaledPixels>,
) -> gpui::Path<ScaledPixels> {
    use gpui::{Path, px};

    let mut path = Path::new(point(px(points[0].0), px(points[0].1)));
    path.line_to(point(px(points[1].0), px(points[1].1)));
    path.line_to(point(px(points[2].0), px(points[2].1)));
    path.color = background;
    let mut path = path.scale(1.0);
    path.content_mask = ContentMask {
        bounds: clip,
        ..Default::default()
    };
    path
}

fn render(scene: &mut Scene, width: i32, height: i32) -> image::RgbaImage {
    scene.finish();
    render_scene_to_image(
        scene,
        Size {
            width: DevicePixels(width),
            height: DevicePixels(height),
        },
        &CpuAtlas::new(),
    )
    .expect("render generated solid-quad scene")
}

fn close(actual: u8, expected: f32) {
    let expected = (expected.clamp(0.0, 1.0) * 255.0 + 0.5) as i16;
    assert!(
        (i16::from(actual) - expected).abs() <= 1,
        "actual channel {actual} differs from expected {expected}"
    );
}

#[path = "cpu_properties/atlas.rs"]
mod atlas;
#[path = "cpu_properties/clipping.rs"]
mod clipping;
#[path = "cpu_properties/compositing.rs"]
mod compositing;
#[path = "cpu_properties/glyphs.rs"]
mod glyphs;
#[path = "cpu_properties/paths.rs"]
mod paths;
