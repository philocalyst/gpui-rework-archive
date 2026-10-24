//! Independent author-space scalar oracle: no compiled interval packet reads.
use gpui_canvas::{
    Affine, Canvas, Color, ColorConfig, Extend, Gradient, GradientGeometry as Geometry,
    GradientStop as Stop, Interpolation, OutputProfile, Point, Rect,
};
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
