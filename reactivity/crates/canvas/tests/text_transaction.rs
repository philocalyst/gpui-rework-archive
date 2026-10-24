use gpui_canvas::{Affine, Canvas, Color, ColorConfig, Error, Point, Rect, TextSystem};

const CLIP: Rect = Rect::new(0.0, 0.0, 320.0, 192.0);

fn labels(canvas: &mut Canvas, text: &mut TextSystem, layout: &gpui_canvas::TextLayout) {
    for row in 0..48 {
        canvas
            .draw_text(
                text,
                layout,
                Point {
                    x: 2.25,
                    y: (row % 12) as f32 * 14.0,
                },
                Affine::IDENTITY,
                CLIP,
                Color::WHITE,
            )
            .unwrap();
    }
}

#[test]
fn warm_many_label_rebuild_has_no_submission_allocations() {
    let mut text = TextSystem::bundled().unwrap();
    let layout = text
        .shape("office café repeated labels", 12.0, None)
        .unwrap();
    let mut canvas = Canvas::recording(320, 192, ColorConfig::default()).unwrap();
    labels(&mut canvas, &mut text, &layout);
    canvas.clear(Color::TRANSPARENT);
    let allocation = allocation_counter::measure(|| labels(&mut canvas, &mut text, &layout));
    println!(
        "many_label_warm allocations={} bytes={}",
        allocation.count_total, allocation.bytes_total
    );
    assert_eq!(allocation.count_total, 0);
}

#[test]
fn late_command_limit_failure_preserves_scene_and_new_resource_identity() {
    let mut text = TextSystem::bundled().unwrap();
    let pair = text.shape("Hi", 12.0, None).unwrap();
    let single = text.shape("H", 12.0, None).unwrap();
    let mut canvas = Canvas::recording(320, 192, ColorConfig::default()).unwrap();
    for _ in 0..65_535 {
        canvas
            .fill_rect(
                Rect::new(1.0, 1.0, 1.0, 1.0),
                Affine::IDENTITY,
                CLIP,
                Color::WHITE,
            )
            .unwrap();
    }
    assert_eq!(
        canvas.draw_text(
            &mut text,
            &pair,
            Point::default(),
            Affine::IDENTITY,
            CLIP,
            Color::WHITE
        ),
        Err(Error::ResourceLimit)
    );
    assert_eq!(canvas.prepared_scene().draws().len(), 65_535);
    assert_eq!(canvas.prepared_scene().masks().len(), 0);
    canvas
        .draw_text(
            &mut text,
            &single,
            Point::default(),
            Affine::IDENTITY,
            CLIP,
            Color::WHITE,
        )
        .unwrap();
    assert_eq!(canvas.prepared_scene().draws().len(), 65_536);
    assert_eq!(canvas.prepared_scene().masks().len(), 1);
}

fn fingerprint(canvas: &mut Canvas) -> (u64, u64, usize) {
    fn add(hash: &mut u64, bytes: &[u8]) {
        for &byte in bytes {
            *hash = (*hash ^ u64::from(byte)).wrapping_mul(0x100000001b3);
        }
    }
    let mut commands = 0xcbf29ce484222325;
    let scene = canvas.prepared_scene();
    let count = scene.draws().len();
    for draw in scene.draws() {
        for rect in [draw.local_rect, draw.clip, draw.bounds] {
            for value in [rect.x, rect.y, rect.width, rect.height] {
                add(&mut commands, &value.to_bits().to_le_bytes());
            }
        }
        for value in draw.inverse {
            add(&mut commands, &value.to_bits().to_le_bytes());
        }
        for value in draw.color {
            add(&mut commands, &value.to_bits().to_le_bytes());
        }
        if let Some(mask) = draw.source.mask() {
            add(&mut commands, &(mask.width as u64).to_le_bytes());
            add(&mut commands, &(mask.height as u64).to_le_bytes());
            add(&mut commands, mask.coverage);
        }
    }
    let mut pixels = 0xcbf29ce484222325;
    add(&mut pixels, canvas.pixels());
    (commands, pixels, count)
}

#[test]
fn mixed_script_paint_selection_density_transform_and_scroll_keep_canonical_output() {
    use gpui_canvas::{CaretAffinity, TextOffset, TextPosition, TextSelection};
    let mut text = TextSystem::bundled().unwrap();
    let source = "office e\u{301} café אבג مرحبا\nwrap repeated labels office café\nnewly visible rows 0123456789";
    let layout = text
        .font_face()
        .shaper()
        .shape_interactive(source, 14.0, Some(130.0))
        .unwrap();
    let mut canvas = Canvas::new(160, 96).unwrap();
    let clip = Rect::new(1.125, 0.375, 153.5, 89.25);
    let position = |byte| TextPosition {
        offset: TextOffset::new(byte).unwrap(),
        affinity: CaretAffinity::Downstream,
    };
    // Exact fingerprints from the frozen pre-refactor nightly baseline.
    let expected = [
        (604497862809837837, 7527280167539412869, 43),
        (9246998227355371943, 3768078052957102048, 49),
        (13692261620077259410, 15790634111628224307, 43),
        (1749676696716030854, 13487479287976039562, 43),
        (1937568770473666453, 7419303201436603241, 52),
        (6922594733120599165, 16406274913052508165, 43),
        (17293752116150255889, 10912843186917499701, 43),
    ];
    for (mode, expected) in expected.into_iter().enumerate() {
        canvas.clear(Color::rgb(19, 29, 47));
        let transform = match mode {
            3 => Affine::translation(2.375, 1.125),
            4 => Affine::translation(0.0, -45.25),
            5 => Affine {
                a: -1.0,
                b: 0.1,
                c: 0.05,
                d: 1.0,
                tx: 157.0,
                ty: 0.0,
            },
            _ => Affine::IDENTITY,
        };
        if mode == 1 {
            assert!(layout.selection_rects(
                TextSelection {
                    anchor: position(2),
                    focus: position(56)
                },
                |rect, _| {
                    canvas
                        .fill_rect(rect, transform, clip, Color::rgba(13, 101, 210, 120))
                        .unwrap();
                }
            ));
        }
        canvas
            .draw_text_scaled(
                &mut text,
                &layout,
                Point { x: 2.25, y: 1.5 },
                transform,
                clip,
                if mode == 2 {
                    Color::rgba(190, 30, 80, 180)
                } else {
                    Color::WHITE
                },
                if mode == 6 { 1.25 } else { 1.0 },
            )
            .unwrap();
        if mode == 1 {
            let caret = layout.caret_bounds(position(56)).unwrap();
            canvas
                .fill_rect(caret, transform, clip, Color::WHITE)
                .unwrap();
        }
        assert_eq!(fingerprint(&mut canvas), expected, "mode={mode}");
    }
}

