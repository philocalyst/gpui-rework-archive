use crate::{
    App, Bounds, InlineLayout, LineLayout, PaintFragment, Pixels, Point, Result, ShapedTextLayout,
    SharedString, TextAlign, TextSystem, UnderlineStyle, VisualLine, Window, fill, point, size,
};
use derive_more::{Deref, DerefMut};
use std::{
    ops::Range,
    sync::{
        Arc,
        atomic::{AtomicUsize, Ordering},
    },
};

static GLYPH_PAINT_ERRORS: AtomicUsize = AtomicUsize::new(0);
const MAX_LOGGED_GLYPH_PAINT_ERRORS: usize = 20;

/// A shaped line that is ready to measure and paint.
///
/// [`WindowTextSystem::shape_line`](crate::WindowTextSystem::shape_line) does
/// the expensive shaping work. Reuse the result to measure with
/// [`ShapedLine::width`] and paint on each frame. Paint backgrounds first with
/// [`ShapedLine::paint_background`] when a row needs to sit behind other content.
///
/// # Examples
///
/// ```
/// # use gpui::{EmptyView, TestApp, TextRun, font, hsla, px};
/// # let mut app = TestApp::new();
/// # let mut window = app.open_window(|_window, _cx| EmptyView);
/// window.update(|_view, window, _cx| {
///     let run = TextRun {
///         len: "Hi".len(),
///         font: font("Lilex"),
///         color: hsla(0., 0., 0., 1.),
///         ..Default::default()
///     };
///     let line = window.text_system().shape_line("Hi".into(), px(16.), &[run]);
///     assert_eq!(line.text.as_ref(), "Hi");
///     assert_eq!(line.len(), 2);
/// });
/// ```
#[derive(Clone, Debug, Deref, DerefMut)]
pub struct ShapedLine {
    #[deref]
    #[deref_mut]
    pub(crate) layout: Arc<LineLayout>,
    /// The text that was shaped for this line.
    pub text: SharedString,
}

impl ShapedLine {
    /// Returns the length of the line in UTF-8 bytes.
    #[allow(clippy::len_without_is_empty)]
    pub fn len(&self) -> usize {
        self.layout.len
    }

