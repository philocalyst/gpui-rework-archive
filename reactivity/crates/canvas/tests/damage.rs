use gpui_canvas::{Affine, Canvas, Color, ColorConfig, DamageRegion, Point, Rect, TextSystem};

const WIDTH: usize = 79;
const HEIGHT: usize = 53;

#[derive(Clone, Copy)]
struct Draw {
    rect: Rect,
    transform: Affine,
    color: Color,
}
fn stage(canvas: &mut Canvas, draws: &[Draw], clear: Color) -> DamageRegion {
    let mut candidate = canvas.stage();
    candidate.clear(clear);
    for draw in draws {
        candidate
            .fill_rect(
                draw.rect,
                draw.transform,
                Rect::new(0.3, 0.7, WIDTH as f32 - 1.0, HEIGHT as f32 - 1.0),
                draw.color,
            )
            .unwrap();
    }
    candidate.commit_with_damage()
}
fn full(canvas: &mut Canvas) -> Vec<u32> {
    let mut output = vec![0xdeadbeef; WIDTH * HEIGHT];
    canvas.render_bgrx(&mut output).unwrap();
    output
}
fn assert_support(previous: &[u32], next: &[u32], damage: DamageRegion) {
    for (index, (old, new)) in previous.iter().zip(next).enumerate() {
        if old != new {
            let [left, top, right, bottom] = damage.bounds().expect("changed pixel has support");
            let (x, y) = ((index % WIDTH) as u32, (index / WIDTH) as u32);
            assert!(x >= left && x < right && y >= top && y < bottom);
        }
    }
}
fn repair(canvas: &mut Canvas, output: &mut [u32], damage: DamageRegion) {
    let expected = full(canvas);
    assert_support(output, &expected, damage);
    canvas.render_bgrx_region(output, damage).unwrap();
    assert_eq!(output, expected);
    assert_eq!(canvas.output_bytes(), 0, "no second full-frame image");
}
fn draw(index: u32) -> Draw {
    Draw {
        rect: Rect::new(-1.3, -0.7, 13.7, 9.1),
        transform: Affine {
            a: if index.is_multiple_of(2) { -1.0 } else { 1.0 },
            b: (index % 3) as f32 * 0.13,
            c: -0.17,
            d: 1.0,
            tx: (index * 17 % 65) as f32 + 3.3,
            ty: (index * 11 % 39) as f32 + 1.7,
        },
        color: Color::linear_display_p3(
            (index % 7) as f32 * 0.4,
            -0.1,
            (index % 5) as f32 * 0.3,
            0.7,
        )
        .unwrap(),
    }
}

#[test]
fn insert_remove_reorder_and_transformed_color_edits_repair_every_pixel() {
    for proofs in [false, true] {
        let mut canvas =
            Canvas::recording(WIDTH as u32, HEIGHT as u32, Default::default()).unwrap();
        canvas.set_tile_proofs(proofs);
        stage(&mut canvas, &[draw(1), draw(2)], Color::WHITE);
        let mut output = full(&mut canvas);
        for draws in [
            vec![draw(1)], // The unmatched old tail must not be consumed by zip.
            vec![],
            vec![draw(3), draw(4), draw(5)],
            vec![draw(5), draw(4), draw(3)],
            vec![draw(5), draw(4), draw(7)],
        ] {
            let damage = stage(&mut canvas, &draws, Color::WHITE);
            repair(&mut canvas, &mut output, damage);
        }
        for index in 0..32 {
            let draws = (0..index % 9).map(|i| draw(index + i)).collect::<Vec<_>>();
            let damage = stage(&mut canvas, &draws, Color::WHITE);
            repair(&mut canvas, &mut output, damage);
        }
    }
}

#[test]
fn a_small_repair_at_a_distant_origin_needs_only_local_bins() {
    let mut canvas = Canvas::recording(1280, 720, ColorConfig::default()).unwrap();
    let mut reference = Canvas::recording(1280, 720, ColorConfig::default()).unwrap();
    let viewport = Rect::new(0.0, 0.0, 1280.0, 720.0);
    let describe = |canvas: &mut Canvas, x| {
        let mut candidate = canvas.stage();
        candidate.clear(Color::WHITE);
        candidate
            .fill_rect(
                Rect::new(x, 650.0, 2.0, 17.0),
                Affine::IDENTITY,
                viewport,
                Color::BLACK,
            )
            .unwrap();
        candidate.commit_with_damage()
    };
    describe(&mut canvas, 1100.0);
    describe(&mut reference, 1100.0);
    let mut output = vec![0; 1280 * 720];
    reference.render_bgrx(&mut output).unwrap();
    let damage = describe(&mut canvas, 1101.0);
    describe(&mut reference, 1101.0);
    let mut expected = output.clone();
    reference.render_bgrx(&mut expected).unwrap();
    canvas.render_bgrx_region(&mut output, damage).unwrap();
    assert_eq!(output, expected);
    assert!(canvas.stats().bin_bytes <= 128);
    assert!(canvas.stats().tile_references <= 2);
    assert_eq!(canvas.stats().output_bands, 2);
    assert_eq!(canvas.output_bytes(), 0);
}