#[test]
fn duplicate_keys_and_foreign_face_rollback_preserve_pixels_and_candidate() {
    let mut text = TextSystem::bundled().unwrap();
    let many = text
        .shape(&format!("{}i", "H".repeat(128)), 1.0, Some(2.0))
        .unwrap();
    let one = text.shape("H", 1.0, None).unwrap();
    let mut foreign = TextSystem::new(include_bytes!("../assets/NotoSans.ttf")).unwrap();
    let foreign_layout = foreign.shape("H", 1.0, None).unwrap();
    let mut canvas = Canvas::new(320, 192).unwrap();
    canvas
        .draw_text(
            &mut foreign,
            &foreign_layout,
            Point::default(),
            Affine::IDENTITY,
            CLIP,
            Color::WHITE,
        )
        .unwrap();
    // One foreign mask already exists. The rejected draw admits a new primary
    // service mask, then 127 duplicate placements, before exceeding the limit.
    for _ in 0..65_407 {
        canvas
            .fill_rect(
                Rect::new(1.0, 1.0, 1.0, 1.0),
                Affine::IDENTITY,
                CLIP,
                Color::WHITE,
            )
            .unwrap();
    }
    let before = fingerprint(&mut canvas);
    let rendered = canvas.stats().render_count;
    let masks = canvas
        .prepared_scene()
        .masks()
        .map(|mask| mask.key)
        .collect::<Vec<_>>();
    assert_eq!(
        canvas.draw_text(
            &mut text,
            &many,
            Point::default(),
            Affine::IDENTITY,
            CLIP,
            Color::WHITE
        ),
        Err(Error::ResourceLimit)
    );
    assert_eq!(fingerprint(&mut canvas), before);
    assert_eq!(canvas.stats().render_count, rendered);
    assert_eq!(
        canvas
            .prepared_scene()
            .masks()
            .map(|mask| mask.key)
            .collect::<Vec<_>>(),
        masks
    );
    // The same failure in a replacement candidate cannot publish its partial
    // glyph group or change the target's previous pixels and resources.
    {
        let mut candidate = canvas.stage();
        for _ in 0..65_408 {
            candidate
                .fill_rect(
                    Rect::new(1.0, 1.0, 1.0, 1.0),
                    Affine::IDENTITY,
                    CLIP,
                    Color::WHITE,
                )
                .unwrap();
        }
        assert_eq!(
            candidate.draw_text(
                &mut text,
                &many,
                Point::default(),
                Affine::IDENTITY,
                CLIP,
                Color::WHITE
            ),
            Err(Error::ResourceLimit)
        );
    }
    assert_eq!(fingerprint(&mut canvas), before);
    canvas
        .draw_text(
            &mut text,
            &one,
            Point::default(),
            Affine::IDENTITY,
            CLIP,
            Color::WHITE,
        )
        .unwrap();
    assert_eq!(canvas.prepared_scene().masks().len(), 2);
}

#[test]
fn submission_allocation_and_retained_capacity_ledger() {
    let mut text = TextSystem::bundled().unwrap();
    for (name, source, repeats, clip) in [
        ("single", "H", 1, CLIP),
        ("label", "office café repeated labels", 1, CLIP),
        ("many_labels", "office café repeated labels", 48, CLIP),
        (
            "clipped",
            "office café repeated labels",
            48,
            Rect::new(900.0, 900.0, 1.0, 1.0),
        ),
    ] {
        let layout = text.shape(source, 12.0, None).unwrap();
        let mut warm_cache = Canvas::recording(320, 192, ColorConfig::default()).unwrap();
        warm_cache
            .draw_text(
                &mut text,
                &layout,
                Point::default(),
                Affine::IDENTITY,
                CLIP,
                Color::WHITE,
            )
            .unwrap();
        let mut canvas = Canvas::recording(320, 192, ColorConfig::default()).unwrap();
        let submit = |canvas: &mut Canvas, text: &mut TextSystem| {
            for _ in 0..repeats {
                canvas
                    .draw_text(
                        text,
                        &layout,
                        Point::default(),
                        Affine::IDENTITY,
                        clip,
                        Color::WHITE,
                    )
                    .unwrap();
            }
        };
        let cold = allocation_counter::measure(|| submit(&mut canvas, &mut text));
        let storage = canvas.prepared_scene().storage();
        canvas.clear(Color::TRANSPARENT);
        let warm = allocation_counter::measure(|| submit(&mut canvas, &mut text));
        println!(
            "ledger name={name} cold_count={} cold_bytes={} warm_count={} warm_bytes={} storage={storage:?}",
            cold.count_total, cold.bytes_total, warm.count_total, warm.bytes_total
        );
    }
}
