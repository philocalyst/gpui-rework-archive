//! Canonical-C spaces and working paints. No model or Signal borrow enters here.
use super::{Common, Mapping};
use crate::{Color, DamageRegion, Error, Rect};

const DISCOVERY: usize = 32;
const FIRST_PAINT: u32 = 3;
const MAX_ROWS: usize = super::MAX_COMMANDS * 2;
const SHARED: u8 = 1;
const RECTANGLE: u8 = 2;
const SUPPORT_FLAG: u16 = 1 << 15;
const _: () = assert!(16_384 < SUPPORT_FLAG);

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
    support: PaintSupport,
}
/// Four admitted coordinates use only bits 0..=14. Their four spare high bits
/// carry material and literal ownership facts; they are masked before any
/// geometry operation. Immutable rows may have multiple owners; exclusive rows
/// have been positionally written and never participate in discovery again.
#[derive(Clone, Copy, Default)]
struct PaintSupport([u16; 4]);
impl PaintSupport {
    fn new(shared: bool) -> Self {
        Self([u16::from(shared) * SUPPORT_FLAG, 0, 0, 0])
    }
    fn shared(self) -> bool {
        self.0[0] & SUPPORT_FLAG != 0
    }
    fn rectangle(self) -> bool {
        self.0[1] & SUPPORT_FLAG != 0
    }
    fn immutable(self) -> bool {
        self.0[2] & SUPPORT_FLAG != 0
    }
    fn discoverable(self) -> bool {
        !self.shared() && self.0[3] & SUPPORT_FLAG == 0
    }
    fn writable_literal(self) -> bool {
        !self.shared() && !self.immutable()
    }
    fn alias(&mut self) {
        debug_assert!(self.discoverable());
        self.0[2] |= SUPPORT_FLAG;
    }
    fn exclusive(&mut self) {
        debug_assert!(!self.shared() && !self.immutable());
        self.0[3] |= SUPPORT_FLAG;
    }
    fn flags(self) -> u8 {
        (u8::from(self.shared()) * SHARED) | (u8::from(self.rectangle()) * RECTANGLE)
    }
    fn damage(self) -> DamageRegion {
        DamageRegion::checked_canvas_bounds(self.0.map(|v| usize::from(v & !SUPPORT_FLAG)))
    }
    fn include(&mut self, damage: DamageRegion, rectangle: bool) {
        let flags = self.0.map(|value| value & SUPPORT_FLAG);
        self.0 = self.damage().union(damage).coordinates();
        for (coordinate, flag) in self.0.iter_mut().zip(flags) {
            *coordinate |= flag;
        }
        self.0[1] |= u16::from(rectangle) * SUPPORT_FLAG;
    }
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
    fn find_scope(&self, scope: Scope, viewport: Rect) -> Option<ScopeRef> {
        let same = |value: &Scope| {
            value.inverse.map(f64::to_bits) == scope.inverse.map(f64::to_bits)
                && same_rect(value.clip, scope.clip)
        };
        if same(&implicit_scope(viewport)) {
            return Some(ScopeRef(0));
        }
        // Adjacent cohorts can begin after the bounded discovery prefix.
        // Reuse their most recently stored exact scope without growing a map.
        if self.scopes.last().is_some_and(same) {
            return Some(ScopeRef(self.scopes.len() as u32));
        }
        self.scopes
            .iter()
            .take(DISCOVERY)
            .position(same)
            .map(|index| ScopeRef(index as u32 + 1))
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
        let new_scope = self.find_scope(scope, viewport).is_none();
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
            self.find_literal(color).is_none()
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
        if let Some(reference) = self.find_scope(scope, viewport) {
            return reference;
        }
        let index = self.scopes.len();
        self.scopes.push(scope);
        ScopeRef(index as u32 + 1)
    }
    fn implicit_literal(color: PaintColor) -> Option<PaintRef> {
        for index in 0..FIRST_PAINT {
            if same_color(color, implicit_paint(index).unwrap()) {
                return Some(PaintRef(index));
            }
        }
        None
    }
    fn find_literal(&self, color: PaintColor) -> Option<PaintRef> {
        if let Some(reference) = Self::implicit_literal(color) {
            return Some(reference);
        }
        let same =
            |paint: &PaintValue| paint.support.discoverable() && same_color(paint.value, color);
        if self.paints.last().is_some_and(same) {
            return Some(PaintRef(self.paints.len() as u32 - 1 + FIRST_PAINT));
        }
        self.paints
            .iter()
            .take(DISCOVERY)
            .position(same)
            .map(|index| PaintRef(index as u32 + FIRST_PAINT))
    }
    pub(super) fn literal(&mut self, color: PaintColor) -> PaintRef {
        if let Some(reference) = self.find_literal(color) {
            if reference.0 >= FIRST_PAINT {
                self.paints[(reference.0 - FIRST_PAINT) as usize]
                    .support
                    .alias();
            }
            return reference;
        }
        let index = self.paints.len();
        self.paints.push(PaintValue {
            value: color,
            support: PaintSupport::default(),
        });
        PaintRef(index as u32 + FIRST_PAINT)
    }
    // A positional write must not mutate an aliased row or join discovery.
    // Existing unique rows become exclusive; shared/immutable rows detach.
    // Subsequent writes keep that exclusive row, without retaining history.
    pub(super) fn set_literal(&mut self, reference: PaintRef, color: PaintColor) -> PaintRef {
        if reference.0 >= FIRST_PAINT {
            let value = &mut self.paints[(reference.0 - FIRST_PAINT) as usize];
            if value.support.writable_literal() {
                value.value = color;
                value.support.exclusive();
                return reference;
            }
        }
        if let Some(reference) = Self::implicit_literal(color) {
            return reference;
        }
        let index = self.paints.len();
        let mut support = PaintSupport::default();
        support.exclusive();
        self.paints.push(PaintValue {
            value: color,
            support,
        });
        PaintRef(index as u32 + FIRST_PAINT)
    }
    pub(super) fn needs_literal_entry(&self, reference: PaintRef, color: PaintColor) -> bool {
        if reference.0 >= FIRST_PAINT && {
            let support = self.paints[(reference.0 - FIRST_PAINT) as usize].support;
            support.writable_literal()
        } {
            return false;
        }
        Self::implicit_literal(color).is_none()
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
            support: PaintSupport::new(true),
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
            .filter(|value| value.support.shared())
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
        value.support.include(damage, rectangle);
    }
    pub(super) fn shared_slot(&self, paint: PaintRef) -> Option<PaintSlot> {
        if paint.0 < FIRST_PAINT {
            return None;
        }
        (self.paints[(paint.0 - FIRST_PAINT) as usize]
            .support
            .shared())
        .then(|| PaintSlot(std::num::NonZeroU32::new(paint.0).unwrap()))
    }
    pub(super) fn bank(
        &self,
    ) -> impl ExactSizeIterator<Item = PreparedPaint> + DoubleEndedIterator + '_ {
        let end = self
            .paints
            .iter()
            .rposition(|paint| paint.support.shared())
            .map_or(0, |last| last + 1);
        self.paints[..end].iter().map(|paint| PreparedPaint {
            value: paint.value,
            flags: paint.support.flags(),
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
            if !old.support.shared() {
                return Err(fail(SlotErrorKind::NotShared));
            }
            if old.value.0[3].to_bits() != write.value.0[3].to_bits() {
                return Err(fail(SlotErrorKind::AlphaChanged));
            }
            if !same_color(old.value, write.value) {
                damage = damage.union(old.support.damage());
                changed += 1;
            }
        }
        Ok((damage, changed))
    }
    pub(super) fn commit(&mut self, edits: &[SlotEdit]) -> bool {
        let mut revoke = false;
        for edit in edits {
            let value = &mut self.paints[edit.slot.index() as usize].value;
            revoke |=
                super::can_discard_backdrop(value.0) != super::can_discard_backdrop(edit.value.0);
            *value = edit.value;
        }
        revoke
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
        let revoke = self.canvas.commands.columns.commit(self.edits);
        if revoke && let Some(raster) = &mut self.canvas.raster {
            raster.revoke_cuts();
        }
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

#[cfg(test)]
mod tests {
    use super::*;

    fn admit_literal(columns: &mut Columns, color: PaintColor) -> PaintRef {
        let viewport = Rect::new(0.0, 0.0, 32.0, 32.0);
        let mut common = test_scope(0, viewport);
        common.map.inverse = [1.0, -0.0, -0.0, 1.0, 0.0, 0.0];
        common.color = color.0;
        columns.admit(common, viewport, None, false, false).unwrap();
        columns.literal(color)
    }

    #[test]
    fn literal_palette_shares_exact_bits_without_aliasing_mutable_sources() {
        let color = PaintColor([0.25, 0.5, 0.75, 1.0]);
        let mut columns = Columns::default();
        let source = columns.shared(color).unwrap();
        let first = admit_literal(&mut columns, color);
        let repeated = admit_literal(&mut columns, color);
        assert_eq!(first.0, repeated.0);
        assert_ne!(first.0, source.0.get());
        assert_eq!(columns.paints.len(), 2);
        assert!(columns.paints[1].support.immutable());
        assert!(!columns.paints[0].support.immutable());
        let changed = PaintColor([0.5, 0.25, 0.75, 1.0]);
        let edits = [SlotEdit::new(source, changed)];
        columns.validate(&edits).unwrap();
        columns.commit(&edits);
        assert!(same_color(columns.paint(first), color));

        // Numeric equality cannot merge distinct working-color bit patterns.
        for sign in [0.0, -0.0] {
            admit_literal(&mut columns, PaintColor([sign, 0.5, 0.75, 1.0]));
        }
        assert_eq!(columns.paints.len(), 4);
        let mut fake = source;
        fake.0 = std::num::NonZeroU32::new(first.0).unwrap();
        assert_eq!(
            columns
                .validate(&[SlotEdit::new(fake, changed)])
                .unwrap_err()
                .reason,
            SlotErrorKind::NotShared
        );
    }

    #[test]
    fn positional_writes_detach_once_and_never_rejoin_literal_discovery() {
        let color = PaintColor([0.25, 0.5, 0.75, 1.0]);
        let other = PaintColor([0.5, 0.25, 0.75, 1.0]);
        let mut columns = Columns::default();
        let palette = admit_literal(&mut columns, color);
        assert_eq!(admit_literal(&mut columns, color).0, palette.0);
        assert!(columns.needs_literal_entry(palette, color));
        columns.reserve_literals(1).unwrap();
        let mut detached = palette;
        let measured = allocation_counter::measure(|| {
            detached = columns.set_literal(palette, color);
        });
        assert_eq!(measured.count_total, 0);
        assert_ne!(detached.0, palette.0);
        assert!(!columns.paints[1].support.discoverable());
        assert_eq!(admit_literal(&mut columns, color).0, palette.0);
        let other_palette = admit_literal(&mut columns, other);
        for i in 0..1000 {
            let next = if i % 2 == 0 { other } else { color };
            assert!(!columns.needs_literal_entry(detached, next));
            assert_eq!(columns.set_literal(detached, next).0, detached.0);
            let discovered = admit_literal(&mut columns, next);
            assert_ne!(discovered.0, detached.0);
            assert_eq!(
                discovered.0,
                if i % 2 == 0 {
                    other_palette.0
                } else {
                    palette.0
                }
            );
        }
        assert_eq!(columns.paints.len(), 3);

        // A unique original row can be edited without allocating, then stops
        // being a discovery candidate even before it ever acquired a peer.
        let unique = admit_literal(&mut columns, PaintColor([0.75, 0.25, 0.5, 1.0]));
        assert!(!columns.needs_literal_entry(unique, color));
        assert_eq!(columns.set_literal(unique, color).0, unique.0);
        assert!(!columns.paints[3].support.discoverable());
    }

    #[test]
    fn repeated_unique_and_late_miss_palette_storage_is_explicit() {
        let color = |i: usize| PaintColor([0.25 + i as f32 / 8192.0, 0.5, 0.75, 1.0]);
        for mode in 0..3 {
            let mut columns = Columns::default();
            let measured = allocation_counter::measure(|| {
                for i in 0..4096 {
                    let index = match mode {
                        0 => 0,
                        1 => i,
                        _ if i < DISCOVERY + 2 => i,
                        _ => DISCOVERY + (i % 2),
                    };
                    admit_literal(&mut columns, color(index));
                }
            });
            assert_eq!(columns.paints.len(), if mode == 0 { 1 } else { 4096 });
            eprintln!(
                "literal_palette,mode={mode},rows={},capacity={},allocations={},requested={},live={}",
                columns.paints.len(),
                columns.paints.capacity(),
                measured.count_total,
                measured.bytes_total,
                measured.bytes_current
            );
        }
    }

    #[test]
    fn palette_flags_survive_support_union_without_leaking_into_geometry() {
        for immutable in [false, true] {
            let mut support = PaintSupport::default();
            if immutable {
                support.alias();
            } else {
                support.exclusive();
            }
            support.include(DamageRegion::default(), true);
            assert!(support.damage().is_empty());
            support.include(
                DamageRegion::checked_canvas_bounds([0, 0, 16_384, 16_384]),
                false,
            );
            assert_eq!(support.damage().bounds(), Some([0, 0, 16_384, 16_384]));
            assert_eq!(support.flags(), RECTANGLE);
            assert_eq!(support.immutable(), immutable);
            assert_eq!(support.discoverable(), immutable);
        }
    }

    #[test]
    fn empty_and_clipped_calls_do_not_admit_literals_when_the_bank_is_full() {
        let mut canvas =
            super::super::Canvas::recording(32, 32, crate::ColorConfig::default()).unwrap();
        canvas.commands.columns.paints = vec![
            PaintValue {
                value: PaintColor([0.25, 0.5, 0.75, 1.0]),
                support: PaintSupport::new(true)
            };
            MAX_ROWS
        ];
        let clip = Rect::new(0.0, 0.0, 32.0, 32.0);
        let measured = allocation_counter::measure(|| {
            for rect in [
                Rect::new(0.0, 0.0, 0.0, 16.0),
                Rect::new(100.0, 100.0, 16.0, 16.0),
            ] {
                canvas
                    .fill_rect(rect, crate::Affine::IDENTITY, clip, Color::rgb(23, 45, 67))
                    .unwrap();
            }
        });
        assert_eq!((measured.count_total, measured.bytes_total), (0, 0));
        assert_eq!(canvas.commands.columns.paints.len(), MAX_ROWS);
        assert_eq!(canvas.paint_cursor(), 0);
    }

    #[test]
    fn support_flags_never_enter_empty_or_maximum_canvas_geometry() {
        assert_eq!(size_of::<PaintValue>(), 24);
        assert_eq!(size_of::<PaintSupport>(), 8);
        for shared in [false, true] {
            let mut support = PaintSupport::new(shared);
            assert!(support.damage().is_empty());
            assert_eq!(support.shared(), shared);
            support.include(DamageRegion::default(), true);
            assert!(support.damage().is_empty());
            assert!(support.rectangle());
            assert_eq!(support.shared(), shared);

            support.include(
                DamageRegion::checked_canvas_bounds([16_383, 0, 16_384, 1]),
                false,
            );
            support.include(
                DamageRegion::checked_canvas_bounds([0, 16_383, 1, 16_384]),
                false,
            );
            assert_eq!(support.damage().bounds(), Some([0, 0, 16_384, 16_384]));
            assert_eq!(support.flags(), (u8::from(shared) * SHARED) | RECTANGLE);
            assert_eq!(support.damage().coordinates(), [0, 0, 16_384, 16_384]);
        }
    }

    fn test_scope(index: usize, viewport: Rect) -> Common {
        Common {
            map: Mapping {
                inverse: [index as f64 + 2.0, -0.0, -0.0, 1.0, 0.0, 0.0],
            },
            clip: viewport,
            color: [0.0, 0.0, 0.0, 1.0],
        }
    }

    #[test]
    fn repeated_last_scope_after_discovery_prefix_needs_no_more_rows_or_allocations() {
        let viewport = Rect::new(0.0, 0.0, 128.0, 128.0);
        let mut columns = Columns::default();
        for index in 0..=DISCOVERY {
            let common = test_scope(index, viewport);
            columns.admit(common, viewport, None, false, false).unwrap();
            assert_eq!(columns.scope(common, viewport).0, index as u32 + 1);
        }
        let repeated = test_scope(DISCOVERY, viewport);
        let count = allocation_counter::measure(|| {
            for _ in 0..4096 {
                columns
                    .admit(repeated, viewport, None, false, false)
                    .unwrap();
                assert_eq!(columns.scope(repeated, viewport).0, DISCOVERY as u32 + 1);
            }
        });
        assert_eq!(columns.scopes.len(), DISCOVERY + 1);
        assert_eq!((count.count_total, count.bytes_total), (0, 0));

        // The shortcut preserves exact inverse and clip bits.
        let mut different = repeated;
        different.map.inverse[1] = 0.0;
        columns
            .admit(different, viewport, None, false, false)
            .unwrap();
        assert_ne!(columns.scope(different, viewport).0, DISCOVERY as u32 + 1);
    }

    #[test]
    fn alternating_late_scopes_disclose_bounded_discovery_fallback_growth() {
        let viewport = Rect::new(0.0, 0.0, 128.0, 128.0);
        let mut columns = Columns::default();
        for index in 0..DISCOVERY + 2 {
            let common = test_scope(index, viewport);
            columns.admit(common, viewport, None, false, false).unwrap();
            columns.scope(common, viewport);
        }
        let count = allocation_counter::measure(|| {
            for index in 0..128 {
                let common = test_scope(DISCOVERY + index % 2, viewport);
                columns.admit(common, viewport, None, false, false).unwrap();
                columns.scope(common, viewport);
            }
        });
        // Neither alternating scope is in the prefix or equal to the last row.
        assert_eq!(columns.scopes.len(), DISCOVERY + 2 + 128);
        assert!(count.count_total > 0);
        assert!(count.bytes_total >= columns.scopes.capacity() as u64 * size_of::<Scope>() as u64);
        eprintln!(
            "scope_late_alternating,rows={},capacity={},allocations={},requested={}",
            columns.scopes.len(),
            columns.scopes.capacity(),
            count.count_total,
            count.bytes_total
        );
    }

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
