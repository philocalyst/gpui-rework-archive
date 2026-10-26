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
//! Handles live directly in the cache lane. `storage` counts their actual vendor
//! cache inners and spill payloads, excluding allocator overhead and style metadata.
//! This payload ledger is not a complete memory or RSS claim.
//! Pending edits use a sparse ordered set; compute rebuilds a temporary scheduler
//! and filters pending changes by forest root in O(pending changes * depth).
//! A clean call with no pending edits does no tree traversal. Pixel rounding,
//! detailed grid diagnostics, parallel layout and retained placement shortcuts
//! are not implemented by this adapter. Flex/block/grid and out-of-flow layout
//! use Cephal's serial unrounded path. Out-of-flow contexts are retained cold;
//! placement answers are recomputed rather than kept across passes.

use std::collections::{BTreeMap, BTreeSet};

use cephal::compute::block::BlockContext;
use cephal::owned::StyleTable;
use cephal::schedule::{Incremental, Scheduler};
use cephal::style::{CalcId, CalcOp, CalcTable, Ident};
use cephal::tree::{
    AbsoluteContext, AnswerSource, CacheAccess, IdentSuffix, LayoutInput, LayoutOutput,
    LayoutTree as EngineTree,
};
pub use cephal::{AvailableSpace, Layout, MeasureInput, MeasureOutput, Size, Style};
use cephal::{NodeCache, NodeId as EngineId};

use crate::{NodeId, NodeKind, Tree, TreeError};

const NO_STYLE: u32 = u32::MAX;
// The scheduler preserves META_MASK for tree-owned facts. Query metadata comes
// from StyleTable, so this adapter can use one of those bits for hidden layout.
const HIDDEN_SUBTREE: u8 = 0x10;
const _: () = assert!(HIDDEN_SUBTREE & cephal::schedule::META_MASK == HIDDEN_SUBTREE);

/// A hook is installed only on a node that declares content measurement. When
/// external data consulted by the hook changes, call `mark_dirty` on that node.
/// Hooks must give consistent answers for a fixed question during one compute.
pub type MeasureFn = fn(MeasureInput) -> MeasureOutput;

/// A measurement whose wrapping depends only on available width. Known
/// dimensions still constrain either axis; available height is not observable.
#[derive(Clone, Copy, Debug, PartialEq)]
pub struct WidthMeasureInput {
    pub known_dimensions: Size<Option<f32>>,
    pub available_width: AvailableSpace,
}

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

/// Known lane and cache heap payload only. Excludes allocator overhead and
/// vendor style-table metadata; this is not an RSS measurement.
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub struct LayoutStorage {
    pub slots: usize,
    pub active_styles: usize,
    pub allocated_caches: usize,
    pub lane_capacity_bytes: usize,
    pub cache_heap_bytes: usize,
    /// Cold containers with out-of-flow records; their payload is separate from cache_heap_bytes.
    pub absolute_contexts: usize,
}

// Most OOF trees have one recorded containing block. Keep that record in the
// cold owner allocation instead of reserving a whole B-tree leaf for it. Once
// promoted, stay a map until empty ownership is released: take/reinsert must
// not churn between representations during a layout pass.
enum AbsoluteContexts {
    Empty,
    Single(NodeId, AbsoluteContext),
    Many(BTreeMap<NodeId, AbsoluteContext>),
}

