use gpui_canvas::{
    Affine, Canvas, ClipShape, Color, ColorConfig, Extend, Gradient, GradientGeometry,
    GradientStop, Interpolation, Point, Rect, TextSystem,
};

#[test]
fn retained_text_metadata_preserves_complex_clip_gradient_order_and_lifetime() {
    let gradient = Gradient::new(
        GradientGeometry::Linear {
            start: Point::default(),
            end: Point { x: 1.0, y: 0.0 },
        },
        &[
            GradientStop::new(0.0, Color::rgba(31, 73, 211, 180)),
            GradientStop::new(1.0, Color::rgba(211, 41, 71, 220)),
        ],
        Extend::Pad,
        Interpolation::LinearSrgb,
    )
    .unwrap();
    for dpr in [1.0, 2.0, 1.25] {
        let mut fonts = TextSystem::bundled().unwrap();
        let layout = fonts.shape("office café אבג", 12.0, None).unwrap();
        let single = fonts.shape("H", 12.0, None).unwrap();
        let mut canvas = Canvas::recording(96, 48, ColorConfig::default()).unwrap();
        println!(
            "COMPOSE_HEADERS canvas={} layout={} scene={}",
            size_of::<Canvas>(),
            size_of::<gpui_canvas::TextLayout>(),
            canvas.prepared_scene().storage().header_bytes
        );
        canvas.clear(Color::BLACK);
        let parent = canvas
            .create_clip(
                None,
                ClipShape::RoundedRect {
                    rect: Rect::new(1.125, 1.375, 90.5, 44.25),
                    radius: 9.0,
                },
                Affine::IDENTITY,
            )
            .unwrap();
        let child = canvas
            .create_clip(
                Some(parent),
                ClipShape::Rect(Rect::new(0.0, 0.0, 92.0, 44.0)),
                Affine {
                    a: 1.0,
                    b: 0.125,
                    c: -0.125,
                    d: 1.0,
                    tx: 2.0,
                    ty: 0.0,
                },
            )
            .unwrap();
        canvas
            .fill_gradient(
                &gradient,
                Rect::new(0.0, 0.0, 96.0, 48.0),
                4.0,
                Affine::IDENTITY,
                child,
            )
            .unwrap();
        for (row, run) in [&layout, &single, &layout].into_iter().enumerate() {
            canvas
                .draw_text_scaled(
                    &mut fonts,
                    run,
                    Point {
                        x: 2.5,
                        y: row as f32 * 10.0,
                    },
                    Affine::IDENTITY,
                    child,
                    Color::WHITE,
                    dpr,
                )
                .unwrap();
        }
        canvas
            .fill_gradient(
                &gradient,
                Rect::new(75.0, 24.0, 18.0, 20.0),
                0.0,
                Affine::IDENTITY,
                child,
            )
            .unwrap();
        drop((layout, single, fonts));
        let scene = canvas.prepared_scene();
        let flat = scene.draws().collect::<Vec<_>>();
        assert!(
            flat.iter()
                .filter(|draw| draw.source.mask().is_some())
                .count()
                > 2
        );
        assert!(flat.first().unwrap().source.gradient().is_some());
        assert!(flat.last().unwrap().source.gradient().is_some());
        let mut ordinal = 0;
        for group in scene.groups() {
            let chain = group
                .clip_chain()
                .expect("complex prefix survives metadata access");
            for ((source, bounds), placement) in
                group.sources().zip(group.bounds()).zip(group.placements())
            {
                let draw = flat[ordinal];
                assert_eq!(bounds, draw.bounds);
                assert_eq!(placement.local_rect, draw.local_rect);
                assert_eq!(
                    source.mask().map(|mask| mask.key),
                    draw.source.mask().map(|mask| mask.key)
                );
                assert_eq!(
                    source.gradient().map(|(view, radius)| (view.key(), radius)),
                    draw.source
                        .gradient()
                        .map(|(view, radius)| (view.key(), radius))
                );
                for (x, y) in [(0, 0), (3, 3), (8, 7), (90, 41)] {
                    assert_eq!(
                        chain.sample_mask(x, y),
                        draw.clip_chain.unwrap().sample_mask(x, y)
                    );
                }
                ordinal += 1;
            }
        }
        assert_eq!(ordinal, flat.len());
        assert_eq!(
            scene
                .groups()
                .rev()
                .flat_map(|group| group.bounds().rev())
                .collect::<Vec<_>>(),
            flat.iter()
                .rev()
                .map(|draw| draw.bounds)
                .collect::<Vec<_>>()
        );
        let expected = canvas.pixels().to_vec();
        {
            let mut candidate = canvas.stage();
            candidate.clear(Color::WHITE);
        }
        assert_eq!(canvas.pixels(), expected);
        assert!(canvas.clip_geometry().unwrap().chain(child).is_ok());
    }
}

#[test]
fn rebuilt_nested_clip_text_and_gradient_scenes_have_exact_damage() {
    let gradient = Gradient::new(
        GradientGeometry::Linear {
            start: Point::default(),
            end: Point { x: 1.0, y: 1.0 },
        },
        &[
            GradientStop::new(0.0, Color::BLACK),
            GradientStop::new(1.0, Color::WHITE),
        ],
        Extend::Pad,
        Interpolation::LinearSrgb,
    )
    .unwrap();
    let mut fonts = TextSystem::bundled().unwrap();
    let layout = fonts.shape("office café אבג", 12.0, None).unwrap();
    for dpr in [1.0, 2.0, 1.25] {
        let mut canvas = Canvas::recording(96, 48, ColorConfig::default()).unwrap();
        let mut describe = |canvas: &mut Canvas, radius: f32| {
            let mut next = canvas.stage();
            next.clear(Color::BLACK);
            let parent = next
                .create_clip(
                    None,
                    ClipShape::RoundedRect {
                        rect: Rect::new(0.125, 0.375, 90.0, 45.0),
                        radius,
                    },
                    Affine::IDENTITY,
                )
                .unwrap();
            let child = next
                .create_clip(
                    Some(parent),
                    ClipShape::Rect(Rect::new(0.0, 0.0, 92.0, 44.0)),
                    Affine {
                        a: 1.0,
                        b: 0.125,
                        c: -0.125,
                        d: 1.0,
                        tx: 2.0,
                        ty: 0.0,
                    },
                )
                .unwrap();
            next.fill_gradient(
                &gradient,
                Rect::new(0.0, 0.0, 96.0, 48.0),
                3.0,
                Affine::IDENTITY,
                child,
            )
            .unwrap();
            next.draw_text_scaled(
                &mut fonts,
                &layout,
                Point { x: 1.5, y: 1.5 },
                Affine::IDENTITY,
                child,
                Color::WHITE,
                dpr,
            )
            .unwrap();
            next.commit_with_damage()
        };
        assert!(!describe(&mut canvas, 14.0).is_empty());
        let original = canvas.pixels().to_vec();
        assert!(describe(&mut canvas, 14.0).is_empty());
        assert_eq!(canvas.pixels(), original);
        let damage = describe(&mut canvas, 2.0);
        let changed = canvas.pixels();
        assert_ne!(changed, original);
        let [left, top, right, bottom] = damage.bounds().expect("changed clip contributes support");
        for (index, (a, b)) in original
            .chunks_exact(4)
            .zip(changed.chunks_exact(4))
            .enumerate()
        {
            if a != b {
                let (x, y) = ((index % 96) as u32, (index / 96) as u32);
                assert!(x >= left && x < right && y >= top && y < bottom);
            }
        }
    }
}
