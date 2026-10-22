use fontique::{Blob, Collection, CollectionOptions, FontInfoOverride, SourceCache};
use gpui_canvas::{
    CaretAffinity as A, FontFace, Point, Rect, TextOffset, TextPosition, TextSelection,
};
use parley::{
    Affinity, Cursor, FontContext, FontFamilyName, LayoutContext, OverflowWrap, Selection,
    StyleProperty,
};
use std::sync::Arc;

fn position(byte: usize, affinity: A) -> TextPosition {
    TextPosition {
        offset: TextOffset::new(byte).unwrap(),
        affinity,
    }
}
fn selection(start: usize, end: usize) -> TextSelection {
    TextSelection {
        anchor: position(start, A::Downstream),
        focus: position(end, A::Upstream),
    }
}
fn rectangles(layout: &gpui_canvas::TextLayout, range: TextSelection) -> Vec<(Rect, usize)> {
    let mut result = Vec::new();
    assert!(layout.selection_rects(range, |rect, line| result.push((rect, line))));
    result
}

// Compare unions, not callback segmentation: Parley walks visual runs while
// Canvas streams source intervals. Sampling every unique edge interval detects
// both holes and duplicate coverage without depending on either segmentation.
fn assert_union(actual: &[(Rect, usize)], expected: &[(Rect, usize)], context: &str) {
    for (rect, line) in actual {
        assert!(
            expected
                .iter()
                .any(|(reference, reference_line)| line == reference_line
                    && (rect.y - reference.y).abs() < 0.0001
                    && (rect.height - reference.height).abs() < 0.0001),
            "{context}: vertical bounds {rect:?} line{line}, expected{expected:?}"
        );
    }
    let max_line = actual
        .iter()
        .chain(expected)
        .map(|(_, line)| *line)
        .max()
        .unwrap_or(0);
    for line in 0..=max_line {
        let mut edges = actual
            .iter()
            .chain(expected)
            .filter(|(_, l)| *l == line)
            .flat_map(|(r, _)| [r.x, r.x + r.width])
            .collect::<Vec<_>>();
        edges.sort_by(f32::total_cmp);
        edges.dedup_by(|a, b| (*a - *b).abs() < 0.0001);
        for pair in edges.windows(2) {
            let x = pair[0] + (pair[1] - pair[0]) * 0.5;
            let count = |rects: &[(Rect, usize)]| {
                rects
                    .iter()
                    .filter(|(r, l)| *l == line && r.x < x && x < r.x + r.width)
                    .count()
            };
            assert_eq!(
                count(actual),
                count(expected),
                "{context} line{line} x{x}: actual{actual:?} expected{expected:?}"
            );
        }
    }
}

#[test]
fn source_affinity_at_bidi_wrap_owns_the_correct_adjacent_line() {
    let font = FontFace::bundled().unwrap();
    let layout = font
        .shaper()
        .shape_interactive("abc אבג 123 xyz", 18., Some(55.))
        .unwrap();
    let lines = layout.lines().collect::<Vec<_>>();
    assert_eq!(
        lines
            .iter()
            .map(|l| l.text_range().start.byte()..l.text_range().end.byte())
            .collect::<Vec<_>>(),
        [0..4, 4..11, 11..15, 15..18]
    );
    // The number 1 starts line two at its left edge. The logically preceding
    // RTL space ends line one at its left edge. Neither side belongs to line
    // zero, even though a visual predecessor may be reached on that line.
    for (affinity, line) in [(A::Upstream, 1), (A::Downstream, 2)] {
        let caret = layout.caret_bounds(position(11, affinity)).unwrap();
        assert_eq!(caret.x, 0.);
        assert!((caret.y - lines[line].bounds().y).abs() < 0.0001);
    }
    let selected = rectangles(&layout, selection(0, 11));
    assert_eq!(selected.len(), 2);
    for (rect, line) in selected {
        assert_eq!(rect.x, 0.);
        assert!((rect.width - lines[line].bounds().width).abs() < 0.0001);
    }
}

