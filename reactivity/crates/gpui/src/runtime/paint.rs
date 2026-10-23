//! Complete-C working-color updates, separate from mutable logical colors.
use super::*;
#[derive(Clone, Copy, PartialEq, Eq)]
pub(super) enum PatchOutcome {
    Visual,
    Metadata,
    Complete,
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
    pub(super) fn finish_color_slot(
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
    fn publish_paint(
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
                nodes: rows::CandidateRows::empty(),
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
    pub(super) fn rows<'a>(&'a self, acknowledged: &'a [Presented]) -> rows::Rows<'a> {
        if self.keeps_rows() {
            rows::Rows::from(acknowledged)
        } else {
            self.nodes.view(acknowledged)
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
    use crate::Signal;
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
