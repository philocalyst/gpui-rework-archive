//! Interaction borrows the canonical byte/affinity map. No retained index or
//! shaping tree is created by a hit, motion, or selection query.
use super::*;
use crate::Point;

/// One source grapheme advance, derived on demand from canonical caret stops.
#[derive(Clone, Copy, Debug)]
pub struct TextGrapheme {
    start: TextPosition,
    end: TextPosition,
    start_x: f32,
    end_x: f32,
    bounds: Rect,
    line: usize,
    hard_break: bool,
    direction: TextDirection,
}

type Interval = TextGrapheme;

impl TextGrapheme {
    pub fn text_range(self) -> std::ops::Range<TextOffset> {
        self.start.offset..self.end.offset
    }
    pub fn bounds(self) -> Rect {
        self.bounds
    }
    pub fn line(self) -> usize {
        self.line
    }
    pub fn direction(self) -> TextDirection {
        self.direction
    }
    pub fn is_hard_break(self) -> bool {
        self.hard_break
    }

    fn side(&self, right: bool) -> TextPosition {
        if right == (self.start_x < self.end_x) {
            self.end
        } else {
            self.start
        }
    }
}

impl<'a> TextGeometryView<'a> {
    // Source-ordered boundaries remain authoritative when caret tops overlap.
    // End excludes hard separators: upstream at a soft wrap stays on the old
    // line, while the end of a hard separator advances across the source gap.
    pub(super) fn source_line(self, position: TextPosition) -> usize {
        let byte = position.offset.0;
        match position.affinity {
            CaretAffinity::Upstream if byte != 0 => self
                .lines
                .partition_point(|line| line.end < byte)
                .min(self.lines.len() - 1),
            _ => self
                .lines
                .partition_point(|line| line.start <= byte)
                .saturating_sub(1),
        }
    }
    fn line_at(self, y: f32) -> usize {
        self.lines
            .partition_point(|line| line.top <= y)
            .saturating_sub(1)
    }

    /// Inclusive endpoint groups for a validated selection source range.
    fn stops(self, start: u32, end: u32) -> &'a [Stop] {
        let stops = self.carets.unwrap_or_default();
        let first = if start == 0 {
            0
        } else {
            stops.partition_point(|stop| stop.byte < start)
        };
        let last = stops.partition_point(|stop| stop.byte <= end);
        &stops[first..last]
    }

    /// Source suffix whose interval starts stop lazily at the line's end byte.
    /// Zipping with the next group includes the far side of an atomic separator.
    /// At a soft wrap the same extra pair belongs to the next line and filters
    /// out by source-affinity ownership. No upper-bound scan precedes a hit.
    fn line_tail(self, line: usize) -> &'a [Stop] {
        let stops = self.carets.unwrap_or_default();
        let start = self.lines[line].start;
        let first = if start == 0 {
            0
        } else {
            stops.partition_point(|stop| stop.byte < start)
        };
        &stops[first..]
    }

    fn intervals(
        self,
        stops: &'a [Stop],
        marker_width: f32,
    ) -> impl Iterator<Item = Interval> + 'a {
        let groups = stops.chunk_by(|a, b| a.byte == b.byte);
        groups
            .clone()
            .zip(groups.skip(1))
            .filter_map(move |(a, b)| {
                let start = a.iter().find(|stop| stop.affinities & 2 != 0)?;
                let end = b.iter().find(|stop| stop.affinities & 1 != 0)?;
                let line = self.source_line(TextPosition {
                    offset: TextOffset(start.byte),
                    affinity: CaretAffinity::Downstream,
                });
                let hard_break = end.byte > self.lines[line].end;
                // A legal start lies in this line's content range. Earlier
                // ends are no later than its start, so an upstream alias can
                // differ only at a preceding end's equality (a soft wrap).
                // Keep the producer's upstream bits there; byte zero coerces
                // to downstream. Never infer ownership from caret y.
                let geometry_line = if start.affinities & 1 != 0
                    && start.byte != 0
                    && line != 0
                    && self.lines[line - 1].end == start.byte
                {
                    self.source_line(TextPosition {
                        offset: TextOffset(start.byte),
                        affinity: CaretAffinity::Upstream,
                    })
                } else {
                    line
                };
                let metrics = self.lines[geometry_line];
                let left = start.x.min(end.x);
                let direction = if !hard_break && start.x != end.x {
                    if start.x < end.x {
                        TextDirection::LeftToRight
                    } else {
                        TextDirection::RightToLeft
                    }
                } else {
                    let first = self.runs.partition_point(|run| (run.line as usize) < line);
                    self.runs[first..]
                        .iter()
                        .take_while(|run| run.line as usize == line)
                        .find(|run| run.start <= start.byte && start.byte <= run.end)
                        .map_or(TextDirection::LeftToRight, |run| run.direction)
                };
                let marker_left = hard_break && direction == TextDirection::RightToLeft;
                Some(Interval {
                    start: TextPosition {
                        offset: TextOffset(start.byte),
                        affinity: CaretAffinity::Downstream,
                    },
                    end: TextPosition {
                        offset: TextOffset(end.byte),
                        affinity: CaretAffinity::Upstream,
                    },
                    start_x: start.x,
                    end_x: end.x,
                    bounds: if hard_break {
                        Rect::new(
                            if marker_left {
                                start.x - marker_width
                            } else {
                                start.x
                            },
                            metrics.top,
                            marker_width,
                            metrics.height,
                        )
                    } else {
                        Rect::new(left, metrics.top, (end.x - start.x).abs(), metrics.height)
                    },
                    line,
                    hard_break,
                    direction,
                })
            })
    }
}

