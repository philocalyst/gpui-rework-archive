// Copyright 2025 the Parley Authors
// SPDX-License-Identifier: Apache-2.0 OR MIT

use crate::IndentOptions;
use crate::InlineBox;
use crate::layout::alignment::align;
use crate::layout::data::LayoutData;
use crate::layout::{
    ContentWidths, SpanMetrics, Style, alignment::Alignment, alignment::AlignmentOptions,
    line::Line, line_break::BreakLines,
};
use crate::style::Brush;

use core::cmp::Ordering;
use core::fmt;

/// Text layout.
///
/// The [`Debug`] implementation prints a compact summary by default.
/// The alternate form (`{:#?}`) formats the full underlying data.
///
/// Read views borrow the owner; clearing cannot retire their resources early.
/// ```compile_fail
/// let mut layout = parley::Layout::<()>::new();
/// let line = layout.get(0);
/// layout.clear();
/// drop(line);
/// ```
/// Rebreaking cannot mutate a live run's width association.
/// ```compile_fail
/// let mut layout = parley::Layout::<()>::new();
/// let run = layout.get(0).unwrap().runs().next().unwrap();
/// layout.break_all_lines(Some(40.));
/// let _font = run.font();
/// ```
///
/// [`Debug`]: core::fmt::Debug
#[derive(Clone)]
pub struct Layout<B: Brush> {
    pub(crate) data: LayoutData<B>,
}

impl<B: Brush> fmt::Debug for Layout<B> {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        if f.alternate() {
            f.debug_struct("Layout").field("data", &self.data).finish()
        } else {
            f.debug_struct("Layout")
                .field("text_len", &self.data.shape.text_len)
                .field("width", &self.data.width_data.width)
                .field("height", &self.data.width_data.height)
                .field("lines", &self.data.width_data.lines.len())
                .field("runs", &self.data.shape.runs.len())
                .field("styles", &self.data.shape.styles.len())
                .finish_non_exhaustive()
        }
    }
}

