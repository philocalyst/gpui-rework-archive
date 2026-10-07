//! Paths rendering contracts.
use super::*;

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
