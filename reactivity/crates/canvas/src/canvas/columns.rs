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
// Device-scope rows belong to DrawGeometry, not the mutable paint bank.
#[derive(Default)]
pub(super) struct ScopeState { scopes:Vec<Scope> }
#[derive(Default)]
pub(super) struct PaintState { paints:Vec<PaintValue> }
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
impl ScopeState {
    pub(super) fn clear(&mut self) {self.scopes.clear();}
    pub(super) fn bytes(&self)->usize {self.scopes.capacity()*size_of::<Scope>()}
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
}
impl PaintState {
    pub(super) fn clear(&mut self) {
        self.paints.clear();
    }
    pub(super) fn bytes(&self) -> usize {
        self.paints.capacity() * size_of::<PaintValue>()
    }

    // Reserve before the display-list commit. Existing immutable scopes and
    // paints keep their positions until the whole canonical scene is replaced.
    pub(super) fn admit(
        &mut self,
        scopes:&mut ScopeState,
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
        let new_scope = scopes.find_scope(scope, viewport).is_none();
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
        if (new_scope && scopes.scopes.len() >= MAX_ROWS)
            || (new_paint && self.paints.len() >= MAX_ROWS)
        {
            return Err(Error::ResourceLimit);
        }
        if new_scope {
            scopes.scopes
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
    fn reserve_shared(&mut self) -> Result<(), Error> {
        if self.paints.len() >= MAX_ROWS {
            return Err(Error::ResourceLimit);
        }
        self.paints
            .try_reserve(1)
            .map_err(|_| Error::ResourceLimit)?;
        Ok(())
    }
    pub(super) fn shared(&mut self, color: PaintColor) -> Result<PaintSlot, Error> {
        self.reserve_shared()?;
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
    pub(super) fn resolve(&self, scopes:&ScopeState, common: StoredCommon, viewport: Rect, image: bool) -> Common {
        let scope = if common.scope.0 == 0 {
            implicit_scope(viewport)
        } else {
            scopes.scopes[common.scope.0 as usize - 1]
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
        scopes:&mut ScopeState,
        common: Common,
        viewport: Rect,
        shared: Option<PaintSlot>,
        image: bool,
    ) -> StoredCommon {
        let scope = scopes.scope(common, viewport);
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
    pub(super) fn changed_slots<'a>(&'a self,edits:&'a[SlotEdit])->impl Iterator<Item=PaintSlot>+'a {
        edits.iter().filter(|edit|!same_color(self.paints[edit.slot.index() as usize].value,edit.value)).map(|edit|edit.slot)
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
/// Borrowed precommit witness of the SAME checked SlotCommit. Consumers may
/// derive common resource roots, but must drop this borrow before committing.
/// It certifies physical edits/users, not complete source logical dirty closure.
pub struct PreparedSlotMutation<'plan,'canvas,'edits> {
    plan:&'plan SlotCommit<'canvas,'edits>,
    base:gpui_reactivity_core::change::SceneRevision,
    bank:gpui_reactivity_core::change::SceneRevision,
}
impl PreparedSlotMutation<'_,'_,'_> {
    pub fn base(&self)->gpui_reactivity_core::change::SceneRevision {self.base}
    pub fn bank_origin(&self)->gpui_reactivity_core::change::SceneRevision {self.bank}
    pub fn changed_slots(&self)->impl Iterator<Item=PaintSlot>+'_ {
        self.plan.canvas.commands.paint_state.changed_slots(self.plan.edits)
    }
    pub fn actual_users(&self,slot:PaintSlot)->Option<impl Iterator<Item=gpui_reactivity_core::change::SiteId>+'_> {
        super::publication::slot_users(self.plan.canvas,slot)
    }
}
impl<'canvas,'edits> SlotCommit<'canvas, 'edits> {
    /// Read ACTUAL validated edits while the exclusive plan still pins this
    /// bank. No allocation, caller-list constructor, resource mint or mutation.
    ///
    /// ```compile_fail,E0505
    /// use gpui_canvas::SlotCommit;
    /// fn no_mutation_while_borrowed(plan:SlotCommit<'_,'_>) {
    ///     let witness=plan.prepared_mutation().unwrap();
    ///     let _=plan.commit();
    ///     let _=witness.base();
    /// }
    /// ```
    pub fn prepared_mutation(&self)->Result<PreparedSlotMutation<'_,'canvas,'edits>,super::PublicationError> {
        let (base,bank)=super::publication::slot_origin(self.canvas)?;
        Ok(PreparedSlotMutation {plan:self,base,bank})
    }
    pub fn damage(&self) -> DamageRegion {
        self.damage
    }
    pub fn changed_slots(&self) -> usize {
        self.changed
    }
    pub fn commit(self) -> DamageRegion { self.commit_into().1 }
    fn commit_into(self) -> (&'canvas mut super::Canvas,DamageRegion) {
        if !self.edits.is_empty() {self.canvas.revoke_publication();}
        let revoke = self.canvas.commands.paint_state.commit(self.edits);
        if revoke && let Some(raster) = &mut self.canvas.raster {
            raster.revoke_cuts();
        }
        self.canvas.dirty |= self.changed != 0;
        (self.canvas,self.damage)
    }
    pub fn commit_publication(self,changes:gpui_reactivity_core::change::PreparedChanges<'_>,publication:gpui_reactivity_core::change::PreparedPublication<'_>)
        ->Result<DamageRegion,super::PublicationError> {
        let stamp=super::publication::check_slot_publication(self.canvas,&changes,&publication,self.edits,self.changed)?;
        let mut parts=super::publication::take_slot_groups(self.canvas);
        // The same exclusive owner/header passed preflight; no callback or
        // fallible allocation occurs between check and this infallible commit.
        parts.groups.prepare_retarget(stamp).expect("prevalidated unchanged group header").commit();
        let (canvas,damage)=self.commit_into();
        let (batch,closed)=changes.commit_with_closure();let receipt=publication.commit();
        super::publication::install(canvas,receipt,batch,closed,parts);
        Ok(damage)
    }
}
impl super::Canvas {
    /// Allocate a distinct shared working-color relationship in this scene.
    /// Equal colors deliberately receive distinct slots. Scene replacement
    /// revokes positional meanings; callers retain their own scene authority.
    pub fn paint_slot(&mut self, value: PaintColor) -> Result<PaintSlot, Error> {
        self.commands.paint_state.reserve_shared()?;
        self.revoke_publication();
        Ok(self.commands.paint_state.shared_reserved(value))
    }
    pub fn prepare_slots<'canvas, 'edits>(
        &'canvas mut self,
        edits: &'edits [SlotEdit],
    ) -> Result<SlotCommit<'canvas, 'edits>, SlotError> {
        let (damage, changed) = self.commands.paint_state.validate(edits)?;
        Ok(SlotCommit {
            canvas: self,
            edits,
            damage,
            changed,
        })
    }
    pub(super) fn slot_color(&self, slot: PaintSlot) -> Result<PaintColor, Error> {
        let reference = self
            .commands.paint_state
            .shared_ref(slot)
            .ok_or(Error::InvalidPaintSlot)?;
        Ok(self.commands.paint_state.paint(reference))
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
    pub(super) fn commit(self, columns: &mut PaintState, value: PaintColor) -> Option<PaintSlot> {
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

    fn admit_literal(columns: &mut PaintState, color: PaintColor) -> PaintRef {
        let viewport = Rect::new(0.0, 0.0, 32.0, 32.0);
        let mut common = test_scope(0, viewport);
        common.map.inverse = [1.0, -0.0, -0.0, 1.0, 0.0, 0.0];
        common.color = color.0;
        let mut scopes=ScopeState::default();
        columns.admit(&mut scopes,common, viewport, None, false, false).unwrap();
        columns.literal(color)
    }

    #[test]
    fn literal_palette_shares_exact_bits_without_aliasing_mutable_sources() {
        let color = PaintColor([0.25, 0.5, 0.75, 1.0]);
        let mut columns = PaintState::default();
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
        let mut columns = PaintState::default();
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
            let mut columns = PaintState::default();
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
        canvas.commands.paint_state.paints = vec![
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
        assert_eq!(canvas.commands.paint_state.paints.len(), MAX_ROWS);
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
        let mut columns = PaintState::default();
        let mut scopes=ScopeState::default();
        for index in 0..=DISCOVERY {
            let common = test_scope(index, viewport);
            columns.admit(&mut scopes,common, viewport, None, false, false).unwrap();
            assert_eq!(scopes.scope(common, viewport).0, index as u32 + 1);
        }
        let repeated = test_scope(DISCOVERY, viewport);
        let count = allocation_counter::measure(|| {
            for _ in 0..4096 {
                columns
                    .admit(&mut scopes,repeated, viewport, None, false, false)
                    .unwrap();
                assert_eq!(scopes.scope(repeated, viewport).0, DISCOVERY as u32 + 1);
            }
        });
        assert_eq!(scopes.scopes.len(), DISCOVERY + 1);
        assert_eq!((count.count_total, count.bytes_total), (0, 0));

        // The shortcut preserves exact inverse and clip bits.
        let mut different = repeated;
        different.map.inverse[1] = 0.0;
        columns
            .admit(&mut scopes,different, viewport, None, false, false)
            .unwrap();
        assert_ne!(scopes.scope(different, viewport).0, DISCOVERY as u32 + 1);
    }

    #[test]
    fn alternating_late_scopes_disclose_bounded_discovery_fallback_growth() {
        let viewport = Rect::new(0.0, 0.0, 128.0, 128.0);
        let mut columns = PaintState::default();
        let mut scopes=ScopeState::default();
        for index in 0..DISCOVERY + 2 {
            let common = test_scope(index, viewport);
            columns.admit(&mut scopes,common, viewport, None, false, false).unwrap();
            scopes.scope(common, viewport);
        }
        let count = allocation_counter::measure(|| {
            for index in 0..128 {
                let common = test_scope(DISCOVERY + index % 2, viewport);
                columns.admit(&mut scopes,common, viewport, None, false, false).unwrap();
                scopes.scope(common, viewport);
            }
        });
        // Neither alternating scope is in the prefix or equal to the last row.
        assert_eq!(scopes.scopes.len(), DISCOVERY + 2 + 128);
        assert!(count.count_total > 0);
        assert!(count.bytes_total >= scopes.scopes.capacity() as u64 * size_of::<Scope>() as u64);
        eprintln!(
            "scope_late_alternating,rows={},capacity={},allocations={},requested={}",
            scopes.scopes.len(),
            scopes.scopes.capacity(),
            count.count_total,
            count.bytes_total
        );
    }

    #[test]
    fn geometry_and_paint_extraction_preserves_legacy_layout_and_empty_owner_count() {
        use super::super::{DrawGeometry,DrawRef,InlineDraw,CommonGroup,MaskIndex,ImageResources,DisplayList};
        use crate::text::Raster;
        use std::sync::Arc;
        // Exact prior ownership shape, test-only and empty. Every field is
        // consumed below; this is not another production owner or history.
        #[derive(Default)]
        struct LegacyDisplayList {
            order:Vec<DrawRef>,inline:Vec<InlineDraw>,commons:Vec<CommonGroup>,
            columns:(Vec<Scope>,Vec<PaintValue>),masks:Vec<Arc<Raster>>,
            mask_index:MaskIndex,images:Option<Box<ImageResources>>,
        }
        let old=LegacyDisplayList::default();
        let headers=(old.order.capacity(),old.inline.capacity(),old.commons.capacity(),old.columns.0.capacity(),
            old.columns.1.capacity(),old.masks.capacity(),old.mask_index.capacity(),old.images.is_some());
        assert_eq!(headers,(0,0,0,0,0,0,0,false));
        println!("DRAW_OWNER_LAYOUT DisplayList={} legacy={} Geometry={} PaintState={} ScopeState={} DrawRef={}",
            size_of::<DisplayList>(),size_of::<LegacyDisplayList>(),size_of::<DrawGeometry>(),size_of::<PaintState>(),size_of::<ScopeState>(),size_of::<DrawRef>());
        assert_eq!(size_of::<DisplayList>(),size_of::<LegacyDisplayList>());
        assert_eq!(size_of::<DisplayList>(),size_of::<DrawGeometry>()+size_of::<PaintState>());
        assert_eq!(size_of::<ScopeState>(),size_of::<Vec<Scope>>());
        assert_eq!(size_of::<PaintState>(),size_of::<Vec<PaintValue>>());assert_eq!(size_of::<DrawRef>(),14);
        let empty=allocation_counter::measure(|| {let list=DisplayList::default();assert_eq!(list.len(),0);assert_eq!(list.storage().lane_bytes(),0);});
        assert_eq!((empty.count_total,empty.bytes_total),(0,0));
    }

    #[test]
    fn checked_color_changes_only_paint_state_but_literal_detachment_is_geometry_write() {
        use crate::{Affine,AlphaMode,Canvas,ColorConfig,Image,ImageProfile,ImageOptions,ImageSampling,PaintEdit,Rect};
        let mut canvas=Canvas::recording(64,32,ColorConfig::default()).unwrap();let clip=Rect::new(0.,0.,64.,32.);
        let color=PaintColor::new(Color::rgba(30,60,90,255));let slot=canvas.paint_slot(color).unwrap();
        let transform=Affine {a:1.25,d:1.25,..Affine::IDENTITY};
        canvas.fill_rect_slot(Rect::new(0.,0.,8.,8.),transform,clip,slot).unwrap();
        let literal=canvas.paint_cursor();canvas.fill_rect(Rect::new(16.,0.,8.,8.),transform,clip,Color::rgba(30,60,90,255)).unwrap();
        let index=canvas.paint_index(literal).unwrap();
        canvas.fill_rect(Rect::new(24.,0.,8.,8.),transform,clip,Color::rgba(30,60,90,255)).unwrap();
        let image=Image::rgba8(1,1,ImageProfile::Srgb,AlphaMode::Straight,vec![20,40,80,255].into_boxed_slice()).unwrap();
        canvas.draw_image_with(&image,Rect::new(40.,0.,8.,8.),Affine::IDENTITY,clip,ImageOptions {sampling:ImageSampling::Nearest,corner_radius:2.5}).unwrap();
        let image_draw=*canvas.commands.geometry.order.last().unwrap();let (image_common,_)=canvas.commands.state(image_draw);
        assert_eq!(image_common.paint.0,2.5f32.to_bits(),"image lane remains radius bits, not a bank address");
        let scopes:Vec<_>=canvas.commands.geometry.scopes.scopes.iter().map(|s|(s.inverse.map(f64::to_bits),[s.clip.x,s.clip.y,s.clip.width,s.clip.height].map(f32::to_bits))).collect();
        let order:Vec<_>=canvas.commands.geometry.order.iter().map(|d|(d.bounds,d.command,d.glyph,d.mask)).collect();
        let bindings:Vec<_>=canvas.commands.geometry.inline.iter().map(|d|d.common.paint.0).collect();
        let owners=(canvas.commands.geometry.order.as_ptr(),canvas.commands.geometry.inline.as_ptr(),canvas.commands.geometry.commons.as_ptr(),canvas.commands.geometry.masks.as_ptr());
        canvas.prepare_slots(&[SlotEdit::new(slot,PaintColor::new(Color::rgba(50,70,100,255)))]).unwrap().commit();
        assert_eq!(canvas.commands.geometry.order.iter().map(|d|(d.bounds,d.command,d.glyph,d.mask)).collect::<Vec<_>>(),order);
        assert_eq!(canvas.commands.geometry.inline.iter().map(|d|d.common.paint.0).collect::<Vec<_>>(),bindings);
        assert_eq!(canvas.commands.geometry.scopes.scopes.iter().map(|s|(s.inverse.map(f64::to_bits),[s.clip.x,s.clip.y,s.clip.width,s.clip.height].map(f32::to_bits))).collect::<Vec<_>>(),scopes);
        assert_eq!((canvas.commands.geometry.order.as_ptr(),canvas.commands.geometry.inline.as_ptr(),canvas.commands.geometry.commons.as_ptr(),canvas.commands.geometry.masks.as_ptr()),owners);
        canvas.prepare_paint(&[PaintEdit::new(index,Color::rgba(100,20,60,255))]).unwrap().commit();
        assert_ne!(canvas.commands.geometry.inline[1].common.paint.0,bindings[1],"aliased literal detaches by an explicit geometry binding write");
        assert_eq!(canvas.commands.geometry.inline[2].common.paint.0,bindings[2],"other immutable literal stays attached");
        let (image_common,_)=canvas.commands.state(image_draw);assert_eq!(image_common.paint.0,2.5f32.to_bits());
        assert_eq!(canvas.prepared_scene().draws().last().unwrap().source.corner_radius(),Some(2.5));
        let mut actual=vec![0;64*32];canvas.render_bgrx(&mut actual).unwrap();
        let mut cold=Canvas::recording(64,32,ColorConfig::default()).unwrap();
        for (x,color) in [(0.,Color::rgba(50,70,100,255)),(16.,Color::rgba(100,20,60,255)),(24.,Color::rgba(30,60,90,255))] {
            cold.fill_rect(Rect::new(x,0.,8.,8.),transform,clip,color).unwrap();
        }
        cold.draw_image_with(&image,Rect::new(40.,0.,8.,8.),Affine::IDENTITY,clip,ImageOptions {sampling:ImageSampling::Nearest,corner_radius:2.5}).unwrap();
        let mut expected=vec![0;64*32];cold.render_bgrx(&mut expected).unwrap();assert_eq!(actual,expected);
    }

    #[test]
    fn complete_bank_layout_and_plain_recording_floor_are_explicit() {
        // Preserve the historical Columns log lane as the combined scope/paint
        // header size. The separate new-layout fixture names both new types.
        eprintln!(
            "scope_bank_layout,Canvas={},DisplayList={},Columns={},Inline={},CommonGroup={},Scope={},Paint={},Stored={},Frame={},Prepared={},PreparedGroup={},Slot={},OptionSlot={},Edit={}",
            size_of::<super::super::Canvas>(),
            size_of::<super::super::DisplayList>(),
            size_of::<(ScopeState,PaintState)>(),
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
        assert_eq!(size_of::<(ScopeState,PaintState)>(), 2 * size_of::<Vec<()>>());
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
            assert!(canvas.commands.geometry.scopes.scopes.is_empty());
            assert!(canvas.commands.paint_state.paints.is_empty());
        });
        eprintln!(
            "scope_plain_recording,allocations={},requested={},peak={}",
            allocation.count_total, allocation.bytes_total, allocation.bytes_max
        );
    }
}
