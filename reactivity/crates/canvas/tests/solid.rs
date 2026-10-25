use gpui_canvas::{
    Affine, Canvas, Color, ColorConfig, Error, OutputProfile, PixelFormat, Rect, SdrMapping,
};

#[test]
fn solid_certificate_uses_exact_output_quantizer_without_rendering_or_allocating() {
    for config in [
        ColorConfig::default(),
        ColorConfig {
            mapping: SdrMapping::ReinhardPerChannel { exposure: 1.75 },
            ..Default::default()
        },
    ] {
        for color in [
            Color::BLACK,
            Color::WHITE,
            Color::rgb(12, 34, 230),
            Color::linear_srgb(0.0001517635, 0.3, 2.0, 1.0).unwrap(),
            Color::display_p3(0.4, 0.7, 0.1, 1.0).unwrap(),
            Color::oklch(0.65, 0.15, 300.0, 1.0).unwrap(),
        ] {
            let mut canvas = Canvas::recording(23, 19, config).unwrap();
            canvas.clear(color);
            let mut word = None;
            let allocations = allocation_counter::measure(|| {
                word = canvas.prepared_scene().solid_bgrx().unwrap()
            });
            assert_eq!(allocations.count_total, 0, "{allocations:?}");
            let word = word.unwrap();
            assert_eq!(canvas.output_bytes(), 0);
            assert_eq!(canvas.stats().render_count, 0);
            let mut reference = vec![0; 23 * 19];
            canvas.render_bgrx(&mut reference).unwrap();
            assert!(reference.iter().all(|&pixel| pixel == word));
        }
    }
}

#[test]
fn unsupported_and_nonempty_scenes_use_normal_renderer() {
    for config in [
        ColorConfig {
            profile: OutputProfile::DisplayP3,
            ..Default::default()
        },
        ColorConfig {
            format: PixelFormat::Rgba16Float,
            ..Default::default()
        },
    ] {
        let mut canvas = Canvas::recording(16, 16, config).unwrap();
        canvas.clear(Color::WHITE);
        assert_eq!(canvas.prepared_scene().solid_bgrx(), Ok(None));
    }
    let mut canvas = Canvas::recording(16, 16, ColorConfig::default()).unwrap();
    canvas.clear(Color::rgba(255, 255, 255, 128));
    assert_eq!(canvas.prepared_scene().solid_bgrx(), Ok(None));
    canvas.clear(Color::BLACK);
    canvas
        .fill_rect(
            Rect::new(0.0, 0.0, 0.01, 0.01),
            Affine::IDENTITY,
            Rect::new(0.0, 0.0, 16.0, 16.0),
            Color::WHITE,
        )
        .unwrap();
    // No samples change, but the zero-command certificate stays conservative.
    assert_eq!(canvas.prepared_scene().solid_bgrx(), Ok(None));
    canvas.clear(Color::WHITE);
    assert_eq!(canvas.prepared_scene().solid_bgrx(), Ok(Some(0x00ff_ffff)));
}

#[test]
fn public_scene_metadata_edits_cannot_certify_invalid_content() {
    let mut canvas = Canvas::recording(16, 16, ColorConfig::default()).unwrap();
    canvas.clear(Color::WHITE);
    let scene = canvas.prepared_scene();
    let mut invalid = scene;
    invalid.width = 0;
    assert_eq!(invalid.solid_bgrx(), Err(Error::InvalidDimensions));
    invalid = scene;
    invalid.clear[0] = f32::NAN;
    assert_eq!(invalid.solid_bgrx(), Err(Error::InvalidColor));
    invalid = scene;
    invalid.clear[0] = 1e30;
    assert_eq!(invalid.solid_bgrx(), Err(Error::ColorOutOfRange));
    invalid = scene;
    invalid.color_config.reference_white_nits = 0.0;
    assert_eq!(invalid.solid_bgrx(), Err(Error::InvalidColor));
}
