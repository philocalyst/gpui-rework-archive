//! Production shader-paint integration tests through GPUI scenes and the WGPU renderer.
#![cfg(feature = "test-support")]

use gpui::{
    AppContext, BorderStyle, Bounds, ContentMask, Context, Corners, DevicePixels, Edges,
    HeadlessAppContext, IntoElement, ParentElement, PlatformHeadlessRenderer, Point, Quad, Render,
    ScaledPixels, Scene, ShaderProgram, ShaderQuad, ShaderShape, Size, Styled, Window, div,
    paint::PaintRoot,
    px,
    shader::{
        Paint, backdrop, color, reset_shader_cache_stats, rgba, shader, shader_cache_stats, vec2,
    },
    size, solid_background,
};
use gpui_ce_wgpu::{CosmicTextSystem, WgpuHeadlessRenderer};
use std::sync::Arc;

const TARGET: Size<DevicePixels> = Size {
    width: DevicePixels(128),
    height: DevicePixels(128),
};

fn bounds(x: f32, y: f32, width: f32, height: f32) -> Bounds<ScaledPixels> {
    Bounds {
        origin: Point {
            x: ScaledPixels(x),
            y: ScaledPixels(y),
        },
        size: Size {
            width: ScaledPixels(width),
            height: ScaledPixels(height),
        },
    }
}

fn full_mask() -> ContentMask<ScaledPixels> {
    ContentMask {
        bounds: bounds(0., 0., 128., 128.),
    }
}

fn render(renderer: &mut WgpuHeadlessRenderer, scene: Scene) -> image::RgbaImage {
    render_sized(renderer, scene, TARGET)
}

fn render_sized(
    renderer: &mut WgpuHeadlessRenderer,
    mut scene: Scene,
    target: Size<DevicePixels>,
) -> image::RgbaImage {
    let _ = env_logger::builder().is_test(true).try_init();
    scene.finish();
    renderer
        .render_scene_to_image(&scene, target)
        .expect("headless scene render")
}

fn assert_pixel_near(image: &image::RgbaImage, x: u32, y: u32, expected: [u8; 4], tolerance: u8) {
    let actual = image.get_pixel(x, y).0;
    assert!(
        actual
            .iter()
            .zip(expected)
            .all(|(actual, expected)| actual.abs_diff(expected) <= tolerance),
        "pixel ({x},{y}): got {actual:?}, expected {expected:?} ±{tolerance}"
    );
}

fn shader_shape(paint: Paint, geometry: Quad, shape: ShaderShape) -> ShaderQuad {
    ShaderQuad {
        order: 0,
        bounds: geometry.bounds,
        content_mask: geometry.content_mask,
        shader: ShaderProgram::Paint(paint.compile().expect("compile production paint")),
        opacity: 1.,
        scale_factor: 1.,
        geometry: Some((shape, geometry)),
    }
}

fn legacy_shader_quad(color: [f32; 4], shape: Bounds<ScaledPixels>) -> ShaderQuad {
    let shader = PaintRoot::new()
        .shader(|builder| builder.vec4(color))
        .expect("compile legacy shader");
    ShaderQuad {
        order: 0,
        bounds: shape,
        content_mask: full_mask(),
        shader: ShaderProgram::Legacy(shader),
        opacity: 1.,
        scale_factor: 1.,
        geometry: None,
    }
}

fn assert_images_near(left: &image::RgbaImage, right: &image::RgbaImage, tolerance: u8) {
    assert_eq!(left.dimensions(), right.dimensions());
    for (x, y, expected) in left.enumerate_pixels() {
        let actual = right.get_pixel(x, y);
        assert!(
            expected
                .0
                .iter()
                .zip(actual.0)
                .all(|(a, b)| a.abs_diff(b) <= tolerance),
            "pixel ({x},{y}): ordinary quad {:?}, shader paint {:?}",
            expected.0,
            actual.0,
        );
    }
}

#[test]
fn solid_background_paint_matches_ordinary_quad_including_gray_channels() {
    let mut renderer = WgpuHeadlessRenderer::new().expect("headless GPU");
    renderer.set_transparent(true);
    let gray = gpui::rgb(0x808080);
    let geometry = Quad {
        bounds: bounds(16., 20., 76., 68.),
        content_mask: full_mask(),
        background: solid_background(gray),
        border_color: gpui::transparent_black().into(),
        ..Default::default()
    };
    let mut ordinary = Scene::default();
    ordinary.insert_primitive(geometry);
    let ordinary = render(&mut renderer, ordinary);
    let mut procedural = Scene::default();
    procedural.insert_primitive(shader_shape(color(gray), geometry, ShaderShape::Background));
    let procedural = render(&mut renderer, procedural);
    assert_images_near(&ordinary, &procedural, 2);
    assert_pixel_near(&procedural, 32, 32, [128, 128, 128, 255], 2);
}

#[test]
fn fractional_background_edges_and_rounded_corners_match_quad_coverage() {
    let mut renderer = WgpuHeadlessRenderer::new().expect("headless GPU");
    renderer.set_transparent(true);
    let fill = gpui::rgb(0xb5864c);
    for (corner_radii, smoothing) in [
        (Corners::all(ScaledPixels(0.)), 0.0),
        (Corners::all(ScaledPixels(12.)), 0.0),
        (Corners::all(ScaledPixels(12.)), 0.75),
    ] {
        let geometry = Quad {
            bounds: bounds(12.25, 17.75, 93.5, 81.25),
            content_mask: ContentMask {
                bounds: bounds(14.5, 19.25, 88.5, 74.75),
            },
            background: solid_background(fill),
            border_color: gpui::transparent_black().into(),
            corner_radii,
            corner_smoothing: smoothing,
            ..Default::default()
        };
        let mut ordinary = Scene::default();
        ordinary.insert_primitive(geometry);
        let ordinary = render(&mut renderer, ordinary);
        let mut procedural = Scene::default();
        procedural.insert_primitive(shader_shape(color(fill), geometry, ShaderShape::Background));
        let procedural = render(&mut renderer, procedural);
        assert_images_near(&ordinary, &procedural, 2);
    }
}

