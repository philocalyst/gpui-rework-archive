//! Interaction borrows the canonical byte/affinity map. No retained index or
//! shaping tree is created by a hit, motion, or selection query.
use super::*;
use crate::Point;

struct Interval {
    start: TextPosition,
    end: TextPosition,
    start_x: f32,
    end_x: f32,
    bounds: Rect,
    line: usize,
    hard_break: bool,
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
            let line = if byte <= 2 {
                0
            } else if byte <= 4 {
                1
            } else if byte < 12 {
                2
            } else {
                (byte / 4).min(2_499)
            };
            let mut stop = Stop {
                byte,
                bounds: Rect::new((byte % 4) as f32, line as f32 * 10., 1., 10.),
                affinities: 3,
            };
            if byte == 2 {
                stop.affinities = 1;
                map.carets.as_mut().unwrap().push(stop);
                stop.affinities = 2;
                stop.bounds.y = 10.;
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
                .intervals(all, 2.5)
                .filter(|i| i.line == line)
                .map(owned)
                .collect::<Vec<_>>();
            let mut derived = 0;
            let cut = map
                .intervals(map.line_tail(line), 2.5)
                .inspect(|_| derived += 1)
                .take_while(|interval| interval.start.offset.0 <= map.lines[line].end)
                .filter(|i| i.line == line)
                .map(owned)
                .collect::<Vec<_>>();
            assert_eq!(cut, full, "line{line}");
            assert!(derived <= 8);
        }
        assert_eq!(
            map.stops(4, 6).iter().map(|s| s.byte).collect::<Vec<_>>(),
            [4, 6]
        );
        let requested = map.stops(8_001, 8_003);
        assert_eq!(requested.len(), 3);
        assert_eq!(map.intervals(requested, 2.5).count(), 2);
        assert_eq!(map.intervals(all, 2.5).count(), 9_999);
    }
}
impl Interval {
    fn side(&self, right: bool) -> TextPosition {
        if right == (self.start_x < self.end_x) {
            self.end
        } else {
            self.start
        }
    }
}

impl Details {
    fn line_at(&self, y: f32) -> usize {
        self.lines
            .partition_point(|line| line.top <= y)
            .saturating_sub(1)
    }

    /// Inclusive endpoint groups for a validated selection source range.
    fn stops(&self, start: u32, end: u32) -> &[Stop] {
        let stops = self.carets.as_deref().unwrap_or_default();
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
    fn line_tail(&self, line: usize) -> &[Stop] {
        let stops = self.carets.as_deref().unwrap_or_default();
        let start = self.lines[line].start;
        let first = if start == 0 {
            0
        } else {
            stops.partition_point(|stop| stop.byte < start)
        };
        &stops[first..]
    }

    fn intervals<'a>(
        &'a self,
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
                let line = self.line_at(start.bounds.y);
                let hard_break = start.bounds.y != end.bounds.y;
                let left = start.bounds.x.min(end.bounds.x);
                let marker_left = hard_break && {
                    let first = self.runs.partition_point(|run| (run.line as usize) < line);
                    self.runs[first..]
                        .iter()
                        .take_while(|run| run.line as usize == line)
                        .find(|run| run.start <= start.byte && start.byte <= run.end)
                        .is_some_and(|run| run.direction == TextDirection::RightToLeft)
                };
                Some(Interval {
                    start: TextPosition {
                        offset: TextOffset(start.byte),
                        affinity: CaretAffinity::Downstream,
                    },
                    end: TextPosition {
                        offset: TextOffset(end.byte),
                        affinity: CaretAffinity::Upstream,
                    },
                    start_x: start.bounds.x,
                    end_x: end.bounds.x,
                    bounds: if hard_break {
                        Rect::new(
                            if marker_left {
                                start.bounds.x - marker_width
                            } else {
                                start.bounds.x
                            },
                            start.bounds.y,
                            marker_width,
                            start.bounds.height,
                        )
                    } else {
                        Rect::new(
                            left,
                            start.bounds.y,
                            (end.bounds.x - start.bounds.x).abs(),
                            start.bounds.height,
                        )
                    },
                    line,
                    hard_break,
                })
            })
    }
}

impl TextLayout {
    /// Nearest legal grapheme caret in layout-local coordinates. Points outside
    /// the layout clamp to the nearest line and visual interval. At an interval
    /// midpoint the left side wins; bidi joins retain that side's affinity.
    /// Nonfinite points and layouts shaped without interaction return None.
    /// Scans the existing caret map and searches line/run tables without allocating.
    pub fn position_at(&self, point: Point) -> Option<TextPosition> {
        if !point.x.is_finite() || !point.y.is_finite() {
            return None;
        }
        let map = self.mapping.as_ref()?;
        map.carets.as_ref()?;
        let line = map.line_at(point.y);
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
            if point.x < left {
                if after.is_none_or(|(edge, _)| left < edge) {
                    after = Some((left, at_left));
                }
            } else if point.x > right {
                if before.is_none_or(|(edge, _)| right > edge) {
                    before = Some((right, at_right));
                }
            } else {
                let middle = (f64::from(left) + f64::from(right)) * 0.5;
                return Some(if f64::from(point.x) > middle {
                    at_right
                } else {
                    at_left
                });
            }
        }
        let best = match (before, after) {
            (Some((left, a)), Some((right, b))) => {
                let middle = (f64::from(left) + f64::from(right)) * 0.5;
                Some(if f64::from(point.x) > middle { b } else { a })
            }
            (Some((_, position)), None) | (None, Some((_, position))) => Some(position),
            (None, None) => None,
        };
        best.or_else(|| {
            // Empty paragraphs have a caret but no source interval.
            stops
                .iter()
                .take_while(|stop| stop.byte <= map.lines[line].end)
                .find(|stop| map.line_at(stop.bounds.y) == line)
                .map(|stop| TextPosition {
                    offset: TextOffset(stop.byte),
                    affinity: if stop.affinities & 2 != 0 {
                        CaretAffinity::Downstream
                    } else {
                        CaretAffinity::Upstream
                    },
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
        &self,
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
        let map = self.mapping.as_ref().unwrap();
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
    pub fn previous_visual(&self, position: TextPosition) -> Option<TextPosition> {
        self.move_visual(position, false)
    }

    /// Moves one visible grapheme edge to the right, continuing at the left
    /// edge of the next line. See [`Self::previous_visual`] for edge policy.
    pub fn next_visual(&self, position: TextPosition) -> Option<TextPosition> {
        self.move_visual(position, true)
    }

    fn move_visual(&self, position: TextPosition, right: bool) -> Option<TextPosition> {
        let bounds = self.caret_bounds(position)?;
        let map = self.mapping.as_ref()?;
        let line = map.line_at(bounds.y);
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
        if let Some(next) = next_line.and_then(|index| map.lines.get(index)) {
            return self.position_at(Point {
                x: if right { -f32::MAX } else { f32::MAX },
                y: next.top,
            });
        }
        Some(position)
    }
}
