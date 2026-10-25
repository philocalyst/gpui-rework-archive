//! Compositing rendering contracts.
use super::*;

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