#[test]
fn physical_arrows_walk_independent_known_visual_edges() {
    let font = FontFace::bundled().unwrap();
    let layout = font
        .shaper()
        .shape_interactive("a אבג b", 18., None)
        .unwrap();
    let mut caret = position(0, A::Downstream);
    // Visible order a, space, gimel, bet, alef, space, b. Arrival from
    // the left owns a trailing LTR edge or a leading RTL edge.
    for byte in [1, 2, 6, 4, 2, 9, 10] {
        let next = layout.next_visual(caret).unwrap();
        assert_eq!(next.offset.byte(), byte);
        assert!(layout.caret_bounds(next).unwrap().x > layout.caret_bounds(caret).unwrap().x);
        caret = next;
    }
    assert_eq!(layout.next_visual(caret), Some(caret));
    for _ in 0..7 {
        let previous = layout.previous_visual(caret).unwrap();
        assert!(layout.caret_bounds(previous).unwrap().x < layout.caret_bounds(caret).unwrap().x);
        caret = previous;
    }
    assert_eq!(caret.offset.byte(), 0);
    assert_eq!(layout.previous_visual(caret), Some(caret));
}

#[test]
fn ordinary_interaction_queries_allocate_nothing_and_preserve_layout_size() {
    let font = FontFace::bundled().unwrap();
    let layout = font
        .shaper()
        .shape_interactive("abc אבג 123\r\ne\u{301} office", 18., Some(55.))
        .unwrap();
    let allocations = allocation_counter::measure(|| {
        for _ in 0..50 {
            let caret = layout.position_at(Point { x: 22., y: 31. }).unwrap();
            std::hint::black_box(layout.previous_visual(caret));
            std::hint::black_box(layout.next_visual(caret));
            assert!(
                layout.selection_rects(selection(0, layout.text_len()), |rect, line| {
                    std::hint::black_box((rect, line));
                })
            );
        }
    });
    assert_eq!(allocations.count_total, 0);
    assert_eq!(std::mem::size_of::<gpui_canvas::TextLayout>(), 56);
    assert_eq!(std::mem::size_of::<gpui_canvas::Glyph>(), 16);
}

#[test]
fn selected_crlf_is_atomic_and_its_marker_extends_past_the_source_trailing_edge() {
    let font = FontFace::bundled().unwrap();
    for (source, byte, rtl) in [
        ("a\r\nb", 1, false),
        ("א\r\nb", 2, true),
        ("\r\nb", 0, false),
    ] {
        let layout = font.shaper().shape_interactive(source, 18., None).unwrap();
        let before = layout.caret_bounds(position(byte, A::Upstream)).unwrap();
        let marked = rectangles(&layout, selection(byte, byte + 2));
        assert_eq!(marked.len(), 1);
        assert_eq!(marked[0].1, 0);
        assert_eq!(marked[0].0.width, 4.5);
        assert_eq!(marked[0].0.y, before.y);
        assert_eq!(marked[0].0.x, before.x - if rtl { 4.5 } else { 0. });
        assert!(
            !layout.selection_rects(selection(byte + 1, byte + 2), |_, _| panic!(
                "CRLF interior"
            ))
        );
        let hit = layout
            .position_at(Point {
                x: marked[0].0.x + 2.,
                y: before.y + 1.,
            })
            .unwrap();
        assert_eq!(hit.offset.byte(), byte);
    }
}

