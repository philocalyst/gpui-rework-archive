//! Sparse first-write history relative to accepted C, never P or a failed solve.
use std::collections::BTreeMap;
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
}
impl LayoutWrites {
    pub fn new(limit: usize) -> Self { Self { limit: limit.min(MAX_ENTRIES), entries: BTreeMap::new(), incomplete: false } }
    pub fn record(&mut self, id: NodeId, before: Layout, after: Layout) {
        if let Some(write) = self.entries.get_mut(&id) { write.after = after; return; }
        // A known gap already requires full canonical fallback. Preserve any
        // earlier records, but do not materialize unusable new partial history.
        if self.incomplete { return; }
        if self.entries.len() == self.limit { self.incomplete = true; return; }
        self.entries.insert(id, Write { before, after });
    }
    pub fn invalidate(&mut self) { self.incomplete = true; }
    pub fn incomplete(&self) -> bool { self.incomplete }
    pub fn entries(&self) -> impl Iterator<Item=(NodeId, &Write)> { self.entries.iter().map(|(id,write)| (*id,write)) }
    /// Called only after a successful canonical Canvas publication.
    pub fn published(&mut self) { self.entries.clear(); self.incomplete = false; }
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