impl<'a> TextGeometryView<'a> {
    /// Source-ordered grapheme advances, including atomic hard-break markers.
    /// Nothing is retained or allocated. Requires interactive shaping.
    pub fn graphemes(self) -> impl Iterator<Item = TextGrapheme> + 'a {
        self.intervals(self.carets.unwrap_or_default(), self.font_size * 0.25)
    }
    /// Units in an exact source range. Invalid or reversed endpoints return
    /// None before iteration; bounds use the same source-affinity ownership.
    pub fn graphemes_in(
        self,
        range: std::ops::Range<TextOffset>,
    ) -> Option<impl Iterator<Item = TextGrapheme> + 'a> {
        if range.start > range.end {
            return None;
        }
        let stops = self.carets?;
        for offset in [range.start, range.end] {
            let index = stops.partition_point(|stop| stop.byte < offset.0);
            if stops.get(index).is_none_or(|stop| stop.byte != offset.0) {
                return None;
            }
        }
        Some(self.intervals(
            self.stops(range.start.0, range.end.0),
            self.font_size * 0.25,
        ))
    }
    /// The containing grapheme, distinct from nearest-caret midpoint policy.
    /// Outside/zero-area advances and nonfinite points produce None.
    pub fn grapheme_at(self, point: Point) -> Option<TextGrapheme> {
        if !point.x.is_finite() || !point.y.is_finite() {
            return None;
        }
        let line = self.line_at(point.y);
        self.intervals(self.line_tail(line), self.font_size * 0.25)
            .take_while(|unit| unit.start.offset.0 <= self.lines[line].end)
            .find(|unit| unit.line == line && unit.bounds.contains(point))
    }
    /// Advance at an exact grapheme start; interiors and the terminal caret
    /// have no grapheme. The byte lookup reuses the existing sorted stops.
    pub fn grapheme(self, start: TextOffset) -> Option<TextGrapheme> {
        let stops = self.carets?;
        let first = stops.partition_point(|stop| stop.byte < start.0);
        self.intervals(&stops[first..], self.font_size * 0.25)
            .next()
            .filter(|unit| unit.start.offset == start)
    }
    /// Source-ordered directional runs, split only at legal grapheme boundaries.
    /// Font-run boundaries inside a grapheme do not split the selectable unit.
    /// Equal direction does not imply visual adjacency across bidi isolates;
    /// an affinity discontinuity starts a new run instead of spanning a gap.
    pub fn runs(self) -> impl Iterator<Item = TextRun> + 'a {
        let mut units = self.graphemes().peekable();
        let mut terminal = self
            .lines
            .last()
            .filter(|line| self.carets.is_some() && line.start == self.len && line.end == self.len)
            .map(|_| TextRun {
                start: self.len,
                end: self.len,
                bounds: {
                    let caret = self
                        .caret_bounds(TextPosition {
                            offset: TextOffset(self.len),
                            affinity: CaretAffinity::Downstream,
                        })
                        .expect("interactive terminal line has a caret");
                    Rect::new(caret.x, caret.y, 0., caret.height)
                },
                line: self.lines.len() - 1,
                direction: TextDirection::LeftToRight,
            });
        std::iter::from_fn(move || {
            let Some(first) = units.next() else {
                return terminal.take();
            };
            let mut run = TextRun {
                start: first.start.offset.0,
                end: first.end.offset.0,
                bounds: first.bounds,
                line: first.line,
                direction: first.direction,
            };
            let mut edge = first.end_x;
            while let Some(next) = units.peek().filter(|next| {
                next.line == run.line
                    && next.direction == run.direction
                    && next.start.offset.0 == run.end
                    && next.start_x == edge
                    && next.bounds.y == run.bounds.y
                    && next.bounds.height == run.bounds.height
            }) {
                let right =
                    (run.bounds.x + run.bounds.width).max(next.bounds.x + next.bounds.width);
                run.bounds.x = run.bounds.x.min(next.bounds.x);
                run.bounds.width = right - run.bounds.x;
                run.end = next.end.offset.0;
                edge = next.end_x;
                units.next();
            }
            Some(run)
        })
    }

    /// Nearest legal grapheme caret in layout-local coordinates. Points outside
    /// the layout clamp to the nearest line and visual interval. At an interval
    /// midpoint the left side wins; bidi joins retain that side's affinity.
    /// Nonfinite points and layouts shaped without interaction return None.
    /// Scans the existing caret map and searches line/run tables without allocating.
    pub fn position_at(self, point: Point) -> Option<TextPosition> {
        if !point.x.is_finite() || !point.y.is_finite() {
            return None;
        }
        self.position_on_line(self.line_at(point.y), point.x)
    }

    fn position_on_line(self, line: usize, x: f32) -> Option<TextPosition> {
        let map = self;
        map.carets.as_ref()?;
        let stops = map.line_tail(line);
        let mut before: Option<(f32, TextPosition)> = None;
        let mut after: Option<(f32, TextPosition)> = None;
        for interval in map
            .intervals(stops, self.font_size * 0.25)
            .take_while(|interval| interval.start.offset.0 <= map.lines[line].end)
            .filter(|i| i.line == line)
        {
            // A hard break belongs to the preceding line; clicking its marker
            // must not put the caret at the beginning of the following line.
            let (left, right, at_left, at_right) = if interval.hard_break {
                (
                    interval.start_x,
                    interval.start_x,
                    interval.start,
                    interval.start,
                )
            } else {
                (
                    interval.start_x.min(interval.end_x),
                    interval.start_x.max(interval.end_x),
                    interval.side(false),
                    interval.side(true),
                )
            };
            // Compare edges before subtracting. At distant finite points every
            // f32 distance can round to the same value, losing visual order.
            if x < left {
                if after.is_none_or(|(edge, _)| left < edge) {
                    after = Some((left, at_left));
                }
            } else if x > right {
                if before.is_none_or(|(edge, _)| right > edge) {
                    before = Some((right, at_right));
                }
            } else {
                let middle = (f64::from(left) + f64::from(right)) * 0.5;
                return Some(if f64::from(x) > middle {
                    at_right
                } else {
                    at_left
                });
            }
        }
        let best = match (before, after) {
            (Some((left, a)), Some((right, b))) => {
                let middle = (f64::from(left) + f64::from(right)) * 0.5;
                Some(if f64::from(x) > middle { b } else { a })
            }
            (Some((_, position)), None) | (None, Some((_, position))) => Some(position),
            (None, None) => None,
        };
        best.or_else(|| {
            // Empty paragraphs have a caret but no source interval.
            stops
                .iter()
                .take_while(|stop| stop.byte <= map.lines[line].end)
                .find_map(|stop| {
                    [CaretAffinity::Downstream, CaretAffinity::Upstream]
                        .into_iter()
                        .find_map(|affinity| {
                            let mask = if affinity == CaretAffinity::Downstream {
                                2
                            } else {
                                1
                            };
                            let position = TextPosition {
                                offset: TextOffset(stop.byte),
                                affinity,
                            };
                            (stop.affinities & mask != 0 && map.source_line(position) == line)
                                .then_some(position)
                        })
                })
        })
    }

    /// Visits selection rectangles and their visual line indices without
    /// allocation. Source order is preserved; touching consecutive rectangles
    /// coalesce. A selected hard break has a quarter-em marker on its old line.
    /// Invalid endpoints return false before invoking the callback. A collapsed
    /// byte range succeeds without rectangles, including split-affinity carets.
    /// Scans the existing caret map; no selection geometry is retained.
    pub fn selection_rects(
        self,
        selection: TextSelection,
        mut visit: impl FnMut(Rect, usize),
    ) -> bool {
        if !self.validates_selection(selection) {
            return false;
        }
        let start = selection.anchor.offset.min(selection.focus.offset);
        let end = selection.anchor.offset.max(selection.focus.offset);
        if start == end {
            return true;
        }
        let map = self;
        let mut pending: Option<(Rect, usize)> = None;
        for interval in map.intervals(map.stops(start.0, end.0), self.font_size * 0.25) {
            if interval.bounds.width == 0. {
                continue;
            }
            let next = interval.bounds;
            if let Some((rect, line)) = &mut pending {
                if *line == interval.line
                    && rect.y == next.y
                    && rect.height == next.height
                    && rect.x <= next.x + next.width
                    && next.x <= rect.x + rect.width
                {
                    let right = (rect.x + rect.width).max(next.x + next.width);
                    rect.x = rect.x.min(next.x);
                    rect.width = right - rect.x;
                    continue;
                }
                visit(*rect, *line);
            }
            pending = Some((next, interval.line));
        }
        if let Some((rect, line)) = pending {
            visit(rect, line);
        }
        true
    }

    /// Moves one visible grapheme edge to the left. Equal-geometry affinity
    /// aliases are skipped; at a line edge motion continues on the adjacent
    /// visual line. Returns None for an invalid current position. At document
    /// edges it returns the current position. This is physical arrow motion;
    /// word movement and paragraph-direction commands are separate policies.
    pub fn previous_visual(self, position: TextPosition) -> Option<TextPosition> {
        self.move_visual(position, false)
    }

    /// Moves one visible grapheme edge to the right, continuing at the left
    /// edge of the next line. See [`Self::previous_visual`] for edge policy.
    pub fn next_visual(self, position: TextPosition) -> Option<TextPosition> {
        self.move_visual(position, true)
    }

    /// Nearest legal caret on the preceding visual line at layout-local `x`.
    /// Affinity determines the current line at a wrap. Document edges preserve
    /// the current position. Invalid positions or nonfinite x return None.
    /// Borrows the existing interaction map without allocation.
    pub fn previous_visual_line(self, position: TextPosition, x: f32) -> Option<TextPosition> {
        self.move_visual_line(position, x, false)
    }

    /// Nearest legal caret on the following visual line; see
    /// [`Self::previous_visual_line`]. The caller owns preferred-x policy.
    pub fn next_visual_line(self, position: TextPosition, x: f32) -> Option<TextPosition> {
        self.move_visual_line(position, x, true)
    }

    fn move_visual_line(self, position: TextPosition, x: f32, down: bool) -> Option<TextPosition> {
        self.caret_bounds(position)?;
        if !x.is_finite() {
            return None;
        }
        let line = self.source_line(position);
        let next = if down {
            line.checked_add(1)
        } else {
            line.checked_sub(1)
        };
        match next.filter(|&line| line < self.lines.len()) {
            Some(line) => self.position_on_line(line, x),
            None => Some(position),
        }
    }

    /// Physical left edge of the current visual line, including RTL text.
    /// Invalid positions return None. No geometry or navigation state is retained.
    pub fn visual_line_start(self, position: TextPosition) -> Option<TextPosition> {
        self.caret_bounds(position)?;
        self.position_on_line(self.source_line(position), -f32::MAX)
    }

    /// Physical right edge of the current visual line; see [`Self::visual_line_start`].
    pub fn visual_line_end(self, position: TextPosition) -> Option<TextPosition> {
        self.caret_bounds(position)?;
        self.position_on_line(self.source_line(position), f32::MAX)
    }

    fn move_visual(self, position: TextPosition, right: bool) -> Option<TextPosition> {
        let bounds = self.caret_bounds(position)?;
        let map = self;
        // The successful bounds lookup above already validated byte/affinity.
        let line = map.source_line(position);
        let mut best = None;
        let mut distance = f32::INFINITY;
        for interval in map
            .intervals(map.line_tail(line), self.font_size * 0.25)
            .take_while(|interval| interval.start.offset.0 <= map.lines[line].end)
            .filter(|i| i.line == line && !i.hard_break)
        {
            let x = if right {
                interval.start_x.max(interval.end_x)
            } else {
                interval.start_x.min(interval.end_x)
            };
            let d = if right { x - bounds.x } else { bounds.x - x };
            if d > 0. && d < distance {
                best = Some(interval.side(right));
                distance = d;
            }
        }
        if best.is_some() {
            return best;
        }
        let next_line = if right {
            line.checked_add(1)
        } else {
            line.checked_sub(1)
        };
        if let Some(next) = next_line.filter(|index| *index < map.lines.len()) {
            return self.position_on_line(next, if right { -f32::MAX } else { f32::MAX });
        }
        Some(position)
    }
}

