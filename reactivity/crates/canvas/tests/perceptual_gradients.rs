#[path = "support/perceptual_oracle.rs"]
mod oracle;
const HDR: f32 = f32::from_bits(1e20_f32.to_bits() - 1);
use gpui_canvas::{
    Color, Extend, Gradient, GradientGeometry, GradientStop as Stop, HueInterpolation as Hue,
    Interpolation as Mode, Point,
};
fn try_make(left: Color, right: Color, mode: Mode) -> Result<Gradient, gpui_canvas::Error> {
    Gradient::new(
        GradientGeometry::Linear {
            start: Point { x: 0., y: 0. },
            end: Point { x: 1., y: 0. },
        },
        &[Stop::new(0., left), Stop::new(1., right)],
        Extend::Pad,
        mode,
    )
}
fn make(left: Color, right: Color, mode: Mode) -> Gradient {
    try_make(left, right, mode).unwrap()
}
fn modes() -> [Mode; 5] {
    [
        Mode::Oklab,
        Mode::Oklch { hue: Hue::Shorter },
        Mode::Oklch { hue: Hue::Longer },
        Mode::Oklch {
            hue: Hue::Increasing,
        },
        Mode::Oklch {
            hue: Hue::Decreasing,
        },
    ]
}
#[test]
fn authored_f64_oracle_covers_alpha_routes_hdr_p3_and_negative_lms() {
    let colors = [
        Color::linear_srgb(HDR, 0., 0., 1.).unwrap(),
        Color::linear_srgb(HDR, 0., 0., 1e-22).unwrap(),
        Color::linear_srgb(-HDR, HDR, -HDR, 2e-22).unwrap(),
        Color::linear_srgb(0., HDR, 0., 0.0001).unwrap(),
        Color::linear_srgb(-HDR, HDR, -HDR, 0.7).unwrap(),
        Color::linear_srgb(9., -1., 3., 0.).unwrap(),
        Color::linear_srgb(0.2, 0.2, 0.2, 1.).unwrap(),
        Color::linear_srgb(-0.2, -0.2, -0.2, f32::MIN_POSITIVE).unwrap(),
        Color::linear_display_p3(0.2, 4., -0.1, 0.5).unwrap(),
        Color::oklch(0.7, 0.2, 10., 0.25).unwrap(),
        Color::oklch(0.3, 0.1, 190., 0.75).unwrap(),
        Color::oklch(0.5, 0., 350., 1.).unwrap(),
        Color::oklch(0.5, 0.000004, 10., 0.5).unwrap(),
    ];
    let mut max_tolerance_fraction = 0.0_f64;
    let mut max_small_channel_error = 0.0_f64;
    for mode in modes() {
        let (mut admitted, mut rejected) = (0, 0);
        for left in colors {
            for right in colors {
                let g = match try_make(left, right, mode) {
                    Ok(g) => {
                        admitted += 1;
                        g
                    }
                    Err(gpui_canvas::Error::GradientPrecision) => {
                        rejected += 1;
                        continue;
                    }
                    Err(error) => panic!("unexpected admission error {error:?}"),
                };
                assert_eq!(g.view().interpolation(), mode);
                assert!(g.view().stop(0).unwrap().color.same_authoring(left));
                for t in [f32::from_bits(1), 0.00001, 0.125, 0.5, 0.875, 0.99999] {
                    let expected = oracle::interpolate(left, right, f64::from(t), mode);
                    let actual = g.view().sample_parameter(t).unwrap();
                    for c in 0..4 {
                        assert!(
                            actual[c].is_finite(),
                            "{mode:?} {left:?} {right:?} t={t} {actual:?}"
                        );
                        let tolerance = if c == 3 {
                            2e-7
                        } else {
                            0.00002 + 0.00002 * expected[c].abs()
                        };
                        let error = (f64::from(actual[c]) - expected[c]).abs();
                        max_tolerance_fraction = max_tolerance_fraction.max(error / tolerance);
                        if c != 3 && expected[c].abs() <= 0.001 {
                            max_small_channel_error = max_small_channel_error.max(error);
                        }
                        assert!(
                            error <= tolerance,
                            "{mode:?} {left:?} {right:?} t={t} channel={c} actual={} oracle={} error={error} tolerance={tolerance}",
                            actual[c],
                            expected[c]
                        );
                    }
                }
            }
        }
        eprintln!("perceptual_profile,{mode:?},admitted={admitted},rejected={rejected}");
        assert!(admitted >= 30, "ordinary colors must not all be rejected");
    }
    eprintln!(
        "perceptual_f64_oracle,max_tolerance_fraction={max_tolerance_fraction},max_small_channel_abs_error={max_small_channel_error}"
    );
}
#[test]
fn exact_endpoints_edges_alpha_admission_and_lossless_authors() {
    for mode in modes() {
        let left = Color::linear_srgb(-0., 0.75, -0.1, 0.25).unwrap();
        let right = Color::linear_display_p3(0.1, 0.4, -0.1, 0.75).unwrap();
        let g = make(left, right, mode);
        let premul = |c: Color| {
            let mut v = c.to_linear_srgb();
            for x in &mut v[..3] {
                *x *= c.alpha();
            }
            v
        };
        for t in [-f32::MAX, 0.] {
            assert_eq!(
                g.view().sample_parameter(t).unwrap().map(f32::to_bits),
                premul(left).map(f32::to_bits)
            );
        }
        for t in [1., f32::MAX] {
            assert_eq!(
                g.view().sample_parameter(t).unwrap().map(f32::to_bits),
                premul(right).map(f32::to_bits)
            );
        }
        assert_eq!(g.view().sample_parameter(0.5).unwrap()[3], 0.5);
        assert_eq!(g.view().byte_len(), 48 + 2 * 80);
        let stops = [
            Stop::new(0., left),
            Stop::new(0.5, left),
            Stop::new(0.5, right),
            Stop::new(1., right),
        ];
        let hard = Gradient::new(g.view().geometry(), &stops, Extend::Pad, mode).unwrap();
        assert_eq!(
            hard.view().sample_parameter(0.5).unwrap().map(f32::to_bits),
            premul(right).map(f32::to_bits)
        );
        let tiny = Color::linear_srgb(1., -0., 3., f32::from_bits(1)).unwrap();
        assert_eq!(
            Gradient::new(
                g.view().geometry(),
                &[Stop::new(0., tiny), Stop::new(1., right)],
                Extend::Pad,
                mode
            )
            .err(),
            Some(gpui_canvas::Error::InvalidGradient)
        );
        assert!(
            make(tiny, right, Mode::LinearSrgb)
                .view()
                .stop(0)
                .unwrap()
                .color
                .same_authoring(tiny)
        );
        let hidden = Color::linear_srgb(HDR, -HDR, 0., 0.).unwrap();
        assert!(!make(hidden, hidden, mode).view().has_visible_stop());
        assert_eq!(
            make(hidden, hidden, mode)
                .view()
                .sample_parameter(0.5)
                .unwrap(),
            [0.; 4]
        );
    }
    assert_eq!(Mode::default(), Mode::Oklch { hue: Hue::Shorter });
}