#[test]
fn derived_selection_intervals_match_parley_real_bidi_ligature_and_wrap_geometry() {
    let mut fonts = FontContext {
        collection: Collection::new(CollectionOptions {
            shared: false,
            system_fonts: false,
        }),
        source_cache: SourceCache::default(),
    };
    let families = ["selection primary", "selection arabic", "selection hebrew"];
    for (family, bytes) in families.into_iter().zip([
        &include_bytes!("../assets/NotoSans.ttf")[..],
        &include_bytes!("../assets/arabic/NotoSansArabic-Regular.ttf")[..],
        &include_bytes!("../assets/hebrew/NotoSansHebrew-Regular.ttf")[..],
    ]) {
        fonts.collection.register_fonts(
            Blob::new(Arc::new(bytes)),
            Some(FontInfoOverride {
                family_name: Some(family),
                width: Some(Default::default()),
                style: Some(Default::default()),
                weight: Some(Default::default()),
                axes: None,
            }),
        );
    }
    let mut context = LayoutContext::<()>::new();
    let names = families.map(|name| FontFamilyName::Named(name.into()));
    let font = FontFace::bundled().unwrap();
    let mut shaper = font.shaper();
    for source in [
        "office affine",
        "a אבג b",
        "abc אבג 123 xyz",
        "العربية 123 abc",
        "a \u{2067}אבג\u{2069} b",
        "a\u{202e}BC\u{202c}D",
        "e\u{301} office",
        "नमस्ते abc",
    ] {
        for width in [None, Some(55.)] {
            let mut builder = context.ranged_builder(&mut fonts, source, 1., false);
            builder.push_default(&names[..]);
            builder.push_default(StyleProperty::FontSize(18.));
            builder.push_default(StyleProperty::OverflowWrap(OverflowWrap::Anywhere));
            let mut reference = builder.build(source);
            reference.break_all_lines(width);
            let actual = shaper.shape_interactive(source, 18., width).unwrap();
            let boundaries = icu_segmenter::GraphemeClusterSegmenter::new()
                .segment_str(source)
                .collect::<Vec<_>>();
            for &start in &boundaries {
                for &end in boundaries.iter().filter(|&&end| end >= start) {
                    let selected = Selection::new(
                        Cursor::from_byte_index(&reference, start, Affinity::Downstream),
                        Cursor::from_byte_index(&reference, end, Affinity::Upstream),
                    );
                    let expected = selected
                        .geometry(&reference)
                        .into_iter()
                        .map(|(r, l)| {
                            (
                                Rect::new(
                                    r.x0 as f32,
                                    r.y0 as f32,
                                    (r.x1 - r.x0) as f32,
                                    (r.y1 - r.y0) as f32,
                                ),
                                l,
                            )
                        })
                        .collect::<Vec<_>>();
                    let range = selection(start, end);
                    // This oracle never asks a Cursor for geometry or chooses
                    // first/last lines from cursor geometry. Select cluster
                    // ownership directly and independently sum visual advances.
                    let mut clusters = Vec::new();
                    for (line_index, line) in reference.lines().enumerate() {
                        let metrics = line.metrics();
                        let mut origin = metrics.offset + metrics.inline_min_coord;
                        for run in line.runs() {
                            let mut x = origin;
                            for cluster in run.visual_clusters() {
                                let advance = cluster.advance();
                                if (start..end).contains(&cluster.text_range().start)
                                    && advance > 0.
                                {
                                    clusters.push((
                                        Rect::new(
                                            x,
                                            metrics.block_min_coord,
                                            advance,
                                            metrics.block_max_coord - metrics.block_min_coord,
                                        ),
                                        line_index,
                                    ));
                                }
                                x += advance;
                            }
                            origin += run.advance();
                        }
                    }
                    assert_union(
                        &rectangles(&actual, range),
                        &clusters,
                        "independent visual cluster ownership",
                    );
                    assert_union(
                        &rectangles(&actual, range),
                        &expected,
                        &format!("{source:?} {width:?} {start}..{end}"),
                    );
                    assert_union(
                        &rectangles(
                            &actual,
                            TextSelection {
                                anchor: range.focus,
                                focus: range.anchor,
                            },
                        ),
                        &expected,
                        "reversed",
                    );
                }
            }
        }
    }
}

