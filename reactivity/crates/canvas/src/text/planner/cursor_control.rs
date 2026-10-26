//! Public-only frozen b80/cursor-read control. No view constructor used.
use super::*;

fn build(content: &str, size: f32, indent: f32) -> parley::Layout<()> {
    // All views remain usable after this temporary planner/font context dies.
    let face = FontFace::bundled().unwrap();
    let mut planner = Planner::new(&face).unwrap();
    let needed = planner.coverage(content).unwrap();
    let names = FAMILIES.iter().enumerate().filter_map(|(slot, family)| {
        (slot == 0 || needed & (1 << (slot - 1)) != 0)
            .then(|| FontFamilyName::Named((*family).into()))
    }).collect::<Vec<_>>();
    let mut builder = planner.context.ranged_builder(&mut planner.fonts, content, 1., false);
    builder.push_default(&names[..]);
    builder.push_default(StyleProperty::FontSize(size));
    builder.push_default(StyleProperty::OverflowWrap(OverflowWrap::Anywhere));
    let mut layout = builder.build(content);
    layout.set_text_indent(indent, parley::IndentOptions::default());
    layout
}
fn bits(rect: parley::BoundingBox) -> [u64; 4] {
    [rect.x0.to_bits(), rect.y0.to_bits(), rect.x1.to_bits(), rect.y1.to_bits()]
}
fn observe(
    content: &str,
    direct: impl Fn(usize, Affinity) -> (Cursor, [u64; 4]),
    indexed: &CursorGeometry<'_, ()>,
    caret_width: f32,
) -> Vec<u64> {
    let mut words = Vec::new();
    for byte in (0..=content.len()).chain([usize::MAX]) {
        let pair = [Affinity::Upstream, Affinity::Downstream].map(|affinity| {
            let (cursor, rect) = direct(byte, affinity);
            assert_eq!(indexed.cursor(byte, affinity), cursor);
            assert_eq!(bits(indexed.geometry(cursor, caret_width)), rect);
            words.extend([byte as u64, cursor.index() as u64,
                u64::from(cursor.affinity() == Affinity::Downstream)]);
            words.extend(rect);
            (cursor.index() == byte).then_some(rect)
        });
        let expected = pair[0].zip(pair[1]).map(|(a, b)| [a, b]);
        assert_eq!(indexed.geometries_at(byte, caret_width).map(|p| p.map(bits)), expected);
    }
    words
}
fn ordinary(layout: &parley::Layout<()>, content: &str, width: f32) -> Vec<u64> {
    let index = CursorGeometry::new(layout).unwrap();
    observe(content, |byte, affinity| {
        let cursor = Cursor::from_byte_index(layout, byte, affinity);
        (cursor, bits(cursor.geometry(layout, width)))
    }, &index, width)
}

#[test]
fn ordinary_cursor_frozen_control_output() {
    let _registry = super::super::BUNDLED_TEST_LOCK.lock().unwrap();
    eprintln!("CURSOR-READ-SIZES {:?}", [std::mem::size_of::<CursorGeometry<'_, ()>>(),
        std::mem::size_of::<parley::Layout<()>>(), std::mem::size_of::<parley::WidthView<'_, ()>>()]);
    let corpus = [String::new(), "a".into(), "a\u{301}".into(),
        "office affinity AVATAR trailing  ".into(),
        "abc אבג 123 xyz العربية office".into(),
        "a\u{200d}b\u{2066}אבג\u{2069}".into(),
        "line\u{2028}next end".into(), format!("a{} end", "\u{301}".repeat(512))];
    let mut records = 0;
    for (case, content) in corpus.into_iter().enumerate() {
        for size in [14.1, 23.75] {
            for indent in [0., 3.125] {
                for width in [None, Some(1.), Some(40.), Some(60.), Some(120.)] {
                    let mut layout = build(&content, size, indent);
                    layout.break_all_lines(width);
                    for caret_width in [-0., 1., -1., 1e20] {
                        let words = ordinary(&layout, &content, caret_width);
                        assert!(!words.is_empty());
                        eprintln!("CURSOR-READ-ORACLE case={case} size={} indent={} width={:?} caret={} words={words:?}",
                            size.to_bits(), indent.to_bits(), width.map(f32::to_bits), caret_width.to_bits());
                        records += 1;
                    }
                }
            }
        }
    }
    assert_eq!(records, 640);
}
