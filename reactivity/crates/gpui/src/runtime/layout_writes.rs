//! Sparse first-write history relative to accepted C, never P or a failed solve.
use std::collections::{BTreeMap, BTreeSet};
use gpui_reactivity_core::{NodeId, layout::Layout};

// Internal optional-evidence policy budget, not an algorithmic threshold or
// application resource quota. There is no existing layout-evidence limits
// configuration to reuse. Larger
// updates fall back to complete preparation instead of retaining N layouts.
pub(super) const MAX_ENTRIES: usize = 64;
const ENTRY_PAYLOAD_BYTES: usize = std::mem::size_of::<(NodeId, Write)>();
const _: () = assert!(ENTRY_PAYLOAD_BYTES * MAX_ENTRIES <= 16 * 1024);

#[derive(Clone, Copy, Debug)]
pub(super) struct Write { pub before: Layout, pub after: Layout }
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub(super) struct Channels { pub location: bool, pub size: bool, pub content: bool, pub overflow: bool, pub order: bool }
impl Write {
    /// Own canonical geometry always changes; only an active outgoing clip
    /// depends on this box's extent. Parent size alone is not child placement.
    pub fn output_facets(&self, active_clip: bool) -> (gpui_reactivity_core::change::Facets, gpui_reactivity_core::change::Scope) {
        use gpui_reactivity_core::change::{Facet, Facets, Scope};
        let channels=self.channels();
        let mut facets=Facets::one(Facet::PrimitiveContent);let mut scope=Scope::Site;
        if channels.location { facets=facets.union(Facets::one(Facet::Transform));scope=Scope::Subtree; }
        if active_clip && (channels.size || channels.content || channels.overflow) {
            facets=facets.union(Facets::one(Facet::Clip));scope=Scope::Subtree;
        }
        if channels.order { facets=facets.union(Facets::one(Facet::Stacking));scope=Scope::Subtree; }
        if self.before.content_box_width()!=self.after.content_box_width() { facets=facets.union(Facets::one(Facet::TextWidth)); }
        (facets,scope)
    }
    pub fn channels(&self) -> Channels { Channels {
        location: self.before.location != self.after.location,
        size: self.before.size != self.after.size,
        content: self.before.border != self.after.border || self.before.padding != self.after.padding || self.before.margin != self.after.margin || self.before.scrollbar_size != self.after.scrollbar_size,
        overflow: self.before.scrollable_overflow_rect != self.after.scrollable_overflow_rect,
        order: self.before.order != self.after.order,
    } }
}
pub(super) struct LayoutWrites {
    limit: usize,
    entries: BTreeMap<NodeId, Write>,
    incomplete: bool,
    answers: BTreeSet<NodeId>,
    answer_incomplete: bool,
}
impl LayoutWrites {
    pub fn new(limit: usize) -> Self { Self { limit: limit.min(MAX_ENTRIES), entries: BTreeMap::new(), incomplete: false, answers: BTreeSet::new(), answer_incomplete: false } }
    pub fn record(&mut self, id: NodeId, before: Layout, after: Layout) {
        if let Some(write) = self.entries.get_mut(&id) { write.after = after; return; }
        // A known gap already requires full canonical fallback. Preserve any
        // earlier records, but do not materialize unusable new partial history.
        if self.incomplete { return; }
        if self.entries.len() + self.answers.len() == self.limit { self.incomplete = true; return; }
        self.entries.insert(id, Write { before, after });
    }
    pub fn invalidate(&mut self) { self.incomplete = true; }
    pub fn answer_sites(&self) -> impl Iterator<Item=NodeId> + '_ { self.answers.iter().copied() }
    pub fn incomplete(&self) -> bool { self.incomplete || self.answer_incomplete }
    pub fn entries(&self) -> impl Iterator<Item=(NodeId, &Write)> { self.entries.iter().map(|(id,write)| (*id,write)) }
    /// Called only after a successful canonical Canvas publication.
    pub fn published(&mut self) { self.entries.clear(); self.answers.clear(); self.incomplete = false; self.answer_incomplete = false; }
}

impl gpui_reactivity_core::layout::LayoutObserver for LayoutWrites {
    fn layout_changed(&mut self, id: NodeId, before: Layout, after: Layout) { self.record(id, before, after); }
    fn answer_changed(&mut self, id: NodeId, before: cephal::tree::LayoutOutput, after: cephal::tree::LayoutOutput) {
        if before == after || self.answers.contains(&id) || self.incomplete || self.answer_incomplete { return; }
        if self.entries.len() + self.answers.len() == self.limit { self.invalidate(); return; }
        self.answers.insert(id);
    }
    fn answer_gap(&mut self, _id: NodeId) { self.answer_incomplete = true; }
}

