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

proptest! {
    #![proptest_config(ProptestConfig { cases: 48, .. ProptestConfig::default() })]

    #[test]
    fn overlapping_translucent_quads_obey_source_over_for_generated_alpha_pairs(
        below_byte in 1u8..=255,
        above_byte in 1u8..=255,
    ) {
        let below_alpha = f32::from(below_byte) / 255.0;
        let above_alpha = f32::from(above_byte) / 255.0;
        let bounds = rect(0.0, 0.0, 2.0, 2.0);
        let below = Hsla::new(240.0, 1.0, 0.5, below_alpha);
        let above = Hsla::new(0.0, 1.0, 0.5, above_alpha);
        let mut scene = Scene::default();
        scene.insert_primitive(solid(bounds, below));
        scene.insert_primitive(solid(bounds, above));
        let image = render(&mut scene, 2, 2);
        let pixel = image.get_pixel(0, 0).0;

        let expected_alpha = above_alpha + below_alpha * (1.0 - above_alpha);
        // Pure blue is the lower layer and pure red is the upper layer. The output image is
        // unpremultiplied, so calculate the visible channel values from premultiplied source-over.
        close(pixel[0], above_alpha / expected_alpha);
        close(pixel[1], 0.0);
        close(pixel[2], below_alpha * (1.0 - above_alpha) / expected_alpha);
        close(pixel[3], expected_alpha);
    }

    /// Rectangles use quarter-pixel coordinates to exercise both negative clipping and partial
    /// edge coverage. For a hard edge, expected coverage is determined by pixel-center inclusion.
    #[test]
    fn generated_opaque_rectangles_have_local_pixel_effects(
        x_quarters in -4i16..32,
        y_quarters in -4i16..32,
        width_quarters in 1u8..=25,
        height_quarters in 1u8..=25,
    ) {
        let (x, y, width, height) = (
            f32::from(x_quarters) / 4.0,
            f32::from(y_quarters) / 4.0,
            f32::from(width_quarters) / 4.0,
            f32::from(height_quarters) / 4.0,
        );
        let bounds = rect(x, y, width, height);
        let mut scene = Scene::default();
        scene.insert_primitive(solid(bounds, Hsla::new(0.0, 1.0, 0.5, 1.0)));
        let image = render(&mut scene, 8, 8);
        for py in 0..8 {
            for px in 0..8 {
                let center_x = px as f32 + 0.5;
                let center_y = py as f32 + 0.5;
                let covered = center_x >= x
                    && center_x < x + width
                    && center_y >= y
                    && center_y < y + height;
                let actual = image.get_pixel(px, py).0;
                let expected = if covered { [255, 0, 0, 255] } else { [0, 0, 0, 0] };
                prop_assert_eq!(
                    actual, expected,
                    "rectangle ({}, {}, {}, {}) affected pixel ({}, {}) unexpectedly", x, y, width, height, px, py
                );
            }
        }
    }
}

proptest! {
    #![proptest_config(ProptestConfig { cases: 24, .. ProptestConfig::default() })]

    #[test]
    fn retained_cpu_frame_matches_fresh_renderer_after_generated_removals_and_resizes(
        generated in prop::collection::vec(
            (2u8..=9, 2u8..=9, 0u8..=2, any::<u8>(), any::<u8>(), any::<u8>(), any::<u8>()),
            0..=8,
        ),
    ) {
        // The prefix guarantees that every generated sequence exercises clear-after-removal,
        // same-area axis resize, translucent replay, and reuse after a resize.
        let mut steps = vec![
            (8, 6, 1, 0, 0, 255, 0),
            (8, 6, 0, 0, 0, 0, 0),
            (6, 8, 2, 1, 2, 128, 170),
            (6, 8, 0, 0, 0, 0, 0),
            (8, 6, 1, 0, 0, 255, 85),
        ];
        steps.extend(generated);

        let mut reused = CpuRenderer::new();
        for (step_index, (width, height, mode, x_seed, y_seed, alpha, hue))
            in steps.into_iter().enumerate()
        {
            let mut scene = Scene::default();
            if mode > 0 {
                let x = (x_seed % width) as f32;
                let y = (y_seed % height) as f32;
                let bounds = rect(x, y, width as f32 - x, height as f32 - y);
                let hue_degrees = f32::from(hue) * (360.0 / 256.0);
                let alpha = f32::from(alpha) / 255.0;
                scene.insert_primitive(solid(
                    bounds,
                    Hsla::new(hue_degrees, 1.0, 0.5, alpha),
                ));
                if mode == 2 {
                    let overlap = rect(x, y, bounds.size.width.0.min(3.0), bounds.size.height.0.min(3.0));
                    scene.insert_primitive(solid(
                        overlap,
                        Hsla::new((hue_degrees + 120.0) % 360.0, 1.0, 0.5, 0.5),
                    ));
                }
            }
            scene.finish();
            let target = Size {
                width: DevicePixels(i32::from(width)),
                height: DevicePixels(i32::from(height)),
            };
            let reused_image = reused
                .render_scene_to_image(&scene, target)
                .expect("reused renderer should replay each generated scene");
            let mut fresh = CpuRenderer::new();
            let fresh_image = fresh
                .render_scene_to_image(&scene, target)
                .expect("fresh renderer should replay each generated scene");
            prop_assert_eq!(
                reused_image.as_raw(),
                fresh_image.as_raw(),
                "retained frame differs at step {}, size {}x{}, mode {}",
                step_index,
                width,
                height,
                mode,
            );
        }
    }
}

