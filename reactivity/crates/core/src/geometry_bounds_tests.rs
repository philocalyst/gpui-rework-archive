use super::*;

// The complete pre-change implementation is intentionally independent of the
// selected-endpoint path and its exceptional reducer. Compare returned bits,
// including all admission/classification and outward-rounding decisions.
#[inline(never)]
fn four_corner_oracle(space: CoordinateSpace, rect: Rect) -> MappedBounds {
    if !rect.is_valid()
        || matches!(space.domain, Domain::Uncertain)
        || !space.matrix.into_iter().all(f64::is_finite)
    {
        return MappedBounds::Unbounded;
    }
    let [a, b, c, d, tx, ty] = space.matrix;
    let det = a * d - b * c;
    if rect.is_empty() || det == 0.0 {
        return MappedBounds::Empty;
    }
    let (x, y) = (rect.x as f64, rect.y as f64);
    let (right, bottom) = (x + rect.width as f64, y + rect.height as f64);
    let points = [[x, y], [right, y], [x, bottom], [right, bottom]];
    let mut min = [f64::INFINITY; 2];
    let mut max = [f64::NEG_INFINITY; 2];
    for p in points {
        let x = a * p[0] + c * p[1] + tx;
        let y = b * p[0] + d * p[1] + ty;
        min[0] = min[0].min(x);
        min[1] = min[1].min(y);
        max[0] = max[0].max(x);
        max[1] = max[1].max(y);
    }
    let min = min.map(|v| (v as f32).next_down());
    let max = max.map(|v| (v as f32).next_up());
    let result = Rect::new(
        min[0],
        min[1],
        (max[0] - min[0]).next_up(),
        (max[1] - min[1]).next_up(),
    );
    if result.is_valid() {
        MappedBounds::Finite(result)
    } else {
        MappedBounds::Unbounded
    }
}

fn bits(bounds: MappedBounds) -> (u8, [u32; 4]) {
    match bounds {
        MappedBounds::Empty => (0, [0; 4]),
        MappedBounds::Finite(r) => (1, [r.x, r.y, r.width, r.height].map(f32::to_bits)),
        MappedBounds::Unbounded => (2, [0; 4]),
    }
}
fn check(space: CoordinateSpace, rect: Rect) {
    assert_eq!(
        bits(space.mapped_bounds(rect)),
        bits(four_corner_oracle(space, rect)),
        "space={space:?}, rect={rect:?}"
    );
}
fn next(seed: &mut u64) -> u64 {
    *seed ^= *seed << 13;
    *seed ^= *seed >> 7;
    *seed ^= *seed << 17;
    *seed
}

#[test]
fn endpoint_signs_signed_zero_and_subnormal_boundaries_match_exact_bits() {
    let values = [
        -1.0,
        -f32::MIN_POSITIVE,
        -f32::from_bits(1),
        -0.0,
        0.0,
        f32::from_bits(1),
        f32::MIN_POSITIVE,
        1.0,
    ];
    let rects = [
        Rect::new(-0.0, 0.0, 1.0, 1.0),
        Rect::new(-1.0, -1.0, 2.0, 2.0),
        Rect::new(0.0, -0.0, f32::from_bits(1), f32::MIN_POSITIVE),
        Rect::new(-1.0e20, 1.0e20, 1.0, 1.0),
    ];
    for a in values {
        for b in values {
            for c in values {
                for d in values {
                    for translation in [-0.0, 0.0, -1.0, 1.0] {
                        let space = CoordinateSpace::new(Affine {
                            a,
                            b,
                            c,
                            d,
                            tx: translation,
                            ty: -translation,
                        });
                        for rect in rects {
                            check(space, rect);
                        }
                    }
                }
            }
        }
    }
}

