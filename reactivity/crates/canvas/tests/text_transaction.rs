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
    for mode in 0..7 {
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
        println!(
            "canonical mode={mode} fingerprint={:?}",
            fingerprint(&mut canvas)
        );
    }
}
