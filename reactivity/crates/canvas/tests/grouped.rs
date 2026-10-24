use gpui_canvas::{
    Affine, Canvas, Color, ColorConfig, FontFace, Point, PreparedDraw, Rect, TextSystem,
};

#[derive(Debug, PartialEq)]
struct Snapshot {
    rect: Rect,
    inverse: [f64; 6],
    clip: Rect,
    bounds: Rect,
    color: [f32; 4],
    mask: Option<(gpui_canvas::GlyphKey, usize, usize, Vec<u8>)>,
}
fn snapshot(draw: PreparedDraw<'_>) -> Snapshot {
    Snapshot {
        rect: draw.local_rect,
        inverse: draw.inverse,
        clip: draw.clip,
        bounds: draw.bounds,
        color: draw.color,
        mask: draw
            .source
            .mask()
            .map(|m| (m.key, m.width, m.height, m.coverage.to_vec())),
    }
}

#[test]
fn groups_are_the_same_canonical_painter_sequence_in_both_directions() {
    let mut fonts = TextSystem::bundled().unwrap();
    let multi = fonts.shape("office café", 16.0, None).unwrap();
    let single = fonts.shape("H", 16.0, None).unwrap();
    let clip = Rect::new(0.0, 0.0, 160.0, 96.0);
    let mut canvas = Canvas::recording(160, 96, ColorConfig::default()).unwrap();
    for i in 0..8 {
        canvas
            .fill_rect(
                Rect::new(i as f32, 2.0, 10.0, 12.0),
                Affine::IDENTITY,
                clip,
                Color::WHITE,
            )
            .unwrap();
        canvas
            .draw_text(
                &mut fonts,
                if i % 2 == 0 { &multi } else { &single },
                Point {
                    x: 4.0,
                    y: i as f32 * 8.0,
                },
                Affine {
                    a: 1.0,
                    b: 0.1,
                    c: 0.05,
                    d: 1.0,
                    tx: 0.0,
                    ty: 0.0,
                },
                clip,
                Color::rgba(12, 40, 90, 180),
            )
            .unwrap();
    }
    let scene = canvas.prepared_scene();
    let _: gpui_canvas::SceneStorage = scene.storage();
    let flat = scene.draws().map(snapshot).collect::<Vec<_>>();
    let grouped = scene
        .groups()
        .flat_map(|group| {
            group.placements().map(move |p| {
                snapshot(PreparedDraw {
                    local_rect: p.local_rect,
                    inverse: group.inverse,
                    clip: group.clip,
                    bounds: p.bounds,
                    color: group.color,
                    source: p.source,
                })
            })
        })
        .collect::<Vec<_>>();
    assert_eq!(flat, grouped);
    let bounds = scene
        .groups()
        .flat_map(|group| group.bounds())
        .collect::<Vec<_>>();
    assert_eq!(
        bounds,
        flat.iter().map(|draw| draw.bounds).collect::<Vec<_>>()
    );
    let sources = scene
        .groups()
        .flat_map(|group| group.sources())
        .map(|source| {
            source
                .mask()
                .map(|mask| (mask.key, mask.width, mask.height, mask.coverage.to_vec()))
        })
        .collect::<Vec<_>>();
    assert_eq!(
        sources,
        flat.iter()
            .map(|draw| draw.mask.clone())
            .collect::<Vec<_>>()
    );
    assert_eq!(
        scene
            .groups()
            .rev()
            .flat_map(|group| group.bounds().rev())
            .collect::<Vec<_>>(),
        bounds.into_iter().rev().collect::<Vec<_>>()
    );
    let expected = scene
        .groups()
        .map(|g| g.placements().map(|p| p.local_rect).collect::<Vec<_>>())
        .collect::<Vec<_>>();
    assert_eq!(expected.len(), 16);
    let mut groups = scene.groups();
    let mut front = 0;
    let mut back = expected.len();
    while front < back {
        assert_eq!(groups.len(), back - front);
        if (front + back) % 3 == 0 {
            back -= 1;
            assert_eq!(
                groups
                    .next_back()
                    .unwrap()
                    .placements()
                    .map(|p| p.local_rect)
                    .collect::<Vec<_>>(),
                expected[back]
            );
        } else {
            assert_eq!(
                groups
                    .next()
                    .unwrap()
                    .placements()
                    .map(|p| p.local_rect)
                    .collect::<Vec<_>>(),
                expected[front]
            );
            front += 1;
        }
    }
    assert_eq!(groups.len(), 0);
    assert!(groups.next().is_none() && groups.next_back().is_none());
}

#[test]
fn masks_are_leased_once_per_stable_key_across_runs_cache_eviction_and_services() {
    let face = FontFace::bundled().unwrap();
    let mut first = TextSystem::from_font(face.clone());
    let mut second = TextSystem::from_font(face);
    let layout = first.shape(&"H".repeat(128), 16.0, None).unwrap();
    let clip = Rect::new(0.0, 0.0, 2048.0, 64.0);
    let mut canvas = Canvas::recording(2048, 64, ColorConfig::default()).unwrap();
    canvas
        .draw_text(
            &mut first,
            &layout,
            Point::default(),
            Affine::IDENTITY,
            clip,
            Color::WHITE,
        )
        .unwrap();
    assert_eq!(canvas.prepared_scene().draws().len(), 128);
    assert_eq!(canvas.prepared_scene().masks().len(), 1);
    let first_key = canvas.prepared_scene().masks().next().unwrap().key;
    first.clear_cache();
    canvas
        .draw_text(
            &mut second,
            &layout,
            Point::default(),
            Affine::IDENTITY,
            clip,
            Color::WHITE,
        )
        .unwrap();
    assert_eq!(canvas.prepared_scene().masks().len(), 1);
    assert_eq!(second.cache_bytes(), 0); // scene lookup precedes font-cache lease
    assert_eq!(
        canvas.prepared_scene().masks().next().unwrap().key,
        first_key
    );
    canvas
        .draw_text_scaled(
            &mut second,
            &layout,
            Point::default(),
            Affine::IDENTITY,
            clip,
            Color::WHITE,
            1.25,
        )
        .unwrap();
    assert_eq!(canvas.prepared_scene().masks().len(), 2);
    let mut foreign = TextSystem::new(include_bytes!("../assets/NotoSans.ttf")).unwrap();
    let foreign_layout = foreign.shape("H", 16.0, None).unwrap();
    canvas
        .draw_text(
            &mut foreign,
            &foreign_layout,
            Point::default(),
            Affine::IDENTITY,
            clip,
            Color::WHITE,
        )
        .unwrap();
    assert_eq!(canvas.prepared_scene().masks().len(), 3);
    let before = canvas
        .prepared_scene()
        .draws()
        .map(snapshot)
        .collect::<Vec<_>>();
    {
        let mut candidate = canvas.stage();
        candidate
            .draw_text(
                &mut second,
                &layout,
                Point::default(),
                Affine::IDENTITY,
                clip,
                Color::WHITE,
            )
            .unwrap();
        assert!(
            candidate
                .draw_text(
                    &mut second,
                    &layout,
                    Point {
                        x: f32::NAN,
                        y: 0.0
                    },
                    Affine::IDENTITY,
                    clip,
                    Color::WHITE
                )
                .is_err()
        );
    }
    assert_eq!(
        canvas
            .prepared_scene()
            .draws()
            .map(snapshot)
            .collect::<Vec<_>>(),
        before
    );
    canvas.clear(Color::BLACK);
    assert_eq!(canvas.prepared_scene().masks().len(), 0);
    assert_eq!(canvas.prepared_scene().groups().len(), 0);
}
