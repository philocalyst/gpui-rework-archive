//! One bounded transition, never a second semantic tree. Only a native adapter
//! with an active session installs this observer; headless builds omit it.
use super::*;
use query::SemanticState;

pub(super) const MAX_CHANGED: usize = 4096;

#[derive(Clone, Copy, PartialEq, Eq)]
pub(super) struct Stamp {
    pub(super) sequence: Option<NonZeroU64>,
    pub(super) epoch: u64,
    pub(super) size: [u32; 2],
}
impl Stamp {
    fn matches(self, state: SemanticState, sites: &Sites) -> bool {
        self.sequence.map(|sequence| PresentationToken {
            window: sites.namespace(),
            sequence,
        }) == state.token
            && self.epoch == state.epoch
            && self.size == state.size
    }
}

pub(super) struct Observer {
    base: Stamp,
    target: Stamp,
    indices: Vec<u32>,
    exact: bool,
    pending: bool,
    // A field rebind can preserve every displayed byte (including the shared
    // empty string). No per-node binding history belongs in Presented. Require
    // one native full publication covering the actual source/candidate barrier.
    input_epoch: u64,
    input_sequence: u64,
}
impl Observer {
    fn new(stamp: Stamp) -> Self {
        Self {
            base: stamp,
            target: stamp,
            indices: Vec::new(),
            exact: false,
            pending: false,
            input_epoch: 0,
            input_sequence: 0,
        }
    }
    pub(super) fn begin(&mut self, base: Stamp, size: [u32; 2]) -> Collect<'_> {
        self.base = base;
        self.indices.clear();
        self.exact = false;
        self.pending = true;
        Collect {
            observer: self,
            exact: base.sequence.is_some() && base.size == size,
        }
    }
    fn delta(&self, base: SemanticState, target: SemanticState, sites: &Sites) -> Option<&[u32]> {
        (!self.pending
            && self.exact
            && base.epoch >= self.input_epoch
            && base.token.map_or(0, |token| token.sequence.get()) >= self.input_sequence
            && self.base.matches(base, sites)
            && self.target.matches(target, sites))
        .then_some(self.indices.as_slice())
    }
    pub(super) fn input_rebound(&mut self, source: u64, covered: u64, next: NonZeroU64) {
        if source > covered {
            self.input_epoch = self.input_epoch.max(source);
        } else {
            // An eligible C may already cover this same S. Only a later C can
            // contain the rebind. The ordinary presentation allocator checks
            // next+1 before preparing; exhaustion never wraps this authority.
            self.input_sequence = self.input_sequence.max(next.get());
        }
    }
    pub(super) fn acknowledge(&mut self, stamp: Stamp) {
        // Any post-prepare mutation or superseded/failed collector loses sparse
        // trust. It cannot revoke the older coherent candidate or its pixels.
        if !self.pending && self.target == stamp {
            return;
        }
        self.exact &= self.pending
            && self.target.sequence == stamp.sequence
            && self.target.epoch == stamp.epoch
            && self.target.size == stamp.size;
        self.pending = false;
        self.target = stamp;
    }
    pub(super) fn relabel(&mut self, base: Stamp, previous: Stamp, target: Stamp) {
        if self.pending && self.target == previous {
            // This collector actually described the preceding complete C.
            self.target = target;
        } else if previous == base {
            // No earlier unobserved candidate can differ from acknowledged P.
            self.begin(base, target.size).finish(target, 0, 0);
        } else {
            // Late activation (or lost collection) cannot certify C from P.
            self.base = base;
            self.target = target;
            self.indices.clear();
            self.exact = false;
            self.pending = true;
        }
    }
    pub(super) fn invalidate(&mut self) {
        self.exact = false;
        self.indices.clear();
    }
}

/// A borrowed row carries the resolver for the same immutable sheet.
#[derive(Clone, Copy)]
pub(super) struct RowView<'a> {
    pub row: &'a Presented,
    pub bases: geometry::Bases<'a>,
    pub shape: crate::property::GeometryStyle,
}
impl RowView<'_> {
    fn transform(self) -> Option<Affine> {
        self.row.transform(self.bases)
    }
}
/// Temporary call state, never retained by the observer or per node.
pub(super) struct ComparedRows<'p, 'c> {
    pub previous: Option<RowView<'p>>,
    pub next: RowView<'c>,
}

