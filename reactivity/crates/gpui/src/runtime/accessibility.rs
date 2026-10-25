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

#[cfg(test)]
mod unchanged_tests {
    use super::*;
    use crate::{El, Signal, Source, div, text_input};

    struct Page {
        width: Signal<f64>,
        map: Signal<Affine>,
        unused: Signal<u64>,
    }
    impl Page {
        const WIDTH: Source<Self, f64> =
            Source::new(FieldId::new(1), "width", |m| &m.width, |m| &mut m.width);
        const MAP: Source<Self, Affine> =
            Source::new(FieldId::new(2), "map", |m| &m.map, |m| &mut m.map);
        const UNUSED: Source<Self, u64> =
            Source::new(FieldId::new(3), "unused", |m| &m.unused, |m| &mut m.unused);
        fn new() -> Self {
            Self {
                width: Signal::new(40.),
                map: Signal::new(Affine::IDENTITY),
                unused: Signal::new(0),
            }
        }
    }
    impl View for Page {
        fn sources() -> Sources<Self> {
            Sources::new()
                .direct(Self::WIDTH)
                .direct(Self::MAP)
                .direct(Self::UNUSED)
        }
        fn view(&self) -> El<'_> {
            div()
                .name("surface")
                .w(&self.width)
                .h(12)
                .bg(Color::BLACK)
                .transform(&self.map)
        }
    }
    fn token<M: View + 'static>(win: &Win<M>) -> PresentationToken {
        win.with_scene(|_, token| token).unwrap()
    }
    fn acknowledge<M: View + 'static>(win: &mut Win<M>) {
        win.presented(token(win)).unwrap();
    }
    fn recording() -> Win<Page> {
        let mut win = Win::recording(
            Page::new(),
            WindowOptions {
                size: [80, 40],
                ..Default::default()
            },
        )
        .unwrap();
        acknowledge(&mut win);
        win
    }
    fn noop(win: &mut Win<Page>, mode: usize) -> Commit {
        match mode {
            0 => {
                let value = *win.read(Page::WIDTH).unwrap();
                win.set(Page::WIDTH, value).unwrap()
            }
            1 => {
                let value = *win.read(Page::MAP).unwrap();
                win.set(Page::MAP, value).unwrap()
            }
            _ => {
                let value = *win.read(Page::UNUSED).unwrap() + 1;
                win.set(Page::UNUSED, value).unwrap()
            }
        }
    }
    #[test]
    fn acknowledged_generic_noops_advance_epoch_with_exact_empty_delta() {
        for mode in 0..3 {
            let mut win = recording();
            win.accessibility_observe(true).unwrap();
            let base = win.accessibility_state().unwrap();
            let before = token(&win);
            let commit = noop(&mut win, mode);
            let next = win.accessibility_state().unwrap();
            assert_eq!(next.token, base.token);
            assert!(next.epoch > base.epoch);
            assert_eq!(next.epoch, commit.source_epoch);
            assert_eq!(token(&win), before);
            assert_eq!(win.accessibility_delta(base, next), Some(&[][..]));
        }
    }
    #[test]
    fn early_observer_retains_pending_nonempty_transition_through_generic_noop() {
        for mode in 0..3 {
            let mut win = recording();
            win.accessibility_observe(true).unwrap();
            let base = win.accessibility_state().unwrap();
            win.set(Page::MAP, Affine::translation(5., 0.)).unwrap();
            let eligible = token(&win);
            let commit = noop(&mut win, mode);
            assert_eq!(win.accessibility_state().unwrap(), base);
            assert_eq!(token(&win), eligible);
            assert!(commit.presentation_epoch < commit.source_epoch);
            assert!(win.accessibility_delta(base, base).is_none());
            win.presented(eligible).unwrap();
            let next = win.accessibility_state().unwrap();
            assert_eq!(next.epoch, commit.source_epoch);
            assert_eq!(win.accessibility_delta(base, next), Some(&[0][..]));
        }
    }
    #[test]
    fn late_observer_does_not_invent_exact_delta_for_unobserved_candidate() {
        for mode in 0..3 {
            let mut win = recording();
            let base = win.accessibility_state().unwrap();
            win.set(Page::MAP, Affine::translation(5., 0.)).unwrap();
            let eligible = token(&win);
            win.accessibility_observe(true).unwrap();
            noop(&mut win, mode);
            win.presented(eligible).unwrap();
            let next = win.accessibility_state().unwrap();
            assert!(win.accessibility_delta(base, next).is_none());
            // An actual full consumer publication at next can establish this
            // new base; only the subsequent unchanged transition may be empty.
            noop(&mut win, mode);
            let after = win.accessibility_state().unwrap();
            assert_eq!(win.accessibility_delta(next, after), Some(&[][..]));
            assert!(win.accessibility_delta(base, after).is_none());
        }
    }
    #[test]
    fn failed_newer_candidate_and_generic_noop_preserve_old_ack_fallback() {
        for mode in 0..3 {
            let mut win = recording();
            win.accessibility_observe(true).unwrap();
            let base = win.accessibility_state().unwrap();
            win.set(Page::MAP, Affine::translation(5., 0.)).unwrap();
            noop(&mut win, mode);
            let eligible = token(&win);
            assert!(win.set(Page::MAP, Affine::scale(0., 1.)).is_err());
            let value = *win.read(Page::WIDTH).unwrap();
            assert!(win.set(Page::WIDTH, value).is_err());
            assert_eq!(token(&win), eligible);
            let commit = win.presented(eligible).unwrap();
            let next = win.accessibility_state().unwrap();
            assert!(commit.presentation_epoch < commit.source_epoch);
            assert!(win.accessibility_delta(base, next).is_none());
        }
    }

    struct Inputs {
        peer: bool,
        first: Signal<String>,
        second: Signal<String>,
        map: Signal<Affine>,
        unused: Signal<u64>,
    }
    impl Inputs {
        const FIRST: Source<Self, String> =
            Source::new(FieldId::new(1), "first", |m| &m.first, |m| &mut m.first);
        const SECOND: Source<Self, String> =
            Source::new(FieldId::new(2), "second", |m| &m.second, |m| &mut m.second);
        const MAP: Source<Self, Affine> =
            Source::new(FieldId::new(3), "map", |m| &m.map, |m| &mut m.map);
        const UNUSED: Source<Self, u64> =
            Source::new(FieldId::new(4), "unused", |m| &m.unused, |m| &mut m.unused);
    }
    impl View for Inputs {
        fn sources() -> Sources<Self> {
            Sources::new()
                .direct(Self::FIRST)
                .direct(Self::SECOND)
                .direct(Self::MAP)
                .direct(Self::UNUSED)
        }
        fn view(&self) -> El<'_> {
            text_input(if self.peer { &self.second } else { &self.first })
                .name("input")
                .w(60)
                .h(24)
                .transform(&self.map)
        }
    }
    fn barrier(win: &Win<Inputs>) -> (u64, u64) {
        let runtime = win.runtime().unwrap();
        let observer = runtime.accessibility.as_ref().unwrap();
        (observer.input_epoch, observer.input_sequence)
    }
    #[test]
    fn generic_unchanged_publication_does_not_clear_input_rebound_barrier() {
        let mut win = Win::recording(
            Inputs {
                peer: false,
                first: Signal::new("abc".into()),
                second: Signal::new("abc".into()),
                map: Signal::new(Affine::IDENTITY),
                unused: Signal::new(0),
            },
            WindowOptions {
                size: [80, 40],
                ..Default::default()
            },
        )
        .unwrap();
        acknowledge(&mut win);
        win.accessibility_observe(true).unwrap();
        let base = win.accessibility_state().unwrap();
        win.set(Inputs::MAP, Affine::translation(5., 0.)).unwrap();
        win.update(|model| model.peer = true).unwrap();
        let lower = barrier(&win);
        assert!(lower.0 > base.epoch || lower.1 > base.token.unwrap().sequence.get());
        let eligible = token(&win);
        win.set(Inputs::UNUSED, 1).unwrap();
        assert_eq!(barrier(&win), lower);
        assert!(win.set(Inputs::MAP, Affine::scale(0., 1.)).is_err());
        assert!(win.set(Inputs::UNUSED, 2).is_err());
        win.presented(eligible).unwrap();
        let old_ack = win.accessibility_state().unwrap();
        assert!(win.accessibility_delta(base, old_ack).is_none());
        assert_eq!(barrier(&win), lower);
        win.set(Inputs::MAP, Affine::IDENTITY).unwrap();
        acknowledge(&mut win);
        let covered = win.accessibility_state().unwrap();
        win.set(Inputs::UNUSED, 3).unwrap();
        let next = win.accessibility_state().unwrap();
        assert_eq!(win.accessibility_delta(covered, next), Some(&[][..]));
        assert_eq!(barrier(&win), lower);
    }
}