    /// Returns a forward-only cursor over backend cluster boundaries.
    pub fn cursor(&self) -> ShapedLineCursor<'_> {
        assert_eq!(
            self.len(),
            self.text.len(),
            "cannot slice an adjusted-length line"
        );
        let h = self.layout.ascent + self.layout.descent;
        let x = self
            .layout
            .platform_layout
            .caret_bounds(crate::CaretPosition::attached_to_next_cluster(0), h)
            .map_or(Pixels::ZERO, |b| b.origin.x);
        ShapedLineCursor {
            line: self,
            byte_index: 0,
            x_offset: x,
        }
    }
    /// Splits at a UTF-8 and shaping-cluster boundary without reshaping either half.
    pub fn split_at(&self, i: usize) -> (ShapedLine, ShapedLine) {
        assert!(i <= self.len(), "split exceeds line");
        assert!(
            self.text.is_char_boundary(i),
            "split is not a UTF-8 boundary"
        );
        assert!(
            self.is_cluster_boundary(i),
            "split falls inside a shaped cluster"
        );
        (self.slice(0..i), self.slice(i..self.len()))
    }
    fn is_cluster_boundary(&self, i: usize) -> bool {
        i == 0
            || i == self.len()
            || self
                .layout
                .platform_layout
                .normalized_caret(crate::CaretPosition::attached_to_next_cluster(i))
                .index
                == i
    }
    fn slice(&self, source: Range<usize>) -> ShapedLine {
        let h = self.layout.ascent + self.layout.descent;
        let bounds = if source.is_empty() {
            Vec::new()
        } else {
            self.layout
                .platform_layout
                .selection_bounds(source.clone(), h)
        };
        let x0 = bounds
            .iter()
            .map(|b| b.origin.x)
            .reduce(|a, b| a.min(b))
            .unwrap_or_else(|| {
                self.layout
                    .platform_layout
                    .caret_bounds(
                        crate::CaretPosition::attached_to_next_cluster(source.start),
                        h,
                    )
                    .map_or(Pixels::ZERO, |b| b.origin.x)
            });
        let x1 = bounds
            .iter()
            .map(|b| b.origin.x + b.size.width)
            .reduce(|a, b| a.max(b))
            .unwrap_or(x0);
        let width = (x1 - x0).max(Pixels::ZERO);
        let mut fragments = Vec::new();
        for f in &self.layout.paint_fragments {
            let start = source.start.max(f.source_range.start);
            let end = source.end.min(f.source_range.end);
            if start >= end {
                continue;
            }
            let Some(ranges) = &f.glyph_source_ranges else {
                assert_eq!(
                    start..end,
                    f.source_range,
                    "backend lacks cluster ranges for partial slicing"
                );
                let mut part = f.clone();
                part.glyphs = f
                    .glyphs
                    .iter()
                    .cloned()
                    .map(|mut g| {
                        g.position.x -= x0;
                        g
                    })
                    .collect::<Vec<_>>()
                    .into();
                part.x_range = f.x_range.start - x0..f.x_range.end - x0;
                part.source_range = start - source.start..end - source.start;
                fragments.push(part);
                continue;
            };
            assert_eq!(ranges.len(), f.glyphs.len(), "glyph/range map mismatch");
            let mut glyphs = Vec::new();
            let mut mapped = Vec::new();
            for (g, r) in f.glyphs.iter().zip(ranges.iter()) {
                if r.start >= start && r.end <= end {
                    let mut g = g.clone();
                    g.position.x -= x0;
                    glyphs.push(g);
                    mapped.push(r.start - source.start..r.end - source.start)
                }
            }
            let mut fragment_bounds = Vec::new();
            fragment_bounds.extend(
                self.layout
                    .platform_layout
                    .selection_bounds(start..end, h)
                    .into_iter()
                    .filter(|bounds| {
                        bounds.origin.x < f.x_range.end
                            && bounds.origin.x + bounds.size.width > f.x_range.start
                    }),
            );
            let left = fragment_bounds
                .iter()
                .map(|bounds| bounds.origin.x.max(f.x_range.start))
                .reduce(|a, b| a.min(b))
                .unwrap_or(x0);
            let right = fragment_bounds
                .iter()
                .map(|bounds| (bounds.origin.x + bounds.size.width).min(f.x_range.end))
                .reduce(|a, b| a.max(b))
                .unwrap_or(left);
            let mut part = f.clone();
            part.glyphs = glyphs.into();
            part.glyph_source_ranges = Some(mapped.into());
            part.x_range = left - x0..right - x0;
            part.source_range = start - source.start..end - source.start;
            fragments.push(part)
        }
        let direction = self
            .layout
            .visual_lines
            .first()
            .map_or(crate::ResolvedDirection::LeftToRight, |l| l.direction);
        let layout = Arc::new(LineLayout {
            font_size: self.layout.font_size,
            width,
            ascent: self.layout.ascent,
            descent: self.layout.descent,
            visual_lines: smallvec::smallvec![VisualLine {
                text_range: 0..source.len(),
                paint_fragment_range: 0..fragments.len(),
                advance_width: width,
                offset: Pixels::ZERO,
                direction
            }],
            paint_fragments: fragments,
            len: source.len(),
            platform_layout: Arc::new(SlicedPlatformTextLayout {
                inner: self.layout.platform_layout.clone(),
                source: source.clone(),
                x_origin: x0,
                size: crate::size(width, self.layout.platform_layout.size().height),
            }),
        });
        ShapedLine {
            layout,
            text: SharedString::new(&self.text[source]),
        }
    }
    /// Returns the width of the line in logical pixels.
    ///
    /// This is the glyph advance width from the text shaping system. Use it to
    /// advance a "pen" when you paint several lines or fragments on one row.
    pub fn width(&self) -> Pixels {
        self.layout.width
    }

    /// Paints the glyphs, underlines, and strikethroughs of the line.
    ///
    /// `origin` is the top-left corner of the line box, which is `line_height`
    /// tall. The baseline is placed inside that box, centered by the font's
    /// ascent and descent. When `align_width` is `Some`, the line is aligned
    /// within that width using `align`. Otherwise it is aligned in its own width.
    ///
    /// Call this during paint. Background colors are not painted here, so call
    /// [`ShapedLine::paint_background`] first.
    ///
    /// # Errors
    ///
    /// Returns an error only if the window's paint layer fails. A glyph that
    /// fails to paint is logged and skipped, and the call still succeeds.
    pub fn paint(
        &self,
        origin: Point<Pixels>,
        line_height: Pixels,
        align: TextAlign,
        align_width: Option<Pixels>,
        window: &mut Window,
        cx: &mut App,
    ) -> Result<()> {
        self.paint_with_underline_handler(
            origin,
            line_height,
            align,
            align_width,
            window,
            cx,
            |_, origin, width, style, window| window.paint_underline(origin, width, style),
        )
    }

    /// Paints the line and calls the handler for every visual underline fragment.
    ///
    /// The callback receives the original UTF-8 byte range, visual position and width of the
    /// underline, its resolved style, and the window. The byte range stays in logical source
    /// order even when bidirectional layout paints fragments in visual order.
    pub fn paint_with_underline_handler(
        &self,
        origin: Point<Pixels>,
        line_height: Pixels,
        align: TextAlign,
        align_width: Option<Pixels>,
        window: &mut Window,
        cx: &mut App,
        mut paint_underline: impl FnMut(
            Range<usize>,
            Point<Pixels>,
            Pixels,
            &UnderlineStyle,
            &mut Window,
        ),
    ) -> Result<()> {
        paint_visual_text(
            origin,
            &self.layout,
            line_height,
            align,
            align_width,
            &self.layout.visual_lines,
            TextPaintPass::Foreground,
            window,
            cx,
            &mut paint_underline,
        )
    }

    /// Paints the background color of each run in the line.
    ///
    /// The arguments match [`ShapedLine::paint`]. Call this before `paint`, so
    /// that the glyphs are drawn over the backgrounds.
    pub fn paint_background(
        &self,
        origin: Point<Pixels>,
        line_height: Pixels,
        align: TextAlign,
        align_width: Option<Pixels>,
        window: &mut Window,
        cx: &mut App,
    ) -> Result<()> {
        paint_visual_text(
            origin,
            &self.layout,
            line_height,
            align,
            align_width,
            &self.layout.visual_lines,
            TextPaintPass::Background,
            window,
            cx,
            &mut paint_underline_default,
        )
    }
}