#[test]
fn procedural_border_uses_exact_quad_coverage_for_smoothing_dashes_and_unequal_edges() {
    let mut renderer = WgpuHeadlessRenderer::new().expect("headless GPU");
    renderer.set_transparent(true);
    let border = gpui::rgb(0x48b8d0);
    for (style, smoothing) in [
        (BorderStyle::Solid, 0.0),
        (BorderStyle::Solid, 0.65),
        (BorderStyle::Dashed, 1.0),
    ] {
        let geometry = Quad {
            bounds: bounds(13.25, 19.5, 91.5, 74.25),
            content_mask: ContentMask {
                bounds: bounds(15.5, 18., 85.25, 68.75),
            },
            border_style: style,
            border_dashed_length: 3.5,
            border_dashed_gap: 1.7,
            border_color: border.into(),
            background: solid_background(gpui::transparent_black()),
            border_widths: Edges {
                top: ScaledPixels(2.5),
                right: ScaledPixels(6.0),
                bottom: ScaledPixels(8.25),
                left: ScaledPixels(3.75),
            },
            corner_radii: Corners {
                top_left: ScaledPixels(19.),
                top_right: ScaledPixels(6.),
                bottom_right: ScaledPixels(23.),
                bottom_left: ScaledPixels(11.),
            },
            corner_smoothing: smoothing,
            ..Default::default()
        };
        let mut ordinary = Scene::default();
        ordinary.insert_primitive(geometry);
        let ordinary = render(&mut renderer, ordinary);
        let mut procedural = Scene::default();
        procedural.insert_primitive(shader_shape(color(border), geometry, ShaderShape::Border));
        let procedural = render(&mut renderer, procedural);
        assert_images_near(&ordinary, &procedural, 2);
    }
}

#[test]
fn ordinary_quad_border_antialiasing_keeps_premultiplied_rgb_proportional_to_alpha() {
    let mut renderer = WgpuHeadlessRenderer::new().expect("headless GPU");
    renderer.set_transparent(true);
    let geometry = Quad {
        bounds: bounds(16.25, 16.25, 80.5, 80.5),
        content_mask: full_mask(),
        background: solid_background(gpui::transparent_black()),
        border_color: gpui::rgba(0xe85f87b3).into(),
        border_widths: Edges::all(ScaledPixels(8.)),
        corner_radii: Corners::all(ScaledPixels(15.)),
        ..Default::default()
    };
    let mut scene = Scene::default();
    scene.insert_primitive(geometry);
    let image = render(&mut renderer, scene);
    let mut partial_pixels = 0;
    for pixel in image.pixels() {
        let [r, g, b, a] = pixel.0;
        if (12..168).contains(&a) {
            partial_pixels += 1;
            for (channel, tint) in [(r, 0xe8u8), (g, 0x5f), (b, 0x87)] {
                let expected = (tint as f32 * a as f32 / 255.0).round() as u8;
                assert!(
                    channel.abs_diff(expected) <= 3,
                    "partially covered border: premultiplied channel {channel}, expected {expected}, alpha {a}"
                );
            }
        }
    }
    assert!(
        partial_pixels > 10,
        "fixture must exercise antialiased coverage"
    );
}

#[test]
fn ordinary_quad_translucent_fill_and_border_use_one_source_over_composition() {
    let mut renderer = WgpuHeadlessRenderer::new().expect("headless GPU");
    renderer.set_transparent(true);
    let geometry = Quad {
        bounds: bounds(16., 16., 80., 80.),
        content_mask: full_mask(),
        background: solid_background(gpui::rgba(0xff000080)),
        border_color: gpui::rgba(0x0000ff80).into(),
        border_widths: Edges::all(ScaledPixels(8.)),
        ..Default::default()
    };
    let mut scene = Scene::default();
    scene.insert_primitive(geometry);
    let image = render(&mut renderer, scene);
    assert_pixel_near(&image, 48, 48, [128, 0, 0, 128], 2);
    assert_pixel_near(&image, 20, 48, [64, 0, 128, 192], 2);
}

#[test]
fn narrow_border_with_large_corners_keeps_curved_pixels_outside_strip_depth() {
    let mut renderer = WgpuHeadlessRenderer::new().expect("headless GPU");
    renderer.set_transparent(true);
    let border = gpui::rgb(0xe85f87);
    for (smoothing, scale_factor) in [(0.0, 1.0), (0.85, 1.0), (0.85, 2.0)] {
        let geometry = Quad {
            bounds: bounds(4.25, 4.5, 119.5, 119.0),
            content_mask: ContentMask {
                bounds: bounds(5.5, 6.25, 117., 116.),
            },
            background: solid_background(gpui::transparent_black()),
            border_color: border.into(),
            border_widths: Edges::all(ScaledPixels(2.)),
            corner_radii: Corners::all(ScaledPixels(50.)),
            corner_smoothing: smoothing,
            ..Default::default()
        };
        let mut ordinary = Scene::default();
        ordinary.insert_primitive(geometry);
        let ordinary = render(&mut renderer, ordinary);
        let mut procedural = Scene::default();
        let mut painted = shader_shape(color(border), geometry, ShaderShape::Border);
        painted.scale_factor = scale_factor;
        procedural.insert_primitive(painted);
        let procedural = render(&mut renderer, procedural);
        assert_images_near(&ordinary, &procedural, 2);
    }
}

#[test]
fn legacy_and_production_paints_have_separate_pipeline_identities() {
    let mut renderer = WgpuHeadlessRenderer::new().expect("headless GPU");
    let mut scene = Scene::default();
    scene.insert_primitive(legacy_shader_quad(
        [1., 0., 0., 1.],
        bounds(8., 8., 48., 48.),
    ));
    let geometry = Quad {
        bounds: bounds(64., 8., 48., 48.),
        content_mask: full_mask(),
        ..Default::default()
    };
    scene.insert_primitive(shader_shape(
        color(gpui::rgb(0x0000ff)),
        geometry,
        ShaderShape::Background,
    ));
    let image = render(&mut renderer, scene);
    assert_pixel_near(&image, 24, 24, [255, 0, 0, 255], 2);
    assert_pixel_near(&image, 80, 24, [0, 0, 255, 255], 2);
    assert_eq!(renderer.paint_diagnostics().0, 2);
}

