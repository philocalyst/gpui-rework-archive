//! Private-layout qualification; copied into the production-module overlay.
use crate::{
    FontFamilyName, Layout, LayoutContext, OverflowWrap, StyleProperty, editing::CursorGeometry,
};
use alloc::{vec, vec::Vec};
use core::ops::ControlFlow;

pub(crate) fn layout(source: &str, width: Option<f32>) -> Layout<()> {
    let mut fonts = super::span_tests::fonts();
    let mut context = LayoutContext::new();
    let mut builder = context.ranged_builder(&mut fonts, source, 1., false);
    builder.push_default(FontFamilyName::Named("primary".into()));
    builder.push_default(StyleProperty::FontSize(16.));
    builder.push_default(StyleProperty::OverflowWrap(OverflowWrap::Anywhere));
    let mut result = builder.build(source);
    result.break_all_lines(width);
    result
}

fn bits(pair: Option<[crate::BoundingBox; 2]>) -> Option<[[u64; 4]; 2]> {
    pair.map(|pair| pair.map(|r| [r.x0, r.y0, r.x1, r.y1].map(f64::to_bits)))
}

fn compare(layout: &Layout<()>, requests: &[usize], restart: bool) {
    let index = CursorGeometry::new(layout).expect("fixture admits indexed geometry");
    let expected = requests
        .iter()
        .map(|&byte| (byte, bits(index.geometries_at(byte, 1.))))
        .collect::<Vec<_>>();
    let mut actual = vec![(usize::MAX, None)];
    let checkpoint = actual.len();
    let result = CursorGeometry::try_for_each_pair_partial(
        layout,
        requests.iter().copied(),
        1.,
        |byte, pair| {
            actual.push((byte, bits(pair)));
        },
    );
    assert_eq!(result.is_err(), restart);
    if result.is_err() {
        actual.truncate(checkpoint);
        for &byte in requests {
            actual.push((byte, bits(index.geometries_at(byte, 1.))));
        }
    }
    assert_eq!(actual[0], (usize::MAX, None));
    assert_eq!(actual[checkpoint..], expected);
}

#[test]
fn partial_producer_pairs_match_full_index_bits() {
    let mut layouts = 0;
    super::span_tests::census_layouts(|layout, _| {
        let requests = (0..=layout.data.text_len)
            .flat_map(|byte| [byte, byte])
            .chain([usize::MAX])
            .collect::<Vec<_>>();
        compare(layout, &requests, false);
        layouts += 1;
    });
    assert_eq!(layouts, 396);
}

#[test]
fn repeated_and_decreasing_requests_preserve_restarted_source_order() {
    let layout = layout("abcdefghijklmno", Some(30.));
    compare(&layout, &[0, 0, 1, 1, 15, 15, usize::MAX], false);
    compare(&layout, &[0, 5, 1, 15, 0, usize::MAX, 5], true);
}

#[test]
fn late_decreasing_disjoint_lines_restart_after_callbacks() {
    let mut layout = layout("abcdefghijklmno", Some(30.));
    assert!(layout.data.lines.len() > 3);
    layout.data.lines.swap(1, 2);
    let mut callbacks = 0;
    assert!(
        CursorGeometry::try_for_each_pair_partial(&layout, 0..=15, 1., |_, _| callbacks += 1)
            .is_err()
    );
    assert!(callbacks > 0);
    compare(&layout, &(0..=15).collect::<Vec<_>>(), true);
}

#[test]
fn late_duplicate_run_fragments_restart_without_changing_admission() {
    for empty in [false, true] {
        let mut layout = layout("abcdefghijklmno", Some(30.));
        let last = layout.data.lines.last_mut().unwrap();
        let position = last.item_range.end - 1;
        let mut duplicate = layout.data.line_items[position].clone();
        if empty {
            let first = &mut layout.data.line_items[position];
            first.shaped_cluster_range.end = first.shaped_cluster_range.start;
            first.text_range.end = first.text_range.start;
            duplicate = first.clone();
        } else {
            let first = &mut layout.data.line_items[position];
            let middle = first.shaped_cluster_range.start + 1;
            first.shaped_cluster_range.end = middle;
            duplicate.shaped_cluster_range.start = middle;
        }
        layout.data.line_items.push(duplicate);
        last.item_range.end += 1;
        let mut callbacks = 0;
        assert!(
            CursorGeometry::try_for_each_pair_partial(&layout, 0..=15, 1., |_, _| callbacks += 1)
                .is_err()
        );
        assert!(callbacks > 0);
        compare(&layout, &(0..=15).collect::<Vec<_>>(), true);
    }
}

#[test]
fn late_font_rejection_overrides_earlier_nonfinite_geometry() {
    for overlap in [false, true] {
        let mut layout = layout("abcdefghijklmno", Some(30.));
        layout.data.lines[0].metrics.offset = f32::NAN;
        if overlap {
            let first = layout.data.lines[0].item_range.start;
            let last = layout.data.lines.last().unwrap().item_range.start;
            layout.data.line_items[last].shaped_cluster_range =
                layout.data.line_items[first].shaped_cluster_range.clone();
        } else {
            layout.data.text_len -= 1;
        }
        let mut output = vec![123];
        let checkpoint = output.len();
        let mut invalid_geometry = false;
        let result =
            CursorGeometry::try_for_each_pair_partial(&layout, 0..=15, 1., |byte, pair| {
                invalid_geometry |= pair.is_some_and(|pair| {
                    pair.into_iter()
                        .any(|r| ![r.x0, r.y0, r.x1, r.y1].into_iter().all(f64::is_finite))
                });
                output.push(byte);
            });
        assert!(result.is_err());
        assert!(
            invalid_geometry,
            "nonfinite pair must precede structural restart"
        );
        assert!(output.len() > checkpoint);
        output.truncate(checkpoint);
        assert!(
            CursorGeometry::new(&layout).is_none(),
            "index retains final InvalidFont authority"
        );
        assert_eq!(output, [123]);
        let mut atomic_calls = 0;
        assert_eq!(
            CursorGeometry::try_for_each_pair(&layout, 0..=15, 1., |_, _| {
                atomic_calls += 1;
                ControlFlow::Break("geometry failure")
            }),
            None
        );
        assert_eq!(atomic_calls, 0);
    }
}

#[test]
fn empty_synthetic_metrics_and_large_source_guard_are_explicit() {
    compare(&layout("", None), &[0, 0, usize::MAX], false);
    let mut layout = layout("a", None);
    layout.data.text_len = u32::MAX as usize + 1;
    let mut calls = 0;
    assert!(
        CursorGeometry::try_for_each_pair_partial(&layout, [0], 1., |_, _| calls += 1).is_err()
    );
    assert_eq!(calls, 0);
}

#[test]
fn public_borrowed_state_sizes() {
    use core::mem::{size_of, size_of_val};
    let layout = layout("abc", None);
    let run = layout.get(0).unwrap().runs().next().unwrap();
    std::eprintln!(
        "STATE Vec={} Run={} Cluster={} clusters={} Restart={} BoundingBox={}",
        size_of::<Vec<f32>>(),
        size_of_val(&run),
        size_of::<crate::layout::Cluster<'_, ()>>(),
        size_of_val(&run.clusters()),
        size_of::<crate::editing::CursorGeometryRestart>(),
        size_of::<crate::BoundingBox>()
    );
}
