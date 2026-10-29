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
    pub paint_nodes: usize,
    pub image_reconcile_entries: usize,
}
impl<M: View + 'static> Win<M> {
    pub(crate) fn structural_reset(&mut self) {
        self.runtime_mut().unwrap().structural_work = Work::default();
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
        json!({"logical":logical,"work":r.structural_work,"counters":r.counters,"node_bytes":std::mem::size_of::<Node>(),"node_capacity_bytes":r.nodes.capacity()*std::mem::size_of::<Node>(),"presented_capacity_bytes":r.presented.capacity()*std::mem::size_of::<Presented>(),"layout_id_capacity_bytes":r.layout_nodes.capacity()*std::mem::size_of::<NodeId>(),"identity_index_kind":index_kind,"identity_index_heap_bytes":index_bytes,"pending":format!("{:?}",r.latest_token),"source_epoch":r.source_epoch,"complete_epoch":r.complete_epoch,"presentation_epoch":r.presentation_epoch})
    }
}
