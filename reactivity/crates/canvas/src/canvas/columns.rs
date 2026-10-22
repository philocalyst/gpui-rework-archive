//! Canonical-C spaces and working paints. No model or Signal borrow enters here.
use super::{Common, Mapping};
use crate::{Color, DamageRegion, Error, Rect};

const DISCOVERY: usize = 32;
const FIRST_PAINT: u32 = 3;
const MAX_ROWS: usize = super::MAX_COMMANDS * 2;
const SHARED: u8 = 1;
const RECTANGLE: u8 = 2;

/// A validated author color converted once to the canonical working domain.
/// Private lanes prevent callers constructing arbitrary/nonfinite GPU values.
#[derive(Clone, Copy, Debug)]
pub struct PaintColor(pub(super) [f32; 4]);
impl PaintColor {
    pub fn new(color: Color) -> Self {
        Self(color.premultiplied())
    }
    pub fn working(self) -> [f32; 4] {
        self.0
    }
}

/// Position in the current canonical paint bank, not semantic identity or a
/// cross-scene capability. Scene replacement can reuse the same position; an
/// owner pairs this with its exact complete-scene token before incremental use.
#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord)]
pub struct PaintSlot(std::num::NonZeroU32);
impl PaintSlot {
    /// Zero-based row in PreparedScene::paint_bank. Implicit literal paints
    /// are not rows. This is positional information, not scene authority.
    pub fn index(self) -> u32 {
        self.0.get() - FIRST_PAINT
    }
}

#[derive(Clone, Copy, Debug)]
pub struct SlotEdit {
    slot: PaintSlot,
    value: PaintColor,
}
impl SlotEdit {
    pub fn new(slot: PaintSlot, value: PaintColor) -> Self {
        Self { slot, value }
    }
    pub fn slot(self) -> PaintSlot {
        self.slot
    }
    pub fn value(self) -> PaintColor {
        self.value
    }
}
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum SlotErrorKind {
    MissingSlot,
    NotShared,
    AlphaChanged,
    Unordered,
}
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct SlotError {
    pub edit: usize,
    pub reason: SlotErrorKind,
}
impl std::fmt::Display for SlotError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{self:?}")
    }
}
impl std::error::Error for SlotError {}

