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
    change: Option<styles::ColorChange>,
    fallback_dirty: bool,
}
impl PaintIntent {
    pub(super) fn new(change: Option<styles::ColorChange>, fallback_dirty: bool) -> Self {
        Self { change, fallback_dirty }
    }
}
/// Exactly one transition, never an accumulated change log. A coalesced native
/// packet that does not match from rebuilds from the latest complete C bank.
#[cfg(any(feature = "native-core", test))]
#[cfg_attr(not(feature = "native-core"), allow(dead_code))]
pub(crate) struct SlotTransition {
    pub(crate) from: PresentationToken,
    pub(crate) edits: [gpui_canvas::SlotEdit; 1],
}
impl<M: View + 'static> Runtime<M> {
    pub(super) fn publish_paint_intent(&mut self, intent: PaintIntent) -> Result<bool, Error> {
        self.dirty |= intent.fallback_dirty;
        let complete = self.finish_color_slot(intent.change.as_ref())?;
        if complete {
            // publish_paint(None) intentionally preserves caller dirty state;
            // this admitted paint-only outcome is the owner of that state.
            self.dirty = false;
        }
        Ok(complete)
    }
    fn finish_color_slot(
        &mut self,
        change: Option<&styles::ColorChange>,
    ) -> Result<bool, Error> {
        use gpui_canvas::SlotEdit;
        let Some(change) = change else {
            self.publish_paint(None)?;
            return Ok(true);
        };
        if change.users == 0
            || change.previous.working().map(f32::to_bits)
                == change.value.working().map(f32::to_bits)
        {
            self.publish_paint(None)?;
            return Ok(true);
        }
        if change.previous.working()[3].to_bits() != change.value.working()[3].to_bits() {
            return Ok(false);
        }
        let Some(slot) = change.canvas else {
            // No command from this relationship survived complete preparation.
            // Equal alpha preserves that geometric/material absence.
            self.publish_paint(None)?;
            return Ok(true);
        };
        let sequence = self.next_presentation;
        let next = sequence.checked_add(1).ok_or(Error::EpochExhausted)?;
        let token = PresentationToken {
            window: self.sites.namespace(),
            sequence,
        };
        let edits = [SlotEdit::new(slot, change.value)];
        let Ok(plan) = self.canvas.prepare_slots(&edits) else {
            return Ok(false);
        };
        let damage = plan.commit();
        #[cfg(feature = "native-core")]
        self.styles.record_slot_transition(
            self.latest_token.expect("complete predecessor has a token"),
            edits[0],
        );
        self.publish_paint(Some((damage, token, next)))?;
        Ok(true)
    }
    pub(super) fn publish_paint(
        &mut self,
        change: Option<(gpui_canvas::DamageRegion, PresentationToken, NonZeroU64)>,
    ) -> Result<(), Error> {
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
            return Ok(());
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
        Ok(())
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
}
