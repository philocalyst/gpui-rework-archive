use gpui_canvas::{
    Color, ColorConfig, ColorSpace, Error, FloatRangePolicy, OutputProfile, OutputTransfer,
    PixelFormat, SdrMapping, oklch,
};
fn near(actual: f32, expected: f64, tolerance: f64) {
    assert!(
        (actual as f64 - expected).abs() < tolerance,
        "{actual} vs {expected}"
    );
}
// Independent direct-sRGB formula from Oklab's author (2021 matrix revision),
// rather than the implementation's CSS XYZ intermediate.
// https://bottosson.github.io/posts/oklab/#converting-from-linear-srgb-to-oklab
fn reference(l: f64, c: f64, h: f64) -> [f64; 3] {
    let a = c * h.to_radians().cos();
    let b = c * h.to_radians().sin();
    let x = (l + 0.3963377774 * a + 0.2158037573 * b).powi(3);
    let y = (l - 0.1055613458 * a - 0.0638541728 * b).powi(3);
    let z = (l - 0.0894841775 * a - 1.2914855480 * b).powi(3);
    [
        4.0767416621 * x - 3.3077115913 * y + 0.2309699292 * z,
        -1.2684380046 * x + 2.6097574011 * y - 0.3413193965 * z,
        -0.0041960863 * x - 0.7034186147 * y + 1.7076147010 * z,
    ]
}
#[test]
fn css_xyz_path_agrees_with_independent_published_direct_srgb_reference() {
    for l in [0.0_f32, 0.2, 0.5, 0.75, 1.0] {
        for c in [0.0_f32, 0.05, 0.2, 0.4, 2.0] {
            for h in [0.0_f32, 29.234, 90.0, 142.495, 180.0, 264.052, 359.0] {
                let actual = oklch(l, c, h).unwrap().to_linear_srgb();
                let expected = reference(l as f64, c as f64, h as f64);
                for i in 0..3 {
                    near(actual[i], expected[i], 2e-5 * (1.0 + expected[i].abs()));
                }
            }
        }
    }
}
#[test]
fn primaries_have_independent_reference_oklch_values_and_roundtrip() {
    // Author's forward direct-sRGB matrices, followed by cylindrical conversion.
    for (rgb, expected) in [
        ([1.0, 0.0, 0.0], [0.62795536, 0.25768331, 29.233885]),
        ([0.0, 1.0, 0.0], [0.86643961, 0.29482724, 142.495339]),
        ([0.0, 0.0, 1.0], [0.45201372, 0.31321437, 264.052021]),
    ] {
        let original = Color::linear_srgb(rgb[0], rgb[1], rgb[2], 0.375).unwrap();
        let converted = original.convert(ColorSpace::Oklch).unwrap();
        let v = converted.channels();
        near(v[0], expected[0], 2e-7);
        near(v[1], expected[1], 2e-7);
        near(v[2], expected[2], 2e-5);
        assert_eq!(v[3], 0.375);
        for (a, b) in converted.to_linear_srgb()[..3].iter().zip(rgb) {
            near(*a, b as f64, 8e-7);
        }
    }
}
#[test]
fn hue_alpha_extended_values_and_oklch_neutral_defaults() {
    let color = Color::oklch(0.65, 0.2, -30.0, 0.25).unwrap();
    assert_eq!(color.space(), ColorSpace::Oklch);
    assert_eq!(color.channels(), [0.65, 0.2, 330.0, 0.25]);
    assert_eq!(Color::oklch(0.65, 0.2, 1050.0, 0.25).unwrap(), color);
    assert_eq!(
        color.with_alpha(0.5).unwrap().channels(),
        [0.65, 0.2, 330.0, 0.5]
    );
    assert_eq!(oklch(0.2, 0.0, 360.0).unwrap().channels()[2], 0.0);
    assert_eq!(Color::WHITE.space(), ColorSpace::Oklch);
    assert_eq!(Color::WHITE.to_linear_srgb(), [1.0; 4]);
    assert_eq!(Color::BLACK.to_linear_srgb(), [0.0, 0.0, 0.0, 1.0]);
    assert_eq!(Color::default(), Color::TRANSPARENT);
    assert_eq!(
        oklch(0.5, 0.0, 125.0).unwrap().to_linear_srgb(),
        [0.125, 0.125, 0.125, 1.0]
    );
    assert!(
        oklch(0.6, 0.4, 140.0)
            .unwrap()
            .to_linear_srgb()
            .iter()
            .any(|v| *v < 0.0)
    );
    assert_eq!(
        Color::linear_srgb(-0.25, 4.0, 1.0, 0.5)
            .unwrap()
            .to_linear_srgb(),
        [-0.25, 4.0, 1.0, 0.5]
    );
}
#[test]
fn invalid_ranges_and_out_of_working_range_are_rejected() {
    for v in [
        [-0.01, 0.1, 0.0, 1.0],
        [1.01, 0.1, 0.0, 1.0],
        [0.5, -0.1, 0.0, 1.0],
        [0.5, 0.1, f32::NAN, 1.0],
        [0.5, 0.1, f32::INFINITY, 1.0],
        [0.5, 0.1, 0.0, 1.1],
    ] {
        assert_eq!(
            Color::oklch(v[0], v[1], v[2], v[3]),
            Err(Error::InvalidColor)
        );
    }
    assert_eq!(oklch(0.5, f32::MAX, 30.0), Err(Error::ColorOutOfRange));
    assert!((0.0..360.0).contains(&oklch(0.5, 0.1, f32::MAX).unwrap().channels()[2]));
    assert_eq!(
        Color::linear_srgb(4.0, 4.0, 4.0, 1.0)
            .unwrap()
            .convert(ColorSpace::Oklch),
        Err(Error::InvalidColor)
    );
}
#[test]
fn metadata_names_linear_p3_d65_reference_white_and_numeric_conversion() {
    let config = ColorConfig {
        profile: OutputProfile::DisplayP3,
        format: PixelFormat::Rgba16Float,
        reference_white_nits: 100.0,
        ..ColorConfig::default()
    };
    config.validate().unwrap();
    assert_eq!(config.bytes_per_pixel(), 8);
    let m = config.metadata();
    assert_eq!(m.transfer, OutputTransfer::Linear);
    assert_eq!(m.primaries_xy, [[0.68, 0.32], [0.265, 0.69], [0.15, 0.06]]);
    assert_eq!(m.white_point_xy, [0.3127, 0.3290]);
    assert_eq!(m.reference_white_nits, 100.0);
    assert_eq!(m.float_range, Some(FloatRangePolicy::FiniteSaturate));
    assert!(m.premultiplied_alpha);
    assert_eq!(m.sdr_mapping, None);
    assert_eq!(ColorConfig::default().reference_white_nits, 203.0);
    for value in [0.0, -1.0, f32::NAN, f32::INFINITY] {
        assert_eq!(
            ColorConfig {
                reference_white_nits: value,
                ..config
            }
            .validate(),
            Err(Error::InvalidColor)
        );
    }
    assert_eq!(
        ColorConfig {
            mapping: SdrMapping::ReinhardPerChannel { exposure: 1.0 },
            ..config
        }
        .validate(),
        Err(Error::InvalidColor)
    );
}
