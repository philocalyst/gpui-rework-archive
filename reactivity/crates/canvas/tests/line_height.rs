use gpui_canvas::{Error, FontFace, TextLayout};

fn assert_same(a: &TextLayout, b: &TextLayout) {
    assert_eq!(
        (a.width, a.height, a.baseline),
        (b.width, b.height, b.baseline)
    );
    assert_eq!(
        a.glyphs().collect::<Vec<_>>(),
        b.glyphs().collect::<Vec<_>>()
    );
    assert_eq!(
        a.lines()
            .map(|l| (l.text_range(), l.bounds(), l.baseline()))
            .collect::<Vec<_>>(),
        b.lines()
            .map(|l| (l.text_range(), l.bounds(), l.baseline()))
            .collect::<Vec<_>>()
    );
}

#[test]
fn omitted_pitch_preserves_defaults_after_explicit_reuse() {
    let font = FontFace::bundled().unwrap();
    let mut shaper = font.shaper();
    for text in [
        "",
        "one\ntwo\n",
        "e\u{301}\r\nאבג\nالعربية",
        "words wrap over several lines",
    ] {
        let old = shaper.shape_interactive(text, 14., Some(70.)).unwrap();
        shaper
            .shape_interactive_with_line_height(text, 14., Some(70.), Some(40.))
            .unwrap();
        let normal = shaper
            .shape_interactive_with_line_height(text, 14., Some(70.), None)
            .unwrap();
        assert_same(&old, &normal);
        let measure = shaper
            .measure_with_line_height(text, 14., Some(70.), None)
            .unwrap();
        assert_eq!(
            (measure.width, measure.height, measure.baseline),
            (old.width, old.height, old.baseline)
        );
    }
}

#[test]
fn absolute_pitch_controls_wrapped_and_hard_lines_and_matches_measurement() {
    let font = FontFace::bundled().unwrap();
    let mut shaper = font.shaper();
    for pitch in [5., 20., 28., 31.5] {
        for text in [
            "",
            "one\ntwo\n",
            "one\r\ntwo\n\nthree",
            "word word word word word word",
        ] {
            let shape = shaper
                .shape_interactive_with_line_height(text, 14., Some(70.), Some(pitch))
                .unwrap();
            let lines = shape.lines().collect::<Vec<_>>();
            assert_eq!(shape.height, lines.len() as f32 * pitch);
            // Repeated identical primary-font line metrics have exact pitch.
            for (i, line) in lines.iter().enumerate() {
                assert_eq!(line.baseline(), lines[0].baseline() + i as f32 * pitch);
            }
            let measure = shaper
                .measure_with_line_height(text, 14., Some(70.), Some(pitch))
                .unwrap();
            assert_eq!(
                (measure.width, measure.height, measure.baseline),
                (shape.width, shape.height, shape.baseline)
            );
            let ordinary = shaper
                .shape_with_line_height(text, 14., Some(70.), Some(pitch))
                .unwrap();
            assert_eq!(
                ordinary.glyphs().collect::<Vec<_>>(),
                shape.glyphs().collect::<Vec<_>>()
            );
        }
    }
}

#[test]
fn line_pitch_rejects_invalid_values_and_overflow_without_poisoning_reuse() {
    let font = FontFace::bundled().unwrap();
    let mut shaper = font.shaper();
    for bad in [0., -0., -1., f32::NAN, f32::INFINITY, f32::NEG_INFINITY] {
        assert_eq!(
            shaper.measure_with_line_height("a", 14., None, Some(bad)),
            Err(Error::InvalidGeometry)
        );
        assert!(matches!(
            shaper.shape_with_line_height("a", 14., None, Some(bad)),
            Err(Error::InvalidGeometry)
        ));
    }
    assert!(
        shaper
            .shape_interactive_with_line_height("a\nb\nc", 14., None, Some(f32::MAX))
            .is_err()
    );
    let after = shaper
        .shape_interactive_with_line_height("a\nb", 14., None, Some(20.))
        .unwrap();
    let fresh = font
        .shaper()
        .shape_interactive_with_line_height("a\nb", 14., None, Some(20.))
        .unwrap();
    assert_same(&after, &fresh);
}
