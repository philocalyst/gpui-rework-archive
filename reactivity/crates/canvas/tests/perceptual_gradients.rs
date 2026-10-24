#[path = "support/perceptual_oracle.rs"]
mod oracle;
const HDR: f32 = f32::from_bits(1e20_f32.to_bits() - 1);
use gpui_canvas::{
    Color, Extend, Gradient, GradientGeometry, GradientStop as Stop, HueInterpolation as Hue,
    Interpolation as Mode, Point,
};
fn make(left: Color, right: Color, mode: Mode) -> Gradient {
    Gradient::new(
        GradientGeometry::Linear {
            start: Point { x: 0., y: 0. },
            end: Point { x: 1., y: 0. },
        },
        &[Stop::new(0., left), Stop::new(1., right)],
        Extend::Pad,
        mode,
    )
    .unwrap()
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
    let mut max_scaled_error = 0.0_f64;
    for mode in modes() {
        for left in colors {
            for right in colors {
                let g = make(left, right, mode);
                assert_eq!(g.view().interpolation(), mode);
                assert!(g.view().stop(0).unwrap().color.same_authoring(left));
                for t in [f32::from_bits(1), 0.00001, 0.125, 0.5, 0.875, 0.99999] {
                    let expected = oracle::interpolate(left, right, f64::from(t), mode);
                    let actual = g.view().sample_parameter(t).unwrap();
                    let scale = expected[..3]
                        .iter()
                        .map(|v| v.abs())
                        .fold(1.0_f64, f64::max)
                        .max(
                            left.to_linear_srgb()[..3]
                                .iter()
                                .chain(&right.to_linear_srgb()[..3])
                                .map(|v| f64::from(v.abs()))
                                .fold(0.0_f64, f64::max),
                        );
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
                        max_scaled_error =
                            max_scaled_error.max(if c == 3 { error } else { error / scale });
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
    }
    eprintln!("perceptual_f64_oracle,max_scaled_error={max_scaled_error}");
}
#[test]
fn exact_endpoints_edges_alpha_admission_and_lossless_authors() {
    for mode in modes() {
        let left = Color::linear_srgb(-0., HDR, -0.1, 0.25).unwrap();
        let right = Color::linear_display_p3(1., 4., -0.1, 0.75).unwrap();
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