#[test]
fn hit_selection_and_motion_share_exact_grapheme_crlf_and_bidi_positions() {
    let font = FontFace::bundled().unwrap();
    let mut shaper = font.shaper();
    for source in [
        "",
        "e\u{301} office",
        "a אבג b",
        "a\r\n\r\nb\n",
        "א\r\nb",
        "a\u{2028}b",
    ] {
        let layout = shaper.shape_interactive(source, 18., Some(55.)).unwrap();
        let boundaries = icu_segmenter::GraphemeClusterSegmenter::new()
            .segment_str(source)
            .collect::<Vec<_>>();
        for y in [-100., 0., 10., 25., 50., 1000.] {
            for x in [-100., 0., 5., 20., 50., 1000.] {
                let hit = layout.position_at(Point { x, y }).unwrap();
                assert!(
                    boundaries.contains(&hit.offset.byte()),
                    "{source:?} {hit:?}"
                );
                assert!(layout.caret_bounds(hit).is_some());
                for right in [false, true] {
                    let moved = if right {
                        layout.next_visual(hit)
                    } else {
                        layout.previous_visual(hit)
                    }
                    .unwrap();
                    assert!(boundaries.contains(&moved.offset.byte()));
                    assert!(layout.caret_bounds(moved).is_some());
                }
            }
        }
        assert_eq!(layout.position_at(Point { x: f32::NAN, y: 0. }), None);
        assert_eq!(
            layout.position_at(Point {
                x: 0.,
                y: f32::INFINITY
            }),
            None
        );
        assert!(rectangles(&layout, selection(0, 0)).is_empty());
        let all = rectangles(&layout, selection(0, source.len()));
        assert!(all.iter().all(|(r, _)| r.width > 0. && r.height > 0.));
        assert_eq!(rectangles(&layout, selection(source.len(), 0)), all);
    }
    let plain = shaper.shape("abc", 18., None).unwrap();
    assert_eq!(plain.position_at(Point { x: 0., y: 0. }), None);
    let combining = shaper.shape_interactive("e\u{301}", 18., None).unwrap();
    assert!(
        !combining.selection_rects(selection(1, 3), |_, _| panic!("invalid selection callback"))
    );
}

#[test]
fn independent_visible_order_hits_half_intervals_with_source_affinity() {
    let font = FontFace::bundled().unwrap();
    let layout = font
        .shaper()
        .shape_interactive("a אבג b", 18., None)
        .unwrap();
    // Known UAX9 visual order: a, space, gimel, bet, alef, space, b.
    for (start, end, rtl) in [
        (0, 1, false),
        (1, 2, false),
        (6, 8, true),
        (4, 6, true),
        (2, 4, true),
        (8, 9, false),
        (9, 10, false),
    ] {
        let a = layout.caret_bounds(position(start, A::Downstream)).unwrap();
        let b = layout.caret_bounds(position(end, A::Upstream)).unwrap();
        let left = a.x.min(b.x);
        let width = (a.x - b.x).abs();
        for (fraction, expected) in [
            (0.25, if rtl { end } else { start }),
            (0.75, if rtl { start } else { end }),
        ] {
            let hit = layout
                .position_at(Point {
                    x: left + width * fraction,
                    y: a.y + a.height * 0.5,
                })
                .unwrap();
            assert_eq!(hit.offset.byte(), expected);
            assert_eq!(
                hit.affinity,
                if expected == start {
                    A::Downstream
                } else {
                    A::Upstream
                }
            );
        }
    }
}

#[test]
fn distant_hits_and_line_transitions_choose_physical_extrema() {
    let font = FontFace::bundled().unwrap();
    let mut shaper = font.shaper();
    for (source, left, right) in [("abc", 0, 3), ("אבג", 6, 0), ("a אבג b", 0, 10)] {
        let layout = shaper.shape_interactive(source, 18., None).unwrap();
        for (x, expected) in [(-f32::MAX, left), (f32::MAX, right)] {
            assert_eq!(
                layout
                    .position_at(Point { x, y: 0. })
                    .unwrap()
                    .offset
                    .byte(),
                expected,
                "{source:?} at {x}"
            );
        }
    }
    let layout = shaper.shape_interactive("abc\ndef", 18., None).unwrap();
    assert_eq!(
        layout.previous_visual(position(4, A::Downstream)).unwrap(),
        position(3, A::Upstream)
    );
    let layout = shaper.shape_interactive("אבג\nדהו", 18., None).unwrap();
    assert_eq!(
        layout.next_visual(position(0, A::Downstream)).unwrap(),
        position(13, A::Upstream)
    );
}