impl AbsoluteContexts {
    fn len(&self) -> usize {
        match self {
            Self::Empty => 0,
            Self::Single(..) => 1,
            Self::Many(records) => records.len(),
        }
    }
    fn is_empty(&self) -> bool {
        self.len() == 0
    }
    fn get(&self, node: &NodeId) -> Option<&AbsoluteContext> {
        match self {
            Self::Single(key, record) if key == node => Some(record),
            Self::Many(records) => records.get(node),
            _ => None,
        }
    }
    fn insert(&mut self, node: NodeId, record: AbsoluteContext) {
        match self {
            Self::Empty => *self = Self::Single(node, record),
            Self::Single(key, previous) if *key == node => *previous = record,
            Self::Single(..) => {
                let Self::Single(key, previous) = std::mem::replace(self, Self::Empty) else {
                    unreachable!()
                };
                let mut records = BTreeMap::new();
                records.insert(key, previous);
                records.insert(node, record);
                *self = Self::Many(records);
            }
            Self::Many(records) => {
                records.insert(node, record);
            }
        }
    }
    fn remove(&mut self, node: &NodeId) -> Option<AbsoluteContext> {
        match self {
            Self::Single(key, _) if key == node => {
                let Self::Single(_, record) = std::mem::replace(self, Self::Empty) else {
                    unreachable!()
                };
                Some(record)
            }
            Self::Many(records) => records.remove(node),
            _ => None,
        }
    }
    #[cfg(test)]
    fn iter(&self) -> impl Iterator<Item = (&NodeId, &AbsoluteContext)> {
        let single = match self {
            Self::Single(key, record) => Some((key, record)),
            _ => None,
        };
        let many = match self {
            Self::Many(records) => Some(records),
            _ => None,
        };
        single
            .into_iter()
            .chain(many.into_iter().flat_map(BTreeMap::iter))
    }
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
    caches: Vec<NodeCache>,
    // One owner word, no per-node lane or allocation before the first record.
    absolute_contexts: Option<Box<AbsoluteContexts>>,
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
            absolute_contexts: None,
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
        self.insert_before(parent, None, kind, style)
    }
    /// Insert before a checked direct child, retaining every other node/cache.
    pub fn insert_before(
        &mut self,
        parent: Option<NodeId>,
        before: Option<NodeId>,
        kind: NodeKind,
        style: Style,
    ) -> Result<NodeId, LayoutError> {
        let node = self.tree.insert_before(parent, before, kind)?;
        let slots = self.tree.slot_count();
        self.style_ids.resize(slots, NO_STYLE);
        self.layouts.resize(slots, Layout::ZERO);
        self.depths.resize(slots, 0);
        self.child_counts.resize(slots, 0);
        self.flags.resize(slots, 0);
        self.caches.resize_with(slots, NodeCache::new);
        let index = self.tree.slot(node);
        self.style_ids[index] = self.styles.intern(style);
        self.layouts[index] = Layout::ZERO;
        self.depths[index] = parent.map_or(0, |id| self.depths[self.tree.slot(id)] + 1);
        self.child_counts[index] = 0;
        self.flags[index] = 0;
        self.caches[index] = NodeCache::new();
        if let Some(parent) = parent {
            self.invalidate_absolute_above(parent);
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
            self.reset_cache(index);
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
        self.invalidate_absolute_above(node);
        for id in self.tree.subtree(node)? {
            let index = self.tree.slot(id);
            self.styles.release(self.style_ids[index]);
            self.style_ids[index] = NO_STYLE;
            self.layouts[index] = Layout::ZERO;
            self.caches[index] = NodeCache::new();
            self.flags[index] = 0;
            self.pending.remove(&id);
            self.viewports.remove(&id);
            self.measures.remove(&id);
            if let Some(contexts) = &mut self.absolute_contexts {
                contexts.remove(&id);
            }
        }
        self.release_empty_absolute_contexts();
        let removed = self.tree.remove(node)?;
        if let Some(parent) = parent {
            let index = self.tree.slot(parent);
            self.child_counts[index] -= 1;
            if self.is_cheap(parent) {
                self.reset_cache(index);
            }
            self.mark_dirty(parent)?;
        }
        Ok(removed)
    }
    pub fn reparent(&mut self, node: NodeId, parent: Option<NodeId>) -> Result<bool, LayoutError> {
        self.reparent_before(node, parent, None)
    }
    /// Reorder or move a subtree without replacing its layout capabilities.
    /// Validation and no-op detection precede cache/depth/pending mutations.
    pub fn reparent_before(
        &mut self,
        node: NodeId,
        parent: Option<NodeId>,
        before: Option<NodeId>,
    ) -> Result<bool, LayoutError> {
        self.tree.validate_reparent_before(node, parent, before)?;
        let old_parent = self.tree.parent(node)?;
        if old_parent == parent
            && (before == Some(node) || self.tree.next_sibling(node)? == before)
        {
            return Ok(false);
        }
        let old_depth = self.depths[self.tree.slot(node)];
        if let Some(old) = old_parent {
            self.invalidate_absolute_above(old);
        }
        if let Some(new) = parent {
            self.invalidate_absolute_above(new);
        }
        self.tree.reparent_before(node, parent, before)?;
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
                self.reset_cache(index);
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
        self.compute_inner(root, viewport, None, false, None)
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
        self.compute_inner(root, viewport, Some(measure), false, None)
    }
    /// Like `compute_with`, with no available height in the callback's input.
    /// The existing leaf cache can therefore share answers across available
    /// heights. Known heights remain part of the question. As with any content
    /// service change, mark affected nodes dirty before replacing its answers.
    pub fn compute_with_width_measure(
        &mut self,
        root: NodeId,
        viewport: Size<AvailableSpace>,
        measure: &mut dyn FnMut(NodeId, WidthMeasureInput) -> MeasureOutput,
    ) -> Result<bool, LayoutError> {
        self.compute_inner(
            root,
            viewport,
            Some(&mut |node, input| {
                measure(
                    node,
                    WidthMeasureInput {
                        known_dimensions: input.known_dimensions,
                        available_width: input.available_space.width,
                    },
                )
            }),
            true,
            None,
        )
    }
    /// Streams actual non-speculative layout writes before overwrite. The
    /// observer must bound its own retained history; no callback is retained.
    /// A callback panic poisons this adapter, just like a measure panic.
    pub fn compute_with_width_measure_and_changes(
        &mut self, root: NodeId, viewport: Size<AvailableSpace>,
        measure: &mut dyn FnMut(NodeId, WidthMeasureInput) -> MeasureOutput,
        changes: &mut dyn FnMut(NodeId, Layout, Layout),
    ) -> Result<bool, LayoutError> {
        self.compute_inner(root, viewport, Some(&mut |node, input| {
            measure(node, WidthMeasureInput { known_dimensions: input.known_dimensions, available_width: input.available_space.width })
        }), true, Some(changes))
    }
    fn compute_inner(
        &mut self,
        root: NodeId,
        viewport: Size<AvailableSpace>,
        measure: Option<&mut dyn FnMut(NodeId, MeasureInput) -> MeasureOutput>,
        width_only: bool,
        changes: Option<&mut dyn FnMut(NodeId, Layout, Layout)>,
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
            for slot in 0..self.caches.len() {
                self.clear_cache(slot);
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
                width_only,
                changes,
            };
            for node in selected {
                let key = EngineId::new(engine.owner.tree.layout_key(node));
                scheduler.mark(&mut engine, key);
            }
            scheduler.run(&mut engine, engine_root, changed);
            if changed {
                let slot = engine.owner.tree.slot(root);
                engine.owner.clear_cache(slot);
            }
            cephal::compute::compute_root_layout(&mut engine, engine_root, viewport);
        }
        self.release_empty_absolute_contexts();
        self.viewports.insert(root, viewport);
        self.poisoned = false;
        Ok(true)
    }
    pub fn storage(&self) -> LayoutStorage {
        let allocated_caches = self
            .caches
            .iter()
            .filter(|c| c.allocated_bytes() != 0)
            .count();
        LayoutStorage {
            slots: self.tree.slot_count(),
            active_styles: self.styles.len(),
            allocated_caches,
            lane_capacity_bytes: self.style_ids.capacity() * 4
                + self.layouts.capacity() * std::mem::size_of::<Layout>()
                + self.depths.capacity() * 4
                + self.child_counts.capacity() * 4
                + self.flags.capacity()
                + self.caches.capacity() * std::mem::size_of::<NodeCache>(),
            cache_heap_bytes: self.caches.iter().map(NodeCache::allocated_bytes).sum(),
            absolute_contexts: self
                .absolute_contexts
                .as_ref()
                .map_or(0, |records| records.len()),
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
    // An ancestor's record can name a removed or moved descendant. Rebuild only
    // recorded holders on the affected path before any engine id can retire;
    // off-path records and cached answers remain valid.
    fn invalidate_absolute_above(&mut self, mut node: NodeId) {
        if self.absolute_contexts.is_none() {
            return;
        }
        loop {
            if self
                .absolute_contexts
                .as_mut()
                .unwrap()
                .remove(&node)
                .is_some()
            {
                self.clear_cache(self.tree.slot(node));
                self.pending.insert(node);
            }
            let Some(parent) = self.tree.parent(node).unwrap() else {
                break;
            };
            node = parent;
        }
        self.release_empty_absolute_contexts();
    }
    fn release_empty_absolute_contexts(&mut self) {
        if self
            .absolute_contexts
            .as_ref()
            .is_some_and(|records| records.is_empty())
        {
            self.absolute_contexts = None;
        }
    }
    fn clear_cache(&mut self, slot: usize) {
        self.flags[slot] &= !HIDDEN_SUBTREE;
        self.caches[slot].clear();
    }
    fn reset_cache(&mut self, slot: usize) {
        self.flags[slot] &= !HIDDEN_SUBTREE;
        self.caches[slot] = NodeCache::new();
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
    width_only: bool,
    owner: &'a mut LayoutTree,
    measure: Option<&'service mut dyn FnMut(NodeId, MeasureInput) -> MeasureOutput>,
    changes: Option<&'service mut dyn FnMut(NodeId, Layout, Layout)>,
}
impl Engine<'_, '_> {
    fn node(&self, node: EngineId) -> NodeId {
        self.owner.tree.node_for_layout_key(node.raw())
    }
    fn slot(&self, node: EngineId) -> usize {
        self.owner.tree.slot(self.node(node))
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
            kind: if leaf {
                if self.width_only {
                    cephal::tree::NodeKind::LeafIgnoringHeight
                } else {
                    cephal::tree::NodeKind::Leaf
                }
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
    fn measure_ignores_available_height(&self) -> bool {
        self.width_only
    }
    fn set_unrounded_layout(&mut self, node: EngineId, layout: &Layout) {
        if self.owner.speculation != 0 {
            return;
        }
        let index = self.slot(node);
        if self.owner.layouts[index] != *layout {
            let node = self.node(node);
            let before = self.owner.layouts[index];
            if let Some(changes) = self.changes.as_mut() { changes(node, before, *layout); }
            self.owner.stats.changed_layout_writes += 1;
            self.owner.layouts[index] = *layout;
        }
    }
    fn unrounded_layout(&self, node: EngineId) -> Option<Layout> {
        Some(self.owner.layouts[self.slot(node)])
    }
    fn set_absolute_context(&mut self, node: EngineId, context: AbsoluteContext) {
        if self.owner.speculation == 0 {
            let node = self.node(node);
            self.owner
                .absolute_contexts
                .get_or_insert_with(|| Box::new(AbsoluteContexts::Empty))
                .insert(node, context);
        }
    }
    fn clear_absolute_context(&mut self, node: EngineId) {
        if self.owner.speculation != 0 || self.owner.absolute_contexts.is_none() {
            return;
        }
        let node = self.node(node);
        self.owner.absolute_contexts.as_mut().unwrap().remove(&node);
    }
    fn absolute_context(&self, node: EngineId) -> Option<&AbsoluteContext> {
        self.owner.absolute_contexts.as_ref()?.get(&self.node(node))
    }
    fn take_absolute_context(&mut self, node: EngineId) -> Option<AbsoluteContext> {
        if self.owner.speculation != 0 {
            return None;
        }
        let node = self.node(node);
        self.owner.absolute_contexts.as_mut()?.remove(&node)
    }
    fn keeps_placements(&self) -> bool {
        false
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
        &self.owner.caches[self.slot(node)]
    }
    fn cache_mut(&mut self, node: EngineId) -> &mut NodeCache {
        let slot = self.slot(node);
        self.owner.flags[slot] &= !HIDDEN_SUBTREE;
        &mut self.owner.caches[slot]
    }
    fn is_hidden_layout(&self, node: EngineId) -> bool {
        self.owner.flags[self.slot(node)] & HIDDEN_SUBTREE != 0
    }
    fn mark_hidden_layout(&mut self, node: EngineId) {
        if self.owner.speculation == 0 {
            let slot = self.slot(node);
            self.owner.flags[slot] |= HIDDEN_SUBTREE;
        }
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
    fn rejected_ordered_layout_edits_preserve_caches_lanes_and_pending_work() {
        let mut tree = LayoutTree::new();
        let root = tree.insert(None, NodeKind::Element, Style::DEFAULT).unwrap();
        let child = tree.insert(Some(root), NodeKind::Element, Style::DEFAULT).unwrap();
        let descendant = tree.insert(Some(child), NodeKind::Element, Style::DEFAULT).unwrap();
        tree.compute(root, Size::MAX_CONTENT).unwrap();
        let mut other = LayoutTree::new();
        let foreign = other.insert(None, NodeKind::Element, Style::DEFAULT).unwrap();
        let state = |tree: &LayoutTree| {
            (
                tree.stats(), tree.storage(), tree.generation(), tree.pending.clone(),
                tree.layouts.clone(), tree.depths.clone(), tree.child_counts.clone(),
                tree.flags.clone(), tree.style_ids.clone(),
                tree.tree.preorder().collect::<Vec<_>>(),
            )
        };
        let before = state(&tree);
        assert!(tree.insert_before(Some(root), Some(foreign), NodeKind::Element, Style::DEFAULT).is_err());
        assert_eq!(state(&tree), before);
        assert!(tree.reparent_before(root, Some(descendant), None).is_err());
        assert_eq!(state(&tree), before);
        assert!(tree.reparent_before(child, Some(root), Some(descendant)).is_err());
        assert_eq!(state(&tree), before);
        assert!(!tree.reparent_before(child, Some(root), Some(child)).unwrap());
        assert!(!tree.reparent_before(child, Some(root), None).unwrap());
        assert_eq!(state(&tree), before);
    }
    #[test]
    fn hidden_marker_uses_flags_and_revokes_on_mutation_and_rollover() {
        let mut tree = LayoutTree::new();
        let hidden = tree
            .insert(
                None,
                NodeKind::Element,
                Style {
                    display: cephal::style::Display::None,
                    ..Style::DEFAULT
                },
            )
            .unwrap();
        let leaf = tree
            .insert(Some(hidden), NodeKind::Element, Style::DEFAULT)
            .unwrap();
        let other = tree
            .insert(None, NodeKind::Element, Style::DEFAULT)
            .unwrap();
        tree.compute(hidden, Size::MAX_CONTENT).unwrap();
        let slot = tree.tree.slot(hidden);
        assert_ne!(tree.flags[slot] & HIDDEN_SUBTREE, 0);
        assert_eq!(tree.flags[tree.tree.slot(leaf)] & HIDDEN_SUBTREE, 0);
        assert_eq!(tree.storage().cache_heap_bytes, 0);
        let key = EngineId::new(tree.tree.layout_key(hidden));
        {
            let mut engine = Engine {
                owner: &mut tree,
                measure: None,
                observed: 0,
                width_only: false,
                changes: None,
            };
            engine.set_speculation(1);
            cephal::compute::compute_hidden_layout(&mut engine, key);
            assert!(engine.is_hidden_layout(key));
            engine.cache_mut(key).clear();
            assert!(!engine.is_hidden_layout(key));
            cephal::compute::compute_hidden_layout(&mut engine, key);
            assert!(!engine.is_hidden_layout(key));
            engine.mark_hidden_layout(key);
            assert!(!engine.is_hidden_layout(key));
            engine.set_speculation(0);
            cephal::compute::compute_hidden_layout(&mut engine, key);
            assert!(engine.is_hidden_layout(key));
            assert_eq!(engine.cache(key).allocated_bytes(), 0);
        }
        // Rollover clears even a different forest's proof, before stamps reuse.
        tree.generation = u32::MAX;
        tree.compute(other, Size::MAX_CONTENT).unwrap();
        assert_eq!(tree.generation(), 1);
        assert_eq!(tree.flags[slot] & HIDDEN_SUBTREE, 0);
        tree.mark_dirty(hidden).unwrap();
        tree.compute(hidden, Size::MAX_CONTENT).unwrap();
        assert_ne!(tree.flags[slot] & HIDDEN_SUBTREE, 0);
        tree.remove(hidden).unwrap();
        let reused = tree
            .insert(None, NodeKind::Element, Style::DEFAULT)
            .unwrap();
        assert_eq!(tree.flags[tree.tree.slot(reused)], 0);
        assert_eq!(tree.storage().cache_heap_bytes, 0);
    }

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
    #[test]
    fn oof_records_remain_live_through_rollover_and_reused_slots() {
        use cephal::style::{Dimension, LengthPercentageAuto, Position};
        let mut tree = LayoutTree::new();
        let root = tree
            .insert(
                None,
                NodeKind::Element,
                Style {
                    position: Position::Relative,
                    ..Style::DEFAULT
                },
            )
            .unwrap();
        let bridge = tree
            .insert(Some(root), NodeKind::Element, Style::DEFAULT)
            .unwrap();
        let style = Style {
            position: Position::Absolute,
            size: Size {
                width: Dimension::length(20.0),
                height: Dimension::length(12.0),
            },
            inset: cephal::Rect {
                left: LengthPercentageAuto::length(13.0),
                top: LengthPercentageAuto::length(17.0),
                ..cephal::Rect::splat(LengthPercentageAuto::AUTO)
            },
            ..Style::DEFAULT
        };
        let leaf = tree
            .insert(Some(bridge), NodeKind::Element, style.clone())
            .unwrap();
        let available = Size {
            width: AvailableSpace::Definite(200.0),
            height: AvailableSpace::Definite(100.0),
        };
        tree.compute(root, available).unwrap();
        assert!(tree.storage().absolute_contexts >= 2);
        tree.generation = u32::MAX;
        tree.mark_dirty(leaf).unwrap();
        tree.compute(root, available).unwrap();
        assert_eq!(tree.generation(), 1);
        let slot = tree.tree.slot(leaf);
        tree.remove(leaf).unwrap();
        let replacement = tree.insert(Some(bridge), NodeKind::Element, style).unwrap();
        assert_eq!(tree.tree.slot(replacement), slot);
        assert_ne!(replacement, leaf);
        tree.compute(root, available).unwrap();
        for (&holder, context) in tree.absolute_contexts.as_ref().unwrap().iter() {
            assert!(tree.tree.contains(holder));
            for entry in context.entries.iter().chain(&context.surfaced) {
                let node = match *entry {
                    cephal::tree::OofEntry::Seed { node, .. }
                    | cephal::tree::OofEntry::Through { node, .. } => node,
                };
                assert!(
                    tree.tree
                        .contains(tree.tree.node_for_layout_key(node.raw()))
                );
            }
            assert!(context.placed.is_empty());
            assert!(context.viewport.is_empty());
        }
    }

    #[test]
    fn cold_context_owner_replaces_takes_and_promotes_without_demotion() {
        let mut tree = Tree::new();
        let first = tree.insert(None, NodeKind::Element).unwrap();
        let second = tree.insert(None, NodeKind::Element).unwrap();
        let mut records = Box::new(AbsoluteContexts::Empty);
        let allocation = &*records as *const AbsoluteContexts;
        records.insert(first, AbsoluteContext::default());
        assert!(matches!(*records, AbsoluteContexts::Single(..)));
        let mut replacement = AbsoluteContext::default();
        replacement.entries.reserve_exact(3);
        records.insert(first, replacement);
        assert_eq!(records.len(), 1);
        assert_eq!(records.get(&first).unwrap().entries.capacity(), 3);
        assert!(matches!(*records, AbsoluteContexts::Single(..)));
        let moved = records.remove(&first).unwrap();
        assert!(records.is_empty());
        assert!(records.get(&second).is_none());
        records.insert(first, moved);
        assert!(matches!(*records, AbsoluteContexts::Single(..)));
        records.insert(second, AbsoluteContext::default());
        assert!(matches!(*records, AbsoluteContexts::Many(..)));
        assert_eq!(records.len(), 2);
        let moved = records.remove(&first).unwrap();
        assert!(matches!(*records, AbsoluteContexts::Many(..)));
        records.insert(first, moved);
        records.remove(&first).unwrap();
        records.remove(&second).unwrap();
        assert!(records.is_empty());
        assert!(matches!(*records, AbsoluteContexts::Many(..)));
        records.insert(second, AbsoluteContext::default());
        assert!(matches!(*records, AbsoluteContexts::Many(..)));
        assert_eq!(allocation, &*records as *const AbsoluteContexts);
        println!(
            "AbsoluteContexts={},LayoutTree={}",
            size_of::<AbsoluteContexts>(),
            size_of::<LayoutTree>()
        );
    }

    #[test]
    fn speculative_oof_writes_cannot_allocate_or_replace_real_records() {
        let mut owner = LayoutTree::new();
        let node = owner
            .insert(None, NodeKind::Element, Style::DEFAULT)
            .unwrap();
        let key = EngineId::new(owner.tree.layout_key(node));
        let mut engine = Engine {
            owner: &mut owner,
            observed: 0,
            measure: None,
            width_only: false,
            changes: None,
        };
        engine.set_speculation(1);
        engine.set_absolute_context(key, AbsoluteContext::default());
        assert!(engine.owner.absolute_contexts.is_none());
        engine.set_speculation(0);
        engine.set_absolute_context(key, AbsoluteContext::default());
        engine.set_speculation(1);
        engine.clear_absolute_context(key);
        assert!(engine.take_absolute_context(key).is_none());
        assert!(engine.absolute_context(key).is_some());
    }
}

#[cfg(test)]
mod write_observer_tests {
    use super::*;
    #[test]
    fn compute_observer_matches_actual_write_count_and_clean_call_emits_nothing() {
        let mut tree = LayoutTree::new();
        let root = tree.insert(None, NodeKind::Element, Style::DEFAULT).unwrap();
        let viewport = Size { width: AvailableSpace::Definite(20.), height: AvailableSpace::Definite(10.) };
        let mut writes = Vec::new();
        let before = tree.stats().changed_layout_writes;
        assert!(tree.compute_with_width_measure_and_changes(root, viewport,
            &mut |_, _| panic!("unmeasured root must not ask content service"),
            &mut |id, old, new| writes.push((id, old, new))).unwrap());
        assert_eq!(writes.len() as u64, tree.stats().changed_layout_writes - before);
        assert!(!writes.is_empty());
        assert!(writes.iter().all(|(id, old, new)| *id == root && old != new));
        writes.clear();
        assert!(!tree.compute_with_width_measure_and_changes(root, viewport,
            &mut |_, _| panic!("clean root must not measure"),
            &mut |id, old, new| writes.push((id, old, new))).unwrap());
        assert!(writes.is_empty());
    }
    #[test]
    fn observer_receives_real_full_capability_before_overwrite_not_speculation_or_equal_write() {
        let mut owner = LayoutTree::new();
        let node = owner.insert(None, NodeKind::Element, Style::DEFAULT).unwrap();
        let initial = owner.layout(node).unwrap();
        let mut next = initial; next.size.width += 17.;
        let mut writes = Vec::new();
        {
            let mut observer = |id, before, after| writes.push((id, before, after));
            let key = EngineId::new(owner.tree.layout_key(node));
            let mut engine = Engine { owner: &mut owner, observed: 0, width_only: false, measure: None, changes: Some(&mut observer) };
            engine.set_speculation(1);
            engine.set_unrounded_layout(key, &next);
            assert_eq!(engine.owner.layout(node).unwrap(), initial);
            engine.set_speculation(0);
            engine.set_unrounded_layout(key, &next);
            engine.set_unrounded_layout(key, &next);
        }
        assert_eq!(writes, vec![(node, initial, next)]);
        assert_eq!(owner.layout(node).unwrap(), next);
    }
}
