//! Test-only observation of the existing structural boundary. No journal adapter.
use super::*;
use serde_json::json;
#[derive(Default, Clone, Copy, serde::Serialize)]
pub(super) struct Work {
    pub reconciled: usize,
    pub survived: usize,
    pub minted: usize,
    pub relocated: usize,
    pub identity_index_input: usize,
    pub layout_insertions: usize,
    pub layout_full_rebuilds: usize,
    pub layout_rebuild_reason_bits: u8,
    pub layout_discarded_handles: usize,
    pub layout_style_calls: usize,
    pub layout_explicit_dirty_calls: usize,
    pub layout_parent_flow_checks: usize,
    pub layout_computes: u64,
    pub layout_computed_answers: u64,
    pub layout_cached_answers: u64,
    pub layout_cheap_answers: u64,
    pub layout_measure_queries: u64,
    pub layout_changed_writes: u64,
    pub paint_nodes: usize,
    pub image_reconcile_entries: usize,
}
impl<M: View + 'static> Win<M> {
    pub(crate) fn structural_reset(&mut self) {
        self.runtime_mut().unwrap().structural_work = Work::default();
        #[cfg(feature = "layout-preservation-lab")]
        {
            self.runtime_mut().unwrap().layout_preservation.work = Default::default();
        }
        self.reset_counters().unwrap();
    }
    pub(crate) fn structural_observation(&self) -> serde_json::Value {
        let r = self.runtime().unwrap();
        let logical: Vec<_> = r.nodes.iter().enumerate().map(|(i,n)| {
            json!({"index":i,"identity":n.identity(),"parent":n.parent().index(),"kind":format!("{:?}",n.kind()),"row_key":r.list_rows.get(&n.identity()).map(|row| row.key.get())})
        }).collect();
        let (index_kind, index_bytes) = match &r.by_identity {
            IdentityIndex::Contiguous { .. } => ("contiguous", 0),
            IdentityIndex::Runs(v) => ("runs", std::mem::size_of_val(&**v)),
            IdentityIndex::Indexed(v) => ("indexed", std::mem::size_of_val(&**v)),
        };
        json!({"semantic_emission":r.semantic_emission.report(r),"ordered_cold_extents":r.ordered_cold_extents.report(),"cold_correspondence":r.cold_correspondence.report(),"raw_node_vec_header_bytes":std::mem::size_of::<Vec<Node>>(),"logical":logical,"work":r.structural_work,"counters":r.counters,"node_bytes":std::mem::size_of::<Node>(),"node_capacity_bytes":r.nodes.capacity()*std::mem::size_of::<Node>(),"presented_capacity_bytes":r.presented.capacity()*std::mem::size_of::<Presented>(),"layout_id_capacity_bytes":r.layout_nodes.capacity()*std::mem::size_of::<NodeId>(),"identity_index_kind":index_kind,"identity_index_heap_bytes":index_bytes,"pending":format!("{:?}",r.latest_token),"source_epoch":r.source_epoch,"complete_epoch":r.complete_epoch,"presentation_epoch":r.presentation_epoch})
    }
}