impl<G: AsRef<TextGeometry>> TextLayout<G> {
    /// Nearest grapheme caret; see [`TextGeometry::position_at`].
    pub fn position_at(&self, point: Point) -> Option<TextPosition> {
        self.geometry()?.position_at(point)
    }
    /// Allocation-free rectangles; invalid endpoints invoke no callbacks.
    pub fn selection_rects(
        &self,
        selection: TextSelection,
        visit: impl FnMut(Rect, usize),
    ) -> bool {
        self.geometry()
            .is_some_and(|map| map.selection_rects(selection, visit))
    }
    pub fn previous_visual(&self, position: TextPosition) -> Option<TextPosition> {
        self.geometry()?.previous_visual(position)
    }
    pub fn next_visual(&self, position: TextPosition) -> Option<TextPosition> {
        self.geometry()?.next_visual(position)
    }
    pub fn previous_visual_line(&self, position: TextPosition, x: f32) -> Option<TextPosition> {
        self.geometry()?.previous_visual_line(position, x)
    }
    pub fn next_visual_line(&self, position: TextPosition, x: f32) -> Option<TextPosition> {
        self.geometry()?.next_visual_line(position, x)
    }
    pub fn visual_line_start(&self, position: TextPosition) -> Option<TextPosition> {
        self.geometry()?.visual_line_start(position)
    }
    pub fn visual_line_end(&self, position: TextPosition) -> Option<TextPosition> {
        self.geometry()?.visual_line_end(position)
    }
}