struct StyledPaintView;

impl Render for StyledPaintView {
    fn render(&mut self, _: &mut Window, _: &mut Context<Self>) -> impl IntoElement {
        div().relative().size_full().child(
            div()
                .absolute()
                .left(px(16.))
                .top(px(18.))
                .w(px(90.))
                .h(px(80.))
                .rounded(px(12.))
                .border_2()
                .bg(color(gpui::rgb(0x808080)))
                .border_color(color(gpui::rgb(0xff0000)))
                .child(
                    div()
                        .absolute()
                        .left(px(18.))
                        .top(px(18.))
                        .w(px(20.))
                        .h(px(20.))
                        .bg(gpui::rgb(0x0000ff)),
                ),
        )
    }
}

#[test]
fn real_style_background_child_and_border_paint_in_native_order() {
    let mut cx = HeadlessAppContext::with_platform(
        Arc::new(CosmicTextSystem::new("sans-serif")),
        Arc::new(()),
        || Some(Box::new(WgpuHeadlessRenderer::new().expect("headless GPU"))),
    );
    let window = cx
        .open_window(size(px(128.), px(128.)), |_, cx| {
            cx.new(|_| StyledPaintView)
        })
        .expect("open real headless window");
    let (shaders, quads) = cx
        .update_window(window.into(), |_, window, cx| {
            window.draw(cx).clear(cx);
            (window.painted_shader_quads(), window.painted_quads())
        })
        .expect("paint styled view");
    assert_eq!(shaders.len(), 2, "one background and one border paint");
    let background = shaders
        .iter()
        .find(|shader| matches!(shader.geometry, Some((ShaderShape::Background, _))))
        .expect("background shader");
    let border = shaders
        .iter()
        .find(|shader| matches!(shader.geometry, Some((ShaderShape::Border, _))))
        .expect("border shader");
    let child = quads
        .iter()
        .find(|quad| quad.background == solid_background(gpui::rgb(0x0000ff)))
        .expect("ordinary child quad");
    assert!(background.order < child.order && child.order < border.order);
    let (_, border_geometry) = border.geometry.expect("canonical border shape");
    assert_eq!(
        border_geometry.bounds,
        background.geometry.expect("canonical fill").1.bounds
    );
    assert_eq!(
        border_geometry.border_widths,
        Edges::all(ScaledPixels(2. * border.scale_factor))
    );
    assert_eq!(
        border_geometry.corner_radii,
        Corners::all(ScaledPixels(12. * border.scale_factor))
    );
    let image = cx
        .capture_screenshot(window.into())
        .expect("render styled view");
    let scale = border.scale_factor;
    let at = |x: f32, y: f32| ((x * scale) as u32, (y * scale) as u32);
    let (x, y) = at(60., 60.);
    assert_pixel_near(&image, x, y, [128, 128, 128, 255], 3);
    let (x, y) = at(40., 44.);
    assert_pixel_near(&image, x, y, [0, 0, 255, 255], 3);
    let (x, y) = at(17., 55.);
    assert_pixel_near(&image, x, y, [255, 0, 0, 255], 3);
}

struct CulledPaintView;

impl Render for CulledPaintView {
    fn render(&mut self, _: &mut Window, _: &mut Context<Self>) -> impl IntoElement {
        div()
            .relative()
            .size_full()
            .child(
                div()
                    .absolute()
                    .left(px(200.))
                    .top(px(12.))
                    .w(px(40.))
                    .h(px(40.))
                    .bg(animated_paint(0.1)),
            )
            .child(
                div()
                    .absolute()
                    .left(px(10.))
                    .top(px(10.))
                    .w(px(20.))
                    .h(px(20.))
                    .overflow_hidden()
                    .child(
                        div()
                            .absolute()
                            .left(px(30.))
                            .top(px(0.))
                            .w(px(16.))
                            .h(px(16.))
                            .bg(animated_paint(0.2)),
                    ),
            )
    }
}

#[test]
fn fully_culled_style_paints_do_not_compile() {
    reset_shader_cache_stats();
    let before = shader_cache_stats();
    let mut cx = HeadlessAppContext::with_platform(
        Arc::new(CosmicTextSystem::new("sans-serif")),
        Arc::new(()),
        || Some(Box::new(WgpuHeadlessRenderer::new().expect("headless GPU"))),
    );
    let window = cx
        .open_window(size(px(128.), px(128.)), |_, cx| {
            cx.new(|_| CulledPaintView)
        })
        .expect("open headless window");
    let shader_quads = cx
        .update_window(window.into(), |_, window, cx| {
            window.draw(cx).clear(cx);
            window.painted_shader_quads()
        })
        .expect("paint culled view");
    assert!(shader_quads.is_empty());
    let after = shader_cache_stats();
    assert_eq!(after.ir_lowerings, before.ir_lowerings);
    assert_eq!(after.program_cache_hits, before.program_cache_hits);
    assert_eq!(after.program_cache_misses, before.program_cache_misses);
}

fn animated_paint(phase: f32) -> Paint {
    shader(|pixel| {
        color([phase, 0.2, 0.4, 1.0]).mix(
            color([0.0, 0.0, 1.0, 1.0]),
            (pixel.uv().x() * 2.0 + phase).sin() * 0.25 + 0.25,
        )
    })
}

