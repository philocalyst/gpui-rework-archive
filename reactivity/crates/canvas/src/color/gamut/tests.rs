use super::*;

fn cases() -> impl Iterator<Item = (OutputProfile, f32, f32, f64)> {
    include_str!("../../../tests/fixtures/gamut_limits.csv")
        .lines()
        .skip(1)
        .map(|line| {
            let mut cells = line.split(',');
            let profile = if cells.next().unwrap() == "srgb" {
                OutputProfile::Srgb
            } else {
                OutputProfile::DisplayP3
            };
            let l = f32::from_bits(cells.next().unwrap().parse().unwrap());
            let h = f32::from_bits(cells.next().unwrap().parse().unwrap());
            (profile, l, h, cells.next().unwrap().parse().unwrap())
        })
}
fn check_limits<S: Simd>(simd: S) {
    let mut worst_ulps = 0.0_f64;
    let mut worst_normal_scaled = 0.0_f64;
    for (profile, l, h, expected) in cases() {
        if l == 0.0 || l == 1.0 {
            assert_eq!(profile.max_chroma(l, h).unwrap() as f64, expected);
            continue;
        }
        let cap = limit(simd, profile, l, h).unwrap();
        let ulp = ((expected as f32).next_up() - expected as f32) as f64;
        let error = (cap as f64 - expected).abs();
        assert!(
            error <= 2.0 * ulp + 1e-12 * l as f64,
            "{profile:?} L={l} h={h}: {cap} vs {expected}, error={error}"
        );
        worst_ulps = worst_ulps.max(error / ulp);
        if l.is_normal() {
            worst_normal_scaled = worst_normal_scaled.max(error / l as f64);
        }
        assert_eq!(
            cap.to_bits(),
            limit(fearless_simd::Fallback::new(), profile, l, h)
                .unwrap()
                .to_bits()
        );
        assert!(in_gamut(
            Color::pack([l, cap, h, 1.0], ColorSpace::Oklch),
            profile
        ));
        let mut outside = cap;
        for _ in 0..8 {
            outside = outside.next_up();
        }
        assert!(
            !in_gamut(
                Color::pack([l, outside, h, 1.0], ColorSpace::Oklch),
                profile
            ),
            "no nearby outward witness: {profile:?} L={l} h={h} C={cap}"
        );
    }
    println!(
        "worst error in f32ULPs={worst_ulps:e}; normal-L scaled error={worst_normal_scaled:e}"
    );
}
#[test]
fn limits_match_independent_high_precision_monotone_interval_oracle() {
    check_limits(fearless_simd::Fallback::new());
    let level = fearless_simd::Level::new();
    #[cfg(target_arch = "x86_64")]
    {
        if let Some(s) = level.as_sse2() {
            check_limits(s)
        }
        if let Some(s) = level.as_sse4_2() {
            check_limits(s)
        }
        if let Some(s) = level.as_avx2() {
            check_limits(s)
        }
        if let Some(s) = level.as_avx512() {
            check_limits(s)
        }
    }
    #[cfg(target_arch = "aarch64")]
    if let Some(s) = level.as_neon() {
        check_limits(s)
    }
}
#[test]
fn author_bits_alpha_validation_and_extended_colors_have_explicit_contracts() {
    for profile in [OutputProfile::Srgb, OutputProfile::DisplayP3] {
        for channels in [
            [0.5, 0.01, 133.5, -0.0],
            [-0.0, -0.0, 270.0, 0.5],
            [1.0, 0.0, 90.0, 1.0],
        ] {
            let c = Color::oklch(channels[0], channels[1], channels[2], channels[3]).unwrap();
            assert!(c.same_authoring(c.fit_chroma(profile).unwrap()));
        }
        for l in [0.0, 1.0] {
            let c = Color::oklch(l, 1.0, 30.0, -0.0).unwrap();
            let fit = c.fit_chroma(profile).unwrap();
            assert_eq!(fit.channels()[1], 0.0);
            assert_eq!(fit.channels()[3].to_bits(), (-0.0_f32).to_bits());
            assert!(in_gamut(fit, profile));
        }
        let c = Color::oklch(0.5, 1e6, 30.0, -0.0).unwrap();
        let fit = c.fit_chroma(profile).unwrap();
        assert!(fit.channels()[1] < c.channels()[1]);
        for index in [0, 2, 3] {
            assert_eq!(
                fit.channels()[index].to_bits(),
                c.channels()[index].to_bits()
            );
        }
        assert!(in_gamut(fit, profile));
        for c in [
            Color::rgb(255, 0, 0),
            Color::linear_srgb(4.0, -1.0, 2.0, 1.0).unwrap(),
            Color::display_p3(0.2, 0.3, 0.4, 1.0).unwrap(),
            Color::linear_display_p3(3.0, 2.0, 1.0, 1.0).unwrap(),
        ] {
            assert_eq!(c.fit_chroma(profile), Err(Error::InvalidColor));
        }
        for l in [f32::NAN, f32::INFINITY, -0.1, 1.0_f32.next_up()] {
            assert_eq!(profile.max_chroma(l, 30.0), Err(Error::InvalidColor));
        }
        for h in [f32::NAN, f32::INFINITY, f32::NEG_INFINITY] {
            assert_eq!(profile.max_chroma(0.5, h), Err(Error::InvalidColor));
        }
        for h in [0.0, 90.0, 180.0, 270.0, f32::MAX, -f32::MAX] {
            assert_eq!(profile.max_chroma(0.0, h).unwrap(), 0.0);
            assert_eq!(profile.max_chroma(1.0, h).unwrap(), 0.0);
            assert_eq!(
                profile.max_chroma(0.5, h).unwrap(),
                profile.max_chroma(0.5, wrap_hue(h as f64)).unwrap()
            );
        }
    }
    // This real sRGB ray leaves red<0 and re-enters before green<0. Fitting
    // preserves a valid author beyond the first connected-neutral boundary.
    let reentry = Color::oklch(0.1, 0.067, 264.2, -0.0).unwrap();
    assert!(reentry.channels()[1] > OutputProfile::Srgb.max_chroma(0.1, 264.2).unwrap());
    assert!(in_gamut(reentry, OutputProfile::Srgb));
    assert!(reentry.same_authoring(reentry.fit_chroma(OutputProfile::Srgb).unwrap()));
    assert_eq!(
        Color::oklch(0.5, f32::MAX, 30.0, 1.0),
        Err(Error::ColorOutOfRange)
    );
}
fn polynomial_cases<S: Simd>(simd: S) {
    let p = Polynomial {
        a: [1.0, 1.0, 0.0, 0.0].simd_into(simd),
        b: [-4.0, -6.0, 0.0, 0.0].simd_into(simd),
        c: [5.0, 11.0, 1.0, 0.0].simd_into(simd),
        d: [-2.0, -6.0, -0.25, -1.0].simd_into(simd),
    };
    let [r, unresolved] = first_exit(
        simd,
        p,
        critical_points(simd, p),
        f64x4::splat(simd, 10.0),
        1.0,
    );
    let r: [f64; 4] = r.into();
    let unresolved: [f64; 4] = unresolved.into();
    assert_eq!(r[0], f64::INFINITY);
    assert_eq!(unresolved[0], 0.0);
    assert!((r[1] - 1.0).abs() < 1e-12, "first of three {r:?}");
    assert!((r[2] - 0.25).abs() < 1e-12, "linear {r:?}");
    assert_eq!(r[3], f64::INFINITY);
}
#[test]
fn first_outward_roots_and_unresolved_contacts_keep_separate_authority() {
    polynomial_cases(fearless_simd::Fallback::new());
    #[cfg(target_arch = "x86_64")]
    polynomial_cases(fearless_simd::Level::new().as_sse2().unwrap());
}

