//! Positional paint authority over the current canonical scene. These are
//! checked group indices, not semantic identities or cross-scene capabilities.
use super::*;

/// Start of one color-bearing command group in painter order.
///
/// A replacement scene may give the same position a different meaning. The
/// caller owns that semantic binding; every edit still checks the current
/// group's material, boundary and alpha before touching any commands.
#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord)]
pub struct PaintIndex(u32);
impl PaintIndex {
    pub fn order(self) -> u32 {
        self.0
    }
}

/// One admitted working-color value. Construction converts a validated author
/// color once, before borrowing the Canvas transactionally.
#[derive(Clone, Copy, Debug)]
pub struct PaintEdit {
    index: PaintIndex,
    color: [f32; 4],
}
impl PaintEdit {
    pub fn new(index: PaintIndex, color: Color) -> Self {
        Self {
            index,
            color: color.premultiplied(),
        }
    }
    pub fn index(self) -> PaintIndex {
        self.index
    }
    pub fn color(self) -> [f32; 4] {
        self.color
    }
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum PaintErrorKind {
    MissingGroup,
    NotColor,
    AlphaChanged,
    /// Edits must have strictly increasing group positions. Coalescing belongs
    /// to the source owner, which knows the intended order of its writes.
    Unordered,
    ResourceLimit,
}
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct PaintError {
    pub edit: usize,
    pub reason: PaintErrorKind,
}
impl std::fmt::Display for PaintError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{self:?}")
    }
}
impl std::error::Error for PaintError {}

/// A prevalidated color commit. Its exclusive Canvas borrow prevents topology
/// changes between validation and the infallible write phase. Drop is a no-op.
/// No staging Vec or resource reference increment is required.
///
/// ```compile_fail,E0499
/// use gpui_canvas::{Canvas, Color, PaintEdit};
/// fn cannot_retarget(canvas: &mut Canvas, edits: &[PaintEdit]) {
///     let plan = canvas.prepare_paint(edits).unwrap();
///     canvas.clear(Color::BLACK);
///     plan.commit();
/// }
/// ```
#[must_use = "call commit to apply the validated edits; dropping changes nothing"]
pub struct PaintCommit<'canvas, 'edits> {
    canvas: &'canvas mut Canvas,
    edits: &'edits [PaintEdit],
    damage: DamageRegion,
    changed: usize,
}
impl PaintCommit<'_, '_> {
    pub fn damage(&self) -> DamageRegion {
        self.damage
    }
    pub fn changed_groups(&self) -> usize {
        self.changed
    }
    pub fn commit(self) -> DamageRegion {
        for edit in self.edits {
            let commands = &mut self.canvas.commands;
            let address = commands.order[edit.index.0 as usize];
            let common = if address & INLINE_DRAW != 0 {
                &mut commands.inline[(address & !INLINE_DRAW) as usize].common
            } else {
                let group = commands.placements[address as usize].common;
                &mut commands.commons[group as usize].common
            };
            common.paint = commands
                .columns
                .set_literal(common.paint, PaintColor(edit.color));
        }
        self.canvas.dirty |= self.changed != 0;
        self.damage
    }
}

impl DisplayList {
    fn paint_group(
        &self,
        start: u32,
        viewport: Rect,
    ) -> Result<(u32, Common, DamageRegion), PaintErrorKind> {
        let &address = self
            .order
            .get(start as usize)
            .ok_or(PaintErrorKind::MissingGroup)?;
        let (common, geometry, source) = self.parts(address, viewport);
        if source != RECT_SOURCE && source & ROUNDED_SOURCE == 0 && source & IMAGE_SOURCE != 0 {
            return Err(PaintErrorKind::NotColor);
        }
        let damage = if address & INLINE_DRAW != 0 {
            DamageRegion::checked_canvas_bounds(geometry.bounds.map(usize::from))
        } else {
            let p = &self.placements[address as usize];
            if self.commons[p.common as usize].range[0] != start {
                return Err(PaintErrorKind::MissingGroup);
            }
            // All placements share this clip. Using it avoids a glyph-count
            // scan on every foreground edit. It can be larger than glyph ink.
            // The Canvas caller intersects it with the physical viewport.
            DamageRegion::default()
        };
        Ok((address, common, damage))
    }
}

impl Canvas {
    /// Capture immediately before one paint call, then resolve immediately
    /// afterward with paint_index. An empty/clipped call emits no index.
    pub fn paint_cursor(&self) -> u32 {
        self.commands.order.len() as u32
    }

    pub fn paint_index(&self, cursor: u32) -> Option<PaintIndex> {
        self.commands
            .paint_group(cursor, viewport_rect(self.width, self.height))
            .ok()
            .map(|_| PaintIndex(cursor))
    }

