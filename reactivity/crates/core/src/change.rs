//! Canonical mutation/dependency contract. These revisions are witnesses, NEVER ACK authority.
//! Storage is bounded by live dependency/changed-artifact limits, not event history.
use crate::{MappedBounds, Rect};
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
#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord)]
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
    Clip, Stacking, ResourcePixels, ResourceMetrics, Hit, Semantics, WidthConstraint, HeightConstraint, PrimitiveContent,
}
#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
pub struct Facets(u16);
impl Facets {
    pub const fn one(facet: Facet) -> Self { Self(1 << facet as u16) }
    pub const fn union(self, other: Self) -> Self { Self(self.0 | other.0) }
    pub const fn contains(self, facet: Facet) -> bool { self.0 & (1 << facet as u16) != 0 }
    /// Positive admission schema: future facets are forbidden by default.
    /// Primitive/overlay edits are NOT material-bank color edits.
    pub const fn is_material_only(self) -> bool {
        self.0 & !(Self::one(Facet::Paint).0 | Self::one(Facet::Hit).0 | Self::one(Facet::Semantics).0) == 0
    }

    pub fn phases(self) -> impl Iterator<Item = Phase> {
        Phase::ALL.into_iter().filter(move |phase| {
            use Facet::*;
            let geometry = self.contains(Topology) || self.contains(Layout) || self.contains(ResourceMetrics) || self.contains(WidthConstraint) || self.contains(HeightConstraint);
            let source = self.contains(TextSource) || self.contains(TextPolicy);
            let measure = geometry || source || self.contains(TextWidth);
            let placement = measure || self.contains(Transform);
            let clip = placement || self.contains(Clip);
            let primitive = clip || self.contains(Stacking) || self.contains(PrimitiveContent);
            let lower = primitive || self.contains(Paint) || self.contains(ResourcePixels);
            match phase {
                Phase::WidthConstraint => self.contains(WidthConstraint),
                Phase::HeightConstraint => self.contains(HeightConstraint),
                Phase::BoxConstraint => self.contains(Layout),
                Phase::Realize => false,
                Phase::Shape => source,
                Phase::TextLayout => source || self.contains(TextWidth) || self.contains(WidthConstraint),
                Phase::Measure | Phase::Layout => measure,
                Phase::Placement => placement,
                Phase::Clip => clip,
                Phase::Primitive => primitive,
                Phase::Material | Phase::Raster => lower,
                Phase::Hit => placement || clip || self.contains(Stacking) || self.contains(PrimitiveContent) || self.contains(Hit),
                Phase::Semantics => lower || self.contains(Hit) || self.contains(Semantics),
            }
        })
    }
}
#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord, Hash)]
pub enum Phase { WidthConstraint, HeightConstraint, BoxConstraint, Realize, Shape, TextLayout, Measure, Layout, Placement, Clip, Primitive, Material, Raster, Hit, Semantics }
impl Phase {
    pub const fn downstream(self) -> &'static [Self] {
        match self {
            Self::WidthConstraint => &[Self::TextLayout], Self::HeightConstraint | Self::BoxConstraint => &[Self::Measure],
            Self::Shape => &[Self::TextLayout], Self::TextLayout => &[Self::Measure],
            Self::Measure => &[Self::Layout], Self::Layout => &[Self::Placement],
            Self::Placement => &[Self::Clip, Self::Primitive, Self::Hit, Self::Semantics],
            Self::Clip => &[Self::Primitive, Self::Hit, Self::Semantics],
            Self::Primitive => &[Self::Material, Self::Raster, Self::Hit, Self::Semantics], Self::Material => &[Self::Raster], _ => &[],
        }
    }
    pub const ALL: [Self; 15] = [Self::WidthConstraint, Self::HeightConstraint, Self::BoxConstraint, Self::Realize, Self::Shape, Self::TextLayout, Self::Measure, Self::Layout, Self::Placement, Self::Clip, Self::Primitive, Self::Material, Self::Raster, Self::Hit, Self::Semantics];
}
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum Scope { Site, Subtree, Scene }
/// Logical invalidation is often known before canonical placement exists.
/// Pending is NOT unbounded damage and never permanently forces full raster.
#[derive(Clone, Copy, Debug, PartialEq)]
pub enum Support { Pending, Empty, Finite(Rect), Unbounded }
impl From<MappedBounds> for Support {
    fn from(value: MappedBounds) -> Self { match value { MappedBounds::Empty => Self::Empty, MappedBounds::Finite(rect) => Self::Finite(rect), MappedBounds::Unbounded => Self::Unbounded } }
}
#[derive(Clone, Copy, Debug, PartialEq)]
pub struct Change { pub site: SiteId, pub facets: Facets, pub scope: Scope, pub before: Support, pub after: Support }
/// Produced by the canonical renderer resolver, after matching OLD indexed
/// revision+complete membership and NEW accepted snapshot/ranges/resources.
/// This stage has no Pending variant; source-side guesses are not resolution.
#[derive(Clone, Copy, Debug, PartialEq)]
pub struct ResolvedChange { pub site: SiteId, pub facets: Facets, pub scope: Scope, pub before: MappedBounds, pub after: MappedBounds }
#[derive(Debug)]
pub struct ResolvedChangeBatch { pub stamp: BatchStamp, pub full: FullReasons, pub entries: Vec<ResolvedChange> }

