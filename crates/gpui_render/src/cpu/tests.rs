use super::*;
use gpui::{Bounds, ContentMask, Hsla, Point, ScaledPixels};

fn scene_quad(bounds: Bounds<ScaledPixels>, color: Hsla) -> gpui::Quad {
    gpui::Quad {
        bounds,
        content_mask: ContentMask {
            bounds,
            ..Default::default()
        },
        background: color.into(),
        ..Default::default()
    }
}
fn bounds(x: f32, y: f32, w: f32, h: f32) -> Bounds<ScaledPixels> {
    Bounds {
        origin: Point {
            x: ScaledPixels(x),
            y: ScaledPixels(y),
        },
        size: Size {
            width: ScaledPixels(w),
            height: ScaledPixels(h),
        },
    }
}

#[test]
fn shader_quad_pixel_uses_production_coverage_and_premultiplies() {
    let quad = scene_quad(bounds(0., 0., 2., 2.), Hsla::new(0., 1., 0.5, 0.5));
    let color =
        crate::shaders::host::QuadShader::new(&quad, false).sample(wgsl_rs::std::vec2f(1., 1.));
    assert!((color[0] - 0.5).abs() < 0.002);
    assert!(color[1] < 0.002 && color[2] < 0.002);
    assert!((color[3] - 0.5).abs() < 0.002);
}

#[test]
fn source_over_preserves_premultiplied_alpha_order() {
    let mut frame = Frame::new(1, 1);
    frame.over_at(0, 0, [0., 0., 0.5, 0.5]);
    frame.over_at(0, 0, [0.5, 0., 0., 0.5]);
    let pixel = frame.pixels[0];
    assert_eq!(pixel, [0.5, 0., 0.25, 0.75]);
}

#[test]
fn content_mask_clips_quad_pixels_even_without_fade_edges() {
    let mut scene = Scene::default();
    let mut quad = scene_quad(bounds(0., 0., 4., 1.), Hsla::new(0., 1., 0.5, 1.));
    quad.content_mask = ContentMask {
        bounds: bounds(1., 0., 2., 1.),
        ..Default::default()
    };
    scene.insert_primitive(quad);
    scene.finish();
    let image = render_scene_to_image(
        &scene,
        Size {
            width: DevicePixels(4),
            height: DevicePixels(1),
        },
        &CpuAtlas::new(),
    )
    .unwrap();
    assert_eq!(image.get_pixel(0, 0).0[3], 0);
    assert!(image.get_pixel(1, 0).0[3] > 0);
    assert_eq!(image.get_pixel(3, 0).0[3], 0);
}

#[test]
fn rotated_non_square_sprite_keeps_tile_orientation_and_screen_space_mask() {
    let atlas = CpuAtlas::new();
    let tile = gpui::AtlasTile {
        texture_id: gpui::AtlasTextureId {
            kind: AtlasTextureKind::Monochrome,
            index: 0,
        },
        tile_id: gpui::TileId(0),
        padding: 0,
        bounds: Bounds {
            origin: Point {
                x: DevicePixels(0),
                y: DevicePixels(0),
            },
            size: Size {
                width: DevicePixels(3),
                height: DevicePixels(2),
            },
        },
    };
    atlas
        .insert_captured(
            tile.texture_id,
            CapturedBitmap {
                kind: AtlasTextureKind::Monochrome,
                width: 3,
                height: 2,
                bytes: vec![255, 0, 255, 0, 255, 0],
            },
        )
        .unwrap();

    let sprite_bounds = bounds(0., 0., 3., 2.);
    let mut scene = Scene::default();
    scene.insert_primitive(gpui::MonochromeSprite {
        order: gpui::DrawOrder::default(),
        padding: 0,
        bounds: sprite_bounds,
        // The rotated rectangle occupies x=3..5, so this mask retains its left column.
        content_mask: ContentMask {
            bounds: bounds(3., 1., 1., 3.),
            ..Default::default()
        },
        color: Hsla::new(0., 0., 1., 1.).into(),
        tile,
        transformation: gpui::TransformationMatrix {
            rotation_scale: [[0., -1.], [1., 0.]],
            translation: [5., 1.],
        },
    });
    scene.finish();

    let image = render_scene_to_image(
        &scene,
        Size {
            width: DevicePixels(7),
            height: DevicePixels(5),
        },
        &atlas,
    )
    .unwrap();

    // Clockwise rotation maps the source's bottom row to the left target column.
    eprintln!(
        "rotated sprite alphas: {:?}",
        (1..4)
            .map(|y| (3..5)
                .map(|x| image.get_pixel(x, y).0[3])
                .collect::<Vec<_>>())
            .collect::<Vec<_>>()
    );
    for (row, alpha) in [0, 255, 0].into_iter().enumerate() {
        assert_eq!(image.get_pixel(3, row as u32 + 1).0[3], alpha);
        assert_eq!(image.get_pixel(4, row as u32 + 1).0[3], 0);
    }
    assert_eq!(image.get_pixel(2, 2).0[3], 0);
    assert_eq!(image.get_pixel(5, 2).0[3], 0);
}