    /// Validate the whole edit list before any mutation. Geometry, clip,
    /// material, clear/configuration and command order remain unchanged.
    ///
    /// The diagnostic image becomes dirty on a changed value. Existing CPU
    /// rasterization can reuse geometry bins for the same tile envelope, while
    /// recomputing current opacity cuts. External buffer age remains the host's
    /// responsibility.
    pub fn prepare_paint<'canvas, 'edits>(
        &'canvas mut self,
        edits: &'edits [PaintEdit],
    ) -> Result<PaintCommit<'canvas, 'edits>, PaintError> {
        let mut previous = None;
        let mut damage = DamageRegion::default();
        let mut changed = 0;
        let mut literals = 0;
        for (i, edit) in edits.iter().enumerate() {
            let fail = |reason| PaintError { edit: i, reason };
            if previous.is_some_and(|index| index >= edit.index) {
                return Err(fail(PaintErrorKind::Unordered));
            }
            previous = Some(edit.index);
            let (address, common, support) = self
                .commands
                .paint_group(edit.index.0, viewport_rect(self.width, self.height))
                .map_err(fail)?;
            if edit.color[3] == 0.0 || edit.color[3].to_bits() != common.color[3].to_bits() {
                return Err(fail(PaintErrorKind::AlphaChanged));
            }
            let reference = if address & INLINE_DRAW != 0 {
                self.commands.inline[(address & !INLINE_DRAW) as usize]
                    .common
                    .paint
            } else {
                self.commands.commons[self.commands.placements[address as usize].common as usize]
                    .common
                    .paint
            };
            literals += usize::from(
                self.commands
                    .columns
                    .needs_literal_entry(reference, PaintColor(edit.color)),
            );
            if edit.color.map(f32::to_bits) == common.color.map(f32::to_bits) {
                continue;
            }
            changed += 1;
            let support = if address & INLINE_DRAW != 0 {
                support
            } else {
                let c = common.clip;
                let x = f64::from(c.x);
                let y = f64::from(c.y);
                DamageRegion::checked_canvas_bounds([
                    x.floor().clamp(0.0, self.width as f64) as usize,
                    y.floor().clamp(0.0, self.height as f64) as usize,
                    (x + f64::from(c.width))
                        .ceil()
                        .clamp(0.0, self.width as f64) as usize,
                    (y + f64::from(c.height))
                        .ceil()
                        .clamp(0.0, self.height as f64) as usize,
                ])
            };
            damage = damage.union(support);
        }
        self.commands
            .columns
            .reserve_literals(literals)
            .map_err(|_| PaintError {
                edit: 0,
                reason: PaintErrorKind::ResourceLimit,
            })?;
        Ok(PaintCommit {
            canvas: self,
            edits,
            damage,
            changed,
        })
    }
}
impl PreparedScene<'_> {
    /// Check a position against this borrowed canonical scene. This does not
    /// turn the index into a cross-scene identity or generation capability.
    pub fn paint_index(self, cursor: u32) -> Option<PaintIndex> {
        self.commands
            .paint_group(cursor, extent_rect(self.extent))
            .ok()
            .map(|_| PaintIndex(cursor))
    }
}
impl CanvasScene<'_> {
    pub fn paint_cursor(&self) -> u32 {
        self.pending.paint_cursor()
    }
    pub fn paint_index(&self, cursor: u32) -> Option<PaintIndex> {
        self.pending.paint_index(cursor)
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn paint_plan_adds_no_canvas_fields_and_allocates_nothing() {
        eprintln!(
            "paint_storage,Canvas={},DisplayList={},PaintIndex={},PaintEdit={},PaintCommit={}",
            size_of::<Canvas>(),
            size_of::<DisplayList>(),
            size_of::<PaintIndex>(),
            size_of::<PaintEdit>(),
            size_of::<PaintCommit<'_, '_>>()
        );
        let mut canvas = Canvas::new(32, 32).unwrap();
        let rect = Rect::new(0.0, 0.0, 32.0, 32.0);
        canvas
            .fill_rect(rect, Affine::IDENTITY, rect, Color::BLACK)
            .unwrap();
        let index = canvas.paint_index(0).unwrap();
        let edits = [PaintEdit::new(index, Color::WHITE)];
        let measured = allocation_counter::measure(|| {
            canvas.prepare_paint(&edits).unwrap().commit();
        });
        assert_eq!((measured.count_total, measured.bytes_total), (0, 0));
        eprintln!(
            "paint_commit_allocations={},bytes={}",
            measured.count_total, measured.bytes_total
        );
    }
}