#[test]
fn fixed_coordinates_preserve_hdr_axis_channels_but_longer_still_rotates() {
    let color = Color::linear_srgb(HDR, 0., -0., 1.).unwrap();
    let gradient = make(color, color, Mode::Oklab);
    for t in [0.125, 0.5, 0.875] {
        let actual = gradient.view().sample_parameter(t).unwrap();
        assert_eq!(actual[1], 0.0);
        assert_eq!(actual[2], 0.0);
        assert_eq!(actual[0], HDR);
        assert_eq!(actual[3], 1.0);
    }
    let color = Color::oklch(0.6, 0.2, 30., 0.5).unwrap();
    let short = make(color, color, Mode::Oklch { hue: Hue::Shorter });
    let long = make(color, color, Mode::Oklch { hue: Hue::Longer });
    let a = short.view().sample_parameter(0.5).unwrap();
    let b = long.view().sample_parameter(0.5).unwrap();
    assert!((a[0] - b[0]).abs() > 0.1);
    let gray = Color::oklch(0.6, 0.000003, 10., 1.).unwrap();
    let longer = make(gray, gray, Mode::Oklch { hue: Hue::Longer });
    let shorter = make(gray, gray, Mode::Oklch { hue: Hue::Shorter });
    assert_eq!(
        longer.view().sample_parameter(0.5).unwrap(),
        shorter.view().sample_parameter(0.5).unwrap()
    );
}

#[test]
fn transparent_extreme_hdr_does_not_destroy_visible_polar_coordinates() {
    let left = Color::linear_srgb(HDR, 0., 0., 0.).unwrap();
    let right = Color::linear_srgb(0., 0., 1., 1.).unwrap();
    for mode in modes() {
        let gradient = make(left, right, mode);
        let expected = oracle::interpolate(left, right, 0.5, mode);
        let actual = gradient.view().sample_parameter(0.5).unwrap();
        for c in 0..4 {
            assert!(
                (f64::from(actual[c]) - expected[c]).abs() <= 0.00002 + expected[c].abs() * 0.00002,
                "{mode:?} channel={c} actual={actual:?} expected={expected:?}"
            );
        }
    }
}

#[test]
fn ill_conditioned_opaque_hdr_is_rejected_and_tiny_normal_alpha_hdr_is_admitted() {
    let red = Color::linear_srgb(HDR, 0., 0., 1.).unwrap();
    let green = Color::linear_srgb(0., HDR, 0., 0.0001).unwrap();
    for mode in modes() {
        assert_eq!(
            try_make(red, green, mode).err(),
            Some(gpui_canvas::Error::GradientPrecision)
        );
        let a = red.with_alpha(1e-22).unwrap();
        let b = green.with_alpha(2e-22).unwrap();
        let gradient = make(a, b, mode);
        for t in [0.00001, 0.125, 0.5, 0.875, 0.99999] {
            let actual = gradient.view().sample_parameter(t).unwrap();
            let expected = oracle::interpolate(a, b, f64::from(t), mode);
            for c in 0..4 {
                assert!(
                    (f64::from(actual[c]) - expected[c]).abs()
                        <= 0.00002 + expected[c].abs() * 0.00002
                );
            }
        }
        let gray = Color::linear_srgb(HDR, HDR, HDR, 0.5).unwrap();
        let g = make(gray, gray, mode);
        assert!(g.view().stop(0).unwrap().color.same_authoring(gray));
        assert_eq!(g.view().sample_parameter(0.5).unwrap()[0], HDR * 0.5);
    }
}
