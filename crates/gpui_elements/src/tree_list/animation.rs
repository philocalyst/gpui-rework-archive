//! Bounded structural motion for virtualized tree lists.
//!
//! The caller supplies only rows already materialized by its list viewport (plus
//! any overscan). `TreeListMotionState` keeps at most `MAX_MOTION_ROWS` of those
//! rows and computes FLIP-style offsets for rows that survive a structural
//! splice. Newly inserted rows grow and fade in. Removed identities are
//! discarded immediately; the tree view separately captures their outgoing
//! paint through `PaintSnapshotElement`, without retaining interactive rows
//! or asking the model for deleted content.
//!
//! This keeps the list's canonical row count and hit testing correct throughout
//! a transition. Call [`TreeListMotionState::begin_transition`] after the
//! canonical projection has changed and before rendering the new visible rows.
//! Apply [`RowMotion::translate_y`] as a relative offset, and use
//! [`RowMotion::height_scale`] and [`RowMotion::opacity`] to reveal inserted
//! row contents. Keep the outer list slot at its canonical final height so
//! `ListState` measurements and hit testing continue to match the final layout.

use std::{
    collections::{HashMap, VecDeque},
    hash::Hash,
    time::Duration,
};

/// Maximum number of visible and overscanned rows retained for a transition.
/// The viewport should normally contain far fewer rows than this.
pub const MAX_MOTION_ROWS: usize = 256;

/// Default duration used by tree-list structural transitions.
pub const DEFAULT_TREE_MOTION_DURATION: Duration = Duration::from_millis(160);

/// A materialized row's final geometry, in list-local coordinates.
#[derive(Clone, Debug, PartialEq)]
pub struct TreeListRowLayout<Id> {
    pub id: Id,
    pub y: f32,
    pub height: f32,
}

/// Presentation values to apply to a row while structural motion is active.
#[derive(Clone, Copy, Debug, PartialEq)]
pub struct RowMotion {
    /// Relative vertical offset from the row's final list position.
    pub translate_y: f32,
    /// Opacity multiplier in the range 0 to 1.
    pub opacity: f32,
    /// Visual height multiplier in the range 0 to 1 for the row contents.
    /// Keep the outer list slot at its final height while applying this value.
    pub height_scale: f32,
}

impl Default for RowMotion {
    fn default() -> Self {
        Self {
            translate_y: 0.0,
            opacity: 1.0,
            height_scale: 1.0,
        }
    }
}

#[derive(Clone, Copy, Debug)]
struct Transition {
    from_y: f32,
    to_y: f32,
    from_opacity: f32,
    to_opacity: f32,
    from_height: f32,
    to_height: f32,
    started_at: Duration,
    duration: Duration,
}

#[derive(Clone, Copy, Debug)]
struct Presented {
    y: f32,
    opacity: f32,
    height_scale: f32,
}

/// A bounded transition planner for currently materialized tree rows.
///
/// Time is supplied as a monotonically increasing [`Duration`] (typically
/// elapsed time from a component-owned epoch), which keeps this helper usable
/// without tying it to a window or a particular clock implementation. Row
/// recording and sampling use keyed lookups; pruning scans the bounded active
/// set once per frame, not once per row.
pub struct TreeListMotionState<Id> {
    rows: HashMap<Id, TreeListRowLayout<Id>>,
    row_order: VecDeque<Id>,
    transitions: HashMap<Id, Transition>,
    duration: Duration,
}

impl<Id: Clone + Eq + Hash> Default for TreeListMotionState<Id> {
    fn default() -> Self {
        Self::new(DEFAULT_TREE_MOTION_DURATION)
    }
}

impl<Id: Clone + Eq + Hash> TreeListMotionState<Id> {
    pub fn new(duration: Duration) -> Self {
        Self {
            rows: HashMap::new(),
            row_order: VecDeque::new(),
            transitions: HashMap::new(),
            duration,
        }
    }

