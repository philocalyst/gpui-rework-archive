use gpui_canvas::{
    Affine, Canvas, Color, ColorConfig, ColorSpace, Error, OutputProfile, PixelFormat, Rect,
    SdrMapping,
};
fn near(actual: f32, expected: f32) {
    assert!((actual - expected).abs() < 3e-6, "{actual} vs {expected}");
}

#[test]
fn primary_conversion_uses_d65_matrices_and_preserves_extended_channels() {
    let red = Color::display_p3(1.0, 0.0, 0.0, 1.0)
        .unwrap()
        .to_linear_srgb();
    near(red[0], 1.2249402);
    near(red[1], -0.042056955);
    near(red[2], -0.019637555);
    near(red[3], 1.0);
    let white = Color::display_p3(1.0, 1.0, 1.0, 0.25)
        .unwrap()
        .to_linear_srgb();
    for value in &white[..3] {
        near(*value, 1.0);
    }
    near(white[3], 0.25);
    let extended = Color::srgb(-0.5, 1.5, 0.0, 0.75).unwrap().to_linear_srgb();
    near(extended[0], -0.21404114);
    assert!(extended[1] > 2.0);
    near(extended[3], 0.75);
}

#[test]
fn all_profile_pairs_roundtrip_without_gamut_clipping() {
    let spaces = [
        ColorSpace::Srgb,
        ColorSpace::LinearSrgb,
        ColorSpace::DisplayP3,
        ColorSpace::LinearDisplayP3,
    ];
    let colors = [
        Color::srgb(0.2, 0.4, 0.8, 0.3).unwrap(),
        Color::linear_srgb(-0.1, 1.2, 0.4, 1.0).unwrap(),
        Color::display_p3(1.0, 0.0, 0.0, 0.9).unwrap(),
    ];
    for color in colors {
        for space in spaces {
            let round = color
                .convert(space)
                .unwrap()
                .convert(color.space())
                .unwrap();
            for (a, b) in round.channels().into_iter().zip(color.channels()) {
                near(a, b);
            }
        }
    }
}

#[test]
fn final_mapping_occurs_after_extended_linear_composition() {
    let mut canvas = Canvas::new(1, 1).unwrap();
    canvas.clear(Color::rgb(255, 0, 0));
    canvas
        .fill_rect(
            Rect::new(0.0, 0.0, 1.0, 1.0),
            Affine::IDENTITY,
            Rect::new(0.0, 0.0, 1.0, 1.0),
            Color::display_p3(0.0, 1.0, 0.0, 0.5).unwrap(),
        )
        .unwrap();
    let pixel = canvas.pixels();
    // Linear P3 green in sRGB is [-.22494018,1.04205695,-.07863605].
    // Its negative red contributes before final SDR clipping. Clamping the
    // source first would incorrectly produce sRGB red around 188 instead.
    assert!((pixel[0] as i16 - 167).abs() <= 1);
    assert!((pixel[1] as i16 - 191).abs() <= 1);
    assert_eq!(pixel[2], 0);
    assert_eq!(pixel[3], 255);
}

#[test]
fn p3_bytes_are_explicitly_profiled_and_hdr_requests_fail() {
    let config = ColorConfig {
        profile: OutputProfile::DisplayP3,
        ..ColorConfig::default()
    };
    let mut canvas = Canvas::with_color_config(1, 1, config).unwrap();
    canvas.clear(Color::display_p3(1.0, 0.0, 0.0, 1.0).unwrap());
    assert_eq!(canvas.pixels(), [255, 0, 0, 255]);
    assert_eq!(canvas.color_config(), config);
    canvas.clear(Color::WHITE);
    assert_eq!(canvas.pixels(), [255, 255, 255, 255]);
    assert!(matches!(
        Canvas::with_color_config(
            1,
            1,
            ColorConfig {
                format: PixelFormat::Rgba16Float,
                ..config
            }
        ),
        Err(Error::UnsupportedPixelFormat)
    ));
}

#[test]
fn tone_mapping_is_selected_not_implicit() {
    let color = Color::linear_srgb(4.0, 1.0, 0.25, 1.0).unwrap();
    let mut clipped = Canvas::new(1, 1).unwrap();
    clipped.clear(color);
    assert_eq!(clipped.pixels(), [255, 255, 137, 255]);
    let mut mapped = Canvas::with_color_config(
        1,
        1,
        ColorConfig {
            mapping: SdrMapping::ReinhardPerChannel { exposure: 1.0 },
            ..ColorConfig::default()
        },
    )
    .unwrap();
    mapped.clear(color);
    let pixel = mapped.pixels();
    assert!((pixel[0] as i16 - 231).abs() <= 1);
    assert!((pixel[1] as i16 - 188).abs() <= 1);
    assert!((pixel[2] as i16 - 124).abs() <= 1);
}

#[test]
fn invalid_color_values_and_configuration_are_rejected() {
    assert_eq!(
        Color::srgb(f32::NAN, 0.0, 0.0, 1.0),
        Err(Error::InvalidColor)
    );
    assert_eq!(
        Color::linear_srgb(0.0, 0.0, 0.0, 1.1),
        Err(Error::InvalidColor)
    );
    assert_eq!(
        Color::linear_srgb(0.0, 0.0, 0.0, -0.1),
        Err(Error::InvalidColor)
    );
    assert_eq!(
        Color::srgb(f32::MAX, 0.0, 0.0, 1.0),
        Err(Error::ColorOutOfRange)
    );
    assert_eq!(
        Color::BLACK.with_alpha(f32::INFINITY),
        Err(Error::InvalidColor)
    );
    assert!(matches!(
        Canvas::with_color_config(
            1,
            1,
            ColorConfig {
                mapping: SdrMapping::ReinhardPerChannel { exposure: 0.0 },
                ..ColorConfig::default()
            }
        ),
        Err(Error::InvalidColor)
    ));
}