#[test]
fn nonbinary_rational_tangent_blocks_later_roots_instead_of_guessing_a_sign() {
    // Exact dyadic coefficients of (15t-11)^2(t-2)/256.
    let s = fearless_simd::Fallback::new();
    let p = Polynomial {
        a: f64x4::splat(s, 225.0 / 256.0),
        b: f64x4::splat(s, -780.0 / 256.0),
        c: f64x4::splat(s, 781.0 / 256.0),
        d: f64x4::splat(s, -242.0 / 256.0),
    };
    let [r, unresolved] = first_exit(s, p, critical_points(s, p), f64x4::splat(s, 4.0), 1.0);
    let r: [f64; 4] = r.into();
    let unresolved: [f64; 4] = unresolved.into();
    assert_eq!(r[0], f64::INFINITY);
    assert_eq!(unresolved[0], 0.0);
}

#[test]
fn finite_input_sweep_keeps_exact_membership_and_a_nearby_outward_witness() {
    let mut seed = 0x91e1_0da5_u32;
    for _ in 0..10_000 {
        seed = seed.wrapping_mul(1_664_525).wrapping_add(1_013_904_223);
        let lightness = f32::from_bits(seed % 0x3f80_0000);
        seed = seed.wrapping_mul(1_664_525).wrapping_add(1_013_904_223);
        let hue = wrap_hue(seed as f64 * (360.0 / 4_294_967_296.0));
        for profile in [OutputProfile::Srgb, OutputProfile::DisplayP3] {
            let cap = profile.max_chroma(lightness, hue).unwrap();
            if lightness == 0.0 {
                continue;
            }
            assert_eq!(
                cap.to_bits(),
                limit(fearless_simd::Fallback::new(), profile, lightness, hue)
                    .unwrap()
                    .to_bits()
            );
            let author = Color::oklch(lightness, cap, hue, -0.0).unwrap();
            assert!(in_gamut(author, profile));
            assert!(author.same_authoring(author.fit_chroma(profile).unwrap()));
            let mut outside = cap;
            for _ in 0..8 {
                outside = outside.next_up();
            }
            assert!(
                !in_gamut(Color::oklch(lightness, outside, hue, 1.0).unwrap(), profile),
                "{profile:?} L={lightness} h={hue} C={cap}"
            );
        }
    }
}

