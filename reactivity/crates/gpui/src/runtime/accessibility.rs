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
}
impl Observer {
    fn new(stamp: Stamp) -> Self {
        Self {
            base: stamp,
            target: stamp,
            indices: Vec::new(),
            exact: false,
            pending: false,
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
            && self.base.matches(base, sites)
            && self.target.matches(target, sites))
        .then_some(self.indices.as_slice())
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
        previous: Option<&Presented>,
        next: &Presented,
        metadata: Option<&Metadata>,
        selection: Option<editing::SelectionSnapshot>,
        list: Option<scroll::ViewportInfo>,
        row: Option<&ListRow>,
    ) {
        if !self.exact {
            return;
        }
        let Some(previous) = previous else {
            self.full();
            return;
        };
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
        if previous.kind != next.kind
            || previous.actions != next.actions
            || previous.text.as_deref() != next.text.as_deref()
            || metadata.and_then(|m| m.selection.as_ref())
                .and_then(|frozen| frozen.presented)
                .and_then(|snapshot| snapshot.selection(previous.identity))
                != selection.and_then(|snapshot| snapshot.selection(next.identity))
            || old_name != new_name
            || old_description != new_description
            || rect_bits(previous.rect) != rect_bits(next.rect)
            || map_bits(previous.transform.get()) != map_bits(next.transform.get())
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
