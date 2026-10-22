use crate::{
    FontFamilyName, Layout, LayoutContext, OverflowWrap, StyleProperty, editing::CursorGeometry,
};
use alloc::{vec, vec::Vec};
use core::ops::ControlFlow;

fn layout(source: &str, width: Option<f32>) -> Layout<()> {
    let mut fonts = super::span_tests::fonts();
    let mut context = LayoutContext::new();
    let families = ["primary", "Arabic", "Hebrew"].map(|s| FontFamilyName::Named(s.into()));
    let mut builder = context.ranged_builder(&mut fonts, source, 1., false);
    builder.push_default(&families[..]);
    builder.push_default(StyleProperty::FontSize(16.));
    builder.push_default(StyleProperty::OverflowWrap(OverflowWrap::Anywhere));
    let mut result = builder.build(source);
    result.break_all_lines(width);
    result
}

fn bits(bounds: crate::BoundingBox) -> [u64; 4] {
    [bounds.x0, bounds.y0, bounds.x1, bounds.y1].map(f64::to_bits)
}

fn admitted_like_index(layout: &Layout<()>) {
    let reference = CursorGeometry::new(layout).expect("old index admits this layout");
    let requested = (0..=layout.data.text_len)
        .chain([usize::MAX])
        .collect::<Vec<_>>();
    let mut received = Vec::new();
    assert_eq!(
        CursorGeometry::try_for_each_pair(layout, requested.iter().copied(), 1., |byte, pair| {
            assert_eq!(
                pair.map(|p| p.map(bits)),
                reference.geometries_at(byte, 1.).map(|p| p.map(bits))
            );
            received.push(byte);
            ControlFlow::<()>::Continue(())
        }),
        Some(ControlFlow::Continue(()))
    );
    assert_eq!(received, requested);
}

#[test]
fn producer_bidi_split_empty_edge_and_inline_box_pairs_match_index() {
    super::span_tests::census_layouts(|layout, _| admitted_like_index(layout));
}

#[test]
fn borrowed_spacing_and_completion_match_ordinary_cursors() {
    use crate::{Alignment, AlignmentOptions, Cursor, layout::Affinity};
    let mut fonts = super::span_tests::fonts();
    let mut context = LayoutContext::<()>::new();
    let families = ["primary", "Arabic", "Hebrew"].map(|s| FontFamilyName::Named(s.into()));
    for source in [
        "",
        "\n\n",
        "office  אבג العربية \r\nx",
        "a\u{301}\u{200d}b \u{a0}\u{3000}x",
    ] {
        for (word, letter) in [(-24., 0.), (0., -20.), (13.25, 1.25)] {
            for wrap in [None, Some(0.), Some(31.)] {
                let mut builder = context.ranged_builder(&mut fonts, source, 1., false);
                builder.push_default(&families[..]);
                builder.push_default(StyleProperty::FontSize(16.));
                builder.push_default(StyleProperty::OverflowWrap(OverflowWrap::Anywhere));
                builder.push_default(StyleProperty::WordSpacing(word));
                builder.push_default(StyleProperty::LetterSpacing(letter));
                let mut layout = builder.build(source);
                layout.break_all_lines(wrap);
                for alignment in [Alignment::Start, Alignment::Justify] {
                    layout.align(alignment, AlignmentOptions::default());
                    for width in [-0., 1., -1., 1e20] {
                        let requests = (0..=source.len())
                            .chain([source.len(), 0, source.len(), usize::MAX, 0])
                            .collect::<Vec<_>>();
                        let mut received = Vec::new();
                        assert_eq!(
                            CursorGeometry::try_for_each_pair(
                                &layout,
                                requests.iter().copied(),
                                width,
                                |byte, pair| {
                                    let upstream =
                                        Cursor::from_byte_index(&layout, byte, Affinity::Upstream);
                                    let expected = (upstream.index() == byte).then(|| {
                                        [
                                            upstream.geometry(&layout, width),
                                            Cursor::from_byte_index(
                                                &layout,
                                                byte,
                                                Affinity::Downstream,
                                            )
                                            .geometry(&layout, width),
                                        ]
                                    });
                                    assert_eq!(
                                        pair.map(|p| p.map(bits)),
                                        expected.map(|p| p.map(bits))
                                    );
                                    received.push(byte);
                                    ControlFlow::<()>::Continue(())
                                }
                            ),
                            Some(ControlFlow::Continue(())),
                        );
                        assert_eq!(received, requests);
                        let mut called = 0;
                        assert_eq!(
                            CursorGeometry::try_for_each_pair(&layout, requests, width, |_, _| {
                                called += 1;
                                ControlFlow::Break("stop")
                            }),
                            Some(ControlFlow::Break("stop")),
                        );
                        assert_eq!(called, 1);
                    }
                }
            }
        }
    }
}