    /// Capture the current materialized layout without animating it. Use this
    /// for the initial render and after scrolling or resizing the viewport;
    /// this also cancels stale offsets tied to the prior viewport geometry.
    pub fn capture_layout(&mut self, rows: &[TreeListRowLayout<Id>]) {
        self.rows.clear();
        self.row_order.clear();
        for row in rows.iter().take(MAX_MOTION_ROWS) {
            self.row_order.push_back(row.id.clone());
            self.rows.insert(row.id.clone(), row.clone());
        }
        self.transitions.clear();
    }

    /// Begin a fresh render pass. This drops geometry for rows that left the
    /// viewport while preserving active transitions; the list callback records
    /// the rows it materializes during this pass.
    pub fn begin_frame(&mut self) {
        self.rows.clear();
        self.row_order.clear();
    }

    /// Record one row that the list actually materialized this frame while
    /// preserving its active transition. The cache evicts the oldest row when
    /// the viewport moves, so retained geometry stays bounded.
    pub fn record_layout(&mut self, row: TreeListRowLayout<Id>) {
        if self.rows.contains_key(&row.id) {
            self.rows.insert(row.id.clone(), row);
        } else {
            if self.row_order.len() == MAX_MOTION_ROWS {
                if let Some(evicted_id) = self.row_order.pop_front() {
                    self.rows.remove(&evicted_id);
                    self.transitions.remove(&evicted_id);
                }
            }
            self.row_order.push_back(row.id.clone());
            self.rows.insert(row.id.clone(), row);
        }
    }

    /// Start transitions from the currently presented geometry to `next`.
    /// Pass only visible rows and overscan. Repeated calls safely sample any
    /// in-flight transition, so a second expand/collapse starts from what the
    /// user currently sees instead of snapping back to the prior endpoint.
    ///
    /// Set `reduced_motion` to skip interpolation and commit the final layout.
    /// Removed rows are immediately forgotten and cannot be rendered as ghosts.
    pub fn begin_transition(
        &mut self,
        next: &[TreeListRowLayout<Id>],
        now: Duration,
        reduced_motion: bool,
    ) {
        let next: Vec<_> = next.iter().take(MAX_MOTION_ROWS).cloned().collect();
        if reduced_motion || self.duration.is_zero() {
            self.rows.clear();
            self.row_order.clear();
            for row in next {
                self.row_order.push_back(row.id.clone());
                self.rows.insert(row.id.clone(), row);
            }
            self.transitions.clear();
            return;
        }

        let old: HashMap<_, _> = self
            .row_order
            .iter()
            .filter_map(|id| {
                self.rows.get(id).map(|row| {
                    let presented = self.presented(id, row.y, now);
                    (id.clone(), presented)
                })
            })
            .collect();

        self.transitions.clear();
        for row in &next {
            let to = Presented {
                y: row.y,
                opacity: 1.0,
                height_scale: 1.0,
            };
            let from = old.get(&row.id).copied().unwrap_or(Presented {
                y: row.y,
                opacity: 0.0,
                height_scale: 0.0,
            });
            if (from.y - to.y).abs() > 0.01
                || (from.opacity - to.opacity).abs() > 0.01
                || (from.height_scale - to.height_scale).abs() > 0.01
            {
                self.transitions.insert(
                    row.id.clone(),
                    Transition {
                        from_y: from.y,
                        to_y: to.y,
                        from_opacity: from.opacity,
                        to_opacity: to.opacity,
                        from_height: from.height_scale,
                        to_height: to.height_scale,
                        started_at: now,
                        duration: self.duration,
                    },
                );
            }
        }
        self.rows.clear();
        self.row_order.clear();
        for row in next {
            self.row_order.push_back(row.id.clone());
            self.rows.insert(row.id.clone(), row);
        }
    }