#[test]
fn fresh_reconstruction_reuses_compilation_and_one_gpu_pipeline() {
    reset_shader_cache_stats();
    let first = animated_paint(0.05).compile().expect("first paint compile");
    let warm_start = shader_cache_stats();
    let mut renderer = WgpuHeadlessRenderer::new().expect("headless GPU");
    let mut scene = Scene::default();
    for index in 0..32 {
        let paint = animated_paint(0.08 + index as f32 * 0.02);
        let compiled = paint.compile().expect("warm paint compile");
        assert_eq!(compiled.program_id(), first.program_id());
        assert_eq!(compiled.wgsl(), first.wgsl());
        assert_ne!(compiled.parameter_slots(), first.parameter_slots());
        scene.insert_primitive(shader_shape(
            paint,
            Quad {
                bounds: bounds((index % 8) as f32 * 16., (index / 8) as f32 * 16., 16., 16.),
                content_mask: full_mask(),
                ..Default::default()
            },
            ShaderShape::Background,
        ));
    }
    let image = render(&mut renderer, scene);
    assert!(image.get_pixel(8, 8).0[3] > 0);
    let stats = shader_cache_stats();
    assert_eq!(stats.ir_lowerings, warm_start.ir_lowerings);
    assert_eq!(stats.wgsl_emissions, warm_start.wgsl_emissions);
    assert_eq!(stats.validations, warm_start.validations);
    assert!(
        stats.program_cache_hits >= warm_start.program_cache_hits + 32,
        "warm start {warm_start:?}, end {stats:?}"
    );
    assert_eq!(renderer.paint_diagnostics().1, 1);
    assert_eq!(renderer.backdrop_capture_count(), 0);
}

#[test]
fn transparent_target_ordinary_quads_use_source_over_alpha() {
    let mut renderer = WgpuHeadlessRenderer::new().expect("headless GPU");
    renderer.set_transparent(true);
    let mut scene = Scene::default();
    for color in [gpui::rgba(0xff000080), gpui::rgba(0x0000ff80)] {
        scene.insert_primitive(Quad {
            bounds: bounds(16., 16., 64., 64.),
            content_mask: full_mask(),
            background: solid_background(color),
            ..Default::default()
        });
    }
    let image = render(&mut renderer, scene);
    assert_pixel_near(&image, 4, 4, [0, 0, 0, 0], 1);
    // The readback target stores premultiplied RGB. Blue-over-red with two
    // 128/255 alpha layers yields roughly (64, 0, 128, 192), independently
    // of any shader-paint builder or scene sampler.
    assert_pixel_near(&image, 48, 48, [64, 0, 128, 192], 2);
}

#[test]
fn transparent_target_production_paints_match_two_quad_source_over() {
    let mut renderer = WgpuHeadlessRenderer::new().expect("headless GPU");
    renderer.set_transparent(true);
    let geometry = Quad {
        bounds: bounds(16., 16., 64., 64.),
        content_mask: full_mask(),
        ..Default::default()
    };
    let mut ordinary = Scene::default();
    for tint in [gpui::rgba(0xff000080), gpui::rgba(0x0000ff80)] {
        ordinary.insert_primitive(Quad {
            background: solid_background(tint),
            ..geometry
        });
    }
    let ordinary = render(&mut renderer, ordinary);
    let mut procedural = Scene::default();
    for tint in [gpui::rgba(0xff000080), gpui::rgba(0x0000ff80)] {
        procedural.insert_primitive(shader_shape(color(tint), geometry, ShaderShape::Background));
    }
    let procedural = render(&mut renderer, procedural);
    assert_images_near(&ordinary, &procedural, 2);
    assert_pixel_near(&procedural, 48, 48, [64, 0, 128, 192], 2);
}

#[test]
fn production_over_opacity_and_mask_preserve_premultiplied_alpha() {
    let mut renderer = WgpuHeadlessRenderer::new().expect("headless GPU");
    renderer.set_transparent(true);
    let recipe = color([1.0, 0.0, 0.0, 0.5])
        .over(color([0.0, 0.0, 1.0, 0.5]))
        .opacity(0.6)
        .mask(0.5);
    let mut scene = Scene::default();
    scene.insert_primitive(shader_shape(
        recipe,
        Quad {
            bounds: bounds(16., 16., 64., 64.),
            content_mask: full_mask(),
            ..Default::default()
        },
        ShaderShape::Background,
    ));
    let image = render(&mut renderer, scene);
    // Premult source-over first: red .5, blue .25, alpha .75. Multiplying
    // opacity .6 and coverage .5 gives (.15, 0, .075, .225).
    assert_pixel_near(&image, 48, 48, [38, 0, 19, 57], 2);
    assert_pixel_near(&image, 4, 4, [0, 0, 0, 0], 1);
}

#[test]
fn inherited_opacity_and_fractional_geometry_cover_composed_paint_once() {
    let mut renderer = WgpuHeadlessRenderer::new().expect("headless GPU");
    renderer.set_transparent(true);
    let geometry = Quad {
        bounds: bounds(16.25, 16.75, 80.5, 79.5),
        content_mask: full_mask(),
        background: solid_background(gpui::rgb(0xff0000)),
        border_color: gpui::transparent_black().into(),
        corner_radii: Corners::all(ScaledPixels(17.)),
        corner_smoothing: 0.55,
        ..Default::default()
    };
    let mut coverage_scene = Scene::default();
    coverage_scene.insert_primitive(geometry);
    let reference = render(&mut renderer, coverage_scene);

    // Both opaque children compose to alpha one. The user mask, inherited
    // opacity, and destination coverage then multiply that result exactly once.
    let paint = color(gpui::rgb(0xff0000))
        .over(color(gpui::rgb(0x0000ff)))
        .mask(0.5);
    let mut painted = shader_shape(paint, geometry, ShaderShape::Background);
    painted.opacity = 0.6;
    let mut scene = Scene::default();
    scene.insert_primitive(painted);
    let actual = render(&mut renderer, scene);
    let mut fractional = 0;
    for (x, y, reference_pixel) in reference.enumerate_pixels() {
        let expected_alpha = (reference_pixel.0[3] as f32 * 0.3).round() as u8;
        let observed = actual.get_pixel(x, y).0;
        if (1..254).contains(&reference_pixel.0[3]) {
            fractional += 1;
        }
        assert!(
            observed[0].abs_diff(expected_alpha) <= 2
                && observed[1] <= 2
                && observed[2] <= 2
                && observed[3].abs_diff(expected_alpha) <= 2,
            "pixel ({x},{y}): got {observed:?}, expected red premult alpha {expected_alpha}"
        );
    }
    assert!(
        fractional > 10,
        "fixture must include fractional shape coverage"
    );
    assert_pixel_near(&actual, 56, 56, [77, 0, 0, 77], 2);
}

