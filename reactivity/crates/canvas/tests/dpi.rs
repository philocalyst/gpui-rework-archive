use gpui_canvas::{Affine, Canvas, Color, Error, Point, Rect, TextSystem};

#[test]
fn two_x_density_uses_real_physical_masks_and_matches_physical_font_rendering() {
    let mut fonts = TextSystem::bundled().unwrap();
    let logical = fonts.shape("Hi", 16.0, None).unwrap();
    let physical = fonts.shape("Hi", 32.0, None).unwrap();
    let clip = Rect::new(0.0, 0.0, 128.0, 80.0);
    let mut scaled = Canvas::new(128, 80).unwrap();
    scaled
        .draw_text_scaled(
            &mut fonts,
            &logical,
            Point { x: 2.0, y: 3.0 },
            Affine::scale(2.0, 2.0),
            clip,
            Color::BLACK,
            2.0,
        )
        .unwrap();
    let mut direct = Canvas::new(128, 80).unwrap();
    direct
        .draw_text(
            &mut fonts,
            &physical,
            Point { x: 4.0, y: 6.0 },
            Affine::IDENTITY,
            clip,
            Color::BLACK,
        )
        .unwrap();
    assert_eq!(scaled.pixels(), direct.pixels());
    let scene = scaled.prepared_scene();
    for draw in scene.draws() {
        let mask = draw.source.mask().unwrap();
        assert_eq!(mask.width as f32, draw.local_rect.width * 2.0);
        assert_eq!(mask.height as f32, draw.local_rect.height * 2.0);
    }
    // Scaling a 16px bitmap geometrically is observably different from sampling
    // the real 32px font mask. This guards against silently dropping raster_scale.
    let mut magnified = Canvas::new(128, 80).unwrap();
    magnified
        .draw_text(
            &mut fonts,
            &logical,
            Point { x: 2.0, y: 3.0 },
            Affine::scale(2.0, 2.0),
            clip,
            Color::BLACK,
        )
        .unwrap();
    assert_ne!(scaled.pixels(), magnified.pixels());
}

#[test]
fn density_one_preserves_existing_pixels_and_fractional_density_uses_physical_raster_keys() {
    let mut fonts = TextSystem::bundled().unwrap();
    let logical = fonts.shape("office", 16.0, None).unwrap();
    let clip = Rect::new(0.0, 0.0, 160.0, 60.0);
    let mut ordinary = Canvas::new(160, 60).unwrap();
    ordinary
        .draw_text(
            &mut fonts,
            &logical,
            Point { x: 2.3, y: 4.7 },
            Affine::IDENTITY,
            clip,
            Color::WHITE,
        )
        .unwrap();
    let mut scaled = Canvas::new(160, 60).unwrap();
    scaled
        .draw_text_scaled(
            &mut fonts,
            &logical,
            Point { x: 2.3, y: 4.7 },
            Affine::IDENTITY,
            clip,
            Color::WHITE,
            1.0,
        )
        .unwrap();
    assert_eq!(ordinary.pixels(), scaled.pixels());
    let old_keys: Vec<_> = ordinary
        .prepared_scene()
        .draws()
        .map(|d| d.source.mask().unwrap().key)
        .collect();
    scaled.clear(Color::TRANSPARENT);
    scaled
        .draw_text_scaled(
            &mut fonts,
            &logical,
            Point::default(),
            Affine::scale(1.25, 1.25),
            clip,
            Color::WHITE,
            1.25,
        )
        .unwrap();
    for (old, new) in old_keys.into_iter().zip(
        scaled
            .prepared_scene()
            .draws()
            .map(|d| d.source.mask().unwrap().key),
    ) {
        assert_ne!(old, new);
    }
    assert!(scaled.pixels().chunks_exact(4).any(|p| p[3] > 0));
}

#[test]
fn invalid_density_and_physical_font_size_reject_even_empty_layouts_atomically() {
    let mut fonts = TextSystem::bundled().unwrap();
    let empty = fonts.shape("", 16.0, None).unwrap();
    let mut canvas = Canvas::new(16, 16).unwrap();
    canvas.clear(Color::WHITE);
    let old = canvas.pixels().to_vec();
    let clip = Rect::new(0.0, 0.0, 16.0, 16.0);
    for scale in [0.0, -1.0, f32::NAN, f32::INFINITY] {
        assert_eq!(
            canvas.draw_text_scaled(
                &mut fonts,
                &empty,
                Point::default(),
                Affine::IDENTITY,
                clip,
                Color::BLACK,
                scale
            ),
            Err(Error::InvalidGeometry)
        );
    }
    for scale in [f32::MAX, 257.0] {
        assert_eq!(
            canvas.draw_text_scaled(
                &mut fonts,
                &empty,
                Point::default(),
                Affine::IDENTITY,
                clip,
                Color::BLACK,
                scale
            ),
            Err(Error::InvalidFontSize)
        );
    }
    let tiny = fonts.shape("", f32::MIN_POSITIVE, None).unwrap();
    assert_eq!(
        canvas.draw_text_scaled(
            &mut fonts,
            &tiny,
            Point::default(),
            Affine::IDENTITY,
            clip,
            Color::BLACK,
            f32::from_bits(1)
        ),
        Err(Error::InvalidFontSize)
    );
    assert_eq!(canvas.prepared_scene().draws().count(), 0);
    assert_eq!(canvas.pixels(), old);
}
