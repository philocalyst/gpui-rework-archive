//! Complete-C working-color updates, separate from mutable logical colors.
use super::*;
#[derive(Clone, Copy, PartialEq, Eq)]
pub(super) enum PatchOutcome {
    Visual,
    Metadata,
    Complete,
}
/// One bounded same-slot chain, not an accumulated change log. Both endpoints
/// certify the positional edit; unsupported changes retain full preparation.
#[cfg(any(feature = "native-core", test))]
#[cfg_attr(not(feature = "native-core"), allow(dead_code))]
#[derive(Clone, Copy)]
pub(crate) struct SlotTransition {
    pub(crate) from: PresentationToken,
    pub(super) through: NonZeroU64,
    pub(crate) edits: [gpui_canvas::SlotEdit; 1],
}
#[cfg(feature = "native-core")]
impl SlotTransition {
    pub(crate) fn connects(&self, from: Option<PresentationToken>, to: PresentationToken) -> bool {
        from == Some(self.from) && to.window == self.from.window && to.sequence == self.through
    }
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
            token,
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
pub(crate) struct TextRepair {
    pub(crate) from: PresentationToken,
    pub(crate) to: PresentationToken,
    pub(crate) regions: gpui_canvas::DamageRegions,
}

#[cfg(feature = "native-core")]
pub(crate) struct ScrollTransition {
    pub(crate) from: PresentationToken,
    pub(crate) to: PresentationToken,
    pub(crate) copy: gpui_canvas::ScrollCopy,
}

/// Damage relative to the exact acknowledged image, including unbound changes.
#[cfg(feature = "native-core")]
#[derive(Clone, Copy)]
pub(crate) struct SceneDamage<'a> {
    pub(crate) base: Option<PresentationToken>,
    pub(crate) region: gpui_canvas::DamageRegion,
    pub(crate) repair: Option<&'a TextRepair>,
    pub(crate) scroll: Option<&'a ScrollTransition>,
}