#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
pub struct FullReasons(u16);
impl FullReasons {
    pub const INITIAL: Self = Self(1);
    pub const CAPACITY: Self = Self(2);
    pub const UNBOUNDED: Self = Self(4);
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
    owner: NonZeroU64, base: Option<SceneRevision>, source_epoch: u64, snapshot_epoch: u64, limit: usize,
    full: FullReasons, entries: BTreeMap<SiteId, Change>, mutation: u64,
}
impl Journal {
    pub fn new(owner: NonZeroU64, limit: usize) -> Self {
        Self { owner, base: None, source_epoch: 0, snapshot_epoch: 0, limit, full: FullReasons::INITIAL, entries: BTreeMap::new(), mutation: 0 }
    }
    pub fn base(&self) -> Option<SceneRevision> { self.base }
    pub fn full(&mut self, reason: FullReasons) { self.full = self.full.union(reason); }
    pub fn record(&mut self, mut change: Change) {
        match self.mutation.checked_add(1) { Some(next) => self.mutation = next, None => self.full(FullReasons::CAPACITY) }
        if change.site.owner != self.owner { self.full(FullReasons::REVISION_GAP); return; }
        for support in [&mut change.before, &mut change.after] {
            if matches!(support, Support::Finite(rect) if !rect.is_valid()) { *support = Support::Unbounded; }
            if matches!(support, Support::Unbounded) { self.full(FullReasons::UNBOUNDED); }
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
        if stamp.from != self.base || stamp.to.owner != self.owner || stamp.snapshot_epoch <= self.snapshot_epoch || stamp.source_epoch < self.source_epoch
            || self.base.is_some_and(|old| old.owner != stamp.to.owner || old.sequence >= stamp.to.sequence)
        { return Err(PrepareError::Revision); }
        let full = self.full;
        // Hard-full candidates require complete canonical admission; a partial
        // delta cannot be consumed (slot-only publication rejects it outright).
        // Keep the pending map for failure/drop repair, but do not copy/retain
        // that unusable list inside the accepted immutable Canvas binding.
        let mut entries = Vec::new();
        if full.is_empty() {
            entries.try_reserve_exact(self.entries.len()).map_err(|_| PrepareError::Capacity)?;
            entries.extend(self.entries.values().copied());
        }
        Ok(PreparedChanges { journal: self, batch: ChangeBatch { stamp, full, entries }, closed: None })
    }
}
pub struct PreparedChanges<'a> { journal: &'a mut Journal, batch: ChangeBatch, closed: Option<ClosedDependencies> }
impl PreparedChanges<'_> {
    pub fn batch(&self) -> &ChangeBatch { &self.batch }
    pub fn closed_dependencies(&self) -> Option<&ClosedDependencies> { self.closed.as_ref() }
    /// Bind the already-computed OLD+NEW logical closure; never recompute after C.
    /// This remains producer schema authority, not output/image completion proof.
    pub fn with_closed(mut self, closure: Invalidated) -> Result<Self, PrepareError> {
        let stamp = self.batch.stamp;
        if closure.basis.owner != stamp.to.owner || closure.basis.from != stamp.from
            || closure.basis.to.is_some_and(|to| to != stamp.to) { return Err(PrepareError::Revision); }
        let mut full = closure.full.union(self.batch.full);
        if closure.basis.facts != Some(self.journal.mutation) { full = full.union(FullReasons::UNKNOWN_DEPENDENCY); }
        // A producer may add late facts (e.g. post-layout text) after an earlier
        // solve closure. Never label uncovered facts incrementally complete.
        if full.is_empty() && self.batch.entries.iter().any(|change| !matches!((change.before, change.after), (Support::Empty, Support::Empty)) && change.facets.phases().any(|phase|
            !closure.artifacts.contains(&DependencyNode::Site(Artifact { site: change.site, phase })))) {
            full = full.union(FullReasons::UNKNOWN_DEPENDENCY);
        }
        self.batch.full = self.batch.full.union(full);
        self.closed = Some(ClosedDependencies { stamp, full, artifacts: if full.is_empty() { closure.artifacts } else { BTreeSet::new() } });
        Ok(self)
    }
    pub fn commit_with_closure(mut self) -> (ChangeBatch, Option<ClosedDependencies>) {
        let closed = self.closed.take(); (self.commit(), closed)
    }

    /// Call only AFTER the corresponding immutable C has actually committed.
    /// No fallible work remains here; failed preparations must DROP this guard.
    pub fn commit(self) -> ChangeBatch {
        self.journal.base = Some(self.batch.stamp.to);
        self.journal.source_epoch = self.batch.stamp.source_epoch;
        self.journal.snapshot_epoch = self.batch.stamp.snapshot_epoch;
        self.journal.entries.clear(); self.journal.mutation = 0; self.journal.full = FullReasons::default(); self.batch
    }
}

#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord, Hash)]
pub struct Artifact { pub site: SiteId, pub phase: Phase }
#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord)]
pub struct GroupId { pub snapshot: SceneRevision, pub first_draw: u32 }
#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord)]
pub struct TileId { pub surface: SurfaceGeneration, pub index: u32 }
#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord)]
pub enum GlobalDependency { Viewport, Pipeline, Clear, ColorConfig, Sampling }
#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord)]
pub enum DependencyNode {
    Site(Artifact), Group(GroupId), Resource(crate::resource::ResourceId), Tile(TileId),
    Global { owner: NonZeroU64, kind: GlobalDependency },
}
impl From<Artifact> for DependencyNode {
    fn from(value: Artifact) -> Self { Self::Site(value) }
}


/// Bounded replacements of canonical owners' immutable resource reads.
/// Snapshot-local Group/Tile dependencies are discovered by the common lazy
/// queue, not retained here across C generations.
pub struct ResourceReadPatch {
    replacements: BTreeMap<Artifact, Vec<crate::resource::ResourceId>>,
    limit: usize, edges: usize, overflow: bool,
}
impl ResourceReadPatch {
    pub fn new(limit: usize) -> Self { Self { replacements: BTreeMap::new(), limit, edges: 0, overflow: false } }
    /// Observe one immutable resource during mandatory preparation. An unchanged
    /// owner allocates nothing; A→B→A cancels only that owner's pending change.
    /// New immutable read inputs cannot create a new event from an old value.
    /// Every changed consumer must already belong to the logical closure; an
    /// arbitrary owner rebind is not certified by a same-stamp receipt.
    pub fn covered_by(&self, closed: &Invalidated) -> bool {
        !closed.full.is_empty() || self.replacements.keys().all(|owner| closed.artifacts.contains(&DependencyNode::Site(*owner)))
    }
    pub fn observe_one(&mut self, graph: &Dependencies, owner: Artifact, input: Option<crate::resource::ResourceId>) {
        let desired = input.as_slice();
        if graph.resources.owners.get(&owner).map_or(&[][..], Vec::as_slice) == desired {
            if let Some(previous) = self.replacements.remove(&owner) { self.edges -= previous.len(); }
            return;
        }
        if self.replacements.get(&owner).is_some_and(|previous| previous.as_slice() == desired) { return; }
        self.replace(owner, input.into_iter().collect());
    }
    pub fn replace(&mut self, owner: Artifact, mut inputs: Vec<crate::resource::ResourceId>) {
        if inputs.len() > self.limit { self.overflow = true; return; }
        inputs.sort_unstable(); inputs.dedup();
        let next = self.edges.checked_sub(self.replacements.get(&owner).map_or(0, Vec::len)).and_then(|count| count.checked_add(inputs.len()));
        if next.is_none_or(|count| count > self.limit) || (!self.replacements.contains_key(&owner) && self.replacements.len() == self.limit) {
            self.overflow = true; return;
        }
        self.edges = next.expect("checked bounded edge sum");
        self.replacements.insert(owner, inputs);
    }
}
#[derive(Default)]
struct ResourceReads {
    owners: std::collections::HashMap<Artifact, Vec<crate::resource::ResourceId>>,
    reverse: std::collections::HashMap<crate::resource::ResourceId, Vec<Artifact>>,
    edges: usize,
}
pub struct PreparedResourceReads<'a> {
    graph: &'a mut Dependencies,
    owners: BTreeMap<Artifact, Vec<crate::resource::ResourceId>>,
    buckets: std::collections::HashMap<crate::resource::ResourceId, Vec<Artifact>>,
    edges: usize,
}
impl PreparedResourceReads<'_> {
    /// All root-table capacity and changed reverse buckets were admitted before
    /// canonical C mutation. Existing accepted semantics survive a dropped guard.
    pub fn commit(self) {
        for (resource, consumers) in self.buckets {
            if consumers.is_empty() { self.graph.resources.reverse.remove(&resource); }
            else { self.graph.resources.reverse.insert(resource, consumers); }
        }
        for (owner, inputs) in self.owners {
            if inputs.is_empty() { self.graph.resources.owners.remove(&owner); }
            else { self.graph.resources.owners.insert(owner, inputs); }
        }
        self.graph.resources.edges = self.edges;
        self.graph.touch();
    }
}