/// Forward-only cursor over a shaped line's backend cluster boundaries.
pub struct ShapedLineCursor<'a> {
    line: &'a ShapedLine,
    byte_index: usize,
    x_offset: Pixels,
}
impl ShapedLineCursor<'_> {
    /// Takes text since the last boundary, retaining original shaped glyphs.
    pub fn take_until(&mut self, i: usize) -> ShapedLine {
        assert!(i >= self.byte_index, "cursor cannot move backward");
        assert!(
            i <= self.line.len() && self.line.text.is_char_boundary(i),
            "invalid cursor boundary"
        );
        assert!(
            self.line.is_cluster_boundary(i),
            "cursor boundary splits a shaping cluster"
        );
        let result = self.line.slice(self.byte_index..i);
        self.byte_index = i;
        let h = self.line.layout.ascent + self.line.layout.descent;
        self.x_offset = self
            .line
            .layout
            .platform_layout
            .caret_bounds(crate::CaretPosition::attached_to_next_cluster(i), h)
            .map_or(self.x_offset, |b| b.origin.x);
        result
    }
    /// Original-layout caret x at the current source boundary.
    pub fn x_offset(&self) -> Pixels {
        self.x_offset
    }
}
#[derive(Debug)]
struct SlicedPlatformTextLayout {
    inner: Arc<dyn crate::PlatformTextLayout>,
    source: Range<usize>,
    x_origin: Pixels,
    size: crate::Size<Pixels>,
}
impl SlicedPlatformTextLayout {
    fn to_inner(&self, i: usize) -> usize {
        self.source.start + i.min(self.source.len())
    }
    fn from_inner(&self, i: usize) -> usize {
        i.saturating_sub(self.source.start).min(self.source.len())
    }
    fn caret(&self, mut c: crate::CaretPosition) -> crate::CaretPosition {
        c.index = self.from_inner(c.index);
        c
    }
    fn bounds(&self, mut b: crate::Bounds<Pixels>) -> crate::Bounds<Pixels> {
        b.origin.x -= self.x_origin;
        b
    }
}
impl crate::PlatformTextLayout for SlicedPlatformTextLayout {
    fn len(&self) -> usize {
        self.source.len()
    }
    fn line_count(&self) -> usize {
        self.inner.line_count()
    }
    fn size(&self) -> crate::Size<Pixels> {
        self.size
    }
    fn byte_index_from_pixel_point(
        &self,
        mut p: Point<Pixels>,
        h: Pixels,
    ) -> std::result::Result<usize, usize> {
        p.x += self.x_origin;
        self.inner
            .byte_index_from_pixel_point(p, h)
            .map(|i| self.from_inner(i))
            .map_err(|i| self.from_inner(i))
    }
    fn caret_from_pixel_point(
        &self,
        mut p: Point<Pixels>,
        h: Pixels,
    ) -> std::result::Result<crate::CaretPosition, crate::CaretPosition> {
        p.x += self.x_origin;
        self.inner
            .caret_from_pixel_point(p, h)
            .map(|c| self.caret(c))
            .map_err(|c| self.caret(c))
    }
    fn caret_bounds(
        &self,
        mut c: crate::CaretPosition,
        h: Pixels,
    ) -> Option<crate::Bounds<Pixels>> {
        c.index = self.to_inner(c.index);
        self.inner.caret_bounds(c, h).map(|b| self.bounds(b))
    }
    fn normalized_caret(&self, mut c: crate::CaretPosition) -> crate::CaretPosition {
        c.index = self.to_inner(c.index);
        self.caret(self.inner.normalized_caret(c))
    }
    fn adjacent_visual_caret(
        &self,
        mut c: crate::CaretPosition,
        d: crate::VisualDirection,
    ) -> Option<crate::CaretPosition> {
        c.index = self.to_inner(c.index);
        let origin = c;
        let mut current = c;
        // A logical slice may occupy multiple visual spans in bidi text. Skip full-layout
        // neighbors outside the slice, but stop at the first included visual caret.
        // The byte-length bound also makes malformed backend cycles fail closed.
        let max_steps = self.inner.len().saturating_mul(2).saturating_add(2);
        for _ in 0..max_steps {
            let next = self.inner.adjacent_visual_caret(current, d)?;
            if (next.index == current.index && next.affinity == current.affinity)
                || (next.index == origin.index && next.affinity == origin.affinity)
            {
                return None;
            }
            if (self.source.start..=self.source.end).contains(&next.index) {
                return Some(self.caret(next));
            }
            current = next;
        }
        None
    }
    fn selection_bounds(&self, r: Range<usize>, h: Pixels) -> Vec<crate::Bounds<Pixels>> {
        self.inner
            .selection_bounds(self.to_inner(r.start)..self.to_inner(r.end), h)
            .into_iter()
            .map(|b| self.bounds(b))
            .collect()
    }
    fn inline_geometry(&self, r: Range<usize>) -> Option<Vec<crate::InlineRangeGeometry>> {
        self.inner
            .inline_geometry(self.to_inner(r.start)..self.to_inner(r.end))
            .map(|v| {
                v.into_iter()
                    .map(|mut g| {
                        g.bounds = self.bounds(g.bounds);
                        g
                    })
                    .collect()
            })
    }
    fn logical_cluster_before(&self, mut c: crate::CaretPosition) -> Option<Range<usize>> {
        c.index = self.to_inner(c.index);
        self.inner.logical_cluster_before(c).and_then(|r| {
            (r.start >= self.source.start && r.end <= self.source.end)
                .then(|| self.from_inner(r.start)..self.from_inner(r.end))
        })
    }
    fn logical_cluster_after(&self, mut c: crate::CaretPosition) -> Option<Range<usize>> {
        c.index = self.to_inner(c.index);
        self.inner.logical_cluster_after(c).and_then(|r| {
            (r.start >= self.source.start && r.end <= self.source.end)
                .then(|| self.from_inner(r.start)..self.from_inner(r.end))
        })
    }
    fn caret_movement(
        &self,
        mut c: crate::CaretPosition,
        m: crate::TextMovement,
        x: Option<Pixels>,
    ) -> crate::CaretMovement {
        c.index = self.to_inner(c.index);
        let mut o = self
            .inner
            .caret_movement(c, m, x.map(|v| v + self.x_origin));
        o.result = self.caret(o.result);
        o.vertical_navigation_x = o.vertical_navigation_x.map(|v| v - self.x_origin);
        o
    }
    fn selection_from_pixel_point(
        &self,
        mut p: Point<Pixels>,
        h: Pixels,
        k: crate::TextSelectionKind,
    ) -> Range<usize> {
        p.x += self.x_origin;
        let r = self.inner.selection_from_pixel_point(p, h, k);
        self.from_inner(r.start)..self.from_inner(r.end)
    }
}

