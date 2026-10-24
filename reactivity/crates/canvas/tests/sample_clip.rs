use gpui_canvas::{Affine, Canvas, Color, Rect, sampled_rect_clip};

fn pixels(rect: Rect, map: Affine, clip: Rect) -> Vec<u8> {
    let mut canvas = Canvas::new(3, 3).unwrap();
    canvas.set_tile_proofs(false);
    canvas.clear(Color::WHITE);
    canvas.fill_rect(rect, map, clip, Color::BLACK).unwrap();
    canvas.pixels().to_vec()
}
#[test]
fn sampled_clips_match_independent_ordinary_canvas_for_signs_ties_and_extreme_inverse() {
    let viewport = Rect::new(0.0, 0.0, 3.0, 3.0);
    let near_cap = (1e-12_f32).next_up();
    for scale in [0.1, 1.0, 1.25, 1e-10, near_cap] {
        for (sx, sy) in [(1.0, 1.0), (-1.0, 1.0), (1.0, -1.0), (-1.0, -1.0)] {
            for shift in [0.0, 0.1, 0.125, 0.375] {
                let map = Affine {
                    a: scale * sx,
                    b: -0.0,
                    c: 0.0,
                    d: scale * sy,
                    tx: shift,
                    ty: shift,
                };
                for rect in [
                    Rect::new(0.0, 0.0, 1.0, 1.0),
                    Rect::new(0.0, 0.0, 1.25, 1.25),
                    Rect::new(0.0, 0.0, 1e-20, 1.0),
                    Rect::new(0.125, -0.25, 1.25, 0.75),
                ] {
                    for parent in [viewport, Rect::new(0.1, 0.0, 0.025, 3.0)] {
                        let clip = sampled_rect_clip(map, rect, parent, [3, 3]).unwrap();
                        let expected = pixels(rect, map, parent);
                        // Oversized identity paint relies ONLY on the lowered
                        // clip; an over-inclusive clip cannot hide in geometry.
                        assert_eq!(
                            pixels(viewport, Affine::IDENTITY, clip),
                            expected,
                            "scale={scale},signs={sx},{sy},shift={shift},rect={rect:?},parent={parent:?}"
                        );
                    }
                }
            }
        }
    }
}
#[test]
fn nested_clips_intersect_exact_sample_sets_and_helper_allocates_nothing() {
    let viewport = Rect::new(0.0, 0.0, 3.0, 3.0);
    let first_map = Affine {
        a: -1.0,
        b: 0.0,
        c: -0.0,
        d: 1.0,
        tx: 0.125,
        ty: 0.0,
    };
    let second_map = Affine::scale(0.1, 0.1);
    let first = Rect::new(0.0, 0.0, 1.0, 1.0);
    let second = Rect::new(0.0, 0.0, 1.25, 1.25);
    for y in 0..12 {
        for x in 0..12 {
            let cell = Rect::new(x as f32 * 0.25, y as f32 * 0.25, 0.25, 0.25);
            let a = pixels(first, first_map, cell);
            let b = pixels(second, second_map, cell);
            let expected = if a.iter().zip(&b).any(|(&a, &b)| a != 255 && b != 255) {
                a
            } else {
                vec![255; 3 * 3 * 4]
            };
            let clip = sampled_rect_clip(first_map, first, cell, [3, 3]).unwrap();
            let clip = sampled_rect_clip(second_map, second, clip, [3, 3]).unwrap();
            let actual = pixels(viewport, Affine::IDENTITY, clip);
            // Alpha is always255; compare RGB, not the alpha padding above.
            assert!(
                actual
                    .as_chunks::<4>()
                    .0
                    .iter()
                    .zip(expected.as_chunks::<4>().0.iter())
                    .all(|(a, b)| a[..3] == b[..3])
            );
        }
    }
    let measured = allocation_counter::measure(|| {
        for _ in 0..100 {
            std::hint::black_box(sampled_rect_clip(first_map, first, viewport, [3, 3]).unwrap());
        }
    });
    assert_eq!(measured.count_total, 0);
    assert!(sampled_rect_clip(Affine::scale(0.0, 1.0), first, viewport, [3, 3]).is_err());
    assert!(sampled_rect_clip(Affine::IDENTITY, first, viewport, [0, 3]).is_err());
}