/// Typed graph identity/generation, never a scene/resource/storage owner.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct GraphVersion { domain: NonZeroU64, generation: u64 }
static NEXT_GRAPH_DOMAIN: std::sync::atomic::AtomicU64 = std::sync::atomic::AtomicU64::new(1);
/// Actual sparse reverse consumer edges. Same-site facet closure is implicit;
/// cross-site layout/placement/clip/resource dependencies are registered explicitly.
pub struct Dependencies {
    snapshot: Option<SceneRevision>, owner: Option<NonZeroU64>, reverse: BTreeMap<DependencyNode, BTreeSet<DependencyNode>>,
    edges: usize, limit: usize, overflow: bool, sites: BTreeSet<SiteId>, complete: bool,
    resources: ResourceReads, domain: Option<NonZeroU64>, generation: u64,
}
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum SnapshotSide { Before, After, Both }
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
struct ClosureContext { owner: NonZeroU64, from: Option<SceneRevision>, to: Option<SceneRevision>, surface: Option<SurfaceGeneration>, facts: Option<u64> }
#[derive(Debug)]
pub struct Invalidated { full: FullReasons, artifacts: BTreeSet<DependencyNode>, basis: ClosureContext, limit: usize, graphs: [Option<GraphVersion>; 2] }
impl Invalidated {
    /// Monotonic conservative fallback; callers cannot remove reasons/artifacts.
    pub fn require_full(&mut self, reason: FullReasons) {
        self.full = self.full.union(reason); if !self.full.is_empty() { self.artifacts.clear(); }
    }
    pub fn matches_graphs(&self, before: &Dependencies, after: Option<&Dependencies>) -> bool {
        if after.is_some_and(|graph| graph.version().is_none()) { return false; }
        let first = before.version(); let second = after.and_then(Dependencies::version).filter(|version| Some(*version) != first);
        first.is_some() && self.graphs == [first, second]
    }
    pub fn matches_pending(&self, journal: &Journal) -> bool {
        self.basis.owner == journal.owner && self.basis.from == journal.base
            && self.basis.to.is_none() && self.basis.facts == Some(journal.mutation)
            && self.full.union(journal.full) == self.full
    }
    pub fn full(&self) -> FullReasons { self.full }
    pub fn artifacts(&self) -> &BTreeSet<DependencyNode> { &self.artifacts }
    pub fn merge(&mut self, other: Self) {
        if self.basis != other.basis { self.full = self.full.union(FullReasons::REVISION_GAP); self.artifacts.clear(); return; }
        for version in other.graphs.into_iter().flatten() {
            if !self.graphs.contains(&Some(version)) {
                if let Some(slot) = self.graphs.iter_mut().find(|slot| slot.is_none()) { *slot = Some(version); }
                else { self.full = self.full.union(FullReasons::UNKNOWN_DEPENDENCY); self.artifacts.clear(); return; }
            }
        }
        self.full = self.full.union(other.full);
        if !self.full.is_empty() { self.artifacts.clear(); return; }
        self.limit = self.limit.min(other.limit);
        if self.artifacts.len() > self.limit { self.full = self.full.union(FullReasons::CAPACITY); self.artifacts.clear(); return; }
        for key in other.artifacts {
            if !self.artifacts.contains(&key) && self.artifacts.len() >= self.limit {
                self.full = self.full.union(FullReasons::CAPACITY); self.artifacts.clear(); return;
            }
            self.artifacts.insert(key);
        }
    }
}
/// Accepted logical closure with exact publication range. It is NOT a completed
/// pixel revision: a target must still consume every intervening group/damage
/// delta from its actual image base, or reject that history as a gap.
#[derive(Debug)]
pub struct ClosedDependencies { stamp: BatchStamp, full: FullReasons, artifacts: BTreeSet<DependencyNode> }
impl ClosedDependencies {
    pub fn stamp(&self) -> BatchStamp { self.stamp }
    pub fn full(&self) -> FullReasons { self.full }
    pub fn artifacts(&self) -> &BTreeSet<DependencyNode> { &self.artifacts }
}
impl Dependencies {
    pub fn new(limit: usize) -> Self {
        let domain = NEXT_GRAPH_DOMAIN.fetch_update(std::sync::atomic::Ordering::Relaxed, std::sync::atomic::Ordering::Relaxed, |value| value.checked_add(1)).ok().and_then(NonZeroU64::new);
        Self { snapshot: None, owner: None, reverse: BTreeMap::new(), edges: 0, limit, overflow: false, sites: BTreeSet::new(), complete: false, resources: ResourceReads::default(), domain, generation: 0 } }
    pub fn version(&self) -> Option<GraphVersion> { self.domain.filter(|_| self.generation < u64::MAX).map(|domain| GraphVersion { domain, generation: self.generation }) }
    fn touch(&mut self) {
        if let Some(next) = self.generation.checked_add(1) { self.generation = next; }
        if self.version().is_none() { self.overflow = true; self.complete = false; }
    }
    pub fn reset_initial(&mut self, owner: NonZeroU64) { self.reset_from(owner, None); }
    pub fn reset(&mut self, snapshot: SceneRevision) { self.reset_from(snapshot.owner, Some(snapshot)); }
    pub fn rebase(&mut self, snapshot: SceneRevision) { self.touch(); if self.owner != Some(snapshot.owner) { self.overflow = true; } self.snapshot = Some(snapshot); }
    fn reset_from(&mut self, owner: NonZeroU64, snapshot: Option<SceneRevision>) { self.owner = Some(owner); self.resources = ResourceReads::default(); self.reverse.clear(); self.edges = 0; self.overflow = false; self.complete = false; self.sites.clear(); self.snapshot = snapshot; self.touch(); }
    pub fn register_site(&mut self, site: SiteId) {
        self.touch();
        self.complete = false;
        if self.owner != Some(site.owner) || (!self.sites.contains(&site) && self.sites.len() == self.limit) { self.overflow = true; return; }
        self.sites.insert(site);
    }
    /// Producer completion witness: all accepted logical sites must have been
    /// registered during the mandatory traversal, including isolated sites.
    /// Required edge coverage remains the producer/consumer schema obligation.
    pub fn finish(&mut self, expected_sites: usize) -> bool {
        self.touch();
        self.complete = !self.overflow && self.sites.len() == expected_sites; self.complete
    }
    /// `consumer` reads `input`; order is intentionally reverse from evaluation.
    pub fn depends_on(&mut self, consumer: Artifact, input: Artifact) {
        self.register_site(input.site); self.register_site(consumer.site);
        self.depends_on_node(DependencyNode::Site(consumer), DependencyNode::Site(input));
    }
    pub fn depends_on_resource(&mut self, consumer: Artifact, resource: crate::resource::ResourceId) {
        self.register_site(consumer.site);
        self.depends_on_node(DependencyNode::Site(consumer), DependencyNode::Resource(resource));
    }
    pub fn depends_on_node(&mut self, consumer: DependencyNode, input: DependencyNode) {
        self.touch();
        if self.overflow { return; }
        self.complete = false;
        if self.reverse.get(&input).is_some_and(|v| v.contains(&consumer)) { return; }
        if self.edges.checked_add(self.resources.edges).is_none_or(|count| count >= self.limit) { self.overflow = true; return; }
        self.reverse.entry(input).or_default().insert(consumer); self.edges += 1;
    }
    /// Stage ONLY affected owners and their old/new reverse buckets. No clone or
    /// traversal of unrelated graph edges. Empty replacement retires an owner.
    pub fn prepare_resource_reads(&mut self, patch: ResourceReadPatch) -> Result<PreparedResourceReads<'_>, FullReasons> {
        if !self.complete || self.version().is_none() { return Err(FullReasons::UNKNOWN_DEPENDENCY); }
        if self.generation >= u64::MAX - 1 { return Err(FullReasons::CAPACITY); }
        if self.overflow || patch.overflow || patch.replacements.len() > self.limit { return Err(FullReasons::CAPACITY); }
        let mut edges = self.resources.edges;
        for (owner, inputs) in &patch.replacements {
            if !self.sites.contains(&owner.site) { return Err(FullReasons::UNKNOWN_DEPENDENCY); }
            edges = edges.checked_sub(self.resources.owners.get(owner).map_or(0, Vec::len)).and_then(|n| n.checked_add(inputs.len())).ok_or(FullReasons::CAPACITY)?;
        }
        if self.edges.checked_add(edges).is_none_or(|n| n > self.limit) { return Err(FullReasons::CAPACITY); }
        let mut buckets = std::collections::HashMap::new();
        for (owner, inputs) in &patch.replacements {
            for resource in self.resources.owners.get(owner).into_iter().flatten().chain(inputs) {
                if !buckets.contains_key(resource) {
                    buckets.try_reserve(1).map_err(|_| FullReasons::CAPACITY)?;
                    let original = self.resources.reverse.get(resource).map_or(&[][..], Vec::as_slice);
                    let mut consumers = Vec::new();
                    consumers.try_reserve(original.len()).map_err(|_| FullReasons::CAPACITY)?;
                    consumers.extend_from_slice(original); buckets.insert(*resource, consumers);
                }
            }
        }
        for (owner, inputs) in &patch.replacements {
            if let Some(previous) = self.resources.owners.get(owner) {
                for resource in previous {
                    let consumers = buckets.get_mut(resource).expect("old bucket staged");
                    if let Ok(index) = consumers.binary_search(owner) { consumers.remove(index); }
                }
            }
            for resource in inputs {
                let consumers = buckets.get_mut(resource).expect("new bucket staged");
                if let Err(index) = consumers.binary_search(owner) {
                    consumers.try_reserve(1).map_err(|_| FullReasons::CAPACITY)?;
                    consumers.insert(index, *owner);
                }
            }
        }
        // Reserving may grow metadata but cannot change accepted read edges.
        // Each commit insertion is now within admitted table capacity.
        self.resources.reverse.try_reserve(buckets.len()).map_err(|_| FullReasons::CAPACITY)?;
        self.resources.owners.try_reserve(patch.replacements.len()).map_err(|_| FullReasons::CAPACITY)?;
        Ok(PreparedResourceReads { graph: self, owners: patch.replacements, buckets, edges })
    }
    pub fn invalidate(&self, batch: &ChangeBatch) -> Invalidated {
        self.invalidate_entries(ClosureContext { owner: batch.stamp.to.owner, from: batch.stamp.from, to: Some(batch.stamp.to), surface: None, facts: None }, SnapshotSide::Both, batch.full, batch.entries.iter().copied(), &mut |_, _| Ok(()))
    }
    pub fn invalidate_pending(&self, journal: &Journal) -> Invalidated {
        self.invalidate_pending_side(journal, SnapshotSide::Both)
    }
    pub fn invalidate_pending_side(&self, journal: &Journal, side: SnapshotSide) -> Invalidated {
        self.invalidate_entries(ClosureContext { owner: journal.owner, from: journal.base, to: None, surface: None, facts: Some(journal.mutation) }, side, journal.full, journal.entries.values().copied(), &mut |_, _| Ok(()))
    }
    /// The SAME bounded queue owns dynamically discovered canonical group,
    /// resource and tile edges. The adapter emits neighbors, not another
    /// fixed-point authority. Stop on false; never materialize an unbounded list.
    pub fn invalidate_with(&self, batch: &ChangeBatch, mut expand: impl FnMut(DependencyNode, &mut dyn FnMut(DependencyNode) -> bool) -> Result<(), FullReasons>) -> Invalidated {
        self.invalidate_entries(ClosureContext { owner: batch.stamp.to.owner, from: batch.stamp.from, to: Some(batch.stamp.to), surface: None, facts: None }, SnapshotSide::Both, batch.full, batch.entries.iter().copied(), &mut expand)
    }
    pub fn invalidate_with_surface(&self, batch: &ChangeBatch, surface: SurfaceGeneration, mut expand: impl FnMut(DependencyNode, &mut dyn FnMut(DependencyNode) -> bool) -> Result<(), FullReasons>) -> Invalidated {
        self.invalidate_entries(ClosureContext { owner: batch.stamp.to.owner, from: batch.stamp.from, to: Some(batch.stamp.to), surface: Some(surface), facts: None }, SnapshotSide::Both, batch.full, batch.entries.iter().copied(), &mut expand)
    }
    fn invalidate_entries(&self, context: ClosureContext, side: SnapshotSide, mut full: FullReasons, entries: impl ExactSizeIterator<Item = Change>, expand: &mut impl FnMut(DependencyNode, &mut dyn FnMut(DependencyNode) -> bool) -> Result<(), FullReasons>) -> Invalidated {
        if self.snapshot != context.from { full = full.union(FullReasons::REVISION_GAP); }
        if self.overflow || entries.len() > self.limit { full = full.union(FullReasons::CAPACITY); }
        if !self.complete { full = full.union(FullReasons::UNKNOWN_DEPENDENCY); }
        if !full.is_empty() { return Invalidated { full, artifacts: BTreeSet::new(), basis: context, limit: self.limit, graphs: [self.version(), None] }; }
        let mut artifacts = BTreeSet::new(); let mut pending = Vec::new();
        // Deduplicate and cap BEFORE enqueue, not after pop. Both containers
        // together hold at most limit distinct artifacts, never an event log.
        fn enqueue(key: DependencyNode, context: ClosureContext, limit: usize, seen: &mut BTreeSet<DependencyNode>, queue: &mut Vec<DependencyNode>) -> Result<(), FullReasons> {
            let valid = match key {
                DependencyNode::Site(site) => site.site.owner == context.owner,
                DependencyNode::Group(group) => group.snapshot.owner == context.owner && (Some(group.snapshot) == context.from || Some(group.snapshot) == context.to),
                DependencyNode::Global { owner, .. } => owner == context.owner,
                DependencyNode::Resource(_) => true,
                DependencyNode::Tile(tile) => Some(tile.surface) == context.surface,
            };
            if !valid { return Err(FullReasons::REVISION_GAP); }
            if seen.contains(&key) { return Ok(()); }
            if seen.len() == limit { return Err(FullReasons::CAPACITY); }
            seen.insert(key); queue.push(key); Ok(())
        }
        for change in entries {
            if change.site.owner != context.owner { return Invalidated { full: FullReasons::REVISION_GAP, artifacts: BTreeSet::new(), basis: context, limit: self.limit, graphs: [self.version(), None] }; }
            if !self.sites.contains(&change.site) {
                // The OLD graph has no newly inserted site; the NEW graph has
                // no removed site. Both closures are consumed by the producer.
                let allowed = match side { SnapshotSide::Before => matches!(change.before, Support::Empty), SnapshotSide::After => matches!(change.after, Support::Empty), SnapshotSide::Both => matches!((change.before, change.after), (Support::Empty, Support::Empty)) };
                if allowed { continue; }
                return Invalidated { full: FullReasons::UNKNOWN_DEPENDENCY, artifacts: BTreeSet::new(), basis: context, limit: self.limit, graphs: [self.version(), None] };
            }
            for phase in change.facets.phases() {
                if let Err(reason) = enqueue(DependencyNode::Site(Artifact { site: change.site, phase }), context, self.limit, &mut artifacts, &mut pending) {
                    return Invalidated { full: reason, artifacts: BTreeSet::new(), basis: context, limit: self.limit, graphs: [self.version(), None] };
                }
            }
        }
        while let Some(key) = pending.pop() {
            if let DependencyNode::Site(site) = key {
                for phase in site.phase.downstream() {
                    if let Err(reason) = enqueue(DependencyNode::Site(Artifact { site: site.site, phase: *phase }), context, self.limit, &mut artifacts, &mut pending) {
                        return Invalidated { full: reason, artifacts: BTreeSet::new(), basis: context, limit: self.limit, graphs: [self.version(), None] };
                    }
                }
            }
            let mut rejected = FullReasons::default();
            let expanded = expand(key, &mut |neighbor| {
                match enqueue(neighbor, context, self.limit, &mut artifacts, &mut pending) {
                    Ok(()) => true, Err(reason) => { rejected = rejected.union(reason); false }
                }
            });
            if !rejected.is_empty() { return Invalidated { full: rejected, artifacts: BTreeSet::new(), basis: context, limit: self.limit, graphs: [self.version(), None] }; }
            if let Err(reason) = expanded { return Invalidated { full: reason, artifacts: BTreeSet::new(), basis: context, limit: self.limit, graphs: [self.version(), None] }; }
            if let DependencyNode::Resource(resource) = key {
                if let Some(consumers) = self.resources.reverse.get(&resource) {
                    for consumer in consumers {
                        if let Err(reason) = enqueue(DependencyNode::Site(*consumer), context, self.limit, &mut artifacts, &mut pending) {
                            return Invalidated { full: reason, artifacts: BTreeSet::new(), basis: context, limit: self.limit, graphs: [self.version(), None] };
                        }
                    }
                }
            }
            if let Some(consumers) = self.reverse.get(&key) {
                for consumer in consumers {
                    if let Err(reason) = enqueue(*consumer, context, self.limit, &mut artifacts, &mut pending) {
                        return Invalidated { full: reason, artifacts: BTreeSet::new(), basis: context, limit: self.limit, graphs: [self.version(), None] };
                    }
                }
            }
        }
        Invalidated { full, artifacts, basis: context, limit: self.limit, graphs: [self.version(), None] }
    }
}

