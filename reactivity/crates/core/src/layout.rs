//! Optional Cephal adapter over the core's single retained topology.
//!
//! Results are unrounded, relative to the parent's border box. This module owns
//! no second topology and never constructs Cephal's owning Tree. It mutates layout
//! lanes in place, without rollback or an atomic presentation publication claim.
//! Cephal's algorithms recurse; the core's nonrecursive topology operations do
//! not imply support for arbitrary layout depth.
//!
//! On x86_64 at Cephal `20c4c494`, Style is 288 bytes, Layout is 92 bytes,
//! and NodeCache is an 8-byte handle to lazily allocated private cache storage.
//! This adapter still boxes that handle; `storage` counts its known lane and
//! outer-box payload only, excluding vendor cache inners/spills and style metadata.
//! Neither the handle size nor that partial ledger is a complete memory claim.
//! Pending edits use a sparse ordered set; compute rebuilds a temporary scheduler
//! and filters pending changes by forest root in O(pending changes * depth).
//! A clean call with no pending edits does no tree traversal. Pixel rounding,
//! detailed grid diagnostics, parallel layout and absolute-position shortcuts
//! are not implemented by this adapter; normal flex/block/grid algorithms and
//! direct-parent absolute placement still run through Cephal's serial unrounded
//! compute path. Non-parent containing blocks require the new absolute-context
//! trait storage, which this adapter does not yet retain.

use std::collections::{BTreeMap, BTreeSet};

use cephal::compute::block::BlockContext;
use cephal::owned::StyleTable;
use cephal::schedule::{Incremental, Scheduler};
use cephal::style::{CalcId, CalcOp, CalcTable, Ident};
use cephal::tree::{
    AnswerSource, CacheAccess, IdentSuffix, LayoutInput, LayoutOutput, LayoutTree as EngineTree,
};
pub use cephal::{AvailableSpace, Layout, MeasureInput, MeasureOutput, Size, Style};
use cephal::{NodeCache, NodeId as EngineId};

use crate::{NodeId, NodeKind, Tree, TreeError};

const NO_STYLE: u32 = u32::MAX;

/// A hook is installed only on a node that declares content measurement. When
/// external data consulted by the hook changes, call `mark_dirty` on that node.
/// Hooks must give consistent answers for a fixed question during one compute.
pub type MeasureFn = fn(MeasureInput) -> MeasureOutput;

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub enum LayoutError {
    Tree(TreeError),
    NotRoot,
    InvalidViewport,
    InvalidCalc,
    /// A previous layout panicked. Retained lanes may have been partly written.
    Poisoned,
}
impl From<TreeError> for LayoutError {
    fn from(error: TreeError) -> Self {
        Self::Tree(error)
    }
}

#[derive(Clone, Copy, Debug, Default, Eq, PartialEq)]
pub struct LayoutStats {
    pub computes: u64,
    pub computed_answers: u64,
    pub cached_answers: u64,
    pub cheap_answers: u64,
    pub measure_calls: u64,
    pub changed_layout_writes: u64,
}

/// Known payload only. Vendor style-table metadata and cache spill allocations
/// are private to Cephal and are not included in these byte counts.
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub struct LayoutStorage {
    pub slots: usize,
    pub active_styles: usize,
    pub allocated_caches: usize,
    pub lane_capacity_bytes: usize,
    pub cache_inline_bytes: usize,
}

/// Retained flex/block/grid layout using the core Tree as its sole topology.
/// Normal empty-content leaves never allocate NodeCache. Styles are interned and
/// references released on replacement/removal. All public node operations check
/// the arena-qualified core capability before accessing a layout lane.
pub struct LayoutTree {
    tree: Tree,
    style_ids: Vec<u32>,
    layouts: Vec<Layout>,
    depths: Vec<u32>,
    child_counts: Vec<u32>,
    flags: Vec<u8>,
    caches: Vec<Option<Box<NodeCache>>>,
    empty_cache: NodeCache,
    styles: StyleTable,
    measures: BTreeMap<NodeId, MeasureFn>,
    // Only full generational core capabilities survive between computes. A
    // vendor scheduler is built afresh after lifecycle validation, so removed
    // engine ids cannot remain in its otherwise unchecked queue.
    pending: BTreeSet<NodeId>,
    viewports: BTreeMap<NodeId, Size<AvailableSpace>>,
    calc: CalcTable,
    idents: BTreeMap<String, Ident>,
    names: Vec<String>,
    generation: u32,
    speculation: u32,
    stats: LayoutStats,
    poisoned: bool,
}