#[test]
fn unpresented_edits_union_without_retaining_the_intermediate_scene() {
    let mut canvas = Canvas::recording(WIDTH as u32, HEIGHT as u32, Default::default()).unwrap();
    stage(&mut canvas, &[draw(1)], Color::WHITE);
    let mut output = full(&mut canvas);
    let first = stage(&mut canvas, &[draw(2)], Color::WHITE);
    let second = stage(&mut canvas, &[draw(3)], Color::WHITE);
    repair(&mut canvas, &mut output, first.union(second));
    let clear = stage(&mut canvas, &[draw(3)], Color::BLACK);
    assert_eq!(clear.bounds(), Some([0, 0, WIDTH as u32, HEIGHT as u32]));
    repair(&mut canvas, &mut output, clear);
}

#[test]
fn identical_leased_text_is_empty_and_moved_text_repairs_old_and_new_support() {
    let mut text = TextSystem::bundled().unwrap();
    let layout = text.shape("office café", 13.5, None).unwrap();
    let mut canvas = Canvas::recording(WIDTH as u32, HEIGHT as u32, Default::default()).unwrap();
    let mut describe = |canvas: &mut Canvas, x| {
        let mut candidate = canvas.stage();
        candidate.clear(Color::WHITE);
        candidate
            .draw_text(
                &mut text,
                &layout,
                Point { x, y: 4.3 },
                Affine::IDENTITY,
                Rect::new(0.0, 0.0, WIDTH as f32, HEIGHT as f32),
                Color::BLACK,
            )
            .unwrap();
        candidate.commit_with_damage()
    };
    describe(&mut canvas, 0.7);
    let mut output = full(&mut canvas);
    let equal = describe(&mut canvas, 0.7);
    assert!(equal.is_empty());
    let previous_count = canvas.stats().render_count;
    canvas.render_bgrx_region(&mut output, equal).unwrap();
    assert_eq!(canvas.stats().render_count, previous_count);
    assert_eq!(canvas.stats().sample_tests, 0);
    let changed = describe(&mut canvas, 15.3);
    assert!(!changed.is_empty());
    repair(&mut canvas, &mut output, changed);
}

#[test]
fn hdr_support_uses_unquantized_working_colors() {
    let config = ColorConfig::linear_hdr(gpui_canvas::OutputProfile::DisplayP3, 203.0).unwrap();
    let mut canvas = Canvas::recording(WIDTH as u32, HEIGHT as u32, config).unwrap();
    stage(&mut canvas, &[draw(1)], Color::WHITE);
    let before = canvas.pixels().to_vec();
    let damage = stage(&mut canvas, &[draw(6)], Color::WHITE);
    let next = canvas.pixels();
    let [left, top, right, bottom] = damage.bounds().unwrap();
    for (index, (old, new)) in before.chunks_exact(8).zip(next.chunks_exact(8)).enumerate() {
        if old != new {
            let (x, y) = ((index % WIDTH) as u32, (index / WIDTH) as u32);
            assert!(x >= left && x < right && y >= top && y < bottom);
        }
    }
}

#[test]
fn hdr_sample_promotion_matches_the_uncompressed_path() {
    let config = ColorConfig::linear_hdr(gpui_canvas::OutputProfile::Srgb, 203.0).unwrap();
    let mut canvas = Canvas::with_color_config(33, 17, config).unwrap();
    let clip = Rect::new(0.0, 0.0, 33.0, 17.0);
    canvas.clear(Color::linear_srgb(-0.0, 0.0, -0.0, 1.0).unwrap());
    for (rect, color) in [
        (
            Rect::new(0.0, 0.0, 16.0, 17.0),
            Color::linear_srgb(-0.0, 0.25, 2.0, 1.0).unwrap(),
        ),
        (
            Rect::new(6.25, 2.5, 12.5, 13.0),
            Color::linear_srgb(3.0, -0.125, 0.0, 0.5).unwrap(),
        ),
        (
            Rect::new(8.0, 3.0, 15.0, 7.0),
            Color::linear_srgb(0.125, 0.5, 5.0, 0.75).unwrap(),
        ),
    ] {
        canvas
            .fill_rect(rect, Affine::IDENTITY, clip, color)
            .unwrap();
    }
    let collapsed = canvas.pixels().to_vec();
    canvas.set_tile_proofs(false);
    assert_eq!(canvas.pixels(), collapsed);
}