fn lattice_geometry<S: Simd>(s: S) {
    let v = |x| f64x4::splat(s, x);
    let active = mask64x4::splat(s, true);
    let ulp = 2.0_f64.powi(-23);
    let narrow = Polynomial {
        a: v(0.0),
        b: v(-1.0),
        c: v(2.0 + ulp),
        d: v(-(1.0 + ulp / 4.0) * (1.0 + 3.0 * ulp / 4.0)),
    };
    // No representable f32 lies in this outward excursion. Ceil(end) is already
    // in the later reentry, so treating that exclusive bound as outside fails.
    assert!(narrow.evaluate(v(1.0 + ulp))[0] < 0.0);
    let (cap, steps) = lattice_exit(narrow, v(0.0), v(1.0 + ulp / 2.0), 1.0, active);
    assert_eq!(cap[0], 1.0);
    assert!(steps <= 31);
    println!("lattice sub-ULP excursion: {steps} evaluations");
    let [resolved, unknown] = first_exit(s, narrow, critical_points(s, narrow), v(2.0), 1.0);
    assert_eq!(resolved[0], f64::INFINITY);
    assert_eq!(unknown[0], 0.0, "numerical admission remains conservative");

    let min_l = f32::from_bits(1) as f64;
    for (name, p, l, start, end, expected) in [
        (
            "floor start",
            Polynomial {
                a: v(0.0),
                b: v(0.0),
                c: v(1.0),
                d: v(-(1.0 + 2.0 * ulp)),
            },
            1.0,
            1.0 + ulp / 4.0,
            1.0 + 3.0 * ulp,
            (1.0 + 2.0 * ulp) as f32,
        ),
        (
            "subnormal",
            Polynomial {
                a: v(0.0),
                b: v(0.0),
                c: v(1.0),
                d: v(-0.25),
            },
            min_l,
            0.0,
            0.5,
            0.0,
        ),
        (
            "finite sentinel",
            Polynomial {
                a: v(1.0),
                b: v(0.0),
                c: v(0.0),
                d: v(-((f32::MAX as f64 * 0.5) / min_l).powi(3)),
            },
            min_l,
            0.0,
            f32::MAX as f64 * 2.0 / min_l,
            f32::MAX * 0.5,
        ),
    ] {
        let (cap, steps) = lattice_exit(p, v(start), v(end), l, active);
        assert_eq!((cap[0] as f32).to_bits(), expected.to_bits(), "{name}");
        assert!(steps <= 31);
        assert!(p.evaluate(v(f32::MAX as f64 / l))[0].is_finite());
        println!("lattice {name}: {steps} evaluations");
    }
    // The upper boundary precedes the continuous lower boundary but shares its
    // inward f32 predecessor. Searching only through that predecessor is safe.
    let linear = |root: f64| Polynomial {
        a: v(0.0),
        b: v(0.0),
        c: v(1.0),
        d: v(-root),
    };
    let lower = linear(1.0 + 3.0 * ulp / 4.0);
    let [lower, _] = first_exit(s, lower, critical_points(s, lower), v(2.0), 1.0);
    assert_eq!(lower[0], 1.0);
    let upper = linear(1.0 + ulp / 4.0);
    let [upper, unknown] = first_exit(s, upper, critical_points(s, upper), lower, 1.0);
    assert_eq!(upper[0], f64::INFINITY);
    assert_eq!(unknown[0], f64::INFINITY);
}
#[test]
fn ordered_f32_search_handles_exclusive_bounds_tiny_excursions_and_finite_extremes() {
    lattice_geometry(fearless_simd::Fallback::new());
    #[cfg(target_arch = "x86_64")]
    lattice_geometry(fearless_simd::Level::new().as_sse2().unwrap());
}