#[cfg(test)]
mod cursor_tests {
    use super::*;
    use crate::{
        CaretMovement, ResolvedDirection, TextMovement, TextSelectionKind, VisualDirection, point,
        size,
    };
    use std::sync::Arc;

    #[derive(Debug)]
    struct MockLayout {
        clusters: Vec<Range<usize>>,
        positions: Vec<f32>,
        text_len: usize,
        visual_stops: Vec<usize>,
    }
    impl MockLayout {
        fn snap(&self, i: usize) -> usize {
            self.clusters
                .iter()
                .find(|r| r.start < i && i < r.end)
                .map_or(i, |r| r.start)
        }
        fn caret_x(&self, i: usize) -> Pixels {
            match i {
                0 => px(0.),
                3 => px(10.),
                5 => px(20.),
                7 => px(30.),
                8 => px(40.),
                _ => px(0.),
            }
        }
    }
    impl crate::PlatformTextLayout for MockLayout {
        fn len(&self) -> usize {
            self.text_len
        }
        fn line_count(&self) -> usize {
            1
        }
        fn size(&self) -> crate::Size<Pixels> {
            size(px(40.), px(16.))
        }
        fn byte_index_from_pixel_point(
            &self,
            p: Point<Pixels>,
            _h: Pixels,
        ) -> std::result::Result<usize, usize> {
            Ok(self
                .clusters
                .iter()
                .find(|r| p.x < self.caret_x(r.end))
                .map_or(self.text_len, |r| r.start))
        }
        fn caret_from_pixel_point(
            &self,
            p: Point<Pixels>,
            h: Pixels,
        ) -> std::result::Result<crate::CaretPosition, crate::CaretPosition> {
            Ok(crate::CaretPosition::attached_to_next_cluster(
                self.byte_index_from_pixel_point(p, h).unwrap(),
            ))
        }
        fn caret_bounds(
            &self,
            c: crate::CaretPosition,
            _h: Pixels,
        ) -> Option<crate::Bounds<Pixels>> {
            Some(crate::Bounds::new(
                point(self.caret_x(c.index), px(0.)),
                size(px(1.), px(16.)),
            ))
        }
        fn normalized_caret(&self, mut c: crate::CaretPosition) -> crate::CaretPosition {
            c.index = self.snap(c.index);
            c
        }
        fn adjacent_visual_caret(
            &self,
            c: crate::CaretPosition,
            d: VisualDirection,
        ) -> Option<crate::CaretPosition> {
            let position = self
                .visual_stops
                .iter()
                .position(|index| *index == c.index)?;
            let next = match d {
                VisualDirection::Left => position.checked_sub(1)?,
                VisualDirection::Right => position.checked_add(1)?,
            };
            self.visual_stops
                .get(next)
                .copied()
                .map(|index| crate::CaretPosition {
                    index,
                    affinity: c.affinity,
                })
        }
        fn selection_bounds(&self, r: Range<usize>, _h: Pixels) -> Vec<crate::Bounds<Pixels>> {
            self.clusters
                .iter()
                .enumerate()
                .filter(|(_, c)| c.start < r.end && r.start < c.end)
                .map(|(i, _)| {
                    crate::Bounds::new(point(px(self.positions[i]), px(0.)), size(px(10.), px(16.)))
                })
                .collect()
        }
        fn logical_cluster_before(&self, c: crate::CaretPosition) -> Option<Range<usize>> {
            self.clusters
                .iter()
                .rev()
                .find(|r| r.start < c.index)
                .cloned()
        }
        fn logical_cluster_after(&self, c: crate::CaretPosition) -> Option<Range<usize>> {
            self.clusters.iter().find(|r| r.end > c.index).cloned()
        }
        fn caret_movement(
            &self,
            c: crate::CaretPosition,
            _m: TextMovement,
            x: Option<Pixels>,
        ) -> CaretMovement {
            CaretMovement {
                result: c,
                vertical_navigation_x: x,
            }
        }
        fn selection_from_pixel_point(
            &self,
            _p: Point<Pixels>,
            _h: Pixels,
            _k: TextSelectionKind,
        ) -> Range<usize> {
            0..0
        }
    }
    fn shaped() -> ShapedLine {
        let text = "a\u{301}אבZ";
        let ranges = vec![0..3, 3..5, 5..7, 7..8];
        let visual_ranges = vec![0..3, 5..7, 3..5, 7..8];
        let x = [0., 20., 10., 30.];
        let glyphs = visual_ranges
            .iter()
            .enumerate()
            .map(|(i, _)| crate::ShapedGlyph {
                id: crate::GlyphId(i as u32),
                position: point(px(x[i]), px(0.)),
                is_emoji: false,
            })
            .collect::<Vec<_>>();
        let fragment = PaintFragment {
            source_run: 0,
            source_range: 0..text.len(),
            font_id: crate::FontId(0),
            font_size: px(12.),
            glyphs: glyphs.into(),
            glyph_source_ranges: Some(visual_ranges.into()),
            x_range: px(0.)..px(40.),
            style: Default::default(),
            underline_offset: None,
            strikethrough_offset: None,
        };
        let layout = Arc::new(LineLayout {
            font_size: px(12.),
            width: px(40.),
            ascent: px(12.),
            descent: px(4.),
            visual_lines: smallvec::smallvec![VisualLine {
                text_range: 0..text.len(),
                paint_fragment_range: 0..1,
                advance_width: px(40.),
                offset: px(0.),
                direction: ResolvedDirection::LeftToRight
            }],
            paint_fragments: vec![fragment],
            len: text.len(),
            platform_layout: Arc::new(MockLayout {
                clusters: ranges,
                positions: vec![0., 10., 20., 30.],
                text_len: text.len(),
                visual_stops: vec![0, 3, 7, 5, 8],
            }),
        });
        ShapedLine {
            layout,
            text: SharedString::new(text),
        }
    }
    #[test]
    fn split_rebases_cluster_ranges_and_caret_geometry_without_reordering_glyphs() {
        let line = shaped();
        let (left, right) = line.split_at(3);
        assert_eq!(left.text.as_ref(), "a\u{301}");
        assert_eq!(right.text.as_ref(), "אבZ");
        assert_eq!(
            left.layout.paint_fragments[0]
                .glyph_source_ranges
                .as_deref(),
            Some(&[0..3][..])
        );
        assert_eq!(
            right.layout.paint_fragments[0]
                .glyph_source_ranges
                .as_deref(),
            Some(&[2..4, 0..2, 4..5][..])
        );
        assert_eq!(
            right.layout.paint_fragments[0]
                .glyphs
                .iter()
                .map(|g| g.position.x)
                .collect::<Vec<_>>(),
            vec![px(10.), px(0.), px(20.)]
        );
        assert_eq!(
            right
                .layout
                .platform_layout
                .caret_bounds(crate::CaretPosition::attached_to_next_cluster(0), px(16.))
                .unwrap()
                .origin
                .x,
            px(0.)
        );
        assert_eq!(
            right
                .layout
                .platform_layout
                .logical_cluster_after(crate::CaretPosition::attached_to_next_cluster(0)),
            Some(0..2)
        );
    }
    #[test]
    #[should_panic(expected = "shaped cluster")]
    fn split_rejects_a_boundary_inside_combining_cluster() {
        shaped().split_at(1);
    }
    #[test]
    fn sliced_visual_navigation_skips_excluded_bidi_spans_without_false_progress() {
        let line = shaped();
        let (slice, _) = line.split_at(5);
        let layout = &slice.layout.platform_layout;
        let next = layout
            .adjacent_visual_caret(
                crate::CaretPosition::attached_to_next_cluster(3),
                VisualDirection::Right,
            )
            .expect("the later in-slice visual span remains reachable");
        assert_eq!(next.index, 5);

        assert_eq!(
            layout.adjacent_visual_caret(next, VisualDirection::Right),
            None,
            "excluded stops beyond the slice must not clamp back to a successful endpoint"
        );
    }

