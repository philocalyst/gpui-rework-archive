// Copyright 2025 the Parley Authors
// SPDX-License-Identifier: Apache-2.0 OR MIT

//! Various helper functions to assert truths during testing.

use std::vec::Vec;

use crate::{Brush, data::LayoutData};

fn canonicalize_layout_data<B: Brush>(layout_data: &LayoutData<B>) -> LayoutData<B> {
    let mut normalized = layout_data.clone();
    let mut canonical_styles = Vec::with_capacity(normalized.shape.styles.len());
    let mut canonical_metrics = Vec::with_capacity(normalized.shape.styles.len());
    let mut remap = Vec::with_capacity(normalized.shape.styles.len());

    // The style tree (`parent`) and everything derived from it (the parent-relative
    // `baseline_offset` and `aligned_subtree_root` of the style metrics) is intentionally not
    // part of the comparison: the tree builder records span nesting that the flat builders
    // cannot express, so only the visual style properties are compared.
    for (style, metrics) in normalized.shape.styles.iter().zip(&normalized.shape.style_metrics) {
        let mut style = style.clone();
        style.parent = 0;
        let mut metrics = *metrics;
        metrics.baseline_offset = 0.;
        metrics.aligned_subtree_root = 0;
        metrics.parent = 0;
        if let Some(index) = canonical_styles
            .iter()
            .position(|existing| *existing == style)
        {
            remap.push(index as u16);
        } else {
            let index = canonical_styles.len() as u16;
            canonical_styles.push(style);
            canonical_metrics.push(metrics);
            remap.push(index);
        }
    }

    normalized.shape.shaped_text.remap_styles(&remap);
    normalized.shape.styles = canonical_styles;
    normalized.shape.style_metrics = canonical_metrics;
    normalized
}

/// Assert that the two provided `LayoutData` are equal.
pub(crate) fn assert_eq_layout_data<B: Brush>(a: &LayoutData<B>, b: &LayoutData<B>, case: &str) {
    let a = canonicalize_layout_data(a);
    let b = canonicalize_layout_data(b);

    assert_eq!(a.shape.scale, b.shape.scale, "{case} scale mismatch");
    assert_eq!(a.shape.quantize, b.shape.quantize, "{case} quantize mismatch");
    assert_eq!(a.shape.base_level, b.shape.base_level, "{case} base_level mismatch");
    assert_eq!(a.shape.text_len, b.shape.text_len, "{case} text_len mismatch");
    assert_eq!(a.width_data.width, b.width_data.width, "{case} width mismatch");
    assert_eq!(a.width_data.full_width, b.width_data.full_width, "{case} full_width mismatch");
    assert_eq!(a.width_data.height, b.width_data.height, "{case} height mismatch");
    assert_eq!(
        a.shape.shaped_text.fonts(),
        b.shape.shaped_text.fonts(),
        "{case} fonts mismatch"
    );
    assert_eq!(
        a.shape.shaped_text.normalized_coords(),
        b.shape.shaped_text.normalized_coords(),
        "{case} coords mismatch"
    );

    // Input (/ output of style resolution)
    assert_eq!(a.shape.styles, b.shape.styles, "{case} styles mismatch");
    assert_eq!(
        a.shape.style_metrics, b.shape.style_metrics,
        "{case} style_metrics mismatch"
    );
    assert_eq!(
        a.width_data.inline_boxes, b.width_data.inline_boxes,
        "{case} inline_boxes mismatch"
    );

    // Output of shaping
    assert_eq!(a.shape.runs, b.shape.runs, "{case} runs mismatch");
    assert_eq!(a.shape.items, b.shape.items, "{case} items mismatch");
    assert_eq!(
        a.shape.shaped_text.characters(),
        b.shape.shaped_text.characters(),
        "{case} characters mismatch"
    );
    assert_eq!(
        a.shape.shaped_text.shaped_clusters(),
        b.shape.shaped_text.shaped_clusters(),
        "{case} clusters mismatch"
    );
    assert_eq!(
        a.shape.shaped_text.glyphs(),
        b.shape.shaped_text.glyphs(),
        "{case} glyphs mismatch"
    );

    // Output of line breaking
    assert_eq!(a.width_data.lines, b.width_data.lines, "{case} lines mismatch");
    assert_eq!(a.width_data.line_items, b.width_data.line_items, "{case} line_items mismatch");

    // Output of alignment
    assert_eq!(
        a.width_data.layout_max_advance, b.width_data.layout_max_advance,
        "{case} alignment_width mismatch"
    );

    // Also compare the whole struct in case any fields have been added that aren't
    // part of this test yet. If this triggers, add the missing assert to the above set.
    assert_eq!(a, b, "{case} LayoutData mismatch");
}
