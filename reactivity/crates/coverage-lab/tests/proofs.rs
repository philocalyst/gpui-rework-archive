use gpui_reactivity_coverage_lab::{
    Affine, Class, Color, Operation, Plan, Point, Primitive, Rect, RenderError, Shape, Space,
    render_direct,
};

fn primitive(shape: Shape, transform: Affine) -> Primitive {
    Primitive::new(shape, Space::new(transform)).unwrap()
}
fn color(r: f64, g: f64, b: f64, a: f64) -> Color {
    Color::new(r, g, b, a).unwrap()
}
// An independent implicit-geometry oracle: multiply out inverse numerators,
// avoid SDF/sqrt/division. Dyadic inputs in the exhaustive tests keep these
// bounded products exactly representable in binary64.
fn implicit(p: Primitive, point: Point) -> bool {
    let t = p.space().forward();
    let det = t.a * t.d - t.b * t.c;
    let x = point.x - t.tx;
    let y = point.y - t.ty;
    let nx = t.d * x - t.c * y;
    let ny = t.a * y - t.b * x;
    match p.shape() {
        Shape::Circle { radius } => nx * nx + ny * ny <= (radius * det) * (radius * det),
        Shape::Box {
            half_width,
            half_height,
        } => nx.abs() <= half_width * det.abs() && ny.abs() <= half_height * det.abs(),
    }
}
fn verify_tile(p: Primitive, tile: Rect) {
    let class = p.classify(tile);
    if class == Class::Boundary {
        return;
    }
    for y in 0..=8 {
        for x in 0..=8 {
            let point = Point {
                x: tile.x + tile.width * x as f64 / 8.0,
                y: tile.y + tile.height * y as f64 / 8.0,
            };
            assert_eq!(
                implicit(p, point),
                class == Class::Inside,
                "{p:?} tile={tile:?} class={class:?} sample={point:?}"
            );
        }
    }
}
#[test]
fn exhaustive_dyadic_certificates_have_no_false_inside_or_outside() {
    for a in [-2.0, -0.5, 0.5, 2.0] {
        for d in [-2.0, -0.5, 0.5, 2.0] {
            for b in [-0.5, 0.0, 0.5] {
                for c in [-0.5, 0.0, 0.5] {
                    let transform = Affine {
                        a,
                        b,
                        c,
                        d,
                        tx: 0.25,
                        ty: -0.5,
                    };
                    if a * d == b * c {
                        continue;
                    }
                    for shape in [
                        Shape::Circle { radius: 1.0 },
                        Shape::Box {
                            half_width: 1.25,
                            half_height: 0.75,
                        },
                    ] {
                        let p = primitive(shape, transform);
                        assert!(p.space().is_admitted());
                        for y in -8..8 {
                            for x in -8..8 {
                                verify_tile(
                                    p,
                                    Rect {
                                        x: x as f64 * 0.5,
                                        y: y as f64 * 0.5,
                                        width: 0.5,
                                        height: 0.5,
                                    },
                                );
                            }
                        }
                    }
                }
            }
        }
    }
}
struct Rng(u64);
impl Rng {
    fn next(&mut self, n: usize) -> usize {
        self.0 ^= self.0 << 13;
        self.0 ^= self.0 >> 7;
        self.0 ^= self.0 << 17;
        self.0 as usize % n
    }
}
#[test]
fn randomized_shear_nonuniform_reflection_and_fractional_tiles() {
    let mut rng = Rng(0x8123_acef);
    for _ in 0..5000 {
        let mut coeff = || rng.next(65) as f64 / 8.0 - 4.0;
        let t = Affine {
            a: coeff(),
            b: coeff(),
            c: coeff(),
            d: coeff(),
            tx: coeff(),
            ty: coeff(),
        };
        let p = primitive(Shape::Circle { radius: 2.5 }, t);
        if !p.space().is_admitted() {
            continue;
        }
        let tile = Rect {
            x: rng.next(129) as f64 / 8.0 - 8.0,
            y: rng.next(129) as f64 / 8.0 - 8.0,
            width: (rng.next(16) + 1) as f64 / 16.0,
            height: (rng.next(16) + 1) as f64 / 16.0,
        };
        verify_tile(p, tile);
        let bound = p.space().inverse_norm_upper().unwrap();
        let det = t.a * t.d - t.b * t.c;
        for i in 0..32 {
            let angle = i as f64 * std::f64::consts::TAU / 32.0;
            let x = angle.cos();
            let y = angle.sin();
            let local_x = (t.d * x - t.c * y) / det;
            let local_y = (t.a * y - t.b * x) / det;
            assert!(local_x.hypot(local_y) <= bound);
        }
    }
}
#[test]
fn singular_unadmitted_and_fractional_touching_edges_never_certify() {
    for transform in [
        Affine {
            a: 0.0,
            ..Affine::IDENTITY
        },
        Affine {
            a: 1.0,
            b: 1.0,
            c: 1.0,
            d: 1.0,
            ..Affine::IDENTITY
        },
        Affine {
            tx: f64::NAN,
            ..Affine::IDENTITY
        },
        Affine {
            a: 1e-12,
            ..Affine::IDENTITY
        },
        Affine {
            a: 1e20,
            ..Affine::IDENTITY
        },
    ] {
        let p = primitive(Shape::Circle { radius: 1.0 }, transform);
        assert!(!p.space().is_admitted());
        assert_eq!(
            p.classify(Rect {
                x: 0.0,
                y: 0.0,
                width: 1.0,
                height: 1.0
            }),
            Class::Boundary
        );
        assert_eq!(p.contains(Point { x: 0.5, y: 0.5 }), None);
        assert!(matches!(
            Plan::build(
                &[Operation::SourceOver {
                    primitive: p,
                    color: color(1.0, 0.0, 0.0, 1.0)
                }],
                8,
                8,
                4,
                false
            ),
            Err(RenderError::Geometry)
        ));
    }
    let p = primitive(
        Shape::Box {
            half_width: 1.0,
            half_height: 1.0,
        },
        Affine::translation(0.25, 0.125),
    );
    for x in [1.25f64.next_down(), 1.25, 1.25f64.next_up()] {
        verify_tile(
            p,
            Rect {
                x,
                y: 0.125,
                width: 0.5,
                height: 0.25,
            },
        );
    }
    assert_eq!(
        p.classify(Rect {
            x: f64::NAN,
            y: 0.0,
            width: 1.0,
            height: 1.0
        }),
        Class::Boundary
    );
}