proptest! {
    #![proptest_config(ProptestConfig { cases: 64, .. ProptestConfig::default() })]

    #[test]
    fn shader_source_over_matches_independent_straight_alpha_reference(
        below in (0.0f32..=1.0, 0.0f32..=1.0, 0.0f32..=1.0, -0.25f32..=1.25),
        above in (0.0f32..=1.0, 0.0f32..=1.0, 0.0f32..=1.0, -0.25f32..=1.25),
    ) {
        let below = [below.0, below.1, below.2, below.3];
        let above = [above.0, above.1, above.2, above.3];
        let below_a = below[3].clamp(0.0, 1.0);
        let above_a = above[3].clamp(0.0, 1.0);
        let out_a = above_a + below_a * (1.0 - above_a);
        let reference = if out_a == 0.0 {
            [0.0; 4]
        } else {
            std::array::from_fn(|i| {
                if i == 3 { out_a } else {
                    (above[i] * above_a + below[i] * below_a * (1.0 - above_a)) / out_a
                }
            })
        };
        let actual = gpui_ce_render::shaders::common::over(
            wgsl_rs::std::vec4f(below[0], below[1], below[2], below[3]),
            wgsl_rs::std::vec4f(above[0], above[1], above[2], above[3]),
        );
        for (channel, expected) in [actual.x, actual.y, actual.z, actual.w].into_iter().zip(reference) {
            prop_assert!((channel - expected).abs() <= 1e-6,
                "source-over channel {channel} differs from scalar reference {expected}");
        }

        // Dither can exceed alpha one. The GPU blend factors saturate it, preserving opaque black.
        let edge = gpui_ce_render::shaders::common::over(
            wgsl_rs::std::vec4f(0.0, 0.0, 0.0, 1.0),
            wgsl_rs::std::vec4f(1.0, 0.0, 0.0, 1.25),
        );
        prop_assert!((edge.x - 1.0).abs() <= 1e-6 && edge.y == 0.0 && edge.z == 0.0 && edge.w == 1.0,
            "alpha above one over opaque black should be clamped to an opaque red result: {edge:?}");
    }
}

#[test]
fn semi_transparent_shadow_uses_its_alpha_once() {
    use gpui::{ShaderBool, Shadow};

    let bounds = rect(0.0, 0.0, 1.0, 1.0);
    let mut scene = Scene::default();
    let shadow_color: Hsla = Hsla::new(0.0, 1.0, 0.5, 0.5);
    scene.insert_primitive(Shadow {
        order: 0,
        blur_radius: ScaledPixels(0.0),
        bounds,
        corner_radii: Default::default(),
        content_mask: ContentMask {
            bounds,
            ..Default::default()
        },
        color: solid_background(shadow_color),
        element_bounds: bounds,
        element_corner_radii: Default::default(),
        inset: ShaderBool::Disabled,
        corner_smoothing: 0.0,
    });
    let image = render(&mut scene, 1, 1);
    assert_eq!(image.get_pixel(0, 0).0, [255, 0, 0, 128]);
}

#[test]
fn path_coverage_composites_with_quad_alpha_and_respects_its_clip() {
    use gpui::Primitive;

    let viewport = rect(0.0, 0.0, 5.0, 5.0);
    let mut scene = Scene::default();
    scene.insert_primitive(solid(viewport, Hsla::new(240.0, 1.0, 0.5, 0.5)));
    scene.insert_primitive(Primitive::Path(filled_triangle(
        [(0.0, 0.0), (5.0, 0.0), (0.0, 5.0)],
        Hsla::new(0.0, 1.0, 0.5, 0.5),
        rect(0.0, 0.0, 3.0, 5.0),
    )));

    let image = render(&mut scene, 5, 5);
    assert_eq!(
        image.get_pixel(1, 1).0,
        [170, 0, 85, 191],
        "half-alpha red path over half-alpha blue quad must use source-over once"
    );
    assert_eq!(
        image.get_pixel(3, 0).0,
        [0, 0, 255, 128],
        "path coverage outside its content clip must leave the lower quad unchanged"
    );
}

