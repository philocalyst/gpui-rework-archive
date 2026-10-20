use crate::{
    Affine, CoordinateSpace, Damage, Geometry, NodeId, NodeKind, Point, Rect, Tree, TreeError,
};

const ABSENT: u32 = u32::MAX;
struct Record {
    slot: u32,
    geometry: Geometry,
    world: Affine,
}

/// Optional geometry extension to the topology. Geometry records are dense and
/// allocated only on declaration; a 4-byte directory maps topology slots to them.
///
/// Mutations eagerly update only the affected subtree. Reads see a coherent tree;
/// there is no scheduler, pending work, background scan, or automatic frame loop.
pub struct SpatialTree {
    tree: Tree,
    directory: Vec<u32>,
    records: Vec<Record>,
    damage: Damage,
    scratch: Vec<(NodeId, Affine)>,
    visited: u64,
}
impl SpatialTree {
    pub fn new(width: u32, height: u32) -> Result<Self, TreeError> {
        Ok(Self {
            tree: Tree::new(),
            directory: Vec::new(),
            records: Vec::new(),
            damage: Damage::new(width, height)?,
            scratch: Vec::new(),
            visited: 0,
        })
    }
    pub fn tree(&self) -> &Tree {
        &self.tree
    }
    pub fn damage(&self) -> &Damage {
        &self.damage
    }
    pub fn clear_damage(&mut self) {
        self.damage.clear();
    }
    /// Counts subtree nodes visited by spatial mutations, including geometry-free wrappers.
    pub fn mutation_visits(&self) -> u64 {
        self.visited
    }
    pub fn geometry_count(&self) -> usize {
        self.records.len()
    }
    pub fn insert(&mut self, parent: Option<NodeId>, kind: NodeKind) -> Result<NodeId, TreeError> {
        let node = self.tree.insert(parent, kind)?;
        self.directory.resize(self.tree.slot_count(), ABSENT);
        Ok(node)
    }
    pub fn geometry(&self, node: NodeId) -> Result<Option<Geometry>, TreeError> {
        self.tree.index(node)?;
        Ok(self.record(node).map(|record| record.geometry))
    }
    pub fn coordinate_space(&self, node: NodeId) -> Result<CoordinateSpace, TreeError> {
        self.tree.index(node)?;
        Ok(CoordinateSpace::new(self.inherited_world(Some(node))))
    }
    pub fn window_bounds(&self, node: NodeId) -> Result<Option<Rect>, TreeError> {
        self.tree.index(node)?;
        Ok(self
            .record(node)
            .and_then(|r| CoordinateSpace::new(r.world).bounds(r.geometry.bounds)))
    }
    /// Setting identical geometry does no work. Invalid data leaves all state and damage unchanged.
    pub fn set_geometry(
        &mut self,
        node: NodeId,
        geometry: Option<Geometry>,
    ) -> Result<bool, TreeError> {
        self.tree.index(node)?;
        if geometry.is_some_and(|g| !g.is_valid()) {
            return Err(TreeError::InvalidGeometry);
        }
        if self.geometry(node)? == geometry {
            return Ok(false);
        }
        if geometry.is_some()
            && self.record(node).is_none()
            && self.records.len() >= ABSENT as usize
        {
            return Err(TreeError::Capacity);
        }
        self.damage_subtree(node);
        self.erase_record(node);
        if let Some(geometry) = geometry {
            let index = self.records.len() as u32;
            let slot = self.tree.slot(node);
            self.directory[slot] = index;
            self.records.push(Record {
                slot: slot as u32,
                geometry,
                world: Affine::IDENTITY,
            });
        }
        self.refresh_subtree(node);
        Ok(true)
    }
    pub fn reparent(&mut self, node: NodeId, parent: Option<NodeId>) -> Result<bool, TreeError> {
        self.tree.validate_reparent(node, parent)?;
        if self.tree.parent(node)? == parent && self.tree.next_sibling(node)?.is_none() {
            return Ok(false);
        }
        self.damage_subtree(node);
        self.tree.reparent(node, parent)?;
        self.refresh_subtree(node);
        Ok(true)
    }
    pub fn remove(&mut self, node: NodeId) -> Result<usize, TreeError> {
        self.tree.index(node)?;
        self.damage_subtree(node);
        // Separate field borrows preserve streaming traversal, without a removal queue.
        for id in self.tree.subtree(node)? {
            let slot = self.tree.slot(id);
            Self::erase_slot(&mut self.directory, &mut self.records, slot);
        }
        self.tree.remove(node)
    }
    /// Last matching node in preorder wins. Exact inverse point mapping and all
    /// ancestor clips are checked; conservative AABBs never decide a hit.
    /// This foundation uses a linear hit scan, not a retained spatial index.
    pub fn hit_test(&self, point: Point) -> Option<NodeId> {
        self.tree
            .preorder()
            .filter(|&node| {
                let Some(record) = self.record(node) else {
                    return false;
                };
                if !CoordinateSpace::new(record.world).hit(record.geometry.bounds, point) {
                    return false;
                }
                let mut ancestor = Some(node);
                while let Some(id) = ancestor {
                    if let Some(r) = self.record(id) {
                        let space = CoordinateSpace::new(r.world);
                        // A singular ancestor invalidates the descendant space too.
                        if !r.world.is_invertible() {
                            return false;
                        }
                        if r.geometry.clip.is_some_and(|clip| !space.hit(clip, point)) {
                            return false;
                        }
                    }
                    ancestor = self.tree.parent(id).unwrap();
                }
                true
            })
            .last()
    }
    /// Allocated payload; no allocator headers or struct headers included.
    pub fn allocated_bytes(&self) -> usize {
        self.tree.allocated_bytes()
            + self.directory.capacity() * 4
            + self.records.capacity() * std::mem::size_of::<Record>()
            + self.scratch.capacity() * std::mem::size_of::<(NodeId, Affine)>()
            + self.damage.allocated_bytes()
    }
    pub fn geometry_record_bytes() -> usize {
        std::mem::size_of::<Record>()
    }
    fn record(&self, node: NodeId) -> Option<&Record> {
        let index = *self.directory.get(self.tree.slot(node))?;
        (index != ABSENT).then(|| &self.records[index as usize])
    }
    fn inherited_world(&self, mut node: Option<NodeId>) -> Affine {
        while let Some(id) = node {
            if let Some(record) = self.record(id) {
                return record.world;
            }
            node = self.tree.parent(id).unwrap();
        }
        Affine::IDENTITY
    }
    fn erase_record(&mut self, node: NodeId) {
        Self::erase_slot(&mut self.directory, &mut self.records, self.tree.slot(node));
    }
    fn erase_slot(directory: &mut [u32], records: &mut Vec<Record>, slot: usize) {
        let index = directory[slot];
        if index == ABSENT {
            return;
        }
        records.swap_remove(index as usize);
        if let Some(moved) = records.get(index as usize) {
            directory[moved.slot as usize] = index;
        }
        directory[slot] = ABSENT;
    }
    fn damage_subtree(&mut self, node: NodeId) {
        for id in self.tree.subtree(node).unwrap() {
            self.visited += 1;
            if let Some(record) = self.record(id) {
                let bounds =
                    CoordinateSpace::new(record.world).mapped_bounds(record.geometry.bounds);
                self.damage.add_mapped(bounds);
            }
        }
    }
    fn refresh_subtree(&mut self, root: NodeId) {
        self.scratch.clear();
        let mut node = root;
        let mut inherited = self.inherited_world(self.tree.parent(root).unwrap());
        loop {
            self.visited += 1;
            let index = self.directory[self.tree.slot(node)];
            let mut world = inherited;
            if index != ABSENT {
                let record = &mut self.records[index as usize];
                world = inherited.compose(record.geometry.transform);
                record.world = world;
                self.damage
                    .add_mapped(CoordinateSpace::new(world).mapped_bounds(record.geometry.bounds));
            }
            if let Some(child) = self.tree.children(Some(node)).unwrap().next() {
                self.scratch.push((node, inherited));
                node = child;
                inherited = world;
                continue;
            }
            loop {
                if node == root {
                    return;
                }
                if let Some(sibling) = self.tree.next_sibling(node).unwrap() {
                    node = sibling;
                    break;
                }
                let (parent, parent_inherited) = self.scratch.pop().unwrap();
                node = parent;
                inherited = parent_inherited;
            }
        }
    }
}