#[test]
fn nested_isolated_filters_composite_once_and_inline_fallback_keeps_parent_target() {
    let area = bounds(0., 0., 5., 5.);
    let boundary = |order: u32, is_start: bool| gpui::FilterBoundary {
        order,
        bounds: area,
        content_mask: ContentMask {
            bounds: area,
            ..Default::default()
        },
        corner_radii: gpui::Corners::default(),
        corner_smoothing: 0.,
        filters: smallvec::smallvec![gpui::ScaledFilter::Blur(ScaledPixels(0.5))],
        opacity: 0.5,
        is_start,
    };
    let mut scene = Scene::default();
    scene.filter_boundaries = vec![
        boundary(0, true),
        boundary(1, true),
        boundary(2, true),
        boundary(4, false),
        boundary(5, false),
        boundary(6, false),
    ];
    let mut quad = scene_quad(area, Hsla::new(0., 1., 0.5, 1.));
    quad.order = 3;
    scene.quads.push(quad);
    scene.finish();
    let commands = scene.render_commands();
    let isolated = commands
        .iter()
        .filter(|command| {
            matches!(
                command,
                gpui::RenderCommand::BeginFilter {
                    target: FilterRenderTarget::Isolated(_),
                    ..
                }
            )
        })
        .count();
    let inline = commands
        .iter()
        .filter(|command| {
            matches!(
                command,
                gpui::RenderCommand::BeginFilter {
                    target: FilterRenderTarget::Inline,
                    ..
                }
            )
        })
        .count();
    assert_eq!((isolated, inline), (2, 1));
    let image = render_scene_to_image(
        &scene,
        Size {
            width: DevicePixels(5),
            height: DevicePixels(5),
        },
        &CpuAtlas::new(),
    )
    .unwrap();
    assert_eq!(image.get_pixel(2, 2).0, [255, 0, 0, 64]);
}

#[test]
fn wavy_underline_coverage_changes_along_the_shader_wave() {
    let line = gpui::Underline {
        order: gpui::DrawOrder::default(),
        padding: 0,
        bounds: bounds(0., 0., 40., 4.),
        content_mask: ContentMask {
            bounds: bounds(0., 0., 40., 4.),
            ..Default::default()
        },
        color: Hsla::new(0., 0., 0., 1.).into(),
        thickness: ScaledPixels(1.),
        wavy: ShaderBool::Enabled,
    };
    let coverage = (0..4)
        .map(|x| {
            crate::shaders::host::wavy_underline_coverage(
                &line,
                wgsl_rs::std::vec2f(x as f32 * 5.0 + 0.5, 2.0),
            )
        })
        .collect::<Vec<_>>();
    assert!(coverage.iter().any(|value| *value > 0.5));
    assert!(coverage.iter().any(|value| *value < 0.5));
}