    #[test]
    fn cursor_tracks_source_boundary_and_mixed_bidi_visual_x() {
        let line = shaped();
        let mut c = line.cursor();
        assert_eq!(c.take_until(3).text.as_ref(), "a\u{301}");
        assert_eq!(c.x_offset(), px(10.));
        assert_eq!(c.take_until(7).text.as_ref(), "אב");
        assert_eq!(c.x_offset(), px(30.));
        assert_eq!(c.take_until(8).text.as_ref(), "Z");
    }
}

/// Shaped text that may contain hard breaks and soft-wrapped lines.
///
/// [`WindowTextSystem::shape_text`](crate::WindowTextSystem::shape_text) returns
/// one visual line for each wrapped or hard-broken line. Paint it with
/// [`ShapedText::paint`], and paint backgrounds first with
/// [`ShapedText::paint_background`]. It derefs to [`ShapedTextLayout`], so the
/// same result supplies measurements such as [`ShapedTextLayout::size`] and
/// [`ShapedTextLayout::line_count`].
///
/// # Examples
///
/// ```
/// # use gpui::{EmptyView, TestApp, TextRun, font, hsla, px};
/// # let mut app = TestApp::new();
/// # let mut window = app.open_window(|_window, _cx| EmptyView);
/// window.update(|_view, window, _cx| {
///     let text = "Hello\nworld";
///     let run = TextRun {
///         len: text.len(),
///         font: font("Lilex"),
///         color: hsla(0., 0., 0., 1.),
///         ..Default::default()
///     };
///     let shaped = window
///         .text_system()
///         .shape_text(text, px(16.), &[run], None, None)
///         .unwrap();
///     assert_eq!(shaped.len(), text.len());
/// });
/// ```
#[derive(Debug, Deref, DerefMut)]
pub struct ShapedText {
    #[deref]
    #[deref_mut]
    pub(crate) layout: Arc<ShapedTextLayout>,
    /// The text that was shaped.
    pub text: SharedString,
}