    /// Motion relative to a row's final layout position. Missing IDs are
    /// intentionally inert, which also prevents stale removed IDs from being
    /// used to render or query model data.
    pub fn row_motion(&self, id: &Id, now: Duration) -> RowMotion {
        let Some(row) = self.rows.get(id) else {
            return RowMotion::default();
        };
        let result = self.presented(id, row.y, now);
        RowMotion {
            translate_y: result.y - row.y,
            opacity: result.opacity.clamp(0.0, 1.0),
            height_scale: result.height_scale.clamp(0.0, 1.0),
        }
    }

    /// Rebase cached content coordinates after a stable scroll anchor moves.
    /// This preserves the same presentation in the viewport when rows are
    /// inserted or removed above it.
    pub fn translate_layout(&mut self, offset: f32) {
        for row in self.rows.values_mut() {
            row.y += offset;
        }
        for transition in self.transitions.values_mut() {
            transition.from_y += offset;
            transition.to_y += offset;
        }
    }

    /// Whether the caller should continue requesting animation frames.
    pub fn is_animating(&self) -> bool {
        !self.transitions.is_empty()
    }

    /// Drop completed transitions even when their rows have scrolled out of
    /// the viewport and are no longer sampled by `row_motion`.
    pub fn tick(&mut self, now: Duration) {
        self.transitions
            .retain(|_, transition| progress(transition, now) < 1.0);
    }

    /// Number of rows held by this helper, never greater than the viewport cap.
    pub fn retained_row_count(&self) -> usize {
        self.row_order.len()
    }

    /// Current bounded row layouts, primarily for coordinating a viewport
    /// snapshot with the list's measured bounds.
    pub fn first_retained_layout(&self) -> Option<&TreeListRowLayout<Id>> {
        self.row_order.front().and_then(|id| self.rows.get(id))
    }

    fn presented(&self, id: &Id, fallback_y: f32, now: Duration) -> Presented {
        let Some(transition) = self.transitions.get(id) else {
            return Presented {
                y: fallback_y,
                opacity: 1.0,
                height_scale: 1.0,
            };
        };
        let t = ease(progress(transition, now));
        Presented {
            y: lerp(transition.from_y, transition.to_y, t),
            opacity: lerp(transition.from_opacity, transition.to_opacity, t),
            height_scale: lerp(transition.from_height, transition.to_height, t),
        }
    }
}

fn progress(transition: &Transition, now: Duration) -> f32 {
    let elapsed = now.saturating_sub(transition.started_at);
    (elapsed.as_secs_f32() / transition.duration.as_secs_f32()).clamp(0.0, 1.0)
}

fn ease(t: f32) -> f32 {
    t * t * (3.0 - 2.0 * t)
}
fn lerp(from: f32, to: f32, t: f32) -> f32 {
    from + (to - from) * t
}

#[cfg(test)]
mod tests {
    use super::*;

    fn row(id: u8, y: f32) -> TreeListRowLayout<u8> {
        TreeListRowLayout {
            id,
            y,
            height: 20.0,
        }
    }

    #[test]
    fn inserted_rows_grow_fade_and_keep_canonical_final_position() {
        let mut motion = TreeListMotionState::new(Duration::from_millis(100));
        motion.capture_layout(&[row(1, 0.0)]);
        motion.begin_transition(&[row(1, 0.0), row(2, 20.0)], Duration::ZERO, false);
        let start = motion.row_motion(&2, Duration::ZERO);
        assert_eq!(start.height_scale, 0.0);
        assert_eq!(start.opacity, 0.0);
        assert_eq!(
            motion.row_motion(&2, Duration::from_millis(100)),
            RowMotion::default()
        );
    }

    #[test]
    fn surviving_rows_flip_when_expansion_splices_rows_above_them() {
        let mut motion = TreeListMotionState::new(Duration::from_millis(100));
        motion.capture_layout(&[row(1, 0.0), row(4, 20.0)]);
        motion.begin_transition(
            &[row(1, 0.0), row(2, 20.0), row(3, 40.0), row(4, 60.0)],
            Duration::ZERO,
            false,
        );
        // Existing row 4 animates from its old position while the inserted
        // rows expand into the canonical slots above it.
        let start = motion.row_motion(&4, Duration::ZERO);
        assert_eq!(start.translate_y, -40.0);
        // The visual row begins at its previous y=20 while its canonical slot
        // already sits at y=60 for hit testing and list measurement.
        assert_eq!(60.0 + start.translate_y, 20.0);
        assert_eq!(
            motion
                .row_motion(&4, Duration::from_millis(100))
                .translate_y,
            0.0
        );
    }