#[derive(Clone, Copy)]
pub(super) struct Scope {
    inverse: [f64; 4],
    clip: Rect,
}
#[derive(Clone, Copy)]
pub(super) struct ScopeRef(u32);
#[derive(Clone, Copy)]
pub(super) struct PaintRef(u32);
#[derive(Clone, Copy)]
pub(super) struct StoredCommon {
    pub(super) translation: [f64; 2],
    pub(super) scope: ScopeRef,
    pub(super) paint: PaintRef,
}
impl StoredCommon {
    // Only image material consumes this private lane as a radius. Other source
    // variants ignore the argument passed to BorrowedSource::prepared.
    pub(super) fn image_radius(self) -> f32 {
        f32::from_bits(self.paint.0)
    }
}
#[derive(Clone, Copy)]
pub(super) struct PaintValue {
    value: PaintColor,
    damage: DamageRegion,
    flags: u8,
}
#[derive(Default)]
pub(super) struct Columns {
    scopes: Vec<Scope>,
    paints: Vec<PaintValue>,
}
fn same_rect(a: Rect, b: Rect) -> bool {
    [a.x, a.y, a.width, a.height].map(f32::to_bits)
        == [b.x, b.y, b.width, b.height].map(f32::to_bits)
}
fn same_color(a: PaintColor, b: PaintColor) -> bool {
    a.0.map(f32::to_bits) == b.0.map(f32::to_bits)
}
fn implicit_scope(viewport: Rect) -> Scope {
    // These are the exact coefficients produced by Mapping::new(IDENTITY),
    // including its negative off-diagonal zeros. Other authored zero signs
    // are separate scopes, even when ordinary numerical equality says equal.
    Scope {
        inverse: [1.0, -0.0, -0.0, 1.0],
        clip: viewport,
    }
}
fn implicit_paint(index: u32) -> Option<PaintColor> {
    match index {
        0 => Some(PaintColor([0.0, 0.0, 0.0, 1.0])),
        1 => Some(PaintColor([1.0, 1.0, 1.0, 1.0])),
        2 => Some(PaintColor([0.0; 4])),
        _ => None,
    }
}
impl Columns {
    pub(super) fn clear(&mut self) {
        self.scopes.clear();
        self.paints.clear();
    }
    pub(super) fn bytes(&self) -> usize {
        self.scopes.capacity() * size_of::<Scope>()
            + self.paints.capacity() * size_of::<PaintValue>()
    }
    // Reserve before the display-list commit. Existing immutable scopes and
    // paints keep their positions until the whole canonical scene is replaced.
    pub(super) fn admit(
        &mut self,
        common: Common,
        viewport: Rect,
        shared: Option<PaintSlot>,
        image: bool,
        new_shared: bool,
    ) -> Result<(), Error> {
        let [a, b, c, d, _, _] = common.map.inverse;
        let scope = Scope {
            inverse: [a, b, c, d],
            clip: common.clip,
        };
        let same = |value: &Scope| {
            value.inverse.map(f64::to_bits) == scope.inverse.map(f64::to_bits)
                && same_rect(value.clip, scope.clip)
        };
        let new_scope =
            !same(&implicit_scope(viewport)) && !self.scopes.iter().take(DISCOVERY).any(same);
        let color = PaintColor(common.color);
        let new_paint = if new_shared {
            true
        } else if image {
            false
        } else if let Some(slot) = shared {
            if self.shared_ref(slot).is_none() {
                return Err(Error::InvalidGeometry);
            }
            false
        } else {
            !(0..FIRST_PAINT).any(|index| same_color(color, implicit_paint(index).unwrap()))
        };
        if (new_scope && self.scopes.len() >= MAX_ROWS)
            || (new_paint && self.paints.len() >= MAX_ROWS)
        {
            return Err(Error::ResourceLimit);
        }
        if new_scope {
            self.scopes
                .try_reserve(1)
                .map_err(|_| Error::ResourceLimit)?;
        }
        if new_paint {
            self.paints
                .try_reserve(1)
                .map_err(|_| Error::ResourceLimit)?;
        }
        Ok(())
    }
    pub(super) fn scope(&mut self, common: Common, viewport: Rect) -> ScopeRef {
        let [a, b, c, d, _, _] = common.map.inverse;
        let scope = Scope {
            inverse: [a, b, c, d],
            clip: common.clip,
        };
        let same = |value: &Scope| {
            value.inverse.map(f64::to_bits) == scope.inverse.map(f64::to_bits)
                && same_rect(value.clip, scope.clip)
        };
        if same(&implicit_scope(viewport)) {
            return ScopeRef(0);
        }
        if let Some(index) = self.scopes.iter().take(DISCOVERY).position(same) {
            return ScopeRef(index as u32 + 1);
        }
        let index = self.scopes.len();
        self.scopes.push(scope);
        ScopeRef(index as u32 + 1)
    }
    pub(super) fn literal(&mut self, color: PaintColor) -> PaintRef {
        for index in 0..FIRST_PAINT {
            if same_color(color, implicit_paint(index).unwrap()) {
                return PaintRef(index);
            }
        }
        let index = self.paints.len();
        self.paints.push(PaintValue {
            value: color,
            damage: DamageRegion::default(),
            flags: 0,
        });
        PaintRef(index as u32 + FIRST_PAINT)
    }
    // Nonshared literal entries are owned by exactly one common group. Keep
    // that entry even when it later becomes an implicit color; repeated unique
    // PaintIndex edits then overwrite one row rather than retain color history.
    pub(super) fn set_literal(&mut self, reference: PaintRef, color: PaintColor) -> PaintRef {
        if reference.0 >= FIRST_PAINT {
            let value = &mut self.paints[(reference.0 - FIRST_PAINT) as usize];
            if value.flags & SHARED == 0 {
                value.value = color;
                return reference;
            }
        }
        self.literal(color)
    }
    pub(super) fn needs_literal_entry(&self, reference: PaintRef, color: PaintColor) -> bool {
        if reference.0 >= FIRST_PAINT
            && self.paints[(reference.0 - FIRST_PAINT) as usize].flags & SHARED == 0
        {
            return false;
        }
        !(0..FIRST_PAINT).any(|i| same_color(color, implicit_paint(i).unwrap()))
    }
    pub(super) fn reserve_literals(&mut self, additional: usize) -> Result<(), Error> {
        if self.paints.len().saturating_add(additional) > MAX_ROWS {
            return Err(Error::ResourceLimit);
        }
        self.paints
            .try_reserve(additional)
            .map_err(|_| Error::ResourceLimit)
    }
    pub(super) fn shared(&mut self, color: PaintColor) -> Result<PaintSlot, Error> {
        if self.paints.len() >= MAX_ROWS {
            return Err(Error::ResourceLimit);
        }
        self.paints
            .try_reserve(1)
            .map_err(|_| Error::ResourceLimit)?;
        Ok(self.shared_reserved(color))
    }
    fn shared_reserved(&mut self, color: PaintColor) -> PaintSlot {
        let index = self.paints.len();
        self.paints.push(PaintValue {
            value: color,
            damage: DamageRegion::default(),
            flags: SHARED,
        });
        PaintSlot(std::num::NonZeroU32::new(index as u32 + FIRST_PAINT).unwrap())
    }
    pub(super) fn paint(&self, reference: PaintRef) -> PaintColor {
        implicit_paint(reference.0)
            .unwrap_or_else(|| self.paints[(reference.0 - FIRST_PAINT) as usize].value)
    }
    pub(super) fn shared_ref(&self, slot: PaintSlot) -> Option<PaintRef> {
        let index = slot.index() as usize;
        self.paints
            .get(index)
            .filter(|value| value.flags & SHARED != 0)
            .map(|_| PaintRef(slot.0.get()))
    }
    pub(super) fn resolve(&self, common: StoredCommon, viewport: Rect, image: bool) -> Common {
        let scope = if common.scope.0 == 0 {
            implicit_scope(viewport)
        } else {
            self.scopes[common.scope.0 as usize - 1]
        };
        let [a, b, c, d] = scope.inverse;
        let [tx, ty] = common.translation;
        Common {
            clip: scope.clip,
            map: Mapping {
                inverse: [a, b, c, d, tx, ty],
            },
            color: if image {
                [f32::from_bits(common.paint.0), 0.0, 0.0, 1.0]
            } else {
                self.paint(common.paint).0
            },
        }
    }
    pub(super) fn store(
        &mut self,
        common: Common,
        viewport: Rect,
        shared: Option<PaintSlot>,
        image: bool,
    ) -> StoredCommon {
        let scope = self.scope(common, viewport);
        let paint = if image {
            PaintRef(common.color[0].to_bits())
        } else if let Some(slot) = shared {
            self.shared_ref(slot)
                .expect("validated current shared slot")
        } else {
            self.literal(PaintColor(common.color))
        };
        StoredCommon {
            scope,
            paint,
            translation: [common.map.inverse[4], common.map.inverse[5]],
        }
    }
    pub(super) fn support(&mut self, paint: PaintRef, damage: DamageRegion, rectangle: bool) {
        if paint.0 < FIRST_PAINT {
            return;
        }
        let value = &mut self.paints[(paint.0 - FIRST_PAINT) as usize];
        value.damage = value.damage.union(damage);
        if rectangle {
            value.flags |= RECTANGLE;
        }
    }
    pub(super) fn shared_slot(&self, paint: PaintRef) -> Option<PaintSlot> {
        if paint.0 < FIRST_PAINT {
            return None;
        }
        (self.paints[(paint.0 - FIRST_PAINT) as usize].flags & SHARED != 0)
            .then(|| PaintSlot(std::num::NonZeroU32::new(paint.0).unwrap()))
    }
    pub(super) fn bank(
        &self,
    ) -> impl ExactSizeIterator<Item = PreparedPaint> + DoubleEndedIterator + '_ {
        let end = self
            .paints
            .iter()
            .rposition(|paint| paint.flags & SHARED != 0)
            .map_or(0, |last| last + 1);
        self.paints[..end].iter().map(|paint| PreparedPaint {
            value: paint.value,
            flags: paint.flags,
        })
    }
    pub(super) fn validate(&self, edits: &[SlotEdit]) -> Result<(DamageRegion, usize), SlotError> {
        let mut previous = None;
        let mut damage = DamageRegion::default();
        let mut changed = 0;
        for (edit, write) in edits.iter().enumerate() {
            let fail = |reason| SlotError { edit, reason };
            if previous.is_some_and(|slot| slot >= write.slot) {
                return Err(fail(SlotErrorKind::Unordered));
            }
            previous = Some(write.slot);
            let index = write.slot.index() as usize;
            let old = self
                .paints
                .get(index)
                .ok_or_else(|| fail(SlotErrorKind::MissingSlot))?;
            if old.flags & SHARED == 0 {
                return Err(fail(SlotErrorKind::NotShared));
            }
            if old.value.0[3].to_bits() != write.value.0[3].to_bits() {
                return Err(fail(SlotErrorKind::AlphaChanged));
            }
            if !same_color(old.value, write.value) {
                damage = damage.union(old.damage);
                changed += 1;
            }
        }
        Ok((damage, changed))
    }
    pub(super) fn commit(&mut self, edits: &[SlotEdit]) {
        for edit in edits {
            self.paints[edit.slot.index() as usize].value = edit.value;
        }
    }
}

