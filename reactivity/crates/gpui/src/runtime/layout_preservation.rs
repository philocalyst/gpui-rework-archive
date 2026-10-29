//! Isolated optional experiment: correspondence preserves capabilities, not outputs.
use super::*;
const NEW: u32 = u32::MAX;
#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
pub(crate) enum Mode {
    #[cfg(test)]
    Automatic,
    #[default]
    Ordered,
    #[allow(dead_code)] // Selected only by the local comparison harness.
    Append,
    Forced,
}
#[derive(Clone, Copy, Debug, Default, Serialize)]
pub(super) struct Work {
    pub correspondence_checks: usize,
    pub prefix_materialized: usize,
    pub plan_allocations: usize,
    pub rank_writes: usize,
    pub plan_peak_bytes: usize,
    pub plan_staged: usize,
    pub plan_attempts: usize,
    pub authority_declines: usize,
    pub preflight_nodes: usize,
    pub removal_checks: usize,
    pub removed_nodes: usize,
    pub inserted_nodes: usize,
    pub preserved_nodes: usize,
    pub new_handle_writes: usize,
    pub handle_scratch_bytes: usize,
    pub sibling_checks: usize,
    pub frontier_pushes: usize,
    pub frontier_pops: usize,
    pub frontier_peak_bytes: usize,
    pub order_calls: u64,
    pub validation_ancestors: u64,
    pub sibling_relinks: u64,
    pub context_ancestors: u64,
    pub depth_nodes: u64,
    pub route_rows: usize,
    pub route_sort_compares: usize,
    pub route_lookups: usize,
    pub route_lookup_compares: usize,
    pub dirty_identity_checks: usize,
    pub retired_dirty_ids: usize,
    pub committed: usize,
    pub invalidated: usize,
}
#[derive(Clone, Copy)]
struct Authority {
    token: PresentationToken,
    root: NodeId,
    len: usize,
}
struct Plan {
    predecessor: Authority,
    complete: u64,
    source: u64,
    ranks: Vec<u32>,
    used: Vec<u64>,
}
impl Plan {
    fn used(&self, rank: usize) -> bool {
        self.used[rank / 64] & (1 << (rank % 64)) != 0
    }
    fn bytes(&self) -> usize {
        size_of::<Self>() + self.ranks.capacity() * 4 + self.used.capacity() * 8
    }
}
pub(super) struct Builder {
    predecessor: Authority,
    complete: u64,
    source: u64,
    new_len: usize,
    plan: Option<Plan>,
}
impl Builder {
    pub(super) fn record(&mut self, rank: usize, old: Option<usize>, work: &mut Work) {
        work.correspondence_checks += 1;
        if self.plan.is_none() && (self.new_len != self.predecessor.len || old != Some(rank)) {
            let mut plan = Plan {
                predecessor: self.predecessor,
                complete: self.complete,
                source: self.source,
                ranks: Vec::with_capacity(self.new_len),
                used: vec![0; self.predecessor.len.div_ceil(64)],
            };
            for i in 0..rank {
                plan.ranks.push(i as u32);
                plan.used[i / 64] |= 1 << (i % 64);
            }
            work.plan_allocations += 2;
            work.prefix_materialized += rank;
            work.rank_writes += rank;
            self.plan = Some(plan);
        }
        if let Some(plan) = &mut self.plan {
            assert_eq!(plan.ranks.len(), rank);
            if let Some(old) = old {
                assert!(
                    old < self.predecessor.len && !plan.used(old),
                    "actual reconciliation match is unique"
                );
                plan.used[old / 64] |= 1 << (old % 64);
            }
            plan.ranks.push(old.map_or(NEW, |i| i as u32));
            work.rank_writes += 1;
            work.plan_peak_bytes = work.plan_peak_bytes.max(plan.bytes());
        }
    }
}
struct Cursor {
    parent: Option<usize>,
    next: Option<NodeId>,
}
#[derive(Default)]
pub(super) struct State {
    mode: Mode,
    committed: Option<Authority>,
    pending: Option<Box<Plan>>,
    working: bool,
    route_active: bool,
    route: Vec<(NodeId, u32)>,
    pub work: Work,
}
impl State {
    pub fn mode(&self) -> Mode {
        self.mode
    }
    #[allow(clippy::too_many_arguments)]
    pub fn begin(
        &mut self,
        old_len: usize,
        new_len: usize,
        root: Option<NodeId>,
        latest: Option<PresentationToken>,
        complete: u64,
        source: u64,
        eligible: bool,
    ) -> Option<Builder> {
        self.pending = None;
        if !matches!(self.mode, Mode::Ordered | Mode::Append) {
            return None;
        }
        let authority = self.committed?;
        if !eligible
            || self.working
            || Some(authority.token) != latest
            || Some(authority.root) != root
            || authority.len != old_len
        {
            self.work.authority_declines += 1;
            return None;
        }
        Some(Builder {
            predecessor: authority,
            complete,
            source,
            new_len,
            plan: None,
        })
    }
    pub fn stage(&mut self, builder: Option<Builder>, topology: bool) {
        self.pending = if topology {
            builder.and_then(|b| b.plan).map(Box::new)
        } else {
            None
        };
        if self.pending.is_some() {
            self.work.plan_allocations += 1;
            self.work.plan_staged += 1;
        }
    }
    pub fn invalidate(&mut self) {
        self.committed = None;
        self.pending = None;
        self.working = true;
        self.work.invalidated += 1;
    }
    pub fn rebuilt(&mut self) {
        self.invalidate();
        self.route = Vec::new();
        self.route_active = false;
    }
    pub fn commit(&mut self, token: PresentationToken, root: NodeId, len: usize) {
        self.committed = Some(Authority { token, root, len });
        self.working = false;
        self.pending = None;
        self.work.committed += 1;
    }
    pub fn measure_index(&mut self, id: NodeId, handles: &[NodeId]) -> usize {
        self.work.route_lookups += 1;
        if self.route_active {
            let i = self
                .route
                .binary_search_by(|(key, _)| {
                    self.work.route_lookup_compares += 1;
                    key.cmp(&id)
                })
                .expect("current qualified measured-node route");
            self.route[i].1 as usize
        } else {
            handles
                .binary_search_by(|key| {
                    self.work.route_lookup_compares += 1;
                    key.cmp(&id)
                })
                .expect("fresh sorted layout handles")
        }
    }
    #[allow(clippy::too_many_arguments)]
    pub fn apply(
        &mut self,
        layout: &mut LayoutTree,
        handles: &mut Vec<NodeId>,
        nodes: &[Node],
        styles: &styles::Styles,
        rows: &BTreeMap<u64, ListRow>,
        latest: Option<PresentationToken>,
        complete: u64,
        source: u64,
        depth: usize,
        eligible: bool,
    ) -> Result<bool, Error> {
        let Some(plan) = self.pending.take() else {
            return Ok(false);
        };
        self.work.plan_attempts += 1;
        let authority = self.committed;
        let valid = eligible
            && !layout.is_poisoned()
            && !self.working
            && authority.is_some_and(|a| {
                a.token == plan.predecessor.token
                    && a.root == plan.predecessor.root
                    && a.len == plan.predecessor.len
            })
            && latest == Some(plan.predecessor.token)
            && complete == plan.complete
            && source == plan.source
            && handles.first() == Some(&plan.predecessor.root)
            && handles.len() == plan.predecessor.len
            && layout.tree().len() == handles.len()
            && plan.ranks.len() == nodes.len()
            && plan.ranks.first() == Some(&0);
        if !valid {
            self.work.authority_declines += 1;
            return Ok(false);
        }
        // All reused descendants must also have a reused, identical core parent;
        // this proves removing an unused ancestor cannot delete a survivor.
        for (index, &old) in plan.ranks.iter().enumerate() {
            self.work.preflight_nodes += 1;
            if old == NEW {
                continue;
            }
            let Some(&id) = handles.get(old as usize) else {
                self.work.authority_declines += 1;
                return Ok(false);
            };
            if !layout.tree().contains(id) {
                self.work.authority_declines += 1;
                return Ok(false);
            }
            let parent = match nodes[index].parent().index() {
                Some(parent) => {
                    let old = plan.ranks[parent];
                    if old == NEW {
                        self.work.authority_declines += 1;
                        return Ok(false);
                    }
                    Some(handles[old as usize])
                }
                None => None,
            };
            if layout.tree().parent(id).map_err(LayoutError::from)? != parent {
                self.work.authority_declines += 1;
                return Ok(false);
            }
        }
        self.committed = None;
        self.working = true;
        let before = layout.mutation_work();
        for (rank, &id) in handles.iter().enumerate() {
            self.work.removal_checks += 1;
            if !plan.used(rank) && layout.tree().contains(id) {
                self.work.removed_nodes += layout.remove(id)?;
            }
        }
        let mut next = Vec::with_capacity(nodes.len());
        let mut route = Vec::new();
        for (index, node) in nodes.iter().enumerate() {
            let old = plan.ranks[index];
            let measured = node.text_slot().0 != u32::MAX || node.kind() == NodeKind::Image;
            let id = if old == NEW {
                let parent = node.parent().index().map(|i| next[i]);
                let style = list::row_style(
                    node.kind(),
                    &styles.get(index),
                    node.parent().index().map(|i| styles.get(i).flow),
                    rows.get(&node.identity()),
                );
                let id = layout.insert(parent, gpui_reactivity_core::NodeKind::Element, style)?;
                if measured {
                    layout.set_measure(id, Some(measure_marker))?;
                }
                self.work.inserted_nodes += 1;
                id
            } else {
                self.work.preserved_nodes += 1;
                handles[old as usize]
            };
            next.push(id);
            self.work.new_handle_writes += 1;
            if measured {
                route.push((id, index as u32));
                self.work.route_rows += 1;
            }
        }
        self.work.handle_scratch_bytes = self
            .work
            .handle_scratch_bytes
            .max(next.capacity() * size_of::<NodeId>());
        let mut frontier = Vec::with_capacity(depth + 1);
        frontier.push(Cursor {
            parent: None,
            next: layout
                .tree()
                .children(None)
                .map_err(LayoutError::from)?
                .next(),
        });
        self.work.frontier_pushes += 1;
        for (index, node) in nodes.iter().enumerate() {
            let parent = node.parent().index();
            while frontier
                .last()
                .is_some_and(|cursor| cursor.parent != parent)
            {
                frontier.pop();
                self.work.frontier_pops += 1;
            }
            let cursor = frontier.last_mut().expect("preorder parent frontier");
            let id = next[index];
            self.work.sibling_checks += 1;
            if cursor.next != Some(id) {
                let before = if self.mode == Mode::Ordered {
                    cursor.next
                } else {
                    None
                };
                layout.reparent_before(id, parent.map(|i| next[i]), before)?;
            }
            cursor.next = layout.tree().next_sibling(id).map_err(LayoutError::from)?;
            if nodes
                .get(index + 1)
                .is_some_and(|n| n.parent().index() == Some(index))
            {
                frontier.push(Cursor {
                    parent: Some(index),
                    next: layout
                        .tree()
                        .children(Some(id))
                        .map_err(LayoutError::from)?
                        .next(),
                });
                self.work.frontier_pushes += 1;
            }
        }
        self.work.frontier_pops += frontier.len();
        self.work.frontier_peak_bytes = self
            .work
            .frontier_peak_bytes
            .max(frontier.capacity() * size_of::<Cursor>());
        let after = layout.mutation_work();
        self.work.order_calls += after.order_calls - before.order_calls;
        self.work.validation_ancestors += after.validation_ancestors - before.validation_ancestors;
        self.work.sibling_relinks += after.sibling_relinks - before.sibling_relinks;
        self.work.context_ancestors += after.context_ancestors - before.context_ancestors;
        self.work.depth_nodes += after.depth_nodes - before.depth_nodes;
        route.sort_unstable_by(|a, b| {
            self.work.route_sort_compares += 1;
            a.0.cmp(&b.0)
        });
        self.route = route;
        self.route_active = true;
        *handles = next; // Working scratch only; commit follows successful preparation.
        Ok(true)
    }
}
#[cfg(test)]
impl<M: View + 'static> Win<M> {
    pub(crate) fn layout_preservation_mode(&mut self, mode: Mode) {
        let r = self.runtime_mut().unwrap();
        assert!(
            r.layout_nodes.is_sorted() && !r.layout_preservation.route_active,
            "select before any structural preservation"
        );
        r.layout_preservation.mode = mode;
    }
    pub(crate) fn layout_wrong_route(&mut self) {
        let r = self.runtime_mut().unwrap();
        assert!(r.layout_preservation.route_active && !r.layout_nodes.is_sorted());
        r.layout_preservation.route_active = false;
    }
    pub(crate) fn layout_inject_poison(&mut self) {
        let r = self.runtime_mut().unwrap();
        let measured = r
            .nodes
            .iter()
            .position(|n| n.text_slot().0 != u32::MAX)
            .unwrap();
        r.layout.mark_dirty(r.layout_nodes[measured]).unwrap();
        let root = r.layout_nodes[0];
        let result = catch_unwind(AssertUnwindSafe(|| {
            r.layout
                .compute_with_width_measure(
                    root,
                    cephal::Size {
                        width: cephal::AvailableSpace::Definite(64.),
                        height: cephal::AvailableSpace::Definite(64.),
                    },
                    &mut |_, _| panic!("bounded layout poison fault"),
                )
                .unwrap();
        }));
        assert!(result.is_err() && r.layout.is_poisoned());
    }
    pub(crate) fn layout_preservation_report(&self) -> serde_json::Value {
        let r = self.runtime().unwrap();
        let state = &r.layout_preservation;
        serde_json::json!({"mode":format!("{:?}",state.mode),"work":state.work,"committed":state.committed.map(|a|format!("{:?}",a.token)),"working":state.working,"pending_bytes":state.pending.as_ref().map_or(0,|p|p.bytes()),"state_header_bytes":size_of::<State>(),"route_active":state.route_active,"route_rows":state.route.len(),"route_capacity_bytes":state.route.capacity()*size_of::<(NodeId,u32)>(),"qualified_route":state.route.iter().map(|(id,rank)|(format!("{id:?}"),rank)).collect::<Vec<_>>()})
    }
}