pub(super) struct Collect<'a> {
    observer: &'a mut Observer,
    exact: bool,
}
impl Collect<'_> {
    pub(super) fn mark(&mut self, index: usize) {
        if !self.exact {
            return;
        }
        if self.observer.indices.len() == MAX_CHANGED {
            self.full();
        } else {
            self.observer
                .indices
                .push(u32::try_from(index).expect("bounded P index"));
        }
    }
    pub(super) fn full(&mut self) {
        self.exact = false;
        self.observer.indices.clear();
    }
    pub(super) fn compare(
        &mut self,
        index: usize,
        rows: ComparedRows<'_, '_>,
        state: (Option<&Metadata>, Option<editing::SelectionSnapshot>),
        text: (Option<&text_geometry::Entry>, Option<&text_geometry::Entry>),
        list: Option<scroll::ViewportInfo>,
        row: Option<&ListRow>,
    ) {
        let (metadata, selection) = state;
        if !self.exact {
            return;
        }
        let Some(previous_view) = rows.previous else {
            self.full();
            return;
        };
        let previous = previous_view.row;
        let next = rows.next.row;
        if previous.identity != next.identity || previous.parent.index() != next.parent.index() {
            self.full();
            return;
        }
        let frozen = metadata.map(|m| &m.presented);
        let old_name = frozen
            .and_then(|m| m.name(previous.identity))
            .map(|s| s.value.as_deref());
        let old_description = frozen
            .and_then(|m| m.description(previous.identity))
            .and_then(|s| s.value.as_deref());
        let (new_name, new_description) =
            metadata.map_or((None, None), |m| m.effective_refs(next.identity));
        let new_name = new_name.map(|value| value.map(AsRef::as_ref));
        let new_description = new_description.map(AsRef::as_ref);
        let old_name = effective_name(previous, old_name);
        let new_name = effective_name(next, new_name);
        if synthetic(previous, old_name) != synthetic(next, new_name) {
            self.full();
            return;
        }
        let same_geometry = match text {
            (Some(old), Some(new)) => {
                std::sync::Arc::ptr_eq(&old.map, &new.map)
                    && old.origin.x.to_bits() == new.origin.x.to_bits()
                    && old.origin.y.to_bits() == new.origin.y.to_bits()
            }
            (None, None) => true,
            _ => false,
        };
        if !same_geometry
            || !previous_view.shape.same(rows.next.shape)
            || previous.kind != next.kind
            || previous.actions != next.actions
            || previous.disabled() != next.disabled()
            || previous.invalid() != next.invalid()
            || previous.text.as_deref() != next.text.as_deref()
            || metadata
                .and_then(|m| m.editing.as_ref())
                .and_then(|frozen| frozen.presented)
                .and_then(|snapshot| snapshot.selection(previous.identity))
                != selection.and_then(|snapshot| snapshot.selection(next.identity))
            || old_name != new_name
            || old_description != new_description
            || rect_bits(previous.local_rect()) != rect_bits(next.local_rect())
            || map_bits(previous_view.transform()) != map_bits(rows.next.transform())
            || frozen
                .and_then(|m| m.list(previous.identity))
                .map(|l| l.count)
                != list.and_then(scroll::ViewportInfo::list).map(|l| l.count)
            || !scroll::same_payload(frozen.map(|m| &m.viewports), previous.identity, list)
            || frozen
                .and_then(|m| m.row(previous.identity))
                .map(|r| r.index)
                != row.map(|r| r.index)
        {
            self.mark(index);
        }
    }
    pub(super) fn metadata(
        &mut self,
        index: usize,
        node: &Presented,
        old: &metadata::Sheet,
        next: (Option<Option<&SharedText>>, Option<&SharedText>),
    ) {
        if !self.exact {
            return;
        }
        let old_name = effective_name(node, old.name(node.identity).map(|s| s.value.as_deref()));
        let next_name = effective_name(node, next.0.map(|name| name.map(AsRef::as_ref)));
        if synthetic(node, old_name) != synthetic(node, next_name) {
            self.full();
            return;
        }
        if old_name != next_name
            || old
                .description(node.identity)
                .and_then(|s| s.value.as_deref())
                != next.1.map(AsRef::as_ref)
        {
            self.mark(index);
        }
    }
    pub(super) fn finish(mut self, stamp: Stamp, old_len: usize, new_len: usize) {
        if old_len != new_len {
            self.full();
        }
        self.observer.indices.sort_unstable();
        self.observer.indices.dedup();
        self.observer.target = stamp;
        self.observer.exact = self.exact;
    }
}
fn effective_name<'a>(node: &'a Presented, name: Option<Option<&'a str>>) -> Option<&'a str> {
    name.unwrap_or_else(|| {
        (node.kind != NodeKind::Input)
            .then_some(node.text.as_deref())
            .flatten()
    })
}
fn synthetic(node: &Presented, name: Option<&str>) -> u8 {
    if node.kind == NodeKind::Input && node.text.is_some() {
        1
    } else if node.kind == NodeKind::Text && name != node.text.as_deref() {
        2
    } else {
        0
    }
}
fn rect_bits(rect: Rect) -> [u32; 4] {
    [rect.x, rect.y, rect.width, rect.height].map(f32::to_bits)
}
fn map_bits(map: Option<Affine>) -> Option<[u32; 6]> {
    map.map(|m| [m.a, m.b, m.c, m.d, m.tx, m.ty].map(f32::to_bits))
}
impl<M> Runtime<M> {
    pub(super) fn semantic_stamp(&self) -> Stamp {
        Stamp {
            sequence: self.presented_sequence,
            epoch: self.presentation_epoch,
            size: self.presentation_size,
        }
    }
}
impl<M: View + 'static, L: LaneSet<M>> Win<M, L> {
    pub(crate) fn accessibility_observe(&mut self, active: bool) -> Result<(), Error> {
        let mut runtime = self.runtime_mut()?;
        if active {
            if runtime.accessibility.is_none() {
                runtime.accessibility = Some(Box::new(Observer::new(runtime.semantic_stamp())));
            }
        } else {
            runtime.accessibility = None;
        }
        Ok(())
    }
    #[cfg(test)]
    pub(crate) fn accessibility_storage(&self) -> (usize, usize, usize, usize) {
        let observer = self.runtime().unwrap().accessibility.as_ref();
        (
            std::mem::size_of::<Runtime<()>>(),
            observer.map_or(0, |_| std::mem::size_of::<Observer>()),
            observer.map_or(0, |o| o.indices.capacity() * std::mem::size_of::<u32>()),
            observer.map_or(0, |o| o.indices.len()),
        )
    }
    pub(crate) fn accessibility_delta(
        &self,
        base: SemanticState,
        target: SemanticState,
    ) -> Option<&[u32]> {
        let runtime = self.runtime().ok()?;
        if !runtime.presentation_valid
            || !base.valid
            || !target.valid
            || !runtime.semantic_stamp().matches(target, &runtime.sites)
        {
            return None;
        }
        runtime
            .accessibility
            .as_ref()?
            .delta(base, target, &runtime.sites)
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn input_authority_barrier_survives_failure_old_ack_and_same_source_rebind() {
        let sites = Sites::new();
        let stamp = |sequence, epoch| Stamp {
            sequence: NonZeroU64::new(sequence),
            epoch,
            size: [100, 100],
        };
        let state = |stamp: Stamp| SemanticState {
            token: stamp.sequence.map(|sequence| PresentationToken {
                window: sites.namespace(),
                sequence,
            }),
            epoch: stamp.epoch,
            size: stamp.size,
            valid: true,
            focus: None,
        };
        // Both source-advanced admission and source-unchanged scroll/rebuild.
        for source_advanced in [false, true] {
            let p = stamp(1, 1);
            let old_c = stamp(2, 2);
            let rebound = stamp(3, if source_advanced { 3 } else { 2 });
            let mut observer = Observer::new(p);
            observer.begin(p, p.size).finish(old_c, 1, 1);
            observer.input_rebound(rebound.epoch, 2, rebound.sequence.unwrap());
            // Failed newer preparation followed by an eligible old C ACK must
            // not erase the sticky source/candidate lower bound.
            observer.begin(p, p.size).full();
            observer.acknowledge(old_c);
            observer.begin(old_c, old_c.size).finish(rebound, 1, 1);
            observer.acknowledge(rebound);
            assert!(
                observer
                    .delta(state(old_c), state(rebound), &sites)
                    .is_none()
            );
            // A full publication at rebound covers the authority change; a
            // subsequent exact transition resumes sparse work without reset.
            let next = stamp(4, rebound.epoch);
            observer.begin(rebound, rebound.size).finish(next, 1, 1);
            observer.acknowledge(next);
            assert_eq!(
                observer.delta(state(rebound), state(next), &sites),
                Some(&[][..])
            );
            // A later rebind cannot decrease either lower bound.
            observer.input_rebound(1, 2, NonZeroU64::new(1).unwrap());
            assert_eq!(
                observer.delta(state(rebound), state(next), &sites),
                Some(&[][..])
            );
        }
    }
}