/// Exclusive, validated edit of the complete canonical scene's paint bank.
/// Dropping without committing changes neither commands nor working colors.
pub struct SlotCommit<'canvas, 'edits> {
    canvas: &'canvas mut super::Canvas,
    edits: &'edits [SlotEdit],
    damage: DamageRegion,
    changed: usize,
}
impl SlotCommit<'_, '_> {
    pub fn damage(&self) -> DamageRegion {
        self.damage
    }
    pub fn changed_slots(&self) -> usize {
        self.changed
    }
    pub fn commit(self) -> DamageRegion {
        self.canvas.commands.columns.commit(self.edits);
        self.canvas.dirty |= self.changed != 0;
        self.damage
    }
}
impl super::Canvas {
    /// Allocate a distinct shared working-color relationship in this scene.
    /// Equal colors deliberately receive distinct slots. Scene replacement
    /// revokes positional meanings; callers retain their own scene authority.
    pub fn paint_slot(&mut self, value: PaintColor) -> Result<PaintSlot, Error> {
        self.commands.columns.shared(value)
    }
    pub fn prepare_slots<'canvas, 'edits>(
        &'canvas mut self,
        edits: &'edits [SlotEdit],
    ) -> Result<SlotCommit<'canvas, 'edits>, SlotError> {
        let (damage, changed) = self.commands.columns.validate(edits)?;
        Ok(SlotCommit {
            canvas: self,
            edits,
            damage,
            changed,
        })
    }
    pub(super) fn slot_color(&self, slot: PaintSlot) -> Result<PaintColor, Error> {
        let reference = self
            .commands
            .columns
            .shared_ref(slot)
            .ok_or(Error::InvalidPaintSlot)?;
        Ok(self.commands.columns.paint(reference))
    }
}
impl super::CanvasScene<'_> {
    pub fn paint_slot(&mut self, value: PaintColor) -> Result<PaintSlot, Error> {
        self.pending.paint_slot(value)
    }
}