#[test]
fn fully_culled_direct_backdrop_paint_does_not_capture() {
    let mut renderer = WgpuHeadlessRenderer::new().expect("headless GPU");
    renderer.set_transparent(true);
    let mut scene = Scene::default();
    scene.insert_primitive(shader_shape(
        shader(|pixel| backdrop().sample(pixel.uv())),
        Quad {
            bounds: bounds(180., 180., 32., 32.),
            content_mask: full_mask(),
            ..Default::default()
        },
        ShaderShape::Background,
    ));
    let image = render(&mut renderer, scene);
    assert_pixel_near(&image, 64, 64, [0, 0, 0, 0], 1);
    assert_eq!(renderer.backdrop_capture_count(), 0);
    assert_eq!(renderer.backdrop_copied_pixels(), 0);
}

#[test]
fn nested_isolated_backdrop_reads_inner_target_not_outer_or_parent() {
    use gpui::{FilterBoundary, ScaledFilter};
    use smallvec::smallvec;

    let mut renderer = WgpuHeadlessRenderer::new().expect("headless GPU");
    let mut scene = Scene::default();
    scene.insert_primitive(Quad {
        bounds: bounds(0., 0., 128., 128.),
        content_mask: full_mask(),
        background: solid_background(gpui::rgb(0xff0000)),
        ..Default::default()
    });
    scene.insert_primitive(shader_shape(
        identity_backdrop(),
        Quad {
            bounds: bounds(0., 0., 8., 8.),
            content_mask: full_mask(),
            ..Default::default()
        },
        ShaderShape::Background,
    ));
    let boundary = |region: Bounds<ScaledPixels>, is_start| FilterBoundary {
        order: 0,
        bounds: region,
        content_mask: full_mask(),
        corner_radii: Default::default(),
        corner_smoothing: 0.,
        filters: smallvec![ScaledFilter::Blur(ScaledPixels(2.))],
        opacity: 1.,
        is_start,
    };
    let outer = bounds(16., 16., 96., 96.);
    let inner = bounds(32., 32., 64., 64.);
    scene.insert_primitive(boundary(outer, true));
    scene.insert_primitive(Quad {
        bounds: outer,
        content_mask: full_mask(),
        background: solid_background(gpui::rgb(0x00ff00)),
        ..Default::default()
    });
    scene.insert_primitive(boundary(inner, true));
    scene.insert_primitive(Quad {
        bounds: bounds(32., 32., 32., 64.),
        content_mask: full_mask(),
        background: solid_background(gpui::rgb(0x0000ff)),
        ..Default::default()
    });
    scene.insert_primitive(shader_shape(
        shader(|pixel| {
            let sampled_alpha = backdrop().sample(pixel.uv()).alpha();
            let inverse_alpha = 1.0 - &sampled_alpha;
            rgba(sampled_alpha, 0.0, inverse_alpha, 1.0)
        }),
        Quad {
            bounds: inner,
            content_mask: full_mask(),
            ..Default::default()
        },
        ShaderShape::Background,
    ));
    scene.insert_primitive(boundary(inner, false));
    scene.insert_primitive(boundary(outer, false));
    scene.insert_primitive(shader_shape(
        shader(|pixel| {
            let red = backdrop().sample(pixel.uv()).red();
            let blue = 1.0 - &red;
            rgba(0.0, red, blue, 1.0)
        }),
        Quad {
            bounds: bounds(112., 48., 16., 16.),
            content_mask: full_mask(),
            ..Default::default()
        },
        ShaderShape::Background,
    ));
    let image = render(&mut renderer, scene);
    assert_pixel_near(&image, 8, 64, [255, 0, 0, 255], 2);
    assert_pixel_near(&image, 24, 64, [0, 255, 0, 255], 2);
    assert_pixel_near(&image, 48, 64, [255, 0, 0, 255], 2);
    assert_pixel_near(&image, 80, 64, [0, 0, 255, 255], 2);
    assert_pixel_near(&image, 120, 56, [0, 255, 0, 255], 2);
    assert_eq!(renderer.backdrop_capture_count(), 3);
    assert_eq!(renderer.backdrop_copied_pixels(), 3 * 128 * 128);
}

#[test]
fn channel_reads_handle_tiny_positive_and_zero_alpha() {
    let mut renderer = WgpuHeadlessRenderer::new().expect("headless GPU");
    let tiny = shader(|_| {
        let source = rgba(1.0, 0.0, 0.0, 5.0e-9);
        let channels = source.rgb();
        rgba(channels.x(), channels.y(), channels.z(), 1.0)
    });
    let zero = shader(|_| {
        let source = rgba(1.0, 0.0, 0.0, 0.0);
        let channels = source.rgb();
        rgba(channels.x(), channels.y(), channels.z(), 1.0)
    });
    let mut scene = Scene::default();
    for (x, paint) in [(16., tiny), (72., zero)] {
        scene.insert_primitive(shader_shape(
            paint,
            Quad {
                bounds: bounds(x, 16., 40., 40.),
                content_mask: full_mask(),
                ..Default::default()
            },
            ShaderShape::Background,
        ));
    }
    let image = render(&mut renderer, scene);
    assert_pixel_near(&image, 32, 32, [255, 0, 0, 255], 2);
    assert_pixel_near(&image, 88, 32, [0, 0, 0, 255], 2);
}

fn identity_backdrop() -> Paint {
    shader(|pixel| backdrop().sample(pixel.uv()))
}

