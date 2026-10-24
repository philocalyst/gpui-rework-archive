//! Independent author-space scalar oracle: no compiled interval packet reads.
use gpui_canvas::{
    Affine, Canvas, Color, ColorConfig, Extend, Gradient, GradientGeometry as Geometry,
    GradientStop as Stop, Interpolation, OutputProfile, Point, Rect,
};

#[test]
fn public_repeat_sampling_does_not_silently_choose_the_first_stop_after_overflow() {
    let gradient = Gradient::new(
        Geometry::Linear {
            start: Point::default(),
            end: Point { x: 1.0, y: 0.0 },
        },
        &[Stop::new(0.0, Color::BLACK), Stop::new(0.3, Color::WHITE)],
        Extend::Repeat,
        Interpolation::LinearSrgb,
    )
    .unwrap();
    let span = f64::from(0.3_f32);
    let expected = (f64::from(f32::MAX).rem_euclid(span) / span) as f32;
    assert!(expected > 0.0);
    assert_eq!(gradient.view().sample_parameter(f32::MAX)[0], expected);
}

fn half(bytes: &[u8]) -> f64 {
    let bits = u16::from_le_bytes([bytes[0], bytes[1]]);
    let e = ((bits >> 10) & 31) as i32;
    let sign = if bits & 0x8000 == 0 { 1. } else { -1. };
    let m = f64::from(bits & 1023);
    sign * if e == 0 {
        m * 2f64.powi(-24)
    } else {
        (1. + m / 1024.) * 2f64.powi(e - 15)
    }
}
fn premul(color: Color) -> [f64; 4] {
    let rgb = color.to_linear_srgb();
    let a = f64::from(color.alpha());
    [
        f64::from(rgb[0]) * a,
        f64::from(rgb[1]) * a,
        f64::from(rgb[2]) * a,
        a,
    ]
}
fn paint(geometry: Geometry, stops: &[Stop], extend: Extend, x: f64, y: f64) -> [f64; 4] {
    let mut t = match geometry {
        Geometry::Linear { start, end } => {
            let (dx, dy) = (
                f64::from(end.x) - f64::from(start.x),
                f64::from(end.y) - f64::from(start.y),
            );
            ((x - f64::from(start.x)) * dx + (y - f64::from(start.y)) * dy) / (dx * dx + dy * dy)
        }
        Geometry::Radial { center, radii } => ((x - f64::from(center.x)) / f64::from(radii[0]))
            .hypot((y - f64::from(center.y)) / f64::from(radii[1])),
        Geometry::Conic { center, start_turn } => {
            let (x, y) = (x - f64::from(center.x), y - f64::from(center.y));
            let angle = if x == 0. && y == 0. {
                0.
            } else {
                x.atan2(-y) / std::f64::consts::TAU
            };
            (angle - f64::from(start_turn)).rem_euclid(1.)
        }
    };
    let first = f64::from(stops[0].offset);
    let last = f64::from(stops.last().unwrap().offset);
    let span = last - first;
    t = match extend {
        Extend::Pad => t,
        Extend::Repeat => (t - first).rem_euclid(span) + first,
        Extend::Reflect => {
            let u = (t - first).rem_euclid(span * 2.);
            first + if u > span { span * 2. - u } else { u }
        }
    };
    let mut left = None;
    for (i, stop) in stops.iter().enumerate() {
        if f64::from(stop.offset) <= t {
            left = Some(i)
        }
    }
    let Some(i) = left else {
        return premul(stops[0].color);
    };
    let a = premul(stops[i].color);
    if i + 1 == stops.len() {
        return a;
    }
    let u = ((t - f64::from(stops[i].offset)) / f64::from(stops[i + 1].offset - stops[i].offset))
        .clamp(0., 1.);
    let b = premul(stops[i + 1].color);
    std::array::from_fn(|c| a[c] * (1. - u) + b[c] * u)
}
#[test]
fn analytic_material_and_rounded_coverage_match_independent_sixteen_sample_oracle() {
    let stops = [
        Stop::new(-0.25, Color::linear_srgb(7., -0.5, 1., 0.).unwrap()),
        Stop::new(0.375, Color::linear_srgb(3., -0.1, 0.5, 0.75).unwrap()),
        Stop::new(0.375, Color::linear_srgb(0.1, 2., -0.25, 0.5).unwrap()),
        Stop::new(1.25, Color::WHITE),
    ];
    let geometries = [
        Geometry::Linear {
            start: Point { x: 0., y: 0. },
            end: Point { x: 1., y: 0.5 },
        },
        Geometry::Radial {
            center: Point { x: 0.5, y: 0.5 },
            radii: [0.5, 0.25],
        },
        Geometry::Conic {
            center: Point { x: 0.5, y: 0.5 },
            start_turn: -0.125,
        },
    ];
    for geometry in geometries {
        for extend in [Extend::Pad, Extend::Repeat, Extend::Reflect] {
            for radius in [0f64, 2.] {
                let g = Gradient::new(geometry, &stops, extend, Interpolation::LinearSrgb).unwrap();
                let clear = Color::linear_srgb(0.2, 0.3, 0.4, 0.6).unwrap();
                let mut canvas = Canvas::recording(
                    12,
                    10,
                    ColorConfig::linear_hdr(OutputProfile::Srgb, 203.).unwrap(),
                )
                .unwrap();
                canvas.clear(clear);
                let rect = Rect::new(0.125, 0.375, 8.5, 6.25);
                let clip = Rect::new(1.125, 0.375, 9.5, 8.25);
                canvas
                    .fill_gradient(
                        &g,
                        rect,
                        radius as f32,
                        Affine {
                            a: -0.9,
                            b: 0.13,
                            c: -0.17,
                            d: 0.75,
                            tx: 10.125,
                            ty: 0.375,
                        },
                        clip,
                    )
                    .unwrap();
                let inverse = canvas.prepared_scene().draws().next().unwrap().inverse;
                let mut expected = Vec::new();
                for py in 0..10 {
                    for px in 0..12 {
                        let mut sum = [0.; 4];
                        for sy in [0.125, 0.375, 0.625, 0.875] {
                            for sx in [0.125, 0.375, 0.625, 0.875] {
                                let (wx, wy) = (f64::from(px) + sx, f64::from(py) + sy);
                                let mut dst = premul(clear);
                                let lx = inverse[0] * wx + inverse[2] * wy + inverse[4]
                                    - f64::from(rect.x);
                                let ly = inverse[1] * wx + inverse[3] * wy + inverse[5]
                                    - f64::from(rect.y);
                                let (w, h) = (f64::from(rect.width), f64::from(rect.height));
                                let inside = wx >= f64::from(clip.x)
                                    && wy >= f64::from(clip.y)
                                    && wx < f64::from(clip.x) + f64::from(clip.width)
                                    && wy < f64::from(clip.y) + f64::from(clip.height)
                                    && lx >= 0.
                                    && ly >= 0.
                                    && lx < w
                                    && ly < h;
                                let dx = lx - lx.clamp(radius, w - radius);
                                let dy = ly - ly.clamp(radius, h - radius);
                                if inside && (radius == 0. || dx * dx + dy * dy <= radius * radius)
                                {
                                    let src = paint(geometry, &stops, extend, lx / w, ly / h);
                                    for c in 0..4 {
                                        dst[c] = src[c] + dst[c] * (1. - src[3]);
                                    }
                                }
                                for c in 0..4 {
                                    sum[c] += dst[c] / 16.;
                                }
                            }
                        }
                        expected.extend(sum);
                    }
                }
                for (i, (bytes, expected)) in canvas
                    .pixels()
                    .as_chunks::<2>()
                    .0
                    .iter()
                    .zip(expected)
                    .enumerate()
                {
                    let actual = half(bytes);
                    assert!(
                        (actual - expected).abs() <= 0.00001f64.max(expected.abs() * 0.0015),
                        "{geometry:?} {extend:?} radius{radius} channel{i}:actual{actual} expected{expected}"
                    );
                }
            }
        }
    }
}

