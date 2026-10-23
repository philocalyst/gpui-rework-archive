use gpui_canvas::{
    Affine, Canvas, Color, ColorConfig, Error, FloatRangePolicy, OutputProfile, OutputTransfer,
    PixelFormat, Point, Rect, TextSystem,
};

// Mathematical binary16 decoder independent of the production integer encoder.
fn decode_half(bytes: &[u8]) -> f64 {
    let bits = u16::from_le_bytes([bytes[0], bytes[1]]);
    assert_ne!(bits & 0x7c00, 0x7c00, "output must never contain inf/NaN");
    let e = ((bits >> 10) & 31) as i32;
    let f = (bits & 1023) as f64;
    let v = if e == 0 {
        f * 2_f64.powi(-24)
    } else {
        (1.0 + f / 1024.0) * 2_f64.powi(e - 15)
    };
    if bits & 0x8000 == 0 { v } else { -v }
}
fn pixel(bytes: &[u8]) -> [f64; 4] {
    std::array::from_fn(|i| decode_half(&bytes[2 * i..2 * i + 2]))
}
fn config(profile: OutputProfile) -> ColorConfig {
    ColorConfig::linear_hdr(profile, 203.0).unwrap()
}
fn fill(canvas: &mut Canvas, color: Color) {
    canvas
        .fill_rect(
            Rect::new(0.0, 0.0, canvas.width() as f32, canvas.height() as f32),
            Affine::IDENTITY,
            Rect::new(0.0, 0.0, canvas.width() as f32, canvas.height() as f32),
            color,
        )
        .unwrap();
}

#[test]
fn rgba16f_is_actual_eight_byte_linear_premultiplied_output() {
    let mut canvas = Canvas::with_color_config(3, 2, config(OutputProfile::Srgb)).unwrap();
    canvas.clear(Color::linear_srgb(-0.25, 4.0, 2.0, 0.5).unwrap());
    let bytes = canvas.pixels();
    assert_eq!(bytes.len(), 3 * 2 * 8);
    for bytes in bytes.as_chunks::<8>().0.iter() {
        assert_eq!(*bytes, [0, 0xb0, 0, 0x40, 0, 0x3c, 0, 0x38]);
        assert_eq!(pixel(bytes), [-0.125, 2.0, 1.0, 0.5]);
    }
    let metadata = canvas.color_config().metadata();
    assert_eq!(metadata.transfer, OutputTransfer::Linear);
    assert_eq!(metadata.float_range, Some(FloatRangePolicy::FiniteSaturate));
    assert_eq!(metadata.reference_white_nits, 203.0);
    assert_eq!(metadata.white_point_xy, [0.3127, 0.3290]);
}

#[test]
fn extended_values_compose_before_finite_storage_saturation() {
    let mut canvas = Canvas::with_color_config(1, 1, config(OutputProfile::Srgb)).unwrap();
    canvas.clear(Color::linear_srgb(-8.0, 2.0, 0.0, 1.0).unwrap());
    fill(
        &mut canvas,
        Color::linear_srgb(16.0, -2.0, 4.0, 0.5).unwrap(),
    );
    assert_eq!(pixel(canvas.pixels()), [4.0, 0.0, 2.0, 1.0]);
    // Both source colors exceed binary16 storage range, but cancellation occurs
    // before encoding. Saturating source colors would produce zero instead of1.
    canvas.clear(Color::linear_srgb(100000.0, -100000.0, 0.0, 1.0).unwrap());
    fill(
        &mut canvas,
        Color::linear_srgb(-99998.0, 99998.0, 0.0, 0.5).unwrap(),
    );
    assert_eq!(pixel(canvas.pixels()), [1.0, -1.0, 0.0, 1.0]);
    canvas.clear(Color::linear_srgb(-1e19, 1e19, 4.0, 0.5).unwrap());
    assert_eq!(pixel(canvas.pixels()), [-65504.0, 65504.0, 2.0, 0.5]);
}