#[test]
fn incremental_snapshot_keeps_fractional_paint_outside_next_glass_bounds() {
    let mut renderer = WgpuHeadlessRenderer::new().expect("headless GPU");
    renderer.set_transparent(true);
    let source = Quad {
        bounds: bounds(16.25, 20.25, 32.5, 32.5),
        content_mask: ContentMask {
            bounds: bounds(16.5, 20.5, 31.75, 31.75),
        },
        corner_radii: Corners::all(ScaledPixels(8.)),
        corner_smoothing: 0.6,
        ..Default::default()
    };
    let mut reference_scene = Scene::default();
    reference_scene.insert_primitive(shader_shape(
        color(gpui::rgb(0xff0000)),
        source,
        ShaderShape::Background,
    ));
    let reference = render(&mut renderer, reference_scene);
    let (sample_x, sample_y, expected) = reference
        .enumerate_pixels()
        .find(|(_, _, pixel)| (32..224).contains(&pixel.0[3]))
        .map(|(x, y, pixel)| (x, y, pixel.0))
        .expect("rounded fractional source must have antialiased pixels");

    let before = renderer.backdrop_copied_pixels();
    let mut scene = Scene::default();
    // First capture initializes the full snapshot. This transparent sample and
    // the following pure Paint share one 33×33 prepared scissor.
    scene.insert_primitive(shader_shape(
        identity_backdrop(),
        source,
        ShaderShape::Background,
    ));
    scene.insert_primitive(shader_shape(
        color(gpui::rgb(0xff0000)),
        source,
        ShaderShape::Background,
    ));
    let dx = (sample_x as f32 - 96.0) / 32.0;
    let dy = (sample_y as f32 - 64.0) / 32.0;
    scene.insert_primitive(shader_shape(
        shader(|pixel| {
            let uv = pixel.uv();
            backdrop().sample(vec2(uv.x() + dx, uv.y() + dy))
        }),
        Quad {
            bounds: bounds(80., 48., 32., 32.),
            content_mask: full_mask(),
            ..Default::default()
        },
        ShaderShape::Background,
    ));
    let image = render(&mut renderer, scene);
    assert_pixel_near(&image, 96, 64, expected, 3);
    assert_eq!(renderer.backdrop_capture_count(), 2);
    assert_eq!(
        renderer.backdrop_copied_pixels() - before,
        128 * 128 + 33 * 33,
        "second capture must patch exactly the previous prepared scissor"
    );
}

#[test]
fn first_backdrop_capture_reinitializes_snapshot_after_each_frame_clear() {
    let mut renderer = WgpuHeadlessRenderer::new().expect("headless GPU");
    renderer.set_transparent(true);
    let probe = Quad {
        bounds: bounds(32., 32., 32., 32.),
        content_mask: full_mask(),
        ..Default::default()
    };
    let mut red_frame = Scene::default();
    red_frame.insert_primitive(Quad {
        bounds: bounds(0., 0., 128., 128.),
        content_mask: full_mask(),
        background: solid_background(gpui::rgb(0xff0000)),
        ..Default::default()
    });
    red_frame.insert_primitive(shader_shape(
        identity_backdrop(),
        probe,
        ShaderShape::Background,
    ));
    let first = render(&mut renderer, red_frame);
    assert_pixel_near(&first, 48, 48, [255, 0, 0, 255], 2);

    let mut clear_frame = Scene::default();
    clear_frame.insert_primitive(shader_shape(
        identity_backdrop(),
        probe,
        ShaderShape::Background,
    ));
    let second = render(&mut renderer, clear_frame);
    assert_pixel_near(&second, 48, 48, [0, 0, 0, 0], 1);
    assert_eq!(renderer.backdrop_capture_count(), 2);
    assert_eq!(renderer.backdrop_copied_pixels(), 2 * 128 * 128);
}

#[test]
fn ordinary_quad_between_backdrops_forces_full_refresh() {
    let mut renderer = WgpuHeadlessRenderer::new().expect("headless GPU");
    renderer.set_transparent(true);
    let mut scene = Scene::default();
    scene.insert_primitive(shader_shape(
        identity_backdrop(),
        Quad {
            bounds: bounds(0., 0., 8., 8.),
            content_mask: full_mask(),
            ..Default::default()
        },
        ShaderShape::Background,
    ));
    scene.insert_primitive(Quad {
        bounds: bounds(32., 32., 16., 16.),
        content_mask: full_mask(),
        background: solid_background(gpui::rgb(0x00ff00)),
        ..Default::default()
    });
    scene.insert_primitive(shader_shape(
        shader(|pixel| {
            let uv = pixel.uv();
            backdrop().sample(vec2(uv.x() - 1.75, uv.y() - 0.75))
        }),
        Quad {
            bounds: bounds(80., 48., 32., 32.),
            content_mask: full_mask(),
            ..Default::default()
        },
        ShaderShape::Background,
    ));
    let image = render(&mut renderer, scene);
    assert_pixel_near(&image, 96, 64, [0, 255, 0, 255], 2);
    assert_eq!(renderer.backdrop_capture_count(), 2);
    assert_eq!(renderer.backdrop_copied_pixels(), 2 * 128 * 128);
}

#[test]
fn legacy_shader_between_backdrops_is_included_in_next_snapshot() {
    let mut renderer = WgpuHeadlessRenderer::new().expect("headless GPU");
    renderer.set_transparent(true);
    let mut scene = Scene::default();
    scene.insert_primitive(shader_shape(
        identity_backdrop(),
        Quad {
            bounds: bounds(0., 0., 8., 8.),
            content_mask: full_mask(),
            ..Default::default()
        },
        ShaderShape::Background,
    ));
    scene.insert_primitive(legacy_shader_quad(
        [1., 0., 0., 1.],
        bounds(32., 32., 16., 16.),
    ));
    scene.insert_primitive(shader_shape(
        shader(|pixel| {
            let uv = pixel.uv();
            backdrop().sample(vec2(uv.x() - 1.75, uv.y() - 0.75))
        }),
        Quad {
            bounds: bounds(80., 48., 32., 32.),
            content_mask: full_mask(),
            ..Default::default()
        },
        ShaderShape::Background,
    ));
    let image = render(&mut renderer, scene);
    assert_pixel_near(&image, 96, 64, [255, 0, 0, 255], 2);
    assert_eq!(renderer.backdrop_capture_count(), 2);
    assert!(
        renderer.backdrop_copied_pixels() >= 128 * 128 + 16 * 16,
        "legacy draw must dirty at least its own visible scissor"
    );
}

