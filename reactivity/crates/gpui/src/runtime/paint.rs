//! Complete-C working-color updates, separate from mutable logical colors.
use super::*;
pub(super) enum PatchOutcome {
    Visual,
    Metadata,
    /// Equal exact operands; publication waits for the turn's editing guards.
    Unchanged,
    Paint(PaintIntent),
}
/// Logical color admission only. No Canvas command, token, complete coverage or
/// acknowledgement changes until the owning turn consumes this after its
/// editing/IME/inspector guards. The fallback remains dirty even if token or
/// slot admission fails, so settle cannot certify an unprepared source epoch.
pub(super) struct PaintIntent {
    edits: PaintEdits,
    requires_full: bool,
    fallback_dirty: bool,
}
impl PaintIntent {
    pub(super) fn new(change: Option<styles::ColorChange>, fallback_dirty: bool) -> Self {
        let mut intent = Self { edits: PaintEdits::Empty, requires_full: false, fallback_dirty };
        if let Some(change) = change {
            intent.include(change);
        }
        intent
    }
    pub(super) fn include(&mut self, change: styles::ColorChange) {
        if change.users == 0 {
            return;
        }
        self.fallback_dirty = true;
        if self.requires_full {
            return;
        }
        if change.previous.working().map(f32::to_bits)
            == change.value.working().map(f32::to_bits)
        {
            return;
        }
        if change.previous.working()[3].to_bits() != change.value.working()[3].to_bits() {
            self.requires_full = true;
            self.edits = PaintEdits::Empty;
            return;
        }
        if let Some(slot) = change.canvas {
            self.edits.push(gpui_canvas::SlotEdit::new(slot, change.value));
        }
        // An absent complete command stays absent for equal-alpha color only.
    }
}
/// One source operation owns one finite edit set, not a cross-turn change log.
/// Preserve the allocation-free zero/one case; only genuinely multi-slot
/// changes allocate a vector proportional to the changed slot frontier.
#[derive(Default)]
pub(super) enum PaintEdits {
    #[default]
    Empty,
    One(gpui_canvas::SlotEdit),
    Many(Vec<gpui_canvas::SlotEdit>),
}
impl PaintEdits {
    fn push(&mut self, edit: gpui_canvas::SlotEdit) {
        match self {
            Self::Empty => *self = Self::One(edit),
            Self::One(previous) => *self = Self::Many(vec![*previous, edit]),
            Self::Many(edits) => edits.push(edit),
        }
    }
    fn as_slice(&self) -> &[gpui_canvas::SlotEdit] {
        match self {
            Self::Empty => &[],
            Self::One(edit) => std::slice::from_ref(edit),
            Self::Many(edits) => edits,
        }
    }
    fn order(&mut self) -> bool {
        if let Self::Many(edits) = self {
            edits.sort_unstable_by_key(|edit| edit.slot());
            // Distinct source relationships should have distinct Canvas slots.
            // Do not silently resolve a conflicting alias by choosing a value.
            return edits.windows(2).all(|pair| pair[0].slot() < pair[1].slot());
        }
        true
    }
}
/// Exactly one transition, never an accumulated change log. A coalesced native
/// packet that does not match from rebuilds from the latest complete C bank.
#[cfg(any(feature = "native-core", test))]
#[cfg_attr(not(feature = "native-core"), allow(dead_code))]
pub(crate) struct SlotTransition {
    pub(crate) from: PresentationToken,
    pub(super) edits: PaintEdits,
}
#[cfg(feature = "native-core")]
impl SlotTransition {
    pub(crate) fn edits(&self) -> &[gpui_canvas::SlotEdit] {
        self.edits.as_slice()
    }
    #[cfg(test)]
    pub(crate) fn retained_edit_capacity(&self) -> usize {
        match &self.edits {
            PaintEdits::Empty | PaintEdits::One(_) => 0,
            PaintEdits::Many(edits) => edits.capacity(),
        }
    }
}
impl<M: View + 'static> Runtime<M> {
    pub(super) fn publish_paint_intent(&mut self, mut intent: PaintIntent) -> Result<bool, Error> {
        self.dirty |= intent.fallback_dirty;
        if intent.requires_full || !intent.edits.order() {
            return Ok(false);
        }
        let complete = self.finish_color_slots(intent.edits)?;
        if complete {
            // publish_paint(None) intentionally preserves caller dirty state;
            // this admitted paint-only outcome is the owner of that state.
            self.dirty = false;
        }
        Ok(complete)
    }
    fn finish_color_slots(
        &mut self,
        edits: PaintEdits,
    ) -> Result<bool, Error> {
        if edits.as_slice().is_empty() {
            return self.publish_paint(None);
        }
        let sequence = self.next_presentation;
        let next = sequence.checked_add(1).ok_or(Error::EpochExhausted)?;
        let token = PresentationToken {
            window: self.sites.namespace(),
            sequence,
        };
        let stamp = self.change_stamp()?;
        let Ok(plan) = self.canvas.prepare_slots(edits.as_slice()) else {
            return Ok(false);
        };
        {
            let Ok(witness) = plan.prepared_mutation() else { return Ok(false); };
            if Some(witness.base()) != self.changes.base() { return Ok(false); }
            // These owners come from the SAME checked Canvas bank/actual changed
            // slots, never caller Paint annotations or source fanout guesses.
            for slot in witness.changed_slots() {
                let Some(users) = witness.actual_users(slot) else { return Ok(false); };
                for site in users {
                    self.changes.record(change_model::Change { site, facets: change_model::Facets::one(change_model::Facet::Paint),
                        scope: change_model::Scope::Site, before: change_model::Support::Pending, after: change_model::Support::Pending });
                }
            }
        }
        let closed = changes::take_or_close(&mut self.pending_closure, &self.dependencies, self.pending_dependencies.as_ref(), &self.changes);
        let pending = self.changes.prepare(stamp).map_err(Error::ChangeProtocol)?.with_closed(closed).map_err(Error::ChangeProtocol)?;
        let publication = self.sites.issuer_mut().prepare(stamp).map_err(Error::ChangeView)?;
        let damage = match plan.commit_publication(pending, publication) {
            Ok(damage) => damage,
            Err(gpui_canvas::PublicationError::IncompleteChanges
                | gpui_canvas::PublicationError::NonPaintMutation
                | gpui_canvas::PublicationError::UncoveredPaint
                | gpui_canvas::PublicationError::Allocation) => return Ok(false),
            Err(error) => return Err(Error::Publication(error)),
        };
        self.dependencies.rebase(stamp.to);
        #[cfg(feature = "native-core")]
        self.styles.record_slot_transition(
            self.latest_token.expect("complete predecessor has a token"),
            edits,
        );
        self.publish_paint(Some((damage, token, next)))?;
        Ok(true)
    }
    pub(super) fn publish_paint(
        &mut self,
        change: Option<(gpui_canvas::DamageRegion, PresentationToken, NonZeroU64)>,
    ) -> Result<bool, Error> {
        #[cfg(feature = "accessibility")]
        let previous = accessibility::Stamp {
            sequence: self.latest_token.map(|token| token.sequence),
            epoch: self.complete_epoch,
            size: self.prepared.as_ref().map_or(
                [self.canvas.width(), self.canvas.height()],
                Prepared::dimensions,
            ),
        };
        let Some((damage, token, next)) = change else {
            if self.complete_epoch != self.source_epoch && !self.bind_non_graphical_change()? { return Ok(false); }
            #[cfg(feature = "accessibility")]
            let base = self.semantic_stamp();
            let acknowledged = self.prepared.is_none() && self.presentation_valid;
            self.complete_epoch = self.source_epoch;
            if acknowledged {
                self.presentation_epoch = self.source_epoch;
            }
            #[cfg(feature = "accessibility")]
            {
                let target = accessibility::Stamp {
                    epoch: self.source_epoch,
                    ..previous
                };
                if let Some(observer) = &mut self.accessibility {
                    observer.relabel(base, previous, target);
                    if acknowledged {
                        observer.acknowledge(target);
                    }
                }
            }
            return Ok(true);
        };
        #[cfg(feature = "accessibility")]
        let sequence = token.sequence;
        if let Some(prepared) = &mut self.prepared {
            prepared.damage = prepared.damage.union(damage);
        } else {
            self.prepared = Some(Prepared {
                size: [
                    (self.presentation_size[0] as u16) | Prepared::KEEP,
                    self.presentation_size[1] as u16,
                ],
                scale_factor: self.presentation_scale_factor,
                nodes: Vec::new(),
                damage,
            });
        }
        #[cfg(feature = "accessibility")]
        {
            let base = self.semantic_stamp();
            if let Some(observer) = &mut self.accessibility {
                observer.relabel(
                    base,
                    previous,
                    accessibility::Stamp {
                        sequence: Some(sequence),
                        epoch: self.source_epoch,
                        size: previous.size,
                    },
                );
            }
        }
        self.latest_token = Some(token);
        self.next_presentation = next;
        self.complete_epoch = self.source_epoch;
        self.dirty = false;
        if self.automatic_presentation {
            self.acknowledge(token)?;
        }
        Ok(true)
    }
}

