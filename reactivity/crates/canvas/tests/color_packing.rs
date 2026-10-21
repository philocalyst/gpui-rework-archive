//! Frozen 20-byte implementation is an independent conversion/admission oracle.
#[path = "support/legacy_color.rs"]
mod legacy;
use gpui_canvas::{Color, ColorSpace, Error};

const SPACES: [ColorSpace; 5] = [
    ColorSpace::Srgb,
    ColorSpace::LinearSrgb,
    ColorSpace::DisplayP3,
    ColorSpace::LinearDisplayP3,
    ColorSpace::Oklch,
];
fn current(c: [f32; 4], space: ColorSpace) -> Result<Color, Error> {
    match space {
        ColorSpace::Srgb => Color::srgb(c[0], c[1], c[2], c[3]),
        ColorSpace::LinearSrgb => Color::linear_srgb(c[0], c[1], c[2], c[3]),
        ColorSpace::DisplayP3 => Color::display_p3(c[0], c[1], c[2], c[3]),
        ColorSpace::LinearDisplayP3 => Color::linear_display_p3(c[0], c[1], c[2], c[3]),
        ColorSpace::Oklch => Color::oklch(c[0], c[1], c[2], c[3]),
    }
}
fn previous(c: [f32; 4], space: ColorSpace) -> Result<legacy::Color, Error> {
    match space {
        ColorSpace::Srgb => legacy::Color::srgb(c[0], c[1], c[2], c[3]),
        ColorSpace::LinearSrgb => legacy::Color::linear_srgb(c[0], c[1], c[2], c[3]),
        ColorSpace::DisplayP3 => legacy::Color::display_p3(c[0], c[1], c[2], c[3]),
        ColorSpace::LinearDisplayP3 => legacy::Color::linear_display_p3(c[0], c[1], c[2], c[3]),
        ColorSpace::Oklch => legacy::Color::oklch(c[0], c[1], c[2], c[3]),
    }
}
fn bits(c: [f32; 4]) -> [u32; 4] {
    c.map(f32::to_bits)
}
fn compare(c: [f32; 4], space: ColorSpace) {
    match (current(c, space), previous(c, space)) {
        (Ok(a), Ok(b)) => {
            assert_eq!(bits(a.channels()), bits(b.channels()), "{space:?} {c:?}");
            assert_eq!(a.space(), b.space());
            assert_eq!(a.alpha().to_bits(), b.alpha().to_bits());
            assert_eq!(
                bits(a.to_linear_srgb()),
                bits(b.to_linear_srgb()),
                "working {space:?} {c:?}"
            );
            assert_eq!(format!("{a:?}"), format!("{b:?}"));
            for target in SPACES {
                match (a.convert(target), b.convert(target)) {
                    (Ok(a), Ok(b)) => {
                        assert_eq!(
                            bits(a.channels()),
                            bits(b.channels()),
                            "convert {space:?}->{target:?}"
                        );
                        assert_eq!(bits(a.to_linear_srgb()), bits(b.to_linear_srgb()));
                    }
                    (Err(a), Err(b)) => assert_eq!(a, b),
                    mismatch => panic!("conversion mismatch {mismatch:?}"),
                }
            }
        }
        (Err(a), Err(b)) => assert_eq!(a, b),
        mismatch => panic!("admission mismatch {space:?} {c:?} {mismatch:?}"),
    }
}
#[test]
fn legacy_admission_channels_and_conversion_are_bit_exact() {
    let edge = [
        0.,
        -0.,
        f32::from_bits(1),
        -f32::from_bits(1),
        f32::MIN_POSITIVE,
        0.04045,
        0.5,
        1.,
        f32::from_bits(1f32.to_bits() + 1),
        -1.,
        1e8,
        -1e8,
        f32::from_bits(1e20f32.to_bits() - 1),
        1e20,
        f32::from_bits(1e20f32.to_bits() + 1),
        -1e20,
        f32::MAX,
        f32::INFINITY,
        f32::NAN,
    ];
    for space in SPACES {
        for x in edge {
            for alpha in [
                0.,
                -0.,
                f32::from_bits(1),
                0.5,
                1.,
                f32::from_bits(1f32.to_bits() + 1),
                f32::INFINITY,
                f32::NAN,
            ] {
                compare([x, x, x, alpha], space);
            }
        }
    }
    let mut rng = 0x48d7_6bcd_u32;
    for space in SPACES {
        for _ in 0..4096 {
            let mut next = || {
                rng ^= rng << 13;
                rng ^= rng >> 17;
                rng ^= rng << 5;
                rng
            };
            let mut c = [
                f32::from_bits(next()),
                f32::from_bits(next()),
                f32::from_bits(next()),
                f32::from_bits(next() % 0x3f80_0001),
            ];
            if space == ColorSpace::Oklch {
                c[0] = f32::from_bits(c[0].to_bits() % 0x3f80_0001);
                c[1] = c[1].abs();
            }
            compare(c, space);
        }
    }
}
#[test]
fn const_palette_alpha_and_float_equality_keep_their_contracts() {
    const C: Color = Color::rgba(17, 82, 240, 93);
    const CHANNELS: [f32; 4] = C.channels();
    const ALPHA: f32 = C.alpha();
    const SPACE: ColorSpace = C.space();
    assert_eq!(
        bits(CHANNELS),
        bits(legacy::Color::rgba(17, 82, 240, 93).channels())
    );
    assert_eq!(ALPHA.to_bits(), CHANNELS[3].to_bits());
    assert_eq!(SPACE, ColorSpace::Srgb);
    assert_ne!(Color::BLACK, Color::rgb(0, 0, 0));
    assert_eq!(size_of::<Option<Color>>(), 20);
    assert_eq!(size_of::<Option<legacy::Color>>(), 20);
    for (a, b) in [
        (Color::BLACK, legacy::Color::BLACK),
        (Color::WHITE, legacy::Color::WHITE),
        (Color::TRANSPARENT, legacy::Color::TRANSPARENT),
    ] {
        assert_eq!(bits(a.channels()), bits(b.channels()));
    }
    for space in SPACES {
        let positive = current([0., 0., 0., 0.], space).unwrap();
        let negative = current([-0., -0., -0., -0.], space).unwrap();
        assert_eq!(positive, negative);
        assert_eq!(negative.alpha().to_bits(), (-0f32).to_bits());
        assert_eq!(negative.with_alpha(0.25).unwrap().alpha(), 0.25);
        assert_eq!(
            negative.with_alpha(-0.).unwrap().alpha().to_bits(),
            (-0f32).to_bits()
        );
    }
}