#[test]
fn consecutive_backdrop_grid_copies_only_previous_cell_but_interleaved_quads_force_full() {
    let mut renderer = WgpuHeadlessRenderer::new().expect("headless GPU");
    let target = Size {
        width: DevicePixels(256),
        height: DevicePixels(256),
    };
    for interleaved in [false, true] {
        let mut scene = Scene::default();
        for i in 0..64 {
            let cell = bounds((i % 8) as f32 * 32., (i / 8) as f32 * 32., 32., 32.);
            if interleaved && i > 0 {
                scene.insert_primitive(Quad {
                    bounds: bounds((i % 8) as f32 * 32., (i / 8) as f32 * 32., 1., 1.),
                    content_mask: ContentMask { bounds: cell },
                    background: solid_background(gpui::rgb(0x223344)),
                    ..Default::default()
                });
            }
            scene.insert_primitive(shader_shape(
                identity_backdrop(),
                Quad {
                    bounds: cell,
                    content_mask: ContentMask { bounds: cell },
                    ..Default::default()
                },
                ShaderShape::Background,
            ));
        }
        let before_captures = renderer.backdrop_capture_count();
        let before_pixels = renderer.backdrop_copied_pixels();
        let image = render_sized(&mut renderer, scene, target);
        assert_eq!(image.dimensions(), (256, 256));
        assert_eq!(renderer.backdrop_capture_count() - before_captures, 64);
        assert_eq!(
            renderer.backdrop_copied_pixels() - before_pixels,
            if interleaved {
                64 * 256 * 256
            } else {
                256 * 256 + 63 * 32 * 32
            }
        );
    }
}

#[test]
fn backdrop_reads_observe_global_insertion_order_even_for_disjoint_bounds_and_layers() {
    for layered in [false, true] {
        let mut renderer = WgpuHeadlessRenderer::new().expect("headless GPU");
        renderer.set_transparent(true);
        let mut scene = Scene::default();
        if layered {
            scene.push_layer(bounds(0., 0., 128., 128.));
        }
        scene.insert_primitive(shader_shape(
            color(gpui::rgb(0x0000ff)),
            Quad {
                bounds: bounds(16., 16., 32., 32.),
                content_mask: full_mask(),
                ..Default::default()
            },
            ShaderShape::Background,
        ));
        scene.insert_primitive(shader_shape(
            shader(|pixel| {
                let uv = pixel.uv();
                backdrop().sample(vec2(uv.x() - 2.0, uv.y()))
            }),
            Quad {
                bounds: bounds(80., 16., 32., 32.),
                content_mask: full_mask(),
                ..Default::default()
            },
            ShaderShape::Background,
        ));
        scene.insert_primitive(shader_shape(
            shader(|pixel| {
                let uv = pixel.uv();
                backdrop().sample(vec2(uv.x() - 2.0, uv.y()))
            }),
            Quad {
                bounds: bounds(80., 64., 32., 32.),
                content_mask: full_mask(),
                ..Default::default()
            },
            ShaderShape::Background,
        ));
        scene.insert_primitive(Quad {
            bounds: bounds(16., 64., 32., 32.),
            content_mask: full_mask(),
            background: solid_background(gpui::rgb(0xff0000)),
            ..Default::default()
        });
        scene.insert_primitive(shader_shape(
            shader(|pixel| {
                let uv = pixel.uv();
                backdrop().sample(vec2(uv.x() - 1.0, uv.y()))
            }),
            Quad {
                bounds: bounds(48., 64., 32., 32.),
                content_mask: full_mask(),
                ..Default::default()
            },
            ShaderShape::Background,
        ));
        if layered {
            scene.pop_layer();
        }
        let image = render(&mut renderer, scene);
        assert_pixel_near(&image, 96, 32, [0, 0, 255, 255], 2);
        assert_pixel_near(&image, 96, 80, [0, 0, 0, 0], 1);
        assert_pixel_near(&image, 64, 80, [255, 0, 0, 255], 2);
        assert_eq!(renderer.backdrop_capture_count(), 3);
        assert_eq!(renderer.backdrop_copied_pixels(), 2 * 128 * 128 + 32 * 32);
    }
}

#[test]
fn backdrop_paint_samples_current_target_at_shifted_component_origin() {
    let mut renderer = WgpuHeadlessRenderer::new().expect("headless GPU");
    renderer.set_transparent(true);
    let geometry = Quad {
        bounds: bounds(24., 32., 64., 64.),
        content_mask: full_mask(),
        ..Default::default()
    };
    let mut scene = Scene::default();
    scene.insert_primitive(Quad {
        background: solid_background(gpui::rgba(0xff000080)),
        ..geometry
    });
    scene.insert_primitive(shader_shape(
        identity_backdrop(),
        geometry,
        ShaderShape::Background,
    ));
    let image = render(&mut renderer, scene);
    // Sampling a half-alpha red destination gives a half-alpha red source.
    // Source-over that destination yields premult red and alpha 0.75.
    assert_pixel_near(&image, 56, 64, [192, 0, 0, 192], 2);
    assert_pixel_near(&image, 12, 16, [0, 0, 0, 0], 1);
    assert_eq!(renderer.backdrop_capture_count(), 1);
}

#[test]
fn backdrop_border_uses_one_snapshot_for_all_four_sides() {
    let mut renderer = WgpuHeadlessRenderer::new().expect("headless GPU");
    let geometry = Quad {
        bounds: bounds(24., 24., 80., 80.),
        content_mask: full_mask(),
        border_widths: Edges::all(ScaledPixels(8.)),
        background: solid_background(gpui::transparent_black()),
        border_color: gpui::transparent_black().into(),
        ..Default::default()
    };
    let paint = shader(|pixel| {
        backdrop()
            .sample(vec2(pixel.uv().x(), 0.05))
            .mix(color(gpui::rgb(0xffffff)), 0.5)
    });
    let mut scene = Scene::default();
    scene.insert_primitive(Quad {
        bounds: geometry.bounds,
        content_mask: geometry.content_mask,
        background: solid_background(gpui::rgb(0x0000ff)),
        border_color: gpui::transparent_black().into(),
        ..Default::default()
    });
    scene.insert_primitive(shader_shape(paint, geometry, ShaderShape::Border));
    let image = render(&mut renderer, scene);
    // Every side samples the pre-border blue top edge. If later strips capture
    // the earlier painted top, the right-side result becomes (192,192,255).
    assert_pixel_near(&image, 60, 27, [128, 128, 255, 255], 2);
    assert_pixel_near(&image, 100, 64, [128, 128, 255, 255], 2);
    assert_pixel_near(&image, 64, 64, [0, 0, 255, 255], 2);
    assert_eq!(renderer.backdrop_capture_count(), 1);
}

