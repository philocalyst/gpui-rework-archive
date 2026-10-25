// Copyright 2026 the Parley Authors
// SPDX-License-Identifier: Apache-2.0 OR MIT

//! Experimental, borrowed immutable paragraph/width seam. Not used by GPUI.
use super::data::{LayoutData, ParagraphData, WidthData};
use super::read::LayoutRead;
use super::{BreakLines, Layout, Line, Style};
use crate::{IndentOptions, style::Brush};

/// An immutable built paragraph, restricted to layouts without inline boxes or
/// applied alignment. This is a source prototype, not a Canvas cache/resource.
/// It owns existing shape arrays without cloning them; it deliberately is not
/// Clone. Its views borrow it and therefore cannot outlive its fonts/shape.
/// ```compile_fail
/// let owner = parley::Layout::<()>::new().try_into_shaped_paragraph().unwrap();
/// let view = owner.width_view(Some(40.)).unwrap();
/// drop(owner);
/// let _ = view.width();
/// ```
#[doc(hidden)]
pub struct ShapedParagraph<B: Brush> {
    shape: ParagraphData<B>,
    indent_amount: f32,
    indent_options: IndentOptions,
}

/// Independently owned line output borrowing its exact immutable source owner.
/// Building/dropping another width cannot mutate this view. No mutable builder,
/// alignment, arbitrary shape/width constructor or Clone is exposed.
/// ```compile_fail
/// let owner = parley::Layout::<()>::new().try_into_shaped_paragraph().unwrap();
/// let view = owner.width_view(Some(40.)).unwrap();
/// let line = view.get(0);
/// drop(view);
/// drop(line);
/// ```
#[doc(hidden)]
pub struct WidthView<'a, B: Brush> {
    paragraph: &'a ShapedParagraph<B>,
    width_data: WidthData,
}

impl<B: Brush> Layout<B> {
    /// Optional source-only ownership conversion. Unsupported boxes/alignment
    /// return the ORIGINAL layout unchanged, not a new semantic layout error.
    /// Existing lines are discarded; caller-provided indent is preserved.
    #[doc(hidden)]
    pub fn try_into_shaped_paragraph(self) -> Result<ShapedParagraph<B>, Self> {
        if !self.data.width_data.inline_boxes.is_empty() || self.alignment().is_some() {
            return Err(self);
        }
        let LayoutData { shape, width_data } = self.data;
        Ok(ShapedParagraph {
            shape,
            indent_amount: width_data.indent_amount,
            indent_options: width_data.indent_options,
        })
    }
}

impl<B: Brush> ShapedParagraph<B> {
    pub(super) fn shape(&self) -> &ParagraphData<B> { &self.shape }
    /// Build one fresh, fully finished width using the original breaker. No
    /// partial BreakLines state can escape as a view. No source rebuild occurs.
    /// This optional prototype accepts only positive finite widths or None;
    /// unsupported widths return None before allocating/breaking, outside GPUI.
    #[doc(hidden)]
    pub fn width_view(&self, max_advance: Option<f32>) -> Option<WidthView<'_, B>> {
        if max_advance.is_some_and(|width| !width.is_finite() || width <= 0.) {
            return None;
        }
        let mut width_data = WidthData {
            indent_amount: self.indent_amount,
            indent_options: self.indent_options,
            ..WidthData::default()
        };
        BreakLines::for_paragraph(self, &mut width_data)
            .break_remaining(max_advance.unwrap_or(f32::MAX));
        Some(WidthView { paragraph: self, width_data })
    }
    #[doc(hidden)]
    pub fn styles(&self) -> &[Style<B>] { &self.shape.styles }
    #[doc(hidden)]
    pub fn text_len(&self) -> usize { self.shape.text_len }
}

impl<B: Brush> WidthView<'_, B> {
    pub(super) fn shape(&self) -> &ParagraphData<B> { self.paragraph.shape() }
    pub(super) fn width_data(&self) -> &WidthData { &self.width_data }
    fn read(&self) -> LayoutRead<'_, B> { LayoutRead::from_width_view(self) }
    #[doc(hidden)]
    pub fn width(&self) -> f32 { self.width_data.width }
    #[doc(hidden)]
    pub fn full_width(&self) -> f32 { self.width_data.full_width }
    #[doc(hidden)]
    pub fn height(&self) -> f32 { self.width_data.height }
    #[doc(hidden)]
    pub fn layout_max_advance(&self) -> f32 { self.width_data.layout_max_advance }
    #[doc(hidden)]
    pub fn get(&self, index: usize) -> Option<Line<'_, B>> { self.read().get(index) }
    #[doc(hidden)]
    pub fn lines(&self) -> impl ExactSizeIterator<Item = Line<'_, B>> + DoubleEndedIterator + Clone + '_ {
        self.read().lines()
    }
}

impl<B: Brush> WidthView<'_, B> {
    /// Experimental direct path with the ordinary byte snapping/affinity policy.
    #[doc(hidden)]
    pub fn cursor_from_byte_index(&self, index: usize, affinity: super::Affinity) -> crate::Cursor {
        crate::Cursor::from_byte_index_read(self.read(), index, affinity)
    }
    /// Experimental direct geometry; cursor remains an ordinary source value.
    /// Geometry always comes from this exact paired source and width view.
    #[doc(hidden)]
    pub fn cursor_geometry(&self, cursor: crate::Cursor, width: f32) -> crate::BoundingBox {
        cursor.geometry_read(self.read(), width)
    }
}