fn rejected_before_geometry_callback(layout: &Layout<()>) {
    assert!(CursorGeometry::new(layout).is_none());
    let mut callbacks = 0;
    assert_eq!(
        CursorGeometry::try_for_each_pair(layout, 0..=layout.data.text_len, f32::NAN, |_, _| {
            callbacks += 1;
            ControlFlow::Break("geometry failure would otherwise win")
        }),
        None
    );
    assert_eq!(callbacks, 0);
}

#[test]
fn complete_font_preflight_precedes_nonfinite_geometry_and_callbacks() {
    let mut malformed = layout("abcdefghijklmno", Some(30.));
    assert!(malformed.data.lines.len() > 1);
    malformed.data.lines[0].metrics.offset = f32::NAN;
    malformed.data.text_len -= 1; // Last source range is out of bounds.
    rejected_before_geometry_callback(&malformed);
}

#[test]
fn disjoint_out_of_order_lines_keep_the_old_admission() {
    let mut reordered = layout("abcdefghijklmno", Some(30.));
    assert!(reordered.data.lines.len() > 1);
    reordered.data.lines.swap(0, 1);
    admitted_like_index(&reordered);
}

#[test]
fn overlapping_line_fragments_reject_before_any_callback() {
    let mut overlapping = layout("abcdefghijklmno", Some(30.));
    assert!(overlapping.data.lines.len() > 1);
    let first = overlapping.data.lines[0].item_range.start;
    let second = overlapping.data.lines[1].item_range.start;
    overlapping.data.line_items[second].shaped_cluster_range = overlapping.data.line_items[first]
        .shaped_cluster_range
        .clone();
    rejected_before_geometry_callback(&overlapping);
}

#[test]
fn duplicate_disjoint_or_empty_run_fragments_use_exact_index_fallback() {
    for empty in [false, true] {
        let mut fragments = layout("abcdefgh", None);
        assert_eq!(fragments.data.line_items.len(), 1);
        let mut first = fragments.data.line_items[0].clone();
        let mut second = first.clone();
        if empty {
            first.shaped_cluster_range.end = first.shaped_cluster_range.start;
            second.shaped_cluster_range = first.shaped_cluster_range.clone();
            first.text_range = 0..0;
            second.text_range = 0..0;
        } else {
            let middle = first.shaped_cluster_range.start + 4;
            first.shaped_cluster_range.end = middle;
            second.shaped_cluster_range.start = middle;
            first.text_range = 0..4;
            second.text_range = 4..8;
        }
        fragments.data.line_items = vec![first, second];
        fragments.data.lines[0].item_range = 0..2;
        admitted_like_index(&fragments);
    }
}

#[test]
fn gaps_and_empty_layouts_remain_admitted_without_coverage_requirement() {
    let mut gap = layout("abcdefgh", None);
    gap.data.line_items[0].shaped_cluster_range.start += 1;
    gap.data.line_items[0].text_range.start = 1;
    admitted_like_index(&gap);
    admitted_like_index(&layout("", None));
}

#[test]
fn trailing_source_gap_and_empty_middle_run_keep_exact_byte_owners() {
    let mut trailing = layout("abcdefgh", None);
    trailing.data.line_items[0].shaped_cluster_range.end -= 1;
    trailing.data.line_items[0].text_range.end -= 1;
    admitted_like_index(&trailing);

    let mut fonts = super::span_tests::fonts();
    let mut context = LayoutContext::<()>::new();
    let mut builder = context.ranged_builder(&mut fonts, "abcdefgh", 1., false);
    builder.push_default(FontFamilyName::Named("primary".into()));
    builder.push_default(StyleProperty::FontSize(16.));
    builder.push(StyleProperty::FontSize(23.), 2..4);
    let mut middle = builder.build("abcdefgh");
    middle.break_all_lines(None);
    assert_eq!(middle.data.line_items.len(), 3);
    let empty = &mut middle.data.line_items[1];
    empty.shaped_cluster_range.end = empty.shaped_cluster_range.start;
    empty.text_range.end = empty.text_range.start;
    // This empty run remains between two other source identities, but owns
    // neither byte of the resulting source gap.
    assert_eq!(
        middle
            .get(0)
            .unwrap()
            .item(1)
            .unwrap()
            .run()
            .unwrap()
            .advance(),
        0.
    );
    admitted_like_index(&middle);
}

#[test]
fn invalid_private_run_identity_keeps_old_panic_before_callbacks() {
    use std::panic::{AssertUnwindSafe, catch_unwind};
    let mut malformed = layout("abcdefgh", None);
    malformed.data.line_items[0].index = usize::MAX;
    assert!(catch_unwind(AssertUnwindSafe(|| CursorGeometry::new(&malformed))).is_err());
    let mut callbacks = 0;
    assert!(
        catch_unwind(AssertUnwindSafe(|| {
            CursorGeometry::try_for_each_pair(&malformed, 0..8, 1., |_, _| {
                callbacks += 1;
                ControlFlow::<()>::Continue(())
            })
        }))
        .is_err()
    );
    assert_eq!(callbacks, 0);
}
