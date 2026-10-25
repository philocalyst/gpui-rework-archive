//! Clipping rendering contracts.
use super::*;

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
fn cropping_large_offscreen_quads_preserves_fractional_mask_edge_coverage() {
    use gpui::Edges;

    let mask_bounds = rect(-0.25, -0.25, 4.75, 3.0);
    let mask = ContentMask {
        bounds: mask_bounds,
        fade_out: Edges {
            left: ScaledPixels(1.5),
            right: ScaledPixels(1.0),
            top: ScaledPixels(1.0),
            bottom: ScaledPixels(0.75),
        },
    };
    let mut quad = solid(
        rect(-100.25, -80.75, 240.5, 120.25),
        Hsla::new(0.0, 1.0, 0.5, 1.0),
    );
    quad.content_mask = mask;
    let mut scene = Scene::default();
    scene.insert_primitive(quad);

    let image = render(&mut scene, 6, 5);
    let left = mask_bounds.origin.x.0;
    let top = mask_bounds.origin.y.0;
    let right = left + mask_bounds.size.width.0;
    let bottom = top + mask_bounds.size.height.0;
    for y in 0..5 {
        for x in 0..6 {
            let center_x = x as f32 + 0.5;
            let center_y = y as f32 + 0.5;
            let inside =
                center_x >= left && center_x <= right && center_y >= top && center_y <= bottom;
            let fade = |distance: f32, width: f32| (distance / width).clamp(0.0, 1.0);
            let alpha = if inside {
                fade(center_x - left, 1.5)
                    * fade(right - center_x, 1.0)
                    * fade(center_y - top, 1.0)
                    * fade(bottom - center_y, 0.75)
            } else {
                0.0
            };
            let alpha_byte = (alpha * 255.0 + 0.5) as u8;
            let expected = if alpha == 0.0 {
                [0, 0, 0, 0]
            } else {
                [255, 0, 0, alpha_byte]
            };
            assert_eq!(
                image.get_pixel(x, y).0,
                expected,
                "mask coverage mismatch at ({x}, {y})"
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
