//! Staged reuse is checked against the independent ordinary recording path.
use gpui_canvas::{Affine, Canvas, Color, Point, Rect, TextSystem};

#[test]
fn forward_transform_change_revokes_previous_witness_bounds() {
    let mut text = TextSystem::bundled().unwrap();
    let layout = text.shape("Wide witness", 14., None).unwrap();
    let mut canvas = Canvas::new(192, 64).unwrap();
    let clip = Rect::new(0., 0., 192., 64.);
    for x in [0., 0., 90., 90., -15., -15.] {
        let map = Affine::translation(x, 0.);
        let origin = Point { x: 0., y: 0. };
        let mut stage = canvas.stage();
        stage.clear(Color::WHITE);
        stage
            .draw_text_scaled(&mut text, &layout, origin, map, clip, Color::BLACK, 1.)
            .unwrap();
        stage.commit();
        let mut fresh = Canvas::new(192, 64).unwrap();
        fresh.clear(Color::WHITE);
        fresh
            .draw_text(&mut text, &layout, origin, map, clip, Color::BLACK)
            .unwrap();
        assert_eq!(canvas.pixels(), fresh.pixels(), "translation={x}");
    }
}

#[test]
fn staged_text_matches_fresh_admission_across_certificate_changes() {
    let mut text = TextSystem::bundled().unwrap();
    let layouts: Vec<_> = [
        "Count: 1",
        "Count: 123456",
        "static text",
        "héllo אבג",
        "x",
        "",
    ]
    .iter()
    .map(|s| text.shape(s, 13., Some(90.)).unwrap())
    .collect();
    let full = Rect::new(0., 0., 128., 80.);
    let mut canvas = Canvas::new(128, 80).unwrap();
    for pass in 0..32 {
        let transform = match pass % 4 {
            0 => Affine::IDENTITY,
            1 => Affine::translation(30., 0.),
            2 => Affine {
                a: 0.9,
                b: 0.1,
                c: -0.2,
                d: 1.1,
                tx: 12.,
                ty: 2.,
            },
            _ => Affine {
                a: -1.,
                b: 0.,
                c: 0.,
                d: 1.,
                tx: 110.,
                ty: 0.,
            },
        };
        let clip = if pass % 3 == 0 {
            Rect::new(22., 0., 70., 80.)
        } else {
            full
        };
        let scale = [1., 1., 1.25, 2.][pass % 4];
        let color = if pass % 5 == 0 {
            Color::rgba(230, 10, 100, 97)
        } else {
            Color::BLACK
        };
        // Each configuration repeats, so hits and invalidations both execute.
        for repeat in 0..2 {
            let mut fresh = Canvas::new(128, 80).unwrap();
            let mut staged = canvas.stage();
            staged.clear(Color::WHITE);
            fresh.clear(Color::WHITE);
            for (i, layout) in layouts.iter().enumerate() {
                let origin = Point {
                    x: (i % 2) as f32 * 3.,
                    y: (i / 2) as f32 * 22.,
                };
                staged
                    .draw_text_scaled(&mut text, layout, origin, transform, clip, color, scale)
                    .unwrap();
                fresh
                    .draw_text_scaled(&mut text, layout, origin, transform, clip, color, scale)
                    .unwrap();
            }
            let damage = staged.commit_with_damage();
            assert_eq!(
                canvas.pixels(),
                fresh.pixels(),
                "pass={pass} repeat={repeat}"
            );
            assert_eq!(
                canvas.prepared_scene().draws().len(),
                fresh.prepared_scene().draws().len()
            );
            if repeat == 1 {
                assert!(damage.bounds().is_none(), "identical replay has no damage");
            }
        }
    }
}

#[test]
fn replay_clear_abort_and_foreign_font_preserve_authority() {
    let mut text = TextSystem::bundled().unwrap();
    let mut foreign = TextSystem::bundled().unwrap();
    let a = text.shape("Retained glyphs", 14., None).unwrap();
    let b = text.shape("Different masks 123", 14., None).unwrap();
    let origin = Point { x: 0., y: 0. };
    let clip = Rect::new(0., 0., 128., 64.);
    let mut canvas = Canvas::new(128, 64).unwrap();
    canvas.clear(Color::WHITE);
    canvas
        .draw_text(&mut text, &a, origin, Affine::IDENTITY, clip, Color::BLACK)
        .unwrap();
    let previous = canvas.pixels().to_vec();
    {
        let mut stage = canvas.stage();
        stage.clear(Color::WHITE);
        assert!(
            stage
                .draw_text_scaled(
                    &mut foreign,
                    &a,
                    origin,
                    Affine::IDENTITY,
                    clip,
                    Color::BLACK,
                    1.
                )
                .is_err()
        );
        stage
            .draw_text_scaled(
                &mut text,
                &a,
                origin,
                Affine::IDENTITY,
                clip,
                Color::BLACK,
                1.,
            )
            .unwrap();
        // Abort after replay: original remains complete and owns every lease.
    }
    assert_eq!(canvas.pixels(), previous);
    let mut stage = canvas.stage();
    stage.clear(Color::WHITE);
    stage
        .draw_text_scaled(
            &mut text,
            &a,
            origin,
            Affine::IDENTITY,
            clip,
            Color::BLACK,
            1.,
        )
        .unwrap();
    stage.clear(Color::WHITE);
    stage
        .draw_text_scaled(
            &mut text,
            &b,
            origin,
            Affine::IDENTITY,
            clip,
            Color::BLACK,
            1.,
        )
        .unwrap();
    stage
        .draw_text_scaled(
            &mut text,
            &a,
            origin,
            Affine::IDENTITY,
            clip,
            Color::BLACK,
            1.,
        )
        .unwrap();
    stage.commit();
    let mut fresh = Canvas::new(128, 64).unwrap();
    fresh.clear(Color::WHITE);
    for layout in [&b, &a] {
        fresh
            .draw_text(
                &mut text,
                layout,
                origin,
                Affine::IDENTITY,
                clip,
                Color::BLACK,
            )
            .unwrap();
    }
    drop(a);
    drop(b);
    drop(text);
    assert_eq!(canvas.pixels(), fresh.pixels());
}