#[test]
fn clipped_path_gradient_uses_the_clipped_paint_bounds() {
    use gpui::{ColorSpace, linear_color_stop, linear_gradient};

    let black: Hsla = Hsla::new(0.0, 0.0, 0.0, 1.0);
    let white: Hsla = Hsla::new(0.0, 0.0, 1.0, 1.0);
    let gradient = linear_gradient(
        90.0,
        linear_color_stop(black, 0.0),
        linear_color_stop(white, 1.0),
    )
    .color_space(ColorSpace::Srgb);
    let mut scene = Scene::default();
    scene.insert_primitive(gpui::Primitive::Path(filled_triangle_with_background(
        [(0.0, 0.0), (5.0, 0.0), (0.0, 5.0)],
        gradient,
        rect(0.0, 0.0, 3.0, 5.0),
    )));

    let image = render(&mut scene, 5, 5);
    let pixel = image.get_pixel(1, 1).0;
    for channel in &pixel[..3] {
        assert!(
            (i16::from(*channel) - 55).abs() <= 3,
            "clipped 0-to-1 sRGB gradient at its midpoint should be near linear-light 55, got {pixel:?}"
        );
    }
    assert!(
        pixel[3] >= 250,
        "interior path coverage stays opaque: {pixel:?}"
    );
}

#[test]
fn path_composite_sprite_bounds_match_the_content_clip() {
    let clip = rect(0.25, 0.5, 2.0, 3.0);
    let path = filled_triangle(
        [(0.0, 0.0), (5.0, 0.0), (0.0, 5.0)],
        Hsla::new(0.0, 1.0, 0.5, 1.0),
        clip,
    );
    let sprite = gpui_ce_render::path_types::sprites(std::slice::from_ref(&path))
        .next()
        .expect("one path yields one composite sprite");

    assert_eq!(sprite.bounds.origin.x.0, clip.origin.x.0);
    assert_eq!(sprite.bounds.origin.y.0, clip.origin.y.0);
    assert_eq!(sprite.bounds.size.width.0, clip.size.width.0);
    assert_eq!(sprite.bounds.size.height.0, clip.size.height.0);
}

#[test]
fn adjacent_path_triangles_assign_shared_edge_pixels_once() {
    use gpui::Primitive;

    let clip = rect(0.0, 0.0, 4.0, 4.0);
    let red = Hsla::new(0.0, 1.0, 0.5, 0.5);
    let mut scene = Scene::default();
    scene.insert_primitive(Primitive::Path(filled_triangle(
        [(0.0, 0.0), (4.0, 0.0), (0.0, 4.0)],
        red,
        clip,
    )));
    scene.insert_primitive(Primitive::Path(filled_triangle(
        [(4.0, 0.0), (4.0, 4.0), (0.0, 4.0)],
        red,
        clip,
    )));

    let image = render(&mut scene, 4, 4);
    assert_eq!(
        image.get_pixel(1, 2).0,
        [255, 0, 0, 128],
        "the shared diagonal's pixel center must belong to exactly one triangle"
    );
}

#[test]
fn smoothed_shadow_uses_smoothed_corner_coverage() {
    use gpui::{Corners, ShaderBool, Shadow};

    fn render_shadow(corner_smoothing: f32) -> image::RgbaImage {
        let bounds = rect(0.0, 0.0, 8.0, 8.0);
        let mut scene = Scene::default();
        let color: Hsla = Hsla::new(0.0, 1.0, 0.5, 1.0);
        scene.insert_primitive(Shadow {
            order: 0,
            blur_radius: ScaledPixels(0.0),
            bounds,
            corner_radii: Corners::all(ScaledPixels(4.0)),
            content_mask: ContentMask {
                bounds,
                ..Default::default()
            },
            color: solid_background(color),
            element_bounds: bounds,
            element_corner_radii: Corners::all(ScaledPixels(4.0)),
            inset: ShaderBool::Disabled,
            corner_smoothing,
        });
        render(&mut scene, 8, 8)
    }

    let rounded = render_shadow(0.0);
    let smoothed = render_shadow(1.0);
    assert_eq!(
        rounded.get_pixel(0, 0).0[3],
        0,
        "rounded corner stays outside"
    );
    assert!(
        smoothed.get_pixel(2, 0).0[3] > rounded.get_pixel(2, 0).0[3],
        "nonzero corner smoothing must increase coverage at the upper-left curved edge"
    );
}