    #[test]
    fn repeated_transition_rebases_from_current_presentation() {
        let mut motion = TreeListMotionState::new(Duration::from_millis(100));
        motion.capture_layout(&[row(1, 0.0), row(2, 40.0)]);
        motion.begin_transition(&[row(1, 0.0), row(2, 20.0)], Duration::ZERO, false);
        let halfway = Duration::from_millis(50);
        let current = motion.row_motion(&2, halfway).translate_y;
        let old_presented_y = 20.0 + current;
        motion.begin_transition(&[row(1, 0.0), row(2, 40.0)], halfway, false);
        let new_presented_y = 40.0 + motion.row_motion(&2, halfway).translate_y;
        assert!((new_presented_y - old_presented_y).abs() < 0.01);
    }

    #[test]
    fn scroll_anchor_rebase_preserves_an_active_transition() {
        let mut motion = TreeListMotionState::new(Duration::from_millis(100));
        motion.capture_layout(&[row(1, 40.0)]);
        motion.begin_transition(&[row(1, 20.0)], Duration::ZERO, false);
        let halfway = Duration::from_millis(50);
        let offset = motion.row_motion(&1, halfway);
        motion.translate_layout(60.0);
        assert_eq!(motion.row_motion(&1, halfway), offset);
        motion.begin_transition(&[row(1, 80.0)], halfway, false);
        assert_eq!(motion.row_motion(&1, halfway), offset);
    }

    #[test]
    fn reduced_motion_commits_immediately_and_removed_rows_are_forgotten() {
        let mut motion = TreeListMotionState::new(Duration::from_millis(100));
        motion.capture_layout(&[row(1, 0.0), row(2, 20.0)]);
        motion.begin_transition(&[row(1, 0.0)], Duration::ZERO, true);
        assert!(!motion.is_animating());
        assert_eq!(motion.retained_row_count(), 1);
        assert_eq!(motion.row_motion(&2, Duration::ZERO), RowMotion::default());
    }

    #[test]
    fn retained_state_is_capped_to_materialized_rows() {
        let mut motion = TreeListMotionState::default();
        let rows: Vec<_> = (0..MAX_MOTION_ROWS + 40)
            .map(|id| TreeListRowLayout {
                id,
                y: id as f32,
                height: 1.0,
            })
            .collect();
        motion.capture_layout(&rows);
        assert_eq!(motion.retained_row_count(), MAX_MOTION_ROWS);
    }

    #[test]
    fn tick_prunes_finished_rows_without_sampling_them_again() {
        let mut motion = TreeListMotionState::new(Duration::from_millis(50));
        motion.capture_layout(&[row(1, 0.0)]);
        motion.begin_transition(&[row(1, 10.0)], Duration::ZERO, false);
        assert!(motion.is_animating());
        motion.tick(Duration::from_millis(50));
        assert!(!motion.is_animating());
    }

    #[test]
    fn new_frame_drops_offscreen_layouts_but_keeps_visible_transition_state() {
        let mut motion = TreeListMotionState::new(Duration::from_millis(100));
        motion.capture_layout(&[row(1, 0.0), row(2, 20.0)]);
        motion.begin_transition(&[row(1, 0.0), row(2, 40.0)], Duration::ZERO, false);
        motion.begin_frame();
        assert_eq!(motion.retained_row_count(), 0);
        assert!(motion.is_animating());
        motion.record_layout(row(2, 40.0));
        assert_eq!(motion.row_motion(&2, Duration::ZERO).translate_y, -20.0);
    }
}
