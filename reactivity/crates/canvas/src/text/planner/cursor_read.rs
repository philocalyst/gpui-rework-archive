//! Experimental paired-read cursor proof only; no GPUI/Canvas reuse adoption.
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
fn view(view: &parley::WidthView<'_, ()>, content: &str, width: f32) -> Vec<u64> {
    let index = CursorGeometry::from_width_view(view).unwrap();
    observe(content, |byte, affinity| {
        let cursor = view.cursor_from_byte_index(byte, affinity);
        (cursor, bits(view.cursor_geometry(cursor, width)))
    }, &index, width)
}

#[test]
fn paired_read_cursor_a_b_a_matches_cold_all_bytes_and_affinities() {
    let _registry = super::super::BUNDLED_TEST_LOCK.lock().unwrap();
    let corpus = [String::new(), "a".into(), "a\u{301}".into(),
        "office affinity AVATAR trailing  ".into(),
        "abc אבג 123 xyz العربية office".into(),
        "a\u{200d}b\u{2066}אבג\u{2069}".into(),
        "line\u{2028}next end".into(), format!("a{} end", "\u{301}".repeat(512))];
    let mut checked = 0;
    let mut distinct_affinity_geometry = false;
    for content in corpus {
        for size in [14.1, 23.75] {
            for indent in [0., 3.125] {
                let owner = build(&content, size, indent).try_into_shaped_paragraph().unwrap();
                let a = owner.width_view(Some(120.)).unwrap();
                let held_a = CursorGeometry::from_width_view(&a).unwrap();
                let held_before = (0..=content.len()).chain([usize::MAX])
                    .map(|byte| held_a.geometries_at(byte, 1.).map(|pair| pair.map(bits)))
                    .collect::<Vec<_>>();
                let before = view(&a, &content, 1.);
                distinct_affinity_geometry |= before.chunks_exact(14).any(|pair| pair[3..7] != pair[10..14]);
                let b = owner.width_view(Some(40.)).unwrap();
                let a2 = owner.width_view(Some(120.)).unwrap();
                let held_b = CursorGeometry::from_width_view(&b).unwrap();
                let held_a2 = CursorGeometry::from_width_view(&a2).unwrap();
                for (position, byte) in (0..=content.len()).chain([usize::MAX]).enumerate() {
                    assert_eq!(held_a.geometries_at(byte, 1.).map(|pair| pair.map(bits)), held_before[position]);
                    let expected_b = [Affinity::Upstream, Affinity::Downstream].map(|affinity| {
                        let cursor = b.cursor_from_byte_index(byte, affinity);
                        (cursor.index() == byte).then(|| bits(b.cursor_geometry(cursor, 1.)))
                    });
                    assert_eq!(held_b.geometries_at(byte, 1.).map(|pair| pair.map(bits)),
                        expected_b[0].zip(expected_b[1]).map(|(up, down)| [up, down]));
                    assert_eq!(held_a2.geometries_at(byte, 1.).map(|pair| pair.map(bits)), held_before[position]);
                    assert_eq!(held_a.geometries_at(byte, 1.).map(|pair| pair.map(bits)), held_before[position]);
                }
                if content == "office affinity AVATAR trailing  " {
                    assert_ne!(a.lines().count(), b.lines().count(), "fixture must rewrap");
                    assert_ne!(before, view(&b, &content, 1.), "caret geometry must change");
                }
                assert_eq!(view(&a2, &content, 1.), before);
                assert_eq!(view(&a, &content, 1.), before);
                for width in [None, Some(1.), Some(40.), Some(60.), Some(120.)] {
                    let next = owner.width_view(width).unwrap();
                    let mut cold = build(&content, size, indent);
                    cold.break_all_lines(width);
                    for caret_width in [-0., 1., -1., 1e20] {
                        assert_eq!(view(&next, &content, caret_width), ordinary(&cold, &content, caret_width));
                        checked += 1;
                    }
                    assert_eq!(view(&a, &content, 1.), before);
                }
                drop(held_b); drop(held_a2); drop(b); drop(a2);
                assert_eq!((0..=content.len()).chain([usize::MAX])
                    .map(|byte| held_a.geometries_at(byte, 1.).map(|pair| pair.map(bits)))
                    .collect::<Vec<_>>(), held_before);
                assert_eq!(view(&a, &content, 1.), before);
            }
        }
    }
    assert_eq!(checked, 640);
    assert!(distinct_affinity_geometry, "fixture must exercise distinct affinity rectangles");
    eprintln!("PAIRED-CURSOR-CASES {checked}");
}