/// A borrowed-scene paint row. Nonshared rows can occur between shared slots;
/// backends retain these positions, rather than invent another identity map.
#[derive(Clone, Copy, Debug)]
pub struct PreparedPaint {
    value: PaintColor,
    flags: u8,
}
impl PreparedPaint {
    pub fn value(self) -> PaintColor {
        self.value
    }
    pub fn shared(self) -> bool {
        self.flags & SHARED != 0
    }
    pub fn rectangle(self) -> bool {
        self.flags & RECTANGLE != 0
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn complete_bank_layout_and_plain_recording_floor_are_explicit() {
        eprintln!(
            "scope_bank_layout,Canvas={},DisplayList={},Columns={},Inline={},CommonGroup={},Scope={},Paint={},Stored={},Frame={},Prepared={},PreparedGroup={},Slot={},OptionSlot={},Edit={}",
            size_of::<super::super::Canvas>(),
            size_of::<super::super::DisplayList>(),
            size_of::<Columns>(),
            size_of::<super::super::InlineDraw>(),
            size_of::<super::super::CommonGroup>(),
            size_of::<Scope>(),
            size_of::<PaintValue>(),
            size_of::<StoredCommon>(),
            size_of::<super::super::Frame<'_>>(),
            size_of::<super::super::PreparedScene<'_>>(),
            size_of::<super::super::PreparedGroup<'_>>(),
            size_of::<PaintSlot>(),
            size_of::<Option<PaintSlot>>(),
            size_of::<SlotEdit>()
        );
        assert_eq!(size_of::<Columns>(), 2 * size_of::<Vec<()>>());
        assert_eq!(size_of::<PaintSlot>(), size_of::<Option<PaintSlot>>());
        let allocation = allocation_counter::measure(|| {
            let mut canvas =
                super::super::Canvas::recording(32, 32, crate::ColorConfig::default()).unwrap();
            canvas
                .fill_rect(
                    Rect::new(0., 0., 32., 32.),
                    crate::Affine::IDENTITY,
                    Rect::new(0., 0., 32., 32.),
                    Color::BLACK,
                )
                .unwrap();
            assert!(canvas.commands.columns.scopes.is_empty());
            assert!(canvas.commands.columns.paints.is_empty());
        });
        eprintln!(
            "scope_plain_recording,allocations={},requested={},peak={}",
            allocation.count_total, allocation.bytes_total, allocation.bytes_max
        );
    }
}

/// Temporary admission choice. The cache borrow ends before a command is stored.
pub(super) enum PaintUse<'a> {
    Literal,
    Existing(PaintSlot),
    Shared(&'a mut Option<PaintSlot>),
}
impl PaintUse<'_> {
    pub(super) fn reference(&self) -> Option<PaintSlot> {
        match self {
            Self::Literal => None,
            Self::Existing(slot) => Some(*slot),
            Self::Shared(cache) => **cache,
        }
    }
    pub(super) fn new_shared(&self) -> bool {
        matches!(self, Self::Shared(None))
    }
    pub(super) fn commit(self, columns: &mut Columns, value: PaintColor) -> Option<PaintSlot> {
        match self {
            Self::Literal => None,
            Self::Existing(slot) => Some(slot),
            Self::Shared(cache) => {
                Some(*cache.get_or_insert_with(|| columns.shared_reserved(value)))
            }
        }
    }
}