impl TextGeometry {
    pub fn graphemes(&self) -> impl Iterator<Item = TextGrapheme> + '_ {
        self.view().graphemes()
    }
    pub fn graphemes_in(
        &self,
        range: std::ops::Range<TextOffset>,
    ) -> Option<impl Iterator<Item = TextGrapheme> + '_> {
        self.view().graphemes_in(range)
    }
    pub fn grapheme_at(&self, point: Point) -> Option<TextGrapheme> {
        self.view().grapheme_at(point)
    }
    pub fn grapheme(&self, start: TextOffset) -> Option<TextGrapheme> {
        self.view().grapheme(start)
    }
    pub fn runs(&self) -> impl Iterator<Item = TextRun> + '_ {
        self.view().runs()
    }
    pub fn position_at(&self, point: Point) -> Option<TextPosition> {
        self.view().position_at(point)
    }
    pub fn selection_rects(
        &self,
        selection: TextSelection,
        visit: impl FnMut(Rect, usize),
    ) -> bool {
        self.view().selection_rects(selection, visit)
    }
    pub fn previous_visual(&self, position: TextPosition) -> Option<TextPosition> {
        self.view().previous_visual(position)
    }
    pub fn next_visual(&self, position: TextPosition) -> Option<TextPosition> {
        self.view().next_visual(position)
    }
    pub fn previous_visual_line(&self, position: TextPosition, x: f32) -> Option<TextPosition> {
        self.view().previous_visual_line(position, x)
    }
    pub fn next_visual_line(&self, position: TextPosition, x: f32) -> Option<TextPosition> {
        self.view().next_visual_line(position, x)
    }
    pub fn visual_line_start(&self, position: TextPosition) -> Option<TextPosition> {
        self.view().visual_line_start(position)
    }
    pub fn visual_line_end(&self, position: TextPosition) -> Option<TextPosition> {
        self.view().visual_line_end(position)
    }
}