#[test]
fn backdrop_bindings_follow_target_resize_without_stale_snapshots() {
    let mut renderer = WgpuHeadlessRenderer::new().expect("headless GPU");
    let paint = identity_backdrop();
    for (dimension, tint, expected) in [
        (128, gpui::rgb(0xff0000), [255, 0, 0, 255]),
        (64, gpui::rgb(0x0000ff), [0, 0, 255, 255]),
        (128, gpui::rgb(0x00ff00), [0, 255, 0, 255]),
    ] {
        let geometry = Quad {
            bounds: bounds(8., 8., 40., 40.),
            content_mask: ContentMask {
                bounds: bounds(0., 0., dimension as f32, dimension as f32),
            },
            ..Default::default()
        };
        let mut scene = Scene::default();
        scene.insert_primitive(Quad {
            background: solid_background(tint),
            ..geometry
        });
        scene.insert_primitive(shader_shape(
            paint.clone(),
            geometry,
            ShaderShape::Background,
        ));
        let image = render_sized(
            &mut renderer,
            scene,
            Size {
                width: DevicePixels(dimension),
                height: DevicePixels(dimension),
            },
        );
        assert_pixel_near(&image, 28, 28, expected, 2);
    }
    assert_eq!(renderer.backdrop_capture_count(), 3);
}

#[test]
fn mapped_uv_updates_local_position_and_nested_mappings() {
    let mut renderer = WgpuHeadlessRenderer::new().expect("headless GPU");
    let local_gradient =
        shader(|pixel| rgba(pixel.position().x() / pixel.size().x(), 0.0, 0.0, 1.0));
    let once = local_gradient.map_uv(|uv| vec2(uv.x() + 0.25, uv.y()));
    let twice = once.map_uv(|uv| vec2(uv.x() + 0.125, uv.y()));
    let mut scene = Scene::default();
    scene.insert_primitive(shader_shape(
        once,
        Quad {
            bounds: bounds(16., 16., 48., 48.),
            content_mask: full_mask(),
            ..Default::default()
        },
        ShaderShape::Background,
    ));
    scene.insert_primitive(shader_shape(
        twice,
        Quad {
            bounds: bounds(80., 16., 48., 48.),
            content_mask: full_mask(),
            ..Default::default()
        },
        ShaderShape::Background,
    ));
    let image = render(&mut renderer, scene);
    // Pixel centers are at x+0.5. Local x=12.5/48 in both boxes.
    let local = 12.5 / 48.0;
    assert_pixel_near(
        &image,
        28,
        40,
        [((local + 0.25) * 255.0) as u8, 0, 0, 255],
        2,
    );
    assert_pixel_near(
        &image,
        92,
        40,
        [((local + 0.375) * 255.0) as u8, 0, 0, 255],
        2,
    );
}

#[test]
fn typed_triangle_material_renders_antialiased_inside_and_outside() {
    let mut renderer = WgpuHeadlessRenderer::new().expect("headless GPU");
    renderer.set_transparent(true);
    let triangle = shader(|pixel| {
        let uv = pixel.uv();
        let slope = (uv.y() - 0.2) * 0.5;
        let left = uv.x() - (&slope + 0.2);
        let right = (0.8 - &slope) - uv.x();
        let top = uv.y() - 0.2;
        let edge = left.min(right).min(top);
        let width = edge.fwidth();
        color([0.9, 0.35, 0.1, 1.0]).mask(edge.smoothstep(-width.clone(), width))
    });
    let mut scene = Scene::default();
    scene.insert_primitive(shader_shape(
        triangle,
        Quad {
            bounds: bounds(16., 16., 96., 96.),
            content_mask: full_mask(),
            ..Default::default()
        },
        ShaderShape::Background,
    ));
    let image = render(&mut renderer, scene);
    assert_pixel_near(&image, 64, 64, [230, 89, 26, 255], 2);
    assert_pixel_near(&image, 28, 84, [0, 0, 0, 0], 2);
    assert!(image.pixels().any(|pixel| (1..=254).contains(&pixel.0[3])));
    image
        .save("/tmp/gpui-shader-triangle.png")
        .expect("save triangle proof");
}

#[test]
fn liquid_glass_material_refracts_actual_backdrop_through_rounded_style_geometry() {
    let mut renderer = WgpuHeadlessRenderer::new().expect("headless GPU");
    let mut scene = Scene::default();
    for (x, tint) in [(24., gpui::rgb(0xff0000)), (64., gpui::rgb(0x0000ff))] {
        scene.insert_primitive(Quad {
            bounds: bounds(x, 24., 40., 80.),
            content_mask: full_mask(),
            background: solid_background(tint),
            ..Default::default()
        });
    }
    let glass = shader(|pixel| {
        let uv = pixel.uv();
        let warp = (uv.y() * 12.0).sin() * 0.02 + 0.5;
        backdrop()
            .sample(vec2(uv.x() + warp, uv.y()))
            .mix(color(gpui::rgb(0xffffff)), 0.2)
            .opacity(0.75)
    });
    scene.insert_primitive(shader_shape(
        glass,
        Quad {
            bounds: bounds(24., 24., 80., 80.),
            content_mask: full_mask(),
            corner_radii: Corners::all(ScaledPixels(12.)),
            corner_smoothing: 0.5,
            ..Default::default()
        },
        ShaderShape::Background,
    ));
    let image = render(&mut renderer, scene);
    // At this left-half interior pixel, the refracted sample comes from the
    // opaque blue right half. A white 20% veil and 75% source opacity over
    // the red destination give (0.4, 0.15, 0.75), alpha one.
    assert_pixel_near(&image, 40, 64, [102, 38, 191, 255], 3);
    assert_eq!(renderer.backdrop_capture_count(), 1);
    image
        .save("/tmp/gpui-shader-liquid-glass.png")
        .expect("save glass proof");
}