#[test]
fn admission_order_empty_invalid_uncertain_and_singular_are_unchanged() {
    let rects = [
        Rect::new(0.0, 0.0, 0.0, 1.0),
        Rect::new(0.0, 0.0, 1.0, -0.0),
        Rect::new(f32::NAN, 0.0, 0.0, 1.0),
        Rect::new(0.0, 0.0, -1.0, 1.0),
        Rect::new(f32::MAX, 0.0, f32::MAX, 1.0),
        Rect::new(f32::INFINITY, 0.0, 1.0, 1.0),
        Rect::new(0.0, 0.0, 1.0, 1.0),
    ];
    for matrix in [
        [1.0, 0.0, 0.0, 1.0, 0.0, 0.0],
        [1.0, 1.0, 1.0, 1.0, 0.0, 0.0],
        [f64::NAN, 0.0, 0.0, 1.0, 0.0, 0.0],
        [f64::INFINITY, 0.0, 0.0, 1.0, 0.0, 0.0],
        [1.0e300, 0.0, 0.0, 1.0e300, 0.0, 0.0],
    ] {
        for domain in [Domain::Composed, Domain::Uncertain] {
            for rect in rects {
                check(CoordinateSpace { matrix, domain }, rect);
            }
        }
    }
    let empty = Rect::new(0.0, 0.0, 0.0, 1.0);
    assert_eq!(
        CoordinateSpace {
            matrix: [1.0, 0.0, 0.0, 1.0, 0.0, 0.0],
            domain: Domain::Uncertain
        }
        .mapped_bounds(empty),
        MappedBounds::Unbounded
    );
}

#[test]
fn seeded_f32_and_wide_f64_domains_match_the_independent_oracle() {
    let mut seed = 0xe081_5af0_a12b_748d;
    for _ in 0..100_000 {
        let matrix = std::array::from_fn(|_| f32::from_bits(next(&mut seed) as u32) as f64);
        let rect = Rect::new(
            f32::from_bits(next(&mut seed) as u32),
            f32::from_bits(next(&mut seed) as u32),
            f32::from_bits(next(&mut seed) as u32 & 0x7fff_ffff),
            f32::from_bits(next(&mut seed) as u32 & 0x7fff_ffff),
        );
        check(
            CoordinateSpace {
                matrix,
                domain: Domain::Direct,
            },
            rect,
        );
    }
    for _ in 0..100_000 {
        let matrix = std::array::from_fn(|_| f64::from_bits(next(&mut seed)));
        let x = (next(&mut seed) as i64 % 100_000) as f32 * 0.125;
        let y = (next(&mut seed) as i64 % 100_000) as f32 * 0.125;
        let w = (next(&mut seed) % 100_000 + 1) as f32 * 0.125;
        let h = (next(&mut seed) % 100_000 + 1) as f32 * 0.125;
        check(
            CoordinateSpace {
                matrix,
                domain: Domain::Composed,
            },
            Rect::new(x, y, w, h),
        );
    }
}

#[test]
fn composed_extremes_exercise_finite_and_nonfinite_corner_paths() {
    let mut space = CoordinateSpace::new(Affine::IDENTITY);
    for _ in 0..8 {
        space = space.compose(Affine::scale(1.0e38, 1.0e-38));
        assert!(!matches!(space.domain, Domain::Uncertain));
        check(space, Rect::new(0.0, 0.0, 1.0, 1.0));
        check(space, Rect::new(0.0, 0.0, 1.0e38, 1.0));
    }
    assert!(space.matrix[0].is_finite() && space.matrix[0] > f32::MAX as f64);
    assert!(!(space.matrix[0] * 1.0e38).is_finite());
    let overflow = CoordinateSpace {
        matrix: [1.0e300, 0.0, -1.0e300, 1.0e-300, 1.0, 0.0],
        domain: Domain::Composed,
    };
    check(overflow, Rect::new(0.0, 0.0, 1.0e38, 1.0e38));
    let mut seed = 0xd3b1_55fa_987c_ab34;
    for _ in 0..2_000 {
        let mut space = CoordinateSpace::new(Affine::IDENTITY);
        for _ in 0..32 {
            let scale = if next(&mut seed) & 1 == 0 {
                1.0e10
            } else {
                1.0e-10
            };
            let sign = if next(&mut seed) & 1 == 0 { 1.0 } else { -1.0 };
            space = space.compose(Affine {
                a: sign * scale,
                b: 0.125,
                c: -0.0625,
                d: scale.recip(),
                tx: 0.25,
                ty: -0.5,
            });
            check(space, Rect::new(-13.125, 19.5, 32.25, 7.75));
        }
    }
}