/// Compact producer storage: owner is shared once by the scene header and rank
/// is the vector ordinal. `parent` is ONLY a structural index, never an identity.
#[derive(Clone, Debug)]
pub struct GroupSpan { pub local: NonZeroU64, pub parent: Option<u32>, pub draws: std::ops::Range<u32> }
#[derive(Debug)]
pub struct SceneGroups {
    revision: SceneRevision, source_epoch: u64, snapshot_epoch: u64,
    groups: Vec<GroupSpan>, draw_count: usize,
}
#[derive(Clone, Debug)]
pub struct OrderedGroup { pub site: SiteId, pub parent: Option<SiteId>, pub order: usize, pub draws: std::ops::Range<u32> }
impl SceneGroups {
    /// Validate complete own-command partition once, while publication is still
    /// fallible. Private fields prevent later source/header/range substitution.
    pub fn new(revision: SceneRevision, source_epoch: u64, snapshot_epoch: u64, groups: Vec<GroupSpan>, draw_count: usize) -> Option<Self> {
        let value = Self { revision, source_epoch, snapshot_epoch, groups, draw_count };
        value.valid_for(revision, source_epoch, snapshot_epoch, draw_count).then_some(value)
    }
    pub fn revision(&self) -> SceneRevision { self.revision }
    pub fn source_epoch(&self) -> u64 { self.source_epoch }
    pub fn snapshot_epoch(&self) -> u64 { self.snapshot_epoch }
    pub fn groups(&self) -> &[GroupSpan] { &self.groups }
    pub fn draw_count(&self) -> usize { self.draw_count }
    pub fn prepare_retarget(&mut self, stamp: BatchStamp) -> Result<PreparedGroups<'_>, ViewError> {
        if stamp.from != Some(self.revision) || stamp.to.owner != self.revision.owner { return Err(ViewError::Revision); }
        if stamp.to.sequence <= self.revision.sequence || stamp.source_epoch < self.source_epoch || stamp.snapshot_epoch <= self.snapshot_epoch { return Err(ViewError::Snapshot); }
        Ok(PreparedGroups { groups: self, stamp })
    }
    pub fn ordered(&self) -> impl ExactSizeIterator<Item = OrderedGroup> + '_ {
        self.groups.iter().enumerate().map(|(order, group)| OrderedGroup {
            site: SiteId::from_monotonic(self.revision.owner, group.local),
            parent: group.parent.and_then(|index| self.groups.get(index as usize))
                .map(|parent| SiteId::from_monotonic(self.revision.owner, parent.local)),
            order, draws: group.draws.clone(),
        })
    }
    /// Validate before consuming caller supplied metadata with an accepted scene.
    /// This checks structure/ranges, NOT Target/ACK or completed-image authority.
    pub fn valid_for(&self, revision: SceneRevision, source_epoch: u64, snapshot_epoch: u64, draw_count: usize) -> bool {
        if self.revision != revision || self.source_epoch != source_epoch || self.snapshot_epoch != snapshot_epoch || snapshot_epoch == 0 { return false; }
        let mut next = 0; let mut identities = BTreeSet::new(); let mut ancestors = Vec::new();
        for (index, group) in self.groups.iter().enumerate() {
            if group.parent.is_some_and(|parent| parent as usize >= index) || group.draws.start != next
                || group.draws.end < group.draws.start || !identities.insert(group.local) { return false; }
            if let Some(parent) = group.parent {
                while ancestors.last().copied() != Some(parent as usize) {
                    if ancestors.pop().is_none() { return false; }
                }
            } else { ancestors.clear(); }
            ancestors.push(index);
            next = group.draws.end;
        }
        next as usize == draw_count
    }
}

