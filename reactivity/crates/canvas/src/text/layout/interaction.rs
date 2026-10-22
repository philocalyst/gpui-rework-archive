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

    fn intervals(&self, marker_width: f32) -> impl Iterator<Item = Interval> + '_ {
        let groups = self
            .carets
            .as_deref()
            .unwrap_or_default()
            .chunk_by(|a, b| a.byte == b.byte);
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
        let stops = map.carets.as_ref()?;
        let line = map.line_at(point.y);
        let mut best = None;
        let mut distance = f32::INFINITY;
        for interval in map
            .intervals(self.font_size * 0.25)
            .filter(|i| i.line == line)
        {
            // A hard break belongs to the preceding line; clicking its marker
            // must not put the caret at the beginning of the following line.
            let (candidate, d) = if interval.hard_break {
                (interval.start, (point.x - interval.start_x).abs())
            } else {
                let left = interval.start_x.min(interval.end_x);
                let right = interval.start_x.max(interval.end_x);
                let d = (left - point.x).max(point.x - right).max(0.);
                (interval.side(point.x > left + (right - left) * 0.5), d)
            };
            if d < distance {
                best = Some(candidate);
                distance = d;
            }
        }
        best.or_else(|| {
            // Empty paragraphs have a caret but no source interval.
            stops
                .iter()
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
        for interval in map.intervals(self.font_size * 0.25) {
            if interval.start.offset < start
                || interval.end.offset > end
                || interval.bounds.width == 0.
            {
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
            .intervals(self.font_size * 0.25)
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