impl Prepared {
    const KEEP: u16 = 1 << 15;
    pub(super) fn keeps_rows(&self) -> bool {
        self.size[0] & Self::KEEP != 0
    }
    pub(super) fn dimensions(&self) -> [u32; 2] {
        [
            u32::from(self.size[0] & !Self::KEEP),
            u32::from(self.size[1]),
        ]
    }
    pub(super) fn rows<'a>(&'a self, acknowledged: &'a [Presented]) -> &'a [Presented] {
        if self.keeps_rows() {
            acknowledged
        } else {
            &self.nodes
        }
    }
}

#[cfg(feature = "native-core")]
impl<M: View + 'static, L: LaneSet<M>> Win<M, L> {
    pub(crate) fn with_paint_scene<R>(
        &self,
        read: impl FnOnce(
            gpui_canvas::PreparedScene<'_>,
            PresentationToken,
            Option<&SlotTransition>,
        ) -> R,
    ) -> Result<R, Error> {
        let runtime = self.runtime()?;
        runtime.live()?;
        let token = runtime.latest_token.ok_or(Error::NoPreparedScene)?;
        Ok(read(
            runtime.canvas.prepared_scene(),
            token,
            runtime.styles.slot_transition(),
        ))
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::{Signal, SignalMap};
    #[test]
    fn paint_admission_transient_layout_ledger() {
        eprintln!(
            "PAINT_ADMISSION_BYTES outcome={} intent={} change={} edits={} transition={} result={}",
            size_of::<PatchOutcome>(), size_of::<PaintIntent>(),
            size_of::<styles::ColorChange>(), size_of::<PaintEdits>(),
            size_of::<SlotTransition>(), size_of::<Result<PatchOutcome, Error>>(),
        );
    }
    #[test]
    fn changed_slot_frontier_orders_all_rows_without_allocating_the_single_case() {
        let mut canvas = Canvas::recording(32, 32, Default::default()).unwrap();
        let color = gpui_canvas::PaintColor::new(Color::BLACK);
        let slots = [canvas.paint_slot(color).unwrap(), canvas.paint_slot(color).unwrap(), canvas.paint_slot(color).unwrap()];
        let mut edits = PaintEdits::Empty;
        let one = allocation_counter::measure(|| edits.push(gpui_canvas::SlotEdit::new(slots[2], color)));
        assert_eq!(one.count_total, 0);
        assert_eq!(edits.as_slice().len(), 1);
        edits.push(gpui_canvas::SlotEdit::new(slots[0], color));
        edits.push(gpui_canvas::SlotEdit::new(slots[1], color));
        assert!(edits.order());
        assert_eq!(edits.as_slice().iter().map(|edit| edit.slot()).collect::<Vec<_>>(), slots);
        let PaintEdits::Many(values) = &edits else { panic!("three-slot frontier owns a vector") };
        eprintln!("PAINT_FRONTIER_MANY len={} capacity={} slot_edit_bytes={}", values.len(), values.capacity(), size_of::<gpui_canvas::SlotEdit>());
        edits.push(gpui_canvas::SlotEdit::new(slots[1], color));
        assert!(!edits.order(), "ambiguous same-slot aliases must take full fallback");
    }
    #[test]
    fn alpha_revocation_drops_partial_slot_transport_without_stopping_logical_admission() {
        let mut canvas = Canvas::recording(32, 32, Default::default()).unwrap();
        let black = gpui_canvas::PaintColor::new(Color::BLACK);
        let white = gpui_canvas::PaintColor::new(Color::WHITE);
        let transparent = gpui_canvas::PaintColor::new(Color::TRANSPARENT);
        let a = canvas.paint_slot(black).unwrap();
        let b = canvas.paint_slot(black).unwrap();
        let mut intent = PaintIntent::new(None, false);
        intent.include(styles::ColorChange { users: 1, previous: black, value: white, canvas: Some(a) });
        intent.include(styles::ColorChange { users: 1, previous: black, value: white, canvas: Some(b) });
        assert_eq!(intent.edits.as_slice().len(), 2);
        intent.include(styles::ColorChange { users: 1, previous: black, value: transparent, canvas: Some(b) });
        assert!(intent.requires_full);
        assert!(intent.edits.as_slice().is_empty());
        let after = allocation_counter::measure(|| {
            for _ in 0..32 {
                intent.include(styles::ColorChange { users: 1, previous: black, value: white, canvas: Some(a) });
            }
        });
        assert_eq!(after.count_total, 0);
        assert!(intent.edits.as_slice().is_empty());
        assert!(intent.fallback_dirty);
    }
    #[test]
    fn late_invalid_changed_slot_leaves_the_entire_complete_bank_and_token_untouched() {
        let mut win = Win::recording(
            Panel { bound: true, color: Signal::new(Color::BLACK) },
            WindowOptions { size: [32, 32], ..Default::default() },
        ).unwrap();
        let before = win.with_scene(|scene, token| {
            (token, scene.paint_bank().map(|paint| (paint.value().working().map(f32::to_bits), paint.shared(), paint.rectangle())).collect::<Vec<_>>())
        }).unwrap();
        let mut foreign = Canvas::recording(32, 32, Default::default()).unwrap();
        let black = gpui_canvas::PaintColor::new(Color::BLACK);
        let mut invalid = foreign.paint_slot(black).unwrap();
        for _ in 1..8 {
            invalid = foreign.paint_slot(black).unwrap();
        }
        let mut runtime = win.runtime_mut().unwrap();
        let (_, slot) = runtime.styles.shared_paint(0, false).unwrap();
        let slot = slot.expect("bound emitted background");
        let mut edits = PaintEdits::Empty;
        edits.push(gpui_canvas::SlotEdit::new(slot, gpui_canvas::PaintColor::new(Color::WHITE)));
        edits.push(gpui_canvas::SlotEdit::new(invalid, gpui_canvas::PaintColor::new(Color::WHITE)));
        assert!(edits.order());
        assert!(!runtime.finish_color_slots(edits).unwrap());
        drop(runtime);
        let after = win.with_scene(|scene, token| {
            (token, scene.paint_bank().map(|paint| (paint.value().working().map(f32::to_bits), paint.shared(), paint.rectangle())).collect::<Vec<_>>())
        }).unwrap();
        assert_eq!(after, before);
    }
    #[cfg(feature = "native-core")]
    #[test]
    fn failed_exact_alpha_intent_preserves_the_old_owned_multi_slot_transition() {
        struct Double(Signal<Color>);
        impl Double {
            const COLOR: crate::Source<Self, Color> = crate::Source::new(
                FieldId::new(1), "color", |model| &model.0, |model| &mut model.0,
            );
        }
        impl View for Double {
            fn sources() -> Sources<Self> { Sources::new().direct(Self::COLOR) }
            fn view(&self) -> crate::El<'_> {
                crate::row((
                    crate::div().size(8).bg(self.0.map(|color| *color)),
                    crate::div().size(8).bg(self.0.map(|color| *color)),
                ))
            }
        }
        let mut win = Win::recording(
            Double(Signal::new(Color::BLACK)),
            WindowOptions { size: [32, 24], ..Default::default() },
        ).unwrap();
        let initial = win.with_scene(|_, token| token).unwrap();
        win.presented(initial).unwrap();
        win.set(Double::COLOR, Color::WHITE).unwrap();
        let witness = |win: &Win<Double>| {
            let runtime = win.runtime().unwrap();
            let state = runtime.styles.slot_transition().unwrap();
            (
                state.from,
                state.edits().iter().map(|edit| (edit.slot(), edit.value().working().map(f32::to_bits))).collect::<Vec<_>>(),
                state.retained_edit_capacity(),
            )
        };
        let old_witness = witness(&win);
        assert_eq!(old_witness.1.len(), 2);
        let bank = |win: &Win<Double>| win.with_scene(|scene, token| {
            (token, scene.paint_bank().map(|paint| (paint.value().working().map(f32::to_bits), paint.shared(), paint.rectangle())).collect::<Vec<_>>())
        }).unwrap();
        let old_bank = bank(&win);
        win.runtime_mut().unwrap().next_presentation = NonZeroU64::MAX;
        assert!(win.set(Double::COLOR, Color::TRANSPARENT).is_err());
        assert_eq!(bank(&win), old_bank);
        assert_eq!(witness(&win), old_witness);
        assert!(win.settle().is_err());
        assert!(win.set(Double::COLOR, Color::TRANSPARENT).is_err());
        assert_eq!(bank(&win), old_bank);
        assert_eq!(witness(&win), old_witness);
        let receipt = win.presented(old_bank.0).unwrap();
        assert!(receipt.presentation_epoch < receipt.source_epoch);
    }
    struct Panel {
        bound: bool,
        color: Signal<Color>,
    }
    impl Panel {
        const COLOR: crate::Source<Self, Color> =
            crate::Source::new(FieldId::new(1), "color", |m| &m.color, |m| &mut m.color);
    }
    impl View for Panel {
        fn sources() -> Sources<Self> {
            Sources::new().direct(Self::COLOR)
        }
        fn view(&self) -> crate::El<'_> {
            let el = crate::div().size(32);
            if self.bound {
                el.bg(&self.color)
            } else {
                el.bg(Color::BLACK)
            }
        }
    }
    struct Inspected { color: Signal<Color>, mapped: bool }
    impl Inspected {
        const COLOR: crate::Source<Self, Color> = crate::Source::new(
            FieldId::new(1), "color", |model| &model.color, |model| &mut model.color,
        );
    }
    impl View for Inspected {
        fn sources() -> Sources<Self> { Sources::new().direct(Self::COLOR) }
        fn view(&self) -> crate::El<'_> {
            let node = crate::div().name("color target").size(32);
            if self.mapped { node.bg(self.color.map(|color| *color)) }
            else { node.bg(&self.color) }
        }
    }
    fn acknowledge_inspected(win: &mut Win<Inspected>) {
        win.presented(win.with_scene(|_, token| token).unwrap()).unwrap();
    }
    fn inspected(mapped: bool, recording: bool) -> Win<Inspected> {
        let model = Inspected { color: Signal::new(Color::BLACK), mapped };
        let options = WindowOptions { size: [640, 480], ..Default::default() };
        let mut win = if recording { Win::recording_with_inspector(model, options) }
            else { Win::with_inspector(model, options) }.unwrap();
        if recording { acknowledge_inspected(&mut win); }
        let target = win.query().name("color target").one().unwrap();
        win.inspector_select(target).unwrap();
        if recording { acknowledge_inspected(&mut win); }
        win
    }
    fn inspected_rows(win: &Win<Inspected>) -> Vec<SnapshotNode> {
        let mut nodes = win.snapshot().unwrap().nodes;
        for node in &mut nodes { node.target = None; }
        nodes
    }
    #[test]
    fn inspector_color_admission_needs_only_one_candidate_and_preserves_failed_predecessor() {
        for mapped in [false, true] {
            let mut expected = inspected(mapped, false);
            expected.set(Inspected::COLOR, Color::WHITE).unwrap();
            let expected_pixels = expected.with_pixels(|pixels, _, _| pixels.to_vec()).unwrap();
            for sequence in [u64::MAX - 1, u64::MAX] {
                let mut win = inspected(mapped, false);
                let old_token = win.with_scene(|_, token| token).unwrap();
                let old_nodes = inspected_rows(&win);
                let old_pixels = win.with_pixels(|pixels, _, _| pixels.to_vec()).unwrap();
                win.runtime_mut().unwrap().next_presentation = NonZeroU64::new(sequence).unwrap();
                let result = win.set(Inspected::COLOR, Color::WHITE);
                if sequence == u64::MAX - 1 {
                    let commit = result.expect("one guarded source edit needs only one complete candidate");
                    assert_eq!(commit.source_epoch, commit.presentation_epoch);
                    assert_eq!(win.with_scene(|_, token| token.sequence.get()).unwrap(), sequence);
                    assert_eq!(inspected_rows(&win), inspected_rows(&expected));
                    win.with_pixels(|pixels, _, _| assert_eq!(pixels, expected_pixels)).unwrap();
                } else {
                    assert!(result.is_err());
                    assert_eq!(win.with_scene(|_, token| token).unwrap(), old_token);
                    assert_eq!(inspected_rows(&win), old_nodes);
                    win.with_pixels(|pixels, _, _| assert_eq!(pixels, old_pixels)).unwrap();
                }
            }
        }
    }
    #[test]
    fn rejected_inspector_color_keeps_distinct_pending_c_and_old_p_until_eligible_ack() {
        for mapped in [false, true] {
            let mut win = inspected(mapped, true);
            let old_p = inspected_rows(&win);
            win.set(Inspected::COLOR, Color::WHITE).unwrap();
            let eligible = win.with_scene(|_, token| token).unwrap();
            let covered = win.runtime().unwrap().complete_epoch;
            let pixels = win.with_pixels(|pixels, _, _| pixels.to_vec()).unwrap();
            assert_eq!(inspected_rows(&win), old_p);
            let mut expected = inspected(mapped, false);
            expected.set(Inspected::COLOR, Color::WHITE).unwrap();
            win.runtime_mut().unwrap().next_presentation = NonZeroU64::MAX;
            assert!(win.set(Inspected::COLOR, Color::BLACK).is_err());
            assert_eq!(win.with_scene(|_, token| token).unwrap(), eligible);
            assert_eq!(inspected_rows(&win), old_p);
            win.with_pixels(|actual, _, _| assert_eq!(actual, pixels)).unwrap();
            let commit = win.presented(eligible).unwrap();
            assert_eq!(commit.presentation_epoch, covered);
            assert!(commit.presentation_epoch < commit.source_epoch);
            assert_eq!(inspected_rows(&win), inspected_rows(&expected));
            win.with_pixels(|actual, _, _| assert_eq!(actual, pixels)).unwrap();
        }
    }
    #[test]
    fn rejected_paint_intent_keeps_retry_dirty_instead_of_covering_failed_source() {
        let mut win = Win::recording(
            Panel { bound: true, color: Signal::new(Color::BLACK) },
            WindowOptions { size: [32, 32], ..Default::default() },
        ).unwrap();
        let old = win.with_scene(|_, token| token).unwrap();
        win.presented(old).unwrap();
        let covered = win.snapshot().unwrap().presentation_epoch;
        let pixels = win.with_pixels(|pixels, _, _| pixels.to_vec()).unwrap();
        win.runtime_mut().unwrap().next_presentation = NonZeroU64::MAX;
        assert!(win.set(Panel::COLOR, Color::WHITE).is_err());
        assert!(win.settle().is_err(), "failed paint source must not be certified by an idle relabel");
        assert!(win.set(Panel::COLOR, Color::WHITE).is_err());
        assert_eq!(win.with_scene(|_, token| token).unwrap(), old);
        assert_eq!(win.snapshot().unwrap().presentation_epoch, covered);
        assert!(win.snapshot().unwrap().source_epoch > covered);
        win.with_pixels(|actual, _, _| assert_eq!(actual, pixels)).unwrap();
    }
    #[test]
    fn cold_storage_and_warm_edits_have_explicit_allocation_costs() {
        eprintln!(
            "paint_headers,Node={},Presented={},Runtime={},Fanout={},Metadata={},Transition={},Prepared={}",
            size_of::<Node>(),
            size_of::<Presented>(),
            size_of::<Runtime<()>>(),
            size_of::<Fanout>(),
            size_of::<Metadata>(),
            size_of::<SlotTransition>(),
            size_of::<Prepared>()
        );
        for bound in [false, true] {
            let mut win = None;
            let mount = allocation_counter::measure(|| {
                win = Some(
                    Win::recording(
                        Panel {
                            bound,
                            color: Signal::new(Color::BLACK),
                        },
                        WindowOptions {
                            size: [32, 32],
                            ..Default::default()
                        },
                    )
                    .unwrap(),
                );
            });
            let mut win = win.unwrap();
            if !bound {
                assert!(win.runtime().unwrap().metadata.is_none());
            } else {
                assert!(matches!(
                    win.runtime().unwrap().styles,
                    styles::Styles::Colors(_)
                ));
                assert!(win.runtime().unwrap().metadata.is_none());
                for color in [Color::WHITE, Color::BLACK] {
                    win.set(Panel::COLOR, color).unwrap();
                }
                let edit = allocation_counter::measure(|| {
                    win.set(Panel::COLOR, Color::WHITE).unwrap();
                });
                assert_eq!(edit.count_total, 0);
                eprintln!(
                    "paint_warm,allocations={},bytes={}",
                    edit.count_total, edit.bytes_total
                );
            }
            eprintln!(
                "paint_mount,bound={bound},allocations={},retained={},peak={}",
                mount.count_total, mount.bytes_current, mount.bytes_max
            );
        }
    }
    #[test]
    fn two_mapped_slots_wait_for_inspector_and_keep_last_complete_c_after_max_failure() {
        struct Guard(Signal<u32>);
        impl Guard {
            const HOVER: crate::Source<Self,u32> = crate::Source::new(
                FieldId::new(1),"hover",|m| &m.0,|m| &mut m.0,
            );
        }
        impl View for Guard {
            fn sources()->Sources<Self> { Sources::new().direct(Self::HOVER) }
            fn view(&self)->crate::El<'_> {
                crate::row((
                    crate::div().name("left").size(24).bg(self.0.map(|id|match *id%3 {
                        0=>Color::BLACK,1=>Color::rgba(255,0,0,255),_=>Color::rgba(0,0,255,255),
                    })),
                    crate::div().name("right").size(24).bg(self.0.map(|id|match *id%3 {
                        0=>Color::WHITE,1=>Color::rgba(0,255,0,255),_=>Color::rgba(255,255,0,255),
                    })),
                ))
            }
        }
        fn ack_guard(win:&mut Win<Guard>) {
            let token=win.with_scene(|_,token|token).unwrap(); win.presented(token).unwrap();
        }
        fn bank(win:&Win<Guard>)->(PresentationToken,Vec<([u32;4],bool,bool)>) {
            win.with_scene(|scene,token|(token,scene.paint_bank().map(|p|(
                p.value().working().map(f32::to_bits),p.shared(),p.rectangle(),
            )).collect())).unwrap()
        }
        let mut win=Win::recording_with_inspector(Guard(Signal::new(0)),WindowOptions {
            size:[720,640],..Default::default()
        }).unwrap();
        ack_guard(&mut win);
        let left=win.query().name("left").one().unwrap();
        win.inspector_select(left).unwrap(); ack_guard(&mut win);
        let old_p=win.snapshot().unwrap().nodes;
        win.set(Guard::HOVER,1).unwrap(); // Distinct pending C, no acknowledgement.
        let older=bank(&win);
        win.runtime_mut().unwrap().next_presentation=NonZeroU64::new(u64::MAX-1).unwrap();
        win.reset_counters().unwrap();
        win.set(Guard::HOVER,2).unwrap();
        let eligible=bank(&win);
        assert_ne!(eligible,older);
        assert_eq!(eligible.0.sequence.get(),u64::MAX-1);
        assert_eq!(win.runtime().unwrap().next_presentation.get(),u64::MAX);
        assert!(win.counters().paint_passes>0);
        assert_eq!(win.snapshot().unwrap().nodes,old_p);
        let pixels=win.with_pixels(|p,_,_|p.to_vec()).unwrap();
        assert!(win.set(Guard::HOVER,3).is_err());
        assert_eq!(bank(&win),eligible);
        assert_eq!(win.snapshot().unwrap().nodes,old_p);
        win.with_pixels(|p,_,_|assert_eq!(pixels,p)).unwrap();
        let receipt=win.presented(eligible.0).unwrap();
        assert!(receipt.presentation_epoch<receipt.source_epoch);
    }

}