#[cfg(feature = "native-core")]
impl<M: View + 'static, L: LaneSet<M>> Win<M, L> {
    pub(crate) fn with_paint_scene<R>(
        &self,
        read: impl FnOnce(
            gpui_canvas::PreparedScene<'_>,
            PresentationToken,
            Option<&SlotTransition>,
            SceneDamage<'_>,
        ) -> R,
    ) -> Result<R, Error> {
        let runtime = self.runtime()?;
        runtime.live()?;
        let token = runtime.latest_token.ok_or(Error::NoPreparedScene)?;
        Ok(read(
            runtime.canvas.prepared_scene(),
            token,
            runtime.styles.slot_transition(),
            SceneDamage {
                scroll: runtime
                    .metadata
                    .as_ref()
                    .and_then(|metadata| metadata.scroll_copy.as_deref())
                    .filter(|scroll| scroll.to == token),
                repair: runtime
                    .text
                    .as_ref()
                    .and_then(|text| text.patch.as_ref())
                    .filter(|patch| patch.content.is_some())
                    .map(|patch| &patch.repair)
                    .filter(|repair| repair.to == token),
                base: (!runtime.automatic_presentation && runtime.presentation_valid)
                    .then_some(runtime.presented_sequence)
                    .flatten()
                    .map(|sequence| PresentationToken {
                        window: runtime.sites.namespace(),
                        sequence,
                    }),
                region: runtime
                    .prepared
                    .as_ref()
                    .map_or(Default::default(), |p| p.damage),
            },
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

#[cfg(all(test, feature = "native-core"))]
mod chain_tests {
    use super::*;
    use crate::prelude::*;
    struct Pair {
        a: Signal<Color>,
        b: Signal<Color>,
        shift: Signal<Affine>,
        swapped: bool,
    }
    impl Pair {
        const A: Source<Self, Color> = Source::new(FieldId::new(1), "a", |m| &m.a, |m| &mut m.a);
        const B: Source<Self, Color> = Source::new(FieldId::new(2), "b", |m| &m.b, |m| &mut m.b);
        const SHIFT: Source<Self, Affine> =
            Source::new(FieldId::new(3), "shift", |m| &m.shift, |m| &mut m.shift);
    }
    impl View for Pair {
        fn sources() -> Sources<Self> {
            Sources::new()
                .direct(Self::A)
                .direct(Self::B)
                .direct(Self::SHIFT)
        }
        fn view(&self) -> El<'_> {
            let a = div().size(16).bg(&self.a);
            let b = div().size(16).bg(&self.b);
            column(if self.swapped { (b, a) } else { (a, b) })
                .size(64)
                .transform(&self.shift)
        }
    }
    fn mount() -> Win<Pair> {
        Win::recording(
            Pair {
                a: Signal::new(Color::BLACK),
                b: Signal::new(Color::WHITE),
                shift: Signal::new(Affine::IDENTITY),
                swapped: false,
            },
            WindowOptions {
                size: [64, 64],
                ..Default::default()
            },
        )
        .unwrap()
    }
    fn token(win: &Win<Pair>) -> PresentationToken {
        win.with_scene(|_, t| t).unwrap()
    }
    fn chain(win: &Win<Pair>) -> Option<SlotTransition> {
        win.runtime().unwrap().styles.slot_transition().copied()
    }
    #[test]
    fn bounded_chain_preserves_exact_endpoints_and_acknowledgement() {
        let mut win = mount();
        let base = token(&win);
        win.presented(base).unwrap();
        win.set(Pair::A, Color::WHITE).unwrap();
        let middle = token(&win);
        assert!(chain(&win).unwrap().connects(Some(base), middle));
        win.set(Pair::A, Color::BLACK).unwrap();
        let latest = token(&win);
        assert!(chain(&win).unwrap().connects(Some(base), latest));
        assert!(!chain(&win).unwrap().connects(Some(middle), latest));
        assert!(matches!(
            win.presented(middle),
            Err(Error::StalePresentation)
        ));
        assert!(chain(&win).unwrap().connects(Some(base), latest));
        let allocation = allocation_counter::measure(|| {
            for i in 0..1000 {
                win.set(
                    Pair::A,
                    if i % 2 == 0 {
                        Color::WHITE
                    } else {
                        Color::BLACK
                    },
                )
                .unwrap();
            }
        });
        assert_eq!(allocation.count_total, 0);
        assert!(chain(&win).unwrap().connects(Some(base), token(&win)));
        eprintln!(
            "chain_header_bytes={},long_chain_allocations={},long_chain_retained_bytes={}",
            size_of::<SlotTransition>(),
            allocation.count_total,
            allocation.bytes_current
        );
        win.presented(token(&win)).unwrap();
        assert!(chain(&win).is_none());
        let base = token(&win);
        win.set(Pair::A, Color::WHITE).unwrap();
        assert!(chain(&win).unwrap().connects(Some(base), token(&win)));
    }
    #[test]
    fn chain_rejects_distinct_slots_geometry_replacement_and_failed_preparation() {
        let mut win = mount();
        let base = token(&win);
        win.presented(base).unwrap();
        win.set(Pair::A, Color::WHITE).unwrap();
        win.set(Pair::B, Color::BLACK).unwrap();
        assert!(!chain(&win).unwrap().connects(Some(base), token(&win)));
        win.set(Pair::SHIFT, Affine::translation(8., 0.)).unwrap();
        assert!(chain(&win).is_none());
        win.set(Pair::A, Color::BLACK).unwrap();
        assert!(!chain(&win).unwrap().connects(Some(base), token(&win)));
        win.update(|model| model.swapped = true).unwrap();
        assert!(chain(&win).is_none());
        win.set(Pair::A, Color::WHITE).unwrap();
        let eligible = token(&win);
        let pixels = win.with_pixels(|p, _, _| p.to_vec()).unwrap();
        assert!(matches!(
            win.set(Pair::SHIFT, Affine::translation(f32::NAN, 0.)),
            Err(crate::SetError::Committed { .. })
        ));
        assert_eq!(token(&win), eligible);
        assert!(chain(&win).is_none());
        assert_eq!(win.with_pixels(|p, _, _| p.to_vec()).unwrap(), pixels);
        win.presented(eligible).unwrap();
    }
    #[test]
    fn chain_cannot_extend_a_missing_tail_or_foreign_namespace() {
        for foreign in [false, true] {
            let mut win = mount();
            let base = token(&win);
            win.presented(base).unwrap();
            win.set(Pair::A, Color::WHITE).unwrap();
            let immediate = token(&win);
            let other = mount();
            let foreign_token = token(&other);
            let mut runtime = win.runtime_mut().unwrap();
            let styles::Styles::Colors(values) = &mut runtime.styles else {
                panic!("bound styles")
            };
            let summary = values.transition.as_mut().unwrap();
            if foreign {
                summary.from = foreign_token;
            } else {
                summary.through = base.sequence;
            }
            drop(runtime);
            win.set(Pair::A, Color::BLACK).unwrap();
            let summary = chain(&win).unwrap();
            assert_eq!(summary.from, immediate);
            assert!(!summary.connects(Some(base), token(&win)));
            assert!(!summary.connects(Some(foreign_token), token(&win)));
        }
    }
}
