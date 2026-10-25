//! Canonical mutation/dependency contract. These revisions are witnesses, NEVER ACK authority.
//! Storage is bounded by live dependency/changed-artifact limits, not event history.
use crate::MappedBounds;
use std::{collections::{BTreeMap, BTreeSet}, num::NonZeroU64};

#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord, Hash)]
pub struct SiteId { pub owner: NonZeroU64, pub local: NonZeroU64 }
impl SiteId {
    /// Observe a producer's owner-scoped MONOTONIC logical identity. Never pass
    /// a reusable storage index. This key is not a Target/ACK capability.
    pub const fn from_monotonic(owner: NonZeroU64, local: NonZeroU64) -> Self { Self { owner, local } }
}
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct Exhausted;
pub struct IdentityDomain { owner: NonZeroU64, next: NonZeroU64 }
impl IdentityDomain {
    pub fn new(owner: NonZeroU64) -> Self { Self { owner, next: NonZeroU64::MIN } }
    pub fn mint(&mut self) -> Result<SiteId, Exhausted> {
        let next = self.next.checked_add(1).ok_or(Exhausted)?;
        let id = SiteId::from_monotonic(self.owner, self.next); self.next = next; Ok(id)
    }
}

#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord, Hash)]
pub struct SceneRevision { pub owner: NonZeroU64, pub sequence: NonZeroU64 }
/// Output contents have BOTH a complete canonical revision and target generation.
/// An indexed scene revision does not certify completed surface pixels.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct SurfaceGeneration { pub owner: NonZeroU64, pub generation: NonZeroU64 }
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct OutputRevision { pub scene: SceneRevision, pub surface: SurfaceGeneration }

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct BatchStamp {
    pub from: Option<SceneRevision>, pub to: SceneRevision,
    /// Admitted logical source state represented by accepted C, NOT displayed P.
    pub source_epoch: u64,
    /// Immutable accepted scene snapshot generation. Never a surface-buffer age.
    pub snapshot_epoch: u64,
}
#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord)]
pub enum Facet {
    Topology, Layout, TextSource, TextPolicy, TextWidth, Paint, Transform,
    Clip, Stacking, ResourcePixels, ResourceMetrics, Hit, Semantics,
}
#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
pub struct Facets(u16);
impl Facets {
    pub const fn one(facet: Facet) -> Self { Self(1 << facet as u16) }
    pub const fn union(self, other: Self) -> Self { Self(self.0 | other.0) }
    pub const fn contains(self, facet: Facet) -> bool { self.0 & (1 << facet as u16) != 0 }
    pub fn phases(self) -> impl Iterator<Item = Phase> {
        Phase::ALL.into_iter().filter(move |phase| {
            use Facet::*;
            let geometry = self.contains(Topology) || self.contains(Layout) || self.contains(ResourceMetrics);
            let source = self.contains(TextSource) || self.contains(TextPolicy);
            let measure = geometry || source || self.contains(TextWidth);
            let placement = measure || self.contains(Transform);
            let clip = placement || self.contains(Clip);
            let lower = clip || self.contains(Paint) || self.contains(Stacking) || self.contains(ResourcePixels);
            match phase {
                Phase::Shape => source,
                Phase::TextLayout => source || self.contains(TextWidth),
                Phase::Measure | Phase::Layout => measure,
                Phase::Placement => placement,
                Phase::Clip => clip,
                Phase::Primitive | Phase::Raster => lower,
                Phase::Hit => placement || clip || self.contains(Stacking) || self.contains(Hit),
                Phase::Semantics => lower || self.contains(Hit) || self.contains(Semantics),
            }
        })
    }
}
#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord)]
pub enum Phase { Shape, TextLayout, Measure, Layout, Placement, Clip, Primitive, Raster, Hit, Semantics }
impl Phase {
    pub const fn downstream(self) -> &'static [Self] {
        match self {
            Self::Shape => &[Self::TextLayout], Self::TextLayout => &[Self::Measure],
            Self::Measure => &[Self::Layout], Self::Layout => &[Self::Placement],
            Self::Placement => &[Self::Clip, Self::Primitive, Self::Hit, Self::Semantics],
            Self::Clip => &[Self::Primitive, Self::Hit, Self::Semantics],
            Self::Primitive => &[Self::Raster], _ => &[],
        }
    }
    pub const ALL: [Self; 10] = [Self::Shape, Self::TextLayout, Self::Measure, Self::Layout, Self::Placement, Self::Clip, Self::Primitive, Self::Raster, Self::Hit, Self::Semantics];
}
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum Scope { Site, Subtree, Scene }
#[derive(Clone, Copy, Debug, PartialEq)]
pub struct Change { pub site: SiteId, pub facets: Facets, pub scope: Scope, pub before: MappedBounds, pub after: MappedBounds }
#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
pub struct FullReasons(u16);
impl FullReasons {
    pub const INITIAL: Self = Self(1);
    pub const CAPACITY: Self = Self(2);
    pub const UNKNOWN_SUPPORT: Self = Self(4);
    pub const REVISION_GAP: Self = Self(8);
    pub const UNKNOWN_DEPENDENCY: Self = Self(16);
    pub const SCENE: Self = Self(32);
    pub const fn union(self, other: Self) -> Self { Self(self.0 | other.0) }
    pub const fn is_empty(self) -> bool { self.0 == 0 }
    pub const fn contains(self, other: Self) -> bool { self.0 & other.0 == other.0 }
}
#[derive(Debug)]
pub struct ChangeBatch { pub stamp: BatchStamp, pub full: FullReasons, pub entries: Vec<Change> }
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum PrepareError { Revision, Capacity }

