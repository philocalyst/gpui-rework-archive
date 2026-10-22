//! Active-only positional bindings to the latest complete Canvas. Indices are
//! never semantic authority: complete-epoch admission precedes every use.
use super::*;
use crate::property::PropertyId;
use gpui_canvas::{PaintEdit, PaintIndex};

#[derive(Clone, Copy)]
struct Field {
    id: FieldId,
    start: u32,
    len: u32,
}
#[derive(Clone, Copy)]
struct Sink {
    destination: Destination,
    cursor: u32,
}
// At most one final FG and BG binding per admitted node.
const _: () = assert!(MAX_NODES <= (u32::MAX as usize) / 2);
const ABSENT: u32 = u32::MAX;
#[derive(Default)]
pub(crate) struct PaintState {
    fields: Vec<Field>,
    sinks: Vec<Sink>,
    pub(crate) edits: Vec<PaintEdit>,
    scratch: Vec<PaintEdit>,
    pub(crate) from: Option<PresentationToken>,
}
pub(super) struct Build {
    state: Box<PaintState>,
    capture: Vec<(Destination, u32)>,
    next: usize,
}
impl Build {
    pub(super) fn new(fanout: &BTreeMap<FieldId, Fanout>) -> Option<Self> {
        let eligible = |fanout: &&Fanout| {
            !fanout.destinations.is_empty()
                && fanout.destinations.iter().all(|d| {
                    matches!(
                        d.property(),
                        Some(PropertyId::Foreground | PropertyId::Background)
                    )
                })
        };
        let fields = fanout.values().filter(eligible).count();
        if fields == 0 {
            return None;
        }
        let sinks = fanout
            .values()
            .filter(eligible)
            .map(|f| f.destinations.len())
            .sum();
        let mut state = Box::new(PaintState {
            fields: Vec::with_capacity(fields),
            sinks: Vec::with_capacity(sinks),
            ..PaintState::default()
        });
        for (&id, fanout) in fanout {
            if fanout.destinations.is_empty()
                || !fanout.destinations.iter().all(|d| {
                    matches!(
                        d.property(),
                        Some(PropertyId::Foreground | PropertyId::Background)
                    )
                })
            {
                continue;
            }
            let start = state.sinks.len() as u32;
            state
                .sinks
                .extend(fanout.destinations.iter().map(|&destination| Sink {
                    destination,
                    cursor: ABSENT,
                }));
            state.fields.push(Field {
                id,
                start,
                len: state.sinks.len() as u32 - start,
            });
        }
        if state.fields.is_empty() {
            return None;
        }
        let mut capture: Vec<_> = state
            .sinks
            .iter()
            .enumerate()
            .map(|(i, s)| (s.destination, i as u32))
            .collect();
        capture.sort_unstable_by_key(|entry| entry.0.packed());
        Some(Self {
            state,
            capture,
            next: 0,
        })
    }
    pub(super) fn capture(
        &mut self,
        node: usize,
        background: Option<PaintIndex>,
        foreground: Option<PaintIndex>,
    ) {
        while let Some(&(destination, slot)) = self.capture.get(self.next) {
            if destination.node() != node {
                break;
            }
            let index = if destination.property() == Some(PropertyId::Background) {
                background
            } else {
                foreground
            };
            self.state.sinks[slot as usize].cursor = index.map_or(ABSENT, PaintIndex::order);
            self.next += 1;
        }
    }
    pub(super) fn finish(self) -> Box<PaintState> {
        self.state
    }
}
impl PaintState {
    fn field(&self, id: FieldId) -> Option<Field> {
        self.fields
            .binary_search_by_key(&id, |entry| entry.id)
            .ok()
            .map(|i| self.fields[i])
    }
    pub(super) fn begin(&mut self, id: FieldId) -> Option<Plan> {
        let field = self.field(id)?;
        let mut edits = std::mem::take(&mut self.scratch);
        edits.clear();
        if edits.capacity() > (field.len as usize).saturating_mul(4) {
            edits = Vec::new();
        }
        edits.reserve_exact(field.len as usize);
        Some(Plan {
            edits,
            start: field.start,
            len: field.len,
        })
    }
    #[inline]
    pub(super) fn index(&self, plan: &Plan, offset: usize) -> Option<u32> {
        (offset < plan.len as usize).then(|| self.sinks[plan.start as usize + offset].cursor)
    }
    #[cfg(feature = "native")]
    pub(crate) fn requested<'a>(
        &'a self,
        scene: gpui_canvas::PreparedScene<'a>,
    ) -> impl Iterator<Item = PaintIndex> + 'a {
        self.sinks
            .iter()
            .filter_map(move |sink| scene.paint_index(sink.cursor))
    }
}
pub(super) struct Plan {
    pub(super) edits: Vec<PaintEdit>,
    start: u32,
    len: u32,
}
#[derive(Clone, Copy, PartialEq, Eq)]
pub(super) enum PatchOutcome {
    Visual,
    Metadata,
    Complete,
}
impl<M: View + 'static> Runtime<M> {
    #[cfg(any(feature = "native", test))]
    pub(super) fn paint_state(&self) -> Option<&PaintState> {
        self.metadata.as_deref()?.paint.as_deref()
    }
    pub(super) fn paint_begin(&mut self, field: FieldId) -> Option<Plan> {
        if self.dirty || self.complete_epoch.checked_add(1) != Some(self.source_epoch) {
            return None;
        }
        self.metadata.as_mut()?.paint.as_mut()?.begin(field)
    }
    pub(super) fn paint_finish(
        &mut self,
        plan: Plan,
        eligible: bool,
        changed: bool,
    ) -> Result<bool, Error> {
        let mut edits = plan.edits;
        let state = self
            .metadata
            .as_mut()
            .and_then(|m| m.paint.as_mut())
            .expect("active paint state");
        if !eligible {
            edits.clear();
            state.scratch = edits;
            return Ok(false);
        }
        if !changed {
            edits.clear();
            state.scratch = edits;
            self.complete_epoch = self.source_epoch;
            if self.prepared.is_none() && self.presentation_valid {
                #[cfg(feature = "accessibility")]
                let base = self.semantic_stamp();
                self.presentation_epoch = self.source_epoch;
                #[cfg(feature = "accessibility")]
                {
                    let target = self.semantic_stamp();
                    if let Some(observer) = &mut self.accessibility {
                        observer.relabel(base, target);
                        observer.acknowledge(target);
                    }
                }
            }
            return Ok(true);
        }
        // Destinations are node-major, with at most one FG and BG each.
        // Canvas emits BG then FG: only those adjacent pairs can be reversed.
        for i in 1..edits.len() {
            if edits[i - 1].index() > edits[i].index() {
                edits.swap(i - 1, i);
            }
        }
        debug_assert!(
            edits
                .windows(2)
                .all(|pair| pair[0].index() < pair[1].index())
        );
        let sequence = self.next_presentation;
        let next = sequence.checked_add(1).ok_or(Error::EpochExhausted)?;
        let token = PresentationToken {
            window: self.sites.namespace(),
            sequence,
        };
        let Ok(plan) = self.canvas.prepare_paint(&edits) else {
            edits.clear();
            state.scratch = edits;
            return Ok(false);
        };
        let damage = plan.commit();
        state.from = self.latest_token;
        std::mem::swap(&mut state.edits, &mut edits);
        edits.clear();
        state.scratch = edits;
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
                    accessibility::Stamp {
                        sequence: Some(sequence),
                        epoch: self.source_epoch,
                        size: self.requested_size,
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

#[cfg(feature = "native")]
impl<M: View + 'static, L: LaneSet<M>> Win<M, L> {
    pub(crate) fn with_paint_scene<R>(
        &self,
        read: impl FnOnce(gpui_canvas::PreparedScene<'_>, PresentationToken, Option<&PaintState>) -> R,
    ) -> Result<R, Error> {
        let runtime = self.runtime()?;
        runtime.live()?;
        let token = runtime.latest_token.ok_or(Error::NoPreparedScene)?;
        Ok(read(
            runtime.canvas.prepared_scene(),
            token,
            runtime.paint_state(),
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
            "paint_headers,Node={},Presented={},Runtime={},Fanout={},Metadata={},State={},Field={},Sink={},Prepared={}",
            size_of::<Node>(),
            size_of::<Presented>(),
            size_of::<Runtime<()>>(),
            size_of::<Fanout>(),
            size_of::<Metadata>(),
            size_of::<PaintState>(),
            size_of::<Field>(),
            size_of::<Sink>(),
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
                let state = win.runtime().unwrap().paint_state().unwrap();
                assert_eq!((state.fields.capacity(), state.sinks.capacity()), (1, 1));
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