#[test]
fn prepared_inverse_lowering_preserves_canonical_ties_without_forward_roundtrip() {
    let clip = Rect::new(0.0, 0.0, 33.0, 17.0);
    let mut canvas = Canvas::recording(33, 17, Default::default()).unwrap();
    canvas
        .fill_rect(
            Rect::new(0.0, 0.0, 8.5, 17.0),
            Affine::scale(1.25, 0.75),
            clip,
            Color::BLACK,
        )
        .unwrap();
    let mut draw = canvas.prepared_scene().draws().next().unwrap();
    let original = draw.sampled_rect_clip([33, 17]).unwrap();
    assert_eq!(
        original,
        sampled_rect_clip(Affine::scale(1.25, 0.75), draw.local_rect, clip, [33, 17]).unwrap()
    );
    assert_eq!(original.width, 10.5);
    draw.inverse[0] = draw.inverse[0].next_down();
    assert_eq!(draw.sampled_rect_clip([33, 17]).unwrap().width, 10.5);
    draw.inverse[0] = draw.inverse[0].next_down();
    assert_eq!(draw.sampled_rect_clip([33, 17]).unwrap().width, 10.75);
    for inverse in [
        [0.0; 6],
        [1.0, 0.125, 0.0, 1.0, 0.0, 0.0],
        [f64::NAN, 0.0, 0.0, 1.0, 0.0, 0.0],
        [1e13, 0.0, 0.0, 1.0, 0.0, 0.0],
    ] {
        draw.inverse = inverse;
        assert!(draw.sampled_rect_clip([33, 17]).is_err());
    }
}

#[test]
fn prepared_cuts_match_frozen_prechange_binary_search() {
    use gpui_canvas::{PreparedDraw, PreparedSource};
    fn rect(fields: &[&str]) -> Rect {
        let [x, y, width, height] =
            std::array::from_fn(|i| f32::from_bits(u32::from_str_radix(fields[i], 16).unwrap()));
        Rect::new(x, y, width, height)
    }
    let mut count = 0;
    for (index, line) in include_str!("fixtures/sample-clip-cuts.csv")
        .lines()
        .enumerate()
    {
        let fields: Vec<_> = line.split(',').collect();
        assert_eq!(fields.len(), 21);
        let viewport = [fields[1].parse().unwrap(), fields[2].parse().unwrap()];
        let inverse = std::array::from_fn(|i| {
            f64::from_bits(u64::from_str_radix(fields[3 + i], 16).unwrap())
        });
        let draw = PreparedDraw {
            local_rect: rect(&fields[9..13]),
            inverse,
            clip: rect(&fields[13..17]),
            bounds: Rect::default(),
            color: [0.0; 4],
            source: PreparedSource::Solid,
        };
        let actual = draw.sampled_rect_clip(viewport).unwrap();
        let expected = rect(&fields[17..21]);
        assert_eq!(
            [actual.x, actual.y, actual.width, actual.height].map(f32::to_bits),
            [expected.x, expected.y, expected.width, expected.height].map(f32::to_bits),
            "frozen case {index}: {}",
            fields[0]
        );
        count += 1;
    }
    assert_eq!(count, 22_296);
}

#[test]
fn handcrafted_prepared_inverse_cuts_match_scalar_membership() {
    use gpui_canvas::{PreparedDraw, PreparedSource};
    let [width, height] = [9, 5];
    let sides = [width, height];
    for scale in [
        f64::from_bits(1),
        f64::MIN_POSITIVE,
        0.8_f64.next_down(),
        0.8,
        1e12,
    ] {
        for sign in [-1.0, 1.0] {
            for zero in [-0.0, 0.0] {
                for translation in [-0.0, 0.0, -1e-308, 8.5] {
                    let draw = PreparedDraw {
                        local_rect: Rect::new(-0.0, 0.0, 8.5, 3.0),
                        inverse: [
                            scale * sign,
                            zero,
                            -zero,
                            scale * sign,
                            translation,
                            -translation,
                        ],
                        clip: Rect::new(-0.0, 0.0, width as f32, height as f32),
                        bounds: Rect::default(),
                        color: [0.0; 4],
                        source: PreparedSource::Solid,
                    };
                    let lowered = draw.sampled_rect_clip(sides).unwrap();
                    for y in 0..height * 4 {
                        for x in 0..width * 4 {
                            let wx = x as f64 * 0.25 + 0.125;
                            let wy = y as f64 * 0.25 + 0.125;
                            let [a, b, c, d, tx, ty] = draw.inverse;
                            let lx = a * wx + c * wy + tx;
                            let ly = b * wx + d * wy + ty;
                            let canonical = lx >= 0.0 && lx < 8.5 && ly >= 0.0 && ly < 3.0;
                            let lowered = wx >= lowered.x as f64
                                && wx < lowered.x as f64 + lowered.width as f64
                                && wy >= lowered.y as f64
                                && wy < lowered.y as f64 + lowered.height as f64;
                            assert_eq!(
                                canonical, lowered,
                                "inverse={:?}, sample=({x},{y})",
                                draw.inverse
                            );
                        }
                    }
                }
            }
        }
    }
}
