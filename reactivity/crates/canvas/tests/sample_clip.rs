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