#[test]
fn provenance_is_private_copied_and_discarded_without_changing_value_equality() {
    let direct = CoordinateSpace::new(Affine::translation(2.0, -3.0));
    assert_eq!(direct.domain, Domain::Direct);
    assert_eq!(direct, direct.compose(Affine::IDENTITY));
    assert_eq!(direct.compose(Affine::IDENTITY).domain, Domain::Composed);
    let copied = direct;
    assert_eq!(copied.domain, Domain::Direct);
    let uncertain = CoordinateSpace {
        domain: Domain::Uncertain,
        ..direct
    };
    assert_ne!(uncertain, direct);
    assert_eq!(
        uncertain.compose(Affine::IDENTITY).domain,
        Domain::Uncertain
    );
    for value in [
        0.0,
        -0.0,
        f32::NAN,
        f32::INFINITY,
        f32::NEG_INFINITY,
        f32::MAX,
    ] {
        let direct = CoordinateSpace::new(Affine {
            tx: value,
            ..Affine::IDENTITY
        });
        let wide = CoordinateSpace {
            domain: Domain::Composed,
            ..direct
        };
        // Original derived float-array equality: NaN remains non-reflexive,
        // and the proof class itself never distinguishes otherwise equal maps.
        assert_eq!(direct == wide, direct.matrix == wide.matrix);
        check(direct, Rect::new(0.0, 0.0, 1.0, 1.0));
    }
    let negative = CoordinateSpace::new(Affine {
        tx: -0.0,
        ..Affine::IDENTITY
    });
    assert_eq!(negative, CoordinateSpace::new(Affine::IDENTITY));
    assert_ne!(
        negative.coefficients()[4].to_bits(),
        CoordinateSpace::new(Affine::IDENTITY).coefficients()[4].to_bits()
    );
    let singular = CoordinateSpace::new(Affine::scale(0.0, 1.0)).compose(Affine::IDENTITY);
    assert_eq!(singular.domain, Domain::Composed);
}

#[test]
fn narrow_extreme_products_and_cancellation_keep_original_bits() {
    let transforms = [
        Affine {
            a: f32::MAX,
            b: 1.0,
            c: -f32::MAX,
            d: 0.0,
            tx: -0.0,
            ty: 0.0,
        },
        Affine {
            a: f32::MAX,
            b: -f32::MAX,
            c: f32::MAX,
            d: f32::MIN_POSITIVE,
            tx: f32::MAX,
            ty: -f32::MAX,
        },
    ];
    let rects = [
        Rect::new(1.0e30, 1.0e30, 1.0e-30, 1.0e-30),
        Rect::new(
            -f32::MAX * 0.25,
            f32::MAX * 0.125,
            f32::MAX * 0.5,
            f32::MAX * 0.25,
        ),
        Rect::new(-0.0, -0.0, f32::from_bits(1), f32::from_bits(1)),
    ];
    for transform in transforms {
        for rect in rects {
            let narrow = CoordinateSpace::new(transform);
            check(narrow, rect);
            check(
                CoordinateSpace {
                    domain: Domain::Composed,
                    ..narrow
                },
                rect,
            );
        }
    }
}

#[test]
fn cached_domain_fits_existing_coordinate_and_spatial_layouts() {
    use std::mem::{align_of, size_of};
    let original_size =
        (size_of::<[f64; 6]>() + size_of::<bool>()).next_multiple_of(align_of::<CoordinateSpace>());
    assert_eq!(size_of::<CoordinateSpace>(), original_size);
    assert_eq!(size_of::<Option<CoordinateSpace>>(), original_size);
    #[cfg(target_pointer_width = "64")]
    {
        assert_eq!(size_of::<CoordinateSpace>(), 56);
        assert_eq!(size_of::<(crate::NodeId, CoordinateSpace)>(), 72);
        assert_eq!(crate::SpatialTree::geometry_record_bytes(), 120);
    }
}
