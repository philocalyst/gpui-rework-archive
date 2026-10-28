use gpui_canvas::{Affine, Canvas, Color, DamageRegion, Point, Rect, TextSystem};
const SIZE: [u32; 2] = [192, 120];
const CLIP: Rect = Rect::new(0.25, 0.5, 191.25, 119.);

fn pixels(canvas: &mut Canvas) -> Vec<u32> {
    let mut out = vec![0; (SIZE[0] * SIZE[1]) as usize];
    canvas.render_bgrx(&mut out).unwrap();
    out
}
fn repair(canvas: &mut Canvas, old: &mut [u32], next: &[u32], damage: DamageRegion) {
    for (index, (a, b)) in old.iter().zip(next).enumerate() {
        if a != b {
            let [l, t, r, b] = damage.bounds().expect("changed pixel needs support");
            let x = index as u32 % SIZE[0];
            let y = index as u32 / SIZE[0];
            assert!(
                x >= l && x < r && y >= t && y < b,
                "lost reverse mismatch at {x},{y}"
            );
        }
    }
    canvas.render_bgrx_region(old, damage).unwrap();
    assert_eq!(old, next);
}
fn shapes(canvas: &mut Canvas, ids: &[u32]) -> DamageRegion {
    let mut scene = canvas.stage();
    scene.clear(Color::WHITE);
    for &id in ids {
        let (x, y) = if id == 90 {
            (142., 84.)
        } else {
            ((id % 4) as f32 * 9. + 2., (id / 4) as f32 * 7. + 2.)
        };
        scene
            .fill_rect(
                Rect::new(x, y, 22.5, 19.25),
                Affine::IDENTITY,
                CLIP,
                Color::linear_display_p3(0.1 * (id % 7) as f32, 0.3, 0.8, 0.6).unwrap(),
            )
            .unwrap();
    }
    scene.commit_with_damage()
}
#[test]
fn unequal_streams_keep_every_changed_pixel_and_exclude_equal_distant_suffix() {
    for proofs in [false, true] {
        let mut canvas = Canvas::recording(SIZE[0], SIZE[1], Default::default()).unwrap();
        canvas.set_tile_proofs(proofs);
        shapes(&mut canvas, &[1, 90]);
        let mut old = pixels(&mut canvas);
        for ids in [
            vec![1, 2, 3, 90],
            vec![1, 90],
            vec![90],
            vec![1, 2, 90],
            vec![3, 2, 90],
            vec![1],
            vec![],
            vec![1, 2, 90],
            vec![2, 1, 90],
        ] {
            let damage = shapes(&mut canvas, &ids);
            let mut fresh = Canvas::recording(SIZE[0], SIZE[1], Default::default()).unwrap();
            shapes(&mut fresh, &ids);
            repair(&mut canvas, &mut old, &pixels(&mut fresh), damage);
        }
        shapes(&mut canvas, &[1, 90]);
        let damage = shapes(&mut canvas, &[1, 2, 90]);
        assert!(
            damage.bounds().unwrap()[2] < 100,
            "unchanged suffix inflated damage"
        );
        let damage = shapes(&mut canvas, &[1, 90]);
        assert!(damage.bounds().unwrap()[2] < 100, "removal inflated damage");
    }
}
fn text_scene(
    canvas: &mut Canvas,
    text: &mut TextSystem,
    value: &str,
    transform: Affine,
) -> DamageRegion {
    let layout = text.shape(value, 14., None).unwrap();
    let suffix = text.shape("retained 0123456789", 14., None).unwrap();
    let mut scene = canvas.stage();
    scene.clear(Color::rgb(23, 31, 47));
    scene
        .draw_text_scaled(
            text,
            &layout,
            Point { x: 3.25, y: 2.5 },
            transform,
            CLIP,
            Color::WHITE,
            1.,
        )
        .unwrap();
    scene
        .draw_text_scaled(
            text,
            &suffix,
            Point { x: 3.25, y: 84.5 },
            transform,
            CLIP,
            Color::WHITE,
            1.,
        )
        .unwrap();
    scene.commit_with_damage()
}
#[test]
fn growing_and_shrinking_glyph_runs_retain_clipped_transformed_suffix() {
    for transform in [
        Affine::IDENTITY,
        Affine {
            a: -1.,
            b: 0.,
            c: 0.1,
            d: 1.,
            tx: 185.,
            ty: 0.25,
        },
    ] {
        let mut text = TextSystem::bundled().unwrap();
        let mut canvas = Canvas::recording(SIZE[0], SIZE[1], Default::default()).unwrap();
        text_scene(&mut canvas, &mut text, "", transform);
        let mut old = pixels(&mut canvas);
        for value in ["1", "123456", "1234567890", "12", "", "99", "98"] {
            let damage = text_scene(&mut canvas, &mut text, value, transform);
            let mut fresh = Canvas::recording(SIZE[0], SIZE[1], Default::default()).unwrap();
            text_scene(&mut fresh, &mut text, value, transform);
            repair(&mut canvas, &mut old, &pixels(&mut fresh), damage);
            if let Some([_, _, _, bottom]) = damage.bounds() {
                assert!(bottom < 80, "unchanged glyph suffix inflated damage");
            }
        }
    }
}
