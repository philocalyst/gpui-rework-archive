// Copyright 2026 the Parley Authors
// SPDX-License-Identifier: Apache-2.0 OR MIT

//! Borrowed read seam only. No owner lease, sharing or new publication authority.
use super::data::{ParagraphData, WidthData};
use super::{Layout, Line, Style};
use crate::style::Brush;
use core::cmp::Ordering;

/// A pair associated only by borrowing an owning Layout or its exact WidthView. Fields are
/// read-only; no arbitrary ParagraphData/WidthData constructor is exposed.
/// Both borrows have the same lifetime and prevent clearing/rebreaking Layout
/// while any Line/Run/Cluster or cursor index derived from this facade remains in use.
pub(crate) struct LayoutRead<'a, B: Brush> {
    shape: &'a ParagraphData<B>,
    width: &'a WidthData,
}
impl<B: Brush> Copy for LayoutRead<'_, B> {}
impl<B: Brush> Clone for LayoutRead<'_, B> {
    fn clone(&self) -> Self { *self }
}
impl<'a, B: Brush> LayoutRead<'a, B> {
    pub(super) fn from_layout(layout: &'a Layout<B>) -> Self {
        Self { shape: &layout.data.shape, width: &layout.data.width_data }
    }
    pub(super) fn from_break_target(target: &'a super::line_break::BreakTarget<'_, B>) -> Self {
        Self { shape: target.shape(), width: target.width() }
    }
    pub(crate) fn from_width_view(view: &'a super::paragraph::WidthView<'_, B>) -> Self {
        Self { shape: view.shape(), width: view.width_data() }
    }
    pub(crate) fn shape(self) -> &'a ParagraphData<B> { self.shape }
    pub(super) fn width(self) -> &'a WidthData { self.width }
    pub(super) fn styles(self) -> &'a [Style<B>] { &self.shape.styles }
    pub(crate) fn len(self) -> usize { self.width.lines.len() }
    pub(crate) fn get(self, index: usize) -> Option<Line<'a, B>> {
        Some(Line { index: index as u32, layout: self, data: self.width.lines.get(index)? })
    }
    pub(crate) fn lines(self) -> impl ExactSizeIterator<Item = Line<'a, B>> + DoubleEndedIterator + Clone + 'a {
        self.width.lines.iter().enumerate().map(move |(index, data)| Line {
            index: index as u32, layout: self, data,
        })
    }
    pub(super) fn line_for_byte_index(self, index: usize) -> Option<(usize, Line<'a, B>)> {
        let line_index = self.width.lines
            .binary_search_by(|line| {
                if index < line.text_range.start {
                    Ordering::Greater
                } else if index >= line.text_range.end {
                    Ordering::Less
                } else {
                    Ordering::Equal
                }
            })
            .ok()?;
        Some((line_index, self.get(line_index)?))
    }
}