pub struct PreparedGroups<'a> { groups: &'a mut SceneGroups, stamp: BatchStamp }
impl PreparedGroups<'_> {
    pub fn commit(self) { self.groups.revision = self.stamp.to; self.groups.source_epoch = self.stamp.source_epoch; self.groups.snapshot_epoch = self.stamp.snapshot_epoch; }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::Rect;
    fn owner() -> NonZeroU64 { NonZeroU64::new(7).unwrap() }
    fn site(local: u64) -> SiteId { SiteId::from_monotonic(owner(), NonZeroU64::new(local).unwrap()) }
    fn revision(sequence: u64) -> SceneRevision { SceneRevision { owner: owner(), sequence: NonZeroU64::new(sequence).unwrap() } }
    fn stamp(from: Option<SceneRevision>, next: u64) -> BatchStamp { BatchStamp { from, to: revision(next), source_epoch: next, snapshot_epoch: next } }
    fn change(local: u64, facet: Facet) -> Change { Change { site: site(local), facets: Facets::one(facet), scope: Scope::Site, before: Support::Finite(Rect::new(0., 0., 1., 1.)), after: Support::Finite(Rect::new(2., 0., 1., 1.)) } }
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
        let mut later = change(1, Facet::Paint); later.before = Support::Empty; later.after = Support::Empty;
        journal.record(later); journal.record(change(2, Facet::Clip));
        let guard = journal.prepare(stamp(None, 1)).unwrap();
        assert!(guard.batch().full.contains(FullReasons::CAPACITY)); assert!(guard.batch().entries.is_empty()); assert_eq!(guard.batch().entries.capacity(),0);
        drop(guard);
        assert_eq!(journal.entries[&site(1)].before, change(1, Facet::Transform).before);
        assert_eq!(journal.entries[&site(1)].after, Support::Empty);
        assert!(journal.entries[&site(1)].facets.contains(Facet::Paint));
        journal.prepare(stamp(None, 1)).unwrap().commit(); assert_eq!(journal.base(), Some(revision(1)));
        assert!(matches!(journal.prepare(stamp(None, 2)), Err(PrepareError::Revision)));
    }
    #[test]
    fn completion_is_revoked_on_registration_and_full_paths_do_not_materialize_partial_work() {
        let mut graph = Dependencies::new(8); graph.reset(revision(1));
        graph.register_site(site(1)); assert!(graph.finish(1)); graph.register_site(site(2));
        let batch = ChangeBatch { stamp: stamp(Some(revision(1)), 2), full: FullReasons::default(), entries: vec![change(1, Facet::Paint)] };
        let dirty = graph.invalidate(&batch); assert!(dirty.full.contains(FullReasons::UNKNOWN_DEPENDENCY)); assert!(dirty.artifacts.is_empty());
        assert!(graph.finish(2));
        let batch = ChangeBatch { full: FullReasons::CAPACITY, ..batch };
        assert!(graph.invalidate(&batch).artifacts.is_empty());
    }
    #[test]
    fn resize_same_source_advances_c_and_snapshot_without_ack_or_source_epoch_forgery() {
        let mut journal = Journal::new(owner(), 8);
        journal.prepare(stamp(None, 1)).unwrap().commit();
        let mut resize = stamp(Some(revision(1)), 2); resize.source_epoch = 1;
        journal.prepare(resize).unwrap().commit();
        let mut bad = stamp(Some(revision(2)), 3); bad.snapshot_epoch = 2;
        assert!(matches!(journal.prepare(bad), Err(PrepareError::Revision)));
        bad.snapshot_epoch = 3; bad.source_epoch = 0;
        assert!(matches!(journal.prepare(bad), Err(PrepareError::Revision)));
    }
    #[test]
    fn inserted_removed_and_net_empty_use_validated_snapshot_sides_not_missing_site_guesses() {
        let mut before = Dependencies::new(64); before.reset(revision(1)); before.register_site(site(1)); before.finish(1);
        let mut after = Dependencies::new(64); after.reset(revision(1)); after.register_site(site(2)); after.finish(1);
        let mut journal = Journal::new(owner(), 8); journal.prepare(stamp(None, 1)).unwrap().commit();
        let mut inserted = change(2, Facet::Topology); inserted.before = Support::Empty; inserted.after = Support::Pending;
        let mut removed = change(1, Facet::Topology); removed.before = Support::Pending; removed.after = Support::Empty;
        journal.record(inserted); journal.record(removed);
        assert!(before.invalidate_pending_side(&journal, SnapshotSide::Before).full.is_empty());
        assert!(after.invalidate_pending_side(&journal, SnapshotSide::After).full.is_empty());
        let mut missing = change(3, Facet::Paint); missing.before = Support::Empty; journal.record(missing);
        assert!(after.invalidate_pending_side(&journal, SnapshotSide::After).full.contains(FullReasons::UNKNOWN_DEPENDENCY));
        missing.after = Support::Empty; journal.record(missing);
        assert!(after.invalidate_pending_side(&journal, SnapshotSide::After).full.is_empty());
    }
    #[test]
    fn publication_ticket_is_one_shot_and_failed_prepare_never_advances_namespace_or_c() {
        let mut issuer = FrameIssuer::new().unwrap(); let owner = issuer.owner();
        let rev = |n| SceneRevision { owner, sequence: NonZeroU64::new(n).unwrap() };
        let first = BatchStamp { from: None, to: rev(1), source_epoch: 0, snapshot_epoch: 1 };
        drop(issuer.prepare(first).unwrap()); let accepted = issuer.prepare(first).unwrap().commit(); assert_eq!(accepted.stamp(), first);
        assert!(matches!(issuer.prepare(first), Err(ViewError::Revision)));
        let resize = BatchStamp { from: Some(rev(1)), to: rev(2), source_epoch: 0, snapshot_epoch: 2 };
        issuer.prepare(resize).unwrap().commit();
        let wrong = BatchStamp { from: Some(rev(2)), to: revision(3), source_epoch: 0, snapshot_epoch: 3 };
        if wrong.to.owner != owner { assert!(matches!(issuer.prepare(wrong), Err(ViewError::ForeignOwner))); }
    }
    #[test]
    fn owned_group_partition_checks_preorder_once_and_retarget_drop_preserves_accepted_header() {
        let group = |id, parent, draws| GroupSpan { local: NonZeroU64::new(id).unwrap(), parent, draws };
        assert!(SceneGroups::new(revision(1), 1, 1, vec![group(1,None,0..1),group(2,None,1..2),group(3,Some(0),2..3)],3).is_none());
        let mut groups = SceneGroups::new(revision(1),1,1,vec![group(1,None,0..1),group(2,Some(0),1..2)],2).unwrap();
        drop(groups.prepare_retarget(stamp(Some(revision(1)),2)).unwrap()); assert_eq!(groups.revision(),revision(1));
        groups.prepare_retarget(stamp(Some(revision(1)),2)).unwrap().commit(); assert_eq!(groups.revision(),revision(2));
        assert!(groups.valid_for(revision(2),2,2,2)); assert!(!groups.valid_for(revision(2),1,2,2));
    }
    #[test]
    fn actual_reverse_edges_propagate_parent_layout_and_descendant_clip_but_not_shape_from_paint() {
        let mut graph = Dependencies::new(128); graph.reset(revision(1));
        graph.depends_on(Artifact { site: site(1), phase: Phase::Layout }, Artifact { site: site(2), phase: Phase::Layout });
        graph.depends_on(Artifact { site: site(3), phase: Phase::Clip }, Artifact { site: site(1), phase: Phase::Clip });
        assert!(graph.finish(3));
        let mut journal = Journal::new(owner(), 8); journal.prepare(stamp(None, 1)).unwrap().commit();
        journal.record(change(2, Facet::Layout)); let batch = journal.prepare(stamp(Some(revision(1)), 2)).unwrap().commit();
        let dirty = graph.invalidate(&batch);
        assert!(dirty.artifacts.contains(&DependencyNode::Site(Artifact { site: site(1), phase: Phase::Layout })));
        assert!(dirty.artifacts.contains(&DependencyNode::Site(Artifact { site: site(3), phase: Phase::Raster })));
        journal.record(change(2, Facet::Paint));
        let batch = journal.prepare(stamp(Some(revision(2)), 3)).unwrap().commit();
        let dirty = graph.invalidate(&batch); assert!(dirty.full.contains(FullReasons::REVISION_GAP));
        assert!(!dirty.artifacts.iter().any(|key| matches!(key, DependencyNode::Site(Artifact { phase: Phase::Shape, .. }))));
        assert!(!Facets::one(Facet::TextWidth).phases().any(|phase| phase == Phase::Shape));
    }
    #[test]
    fn owner_local_resource_reads_drop_replace_retire_and_share_one_bounded_queue() {
        let mut graph = Dependencies::new(32); graph.reset(revision(1));
        graph.register_site(site(1)); graph.register_site(site(2)); assert!(graph.finish(2));
        let mut domain = crate::resource::IdentityDomain::new().unwrap();
        let first = domain.mint().unwrap(); let second = domain.mint().unwrap();
        let consumer = Artifact { site: site(2), phase: Phase::Shape };
        let patch = |resource| { let mut patch = ResourceReadPatch::new(8); patch.replace(consumer, vec![resource]); patch };
        let batch = ChangeBatch { stamp: stamp(Some(revision(1)), 2), full: FullReasons::default(), entries: vec![change(1, Facet::Paint)] };
        let reaches = |graph: &Dependencies, resource| graph.invalidate_with(&batch, |node, emit| {
            if node == DependencyNode::Site(Artifact { site: site(1), phase: Phase::Material }) { emit(DependencyNode::Resource(resource)); }
            Ok(())
        }).artifacts.contains(&DependencyNode::Site(consumer));
        drop(graph.prepare_resource_reads(patch(first)).unwrap()); assert!(!reaches(&graph, first));
        graph.prepare_resource_reads(patch(first)).unwrap().commit(); assert!(reaches(&graph, first));
        drop(graph.prepare_resource_reads(patch(second)).unwrap()); assert!(reaches(&graph, first)); assert!(!reaches(&graph, second));
        graph.prepare_resource_reads(patch(second)).unwrap().commit(); assert!(!reaches(&graph, first)); assert!(reaches(&graph, second));
        graph.rebase(revision(2)); // Stable resource edges are not snapshot-local Group IDs.
        assert_eq!(graph.resources.edges, 1);
        let mut retire = ResourceReadPatch::new(8); retire.replace(consumer, Vec::new());
        graph.prepare_resource_reads(retire).unwrap().commit();
        assert!(graph.resources.reverse.is_empty()); assert!(graph.resources.owners.is_empty());
        let mut unknown = ResourceReadPatch::new(8); unknown.replace(Artifact { site: site(3), phase: Phase::Shape }, vec![first]);
        assert!(matches!(graph.prepare_resource_reads(unknown), Err(reason) if reason.contains(FullReasons::UNKNOWN_DEPENDENCY)));
    }

    #[test]
    fn resource_patch_budgets_include_raw_inputs_owner_records_and_later_base_edges() {
        let mut domain = crate::resource::IdentityDomain::new().unwrap();
        let a = domain.mint().unwrap(); let b = domain.mint().unwrap();
        let owner = Artifact { site: site(1), phase: Phase::Shape };
        let mut graph = Dependencies::new(4); graph.reset(revision(1)); graph.register_site(site(1)); assert!(graph.finish(1));
        let mut oversized = ResourceReadPatch::new(2); oversized.replace(owner, vec![a,a,a]);
        assert!(matches!(graph.prepare_resource_reads(oversized), Err(reason) if reason.contains(FullReasons::CAPACITY)));
        let mut patch = ResourceReadPatch::new(4); patch.replace(owner, vec![a,b]);
        graph.prepare_resource_reads(patch).unwrap().commit();
        for phase in [Phase::Measure, Phase::Layout, Phase::Placement] {
            graph.depends_on_node(DependencyNode::Site(Artifact { site: site(1), phase }), DependencyNode::Resource(a));
        }
        assert!(!graph.finish(1), "base mutation must count already installed resource edges");
        let mut small = Dependencies::new(2); small.reset(revision(1)); small.register_site(site(1)); assert!(small.finish(1));
        let mut too_many_owners = ResourceReadPatch::new(99);
        for phase in [Phase::Shape,Phase::Measure,Phase::Layout] {too_many_owners.replace(Artifact {site:site(1),phase},Vec::new());}
        assert!(matches!(small.prepare_resource_reads(too_many_owners), Err(reason) if reason.contains(FullReasons::CAPACITY)));
    }

    #[test]
    fn closed_receipt_binds_exact_pending_facts_and_preserves_them_on_drop() {
        let mut graph = Dependencies::new(64); graph.reset(revision(1)); graph.register_site(site(1)); assert!(graph.finish(1));
        let mut journal = Journal::new(owner(), 8); journal.prepare(stamp(None, 1)).unwrap().commit();
        journal.record(change(1, Facet::Paint));
        let closed = graph.invalidate_pending(&journal);
        drop(journal.prepare(stamp(Some(revision(1)), 2)).unwrap().with_closed(closed).unwrap());
        assert_eq!(journal.base(), Some(revision(1)));
        let closed = graph.invalidate_pending(&journal);
        let (batch, receipt) = journal.prepare(stamp(Some(revision(1)), 2)).unwrap().with_closed(closed).unwrap().commit_with_closure();
        let receipt = receipt.unwrap(); assert_eq!(receipt.stamp(), batch.stamp); assert!(receipt.full().is_empty());
        assert!(receipt.artifacts().contains(&DependencyNode::Site(Artifact {site:site(1),phase:Phase::Raster})));
        graph.rebase(revision(2));
        journal.record(change(1, Facet::Paint)); let stale = graph.invalidate_pending(&journal);
        journal.record(change(1, Facet::Paint)); // Same seed phases, different admitted fact generation.
        let guard = journal.prepare(stamp(Some(revision(2)), 3)).unwrap().with_closed(stale).unwrap();
        assert!(guard.batch().full.contains(FullReasons::UNKNOWN_DEPENDENCY));
    }
    #[test]
    fn merging_lower_budget_empty_closure_cannot_keep_oversized_existing_set() {
        let mut graph = Dependencies::new(64); graph.reset(revision(1)); graph.register_site(site(1)); assert!(graph.finish(1));
        let mut journal = Journal::new(owner(), 8); journal.prepare(stamp(None, 1)).unwrap().commit(); journal.record(change(1,Facet::Paint));
        let mut large = graph.invalidate_pending(&journal); assert!(large.artifacts.len() > 2);
        let small = Invalidated {full:FullReasons::default(),artifacts:BTreeSet::new(),basis:large.basis,limit:2,graphs:large.graphs};
        large.merge(small); assert!(large.full.contains(FullReasons::CAPACITY)); assert!(large.artifacts.is_empty());
    }

    #[test]
    fn material_admission_excludes_constraints_text_and_primitive_content_by_construction() {
        assert!(Facets::one(Facet::Paint).union(Facets::one(Facet::Semantics)).is_material_only());
        let paint = Facets::one(Facet::Paint).phases().collect::<Vec<_>>();
        assert!(paint.contains(&Phase::Material)); assert!(!paint.contains(&Phase::Primitive));

        for facet in [Facet::Topology,Facet::Layout,Facet::TextSource,Facet::TextPolicy,Facet::TextWidth,
            Facet::Transform,Facet::Clip,Facet::Stacking,Facet::ResourcePixels,Facet::ResourceMetrics,
            Facet::WidthConstraint,Facet::HeightConstraint,Facet::PrimitiveContent] {
            assert!(!Facets::one(Facet::Paint).union(Facets::one(facet)).is_material_only(), "{facet:?}");
        }
        let phases = Facets::one(Facet::PrimitiveContent).phases().collect::<Vec<_>>();
        assert!(phases.contains(&Phase::Primitive)); assert!(phases.contains(&Phase::Raster));
        assert!(!phases.contains(&Phase::Shape)); assert!(!phases.contains(&Phase::Layout));
    }

    #[test]
    fn closure_reuse_requires_exact_graph_domain_and_resource_read_generation() {
        let mut graph = Dependencies::new(64); graph.reset(revision(1)); graph.register_site(site(1)); assert!(graph.finish(1));
        let mut journal = Journal::new(owner(),8); journal.prepare(stamp(None,1)).unwrap().commit(); journal.record(change(1,Facet::Paint));
        let closed = graph.invalidate_pending(&journal);
        assert!(closed.matches_pending(&journal)); assert!(closed.matches_graphs(&graph,None));
        let mut foreign = Dependencies::new(64); foreign.reset(revision(1)); foreign.register_site(site(1)); assert!(foreign.finish(1));
        assert!(!closed.matches_graphs(&foreign,None),"same logical owner/base is not the same graph allocation domain");
        foreign.generation = u64::MAX;
        assert!(!closed.matches_graphs(&graph,Some(&foreign)),"invalid NEW graph is not absence of NEW graph");
        foreign.generation = 0; foreign.domain = None;
        assert!(!closed.matches_graphs(&graph,Some(&foreign)));

        let mut domain = crate::resource::IdentityDomain::new().unwrap(); let resource = domain.mint().unwrap();
        let mut patch = ResourceReadPatch::new(8); patch.replace(Artifact {site:site(1),phase:Phase::Shape},vec![resource]);
        drop(graph.prepare_resource_reads(patch).unwrap()); assert!(closed.matches_graphs(&graph,None));
        let mut patch = ResourceReadPatch::new(8); patch.replace(Artifact {site:site(1),phase:Phase::Shape},vec![resource]);
        graph.prepare_resource_reads(patch).unwrap().commit();
        assert!(closed.matches_pending(&journal)); assert!(!closed.matches_graphs(&graph,None),"read replacement changes provenance even without a journal write");
    }

    #[test]
    fn full_candidate_keeps_pending_failure_facts_but_retains_no_unusable_delta_vector() {
        let mut journal = Journal::new(owner(),128);
        for id in 1..=64 {journal.record(change(id,Facet::Topology));}
        let guard = journal.prepare(stamp(None,1)).unwrap();
        assert!(guard.batch().full.contains(FullReasons::INITIAL));
        assert_eq!(guard.batch().entries.capacity(),0); drop(guard);
        assert_eq!(journal.entries.len(),64,"failed/dropped preparation keeps original pending facts");
        let batch = journal.prepare(stamp(None,1)).unwrap().commit();
        assert!(batch.entries.is_empty());assert_eq!(batch.entries.capacity(),0);assert!(journal.entries.is_empty());
        journal.record(change(1,Facet::Paint));
        let batch = journal.prepare(stamp(Some(revision(1)),2)).unwrap().commit();
        assert!(batch.full.is_empty());assert_eq!(batch.entries.len(),1,"complete incremental delta still retained");
    }

}