impl Default for LayoutTree {
    fn default() -> Self {
        Self::new()
    }
}
impl LayoutTree {
    pub fn new() -> Self {
        Self {
            tree: Tree::new(),
            style_ids: Vec::new(),
            layouts: Vec::new(),
            depths: Vec::new(),
            child_counts: Vec::new(),
            flags: Vec::new(),
            caches: Vec::new(),
            empty_cache: NodeCache::new(),
            styles: StyleTable::new(),
            measures: BTreeMap::new(),
            pending: BTreeSet::new(),
            viewports: BTreeMap::new(),
            calc: CalcTable::new(),
            idents: BTreeMap::new(),
            names: Vec::new(),
            generation: 1,
            speculation: 0,
            stats: LayoutStats::default(),
            poisoned: false,
        }
    }
    pub fn tree(&self) -> &Tree {
        &self.tree
    }
    pub fn stats(&self) -> LayoutStats {
        self.stats
    }
    pub fn generation(&self) -> u32 {
        self.generation
    }
    pub fn is_poisoned(&self) -> bool {
        self.poisoned
    }
    pub fn style(&self, node: NodeId) -> Result<&Style, LayoutError> {
        let slot = self.tree.index(node)? as usize;
        Ok(self.styles.get(self.style_ids[slot]))
    }
    /// Last computed unrounded layout; mutations retain it until compute succeeds.
    pub fn layout(&self, node: NodeId) -> Result<Layout, LayoutError> {
        if self.poisoned {
            return Err(LayoutError::Poisoned);
        }
        Ok(self.layouts[self.tree.index(node)? as usize])
    }
    pub fn insert(
        &mut self,
        parent: Option<NodeId>,
        kind: NodeKind,
        style: Style,
    ) -> Result<NodeId, LayoutError> {
        let node = self.tree.insert(parent, kind)?;
        let slots = self.tree.slot_count();
        self.style_ids.resize(slots, NO_STYLE);
        self.layouts.resize(slots, Layout::ZERO);
        self.depths.resize(slots, 0);
        self.child_counts.resize(slots, 0);
        self.flags.resize(slots, 0);
        self.caches.resize_with(slots, || None);
        let index = self.tree.slot(node);
        self.style_ids[index] = self.styles.intern(style);
        self.layouts[index] = Layout::ZERO;
        self.depths[index] = parent.map_or(0, |id| self.depths[self.tree.slot(id)] + 1);
        self.child_counts[index] = 0;
        self.flags[index] = 0;
        self.caches[index] = None;
        if let Some(parent) = parent {
            self.child_counts[self.tree.slot(parent)] += 1;
            self.mark_dirty(parent)?;
        } else {
            self.pending.insert(node);
        }
        Ok(node)
    }
    pub fn set_style(&mut self, node: NodeId, style: Style) -> Result<bool, LayoutError> {
        let index = self.tree.index(node)? as usize;
        let old = self.style_ids[index];
        if *self.styles.get(old) == style {
            return Ok(false);
        }
        self.style_ids[index] = self.styles.intern(style);
        self.styles.release(old);
        self.mark_dirty(node)?;
        // Parent algorithms read child style directly (flex basis/order/grid
        // placement), outside the child's cached input/output contract.
        if let Some(parent) = self.tree.parent(node)? {
            self.pending.insert(parent);
        }
        Ok(true)
    }
    pub fn set_measure(
        &mut self,
        node: NodeId,
        measure: Option<MeasureFn>,
    ) -> Result<bool, LayoutError> {
        let index = self.tree.index(node)? as usize;
        let old = self.measures.get(&node).copied();
        if match (old, measure) {
            (Some(a), Some(b)) => std::ptr::fn_addr_eq(a, b),
            (None, None) => true,
            _ => false,
        } {
            return Ok(false);
        }
        if let Some(measure) = measure {
            self.measures.insert(node, measure);
        } else {
            self.measures.remove(&node);
        }
        // A node becoming cheap no longer needs its old content-query cache.
        if self.is_cheap(node) {
            self.caches[index] = None;
        }
        self.mark_dirty(node)?;
        Ok(true)
    }
    pub fn mark_dirty(&mut self, node: NodeId) -> Result<(), LayoutError> {
        self.tree.index(node)?;
        // Empty-content leaves bypass the vendor cache by design; their parent
        // must ask them again to observe style changes.
        let target = if self.is_cheap(node) {
            self.tree.parent(node)?.unwrap_or(node)
        } else {
            node
        };
        self.pending.insert(target);
        Ok(())
    }
    pub fn remove(&mut self, node: NodeId) -> Result<usize, LayoutError> {
        self.tree.index(node)?;
        let parent = self.tree.parent(node)?;
        for id in self.tree.subtree(node)? {
            let index = self.tree.slot(id);
            self.styles.release(self.style_ids[index]);
            self.style_ids[index] = NO_STYLE;
            self.layouts[index] = Layout::ZERO;
            self.caches[index] = None;
            self.flags[index] = 0;
            self.pending.remove(&id);
            self.viewports.remove(&id);
            self.measures.remove(&id);
        }
        let removed = self.tree.remove(node)?;
        if let Some(parent) = parent {
            let index = self.tree.slot(parent);
            self.child_counts[index] -= 1;
            if self.is_cheap(parent) {
                self.caches[index] = None;
            }
            self.mark_dirty(parent)?;
        }
        Ok(removed)
    }
    pub fn reparent(&mut self, node: NodeId, parent: Option<NodeId>) -> Result<bool, LayoutError> {
        self.tree.validate_reparent(node, parent)?;
        let old_parent = self.tree.parent(node)?;
        if old_parent == parent && self.tree.next_sibling(node)?.is_none() {
            return Ok(false);
        }
        let old_depth = self.depths[self.tree.slot(node)];
        self.tree.reparent(node, parent)?;
        self.viewports.remove(&node);
        if old_parent != parent {
            if let Some(old) = old_parent {
                self.child_counts[self.tree.slot(old)] -= 1;
            }
            if let Some(new) = parent {
                self.child_counts[self.tree.slot(new)] += 1;
            }
        }
        let new_depth = parent.map_or(0, |id| self.depths[self.tree.slot(id)] + 1);
        if old_depth != new_depth {
            for id in self.tree.subtree(node)? {
                let depth = self
                    .tree
                    .parent(id)?
                    .map_or(0, |p| self.depths[self.tree.slot(p)] + 1);
                self.depths[self.tree.slot(id)] = depth;
            }
        }
        if let Some(old) = old_parent {
            let index = self.tree.slot(old);
            if self.is_cheap(old) {
                self.caches[index] = None;
            }
            self.mark_dirty(old)?;
        }
        if let Some(new) = parent {
            self.mark_dirty(new)?;
        } else {
            self.mark_dirty(node)?;
        }
        Ok(true)
    }
    /// Compute one forest root. An unchanged root/viewport with no pending edits
    /// returns false before entering Cephal or advancing the cache generation.
    /// A panic poisons this adapter; there is no transactional rollback.
    pub fn compute(
        &mut self,
        root: NodeId,
        viewport: Size<AvailableSpace>,
    ) -> Result<bool, LayoutError> {
        self.compute_inner(root, viewport, None)
    }
    /// Borrow a content service for this computation instead of storing it in
    /// every measured node. Only nodes installed with `set_measure` invoke it.
    ///
    /// The callback must be pure for a fixed question during this compute. Its
    /// external dependencies must be marked dirty before their answers change.
    /// Neither the service nor any borrowed answer survives this method.
    pub fn compute_with(
        &mut self,
        root: NodeId,
        viewport: Size<AvailableSpace>,
        measure: &mut dyn FnMut(NodeId, MeasureInput) -> MeasureOutput,
    ) -> Result<bool, LayoutError> {
        self.compute_inner(root, viewport, Some(measure))
    }
    fn compute_inner(
        &mut self,
        root: NodeId,
        viewport: Size<AvailableSpace>,
        measure: Option<&mut dyn FnMut(NodeId, MeasureInput) -> MeasureOutput>,
    ) -> Result<bool, LayoutError> {
        self.tree.index(root)?;
        if self.poisoned {
            return Err(LayoutError::Poisoned);
        }
        if self.tree.parent(root)?.is_some() {
            return Err(LayoutError::NotRoot);
        }
        for axis in [viewport.width, viewport.height] {
            if let AvailableSpace::Definite(value) = axis
                && (!value.is_finite() || value < 0.0)
            {
                return Err(LayoutError::InvalidViewport);
            }
        }
        let changed = self.viewports.get(&root) != Some(&viewport);
        let selected: Vec<_> = self
            .pending
            .iter()
            .copied()
            .filter(|&id| self.root_of(id) == root)
            .collect();
        if !changed && selected.is_empty() {
            return Ok(false);
        }
        self.poisoned = true;
        self.stats.computes += 1;
        if let Some(generation) = self.generation.checked_add(1) {
            self.generation = generation;
        } else {
            // Cache-entry generations influence eviction detection. Never reuse
            // a generation while an old entry can still carry that stamp.
            for cache in self.caches.iter_mut().flatten() {
                cache.clear();
            }
            self.generation = 1;
        }
        let mut scheduler = Scheduler::new();
        let engine_root = EngineId::new(self.tree.layout_key(root));
        for node in &selected {
            self.pending.remove(node);
        }
        {
            let mut engine = Engine {
                owner: self,
                measure,
                observed: 0,
            };
            for node in selected {
                let key = EngineId::new(engine.owner.tree.layout_key(node));
                scheduler.mark(&mut engine, key);
            }
            scheduler.run(&mut engine, engine_root, changed);
            if changed {
                let slot = engine.owner.tree.slot(root);
                if let Some(cache) = &mut engine.owner.caches[slot] {
                    cache.clear();
                }
            }
            cephal::compute::compute_root_layout(&mut engine, engine_root, viewport);
        }
        self.viewports.insert(root, viewport);
        self.poisoned = false;
        Ok(true)
    }
    pub fn storage(&self) -> LayoutStorage {
        let allocated_caches = self.caches.iter().filter(|c| c.is_some()).count();
        LayoutStorage {
            slots: self.tree.slot_count(),
            active_styles: self.styles.len(),
            allocated_caches,
            lane_capacity_bytes: self.style_ids.capacity() * 4
                + self.layouts.capacity() * std::mem::size_of::<Layout>()
                + self.depths.capacity() * 4
                + self.child_counts.capacity() * 4
                + self.flags.capacity()
                + self.caches.capacity() * std::mem::size_of::<Option<Box<NodeCache>>>(),
            cache_inline_bytes: allocated_caches * std::mem::size_of::<NodeCache>(),
        }
    }
    /// Named grid lines/areas use the same interned names as their styles.
    pub fn intern(&mut self, name: &str) -> Ident {
        if let Some(&id) = self.idents.get(name) {
            return id;
        }
        let id = Ident(u32::try_from(self.names.len()).expect("grid name capacity"));
        self.names.push(name.to_owned());
        self.idents.insert(name.to_owned(), id);
        id
    }
    /// Register valid postfix calc bytecode. The upstream evaluator has a
    /// 16-value stack; validate its shape before storing any program.
    pub fn register_calc(&mut self, program: &[CalcOp]) -> Result<CalcId, LayoutError> {
        let mut depth = 0usize;
        for op in program {
            let consumed = match *op {
                CalcOp::Px(v) | CalcOp::Percent(v) => {
                    if !v.is_finite() {
                        return Err(LayoutError::InvalidCalc);
                    }
                    0
                }
                CalcOp::Clamp => 3,
                _ => 2,
            };
            if depth < consumed {
                return Err(LayoutError::InvalidCalc);
            }
            depth = depth - consumed + 1;
            if depth > 16 {
                return Err(LayoutError::InvalidCalc);
            }
        }
        if depth != 1 {
            return Err(LayoutError::InvalidCalc);
        }
        Ok(self.calc.register(program))
    }
    fn is_cheap(&self, node: NodeId) -> bool {
        self.child_counts[self.tree.slot(node)] == 0 && !self.measures.contains_key(&node)
    }
    fn root_of(&self, mut node: NodeId) -> NodeId {
        while let Some(parent) = self
            .tree
            .parent(node)
            .expect("pending ids are removed with their subtree")
        {
            node = parent;
        }
        node
    }
}

