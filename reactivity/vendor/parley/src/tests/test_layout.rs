// Copyright 2026 the Parley Authors
// SPDX-License-Identifier: Apache-2.0 OR MIT

use super::utils::{
    ColorBrush,
    fonts::{FONT_FAMILY_LIST, create_font_context},
};
use crate::{Alignment, AlignmentOptions, FontFamily, IndentOptions, Layout, LayoutContext};

#[test]
fn clear_resets_to_new() {
    let mut fcx = create_font_context();
    let mut lcx: LayoutContext<ColorBrush> = LayoutContext::new();

    static TEXT: &str = "Some text that will wrap across several lines.";

    let mut builder = lcx.ranged_builder(&mut fcx, TEXT, 1., false);
    builder.push_default(FontFamily::from(FONT_FAMILY_LIST));
    let mut layout = builder.build(TEXT);
    layout.set_text_indent(10., IndentOptions::default());
    layout.break_all_lines(Some(50.));
    layout.align(Alignment::Center, AlignmentOptions::default());
    assert!(layout.lines().len() > 1);
    assert!(layout.width() > 0.);
    assert!(layout.height() > 0.);

    layout.clear();

    assert_eq!(layout.data, Layout::new().data);
}

/// The storage cut must allow retiring one width without cloning shape arrays.
/// This is internal sequential association, NOT a public shared-view API.
#[test]
fn detached_width_storage_round_trips_without_rebuilding_shape() {
    let mut fcx = create_font_context();
    let mut lcx: LayoutContext<ColorBrush> = LayoutContext::new();
    let text = "office affinity words abc אבג 123 trailing  ";
    let mut builder = lcx.ranged_builder(&mut fcx, text, 1., false);
    builder.push_default(FontFamily::from(FONT_FAMILY_LIST));
    let mut layout = builder.build(text);
    let shape_identity = (
        layout.data.shape.styles.as_ptr(),
        layout.data.shape.style_metrics.as_ptr(),
        layout.data.shape.runs.as_ptr(),
        layout.data.shape.items.as_ptr(),
        layout.data.shape.shaped_text.characters().as_ptr(),
        layout.data.shape.shaped_text.shaped_clusters().as_ptr(),
        layout.data.shape.shaped_text.runs().as_ptr(),
        layout.data.shape.shaped_text.glyphs().as_ptr(),
        layout.data.shape.shaped_text.fonts().as_ptr(),
        layout.data.shape.shaped_text.normalized_coords().as_ptr(),
    );
    layout.break_all_lines(Some(120.));
    let width_a = core::mem::take(&mut layout.data.width_data);
    layout.break_all_lines(Some(40.));
    let mut other_width = core::mem::replace(&mut layout.data.width_data, width_a);
    assert_ne!(layout.len(), other_width.lines.len(), "fixture must change wrapping");

    for width in [Some(120.), Some(40.), Some(120.)] {
        let mut builder = lcx.ranged_builder(&mut fcx, text, 1., false);
        builder.push_default(FontFamily::from(FONT_FAMILY_LIST));
        let mut cold = builder.build(text);
        cold.break_all_lines(width);
        super::utils::asserts::assert_eq_layout_data(&layout.data, &cold.data, "detached width");
        assert_eq!(shape_identity, (
            layout.data.shape.styles.as_ptr(),
            layout.data.shape.style_metrics.as_ptr(),
            layout.data.shape.runs.as_ptr(),
            layout.data.shape.items.as_ptr(),
            layout.data.shape.shaped_text.characters().as_ptr(),
            layout.data.shape.shaped_text.shaped_clusters().as_ptr(),
        layout.data.shape.shaped_text.runs().as_ptr(),
        layout.data.shape.shaped_text.glyphs().as_ptr(),
        layout.data.shape.shaped_text.fonts().as_ptr(),
        layout.data.shape.shaped_text.normalized_coords().as_ptr(),
        ));
        core::mem::swap(&mut layout.data.width_data, &mut other_width);
    }
}