impl ShapedText {
    /// Returns the length of the text in UTF-8 bytes.
    #[allow(clippy::len_without_is_empty)]
    pub fn len(&self) -> usize {
        self.layout.len()
    }

    /// Paints the glyphs and decorations of every visual line.
    ///
    /// `origin` is the top-left corner of the first line. Each following line
    /// starts `line_height` below the previous one. `bounds` supplies the width
    /// used for alignment; when it is `None`, the layout's wrap width is used.
    /// See [`ShapedLine::paint`] for how the arguments place the text.
    ///
    /// # Errors
    ///
    /// Returns an error only if the window's paint layer fails. A glyph that
    /// fails to paint is logged and skipped.
    pub fn paint(
        &self,
        origin: Point<Pixels>,
        line_height: Pixels,
        align: TextAlign,
        bounds: Option<Bounds<Pixels>>,
        window: &mut Window,
        cx: &mut App,
    ) -> Result<()> {
        let align_width = match bounds {
            Some(bounds) => Some(bounds.size.width),
            None => self.layout.wrap_width,
        };

        paint_visual_text(
            origin,
            &self.layout.layout,
            line_height,
            align,
            align_width,
            &self.layout.visual_lines,
            TextPaintPass::Foreground,
            window,
            cx,
            &mut paint_underline_default,
        )
    }

    /// Paints the background colors of every visual line before the foreground.
    /// The arguments have the same meaning as [`ShapedText::paint`].
    pub fn paint_background(
        &self,
        origin: Point<Pixels>,
        line_height: Pixels,
        align: TextAlign,
        bounds: Option<Bounds<Pixels>>,
        window: &mut Window,
        cx: &mut App,
    ) -> Result<()> {
        let align_width = match bounds {
            Some(bounds) => Some(bounds.size.width),
            None => self.layout.wrap_width,
        };

        paint_visual_text(
            origin,
            &self.layout.layout,
            line_height,
            align,
            align_width,
            &self.layout.visual_lines,
            TextPaintPass::Background,
            window,
            cx,
            &mut paint_underline_default,
        )
    }
}

impl InlineLayout {
    /// Paints the background color of each text run in the inline layout.
    ///
    /// `origin` is the top-left corner of the layout's box. Call this before
    /// [`InlineLayout::paint`].
    pub fn paint_background(
        &self,
        origin: Point<Pixels>,
        window: &mut Window,
        cx: &mut App,
    ) -> Result<()> {
        paint_inline_layout(self, origin, TextPaintPass::Background, window, cx)
    }