pub struct Journal {
    owner: NonZeroU64, base: Option<SceneRevision>, limit: usize,
    full: FullReasons, entries: BTreeMap<SiteId, Change>,
}
impl Journal {
    pub fn new(owner: NonZeroU64, limit: usize) -> Self {
        Self { owner, base: None, limit, full: FullReasons::INITIAL, entries: BTreeMap::new() }
    }
    pub fn base(&self) -> Option<SceneRevision> { self.base }
    pub fn full(&mut self, reason: FullReasons) { self.full = self.full.union(reason); }
    pub fn record(&mut self, mut change: Change) {
        if change.site.owner != self.owner { self.full(FullReasons::REVISION_GAP); return; }
        for support in [&mut change.before, &mut change.after] {
            if matches!(support, MappedBounds::Finite(rect) if !rect.is_valid()) { *support = MappedBounds::Unbounded; }
            if matches!(support, MappedBounds::Unbounded) { self.full(FullReasons::UNKNOWN_SUPPORT); }
        }
        if change.scope == Scope::Scene { self.full(FullReasons::SCENE); }
        if let Some(old) = self.entries.get_mut(&change.site) {
            old.facets = old.facets.union(change.facets);
            old.scope = match (old.scope, change.scope) { (Scope::Scene, _) | (_, Scope::Scene) => Scope::Scene, (Scope::Subtree, _) | (_, Scope::Subtree) => Scope::Subtree, _ => Scope::Site };
            old.after = change.after; // Earliest OLD support and latest NEW; no event history retained.
        } else if self.entries.len() < self.limit {
            self.entries.insert(change.site, change);
        } else {
            self.full(FullReasons::CAPACITY);
        }
    }
    /// Prepare while C is still fallible. Dropping this guard preserves ALL pending changes.
    /// Its exclusive borrow prevents a producer mutation between validation and commit.
    pub fn prepare(&mut self, stamp: BatchStamp) -> Result<PreparedChanges<'_>, PrepareError> {
        if stamp.from != self.base || stamp.to.owner != self.owner || stamp.snapshot_epoch == 0
            || self.base.is_some_and(|old| old.owner != stamp.to.owner || old.sequence >= stamp.to.sequence)
        { return Err(PrepareError::Revision); }
        let mut entries = Vec::new();
        entries.try_reserve_exact(self.entries.len()).map_err(|_| PrepareError::Capacity)?;
        entries.extend(self.entries.values().copied());
        let full = self.full;
        Ok(PreparedChanges { journal: self, batch: ChangeBatch { stamp, full, entries } })
    }
}
pub struct PreparedChanges<'a> { journal: &'a mut Journal, batch: ChangeBatch }
impl PreparedChanges<'_> {
    /// Call only AFTER the corresponding immutable C has actually committed.
    /// No fallible work remains here; failed preparations must DROP this guard.
    pub fn commit(self) -> ChangeBatch {
        self.journal.base = Some(self.batch.stamp.to);
        self.journal.entries.clear(); self.journal.full = FullReasons::default(); self.batch
    }
}

