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
