use gpui_canvas::{Affine, Canvas, Color, DamageRegion, Point, Rect, TextRunSlot, TextSystem};

const SIZE: [u32; 2] = [320, 96];
const CLIP: Rect = Rect::new(1.25, 0.5, 310.5, 90.25);

fn scene(
    canvas: &mut Canvas,
    text: &mut TextSystem,
    value: &str,
    origin: Point,
    transform: Affine,
    scale: f32,
) -> TextRunSlot {
    let layout = text.shape(value, 16., None).unwrap();
    let reservoir = text.shape("0123456789", 16., None).unwrap();
    let mut stage = canvas.stage();
    stage.clear(Color::rgb(23, 31, 47));
    let slot = stage
        .draw_text_scaled_tracked(text, &layout, origin, transform, CLIP, Color::WHITE, scale)
        .unwrap()
        .unwrap();
    stage
        .draw_text_scaled(
            text,
            &reservoir,
            Point { x: 4., y: 60. },
            transform,
            CLIP,
            Color::WHITE,
            scale,
        )
        .unwrap();
    stage.commit();
    slot
}
fn pixels(canvas: &mut Canvas) -> Vec<u32> {
    let mut p = vec![0; (SIZE[0] * SIZE[1]) as usize];
    canvas.render_bgrx(&mut p).unwrap();
    p
}

#[test]
fn precise_support_repairs_every_pixel_and_identical_runs_are_empty() {
    for scale in [1., 1.25] {
        for transform in [
            Affine::IDENTITY,
            Affine {
                a: -1.,
                b: 0.,
                c: 0.,
                d: 1.,
                tx: 319.,
                ty: 0.25,
            },
        ] {
            let mut text = TextSystem::bundled().unwrap();
            let mut canvas = Canvas::recording(SIZE[0], SIZE[1], Default::default()).unwrap();
            let mut full = Canvas::recording(SIZE[0], SIZE[1], Default::default()).unwrap();
            let mut origin = Point { x: 4.25, y: 3.5 };
            let slot = scene(
                &mut canvas,
                &mut text,
                "000000000000",
                origin,
                transform,
                scale,
            );
            let mut output = pixels(&mut canvas);
            for (value, shift) in [
                ("000000000001", 0.),
                ("000000000001", 0.),
                ("000000000009", 0.),
                ("000000000009", 0.125),
                ("000000000000", 0.),
            ] {
                origin.x += shift;
                let layout = text.shape(value, 16., None).unwrap();
                let mut regions = Vec::new();
                let damage = canvas
                    .try_patch_text_observed(
                        slot,
                        &mut text,
                        &layout,
                        origin,
                        transform,
                        CLIP,
                        Color::WHITE,
                        scale,
                        |d| regions.push(d),
                    )
                    .unwrap()
                    .unwrap();
                scene(&mut full, &mut text, value, origin, transform, scale);
                let expected = pixels(&mut full);
                let union = regions
                    .iter()
                    .fold(DamageRegion::default(), |a, &b| a.union(b));
                assert_eq!(damage, union);
                for (i, (a, b)) in output.iter().zip(&expected).enumerate() {
                    if a != b {
                        let (x, y) = (i as u32 % SIZE[0], i as u32 / SIZE[0]);
                        assert!(
                            regions.iter().any(|d| d
                                .bounds()
                                .is_some_and(|[l, t, r, b]| x >= l && x < r && y >= t && y < b)),
                            "missing changed pixel {x},{y}"
                        );
                    }
                }
                for region in regions {
                    canvas.render_bgrx_region(&mut output, region).unwrap();
                }
                assert_eq!(output, expected);
                assert_eq!(pixels(&mut canvas), expected);
                let mut observed = 0;
                assert!(
                    canvas
                        .try_patch_text_observed(
                            slot,
                            &mut text,
                            &layout,
                            origin,
                            transform,
                            CLIP,
                            Color::WHITE,
                            scale,
                            |_| observed += 1
                        )
                        .unwrap()
                        .unwrap()
                        .is_empty()
                );
                assert_eq!(observed, 0);
            }
        }
    }
}

#[test]
fn rejection_and_panicking_observer_preserve_the_complete_scene() {
    let mut text = TextSystem::bundled().unwrap();
    let mut canvas = Canvas::recording(SIZE[0], SIZE[1], Default::default()).unwrap();
    let origin = Point { x: 4., y: 3. };
    let slot = scene(
        &mut canvas,
        &mut text,
        "000000000000",
        origin,
        Affine::IDENTITY,
        1.,
    );
    let before = pixels(&mut canvas);
    let layout = text.shape("000000000001", 16., None).unwrap();
    let result = std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| {
        canvas.try_patch_text_observed(
            slot,
            &mut text,
            &layout,
            origin,
            Affine::IDENTITY,
            CLIP,
            Color::WHITE,
            1.,
            |_| panic!("observer abort"),
        )
    }));
    assert!(result.is_err());
    assert_eq!(pixels(&mut canvas), before);
    let mut observed = 0;
    assert!(
        canvas
            .try_patch_text_observed(
                slot,
                &mut text,
                &layout,
                origin,
                Affine::translation(1., 0.),
                CLIP,
                Color::WHITE,
                1.,
                |_| observed += 1
            )
            .unwrap()
            .is_none()
    );
    assert_eq!(observed, 0);
    assert_eq!(pixels(&mut canvas), before);
    let new_mask = text.shape("00000000000Ω", 16., None).unwrap();
    assert!(
        canvas
            .try_patch_text_observed(
                slot,
                &mut text,
                &new_mask,
                origin,
                Affine::IDENTITY,
                CLIP,
                Color::WHITE,
                1.,
                |_| observed += 1
            )
            .unwrap()
            .is_none()
    );
    assert_eq!(observed, 0);
    assert_eq!(pixels(&mut canvas), before);
}
