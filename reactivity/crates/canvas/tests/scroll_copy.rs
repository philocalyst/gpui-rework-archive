use gpui_canvas::{Affine, Canvas, CanvasScene, Color, Point, Rect, ScrollCopy, TextSystem};

const WIDTH: usize = 80;
const HEIGHT: usize = 64;
const VIEW: [u32; 4] = [5, 7, 65, 55];

fn scene<'a>(
    canvas: &'a mut Canvas,
    text: &mut TextSystem,
    offset: f32,
    labels: bool,
    header: u8,
    changed_row: bool,
    overlay: bool,
) -> CanvasScene<'a> {
    let mut scene = canvas.stage();
    scene.clear(Color::BLACK);
    scene
        .fill_rect(
            Rect::new(0., 0., 80., 64.),
            Affine::IDENTITY,
            Rect::new(0., 0., 80., 64.),
            Color::WHITE,
        )
        .unwrap();
    scene
        .fill_rect(
            Rect::new(1., 1., 20., 4.),
            Affine::IDENTITY,
            Rect::new(0., 0., 80., 64.),
            Color::rgb(header, 40, 70),
        )
        .unwrap();
    let clip = Rect::new(5., 7., 60., 48.);
    for row in 0..20 {
        let y = 7. + row as f32 * 12. - offset;
        let color = if changed_row && row == 2 {
            Color::BLACK
        } else {
            Color::linear_srgb(0.1 + (row % 3) as f32 * 0.2, 0.3, 0.4, 0.7).unwrap()
        };
        scene
            .fill_rect(
                Rect::new(0., 0., 60., 12.),
                Affine::translation(5., y),
                clip,
                color,
            )
            .unwrap();
        if labels {
            let layout = text.shape(&format!("row {row}"), 9., None).unwrap();
            scene
                .draw_text(
                    text,
                    &layout,
                    Point { x: 0., y: 0. },
                    Affine::translation(7., y + 1.),
                    clip,
                    Color::BLACK,
                )
                .unwrap();
        }
    }
    if overlay {
        scene
            .fill_rect(
                Rect::new(20., 20., 10., 10.),
                Affine::IDENTITY,
                clip,
                Color::BLACK,
            )
            .unwrap();
    }
    scene
}
fn full(canvas: &mut Canvas) -> Vec<u32> {
    let mut pixels = vec![0; WIDTH * HEIGHT];
    canvas.render_bgrx(&mut pixels).unwrap();
    pixels
}
fn apply(canvas: &mut Canvas, pixels: &mut [u32], plan: ScrollCopy) {
    let [sx, sy, sr, sb] = plan.source();
    let [dx, dy, dr, db] = plan.destination();
    assert_eq!((sr - sx, sb - sy), (dr - dx, db - dy));
    let prior = pixels.to_vec();
    for y in 0..sb - sy {
        for x in 0..sr - sx {
            pixels[(dy + y) as usize * WIDTH + (dx + x) as usize] =
                prior[(sy + y) as usize * WIDTH + (sx + x) as usize];
        }
    }
    for &repair in plan.repairs() {
        canvas.render_bgrx_region(pixels, repair).unwrap();
    }
}

#[test]
fn exact_scroll_copy_and_other_damage_match_complete_pixels() {
    for labels in [false, true] {
        let mut canvas =
            Canvas::recording(WIDTH as u32, HEIGHT as u32, Default::default()).unwrap();
        let mut text = TextSystem::bundled().unwrap();
        scene(&mut canvas, &mut text, 0., labels, 0, false, false).commit();
        let mut pixels = full(&mut canvas);
        let mut offset = 0;
        for (tick, next) in [6, 12, 24, 18, 0, 40, 7].into_iter().enumerate() {
            let (_, plan) = scene(
                &mut canvas,
                &mut text,
                next as f32,
                labels,
                tick as u8 + 1,
                false,
                false,
            )
            .commit_with_scroll_damage(VIEW, offset - next);
            let plan = plan.expect("supported translated rows must certify");
            apply(&mut canvas, &mut pixels, plan);
            assert!(
                pixels == full(&mut canvas),
                "labels={labels}, {offset}->{next}"
            );
            offset = next;
        }
    }
}

#[test]
fn changed_overlap_stationary_overlay_fractional_maps_and_bad_proposals_fall_back() {
    let mut text = TextSystem::bundled().unwrap();
    for (changed, overlay, offset, bounds, delta) in [
        (true, false, 6., VIEW, -6),
        (false, true, 6., VIEW, -6),
        (false, false, 6.5, VIEW, -6),
        (false, false, 6., [5, 7, 81, 55], -6),
        (false, false, 6., VIEW, i32::MIN),
        (false, false, 6., VIEW, 0),
        (false, false, 6., VIEW, -48),
        (false, false, 6., VIEW, -5),
    ] {
        let mut canvas =
            Canvas::recording(WIDTH as u32, HEIGHT as u32, Default::default()).unwrap();
        scene(&mut canvas, &mut text, 0., true, 0, false, overlay).commit();
        let mut pixels = full(&mut canvas);
        let (damage, plan) = scene(&mut canvas, &mut text, offset, true, 1, changed, overlay)
            .commit_with_scroll_damage(bounds, delta);
        assert!(
            plan.is_none(),
            "changed={changed}, overlay={overlay}, offset={offset}, delta={delta}"
        );
        canvas.render_bgrx_region(&mut pixels, damage).unwrap();
        assert!(pixels == full(&mut canvas));
    }
}

#[test]
fn moved_reused_gradient_falls_back_before_staged_lease_transfer() {
    use gpui_canvas::{Extend, Gradient, GradientGeometry, GradientStop, Interpolation};
    let gradient = Gradient::new(
        GradientGeometry::Linear {
            start: Point::default(),
            end: Point { x: 1., y: 0. },
        },
        &[
            GradientStop::new(0., Color::BLACK),
            GradientStop::new(1., Color::WHITE),
        ],
        Extend::Pad,
        Interpolation::LinearSrgb,
    )
    .unwrap();
    let mut canvas = Canvas::recording(WIDTH as u32, HEIGHT as u32, Default::default()).unwrap();
    let clip = Rect::new(0., 0., WIDTH as f32, HEIGHT as f32);
    let mut before = canvas.stage();
    before.clear(Color::WHITE);
    before
        .fill_gradient(
            &gradient,
            Rect::new(5., 1., 10., 4.),
            0.,
            Affine::IDENTITY,
            clip,
        )
        .unwrap();
    before.commit();
    let mut pixels = full(&mut canvas);
    let mut after = canvas.stage();
    after.clear(Color::WHITE);
    after
        .fill_gradient(
            &gradient,
            Rect::new(5., 20., 10., 4.),
            0.,
            Affine::IDENTITY,
            clip,
        )
        .unwrap();
    let (damage, plan) = after.commit_with_scroll_damage(VIEW, -6);
    assert!(plan.is_none());
    canvas.render_bgrx_region(&mut pixels, damage).unwrap();
    assert!(pixels == full(&mut canvas));
}
