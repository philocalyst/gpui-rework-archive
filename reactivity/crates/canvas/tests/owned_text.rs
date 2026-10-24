use gpui_canvas::{
    Affine, Canvas, Color, FontFace, Point, Rect, TextGeometry, TextLayout, TextOffset,
    TextSelection, TextSystem,
};

fn description<G: AsRef<TextGeometry>>(layout: &TextLayout<G>) -> String {
    format!(
        "{:?}|{:?}|{:?}|{:?}",
        (
            layout.width.to_bits(),
            layout.height.to_bits(),
            layout.baseline.to_bits(),
            layout.font_size().to_bits()
        ),
        layout.glyphs().collect::<Vec<_>>(),
        layout
            .lines()
            .map(|line| (line.text_range(), line.bounds(), line.baseline().to_bits()))
            .collect::<Vec<_>>(),
        layout
            .geometry()
            .unwrap()
            .graphemes()
            .map(|unit| (
                unit.text_range(),
                unit.bounds(),
                unit.direction(),
                unit.line()
            ))
            .collect::<Vec<_>>()
    )
}

#[test]
fn direct_payload_preserves_standalone_geometry_font_and_pixels() {
    let font = FontFace::bundled().unwrap();
    let mut shaper = font.shaper();
    for source in [
        "",
        "a",
        "office ffi ",
        "a\u{301} b",
        "office אבג\r\nالعربية",
        "a\rb\nc\r\nd\u{85}e\u{2028}f\u{2029}g",
    ] {
        for size in [9., 16., 31.] {
            for width in [None, Some(f32::MIN_POSITIVE), Some(27.), Some(120.)] {
                let shared = shaper.shape_interactive(source, size, width).unwrap();
                let owned = shaper.shape_owned_interactive(source, size, width).unwrap();
                assert_eq!(
                    description(&shared),
                    description(&owned),
                    "source={source:?} size={size} width={width:?}"
                );
                for (a, b) in shared.runs().zip(owned.runs()) {
                    assert_eq!(a.text_range(), b.text_range());
                    assert!(a.font_face().same_face(b.font_face()));
                }
                for byte in 0..=source.len() {
                    let offset = TextOffset::new(byte).unwrap();
                    assert_eq!(
                        shared
                            .geometry()
                            .unwrap()
                            .grapheme(offset)
                            .map(|x| x.bounds()),
                        owned
                            .geometry()
                            .unwrap()
                            .grapheme(offset)
                            .map(|x| x.bounds())
                    );
                    let selection = TextSelection::caret(byte).unwrap();
                    assert_eq!(
                        shared.validates_selection(selection),
                        owned.validates_selection(selection)
                    );
                }
                if width == Some(f32::MIN_POSITIVE) {
                    continue;
                }
                let mut a = Canvas::new(160, 100).unwrap();
                let mut b = Canvas::new(160, 100).unwrap();
                let mut text = TextSystem::from_font(font.clone());
                let clip = Rect::new(0., 0., 160., 100.);
                a.draw_text(
                    &mut text,
                    &shared,
                    Point { x: 2., y: 3. },
                    Affine::IDENTITY,
                    clip,
                    Color::BLACK,
                )
                .unwrap();
                b.draw_text(
                    &mut text,
                    &owned,
                    Point { x: 2., y: 3. },
                    Affine::IDENTITY,
                    clip,
                    Color::BLACK,
                )
                .unwrap();
                assert_eq!(a.pixels(), b.pixels());
            }
        }
    }
}