#[cfg(test)]
mod tests {
    use super::*;
    use gpui_reactivity_core::{NodeKind, layout::{LayoutTree, Style}};
    #[test]
    fn earliest_old_survives_failed_work_and_overflow_until_actual_publication() {
        let mut tree = LayoutTree::new();
        let a = tree.insert(None, NodeKind::Element, Style::DEFAULT).unwrap();
        let b = tree.insert(None, NodeKind::Element, Style::DEFAULT).unwrap();
        let old = tree.layout(a).unwrap();
        let mut failed_two = old; failed_two.size.width = 20.;
        let mut failed_three = old; failed_three.size.width = 30.;
        let mut repaired = old; repaired.size.width = 40.;
        let mut writes = LayoutWrites::new(1);
        writes.invalidate();
        writes.record(a, old, failed_two);
        assert_eq!(writes.entries().count(), 0,"known full rebuild must not allocate unusable partial history");
        writes.published();
        writes.record(a, old, failed_two);
        // Failure, dropped work and old ACK have no operation on this journal.
        writes.record(a, failed_two, failed_three);
        writes.record(b, old, failed_three);
        assert!(writes.incomplete());
        for _ in 0..100 { writes.record(b, old, failed_three); }
        assert_eq!(writes.entries().count(), 1,"overflow cannot allocate fresh history on repeated failed turns");
        writes.record(a, failed_three, repaired);
        let (id, actual) = writes.entries().next().unwrap();
        assert_eq!(id, a); assert_eq!(actual.before, old); assert_eq!(actual.after, repaired);
        assert_eq!(writes.entries().count(), 1);
        writes.published();
        assert!(!writes.incomplete()); assert_eq!(writes.entries().count(), 0);
        writes.record(b, repaired, old);
        assert_eq!(writes.entries().count(), 1,"successful C resets the optional tracking budget");
        eprintln!("layout evidence entry payload={} bytes; policy entries={}; BTree allocation overhead excluded", ENTRY_PAYLOAD_BYTES, MAX_ENTRIES);
    }
}

#[cfg(test)]
mod answer_tests {
    use super::*;
    use gpui_reactivity_core::{NodeKind, layout::{LayoutObserver, LayoutTree, Style}};
    #[test]
    fn baseline_only_answer_is_recorded_and_shares_the_bounded_policy() {
        let mut tree=LayoutTree::new();
        let node=tree.insert(None,NodeKind::Element,Style::DEFAULT).unwrap();
        let old=cephal::tree::LayoutOutput::HIDDEN;
        let mut new=old;new.baselines=cephal::tree::Baselines::from_first(Some(7.));
        let mut evidence=LayoutWrites::new(1);
        evidence.answer_changed(node,old,new);
        assert_eq!(evidence.entries().count(),0);
        assert_eq!(evidence.answer_sites().collect::<Vec<_>>(),vec![node]);
        let layout=tree.layout(node).unwrap();
        evidence.record(node,layout,layout);
        assert!(evidence.incomplete(),"answer and final-write cells share one budget");
        evidence.published();
        evidence.answer_gap(node);
        evidence.answer_changed(node,old,new);
        assert_eq!(evidence.answer_sites().count(),0);
        assert!(evidence.incomplete());
    }
}

#[cfg(test)]
mod output_tests {
    use super::*;
    use gpui_reactivity_core::change::{Facet,Scope};
    #[test]
    fn extent_and_content_affect_own_primitive_but_only_active_outgoing_clip_propagates() {
        let mut before=Layout::ZERO;before.size.width=100.;before.size.height=40.;
        let mut after=before;after.size.width=40.;
        let write=Write{before,after};
        let (plain,scope)=write.output_facets(false);
        assert!(plain.contains(Facet::PrimitiveContent));assert!(plain.contains(Facet::TextWidth));
        assert!(!plain.contains(Facet::Transform));assert!(!plain.contains(Facet::Clip));assert_eq!(scope,Scope::Site);
        let (clipped,scope)=write.output_facets(true);
        assert!(clipped.contains(Facet::PrimitiveContent));assert!(clipped.contains(Facet::Clip));assert_eq!(scope,Scope::Subtree);
        let mut inset=before;inset.padding.left=7.;
        let (content,_)=Write{before,after:inset}.output_facets(false);
        assert!(content.contains(Facet::PrimitiveContent));assert!(content.contains(Facet::TextWidth));assert!(!content.contains(Facet::Transform));
        let mut moved=before;moved.location.x=7.;
        let (location,scope)=Write{before,after:moved}.output_facets(false);
        assert!(location.contains(Facet::Transform));assert_eq!(scope,Scope::Subtree);
    }
}
