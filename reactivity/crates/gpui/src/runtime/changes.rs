//! Canonical mutation producer and dependency consumer. No interaction names.
use super::*;
use gpui_reactivity_core::change::{Artifact, BatchStamp, Change, Dependencies, Facet, Facets, FullReasons, Phase, SceneRevision, Scope, SiteId, Support};

pub(super) fn same_transform(a: Affine, b: Affine) -> bool {
    [a.a,a.b,a.c,a.d,a.tx,a.ty].map(f32::to_bits) == [b.a,b.b,b.c,b.d,b.tx,b.ty].map(f32::to_bits)
}
pub(super) fn property_facets(id: crate::property::PropertyId) -> (Facets, Scope) {
    use crate::property::PropertyId::*;
    let (facet, scope) = match id {
        Width => (Facet::WidthConstraint, Scope::Site),
        Height => (Facet::HeightConstraint, Scope::Site),
        Gap | Padding | Flow | Align | Justify | Wrap => (Facet::Layout, Scope::Site),
        FontSize => (Facet::TextPolicy, Scope::Site),
        Foreground | Background => (Facet::Paint, Scope::Site),
        Transform => (Facet::Transform, Scope::Subtree),
        CornerRadius | Clip => (Facet::Clip, Scope::Subtree),
    };
    (Facets::one(facet), scope)
}
pub(super) fn register_node(graph: &mut Dependencies, owner: NonZeroU64, identity: NonZeroU64, parent: Option<u64>, text: bool, virtual_viewport: bool) {
    let site = SiteId::from_monotonic(owner, identity); graph.register_site(site);
    if virtual_viewport {
        // This intrinsic template reads its OWN explicit height and validates
        // padding/gap. It does not read world transforms, clipping or wrapping.
        graph.depends_on(Artifact { site, phase: Phase::Realize }, Artifact { site, phase: Phase::HeightConstraint });
        graph.depends_on(Artifact { site, phase: Phase::Realize }, Artifact { site, phase: Phase::BoxConstraint });
    }
    if text {
        graph.depends_on(Artifact { site, phase: Phase::TextLayout }, Artifact { site, phase: Phase::Layout });
    }
    if let Some(parent) = parent {
        let parent = SiteId::from_monotonic(owner, NonZeroU64::new(parent).expect("admitted parent identity"));
        let key = |site, phase| Artifact { site, phase };
        // Cephal owns cached parent/child LayoutInput answers and propagates
        // only changed observable answers (None/Overflow/Full). Mirroring both
        // directions here premarked the entire connected tree and defeated it.
        // Direct changed style/measure owners still enter LayoutTree's adapter,
        // including its immediate-parent style guard and cheap-leaf redirect.
        graph.depends_on(key(site, Phase::Placement), key(parent, Phase::Placement));
        graph.depends_on(key(site, Phase::Clip), key(parent, Phase::Clip));
    }
}
pub(super) fn dependency_snapshot(pending: &mut Option<Dependencies>, journal: &gpui_reactivity_core::change::Journal, owner: NonZeroU64) -> Dependencies {
    let mut graph = pending.take().unwrap_or_else(|| Dependencies::new(MAX_NODES * Phase::ALL.len()));
    if let Some(base) = journal.base() { graph.reset(base); } else { graph.reset_initial(owner); }
    graph
}
pub(super) fn record(journal: &mut gpui_reactivity_core::change::Journal, owner: NonZeroU64, identity: NonZeroU64, facets: Facets, scope: Scope, before: Support, after: Support) {
    journal.record(Change { site: SiteId::from_monotonic(owner, identity), facets, scope, before, after });
}
pub(super) fn close_dependencies(before: &Dependencies, after: Option<&Dependencies>, journal: &gpui_reactivity_core::change::Journal) -> gpui_reactivity_core::change::Invalidated {
    let side = if after.is_some() { gpui_reactivity_core::change::SnapshotSide::Before } else { gpui_reactivity_core::change::SnapshotSide::Both };
    let mut closed = before.invalidate_pending_side(journal, side);
    if let Some(after) = after { closed.merge(after.invalidate_pending_side(journal, gpui_reactivity_core::change::SnapshotSide::After)); }
    closed
}
pub(super) fn close_outputs(prior: gpui_reactivity_core::change::Invalidated, before: &Dependencies, after: Option<&Dependencies>, journal: &gpui_reactivity_core::change::Journal) -> gpui_reactivity_core::change::Invalidated {
    if prior.matches_pending(journal) && prior.matches_graphs(before, after) { return prior; }
    let full = prior.full();
    let mut next = close_dependencies(before, after, journal);
    next.require_full(full);
    next
}
pub(super) fn take_or_close(cache: &mut Option<gpui_reactivity_core::change::Invalidated>, before: &Dependencies, after: Option<&Dependencies>, journal: &gpui_reactivity_core::change::Journal) -> gpui_reactivity_core::change::Invalidated {
    match cache.take() {
        Some(closed) if closed.matches_pending(journal) && closed.matches_graphs(before, after) => closed,
        _ => close_dependencies(before, after, journal),
    }
}
impl<M: View + 'static> Runtime<M> {
    pub(super) fn observations_current(&mut self) -> Result<bool, Error> {
        #[cfg(not(feature = "source-observation-experiment"))]
        { Ok(!self.has_lists()) }
        #[cfg(feature = "source-observation-experiment")]
        match catch_unwind(AssertUnwindSafe(|| self.viewports.values().filter_map(ViewportState::list).all(|state|
            self.sources.observation_current(&self.model, &state.observation)))) {
            Ok(current) => Ok(current),
            Err(_) => { self.poison(); Err(Error::OwnerPanicked) }
        }
    }

    pub(super) fn record_decoration(&mut self, identity: u64) {
        if self.by_identity.contains(identity) && let Some(identity) = NonZeroU64::new(identity) {
            self.record_change(identity, Facets::one(Facet::PrimitiveContent).union(Facets::one(Facet::Semantics)), Scope::Site, Support::Pending, Support::Pending);
        }
    }

    pub(super) fn canonical_site(&self, index: usize) -> SiteId {
        SiteId::from_monotonic(self.sites.namespace(), self.nodes[index].identity)
    }
    pub(super) fn record_change(&mut self, identity: NonZeroU64, facets: Facets, scope: Scope, before: Support, after: Support) {
        self.changes.record(Change { site: SiteId::from_monotonic(self.sites.namespace(), identity), facets, scope, before, after });
    }
    pub(super) fn change_stamp(&self, token: PresentationToken) -> BatchStamp {
        BatchStamp { from: self.changes.base(), to: SceneRevision { owner: token.window, sequence: token.sequence }, source_epoch: self.source_epoch, snapshot_epoch: token.sequence.get() }
    }
    /// Existing direct sinks are still admitted normally. This graph consumes
    /// their canonical facts and extends invalidation through actual OLD and
    /// NEW parent/read edges; no source/case name selects a special path.
    pub(super) fn requires_realization(&mut self, observe_untracked: bool) -> Result<bool, Error> {
        let closed = take_or_close(&mut self.pending_closure, &self.dependencies, self.pending_dependencies.as_ref(), &self.changes);
        let realize = !closed.full().is_empty() || closed.artifacts().iter().any(|key|
            matches!(key, gpui_reactivity_core::change::DependencyNode::Site(Artifact { phase: Phase::Realize, .. })))
            || (observe_untracked && !self.observations_current()?);
        self.pending_closure = Some(closed);
        Ok(realize)
    }
    pub(super) fn consume_dependencies(&mut self) -> gpui_reactivity_core::change::Invalidated {
        let invalidated = take_or_close(&mut self.pending_closure, &self.dependencies, self.pending_dependencies.as_ref(), &self.changes);
        #[cfg(test)]
        { self.last_input_closure_artifacts = invalidated.artifacts().len(); }
        if !invalidated.full().is_empty() {
            self.changes.full(invalidated.full());
            self.rebuild_layout = true;
            return invalidated;
        }
        for key in invalidated.artifacts() {
            let gpui_reactivity_core::change::DependencyNode::Site(key) = *key else { continue };
            if matches!(key.phase, Phase::TextLayout | Phase::Measure | Phase::Layout)
                && self.by_identity.contains(key.site.local.get())
            { self.layout_dirty.insert(key.site.local.get()); }
        }
        invalidated
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn late_valid_output_facts_cannot_erase_an_earlier_unknown_mapping_reason() {
        let owner=NonZeroU64::new(9002).unwrap();
        let revision=SceneRevision { owner,sequence:NonZeroU64::new(1).unwrap() };
        let mut journal=gpui_reactivity_core::change::Journal::new(owner,32);
        journal.prepare(BatchStamp { from:None,to:revision,source_epoch:1,snapshot_epoch:1 }).unwrap().commit();
        let mut graph=Dependencies::new(128);graph.reset(revision);
        let identity=NonZeroU64::new(1).unwrap();register_node(&mut graph,owner,identity,None,false,false);assert!(graph.finish(1));
        record(&mut journal,owner,identity,Facets::one(Facet::Paint),Scope::Site,Support::Pending,Support::Pending);
        let mut prior=close_dependencies(&graph,None,&journal);
        assert!(prior.full().is_empty());
        prior.require_full(FullReasons::UNKNOWN_DEPENDENCY);
        record(&mut journal,owner,identity,Facets::one(Facet::Hit),Scope::Site,Support::Pending,Support::Pending);
        let next=close_outputs(prior,&graph,None,&journal);
        assert!(next.full().contains(FullReasons::UNKNOWN_DEPENDENCY));
        assert!(next.artifacts().is_empty());
    }

    #[test]
    fn intrinsic_viewport_dependencies_read_own_constraints_not_world_placement() {
        let owner = NonZeroU64::new(9001).unwrap();
        let revision = SceneRevision { owner, sequence: NonZeroU64::new(1).unwrap() };
        let mut graph = Dependencies::new(512); graph.reset(revision);
        register_node(&mut graph, owner, NonZeroU64::new(1).unwrap(), None, false, false);
        register_node(&mut graph, owner, NonZeroU64::new(2).unwrap(), Some(1), false, true);
        assert!(graph.finish(2));
        let site = |id| SiteId::from_monotonic(owner, NonZeroU64::new(id).unwrap());
        for (id, facet, expected) in [
            (1, Facet::Transform, false), (1, Facet::Clip, false),
            (1, Facet::Layout, false), (2, Facet::Paint, false),
            (2, Facet::WidthConstraint, false), (2, Facet::HeightConstraint, true),
            (2, Facet::Layout, true),
        ] {
            let batch = gpui_reactivity_core::change::ChangeBatch {
                stamp: BatchStamp { from: Some(revision), to: SceneRevision { owner, sequence: NonZeroU64::new(2).unwrap() }, source_epoch: 2, snapshot_epoch: 2 },
                full: FullReasons::default(),
                entries: vec![Change { site: site(id), facets: Facets::one(facet), scope: Scope::Site, before: Support::Pending, after: Support::Pending }],
            };
            let result = graph.invalidate(&batch);
            assert!(result.full().is_empty());
            assert_eq!(result.artifacts().contains(&gpui_reactivity_core::change::DependencyNode::Site(Artifact { site: site(2), phase: Phase::Realize })), expected, "{id} {facet:?}");
            if facet == Facet::WidthConstraint {
                assert!(result.artifacts().contains(&gpui_reactivity_core::change::DependencyNode::Site(Artifact { site: site(2), phase: Phase::TextLayout })));
                assert!(!result.artifacts().iter().any(|key| matches!(key, gpui_reactivity_core::change::DependencyNode::Site(Artifact { phase: Phase::Shape, .. }))));
            }
        }
    }
}