#[test]
fn scene_capture_erases_source_atlas_allocation_history() {
    use gpui::{
        AtlasTextureId, AtlasTextureKind, AtlasTile, CapturedBitmap, PolychromeSprite,
        SceneCapture, ShaderBool, TileId,
    };

    fn capture(texture_index: u32, tile_id: u32, tile_origin: (i32, i32)) -> SceneCapture {
        let bounds = rect(1.0, 1.0, 2.0, 2.0);
        let tile = AtlasTile {
            texture_id: AtlasTextureId {
                index: texture_index,
                kind: AtlasTextureKind::Polychrome,
            },
            tile_id: TileId(tile_id),
            padding: 1,
            bounds: Bounds {
                origin: point(DevicePixels(tile_origin.0), DevicePixels(tile_origin.1)),
                size: Size {
                    width: DevicePixels(2),
                    height: DevicePixels(2),
                },
            },
        };
        let mut scene = Scene::default();
        scene.insert_primitive(PolychromeSprite {
            order: 0,
            grayscale: ShaderBool::Disabled,
            opacity: 1.0,
            corner_smoothing: 0.0,
            bounds,
            content_mask: ContentMask {
                bounds,
                ..Default::default()
            },
            corner_radii: Default::default(),
            tile,
        });
        scene.finish();

        SceneCapture::capture(&scene, |resolved| {
            assert_eq!(resolved, tile);
            Ok(CapturedBitmap {
                kind: AtlasTextureKind::Polychrome,
                width: 2,
                height: 2,
                // A two-by-two opaque image with four distinct colors, stored as BGRA.
                bytes: vec![
                    0, 0, 255, 255, 0, 255, 0, 255, 255, 0, 0, 255, 255, 255, 255, 255,
                ],
            })
        })
        .expect("canonicalize scene atlas tile")
    }

    let capture_a = capture(2, 7, (0, 0));
    let capture_b = capture(91, 420, (8, 10));
    assert_eq!(
        serde_json::to_value(&capture_a).unwrap(),
        serde_json::to_value(&capture_b).unwrap(),
        "equivalent tile pixels must serialize identically across atlas allocation histories"
    );
    assert_eq!(
        capture_a.bitmaps().len(),
        1,
        "one referenced tile is stored once"
    );

    let scene_a = capture_a.to_scene().expect("restore first capture");
    let scene_b = capture_b.to_scene().expect("restore second capture");
    let mut atlas_a =
        gpui_ce_render::cpu::CpuRenderer::from_captured_bitmaps(capture_a.bitmaps()).unwrap();
    let mut atlas_b =
        gpui_ce_render::cpu::CpuRenderer::from_captured_bitmaps(capture_b.bitmaps()).unwrap();
    let size = Size {
        width: DevicePixels(4),
        height: DevicePixels(4),
    };
    let pixels_a = atlas_a.render_scene_to_image(&scene_a, size).unwrap();
    let pixels_b = atlas_b.render_scene_to_image(&scene_b, size).unwrap();
    assert_eq!(
        pixels_a, pixels_b,
        "restored pixels must not depend on source atlas IDs"
    );
    assert_eq!(pixels_a.get_pixel(1, 1).0, [255, 0, 0, 255]);
    assert_eq!(pixels_a.get_pixel(2, 1).0, [0, 255, 0, 255]);
    assert_eq!(pixels_a.get_pixel(1, 2).0, [0, 0, 255, 255]);
    assert_eq!(pixels_a.get_pixel(2, 2).0, [255, 255, 255, 255]);
}

#[test]
fn quad_content_mask_clips_inside_its_primitive_bounds() {
    let bounds = rect(0.0, 0.0, 4.0, 4.0);
    let mut quad = solid(bounds, Hsla::new(0.0, 1.0, 0.5, 1.0));
    quad.content_mask.bounds = rect(1.0, 1.0, 2.0, 2.0);
    let mut scene = Scene::default();
    scene.insert_primitive(quad);
    let image = render(&mut scene, 4, 4);
    for y in 0..4 {
        for x in 0..4 {
            let expected = if (1..3).contains(&x) && (1..3).contains(&y) {
                [255, 0, 0, 255]
            } else {
                [0, 0, 0, 0]
            };
            assert_eq!(
                image.get_pixel(x, y).0,
                expected,
                "clip mismatch at ({x}, {y})"
            );
        }
    }
}

#[test]
fn fractional_geometry_uses_the_content_mask_fade_at_pixel_centers() {
    use gpui::Edges;

    let bounds = rect(0.2, 0.0, 1.0, 1.0);
    let red: Hsla = Hsla::new(0.0, 1.0, 0.5, 1.0);
    let mut scene = Scene::default();
    scene.insert_primitive(Quad {
        bounds,
        content_mask: ContentMask {
            // This mask is deliberately broader than the primitive. At the first pixel
            // center (x = 0.5), the one-pixel fade has exactly half coverage.
            bounds: rect(0.25, 0.0, 3.0, 1.0),
            fade_out: Edges {
                left: ScaledPixels(0.5),
                ..Default::default()
            },
        },
        background: solid_background(red),
        ..Default::default()
    });

    let image = render(&mut scene, 4, 1);
    assert_eq!(image.get_pixel(0, 0).0, [255, 0, 0, 128]);
    assert_eq!(image.get_pixel(1, 0).0, [0, 0, 0, 0]);
    assert_eq!(image.get_pixel(3, 0).0, [0, 0, 0, 0]);
}

