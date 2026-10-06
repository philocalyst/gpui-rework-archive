//! Renders one of every primitive kind through the headless WGPU renderer and checks
//! that each one actually lands on the target. This is the cross-platform smoke test for
//! the shared render plan, instance transport, and generated shaders.
#![cfg(feature = "test-support")]

use gpui::{
    AtlasKey, AtlasTile, BackdropFilter, BorderStyle, Bounds, ColorSpace, ContentMask, Corners,
    DevicePixels, Edges, Hsla, MonochromeSprite, PlatformHeadlessRenderer, Point, PolychromeSprite,
    Quad, RenderImageParams, RenderSvgParams, ScaledFilter, ScaledPixels, Scene, ShaderBool,
    Shadow, Size, Underline, checkerboard, linear_color_stop, linear_gradient, solid_background,
};
use gpui_ce_wgpu::WgpuHeadlessRenderer;
use smallvec::smallvec;
use std::borrow::Cow;

const TARGET: Size<DevicePixels> = Size {
    width: DevicePixels(310),
    height: DevicePixels(100),
};

#[test]
fn filled_path_resolves_without_invalidating_the_frame() {
    let mut renderer = WgpuHeadlessRenderer::new().expect("headless renderer");
    let mut scene = Scene::default();
    scene.insert_primitive(Quad {
        bounds: bounds(0.0, 0.0, 200.0, 100.0),
        content_mask: full_mask(),
        background: solid_background(gpui::black()),
        ..Default::default()
    });
    let mut builder = gpui::PathBuilder::fill();
    builder.move_to(gpui::point(gpui::px(20.0), gpui::px(20.0)));
    builder.line_to(gpui::point(gpui::px(80.0), gpui::px(20.0)));
    builder.line_to(gpui::point(gpui::px(50.0), gpui::px(80.0)));
    builder.close();
    let mut path = builder.build().expect("triangle").scale(1.0);
    path.content_mask = full_mask();
    path.color = solid_background(gpui::white());
    scene.insert_primitive(path);
    scene.finish();

    // The path uses an MSAA attachment when supported. Storing that transient
    // attachment invalidates the command buffer, including the background quad.
    let image = renderer
        .render_scene_to_image(&scene, TARGET)
        .expect("valid path frame");
    assert_eq!(image.get_pixel(50, 40).0, [255, 255, 255, 255]);
    assert_eq!(image.get_pixel(150, 40).0, [0, 0, 0, 255]);
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

fn full_mask() -> ContentMask<ScaledPixels> {
    ContentMask {
        bounds: bounds(0.0, 0.0, 310.0, 100.0),
        ..Default::default()
    }
}

#[test]
fn nested_spaces_clip_exactly_and_survive_replay_id_remapping() {
    let mut renderer = WgpuHeadlessRenderer::new().expect("headless renderer");
    let camera = gpui::TransformationMatrix::unit()
        .translate(gpui::point(ScaledPixels(50.0), ScaledPixels(30.0)))
        .rotate(gpui::Radians(std::f32::consts::FRAC_PI_4));
    let mut scene = Scene::default();
    scene.with_transform(camera, |scene| {
        scene.with_clip(mask(30.0, 20.0), |scene| {
            // The child has its own scale and clip. Its larger shape must still
            // respect the parent's rotated rectangle in the parent's coordinates.
            scene.with_transform(
                gpui::TransformationMatrix::unit().scale(Size::new(2.0, 1.0)),
                |scene| {
                    scene.with_clip(mask(30.0, 60.0), |scene| {
                        scene.insert_primitive(Quad {
                            bounds: bounds(0.0, 0.0, 60.0, 60.0),
                            content_mask: full_mask(),
                            background: solid_background(gpui::white()),
                            ..Default::default()
                        });
                    });
                },
            );
        });
    });
    scene.finish();
    let original = renderer.render_scene_to_image(&scene, TARGET).unwrap();
    assert_eq!(original.get_pixel(53, 44).0, [255, 255, 255, 255]);
    // Inside the rotated clip's AABB, outside the actual clip.
    assert_eq!(original.get_pixel(65, 31).0, [0, 0, 0, 255]);
    // Inside the child, beyond the parent clip's right edge.
    assert_eq!(original.get_pixel(78, 66).0, [0, 0, 0, 255]);

    let mut replayed = Scene::default();
    replayed.with_transform(
        gpui::TransformationMatrix::unit().rotate(gpui::Radians(0.2)),
        |_| {},
    );
    replayed.replay(0..1, &scene);
    replayed.finish();
    assert_eq!(
        renderer.render_scene_to_image(&replayed, TARGET).unwrap(),
        original
    );
}

#[test]
fn transformed_path_and_backdrop_use_local_shape_and_screen_scheduling() {
    let mut renderer = WgpuHeadlessRenderer::new().expect("headless renderer");
    let mut scene = Scene::default();
    scene.with_transform(
        gpui::TransformationMatrix::unit()
            .translate(gpui::point(ScaledPixels(50.0), ScaledPixels(30.0)))
            .rotate(gpui::Radians(std::f32::consts::FRAC_PI_4)),
        |scene| {
            scene.with_clip(mask(30.0, 20.0), |scene| {
                let mut builder = gpui::PathBuilder::fill();
                builder.move_to(gpui::point(gpui::px(0.0), gpui::px(0.0)));
                builder.line_to(gpui::point(gpui::px(60.0), gpui::px(0.0)));
                builder.line_to(gpui::point(gpui::px(60.0), gpui::px(60.0)));
                builder.line_to(gpui::point(gpui::px(0.0), gpui::px(60.0)));
                builder.close();
                let mut path = builder.build().unwrap().scale(1.0);
                path.content_mask = full_mask();
                path.color = solid_background(gpui::white());
                scene.insert_primitive(path);
                scene.insert_primitive(BackdropFilter {
                    bounds: bounds(0.0, 0.0, 30.0, 20.0),
                    content_mask: full_mask(),
                    filters: smallvec![ScaledFilter::Blur(ScaledPixels(2.0))],
                    opacity: 1.0,
                    ..Default::default()
                });
            });
        },
    );
    scene.finish();
    let image = renderer.render_scene_to_image(&scene, TARGET).unwrap();
    assert!(image.get_pixel(53, 44).0[0] > 240);
    assert_eq!(image.get_pixel(65, 31).0, [0, 0, 0, 255]);
}

fn mask(width: f32, height: f32) -> ContentMask<ScaledPixels> {
    ContentMask {
        bounds: bounds(0.0, 0.0, width, height),
        ..Default::default()
    }
}

#[test]
fn content_blur_follows_nonuniform_and_rotated_local_axes() {
    let mut renderer = WgpuHeadlessRenderer::new().expect("headless renderer");
    for angle in [0.0, std::f32::consts::FRAC_PI_4] {
        let mut scene = Scene::default();
        scene.with_transform(
            gpui::TransformationMatrix::unit()
                .translate(gpui::point(ScaledPixels(110.0), ScaledPixels(50.0)))
                .rotate(gpui::Radians(angle))
                .scale(Size::new(2.0, 0.5)),
            |scene| {
                let boundary = gpui::FilterBoundary {
                    geometry: None,
                    order: 0,
                    bounds: bounds(-20.0, -20.0, 40.0, 40.0),
                    content_mask: ContentMask {
                        bounds: bounds(-200.0, -200.0, 400.0, 400.0),
                        ..Default::default()
                    },
                    corner_radii: Default::default(),
                    corner_smoothing: 0.0,
                    filters: smallvec![ScaledFilter::Blur(ScaledPixels(8.0))],
                    opacity: 1.0,
                    is_start: true,
                };
                scene.insert_primitive(boundary.clone());
                scene.insert_primitive(Quad {
                    bounds: bounds(-1.0, -1.0, 2.0, 2.0),
                    content_mask: boundary.content_mask,
                    background: solid_background(gpui::white()),
                    ..Default::default()
                });
                scene.insert_primitive(gpui::FilterBoundary {
                    is_start: false,
                    ..boundary
                });
            },
        );
        scene.finish();
        let image = renderer.render_scene_to_image(&scene, TARGET).unwrap();
        // Project the rendered impulse onto the transformed local axes. A blur
        // using only the largest scale would instead produce a circular halo.
        let (sin, cos) = angle.sin_cos();
        let mut mass = 0.0;
        let mut moments = [0.0; 2];
        for (x, y, pixel) in image.enumerate_pixels() {
            let weight = pixel.0[0] as f32;
            let dx = x as f32 + 0.5 - 110.0;
            let dy = y as f32 + 0.5 - 50.0;
            mass += weight;
            moments[0] += weight * (cos * dx + sin * dy).powi(2);
            moments[1] += weight * (-sin * dx + cos * dy).powi(2);
        }
        assert!(mass > 100.0, "the impulse must survive compositing");
        assert!(
            moments[0] > moments[1] * 4.0,
            "blur must follow both local scales at angle {angle}: {moments:?}"
        );
    }
}

fn tile(renderer: &WgpuHeadlessRenderer, key: AtlasKey, bytes: Vec<u8>) -> AtlasTile {
    renderer
        .sprite_atlas()
        .get_or_insert_with(&key, &mut || {
            Ok(Some((
                Size {
                    width: DevicePixels(8),
                    height: DevicePixels(8),
                },
                Cow::Owned(bytes.clone()),
            )))
        })
        .expect("atlas insert must succeed")
        .expect("atlas insert must produce a tile")
}

#[test]
fn every_primitive_kind_renders() {
    let mut renderer = WgpuHeadlessRenderer::new().expect("headless renderer");
    let mono = tile(
        &renderer,
        AtlasKey::Svg(RenderSvgParams {
            path: "test-mono".into(),
            size: Size {
                width: DevicePixels(8),
                height: DevicePixels(8),
            },
        }),
        vec![255; 64],
    );
    let poly = tile(
        &renderer,
        AtlasKey::Image(RenderImageParams {
            image_id: gpui::ImageId(1),
            frame_index: 0,
        }),
        // BGRA red, opaque.
        (0..64).flat_map(|_| [0u8, 0, 255, 255]).collect(),
    );

    let mut scene = Scene::default();
    let green: Hsla = gpui::rgb_to_hsla(gpui::rgb(0x00ff00));
    let red: Hsla = gpui::rgb_to_hsla(gpui::rgb(0xff0000));
    let white: Hsla = gpui::rgb_to_hsla(gpui::rgb(0xffffff));
    let blue: Hsla = gpui::rgb_to_hsla(gpui::rgb(0x0000ff));

    // 1. Solid quad.
    let quad_bounds = bounds(10.0, 10.0, 30.0, 30.0);
    scene.insert_primitive(Quad {
        order: 0,
        bounds: quad_bounds,
        content_mask: full_mask(),
        background: solid_background(green),
        ..Default::default()
    });
    // 2. Bordered quad (white border, transparent fill).
    let bordered = bounds(50.0, 10.0, 30.0, 30.0);
    scene.insert_primitive(Quad {
        order: 0,
        bounds: bordered,
        content_mask: full_mask(),
        border_color: white.into(),
        border_widths: gpui::Edges::all(ScaledPixels(4.0)),
        ..Default::default()
    });
    // 3. Shadow (blue, no blur so it is a solid block).
    let shadow_bounds = bounds(90.0, 10.0, 30.0, 30.0);
    scene.insert_primitive(Shadow {
        order: 0,
        blur_radius: ScaledPixels(0.0),
        bounds: shadow_bounds,
        corner_radii: Default::default(),
        content_mask: full_mask(),
        color: blue.into(),
        element_bounds: shadow_bounds,
        element_corner_radii: Default::default(),
        inset: ShaderBool::Disabled,
        corner_smoothing: 0.0,
    });
    // 4. Underline (white, solid).
    let underline_bounds = bounds(130.0, 20.0, 30.0, 4.0);
    scene.insert_primitive(Underline {
        order: 0,
        padding: 0,
        bounds: underline_bounds,
        content_mask: full_mask(),
        color: white.into(),
        thickness: ScaledPixels(4.0),
        wavy: ShaderBool::Disabled,
    });
    // 5. Monochrome sprite (white coverage tile tinted green).
    let mono_bounds = bounds(10.0, 60.0, 30.0, 30.0);
    scene.insert_primitive(MonochromeSprite {
        order: 0,
        padding: 0,
        bounds: mono_bounds,
        content_mask: full_mask(),
        color: green.into(),
        tile: mono,
        transformation: Default::default(),
    });
    // 6. Polychrome sprite (red image).
    let poly_bounds = bounds(50.0, 60.0, 30.0, 30.0);
    scene.insert_primitive(PolychromeSprite {
        order: 0,
        grayscale: ShaderBool::Disabled,
        opacity: 1.0,
        corner_smoothing: 0.0,
        bounds: poly_bounds,
        content_mask: full_mask(),
        corner_radii: Default::default(),
        tile: poly,
    });
    // 7. A second quad batch. Overlapping the image pushes this quad above it in draw
    //    order, so it starts past the first quads in the frame's quad buffer: a backend
    //    that loses the batch base draws the wrong quads here.
    let late_quad = bounds(60.0, 70.0, 30.0, 30.0);
    scene.insert_primitive(Quad {
        order: 0,
        bounds: late_quad,
        content_mask: full_mask(),
        background: solid_background(blue),
        ..Default::default()
    });
    // 8–9. Gradient drop and inset shadows. The inset gradient stays in the element's paint
    // coordinate space while its offset hole is smaller.
    let gradient = linear_gradient(
        90.0,
        linear_color_stop(red, 0.0),
        linear_color_stop(blue, 1.0),
    )
    .color_space(ColorSpace::Srgb);
    let gradient_drop_bounds = bounds(210.0, 10.0, 40.0, 40.0);
    scene.insert_primitive(Shadow {
        order: 0,
        blur_radius: ScaledPixels(0.0),
        bounds: gradient_drop_bounds,
        corner_radii: Default::default(),
        content_mask: full_mask(),
        color: gradient,
        element_bounds: gradient_drop_bounds,
        element_corner_radii: Default::default(),
        inset: ShaderBool::Disabled,
        corner_smoothing: 0.0,
    });
    scene.insert_primitive(Shadow {
        order: 0,
        blur_radius: ScaledPixels(0.0),
        bounds: bounds(266.0, 16.0, 28.0, 28.0),
        corner_radii: Default::default(),
        content_mask: full_mask(),
        color: gradient,
        element_bounds: bounds(260.0, 10.0, 40.0, 40.0),
        element_corner_radii: Default::default(),
        inset: ShaderBool::Enabled,
        corner_smoothing: 0.0,
    });
    scene.finish();
    let quad_batches: Vec<_> = scene
        .render_commands()
        .iter()
        .filter_map(|command| match command {
            gpui::RenderCommand::Batch(gpui::PrimitiveBatch::Quads { range, .. }) => {
                Some(range.clone())
            }
            _ => None,
        })
        .collect();
    assert_eq!(
        quad_batches,
        vec![0..2, 2..3],
        "the scene must split quads across batches"
    );

    let image = renderer
        .render_scene_to_image(&scene, TARGET)
        .expect("render must succeed");
    let px = |x: u32, y: u32| {
        let p = image.get_pixel(x, y).0;
        (p[0], p[1], p[2], p[3])
    };
    let mut failures = Vec::new();
    let mut check = |name: &str, x: u32, y: u32, expected: (u8, u8, u8)| {
        let (r, g, b, _) = px(x, y);
        let close = |a: u8, b: u8| (a as i32 - b as i32).abs() <= 8;
        if !(close(r, expected.0) && close(g, expected.1) && close(b, expected.2)) {
            failures.push(format!(
                "{name} at ({x},{y}): got ({r},{g},{b}) expected {expected:?}"
            ));
        }
    };
    check("solid quad", 25, 25, (0, 255, 0));
    check("bordered quad border", 52, 25, (255, 255, 255));
    check("bordered quad interior", 65, 25, (0, 0, 0));
    check("shadow", 105, 25, (0, 0, 255));
    check("underline", 145, 22, (255, 255, 255));
    check("monochrome sprite", 25, 75, (0, 255, 0));
    check("polychrome sprite", 55, 65, (255, 0, 0));
    check("second quad batch", 85, 85, (0, 0, 255));
    check("background", 190, 90, (0, 0, 0));
    check("gradient inset shadow hole", 280, 30, (0, 0, 0));
    let mut check_dominant = |name: &str, x: u32, y: u32, red_dominant: bool| {
        let (r, g, b, _) = px(x, y);
        let matches = if red_dominant {
            r > 180 && g < 80 && b < 80
        } else {
            b > 180 && r < 80 && g < 80
        };
        if !matches {
            failures.push(format!(
                "{name} at ({x},{y}): got ({r},{g},{b}), expected {} dominance",
                if red_dominant { "red" } else { "blue" }
            ));
        }
    };
    check_dominant("gradient drop shadow left edge", 212, 30, true);
    check_dominant("gradient drop shadow right edge", 247, 30, false);
    check_dominant("gradient inset shadow left edge", 262, 30, true);
    check_dominant("gradient inset shadow right edge", 297, 30, false);
    if !failures.is_empty() {
        let path = std::env::temp_dir().join("gpui_headless_primitives.png");
        image.save(&path).ok();
        panic!(
            "{}\n(image saved to {})",
            failures.join("\n"),
            path.display()
        );
    }
}

#[test]
fn smoothed_primitives_share_one_contour() {
    let mut renderer = WgpuHeadlessRenderer::new().expect("headless renderer");
    let image_tile = tile(
        &renderer,
        AtlasKey::Image(RenderImageParams {
            image_id: gpui::ImageId(2),
            frame_index: 0,
        }),
        (0..64).flat_map(|_| [0u8, 0, 255, 255]).collect(),
    );
    let target = Size {
        width: DevicePixels(360),
        height: DevicePixels(170),
    };
    let content_mask = mask(360.0, 170.0);
    let green: Hsla = gpui::rgb_to_hsla(gpui::rgb(0x19d36b));
    let white: Hsla = gpui::rgb_to_hsla(gpui::rgb(0xffffff));
    let blue: Hsla = gpui::rgb_to_hsla(gpui::rgb(0x287cff));
    let black: Hsla = gpui::rgb_to_hsla(gpui::rgb(0x000000));
    let radii = Corners::all(ScaledPixels(18.0));

    let mut scene = Scene::default();

    let fill_bounds = bounds(10.0, 10.0, 50.0, 50.0);
    scene.insert_primitive(Quad {
        bounds: fill_bounds,
        content_mask,
        background: solid_background(green),
        corner_radii: radii,
        corner_smoothing: 1.0,
        ..Default::default()
    });

    let border_bounds = bounds(72.0, 10.0, 50.0, 50.0);
    scene.insert_primitive(Quad {
        bounds: border_bounds,
        content_mask,
        border_color: white.into(),
        border_widths: Edges {
            top: ScaledPixels(2.0),
            right: ScaledPixels(5.0),
            bottom: ScaledPixels(8.0),
            left: ScaledPixels(3.0),
        },
        corner_radii: radii,
        corner_smoothing: 0.6,
        ..Default::default()
    });

    let dashed_bounds = bounds(134.0, 10.0, 58.0, 50.0);
    scene.insert_primitive(Quad {
        bounds: dashed_bounds,
        content_mask,
        border_style: BorderStyle::Dashed,
        border_color: white.into(),
        border_widths: Edges::all(ScaledPixels(3.0)),
        corner_radii: Corners {
            top_left: ScaledPixels(20.0),
            top_right: ScaledPixels(8.0),
            bottom_right: ScaledPixels(16.0),
            bottom_left: ScaledPixels(3.0),
        },
        corner_smoothing: 1.0,
        ..Default::default()
    });

    let image_bounds = bounds(204.0, 10.0, 50.0, 50.0);
    scene.insert_primitive(PolychromeSprite {
        order: 0,
        grayscale: ShaderBool::Disabled,
        opacity: 1.0,
        corner_smoothing: 1.0,
        bounds: image_bounds,
        content_mask,
        corner_radii: radii,
        tile: image_tile,
    });

    let drop_element = bounds(20.0, 96.0, 50.0, 44.0);
    scene.insert_primitive(Shadow {
        order: 0,
        blur_radius: ScaledPixels(5.0),
        bounds: bounds(25.0, 101.0, 50.0, 44.0),
        corner_radii: Corners::all(ScaledPixels(15.0)),
        content_mask,
        color: blue.into(),
        element_bounds: drop_element,
        element_corner_radii: Corners::all(ScaledPixels(15.0)),
        inset: ShaderBool::Disabled,
        corner_smoothing: 0.6,
    });
    scene.insert_primitive(Quad {
        bounds: drop_element,
        content_mask,
        background: solid_background(green),
        corner_radii: Corners::all(ScaledPixels(15.0)),
        corner_smoothing: 0.6,
        ..Default::default()
    });

    let inset_bounds = bounds(100.0, 94.0, 50.0, 48.0);
    scene.insert_primitive(Quad {
        bounds: inset_bounds,
        content_mask,
        background: solid_background(green),
        corner_radii: Corners::all(ScaledPixels(16.0)),
        corner_smoothing: 1.0,
        ..Default::default()
    });
    scene.insert_primitive(Shadow {
        order: 0,
        blur_radius: ScaledPixels(4.0),
        bounds: bounds(104.0, 98.0, 42.0, 40.0),
        corner_radii: Corners::all(ScaledPixels(12.0)),
        content_mask,
        color: black.into(),
        element_bounds: inset_bounds,
        element_corner_radii: Corners::all(ScaledPixels(16.0)),
        inset: ShaderBool::Enabled,
        corner_smoothing: 1.0,
    });

    let filter_bounds = bounds(190.0, 92.0, 70.0, 52.0);
    scene.insert_primitive(Quad {
        bounds: filter_bounds,
        content_mask,
        background: checkerboard(white, 2.0),
        ..Default::default()
    });
    scene.insert_primitive(BackdropFilter {
        order: 0,
        bounds: filter_bounds,
        content_mask,
        corner_radii: Corners::all(ScaledPixels(18.0)),
        corner_smoothing: 1.0,
        filters: smallvec![ScaledFilter::Blur(ScaledPixels(5.0))],
        opacity: 1.0,
        geometry: None,
    });

    scene.finish();
    let image = renderer
        .render_scene_to_image(&scene, target)
        .expect("render must succeed");
    let mut unfiltered_scene = Scene::default();
    unfiltered_scene.insert_primitive(Quad {
        bounds: filter_bounds,
        content_mask,
        background: checkerboard(white, 2.0),
        ..Default::default()
    });
    unfiltered_scene.finish();
    let unfiltered = renderer
        .render_scene_to_image(&unfiltered_scene, target)
        .expect("reference render must succeed");
    let pixel = |x: u32, y: u32| image.get_pixel(x, y).0;
    let reference_pixel = |x: u32, y: u32| unfiltered.get_pixel(x, y).0;
    let is_black = |x, y| pixel(x, y)[0..3].iter().all(|channel| *channel <= 12);
    let is_white = |x, y| pixel(x, y)[0..3].iter().all(|channel| *channel >= 235);

    assert!(is_black(10, 10), "smoothed fill must exclude its corner");
    assert!(
        pixel(35, 10)[1] > 180,
        "fill shoulder must reach the top edge"
    );
    assert!(pixel(35, 35)[1] > 180, "fill center");

    assert!(is_white(96, 10), "thin top border");
    assert!(
        is_black(96, 14),
        "top border must not grow to the right width"
    );
    assert!(is_white(120, 35), "right border");
    assert!(is_black(115, 35), "right border interior boundary");
    assert!(is_white(96, 56), "thick bottom border");
    assert!(is_black(96, 50), "bottom border interior boundary");

    let dashed_pixels = (8..62)
        .flat_map(|y| (132..194).map(move |x| (x, y)))
        .filter(|&(x, y)| is_white(x, y))
        .count();
    assert!(
        (150..420).contains(&dashed_pixels),
        "dashed contour coverage: {dashed_pixels}"
    );
    assert!(is_black(163, 35), "dashed border interior");

    assert!(is_black(204, 10), "smoothed image must exclude its corner");
    assert!(
        pixel(229, 10)[0] > 220,
        "image shoulder must reach the top edge"
    );
    assert!(pixel(229, 35)[0] > 220, "image center");

    assert!(
        pixel(73, 132)[2] > 35,
        "drop shadow must extend beyond the element"
    );
    assert!(
        pixel(125, 96)[1] < pixel(125, 118)[1],
        "inset shadow must darken the edge"
    );
    assert!(
        pixel(125, 118)[1] > 120,
        "inset shadow must preserve the center"
    );

    let blurred_midtones = (192..258)
        .flat_map(|x| (94..142).map(move |y| pixel(x, y)[0]))
        .filter(|channel| (30..225).contains(channel))
        .count();
    assert!(
        blurred_midtones > 800,
        "backdrop blur did not composite: {blurred_midtones}"
    );
    assert!(
        pixel(190, 92)
            .iter()
            .zip(reference_pixel(190, 92))
            .all(|(&actual, expected)| actual.abs_diff(expected) <= 1),
        "the smoothed mask must exclude the backdrop corner"
    );
    assert!(
        pixel(225, 92)[0].abs_diff(reference_pixel(225, 92)[0]) > 20,
        "the smoothed mask must include the top shoulder"
    );

    if std::env::var_os("GPUI_SAVE_HEADLESS_TESTS").is_some() {
        image
            .save(std::env::temp_dir().join("gpui_smoothed_primitives.png"))
            .expect("save diagnostic image");
    }
}

#[test]
fn content_mask_fades_quad_edges() {
    let mut renderer = WgpuHeadlessRenderer::new().expect("headless renderer");
    let mut scene = Scene::default();
    let red: Hsla = gpui::rgb_to_hsla(gpui::rgb(0xff0000));
    scene.insert_primitive(Quad {
        order: 0,
        bounds: bounds(0.0, 0.0, 310.0, 100.0),
        content_mask: ContentMask {
            bounds: bounds(0.0, 0.0, 100.0, 100.0),
            fade_out: Edges {
                top: ScaledPixels(10.0),
                right: ScaledPixels(0.0),
                bottom: ScaledPixels(0.0),
                left: ScaledPixels(20.0),
            },
            space: 0,
            padding: 0,
        },
        background: solid_background(red),
        ..Default::default()
    });
    scene.finish();
    let image = renderer
        .render_scene_to_image(&scene, TARGET)
        .expect("render must succeed");
    let pixel = |x: u32, y: u32| image.get_pixel(x, y).0;
    let close = |x: u32, y: u32, red: u8| {
        let actual = pixel(x, y)[0];
        assert!(
            actual.abs_diff(red) <= 3,
            "at ({x},{y}) got {actual}, expected {red}"
        );
    };

    // Fully inside both fades.
    close(60, 50, 255);
    // The ramp is evaluated at pixel centers (x + 0.5), so 10.5px into the
    // 20px left fade is 52.5% coverage.
    close(10, 50, 134);
    // 2.5px into the 10px top fade is 25% coverage.
    close(60, 2, 64);
    // The unfaded right edge still clips hard at the mask boundary.
    assert_eq!(pixel(101, 50)[0], 0);
}

#[test]
fn nested_fades_multiply_without_moving_offscreen_anchors() {
    let mut renderer = WgpuHeadlessRenderer::new().expect("headless renderer");
    let mut scene = Scene::default();
    let faded = |left| ContentMask {
        bounds: bounds(left, 0., 100., 60.),
        fade_out: Edges {
            left: ScaledPixels(20.),
            ..Default::default()
        },
        ..Default::default()
    };
    scene.with_clip(faded(-10.), |scene| {
        scene.with_clip(faded(0.), |scene| {
            scene.insert_primitive(Quad {
                bounds: bounds(0., 0., 100., 60.),
                content_mask: full_mask(),
                background: solid_background(gpui::white()),
                ..Default::default()
            });
        });
    });
    scene.finish();
    let image = renderer.render_scene_to_image(&scene, TARGET).unwrap();
    for x in [0, 4, 9, 14, 19, 30] {
        let center = x as f32 + 0.5;
        let alpha = ((center + 10.) / 20.).clamp(0., 1.) * (center / 20.).clamp(0., 1.);
        let expected = (alpha * 255.).round() as u8;
        let actual = image.get_pixel(x, 30).0[0];
        assert!(
            actual.abs_diff(expected) <= 2,
            "x={x}: expected {expected}, got {actual}"
        );
    }
    assert_eq!(image.get_pixel(91, 30).0, [0, 0, 0, 255]);
}

#[test]
fn clip_distances_reconstruct_local_coordinates_under_large_sheared_reflection() {
    let mut renderer = WgpuHeadlessRenderer::new().expect("headless renderer");
    let mask_at = |x, y, width, height| ContentMask {
        bounds: bounds(x, y, width, height),
        ..Default::default()
    };
    let local_origin = 10_000.0;
    let local_y = 20_000.0;
    let center_x = local_origin + 12.0;
    let center_y = local_y + 8.0;
    // High shear with negative determinant: the mapping is intentionally far from
    // orthogonal, so an accidental axis-aligned or forward-only interpretation is visible.
    let transform = gpui::TransformationMatrix {
        rotation_scale: [[4.0, 3.8], [0.3, 0.2]],
        translation: [
            150.0 - (4.0 * center_x + 3.8 * center_y),
            50.0 - (0.3 * center_x + 0.2 * center_y),
        ],
    };
    let mut scene = Scene::default();
    scene.insert_primitive(Quad {
        bounds: bounds(0.0, 0.0, 310.0, 100.0),
        content_mask: full_mask(),
        background: solid_background(gpui::black()),
        ..Default::default()
    });
    scene.with_transform(transform, |scene| {
        scene.with_clip(
            mask_at(local_origin + 5.0, local_y + 4.0, 14.0, 8.0),
            |scene| {
                scene.insert_primitive(Quad {
                    // Keep the shape edge outside the mask, isolating exact clip coverage.
                    bounds: bounds(local_origin - 40.0, local_y - 40.0, 104.0, 96.0),
                    content_mask: mask_at(local_origin, local_y, 24.0, 16.0),
                    background: solid_background(gpui::white()),
                    ..Default::default()
                });
            },
        );
    });
    scene.finish();
    let image = renderer.render_scene_to_image(&scene, TARGET).unwrap();
    let inverse = transform.inverse().unwrap();
    let in_mask = |x: u32, y: u32, margin: f32| {
        let local = inverse.apply(gpui::point(
            gpui::Pixels::from(x as f32 + 0.5),
            gpui::Pixels::from(y as f32 + 0.5),
        ));
        f32::from(local.x) >= local_origin + 5.0 + margin
            && f32::from(local.x) <= local_origin + 19.0 - margin
            && f32::from(local.y) >= local_y + 4.0 + margin
            && f32::from(local.y) <= local_y + 12.0 - margin
    };
    let visual_bounds = transform.apply_bounds(
        mask_at(local_origin + 5.0, local_y + 4.0, 14.0, 8.0)
            .bounds
            .map(|p| gpui::px(p.0)),
    );
    let mut interior_count = 0;
    let mut phantom_count = 0;
    for y in 0..100 {
        for x in 0..310 {
            let window_point = gpui::point(gpui::px(x as f32 + 0.5), gpui::px(y as f32 + 0.5));
            if in_mask(x, y, 1.0) {
                assert_eq!(
                    image.get_pixel(x, y).0,
                    [255, 255, 255, 255],
                    "inside at {x},{y}"
                );
                interior_count += 1;
            } else if visual_bounds.contains(&window_point) && !in_mask(x, y, -1.0) {
                assert_eq!(
                    image.get_pixel(x, y).0,
                    [0, 0, 0, 255],
                    "outside at {x},{y}"
                );
                phantom_count += 1;
            }
        }
    }
    assert!(
        interior_count > 0,
        "the affine clip has interior pixel centers"
    );
    assert!(
        phantom_count > 0,
        "the affine clip excludes points inside its AABB"
    );
}
#[test]
fn content_filters_preserve_inherited_fades_without_multiplying_them_again() {
    let mut renderer = WgpuHeadlessRenderer::new().expect("headless renderer");
    let faded_mask = ContentMask {
        bounds: bounds(0., 0., 100., 60.),
        fade_out: Edges {
            left: ScaledPixels(20.),
            ..Default::default()
        },
        ..Default::default()
    };
    let camera = gpui::TransformationMatrix::unit()
        .translate(gpui::point(ScaledPixels(40.), ScaledPixels(10.)))
        .rotate(gpui::Radians(0.2))
        .scale(Size::new(2., 1.));
    for (transform, ancestor_fade) in [(gpui::TransformationMatrix::unit(), false), (camera, true)]
    {
        let mut scene = Scene::default();
        scene.insert_primitive(Quad {
            bounds: full_mask().bounds,
            content_mask: full_mask(),
            background: solid_background(gpui::black()),
            ..Default::default()
        });
        let paint_group = |scene: &mut Scene| {
            let content_mask = if ancestor_fade {
                full_mask()
            } else {
                faded_mask
            };
            let boundary = gpui::FilterBoundary {
                geometry: None,
                order: 0,
                bounds: faded_mask.bounds,
                content_mask,
                corner_radii: Corners::default(),
                corner_smoothing: 0.,
                filters: smallvec![ScaledFilter::Blur(ScaledPixels(0.25))],
                opacity: 1.,
                is_start: true,
            };
            scene.insert_primitive(boundary.clone());
            scene.insert_primitive(Quad {
                bounds: faded_mask.bounds,
                content_mask,
                background: solid_background(gpui::white()),
                ..Default::default()
            });
            scene.insert_primitive(gpui::FilterBoundary {
                is_start: false,
                ..boundary
            });
        };
        scene.with_transform(transform, |scene| {
            if ancestor_fade {
                scene.with_clip(faded_mask, paint_group);
            } else {
                paint_group(scene);
            }
        });
        scene.finish();
        let image = renderer.render_scene_to_image(&scene, TARGET).unwrap();
        for local_x in [5., 10., 15., 35.] {
            let window_point = transform.apply(gpui::point(gpui::px(local_x), gpui::px(25.)));
            let x = f32::from(window_point.x).floor() as u32;
            let y = f32::from(window_point.y).floor() as u32;
            let local = transform.inverse().unwrap().apply(gpui::point(
                gpui::px(x as f32 + 0.5),
                gpui::px(y as f32 + 0.5),
            ));
            let expected = ((f32::from(local.x) / 20.).clamp(0., 1.) * 255.).round() as u8;
            let actual = image.get_pixel(x, y).0[0];
            assert!(
                actual.abs_diff(expected) <= 6,
                "ancestor={ancestor_fade}, ({x},{y}): expected one fade {expected}, got {actual}"
            );
        }
    }
}

#[test]
fn rounded_quad_edges_stay_one_device_pixel_under_affine_zoom() {
    let mut renderer = WgpuHeadlessRenderer::new().expect("headless renderer");
    let transforms = [
        gpui::TransformationMatrix {
            rotation_scale: [[1.0, 0.0], [0.0, 1.0]],
            translation: [60.0, 30.0],
        },
        gpui::TransformationMatrix {
            rotation_scale: [[4.0, 0.0], [0.0, 4.0]],
            translation: [100.0, 2.0],
        },
        gpui::TransformationMatrix {
            rotation_scale: [[2.0, 0.5], [1.0, 0.5]],
            translation: [94.0, 44.25],
        },
        gpui::TransformationMatrix {
            rotation_scale: [[4.0, 3.8], [0.3, 0.2]],
            translation: [54.4, 47.6],
        },
        gpui::TransformationMatrix {
            rotation_scale: [[3.0, 1.4], [-0.3, 0.9]],
            translation: [56.0, 45.0],
        },
    ];

    for transform in transforms {
        let mut scene = Scene::default();
        scene.insert_primitive(Quad {
            bounds: bounds(0.0, 0.0, 310.0, 100.0),
            content_mask: full_mask(),
            background: solid_background(gpui::black()),
            ..Default::default()
        });
        scene.with_transform(transform, |scene| {
            scene.insert_primitive(Quad {
                bounds: bounds(0.0, 0.0, 24.0, 24.0),
                content_mask: full_mask(),
                background: solid_background(gpui::white()),
                corner_radii: gpui::Corners::all(ScaledPixels(6.0)),
                ..Default::default()
            });
        });
        scene.finish();
        let image = renderer.render_scene_to_image(&scene, TARGET).unwrap();
        let inverse = transform.inverse().unwrap();
        let distance_gradient = (inverse.rotation_scale[0][0] * inverse.rotation_scale[0][0]
            + inverse.rotation_scale[0][1] * inverse.rotation_scale[0][1])
            .sqrt();
        let mut compared = 0;
        for y in 0..100 {
            for x in 0..310 {
                let local = inverse.apply(gpui::point(
                    gpui::Pixels::from(x as f32 + 0.5),
                    gpui::Pixels::from(y as f32 + 0.5),
                ));
                let local_x = f32::from(local.x);
                let local_y = f32::from(local.y);
                // Away from rounded corners, the left edge's local SDF is exactly -x.
                if (8.0..16.0).contains(&local_y) && (0.01..1.0).contains(&local_x) {
                    let expected = (0.5 + local_x / distance_gradient).clamp(0.0, 1.0);
                    let pixel = image.get_pixel(x, y).0;
                    let actual = pixel[0] as f32 / 255.0;

                    assert!(
                        (actual - expected).abs() <= 0.025,
                        "matrix {:?}: pixel ({x},{y}) maps to local ({local_x:.3},{local_y:.3}), got {actual:.3}, expected {expected:.3}",
                        transform.rotation_scale,
                    );
                    compared += 1;
                }
            }
        }
        assert!(
            compared > 0,
            "matrix {:?} has edge sample pixels",
            transform.rotation_scale
        );
    }
}