#[test]
fn p3_primaries_remain_linear_and_reference_white_is_explicit_metadata() {
    let mut canvas = Canvas::with_color_config(1, 1, config(OutputProfile::DisplayP3)).unwrap();
    canvas.clear(Color::linear_display_p3(4.0, -0.5, 2.0, 0.25).unwrap());
    let expected = canvas.pixels().to_vec();
    assert_eq!(pixel(&expected), [1.0, -0.125, 0.5, 0.25]);
    assert_eq!(
        canvas.color_config().metadata().primaries_xy,
        [[0.68, 0.32], [0.265, 0.69], [0.15, 0.06]]
    );
    let mut different_scale = Canvas::with_color_config(
        1,
        1,
        ColorConfig::linear_hdr(OutputProfile::DisplayP3, 100.0).unwrap(),
    )
    .unwrap();
    different_scale.clear(Color::linear_display_p3(4.0, -0.5, 2.0, 0.25).unwrap());
    assert_eq!(different_scale.pixels(), expected);
    assert_eq!(
        different_scale
            .color_config()
            .metadata()
            .reference_white_nits,
        100.0
    );
}

#[test]
fn recording_allocates_eight_byte_pixels_lazily_and_staging_reuses_them() {
    let mut canvas = Canvas::recording(24, 17, config(OutputProfile::Srgb)).unwrap();
    canvas.clear(Color::linear_srgb(4.0, 1.0, 0.25, 1.0).unwrap());
    assert_eq!(canvas.output_bytes(), 0);
    assert_eq!(canvas.stats().render_count, 0);
    assert_eq!(canvas.prepared_scene().clear, [4.0, 1.0, 0.25, 1.0]);
    let first = canvas.try_pixels().unwrap().to_vec();
    let pointer = canvas.pixels().as_ptr();
    assert_eq!(first.len(), 24 * 17 * 8);
    assert!(canvas.output_bytes() >= 24 * 17 * 8);
    assert_eq!(canvas.stats().render_count, 1);
    {
        let mut candidate = canvas.stage();
        candidate.clear(Color::BLACK);
        assert_eq!(
            candidate.fill_rect(
                Rect::new(0.0, 0.0, 1.0, 1.0),
                Affine::scale(0.0, 1.0),
                Rect::new(0.0, 0.0, 24.0, 17.0),
                Color::WHITE
            ),
            Err(Error::InvalidGeometry)
        );
    }
    assert_eq!(canvas.pixels(), first);
    assert_eq!(canvas.pixels().as_ptr(), pointer);
    assert_eq!(canvas.stats().render_count, 1);
    let mut candidate = canvas.stage();
    candidate.clear(Color::linear_srgb(2.0, 0.0, 0.0, 1.0).unwrap());
    candidate.commit();
    assert_eq!(canvas.stats().render_count, 1);
    assert_eq!(canvas.pixels().as_ptr(), pointer);
    assert!(
        canvas
            .pixels()
            .as_chunks::<8>()
            .0
            .iter()
            .all(|p| pixel(p) == [2.0, 0.0, 0.0, 1.0])
    );
    assert_eq!(canvas.stats().render_count, 2);
}

#[test]
fn actual_font_coverage_is_encoded_as_extended_linear_half_pixels() {
    let mut canvas = Canvas::with_color_config(128, 64, config(OutputProfile::Srgb)).unwrap();
    let mut fonts = TextSystem::bundled().unwrap();
    let layout = fonts.shape("HDR", 36.0, None).unwrap();
    canvas
        .draw_text(
            &mut fonts,
            &layout,
            Point::default(),
            Affine::IDENTITY,
            Rect::new(0.0, 0.0, 128.0, 64.0),
            Color::linear_srgb(4.0, 0.25, -0.5, 0.75).unwrap(),
        )
        .unwrap();
    let mut covered = 0;
    let mut fractional = false;
    let mut hdr = false;
    for bytes in canvas.pixels().as_chunks::<8>().0.iter() {
        let [r, g, b, a] = pixel(bytes);
        if a > 0.0 {
            covered += 1;
            assert!((0.0..=0.75).contains(&a));
            assert!((r - 4.0 * a).abs() < 0.002);
            assert!((g - 0.25 * a).abs() < 0.0002);
            assert!((b + 0.5 * a).abs() < 0.0004);
            fractional |= a < 0.75;
            hdr |= r > 1.0;
        }
    }
    assert!(covered > 100 && fractional && hdr);
}

#[test]
fn byte_counts_and_checked_configuration_are_format_specific() {
    assert_eq!(ColorConfig::default().bytes_per_pixel(), 4);
    assert_eq!(config(OutputProfile::Srgb).bytes_per_pixel(), 8);
    assert_eq!(config(OutputProfile::Srgb).format, PixelFormat::Rgba16Float);
    assert_eq!(
        ColorConfig::linear_hdr(OutputProfile::Srgb, 0.0),
        Err(Error::InvalidColor)
    );
}