#[test]
fn font_gamma_correction_preserves_neutral_and_corrects_half_coverage() {
    use gpui::{
        AtlasTextureId, AtlasTextureKind, AtlasTile, CapturedBitmap, MonochromeSprite, TileId,
    };
    use gpui_ce_render::{
        cpu::CpuRenderer,
        font::{FontRasterizationSettings, SubpixelOrder},
    };

    let tile = AtlasTile {
        texture_id: AtlasTextureId {
            index: 0,
            kind: AtlasTextureKind::Monochrome,
        },
        tile_id: TileId(0),
        padding: 0,
        bounds: Bounds {
            origin: point(DevicePixels(0), DevicePixels(0)),
            size: Size {
                width: DevicePixels(1),
                height: DevicePixels(1),
            },
        },
    };
    let bitmap = CapturedBitmap {
        kind: AtlasTextureKind::Monochrome,
        width: 1,
        height: 1,
        bytes: vec![128],
    };
    let mut scene = Scene::default();
    scene.insert_primitive(MonochromeSprite {
        order: 0,
        padding: 0,
        bounds: rect(0.0, 0.0, 1.0, 1.0),
        content_mask: ContentMask {
            bounds: rect(0.0, 0.0, 1.0, 1.0),
            ..Default::default()
        },
        color: Hsla::new(0.0, 0.0, 1.0, 1.0).into(),
        tile,
        transformation: Default::default(),
    });
    scene.finish();
    let size = Size {
        width: DevicePixels(1),
        height: DevicePixels(1),
    };
    let bitmaps = [bitmap];
    let neutral = FontRasterizationSettings::new(1.0, 0.0, 0.0, SubpixelOrder::RedGreenBlue);
    let mut renderer = CpuRenderer::from_captured_bitmaps(&bitmaps)
        .unwrap()
        .with_font_rasterization(neutral);
    assert_eq!(
        renderer
            .render_scene_to_image(&scene, size)
            .unwrap()
            .get_pixel(0, 0)
            .0,
        [255, 255, 255, 128],
        "neutral settings retain the captured 128/255 glyph coverage"
    );

    let corrected = FontRasterizationSettings::new(2.2, 0.0, 0.0, SubpixelOrder::RedGreenBlue);
    let mut renderer = CpuRenderer::from_captured_bitmaps(&bitmaps)
        .unwrap()
        .with_font_rasterization(corrected);
    let actual = renderer
        .render_scene_to_image(&scene, size)
        .unwrap()
        .get_pixel(0, 0)
        .0[3];
    assert!(
        (i16::from(actual) - 196).abs() <= 1,
        "gamma 2.2 should map half coverage to about 0.769 alpha (196/255), got {actual}"
    );
}

#[test]
fn subpixel_order_reverses_red_and_blue_coverage_channels() {
    use gpui::{
        AtlasTextureId, AtlasTextureKind, AtlasTile, CapturedBitmap, SubpixelSprite, TileId,
    };
    use gpui_ce_render::{
        cpu::CpuRenderer,
        font::{FontRasterizationSettings, SubpixelOrder},
    };

    let tile = AtlasTile {
        texture_id: AtlasTextureId {
            index: 0,
            kind: AtlasTextureKind::Subpixel,
        },
        tile_id: TileId(0),
        padding: 0,
        bounds: Bounds {
            origin: point(DevicePixels(0), DevicePixels(0)),
            size: Size {
                width: DevicePixels(1),
                height: DevicePixels(1),
            },
        },
    };
    let bitmap = CapturedBitmap {
        kind: AtlasTextureKind::Subpixel,
        width: 1,
        height: 1,
        // Captured subpixel tiles retain the native BGRA mask lane order, so this byte
        // sequence represents full red coverage and no blue coverage.
        bytes: vec![0, 0, 255, 255],
    };
    let mut scene = Scene::default();
    scene.insert_primitive(SubpixelSprite {
        order: 0,
        padding: 0,
        bounds: rect(0.0, 0.0, 1.0, 1.0),
        content_mask: ContentMask {
            bounds: rect(0.0, 0.0, 1.0, 1.0),
            ..Default::default()
        },
        color: Hsla::new(0.0, 0.0, 1.0, 1.0).into(),
        tile,
        transformation: Default::default(),
    });
    scene.finish();
    let bitmaps = [bitmap];
    let size = Size {
        width: DevicePixels(1),
        height: DevicePixels(1),
    };
    let render = |order| {
        let settings = FontRasterizationSettings::new(1.0, 0.0, 0.0, order);
        let mut renderer = CpuRenderer::from_captured_bitmaps(&bitmaps)
            .unwrap()
            .with_font_rasterization(settings);
        renderer
            .render_scene_to_image(&scene, size)
            .unwrap()
            .get_pixel(0, 0)
            .0
    };

    assert_eq!(
        render(SubpixelOrder::RedGreenBlue),
        [255, 0, 0, 255],
        "RGB panel order maps the first coverage lane to red"
    );
    assert_eq!(
        render(SubpixelOrder::BlueGreenRed),
        [0, 0, 255, 255],
        "BGR panel order reverses red and blue coverage lanes"
    );
}

