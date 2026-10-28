use gpui_canvas::{Color, ColorSpace, Error};

fn color(space: ColorSpace, c: [f32; 4]) -> Result<Color, Error> {
    match space {
        ColorSpace::Srgb => Color::srgb(c[0], c[1], c[2], c[3]),
        ColorSpace::LinearSrgb => Color::linear_srgb(c[0], c[1], c[2], c[3]),
        ColorSpace::DisplayP3 => Color::display_p3(c[0], c[1], c[2], c[3]),
        ColorSpace::LinearDisplayP3 => Color::linear_display_p3(c[0], c[1], c[2], c[3]),
        ColorSpace::Oklch => Color::oklch(c[0], c[1], c[2], c[3]),
    }
}
fn reference(a: Color, b: Color) -> bool {
    a.space() == b.space() && a.channels().map(f32::to_bits) == b.channels().map(f32::to_bits)
}

#[test]
fn exact_authoring_comparison_matches_observable_channel_bits_and_profile() {
    let mut seed = 7_u64;
    let mut next = || {
        seed = seed.wrapping_mul(6_364_136_223_846_793_005).wrapping_add(1);
        (seed >> 32) as u32
    };
    let mut samples = Vec::new();
    for space in [
        ColorSpace::Srgb,
        ColorSpace::LinearSrgb,
        ColorSpace::DisplayP3,
        ColorSpace::LinearDisplayP3,
        ColorSpace::Oklch,
    ] {
        for index in 0..64 {
            let mut c = [0.0; 4];
            for value in &mut c[..3] {
                *value = match index % 8 {
                    0 => 0.0,
                    1 => -0.0,
                    2 => f32::from_bits(1),
                    3 => -f32::from_bits(1),
                    4 => f32::MIN_POSITIVE,
                    _ => (next() as f64 / u32::MAX as f64 * 20.0 - 5.0) as f32,
                };
            }
            c[3] = if index % 4 == 0 {
                -0.0
            } else {
                (next() as f64 / u32::MAX as f64) as f32
            };
            if space == ColorSpace::Oklch {
                c[0] = c[0].abs().min(1.0);
                c[1] = c[1].abs();
                c[2] *= 1000.0;
            }
            let value = color(space, c).unwrap();
            // Re-author through the public constructor, including normalized
            // hue and each codec's alpha/sign/exponent reconstruction.
            let rebuilt = color(value.space(), value.channels()).unwrap();
            assert!(value.same_authoring(rebuilt));
            samples.push(value);
        }
    }
    for &a in &samples {
        for &b in &samples {
            assert_eq!(a.same_authoring(b), reference(a, b), "{a:?} {b:?}");
        }
    }
}

#[test]
fn numeric_equality_remains_distinct_from_exact_authoring() {
    let positive = Color::linear_srgb(0.0, 0.0, 0.0, 1.0).unwrap();
    let negative = Color::linear_srgb(-0.0, 0.0, 0.0, 1.0).unwrap();
    assert_eq!(positive, negative);
    assert!(!positive.same_authoring(negative));
    assert!(!positive.same_authoring(Color::srgb(0.0, 0.0, 0.0, 1.0).unwrap()));
    assert!(Color::rgb(0, 0, 0).same_authoring(Color::srgb(0.0, 0.0, 0.0, 1.0).unwrap()));
}