// Full diagnostic captures; none are consulted by the producer or layout engine.
struct LayoutRow {
    identity: u64,
    id: NodeId,
    parent: Option<NodeId>,
    children: Vec<NodeId>,
    style: cephal::Style,
    layout: cephal::Layout,
    measured: bool,
}
pub(crate) struct LayoutCapture {
    rows: Vec<LayoutRow>,
    storage: gpui_reactivity_core::layout::LayoutStorage,
    topology_bytes: usize,
    runtime_handle_capacity: usize,
    epochs: [u64; 3],
}
impl LayoutCapture {
    #[cfg(feature = "layout-preservation-lab")]
    pub(crate) fn assert_equivalent(&self, other: &Self) {
        assert_eq!(self.rows.len(), other.rows.len());
        let ranks = |rows: &[LayoutRow]| {
            rows.iter()
                .enumerate()
                .map(|(i, r)| (r.id, i))
                .collect::<BTreeMap<_, _>>()
        };
        let a = ranks(&self.rows);
        let b = ranks(&other.rows);
        for (x, y) in self.rows.iter().zip(&other.rows) {
            assert_eq!(x.style, y.style);
            assert_eq!(x.layout, y.layout);
            assert_eq!(x.measured, y.measured);
            assert_eq!(x.parent.map(|p| a[&p]), y.parent.map(|p| b[&p]));
            assert_eq!(
                x.children.iter().map(|p| a[p]).collect::<Vec<_>>(),
                y.children.iter().map(|p| b[p]).collect::<Vec<_>>()
            );
        }
    }
    #[cfg(feature = "layout-preservation-lab")]
    pub(crate) fn assert_retired<M: View + 'static>(&self, owner: &Win<M>) -> usize {
        let r = owner.runtime().unwrap();
        let mut retired = 0;
        for row in &self.rows {
            if !r.by_identity.contains(row.identity) {
                assert!(
                    !r.layout.tree().contains(row.id),
                    "removed generation remains valid"
                );
                retired += 1;
            }
        }
        retired
    }

    pub(crate) fn report(&self) -> serde_json::Value {
        let rows:Vec<_>=self.rows.iter().map(|r| json!({"identity":r.identity,"handle":format!("{:?}",r.id),"parent":r.parent.map(|id|format!("{id:?}")),"children":r.children.iter().map(|id|format!("{id:?}")).collect::<Vec<_>>(),"style":format!("{:?}",r.style),"layout":format!("{:?}",r.layout),"measured":r.measured})).collect();
        let storage = self.storage;
        json!({"epochs":self.epochs,"rows":rows,"preorder_handles_sorted":self.rows.iter().map(|r|r.id).is_sorted(),"storage":{"slots":storage.slots,"active_styles":storage.active_styles,"allocated_caches":storage.allocated_caches,"lane_capacity_bytes":storage.lane_capacity_bytes,"cache_heap_bytes":storage.cache_heap_bytes,"absolute_contexts":storage.absolute_contexts,"layout_header_bytes":size_of::<LayoutTree>(),"topology_bytes":self.topology_bytes,"runtime_handle_capacity_bytes":self.runtime_handle_capacity},"diagnostic":{"row_visits":self.rows.len(),"child_edges":self.rows.iter().map(|r|r.children.len()).sum::<usize>(),"storage_cache_scan_passes":2,"row_bytes":size_of::<LayoutRow>(),"capture_header_bytes":size_of::<Self>(),"row_capacity_bytes":self.rows.capacity()*size_of::<LayoutRow>(),"children_capacity_bytes":self.rows.iter().map(|r|r.children.capacity()*size_of::<NodeId>()).sum::<usize>(),"exclusions":"Style internal allocations, JSON/String formatting and comparison maps are additional; allocation counter captures requested bytes"}})
    }
    pub(crate) fn compare(&self, old: &Self) -> serde_json::Value {
        let before: BTreeMap<_, _> = old.rows.iter().map(|r| (r.identity, r)).collect();
        let new_ids: BTreeSet<_> = self.rows.iter().map(|r| r.identity).collect();
        let mut projected = Vec::new();
        let matches:Vec<_>=self.rows.iter().enumerate().filter_map(|(rank,after)|{
            let prior=before.get(&after.identity)?;
            projected.push(prior.id);
            Some(json!({"identity":after.identity,"new_rank":rank,"same_handle":prior.id==after.id,"same_own_style":prior.style==after.style,"same_layout":prior.layout==after.layout,"old_handle":format!("{:?}",prior.id),"new_handle":format!("{:?}",after.id),"old_layout":format!("{:?}",prior.layout),"new_layout":format!("{:?}",after.layout)}))
        }).collect();
        json!({"semantic_matches":matches,"survived":projected.len(),"minted":self.rows.len()-projected.len(),"removed":old.rows.iter().filter(|r|!new_ids.contains(&r.identity)).count(),"projected_old_survivor_handles_sorted_in_new_preorder":projected.is_sorted(),"scope":"offline diagnostic identity pairing only; not a layout reuse certificate or optimized mirror diff","comparison_work":{"old_map_inserts":old.rows.len(),"new_set_inserts":self.rows.len(),"new_lookups":self.rows.len(),"old_membership_checks":old.rows.len(),"projected_capacity_bytes":projected.capacity()*size_of::<NodeId>()}})
    }
}
impl<M: View + 'static> Win<M> {
    pub(crate) fn layout_capture(&self) -> LayoutCapture {
        let r = self.runtime().unwrap();
        assert!(r.logical_valid && !r.layout.is_poisoned());
        assert_eq!(r.nodes.len(), r.layout_nodes.len());
        let rows = r
            .nodes
            .iter()
            .zip(&r.layout_nodes)
            .map(|(node, &id)| LayoutRow {
                identity: node.identity(),
                id,
                parent: r.layout.tree().parent(id).unwrap(),
                children: r.layout.tree().children(Some(id)).unwrap().collect(),
                style: r.layout.style(id).unwrap().clone(),
                layout: r.layout.layout(id).unwrap(),
                measured: node.text_slot().0 != u32::MAX || node.kind() == NodeKind::Image,
            })
            .collect();
        LayoutCapture {
            rows,
            storage: r.layout.storage(),
            topology_bytes: r.layout.tree().allocated_bytes(),
            runtime_handle_capacity: r.layout_nodes.capacity() * size_of::<NodeId>(),
            epochs: [r.source_epoch, r.complete_epoch, r.presentation_epoch],
        }
    }
}