#[test]
fn inline_blur_chain_uses_the_largest_declared_radius_once() {
    use gpui::{FilterBoundary, Primitive, ScaledFilter};

    fn render_with(filters: Vec<ScaledFilter>) -> image::RgbaImage {
        let bounds = rect(0.0, 0.0, 24.0, 24.0);
        let boundary = |is_start| {
            Primitive::FilterBoundary(FilterBoundary {
                order: 0,
                bounds,
                content_mask: ContentMask {
                    bounds,
                    ..Default::default()
                },
                corner_radii: Default::default(),
                corner_smoothing: 0.0,
                filters: filters.clone().into(),
                opacity: 1.0,
                is_start,
            })
        };

        let mut scene = Scene::default();
        scene.insert_primitive(boundary(true));
        scene.insert_primitive(solid(
            rect(11.0, 11.0, 2.0, 2.0),
            Hsla::new(0.0, 1.0, 0.5, 1.0),
        ));
        scene.insert_primitive(boundary(false));
        render(&mut scene, 24, 24)
    }

    let chain = render_with(vec![
        ScaledFilter::Blur(ScaledPixels(2.0)),
        ScaledFilter::Blur(ScaledPixels(4.0)),
    ]);
    let largest_only = render_with(vec![ScaledFilter::Blur(ScaledPixels(4.0))]);
    assert_eq!(
        chain.as_raw(),
        largest_only.as_raw(),
        "the inline chain's shared blur pass uses its maximum radius, not repeated blur passes"
    );
}

#[test]
fn monochrome_glyph_samples_at_transformed_destination_coordinates() {
    use gpui::{
        AtlasTextureId, AtlasTextureKind, AtlasTile, CapturedBitmap, MonochromeSprite, TileId,
        TransformationMatrix,
    };
    use gpui_ce_render::cpu::{CpuAtlas, CpuRenderer};

    let bitmap = CapturedBitmap {
        kind: AtlasTextureKind::Monochrome,
        width: 2,
        height: 2,
        bytes: vec![255; 4],
    };
    let atlas = CpuAtlas::new();
    let tile = AtlasTile {
        texture_id: AtlasTextureId {
            index: 0,
            kind: AtlasTextureKind::Monochrome,
        },
        tile_id: TileId(0),
        padding: 0,
        bounds: Bounds {
            origin: point(DevicePixels(0), DevicePixels(0)),
            size: Size {
                width: DevicePixels(2),
                height: DevicePixels(2),
            },
        },
    };
    atlas.insert_captured(tile.texture_id, bitmap).unwrap();
    let glyph_bounds = rect(0.0, 0.0, 2.0, 2.0);
    let mut scene = Scene::default();
    scene.insert_primitive(MonochromeSprite {
        order: 0,
        padding: 0,
        bounds: glyph_bounds,
        content_mask: ContentMask {
            bounds: rect(0.0, 0.0, 4.0, 2.0),
            ..Default::default()
        },
        color: Hsla::new(0.0, 1.0, 0.5, 1.0).into(),
        tile,
        transformation: TransformationMatrix {
            rotation_scale: [[1.0, 0.0], [0.0, 1.0]],
            translation: [1.0, 0.0],
        },
    });
    scene.finish();
    let mut renderer = CpuRenderer::from_atlas(atlas.into());
    let image = renderer
        .render_scene_to_image(
            &scene,
            Size {
                width: DevicePixels(4),
                height: DevicePixels(2),
            },
        )
        .unwrap();
    assert_eq!(
        image.get_pixel(0, 0).0,
        [0, 0, 0, 0],
        "untransformed origin must remain clear"
    );
    assert_eq!(
        image.get_pixel(1, 0).0,
        [255, 0, 0, 255],
        "transformed glyph starts one pixel right"
    );
    assert_eq!(
        image.get_pixel(2, 1).0,
        [255, 0, 0, 255],
        "all glyph coverage follows the transform"
    );
    assert_eq!(
        image.get_pixel(3, 0).0,
        [0, 0, 0, 0],
        "glyph must not extend beyond transformed bounds"
    );
}

#[test]
fn empty_glyph_is_cached_without_creating_a_zero_sized_atlas_tile() {
    use gpui::{
        FontId, ForegroundDependency, GlyphId, GlyphRenderMode, PlatformAtlas, PreparedRasterStyle,
        RasterColorEffect, RasterizedGlyph, RasterizedGlyphFormat, RenderGlyphParams,
        ValidatedRasterizedGlyph, px,
    };

    let atlas = CpuAtlas::new();
    let params = RenderGlyphParams {
        font_id: FontId(0),
        glyph_id: GlyphId(0),
        font_size: px(12.0),
        subpixel_variant: point(0, 0),
        scale_factor: 1.0,
        raster_style: PreparedRasterStyle {
            mode: GlyphRenderMode::Grayscale,
            color_effect: RasterColorEffect::Independent,
            foreground_dependency: ForegroundDependency::Full,
        },
    };
    let build = || {
        ValidatedRasterizedGlyph::new(RasterizedGlyph::empty(RasterizedGlyphFormat::AlphaMask))
            .expect("valid empty glyph")
    };
    let entry = atlas
        .get_or_insert_glyph_with(&params, &mut || Ok(build()))
        .unwrap();
    assert!(
        entry.tile.is_none(),
        "empty glyphs have placement but no atlas tile"
    );
    let cached = atlas
        .get_or_insert_glyph_with(&params, &mut || {
            panic!("cached empty glyph must not rasterize again")
        })
        .unwrap();
    assert_eq!(cached, entry);
}