#[test]
fn legacy_working_colors_produce_identical_cpu_pixels() {
    use gpui_canvas::{Affine, Canvas, ColorConfig, OutputProfile, Rect};
    for config in [
        ColorConfig::default(),
        ColorConfig {
            profile: OutputProfile::DisplayP3,
            ..ColorConfig::default()
        },
        ColorConfig::linear_hdr(OutputProfile::Srgb, 203.).unwrap(),
        ColorConfig::linear_hdr(OutputProfile::DisplayP3, 203.).unwrap(),
    ] {
        let mut actual = Canvas::with_color_config(17, 13, config).unwrap();
        let mut reference = Canvas::with_color_config(17, 13, config).unwrap();
        actual.clear(Color::rgb(64, 128, 192));
        reference.clear(Color::rgb(64, 128, 192));
        let clip = Rect::new(0.1, 0.2, 16.5, 12.6);
        for (i, space) in SPACES.into_iter().enumerate() {
            let channels = if space == ColorSpace::Oklch {
                [0.7, 0.15, 130., 0.7]
            } else {
                [-0.2, 1.3, 0.4, 0.7]
            };
            let authored = current(channels, space).unwrap();
            let old = previous(channels, space).unwrap().to_linear_srgb();
            let linear = Color::linear_srgb(old[0], old[1], old[2], old[3]).unwrap();
            let local = Rect::new(-0.5, 0.2, 7.6, 9.2);
            let map = Affine {
                a: 1.,
                b: 0.17,
                c: -0.13,
                d: 1.,
                tx: i as f32 * 2.1,
                ty: 0.3,
            };
            actual.fill_rect(local, map, clip, authored).unwrap();
            reference.fill_rect(local, map, clip, linear).unwrap();
        }
        assert_eq!(actual.pixels(), reference.pixels(), "{config:?}");
    }
}