    /// Paints the glyphs and underlines or strikethroughs of the inline layout.
    ///
    /// `origin` is the top-left corner of the layout's box. This method paints
    /// only text. The atomic boxes in [`InlineLayout::boxes`] are not painted here.
    pub fn paint(&self, origin: Point<Pixels>, window: &mut Window, cx: &mut App) -> Result<()> {
        paint_inline_layout(self, origin, TextPaintPass::Foreground, window, cx)
    }
}

#[derive(Clone, Copy, PartialEq)]
enum TextPaintPass {
    Background,
    Foreground,
}

struct FragmentPaintContext<'a> {
    line_origin: Point<Pixels>,
    line_height: Pixels,
    baseline_y: Pixels,
    layout: &'a LineLayout,
    pass: TextPaintPass,
    text_system: &'a TextSystem,
}

fn paint_inline_layout(
    inline: &InlineLayout,
    origin: Point<Pixels>,
    pass: TextPaintPass,
    window: &mut Window,
    cx: &mut App,
) -> Result<()> {
    if inline.lines.is_empty() {
        return Ok(());
    }

    let text_system = cx.text_system().clone();
    let placement = place_inline_layout(origin, inline.alignment_offset, window);
    window.paint_layer(Bounds::new(placement.origin, inline.size), |window| {
        for (line, visual_line) in inline.lines.iter().zip(&inline.layout.visual_lines) {
            let line_origin = origin + line.origin + placement.delta;
            paint_visual_line(
                &inline.layout,
                visual_line,
                line_origin,
                line.size.height,
                line_origin.y + line.baseline,
                pass,
                &text_system,
                window,
                &mut paint_underline_default,
            );
        }

        Ok(())
    })
}

#[derive(Clone, Copy, Debug, PartialEq)]
pub(crate) struct InlineLayoutPlacement {
    pub(crate) origin: Point<Pixels>,
    pub(crate) delta: Point<Pixels>,
}

pub(crate) fn place_inline_layout(
    content_origin: Point<Pixels>,
    alignment_offset: Pixels,
    window: &Window,
) -> InlineLayoutPlacement {
    let anchor = content_origin + point(alignment_offset, Pixels::ZERO);
    let placed_anchor = window.pixel_snap_point(anchor);
    let delta = placed_anchor - anchor;

    InlineLayoutPlacement {
        origin: content_origin + delta,
        delta,
    }
}

fn paint_visual_line(
    layout: &LineLayout,
    visual_line: &VisualLine,
    line_origin: Point<Pixels>,
    line_height: Pixels,
    baseline_y: Pixels,
    pass: TextPaintPass,
    text_system: &TextSystem,
    window: &mut Window,
    paint_underline: &mut dyn FnMut(
        Range<usize>,
        Point<Pixels>,
        Pixels,
        &UnderlineStyle,
        &mut Window,
    ),
) {
    let context = FragmentPaintContext {
        line_origin,
        line_height,
        baseline_y,
        layout,
        pass,
        text_system,
    };
    for fragment in &layout.paint_fragments[visual_line.paint_fragment_range.clone()] {
        paint_text_fragment(fragment, &context, window, paint_underline);
    }
}

fn paint_text_fragment(
    fragment: &PaintFragment,
    context: &FragmentPaintContext<'_>,
    window: &mut Window,
    paint_underline: &mut dyn FnMut(
        Range<usize>,
        Point<Pixels>,
        Pixels,
        &UnderlineStyle,
        &mut Window,
    ),
) {
    paint_fragment_decorations_at(
        fragment,
        context.line_origin,
        context.line_height,
        context.baseline_y,
        context.layout,
        window,
        context.pass == TextPaintPass::Foreground,
        paint_underline,
    );
    if context.pass == TextPaintPass::Background {
        return;
    }

    let max_glyph_size = context
        .text_system
        .bounding_box(fragment.font_id, fragment.font_size)
        .size;
    for glyph in &*fragment.glyphs {
        let cull_origin = point(
            context.line_origin.x + glyph.position.x,
            context.line_origin.y,
        );
        if !Bounds::new(cull_origin, max_glyph_size).intersects(&window.content_mask().bounds) {
            continue;
        }

        let glyph_origin = point(
            context.line_origin.x + glyph.position.x,
            context.baseline_y + glyph.position.y,
        );
        let result = if glyph.is_emoji {
            window.paint_emoji_with_color(
                glyph_origin,
                fragment.font_id,
                glyph.id,
                fragment.font_size,
                fragment.style.color,
            )
        } else {
            window.paint_glyph(
                glyph_origin,
                fragment.font_id,
                glyph.id,
                fragment.font_size,
                fragment.style.color,
            )
        };

        if let Err(error) = result {
            let error_idx = GLYPH_PAINT_ERRORS.fetch_add(1, Ordering::Relaxed);

            if error_idx < MAX_LOGGED_GLYPH_PAINT_ERRORS {
                log::error!(
                    "failed to paint glyph {:?} from font {:?}: {error:#}",
                    glyph.id,
                    fragment.font_id
                );
            } else if error_idx == MAX_LOGGED_GLYPH_PAINT_ERRORS {
                log::error!("suppressing further glyph paint errors");
            }
        }
    }
}