#[test]
fn removing_an_atlas_key_forces_pixels_to_be_rebuilt() {
    use gpui::{
        AtlasKey, FontId, ForegroundDependency, GlyphId, GlyphRenderMode, PlatformAtlas,
        PreparedRasterStyle, RasterColorEffect, RasterizedGlyphFormat, RenderGlyphParams, px,
    };
    use std::borrow::Cow;

    let atlas = CpuAtlas::new();
    let params = RenderGlyphParams {
        font_id: FontId(2),
        glyph_id: GlyphId(19),
        font_size: px(12.0),
        subpixel_variant: point(0, 0),
        scale_factor: 1.0,
        raster_style: PreparedRasterStyle {
            mode: GlyphRenderMode::Grayscale,
            color_effect: RasterColorEffect::Independent,
            foreground_dependency: ForegroundDependency::Full,
        },
    };
    let key = AtlasKey::Glyph {
        params,
        format: RasterizedGlyphFormat::AlphaMask,
    };
    let upload = |byte| {
        atlas
            .get_or_insert_with(&key, &mut || {
                Ok(Some((
                    Size {
                        width: DevicePixels(1),
                        height: DevicePixels(1),
                    },
                    Cow::Owned(vec![byte]),
                )))
            })
            .unwrap()
            .unwrap()
    };
    let first = upload(32);
    assert_eq!(atlas.resolve(first).unwrap().bytes, [32]);
    atlas.remove(&key);
    let rebuilt = upload(224);
    assert_ne!(
        first.texture_id, rebuilt.texture_id,
        "removal must discard the old key mapping"
    );
    assert_eq!(atlas.resolve(rebuilt).unwrap().bytes, [224]);
}

#[test]
fn rounded_polychrome_sprite_has_clear_corners_and_opaque_center() {
    use gpui::{
        AtlasTextureId, AtlasTextureKind, AtlasTile, CapturedBitmap, Corners, PolychromeSprite,
        ShaderBool, TileId,
    };

    let atlas = CpuAtlas::new();
    let texture_id = AtlasTextureId {
        index: 0,
        kind: AtlasTextureKind::Polychrome,
    };
    atlas
        .insert_captured(
            texture_id,
            CapturedBitmap {
                kind: AtlasTextureKind::Polychrome,
                width: 8,
                height: 8,
                bytes: [0, 0, 255, 255].repeat(64),
            },
        )
        .unwrap();
    let bounds = rect(0.0, 0.0, 8.0, 8.0);
    let tile = AtlasTile {
        texture_id,
        tile_id: TileId(0),
        padding: 0,
        bounds: Bounds {
            origin: point(DevicePixels(0), DevicePixels(0)),
            size: Size {
                width: DevicePixels(8),
                height: DevicePixels(8),
            },
        },
    };
    let mut scene = Scene::default();
    scene.insert_primitive(PolychromeSprite {
        order: 0,
        grayscale: ShaderBool::Disabled,
        opacity: 1.0,
        corner_smoothing: 0.5,
        bounds,
        content_mask: ContentMask {
            bounds,
            ..Default::default()
        },
        corner_radii: Corners {
            top_left: ScaledPixels(3.0),
            top_right: ScaledPixels(3.0),
            bottom_right: ScaledPixels(3.0),
            bottom_left: ScaledPixels(3.0),
        },
        tile,
    });
    scene.finish();
    let image = render_scene_to_image(
        &scene,
        Size {
            width: DevicePixels(8),
            height: DevicePixels(8),
        },
        &atlas,
    )
    .unwrap();
    assert_eq!(
        image.get_pixel(0, 0).0[3],
        0,
        "rounded sprite corner must be transparent"
    );
    assert_eq!(
        image.get_pixel(4, 4).0,
        [255, 0, 0, 255],
        "sprite center must retain source pixels"
    );
}