fn oracle(ops: &[Operation], width: u32, height: u32, samples: &[Point]) -> Vec<[f64; 4]> {
    let mut result = Vec::new();
    for y in 0..height {
        for x in 0..width {
            let mut sum = [0.0; 4];
            for sample in samples {
                let point = Point {
                    x: f64::from(x) + sample.x,
                    y: f64::from(y) + sample.y,
                };
                let mut destination = [0.0; 4];
                for op in ops {
                    match *op {
                        Operation::SourceOver { primitive, color } => {
                            if implicit(primitive, point) {
                                let source = color.channels();
                                for channel in 0..4 {
                                    destination[channel] =
                                        source[channel] + destination[channel] * (1.0 - source[3]);
                                }
                            }
                        }
                        Operation::BackdropScale { factor } => {
                            for value in &mut destination[..3] {
                                *value *= factor;
                            }
                        }
                    }
                }
                for channel in 0..4 {
                    sum[channel] += destination[channel];
                }
            }
            result.push(sum.map(|v| v / samples.len() as f64));
        }
    }
    result
}
#[test]
fn independent_exhaustive_subpixel_compositing_matches_both_planners() {
    let samples: Vec<_> = (0..4)
        .flat_map(|y| {
            (0..4).map(move |x| Point {
                x: (x as f64 + 0.5) / 4.0,
                y: (y as f64 + 0.5) / 4.0,
            })
        })
        .collect();
    let mut rng = Rng(0x8192_dbec);
    for _ in 0..80 {
        let mut ops = Vec::new();
        for i in 0..9 {
            if i == 4 && rng.next(2) == 0 {
                ops.push(Operation::BackdropScale { factor: 0.5 });
                continue;
            }
            let shape = if rng.next(2) == 0 {
                Shape::Circle {
                    radius: rng.next(10) as f64 + 0.5,
                }
            } else {
                Shape::Box {
                    half_width: rng.next(10) as f64 + 0.25,
                    half_height: rng.next(10) as f64 + 0.75,
                }
            };
            let p = primitive(
                shape,
                Affine {
                    a: 1.0,
                    b: 0.0,
                    c: if rng.next(2) == 0 { 0.5 } else { 0.0 },
                    d: 1.0,
                    tx: rng.next(12) as f64 + 0.25,
                    ty: rng.next(12) as f64 + 0.5,
                },
            );
            let alpha = [0.0, 0.25, 0.5, 1.0][rng.next(4)];
            ops.push(Operation::SourceOver {
                primitive: p,
                color: color(alpha * 0.5, alpha * 0.25, alpha, alpha),
            });
        }
        let expected = oracle(&ops, 12, 9, &samples);
        let (direct, _) = render_direct(&ops, 12, 9, &samples).unwrap();
        assert_eq!(
            direct.iter().map(|p| p.channels()).collect::<Vec<_>>(),
            expected
        );
        for hierarchy in [false, true] {
            for tile in [1, 2, 4, 8] {
                let plan = Plan::build(&ops, 12, 9, tile, hierarchy).unwrap();
                let (actual, _) = plan.render(&samples).unwrap();
                assert_eq!(
                    actual.iter().map(|p| p.channels()).collect::<Vec<_>>(),
                    expected
                );
            }
        }
    }
}
#[test]
fn only_proven_opaque_coverage_culls_and_backdrops_are_barriers() {
    let fill = primitive(
        Shape::Box {
            half_width: 100.0,
            half_height: 100.0,
        },
        Affine::IDENTITY,
    );
    let opaque = Operation::SourceOver {
        primitive: fill,
        color: color(1.0, 0.0, 0.0, 1.0),
    };
    let semi = Operation::SourceOver {
        primitive: fill,
        color: color(0.0, 0.5, 0.0, 0.5),
    };
    let ops = [opaque, semi, opaque, semi];
    let plan = Plan::build(&ops, 8, 8, 4, true).unwrap();
    assert_eq!(plan.stats().occluded_tile_draws, 8);
    assert_eq!(plan.stats().retained_tile_operations, 8);
    let (actual, stats) = plan.render(&[Point { x: 0.5, y: 0.5 }]).unwrap();
    assert_eq!(stats.boundary_point_tests, 0);
    assert_eq!(
        actual,
        render_direct(&ops, 8, 8, &[Point { x: 0.5, y: 0.5 }])
            .unwrap()
            .0
    );
    let semi_ops = [semi, semi];
    assert_eq!(
        Plan::build(&semi_ops, 8, 8, 4, true)
            .unwrap()
            .stats()
            .occluded_tile_draws,
        0
    );
    let dependency = [
        opaque,
        Operation::BackdropScale { factor: 0.5 },
        semi,
        opaque,
    ];
    let plan = Plan::build(&dependency, 8, 8, 4, true).unwrap();
    assert_eq!(plan.stats().occluded_tile_draws, 4);
    assert_eq!(plan.stats().retained_tile_operations, 12);
    assert_eq!(
        plan.render(&[Point { x: 0.5, y: 0.5 }]).unwrap().0,
        render_direct(&dependency, 8, 8, &[Point { x: 0.5, y: 0.5 }])
            .unwrap()
            .0
    );
}
#[test]
fn hierarchy_removes_repeated_classification_and_samples_are_not_area_aa() {
    let large = primitive(
        Shape::Circle { radius: 1000.0 },
        Affine::translation(64.0, 64.0),
    );
    let ops = [Operation::SourceOver {
        primitive: large,
        color: color(1.0, 1.0, 1.0, 1.0),
    }];
    let flat = Plan::build(&ops, 128, 128, 8, false).unwrap();
    let hierarchy = Plan::build(&ops, 128, 128, 8, true).unwrap();
    assert_eq!(hierarchy.stats().classifier_calls, 1);
    assert_eq!(flat.stats().classifier_calls, 256);
    assert_eq!(hierarchy.stats().inside_tiles, 256);
    let small = primitive(
        Shape::Circle { radius: 0.01 },
        Affine::translation(0.5, 0.5),
    );
    let ops = [Operation::SourceOver {
        primitive: small,
        color: color(1.0, 1.0, 1.0, 1.0),
    }];
    let center = render_direct(&ops, 1, 1, &[Point { x: 0.5, y: 0.5 }])
        .unwrap()
        .0[0];
    let four = render_direct(
        &ops,
        1,
        1,
        &[
            Point { x: 0.25, y: 0.25 },
            Point { x: 0.75, y: 0.25 },
            Point { x: 0.25, y: 0.75 },
            Point { x: 0.75, y: 0.75 },
        ],
    )
    .unwrap()
    .0[0];
    assert_eq!(center.channels()[3], 1.0);
    assert_eq!(four.channels()[3], 0.0);
}