impl<B: Brush> Layout<B> {
    pub(crate) fn read(&self) -> super::read::LayoutRead<'_, B> {
        super::read::LayoutRead::from_layout(self)
    }

    /// Creates an empty layout.
    pub fn new() -> Self {
        Self::default()
    }

    /// Clears the layout while retaining capacity.
    ///
    /// This clears underlying strong references to fonts, which would otherwise
    /// prevent those fonts from being freed until dropping or reusing this layout.
    pub fn clear(&mut self) {
        self.data.clear();
    }

    /// Returns the scale factor provided when creating the layout.
    pub fn scale(&self) -> f32 {
        self.data.shape.scale
    }

    /// Returns the style collection for the layout.
    pub fn styles(&self) -> &[Style<B>] {
        &self.data.shape.styles
    }

    /// The inherent metrics of the root span (in CSS terms, that is the metrics of the
    /// [root inline box](https://www.w3.org/TR/css-inline-3/#root-inline-box)).
    ///
    /// These are available once the layout is built, and will be `None` otherwise.
    /// The metric values come from the first available font and font size resolved
    /// from [`push_default`](crate::RangedBuilder::push_default).
    ///
    /// The motivating use case is placing bullet list markers - Blink uses the root
    /// span's ascent and descent for their location and size.
    pub fn root_span_metrics(&self) -> Option<SpanMetrics> {
        self.data.shape.style_metrics.first().map(|it| SpanMetrics {
            ascent: it.ascent,
            descent: it.descent,
            x_height: it.x_height,
        })
    }

    /// Returns the length of the source text, in bytes.
    pub fn text_len(&self) -> usize {
        self.data.shape.text_len
    }

    /// Returns the alignment that was applied to the layout by [`Layout::align`].
    ///
    /// Returns `None` if the layout has not been aligned since it was last built.
    pub fn alignment(&self) -> Option<Alignment> {
        self.data.width_data.alignment
    }

    /// The `max_advance` that was used to line break the `Layout`
    pub fn layout_max_advance(&self) -> f32 {
        self.data.width_data.layout_max_advance
    }

    /// Returns the computed width of the layout excluding the width of hanging whitespace.
    pub fn width(&self) -> f32 {
        self.data.width_data.width
    }

    /// Returns the computed width of the layout including the width of trailing whitespace.
    pub fn full_width(&self) -> f32 {
        self.data.width_data.full_width
    }

    /// Returns the y-offset of the baseline of the first line in the layout.
    /// Returns `None` if the layout is empty.
    pub fn first_baseline(&self) -> Option<f32> {
        self.lines().next().map(|line| line.metrics().baseline)
    }

    /// Returns the y-offset of the baseline of the last line in the layout.
    /// Returns `None` if the layout is empty.
    pub fn last_baseline(&self) -> Option<f32> {
        self.lines().next_back().map(|line| line.metrics().baseline)
    }

    /// Calculates the lower and upper bounds on the width of the layout. These
    /// are recalculated every time this method is called.
    ///
    /// This method currently may not return the correct results for
    /// mixed-direction text.
    pub fn calculate_content_widths(&self) -> ContentWidths {
        self.data.calculate_content_widths()
    }

    /// Returns the height of the layout.
    pub fn height(&self) -> f32 {
        self.data.width_data.height
    }

    /// Returns the number of lines in the layout.
    pub fn len(&self) -> usize {
        self.data.width_data.lines.len()
    }

    /// Returns `true` if the layout is empty.
    pub fn is_empty(&self) -> bool {
        self.data.width_data.lines.is_empty()
    }

    /// Returns the line at the specified index.
    ///
    /// Returns `None` if the index is out of bounds, i.e. if it's
    /// not less than [`self.len()`](Self::len).
    pub fn get(&self, index: usize) -> Option<Line<'_, B>> {
        self.read().get(index)
    }

    /// Returns `true` if the dominant direction of the layout is right-to-left.
    pub fn is_rtl(&self) -> bool {
        self.data.shape.base_level.is_rtl()
    }

    /// Iterator over inline boxes in text index order.
    pub fn inline_boxes(&self) -> impl ExactSizeIterator<Item = &InlineBox> + '_ {
        self.data.width_data.inline_boxes.iter().map(|b| &b.inline_box)
    }

    /// Mutable iterator over the inline boxes in text index order.
    pub fn inline_boxes_mut(&mut self) -> impl ExactSizeIterator<Item = &mut InlineBox> + '_ {
        self.data.width_data.inline_boxes.iter_mut().map(|b| &mut b.inline_box)
    }

    /// Returns an iterator over the lines in the layout.
    pub fn lines(
        &self,
    ) -> impl ExactSizeIterator<Item = Line<'_, B>> + DoubleEndedIterator + '_ + Clone {
        self.read().lines()
    }

    /// Sets the text-indent for the layout.
    ///
    /// The indent is applied as a margin on the start edge of indented lines, reducing the
    /// available width for line breaking and offsetting content during alignment. Negative
    /// values cause the line to protrude beyond the start edge.
    ///
    /// This must be called before [`Layout::break_all_lines`] or [`Layout::break_lines`],
    /// and before [`Layout::align`].
    pub fn set_text_indent(&mut self, amount: f32, options: IndentOptions) {
        self.data.width_data.indent_amount = amount;
        self.data.width_data.indent_options = options;
    }

    /// Returns line breaker to compute lines for the layout.
    pub fn break_lines(&mut self) -> BreakLines<'_, B> {
        BreakLines::new(self)
    }

    /// Breaks all lines with the specified maximum advance.
    pub fn break_all_lines(&mut self, max_advance: Option<f32>) {
        self.break_lines()
            .break_remaining(max_advance.unwrap_or(f32::MAX));
    }

    /// Apply alignment to the layout.
    ///
    /// You must perform line breaking prior to aligning, through [`Layout::break_lines`] or
    /// [`Layout::break_all_lines`].
    ///
    /// If a finite `max_advance` is supplied to `Layout::break_all_lines` then that width will be applied
    /// relative to that width. Otherwise alignment will be applied relative to the width of the
    /// longest line as computed by line breaking.
    ///
    /// If line-specific `offset` and `max_advance` are set using the advanced methods on the `BreakLines`
    /// struct then each line will be aligned individually within its line box.
    pub fn align(&mut self, alignment: Alignment, options: AlignmentOptions) {
        align(&mut self.data, alignment, options);
    }

    /// Returns the index and `Line` object for the line containing the
    /// given byte `index` in the source text.
    pub(crate) fn line_for_byte_index(&self, index: usize) -> Option<(usize, Line<'_, B>)> {
        self.read().line_for_byte_index(index)
    }

    /// Returns the index and `Line` object for the line containing the
    /// given `offset`.
    ///
    /// The offset is specified in the direction orthogonal to line direction.
    /// For horizontal text, this is a vertical or y offset. If the offset is
    /// on a line boundary, it is considered to be contained by the later line.
    pub(crate) fn line_for_offset(&self, offset: f32) -> Option<(usize, Line<'_, B>)> {
        if offset < 0.0 {
            return Some((0, self.get(0)?));
        }
        let maybe_line_index = self.data.width_data.lines.binary_search_by(|line| {
            if offset < line.metrics.block_min_coord {
                Ordering::Greater
            } else if offset >= line.metrics.block_max_coord {
                Ordering::Less
            } else {
                Ordering::Equal
            }
        });
        let line_index = match maybe_line_index {
            Ok(index) => index,
            Err(index) => index.saturating_sub(1),
        };
        Some((line_index, self.get(line_index)?))
    }
}

impl<B: Brush> Default for Layout<B> {
    fn default() -> Self {
        Self {
            data: LayoutData::default(),
        }
    }
}
