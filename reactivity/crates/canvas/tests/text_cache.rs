use gpui_canvas::{
    Affine, Canvas, CaretAffinity, Color, FontFace, Point, Rect, TextCache, TextLayout, TextOffset,
    TextPosition, TextSystem,
};

fn exact(a: &TextLayout, b: &TextLayout, source: &str) {
    assert_eq!(
        [a.width, a.height, a.baseline].map(f32::to_bits),
        [b.width, b.height, b.baseline].map(f32::to_bits)
    );
    let glyphs = |s: &TextLayout| {
        s.glyphs()
            .map(|g| (g.id, g.cluster, g.x.to_bits(), g.baseline.to_bits()))
            .collect::<Vec<_>>()
    };
    assert_eq!(glyphs(a), glyphs(b));
    assert_eq!(
        format!("{:?}", a.lines().collect::<Vec<_>>()),
        format!("{:?}", b.lines().collect::<Vec<_>>())
    );
    for offset in 0..=source.len() {
        for affinity in [CaretAffinity::Upstream, CaretAffinity::Downstream] {
            let position = TextPosition {
                offset: TextOffset::new(offset).unwrap(),
                affinity,
            };
            let bits = |r: Option<Rect>| r.map(|r| [r.x, r.y, r.width, r.height].map(f32::to_bits));
            assert_eq!(
                bits(a.caret_bounds(position)),
                bits(b.caret_bounds(position))
            );
        }
    }
}

#[test]
fn reusable_planning_matches_scoped_unicode_metrics_and_original_byte_geometry() {
    let font = FontFace::bundled().unwrap();
    let mut cache = TextCache::default();
    for _ in 0..3 {
        for source in [
            "Count: 1234",
            "office fi ffi",
            "a\u{301}b\r\nend",
            "مرحبا بالعالم",
            "אבג 123 xyz",
            "",
            "\n",
            "one two three four",
        ] {
            for width in [None, Some(27.), Some(160.)] {
                let cached = font
                    .shaper_reusing(&mut cache)
                    .shape_interactive(source, 16., width)
                    .unwrap();
                let scoped = font.shaper().shape_interactive(source, 16., width).unwrap();
                exact(&cached, &scoped, source);
                let measured = font
                    .shaper_reusing(&mut cache)
                    .measure(source, 16., width)
                    .unwrap();
                let expected = font.shaper().measure(source, 16., width).unwrap();
                assert_eq!(
                    [measured.width, measured.height, measured.baseline].map(f32::to_bits),
                    [expected.width, expected.height, expected.baseline].map(f32::to_bits)
                );
            }
        }
    }
}

#[test]
fn a_new_font_identity_cannot_inherit_the_previous_planner_font_authority() {
    let first = FontFace::new(include_bytes!("../assets/NotoSans-default.ttf")).unwrap();
    let second = FontFace::new(include_bytes!("../assets/NotoSans-default.ttf")).unwrap();
    assert!(!first.same_face(&second));
    let mut cache = TextCache::default();
    let mut held = Vec::new();
    for font in [&first, &second, &first] {
        let layout = font
            .shaper_reusing(&mut cache)
            .shape_interactive("Count: 101", 16., None)
            .unwrap();
        let expected = font
            .shaper()
            .shape_interactive("Count: 101", 16., None)
            .unwrap();
        exact(&layout, &expected, "Count: 101");
        let mut service = TextSystem::from_font(font.clone());
        let mut canvas = Canvas::new(128, 32).unwrap();
        let result = canvas.draw_text(
            &mut service,
            &layout,
            Point { x: 0., y: 0. },
            Affine::IDENTITY,
            Rect::new(0., 0., 128., 32.),
            Color::BLACK,
        );
        assert!(
            result.is_ok(),
            "cache returned foreign font authority: {result:?}"
        );
        held.push((layout, service));
    }
    cache.clear();
    drop(first);
    drop(second);
    for (layout, mut service) in held {
        let mut canvas = Canvas::new(128, 32).unwrap();
        canvas
            .draw_text(
                &mut service,
                &layout,
                Point { x: 0., y: 0. },
                Affine::IDENTITY,
                Rect::new(0., 0., 128., 32.),
                Color::BLACK,
            )
            .unwrap();
    }
}

#[test]
fn rejected_and_panicked_sessions_recover_without_poisoning_future_layouts() {
    let font = FontFace::bundled().unwrap();
    let mut cache = TextCache::default();
    assert!(
        font.shaper_reusing(&mut cache)
            .shape_interactive("bad\0", 16., None)
            .is_err()
    );
    let failed = std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| {
        let _layout = font
            .shaper_reusing(&mut cache)
            .shape_interactive("prior", 16., None)
            .unwrap();
        let mut session = font.shaper_reusing(&mut cache);
        session.shape_interactive("pending", 16., None).unwrap();
        panic!("owned cache unwind test");
    }));
    assert!(failed.is_err());
    let cached = font
        .shaper_reusing(&mut cache)
        .shape_interactive("recovered", 16., None)
        .unwrap();
    let expected = font
        .shaper()
        .shape_interactive("recovered", 16., None)
        .unwrap();
    exact(&cached, &expected, "recovered");
}