// Private view: Cephal's engine-local u64 ids cannot be used as public GPUI
// capabilities. The codec includes generation; arena validation occurs at the
// public boundary, and every engine id is minted from this adapter's topology.
struct Engine<'a, 'service> {
    observed: u8,
    owner: &'a mut LayoutTree,
    measure: Option<&'service mut dyn FnMut(NodeId, MeasureInput) -> MeasureOutput>,
}
impl Engine<'_, '_> {
    fn node(&self, node: EngineId) -> NodeId {
        self.owner.tree.node_for_layout_key(node.raw())
    }
    fn slot(&self, node: EngineId) -> usize {
        self.owner.tree.slot(self.node(node))
    }
    fn skips_cache(&self, node: NodeId) -> bool {
        self.owner.is_cheap(node) || self.owner.style(node).unwrap().generates_no_box()
    }
}
struct Children<'a> {
    tree: &'a Tree,
    children: crate::tree::Children<'a>,
}
impl Iterator for Children<'_> {
    type Item = EngineId;
    fn next(&mut self) -> Option<Self::Item> {
        self.children
            .next()
            .map(|id| EngineId::new(self.tree.layout_key(id)))
    }
}
impl EngineTree for Engine<'_, '_> {
    type ChildIter<'a>
        = Children<'a>
    where
        Self: 'a;
    fn children(&self, node: EngineId) -> Self::ChildIter<'_> {
        Children {
            tree: &self.owner.tree,
            children: self.owner.tree.children(Some(self.node(node))).unwrap(),
        }
    }
    fn child_count(&self, node: EngineId) -> usize {
        self.owner.child_counts[self.slot(node)] as usize
    }
    fn child_at(&self, node: EngineId, index: usize) -> EngineId {
        self.children(node)
            .nth(index)
            .expect("Cephal child index is in range")
    }
    fn style(&self, node: EngineId) -> &Style {
        self.owner.styles.get(self.owner.style_ids[self.slot(node)])
    }
    fn resolve_calc(&self, id: CalcId, basis: f32) -> f32 {
        self.owner.calc.resolve(id, basis)
    }
    fn suffixed_ident(&self, base: Ident, suffix: IdentSuffix) -> Option<Ident> {
        self.owner
            .idents
            .get(&format!(
                "{}{}",
                self.owner.names[base.0 as usize],
                suffix.as_str()
            ))
            .copied()
    }
    fn leaf_is_cheap(&self, node: EngineId) -> bool {
        !self.owner.measures.contains_key(&self.node(node))
    }
    fn is_measured_leaf(&self, node: EngineId) -> bool {
        self.owner.measures.contains_key(&self.node(node))
    }
    fn style_plan(&self, node: EngineId) -> Option<&cephal::compute::plan::StylePlan> {
        self.owner
            .styles
            .plan(self.owner.style_ids[self.slot(node)])
    }
    fn query_meta(&self, node: EngineId) -> cephal::tree::QueryMeta {
        let slot = self.slot(node);
        let style = self.owner.style_ids[slot];
        let leaf = self.owner.child_counts[slot] == 0;
        cephal::tree::QueryMeta {
            hidden: self.owner.styles.get(style).generates_no_box(),
            cheap_leaf: leaf && !self.is_measured_leaf(node),
            dependency: self.owner.styles.parent_size_dependency(style),
            // This adapter uses Cephal's default leaf algorithm. Measurements
            // may inspect either available axis, so height remains observed.
            kind: if leaf {
                cephal::tree::NodeKind::Leaf
            } else {
                self.owner.styles.kind(style)
            },
        }
    }
    fn take_observed(&mut self) -> u8 {
        std::mem::take(&mut self.observed)
    }
    fn note_observed(&mut self, axes: u8) {
        self.observed |= axes;
    }
    fn measure(&mut self, node: EngineId, input: MeasureInput) -> MeasureOutput {
        let node = self.node(node);
        if let Some(measure) = self.owner.measures.get(&node).copied() {
            self.owner.stats.measure_calls += 1;
            match &mut self.measure {
                Some(service) => service(node, input),
                None => measure(input),
            }
        } else {
            MeasureOutput::from_size(input.known_dimensions.unwrap_or(Size::ZERO))
        }
    }
    fn set_unrounded_layout(&mut self, node: EngineId, layout: &Layout) {
        if self.owner.speculation != 0 {
            return;
        }
        let index = self.slot(node);
        if self.owner.layouts[index] != *layout {
            self.owner.stats.changed_layout_writes += 1;
            self.owner.layouts[index] = *layout;
        }
    }
    fn unrounded_layout(&self, node: EngineId) -> Option<Layout> {
        Some(self.owner.layouts[self.slot(node)])
    }
    fn compute_child_layout(
        &mut self,
        node: EngineId,
        input: LayoutInput,
        context: Option<&mut BlockContext<'_>>,
    ) -> LayoutOutput {
        cephal::compute::compute_child_layout(self, node, input, context)
    }
    fn observe_answer(
        &mut self,
        _node: EngineId,
        _input: &LayoutInput,
        _output: &LayoutOutput,
        source: AnswerSource,
    ) {
        match source {
            AnswerSource::CheapLeaf => self.owner.stats.cheap_answers += 1,
            AnswerSource::Cached => self.owner.stats.cached_answers += 1,
            AnswerSource::Computed => self.owner.stats.computed_answers += 1,
        }
    }
}
impl CacheAccess for Engine<'_, '_> {
    fn cache(&self, node: EngineId) -> &NodeCache {
        self.owner.caches[self.slot(node)]
            .as_deref()
            .unwrap_or(&self.owner.empty_cache)
    }
    fn cache_mut(&mut self, node: EngineId) -> &mut NodeCache {
        let slot = self.slot(node);
        if self.owner.caches[slot].is_none() && self.skips_cache(self.node(node)) {
            return &mut self.owner.empty_cache;
        }
        self.owner.caches[slot].get_or_insert_with(|| Box::new(NodeCache::new()))
    }
    fn generation(&self) -> u32 {
        self.owner.generation
    }
    fn speculation(&self) -> u32 {
        self.owner.speculation
    }
    fn set_speculation(&mut self, depth: u32) {
        self.owner.speculation = depth;
    }
}
impl Incremental for Engine<'_, '_> {
    fn parent(&self, node: EngineId) -> Option<EngineId> {
        self.owner
            .tree
            .parent(self.node(node))
            .unwrap()
            .map(|id| EngineId::new(self.owner.tree.layout_key(id)))
    }
    fn depth(&self, node: EngineId) -> u32 {
        self.owner.depths[self.slot(node)]
    }
    fn flags(&self, node: EngineId) -> u8 {
        self.owner.flags[self.slot(node)]
    }
    fn set_flags(&mut self, node: EngineId, flags: u8) {
        let slot = self.slot(node);
        self.owner.flags[slot] = flags;
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn generation_rollover_clears_old_cache_stamps() {
        let mut tree = LayoutTree::new();
        let root = tree
            .insert(None, NodeKind::Element, Style::DEFAULT)
            .unwrap();
        let child = tree
            .insert(Some(root), NodeKind::Element, Style::DEFAULT)
            .unwrap();
        let available = Size {
            width: AvailableSpace::Definite(100.0),
            height: AvailableSpace::MaxContent,
        };
        tree.compute(root, available).unwrap();
        assert_eq!(tree.storage().allocated_caches, 1);
        tree.generation = u32::MAX;
        tree.mark_dirty(child).unwrap();
        assert!(tree.compute(root, available).unwrap());
        assert_eq!(tree.generation(), 1);
        assert_eq!(tree.layout(root).unwrap().size.width, 100.0);
        assert!(!tree.compute(root, available).unwrap());
    }
}