fn paint_underline_default(
    _source_range: Range<usize>,
    origin: Point<Pixels>,
    width: Pixels,
    style: &UnderlineStyle,
    window: &mut Window,
) {
    window.paint_underline(origin, width, style);
}

fn paint_visual_text(
    origin: Point<Pixels>,
    layout: &LineLayout,
    line_height: Pixels,
    align: TextAlign,
    align_width: Option<Pixels>,
    visual_lines: &[VisualLine],
    pass: TextPaintPass,
    window: &mut Window,
    cx: &mut App,
    paint_underline: &mut dyn FnMut(
        Range<usize>,
        Point<Pixels>,
        Pixels,
        &UnderlineStyle,
        &mut Window,
    ),
) -> Result<()> {
    if visual_lines.is_empty() {
        return Ok(());
    }

    let line_bounds = visual_text_bounds(origin, line_height, align, align_width, visual_lines);
    window.paint_layer(line_bounds, |window| {
        let padding_top = (line_height - layout.ascent - layout.descent) / 2.;
        let text_system = cx.text_system().clone();

        for (line_index, line) in visual_lines.iter().enumerate() {
            let line_origin = point(
                visual_line_origin_x(origin.x, align, align_width, line),
                origin.y + line_index as f32 * line_height,
            );
            paint_visual_line(
                layout,
                line,
                line_origin,
                line_height,
                line_origin.y + padding_top + layout.ascent,
                pass,
                &text_system,
                window,
                paint_underline,
            );
        }

        Ok(())
    })
}

fn visual_text_bounds(
    origin: Point<Pixels>,
    line_height: Pixels,
    align: TextAlign,
    align_width: Option<Pixels>,
    visual_lines: &[VisualLine],
) -> Bounds<Pixels> {
    let mut left = Pixels::MAX;
    let mut right = Pixels::MIN;

    for line in visual_lines {
        let line_left = visual_line_origin_x(origin.x, align, align_width, line);
        left = left.min(line_left);
        right = right.max(line_left + line.advance_width);
    }
    Bounds::new(
        point(left, origin.y),
        size(right - left, line_height * visual_lines.len() as f32),
    )
}

fn visual_line_origin_x(
    origin_x: Pixels,
    align: TextAlign,
    align_width: Option<Pixels>,
    line: &VisualLine,
) -> Pixels {
    line.offset
        + aligned_visual_origin_x(
            origin_x,
            align_width.unwrap_or(line.advance_width),
            line.advance_width,
            align,
            line.direction,
        )
}

fn paint_fragment_decorations_at(
    fragment: &PaintFragment,
    line_origin: Point<Pixels>,
    line_height: Pixels,
    baseline_y: Pixels,
    layout: &LineLayout,
    window: &mut Window,
    foreground: bool,
    paint_underline: &mut dyn FnMut(
        Range<usize>,
        Point<Pixels>,
        Pixels,
        &UnderlineStyle,
        &mut Window,
    ),
) {
    let range = line_origin.x + fragment.x_range.start..line_origin.x + fragment.x_range.end;
    if foreground {
        if let Some(mut underline) = fragment.style.underline {
            underline.color = Some(underline.color.unwrap_or(fragment.style.color));
            paint_underline(
                fragment.source_range.clone(),
                point(
                    range.start,
                    baseline_y + fragment.underline_offset.unwrap_or(layout.descent * 0.618),
                ),
                range.end - range.start,
                &underline,
                window,
            );
        }
        if let Some(mut strike) = fragment.style.strikethrough {
            strike.color = Some(strike.color.unwrap_or(fragment.style.color));
            let strike_y = baseline_y
                + fragment
                    .strikethrough_offset
                    .unwrap_or(-layout.ascent * 0.5);
            window.paint_strikethrough(
                point(range.start, strike_y),
                range.end - range.start,
                &strike,
            );
        }
    } else if let Some(color) = fragment.style.background_color {
        window.paint_quad(fill(
            Bounds::new(
                point(range.start, line_origin.y),
                size(range.end - range.start, line_height),
            ),
            color,
        ));
    }
}

fn aligned_visual_origin_x(
    origin_x: Pixels,
    align_width: Pixels,
    line_width: Pixels,
    align: TextAlign,
    direction: crate::ResolvedDirection,
) -> Pixels {
    match align {
        TextAlign::Start if direction.is_rtl() => origin_x + align_width - line_width,
        TextAlign::Start | TextAlign::Left => origin_x,
        TextAlign::Center => (origin_x * 2.0 + align_width - line_width) / 2.0,
        TextAlign::End if direction.is_rtl() => origin_x,
        TextAlign::End | TextAlign::Right => origin_x + align_width - line_width,
    }
}