#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord)]
pub struct Artifact { pub site: SiteId, pub phase: Phase }
/// Actual sparse reverse consumer edges. Same-site facet closure is implicit;
/// cross-site layout/placement/clip/resource dependencies are registered explicitly.
pub struct Dependencies {
    snapshot: Option<SceneRevision>, reverse: BTreeMap<Artifact, BTreeSet<Artifact>>,
    edges: usize, limit: usize, overflow: bool,
}
#[derive(Debug)]
pub struct Invalidated { pub full: FullReasons, pub artifacts: BTreeSet<Artifact> }
impl Dependencies {
    pub fn new(limit: usize) -> Self { Self { snapshot: None, reverse: BTreeMap::new(), edges: 0, limit, overflow: false } }
    pub fn reset(&mut self, snapshot: SceneRevision) { self.reverse.clear(); self.edges = 0; self.overflow = false; self.snapshot = Some(snapshot); }
    /// `consumer` reads `input`; order is intentionally reverse from evaluation.
    pub fn depends_on(&mut self, consumer: Artifact, input: Artifact) {
        if self.overflow { return; }
        if self.snapshot.is_none_or(|s| input.site.owner != s.owner || consumer.site.owner != s.owner) { self.overflow = true; return; }
        if self.reverse.get(&input).is_some_and(|v| v.contains(&consumer)) { return; }
        if self.edges == self.limit { self.overflow = true; return; }
        self.reverse.entry(input).or_default().insert(consumer); self.edges += 1;
    }
    pub fn invalidate(&self, batch: &ChangeBatch) -> Invalidated {
        let mut full = batch.full;
        if self.snapshot != batch.stamp.from { full = full.union(FullReasons::REVISION_GAP); }
        if self.overflow { full = full.union(FullReasons::CAPACITY); }
        let mut artifacts = BTreeSet::new(); let mut pending = Vec::new();
        for change in &batch.entries {
            for phase in change.facets.phases() { pending.push(Artifact { site: change.site, phase }); }
        }
        while let Some(key) = pending.pop() {
            if artifacts.contains(&key) { continue; }
            if artifacts.len() == self.limit { full = full.union(FullReasons::CAPACITY); break; }
            artifacts.insert(key);
            pending.extend(key.phase.downstream().iter().map(|phase| Artifact { site: key.site, phase: *phase }));
            if let Some(consumers) = self.reverse.get(&key) { pending.extend(consumers.iter().copied()); }
        }
        Invalidated { full, artifacts }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::Rect;
    fn owner() -> NonZeroU64 { NonZeroU64::new(7).unwrap() }
    fn site(local: u64) -> SiteId { SiteId::from_monotonic(owner(), NonZeroU64::new(local).unwrap()) }
    fn revision(sequence: u64) -> SceneRevision { SceneRevision { owner: owner(), sequence: NonZeroU64::new(sequence).unwrap() } }
    fn stamp(from: Option<SceneRevision>, next: u64) -> BatchStamp { BatchStamp { from, to: revision(next), source_epoch: next, snapshot_epoch: next } }
    fn change(local: u64, facet: Facet) -> Change { Change { site: site(local), facets: Facets::one(facet), scope: Scope::Site, before: MappedBounds::Finite(Rect::new(0., 0., 1., 1.)), after: MappedBounds::Finite(Rect::new(2., 0., 1., 1.)) } }
    #[test]
    fn identity_removal_never_reuses_storage_and_exhaustion_is_closed() {
        let mut domain = IdentityDomain::new(owner()); let removed = domain.mint().unwrap();
        let replacement = domain.mint().unwrap(); assert_ne!(removed, replacement);
        domain.next = NonZeroU64::new(u64::MAX).unwrap(); assert_eq!(domain.mint(), Err(Exhausted));
    }
    #[test]
    fn failed_preparation_keeps_earliest_old_latest_new_and_full_overflow_reason() {
        let mut journal = Journal::new(owner(), 1);
        journal.record(change(1, Facet::Transform));
        { let candidate = journal.prepare(stamp(None, 1)).unwrap(); drop(candidate); }
        let mut later = change(1, Facet::Paint); later.before = MappedBounds::Empty; later.after = MappedBounds::Empty;
        journal.record(later); journal.record(change(2, Facet::Clip));
        let batch = journal.prepare(stamp(None, 1)).unwrap().commit();
        assert!(batch.full.contains(FullReasons::CAPACITY)); assert_eq!(batch.entries.len(), 1);
        assert_eq!(batch.entries[0].before, change(1, Facet::Transform).before);
        assert_eq!(batch.entries[0].after, MappedBounds::Empty);
        assert!(batch.entries[0].facets.contains(Facet::Paint)); assert_eq!(journal.base(), Some(revision(1)));
        assert!(matches!(journal.prepare(stamp(None, 2)), Err(PrepareError::Revision)));
    }
    #[test]
    fn actual_reverse_edges_propagate_parent_layout_and_descendant_clip_but_not_shape_from_paint() {
        let mut graph = Dependencies::new(128); graph.reset(revision(1));
        graph.depends_on(Artifact { site: site(1), phase: Phase::Layout }, Artifact { site: site(2), phase: Phase::Layout });
        graph.depends_on(Artifact { site: site(3), phase: Phase::Clip }, Artifact { site: site(1), phase: Phase::Clip });
        let mut journal = Journal::new(owner(), 8); journal.prepare(stamp(None, 1)).unwrap().commit();
        journal.record(change(2, Facet::Layout)); let batch = journal.prepare(stamp(Some(revision(1)), 2)).unwrap().commit();
        let dirty = graph.invalidate(&batch);
        assert!(dirty.artifacts.contains(&Artifact { site: site(1), phase: Phase::Layout }));
        assert!(dirty.artifacts.contains(&Artifact { site: site(3), phase: Phase::Raster }));
        journal.record(change(2, Facet::Paint));
        let batch = journal.prepare(stamp(Some(revision(2)), 3)).unwrap().commit();
        let dirty = graph.invalidate(&batch); assert!(dirty.full.contains(FullReasons::REVISION_GAP));
        assert!(!dirty.artifacts.iter().any(|key| key.phase == Phase::Shape));
        assert!(!Facets::one(Facet::TextWidth).phases().any(|phase| phase == Phase::Shape));
    }
}