#[test]
fn gradient_numeric_frontiers_are_admitted_or_rejected_explicitly() {
    let line = Geometry::Linear {
        start: Point { x: 0., y: 0. },
        end: Point { x: 1., y: 0. },
    };
    let red = Color::linear_srgb(1., 0., 0., 1.).unwrap();
    let blue = Color::linear_srgb(0., 0., 1., 1.).unwrap();
    let make = |geometry, stops: &[Stop], extend| {
        Gradient::new(geometry, stops, extend, Interpolation::LinearSrgb)
    };
    // A normal reciprocal and enormous finite HDR delta must not be multiplied
    // together into an overflowing precomputed slope.
    let tiny = f32::MIN_POSITIVE;
    let limit = 1e20_f32.next_down(); // the literal itself rounds above Color's f64 ceiling
    let large = Color::linear_srgb(limit, -limit, 0., 1.).unwrap();
    let opposite = Color::linear_srgb(-limit, limit, 0., 1.).unwrap();
    let g = make(
        line,
        &[Stop::new(0., large), Stop::new(tiny, opposite)],
        Extend::Pad,
    )
    .unwrap();
    let midpoint = g.view().sample_parameter(tiny * 0.5);
    assert!(midpoint.iter().all(|v| v.is_finite()));
    assert!(midpoint[0].abs() < 1e14 && midpoint[1].abs() < 1e14);
    assert_eq!(midpoint[3], 1.);
    assert!(
        make(
            line,
            &[Stop::new(0., red), Stop::new(tiny.next_down(), blue)],
            Extend::Pad
        )
        .is_err()
    );
    assert!(
        make(
            line,
            &[Stop::new(0., red), Stop::new(f32::from_bits(1), blue)],
            Extend::Pad
        )
        .is_err()
    );
    // Adjacent authored offsets at a large magnitude retain f32 half-ULP ties.
    let first = 1_000_000f32 - 0.25;
    let last = first + 0.125;
    let g = make(
        line,
        &[Stop::new(first, red), Stop::new(last, blue)],
        Extend::Pad,
    )
    .unwrap();
    assert_eq!(
        g.view().sample_parameter(first + 0.0625),
        [0.5, 0., 0.5, 1.]
    );
    assert_eq!(
        (first as f64 + 0.03125) as f32,
        first,
        "ties round to the even authored offset"
    );
    // Negative phases are evaluated independently in f64, at exactly
    // representable quarter offsets through the largest admitted phase scale.
    for extend in [Extend::Repeat, Extend::Reflect] {
        let g = make(line, &[Stop::new(-0.5, red), Stop::new(0.5, blue)], extend).unwrap();
        for t in [
            -1_048_575.75f32,
            -8.25,
            -1.25,
            -0.75,
            -0.5,
            0.,
            0.5,
            1.25,
            1_048_575.75,
        ] {
            let x = f64::from(t) + 0.5;
            let u = if extend == Extend::Repeat {
                x.rem_euclid(1.)
            } else {
                let u = x.rem_euclid(2.);
                if u > 1. { 2. - u } else { u }
            };
            assert_eq!(
                g.view().sample_parameter(t),
                [(1. - u) as f32, 0., u as f32, 1.],
                "{extend:?} {t}"
            );
        }
    }
    let stops = [Stop::new(0., red), Stop::new(1., blue)];
    let conic = make(
        Geometry::Conic {
            center: Point { x: 0.5, y: 0.5 },
            start_turn: 0.,
        },
        &stops,
        Extend::Pad,
    )
    .unwrap();
    assert_eq!(conic.view().sample([0.5, 0.25]), [1., 0., 0., 1.]);
    assert_eq!(conic.view().sample([0.5, 0.5]), [1., 0., 0., 1.]);
    assert!(conic.view().sample([0.4999, 0.25])[2] > 0.999);
    assert!(conic.view().sample([0.5001, 0.25])[0] > 0.999);
    let rotated = make(
        Geometry::Conic {
            center: Point { x: 0.5, y: 0.5 },
            start_turn: -0.25,
        },
        &stops,
        Extend::Pad,
    )
    .unwrap();
    assert_eq!(rotated.view().sample([0.5, 0.25]), [0.75, 0., 0.25, 1.]);
    let extremes = [
        Geometry::Linear {
            start: Point { x: 0., y: 0. },
            end: Point { x: 1e-12, y: 0. },
        },
        Geometry::Radial {
            center: Point { x: 1e6, y: 1e6 },
            radii: [1e-12, 1e-12],
        },
    ];
    for geometry in extremes {
        let g = make(geometry, &stops, Extend::Pad).unwrap();
        for point in [[0., 0.], [1., 1.], [0.125, 0.875]] {
            assert!(g.view().sample(point).iter().all(|v| v.is_finite()));
        }
        assert!(
            make(geometry, &stops, Extend::Repeat).is_err(),
            "unstable repeated phase range rejected"
        );
    }
    assert!(
        make(
            Geometry::Radial {
                center: Point::default(),
                radii: [1e-13, 1.]
            },
            &stops,
            Extend::Pad
        )
        .is_err()
    );
    assert!(
        make(
            line,
            &[Stop::new(0., red), Stop::new(0., blue)],
            Extend::Repeat
        )
        .is_err()
    );
}
