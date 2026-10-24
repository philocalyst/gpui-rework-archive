#[path = "support/legacy_admission_masks.rs"]
mod legacy_admission;
#[path = "support/legacy_direct_packets.rs"]
mod legacy_packets;
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

#[test]
fn display_referred_hdr_and_p3_admission_cohorts() {
    // Pair bit 7*left+right uses this order: R,G,B,Y,C,M,neutral. The
    // hexadecimal mask records every accepted/rejected pair, not just a count.
    let palette = [
        [1., 0., 0.],
        [0., 1., 0.],
        [0., 0., 1.],
        [1., 1., 0.],
        [0., 1., 1.],
        [1., 0., 1.],
        [1., 1., 1.],
    ];
    let mut row = 0;
    for reference in [80., 100., 203.] {
        for peak in [reference, 1000., 4000., 10000.] {
            let scale = peak / reference;
            for p3 in [false, true] {
                for (a0, a1) in [(1., 1.), (0.25, 0.75)] {
                    for mode in modes() {
                        let mut accepted = 0_u64;
                        for (i, rgb0) in palette.iter().enumerate() {
                            for (j, rgb1) in palette.iter().enumerate() {
                                let color = |rgb: [f32; 3], alpha| {
                                    let [r, g, b] = rgb.map(|v| v * scale);
                                    if p3 {
                                        Color::linear_display_p3(r, g, b, alpha).unwrap()
                                    } else {
                                        Color::linear_srgb(r, g, b, alpha).unwrap()
                                    }
                                };
                                let (left, right) = (color(*rgb0, a0), color(*rgb1, a1));
                                match try_make(left, right, mode) {
                                    Ok(gradient) => {
                                        accepted |= 1 << (7 * i + j);
                                        for t in [
                                            f32::from_bits(1),
                                            0.00001,
                                            0.125,
                                            0.5,
                                            0.875,
                                            0.99999,
                                            f32::from_bits(1.0_f32.to_bits() - 1),
                                        ] {
                                            let actual =
                                                gradient.view().sample_parameter(t).unwrap();
                                            let expected = oracle::interpolate(
                                                left,
                                                right,
                                                f64::from(t),
                                                mode,
                                            );
                                            for c in 0..3 {
                                                assert!(
                                                    (f64::from(actual[c]) - expected[c]).abs()
                                                        <= Mode::MAX_CONVERSION_ERROR
                                                            + 2e-7 * expected[c].abs(),
                                                    "reference={reference} peak={peak} p3={p3} alpha={a0}/{a1} {mode:?} pair={i}/{j} t={t} c={c} actual={actual:?} expected={expected:?}"
                                                );
                                            }
                                        }
                                    }
                                    Err(gpui_canvas::Error::GradientPrecision) => {}
                                    Err(error) => panic!("unexpected admission error {error:?}"),
                                }
                            }
                        }
                        eprintln!(
                            "display_hdr_profile,reference_nits={reference},peak_nits={peak},p3={p3},alpha={a0}/{a1},mode={mode:?},admitted={},rejected={},accepted_pair_mask={accepted:013x}",
                            accepted.count_ones(),
                            49 - accepted.count_ones()
                        );
                        let legacy = legacy_admission::LEGACY_MASKS[row];
                        assert_eq!(
                            accepted & legacy,
                            legacy,
                            "legacy admission lost at row {row}: reference={reference} peak={peak} p3={p3} alpha={a0}/{a1} {mode:?}"
                        );
                        row += 1;
                        // Lab's authored identities remain exact at every peak.
                        // LCH can replace a tiny nonzero powerless hue, while
                        // Longer can intentionally rotate identical colors.
                        if mode == Mode::Oklab {
                            for i in 0..7 {
                                assert_ne!(accepted & (1 << (8 * i)), 0);
                            }
                        }
                    }
                }
            }
        }
    }
    assert_eq!(row, legacy_admission::LEGACY_MASKS.len());
}

#[test]
fn direct_fallback_packets_match_frozen_profile_bit_for_bit() {
    for (reverse, packet) in legacy_packets::DIRECT_PACKETS.iter().enumerate() {
        let red = Color::linear_srgb(10., 0., 0., if reverse == 0 { 0.25 } else { 0.75 }).unwrap();
        let magenta =
            Color::linear_srgb(10., 0., 10., if reverse == 0 { 0.75 } else { 0.25 }).unwrap();
        let colors = if reverse == 0 {
            [red, magenta]
        } else {
            [magenta, red]
        };
        let gradient = make(colors[0], colors[1], Mode::Oklab);
        assert_eq!(gradient.view().words(), packet);
        assert_ne!(gradient.view().words()[3][1] >> 31, 0);
    }
    let cubic = make(
        Color::linear_srgb(10., 0., 0., 1.).unwrap(),
        Color::linear_srgb(0., 10., 0., 1.).unwrap(),
        Mode::Oklab,
    );
    assert_eq!(cubic.view().words()[3][1] >> 31, 0);
}

#[test]
fn lab_bernstein_controls_keep_near_zero_hdr_channels_small() {
    let mut tested = 0;
    for scale in [1., 1000. / 80., 4000. / 80., 10000. / 80.] {
        for p3 in [false, true] {
            for (a0, a1) in [(1., 1.), (0.25, 0.75), (1e-22, 2e-22)] {
                let color = |rgb: [f32; 3], alpha| {
                    let [r, g, b] = rgb.map(|v| v * scale);
                    if p3 {
                        Color::linear_display_p3(r, g, b, alpha).unwrap()
                    } else {
                        Color::linear_srgb(r, g, b, alpha).unwrap()
                    }
                };
                for rgb in [[0., 1., 0.], [0., 0., 1.], [1., 1., 1.]] {
                    let left = color([1., 0., 0.], a0);
                    let right = color(rgb, a1);
                    let Ok(gradient) = try_make(left, right, Mode::Oklab) else {
                        continue;
                    };
                    tested += 1;
                    for step in 0..=4096 {
                        let t = step as f32 / 4096.;
                        let expected = oracle::interpolate(left, right, f64::from(t), Mode::Oklab);
                        let actual = gradient.view().sample_parameter(t).unwrap();
                        for c in 0..3 {
                            let error = (f64::from(actual[c]) - expected[c]).abs();
                            assert!(
                                error <= Mode::MAX_CONVERSION_ERROR + 2e-7 * expected[c].abs(),
                                "scale={scale} p3={p3} alpha={a0}/{a1} target={rgb:?} t={t} c={c} actual={actual:?} expected={expected:?} error={error}"
                            );
                        }
                    }
                }
            }
        }
    }
    eprintln!("lab_bernstein_dense_near_zero,pairs={tested}");
    assert!(tested >= 30);
}