#[cfg(feature = "parallel")]
#[test]
fn disjoint_workers_repair_the_same_tiles_without_touching_other_bands() {
    use gpui_canvas::RenderPool;
    let mut canvas = Canvas::recording(WIDTH as u32, HEIGHT as u32, Default::default()).unwrap();
    stage(&mut canvas, &[draw(1)], Color::WHITE);
    let before = full(&mut canvas);
    let damage = stage(&mut canvas, &[draw(2)], Color::WHITE);
    let expected = full(&mut canvas);
    for workers in [1, 2, 4] {
        let pool = RenderPool::new(workers).unwrap().with_min_work(0);
        let mut output = before.clone();
        canvas
            .render_bgrx_region_with(&mut output, damage, &pool)
            .unwrap();
        assert_eq!(output, expected);
        assert!(canvas.stats().parallel);
    }
}

#[test]
fn randomized_repairs_cross_partial_tile_and_viewport_edges() {
    fn next(seed: &mut u64) -> u32 {
        *seed = seed
            .wrapping_mul(6364136223846793005)
            .wrapping_add(1442695040888963407);
        (*seed >> 32) as u32
    }
    fn scalar(seed: &mut u64, range: f32) -> f32 {
        (next(seed) % 10001) as f32 / 10000.0 * range
    }
    let mut seed = 8128973;
    for (width, height) in [
        (1, 1),
        (15, 17),
        (16, 16),
        (17, 31),
        (32, 33),
        (79, 53),
        (97, 81),
    ] {
        for proofs in [false, true] {
            let mut canvas = Canvas::recording(width, height, Default::default()).unwrap();
            canvas.set_tile_proofs(proofs);
            let mut pixels = vec![0; (width * height) as usize];
            canvas.clear(Color::WHITE);
            canvas.render_bgrx(&mut pixels).unwrap();
            for turn in 0..120 {
                let mut candidate = canvas.stage();
                candidate.clear(if turn % 23 == 0 {
                    Color::BLACK
                } else {
                    Color::WHITE
                });
                for _ in 0..next(&mut seed) % 18 {
                    let rect = Rect::new(
                        scalar(&mut seed, 15.0) - 7.0,
                        scalar(&mut seed, 15.0) - 7.0,
                        scalar(&mut seed, 30.0) + 0.01,
                        scalar(&mut seed, 30.0) + 0.01,
                    );
                    let transform = Affine {
                        a: if next(&mut seed).is_multiple_of(2) {
                            1.0
                        } else {
                            -1.0
                        },
                        b: scalar(&mut seed, 1.0) - 0.5,
                        c: scalar(&mut seed, 1.0) - 0.5,
                        d: 1.0,
                        tx: scalar(&mut seed, width as f32 + 30.0) - 15.0,
                        ty: scalar(&mut seed, height as f32 + 30.0) - 15.0,
                    };
                    let clip = Rect::new(
                        scalar(&mut seed, width as f32),
                        scalar(&mut seed, height as f32),
                        scalar(&mut seed, width as f32),
                        scalar(&mut seed, height as f32),
                    );
                    let color = Color::rgba(
                        next(&mut seed) as u8,
                        next(&mut seed) as u8,
                        next(&mut seed) as u8,
                        next(&mut seed) as u8,
                    );
                    candidate.fill_rect(rect, transform, clip, color).unwrap();
                }
                let damage = candidate.commit_with_damage();
                let mut expected = vec![0; pixels.len()];
                canvas.render_bgrx(&mut expected).unwrap();
                for (index, (old, new)) in pixels.iter().zip(&expected).enumerate() {
                    if old != new {
                        let [left, top, right, bottom] = damage.bounds().expect("changed support");
                        let x = index as u32 % width;
                        let y = index as u32 / width;
                        assert!(x >= left && x < right && y >= top && y < bottom);
                    }
                }
                canvas.render_bgrx_region(&mut pixels, damage).unwrap();
                assert_eq!(
                    pixels, expected,
                    "{width}×{height}, proofs={proofs}, turn={turn}"
                );
            }
        }
    }
}