/// A directional, single-line source span, derived without allocation.
#[derive(Clone, Copy, Debug)]
pub struct TextRun {
    start: u32,
    end: u32,
    bounds: Rect,
    line: usize,
    direction: TextDirection,
}
impl TextRun {
    pub fn text_range(self) -> std::ops::Range<TextOffset> {
        TextOffset(self.start)..TextOffset(self.end)
    }
    pub fn bounds(self) -> Rect {
        self.bounds
    }
    pub fn line(self) -> usize {
        self.line
    }
    pub fn direction(self) -> TextDirection {
        self.direction
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn byte_cuts_keep_boundary_ownership_and_only_visit_the_requested_source() {
        // Structural work accounting, independent of shaping. The ordinary
        // integration gates exercise these cuts on actual mixed-script fonts.
        // 0..2 and 2..4 are soft-wrapped; 4..6 is an atomic CRLF gap.
        let mut map = Details {
            len: 10_000,
            font_size: 10.,
            runs: Vec::new(),
            lines: (0..2_500)
                .map(|index| Line {
                    start: index * 4,
                    end: index * 4 + 4,
                    top: index as f32 * 10.,
                    height: 10.,
                    baseline: index as f32 * 10. + 8.,
                    width: 2.,
                })
                .collect(),
            carets: Some(Vec::new()),
        };
        map.lines[0].end = 2;
        map.lines[1].start = 2;
        map.lines[1].end = 4;
        map.lines[2].start = 6;
        for byte in (0..=10_000).filter(|&byte| byte != 5) {
            let mut stop = Stop {
                byte,
                x: (byte % 4) as f32,
                affinities: 3,
            };
            if byte == 2 {
                stop.affinities = 1;
                map.carets.as_mut().unwrap().push(stop);
                stop.affinities = 2;
            }
            map.carets.as_mut().unwrap().push(stop);
        }
        let all = map.carets.as_deref().unwrap();
        for line in [0, 1, 2, 999, 2_499] {
            let owned = |interval: Interval| {
                (
                    interval.start.offset.byte(),
                    interval.end.offset.byte(),
                    interval.line,
                )
            };
            let full = map
                .view()
                .intervals(all, 2.5)
                .filter(|i| i.line == line)
                .map(owned)
                .collect::<Vec<_>>();
            let mut derived = 0;
            let cut = map
                .view()
                .intervals(map.view().line_tail(line), 2.5)
                .inspect(|_| derived += 1)
                .take_while(|interval| interval.start.offset.0 <= map.lines[line].end)
                .filter(|i| i.line == line)
                .map(owned)
                .collect::<Vec<_>>();
            assert_eq!(cut, full, "line{line}");
            assert!(derived <= 8);
        }
        assert_eq!(
            map.view()
                .stops(4, 6)
                .iter()
                .map(|s| s.byte)
                .collect::<Vec<_>>(),
            [4, 6]
        );
        let requested = map.view().stops(8_001, 8_003);
        assert_eq!(requested.len(), 3);
        assert_eq!(map.view().intervals(requested, 2.5).count(), 2);
        assert_eq!(map.view().intervals(all, 2.5).count(), 9_999);
    }
}