proptest! {
    #![proptest_config(ProptestConfig { cases: 32, .. ProptestConfig::default() })]

    #[test]
    fn multi_sprite_capture_is_independent_of_texture_allocation_order(
        red_index in 0u32..10_000,
        red_tile in 0u32..1_000,
        blue_tile in 0u32..1_000,
        red_page_x in 0i32..64,
        blue_page_y in 0i32..64,
    ) {
        use gpui::{
            AtlasTextureId, AtlasTextureKind, AtlasTile, CapturedBitmap, PolychromeSprite,
            SceneCapture, ShaderBool, TileId,
        };
        let blue_index = red_index + 10_000;
        let red_pixels = [0, 0, 255, 255].repeat(4);
        let blue_pixels = [255, 0, 0, 255].repeat(4);

        fn tile(index: u32, tile_id: u32, page_x: i32, page_y: i32) -> AtlasTile {
            AtlasTile {
                texture_id: AtlasTextureId { index, kind: AtlasTextureKind::Polychrome },
                tile_id: TileId(tile_id),
                padding: 1,
                bounds: Bounds {
                    origin: point(DevicePixels(page_x), DevicePixels(page_y)),
                    size: Size { width: DevicePixels(2), height: DevicePixels(2) },
                },
            }
        }
        fn sprite(bounds: Bounds<ScaledPixels>, tile: AtlasTile) -> PolychromeSprite {
            PolychromeSprite {
                order: 0,
                grayscale: ShaderBool::Disabled,
                opacity: 1.0,
                corner_smoothing: 0.0,
                bounds,
                content_mask: ContentMask { bounds, ..Default::default() },
                corner_radii: Default::default(),
                tile,
            }
        }
        fn captured(
            red_texture: u32,
            blue_texture: u32,
            red_tile: u32,
            blue_tile: u32,
            red_page_x: i32,
            blue_page_y: i32,
            red_bounds: Bounds<ScaledPixels>,
            blue_bounds: Bounds<ScaledPixels>,
            red_pixels: &[u8],
            blue_pixels: &[u8],
        ) -> SceneCapture {
            let mut scene = Scene::default();
            scene.insert_primitive(sprite(red_bounds, tile(red_texture, red_tile, red_page_x, 0)));
            scene.insert_primitive(sprite(blue_bounds, tile(blue_texture, blue_tile, 0, blue_page_y)));
            scene.finish();
            SceneCapture::capture(&scene, |source| {
                let bytes = if source.texture_id.index == red_texture { red_pixels } else { blue_pixels };
                Ok(CapturedBitmap { kind: AtlasTextureKind::Polychrome, width: 2, height: 2, bytes: bytes.to_vec() })
            }).expect("canonicalize overlapping sprite scene")
        }

        let first = captured(
            red_index, blue_index, red_tile, blue_tile, red_page_x, blue_page_y,
            rect(0.0, 0.0, 3.0, 3.0), rect(1.0, 1.0, 3.0, 3.0),
            &red_pixels, &blue_pixels,
        );
        let second = captured(
            blue_index, red_index, blue_tile + 1, red_tile + 1, blue_page_y + 7, red_page_x + 9,
            rect(0.0, 0.0, 3.0, 3.0), rect(1.0, 1.0, 3.0, 3.0),
            &red_pixels, &blue_pixels,
        );
        prop_assert_eq!(serde_json::to_value(&first).unwrap(), serde_json::to_value(&second).unwrap());
        prop_assert_eq!(first.bitmaps().len(), 2);

        let mut renderer_a = gpui_ce_render::cpu::CpuRenderer::from_captured_bitmaps(first.bitmaps()).unwrap();
        let mut renderer_b = gpui_ce_render::cpu::CpuRenderer::from_captured_bitmaps(second.bitmaps()).unwrap();
        let scene_a = first.into_scene().unwrap();
        let scene_b = second.into_scene().unwrap();
        let viewport = Size { width: DevicePixels(4), height: DevicePixels(4) };
        let image_a = renderer_a.render_scene_to_image(&scene_a, viewport).unwrap();
        let image_b = renderer_b.render_scene_to_image(&scene_b, viewport).unwrap();
        prop_assert_eq!(&image_a, &image_b);
        prop_assert_eq!(image_a.get_pixel(0, 0).0, [255, 0, 0, 255]);
        prop_assert_eq!(image_a.get_pixel(1, 1).0, [0, 0, 255, 255]);

        let first_nonoverlap = captured(
            red_index, blue_index, red_tile, blue_tile, red_page_x, blue_page_y,
            rect(0.0, 0.0, 2.0, 2.0), rect(2.0, 0.0, 2.0, 2.0),
            &red_pixels, &blue_pixels,
        );
        let second_nonoverlap = captured(
            blue_index, red_index, blue_tile + 1, red_tile + 1, blue_page_y + 7, red_page_x + 9,
            rect(0.0, 0.0, 2.0, 2.0), rect(2.0, 0.0, 2.0, 2.0),
            &red_pixels, &blue_pixels,
        );
        prop_assert_eq!(
            serde_json::to_value(&first_nonoverlap).unwrap(),
            serde_json::to_value(&second_nonoverlap).unwrap(),
            "same-order, non-overlapping sprites must serialize canonically after tile allocation changes",
        );
        let mut renderer_a = gpui_ce_render::cpu::CpuRenderer::from_captured_bitmaps(
            first_nonoverlap.bitmaps(),
        )
        .unwrap();
        let mut renderer_b = gpui_ce_render::cpu::CpuRenderer::from_captured_bitmaps(
            second_nonoverlap.bitmaps(),
        )
        .unwrap();
        let scene_a = first_nonoverlap.into_scene().unwrap();
        let scene_b = second_nonoverlap.into_scene().unwrap();
        let viewport = Size {
            width: DevicePixels(4),
            height: DevicePixels(2),
        };
        let image_a = renderer_a.render_scene_to_image(&scene_a, viewport).unwrap();
        let image_b = renderer_b.render_scene_to_image(&scene_b, viewport).unwrap();
        prop_assert_eq!(&image_a, &image_b);
        prop_assert_eq!(image_a.get_pixel(0, 0).0, [255, 0, 0, 255]);
        prop_assert_eq!(image_a.get_pixel(2, 0).0, [0, 0, 255, 255]);
    }
}