/// Private producer brand. Fresh domains are globally unique; no raw-owner,
/// Clone, Default or deserialization constructor can recreate another issuer.
/// Sequence/source/snapshot advance only at infallible publication commit.
pub struct FrameIssuer { owner: NonZeroU64, last: Option<NonZeroU64>, source_epoch: u64, snapshot_epoch: u64 }
static NEXT_FRAME_OWNER: std::sync::atomic::AtomicU64 = std::sync::atomic::AtomicU64::new(1);
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum ViewError { ForeignOwner, Revision, Snapshot, Unbound }
/// One-shot proof of successful producer publication. NOT Clone/Copy: it is
/// consumed into exactly ONE canonical Canvas binding, never a reusable token.
#[derive(Debug)]
pub struct PublicationReceipt { stamp: BatchStamp }
impl PublicationReceipt { pub fn stamp(&self) -> BatchStamp { self.stamp } }
pub struct PreparedPublication<'a> { issuer: &'a mut FrameIssuer, stamp: BatchStamp }
impl FrameIssuer {
    pub fn new() -> Result<Self, Exhausted> {
        let owner = NEXT_FRAME_OWNER.fetch_update(std::sync::atomic::Ordering::Relaxed, std::sync::atomic::Ordering::Relaxed, |v| v.checked_add(1)).map_err(|_| Exhausted)?;
        Ok(Self { owner: NonZeroU64::new(owner).expect("owner starts nonzero"), last: None, source_epoch: 0, snapshot_epoch: 0 })
    }
    pub fn owner(&self) -> NonZeroU64 { self.owner }
    pub fn prepare(&mut self, stamp: BatchStamp) -> Result<PreparedPublication<'_>, ViewError> {
        let from = self.last.map(|sequence| SceneRevision { owner: self.owner, sequence });
        if stamp.to.owner != self.owner { return Err(ViewError::ForeignOwner); }
        if stamp.from != from || self.last.is_some_and(|last| stamp.to.sequence <= last) { return Err(ViewError::Revision); }
        if stamp.source_epoch < self.source_epoch || stamp.snapshot_epoch <= self.snapshot_epoch { return Err(ViewError::Snapshot); }
        Ok(PreparedPublication { issuer: self, stamp })
    }
}
impl PreparedPublication<'_> {
    pub fn stamp(&self) -> BatchStamp { self.stamp }
    /// Only after canonical C accepted. Drop retains the old issuer state.
    pub fn commit(self) -> PublicationReceipt {
        self.issuer.last = Some(self.stamp.to.sequence); self.issuer.source_epoch = self.stamp.source_epoch;
        self.issuer.snapshot_epoch = self.stamp.snapshot_epoch; PublicationReceipt { stamp: self.stamp }
    }
}
