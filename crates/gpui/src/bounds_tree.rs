use crate::{Bounds, Half};
use std::{
    cmp,
    fmt::Debug,
    ops::{Add, Sub},
    ptr::NonNull,
};

/// Maximum children per internal node (R-tree style branching factor).
/// Higher values = shorter tree = fewer cache misses, but more work per node.
const MAX_CHILDREN: usize = 12;

/// A spatial tree optimized for finding maximum ordering among intersecting bounds.
///
/// This is an R-tree variant specifically designed for the use case of assigning
/// z-order to overlapping UI elements. Key optimizations:
/// - Tracks the leaf with global max ordering for O(1) fast-path queries
/// - Uses higher branching factor (4) for lower tree height
/// - Aggressive pruning during search based on max_order metadata
#[derive(Debug)]
pub(crate) struct BoundsTree<U>
where
    U: Clone + Debug + Default + PartialEq,
{
    /// All nodes stored contiguously for cache efficiency.
    nodes: Vec<Node<U>>,
    /// Index of the root node, if any.
    root: Option<usize>,
    /// Index of the leaf with the highest ordering (for fast-path lookups).
    max_leaf: Option<usize>,
    /// Minimum ordering assigned to any subsequent insert. Raised before painting deferred
    /// draws so overlays always sort above the main scene (and their orders can't fall inside a
    /// content-filter order range from the main scene). 0 means no floor.
    order_floor: u32,
    /// Reusable stack for tree traversal during insertion.
    insert_path: Vec<usize>,
    /// Reusable stack for search operations.
    search_stack: Vec<NonNull<Node<U>>>,
}

/// A node in the bounds tree.
#[derive(Debug, Clone)]
struct Node<U>
where
    U: Clone + Debug + Default + PartialEq,
{
    /// Bounding box containing this node and all descendants.
    bounds: Bounds<U>,
    /// Maximum ordering value in this subtree.
    max_order: u32,
    /// Height from this node to a leaf (leaves have height zero).
    height: u32,
    /// Node-specific data.
    kind: NodeKind,
}

#[derive(Debug, Clone)]
enum NodeKind {
    /// Leaf node containing actual bounds data.
    Leaf {
        /// The ordering assigned to this bounds.
        order: u32,
    },
    /// Internal node with children.
    Internal {
        /// Indices of child nodes (2 to MAX_CHILDREN).
        children: NodeChildren,
    },
}

/// Fixed-size array for child indices, avoiding heap allocation.
#[derive(Debug, Clone)]
struct NodeChildren {
    // Keeps an invariant where the max order child is always at the end
    indices: [usize; MAX_CHILDREN],
    len: u8,
}

impl NodeChildren {
    fn new() -> Self {
        Self {
            indices: [0; MAX_CHILDREN],
            len: 0,
        }
    }

    fn push(&mut self, index: usize) {
        debug_assert!((self.len as usize) < MAX_CHILDREN);
        self.indices[self.len as usize] = index;
        self.len += 1;
    }

    fn len(&self) -> usize {
        self.len as usize
    }

    fn as_slice(&self) -> &[usize] {
        &self.indices[..self.len as usize]
    }
}

impl<U> BoundsTree<U>
where
    U: Clone
        + Debug
        + PartialEq
        + PartialOrd
        + Add<U, Output = U>
        + Sub<Output = U>
        + Half
        + Default,
{
    /// Clears all nodes from the tree.
    pub fn clear(&mut self) {
        self.nodes.clear();
        self.root = None;
        self.max_leaf = None;
        self.order_floor = 0;
        self.insert_path.clear();
        self.search_stack.clear();
    }

    /// Raise the minimum ordering for subsequent inserts to `floor`. Relative ordering above the
    /// floor is preserved (overlapping inserts still step above one another).
    pub fn set_order_floor(&mut self, floor: u32) {
        self.order_floor = self.order_floor.max(floor);
    }

    /// Returns whether this tree has no recorded bounds or ordering floor.
    pub(crate) fn is_pristine(&self) -> bool {
        self.nodes.is_empty()
            && self.root.is_none()
            && self.max_leaf.is_none()
            && self.order_floor == 0
    }

    pub(crate) fn has_default_order_floor(&self) -> bool {
        self.order_floor == 0
    }

    /// The highest ordering assigned to any bounds so far (0 if empty).
    pub fn max_order(&self) -> u32 {
        self.max_leaf.map_or(0, |idx| self.nodes[idx].max_order)
    }

    /// Inserts bounds with an ordering strictly greater than *every* existing bounds (not just
    /// intersecting ones), and returns that ordering. Used for content-filter group boundaries
    /// (which must sort after all previously-painted content so their order range can't collide
    /// with unrelated non-overlapping content that reuses low orderings) and to raise the order
    /// floor before painting deferred draws (so overlays always sort above the main scene).
    pub fn insert_above_all(&mut self, new_bounds: Bounds<U>) -> u32 {
        let ordering = self.max_order() + 1;
        let new_leaf_idx = self.insert_leaf(new_bounds, ordering);
        self.max_leaf = Some(new_leaf_idx);
        ordering
    }

    /// Inserts bounds into the tree and returns its assigned ordering.
    ///
    /// The ordering is one greater than the maximum ordering of any
    /// existing bounds that intersect with the new bounds.
    pub fn insert(&mut self, new_bounds: Bounds<U>) -> u32 {
        // Find maximum ordering among intersecting bounds
        let max_intersecting = self.find_max_ordering(&new_bounds);
        let ordering = (max_intersecting + 1).max(self.order_floor);

        // Insert the new leaf
        let new_leaf_idx = self.insert_leaf(new_bounds, ordering);

        // Update max_leaf tracking
        self.max_leaf = match self.max_leaf {
            None => Some(new_leaf_idx),
            Some(old_idx) if self.nodes[old_idx].max_order < ordering => Some(new_leaf_idx),
            some => some,
        };

        ordering
    }

    /// Finds the maximum ordering among all bounds that intersect with the query.
    fn find_max_ordering(&mut self, query: &Bounds<U>) -> u32 {
        let Some(root_idx) = self.root else {
            return 0;
        };

        // Fast path: check if the max-ordering leaf intersects
        if let Some(max_idx) = self.max_leaf {
            let max_node = &self.nodes[max_idx];
            if query.intersects(&max_node.bounds) {
                return max_node.max_order;
            }
        }

        // Slow path: search the tree
        self.search_stack.clear();
        self.search_stack.push(NonNull::from(&self.nodes[root_idx]));

        let mut max_found = 0u32;

        while let Some(node) = self.search_stack.pop() {
            // SAFETY: `node` is guaranteed to be valid as the `nodes` stack is unmodified in this function
            // and the `search_stack` only contains pointers from this function call.
            let node = unsafe { node.as_ref() };

            // Pruning: skip if this subtree can't improve our result
            if node.max_order <= max_found {
                continue;
            }

            // Spatial pruning: skip if bounds don't intersect
            if !query.intersects(&node.bounds) {
                continue;
            }

            match &node.kind {
                NodeKind::Leaf { order } => {
                    max_found = cmp::max(max_found, *order);
                }
                NodeKind::Internal { children } => {
                    // Children are maintained with highest max_order at the end.
                    // Push in forward order to highest (last) is popped first.
                    self.search_stack.extend(
                        children
                            .as_slice()
                            .iter()
                            .map(|&child_idx| &self.nodes[child_idx])
                            .filter(|node| node.max_order > max_found)
                            .map(NonNull::from),
                    );
                }
            }
        }

        max_found
    }

    /// Inserts a leaf node with the given bounds and ordering.
    /// Returns the index of the new leaf.
    fn insert_leaf(&mut self, bounds: Bounds<U>, order: u32) -> usize {
        let new_leaf_idx = self.nodes.len();
        self.nodes.push(Node {
            bounds: bounds.clone(),
            max_order: order,
            height: 0,
            kind: NodeKind::Leaf { order },
        });

        let Some(root_idx) = self.root else {
            // Tree is empty, new leaf becomes root
            self.root = Some(new_leaf_idx);
            return new_leaf_idx;
        };

        // If root is a leaf, create internal node with both
        if matches!(self.nodes[root_idx].kind, NodeKind::Leaf { .. }) {
            let root_bounds = self.nodes[root_idx].bounds.clone();
            let root_order = self.nodes[root_idx].max_order;

            let mut children = NodeChildren::new();
            // Max end invariant
            if order > root_order {
                children.push(root_idx);
                children.push(new_leaf_idx);
            } else {
                children.push(new_leaf_idx);
                children.push(root_idx);
            }

            let new_root_idx = self.nodes.len();
            self.nodes.push(Node {
                bounds: root_bounds.union(&bounds),
                max_order: cmp::max(root_order, order),
                height: 1,
                kind: NodeKind::Internal { children },
            });
            self.root = Some(new_root_idx);
            return new_leaf_idx;
        }

        // Descend to find the best internal node to insert into
        self.insert_path.clear();
        let mut current_idx = root_idx;

        loop {
            let current = &self.nodes[current_idx];
            let NodeKind::Internal { children } = &current.kind else {
                unreachable!("Should only traverse internal nodes");
            };

            self.insert_path.push(current_idx);

            // Keep sibling subtree heights balanced first. Among equally short children,
            // preserve the spatial half-perimeter heuristic.
            let mut best_child_idx = children.as_slice()[0];
            let mut best_child_pos = 0;
            let mut best_height = self.nodes[best_child_idx].height;
            let mut best_cost = bounds
                .union(&self.nodes[best_child_idx].bounds)
                .half_perimeter();

            for (pos, &child_idx) in children.as_slice().iter().enumerate().skip(1) {
                let child_height = self.nodes[child_idx].height;
                let cost = bounds.union(&self.nodes[child_idx].bounds).half_perimeter();
                if child_height < best_height || (child_height == best_height && cost < best_cost) {
                    best_height = child_height;
                    best_cost = cost;
                    best_child_idx = child_idx;
                    best_child_pos = pos;
                }
            }

            // Check if best child is a leaf or internal
            if matches!(self.nodes[best_child_idx].kind, NodeKind::Leaf { .. }) {
                // Best child is a leaf. Check if current node has room for another child.
                if children.len() < MAX_CHILDREN {
                    // Add new leaf directly to this node
                    let node = &mut self.nodes[current_idx];

                    if let NodeKind::Internal { children } = &mut node.kind {
                        children.push(new_leaf_idx);
                        // Swap new leaf only if it has the highest max_order
                        if order <= node.max_order {
                            let last = children.len() - 1;
                            children.indices.swap(last - 1, last);
                        }
                    }

                    node.bounds = node.bounds.union(&bounds);
                    node.max_order = cmp::max(node.max_order, order);
                    break;
                } else {
                    // Node is full, create new internal with [best_leaf, new_leaf]
                    let sibling_bounds = self.nodes[best_child_idx].bounds.clone();
                    let sibling_order = self.nodes[best_child_idx].max_order;

                    let mut new_children = NodeChildren::new();
                    // Max end invariant
                    if order > sibling_order {
                        new_children.push(best_child_idx);
                        new_children.push(new_leaf_idx);
                    } else {
                        new_children.push(new_leaf_idx);
                        new_children.push(best_child_idx);
                    }

                    let new_internal_idx = self.nodes.len();
                    let new_internal_max = cmp::max(sibling_order, order);
                    self.nodes.push(Node {
                        bounds: sibling_bounds.union(&bounds),
                        max_order: new_internal_max,
                        height: 1,
                        kind: NodeKind::Internal {
                            children: new_children,
                        },
                    });

                    // Replace the leaf with the new internal in parent
                    let parent = &mut self.nodes[current_idx];
                    if let NodeKind::Internal { children } = &mut parent.kind {
                        let children_len = children.len();

                        children.indices[best_child_pos] = new_internal_idx;

                        // If new internal has highest max_order, swap it to the end
                        // to maintain sorting invariant
                        if new_internal_max > parent.max_order {
                            children.indices.swap(best_child_pos, children_len - 1);
                        }
                    }
                    break;
                }
            } else {
                // Best child is internal, continue descent
                current_idx = best_child_idx;
            }
        }

        // Propagate bounds and max_order updates up the tree
        let mut updated_child_idx = None;
        for &node_idx in self.insert_path.iter().rev() {
            let height = match &self.nodes[node_idx].kind {
                NodeKind::Leaf { .. } => 0,
                NodeKind::Internal { children } => {
                    children
                        .as_slice()
                        .iter()
                        .map(|&child_idx| self.nodes[child_idx].height)
                        .max()
                        .unwrap_or(0)
                        + 1
                }
            };
            let node = &mut self.nodes[node_idx];
            node.height = height;
            node.bounds = node.bounds.union(&bounds);

            if node.max_order < order {
                node.max_order = order;

                // Swap updated child to end (skip first iteration since the invariant is already handled by previous cases)
                if let Some(child_idx) = updated_child_idx {
                    if let NodeKind::Internal { children } = &mut node.kind {
                        if let Some(pos) = children.as_slice().iter().position(|&c| c == child_idx)
                        {
                            let last = children.len() - 1;
                            if pos != last {
                                children.indices.swap(pos, last);
                            }
                        }
                    }
                }
            }

            updated_child_idx = Some(node_idx);
        }

        new_leaf_idx
    }
}

impl<U> Default for BoundsTree<U>
where
    U: Clone + Debug + Default + PartialEq,
{
    fn default() -> Self {
        BoundsTree {
            nodes: Vec::new(),
            root: None,
            max_leaf: None,
            order_floor: 0,
            insert_path: Vec::new(),
            search_stack: Vec::new(),
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::{Bounds, Point, Size};
    use rand::{Rng, SeedableRng};

    fn bounds(x: f32, y: f32, width: f32, height: f32) -> Bounds<f32> {
        Bounds {
            origin: Point { x, y },
            size: Size { width, height },
        }
    }

    fn check_subtree(tree: &BoundsTree<f32>, index: usize) -> (usize, Bounds<f32>, u32) {
        let node = &tree.nodes[index];
        match &node.kind {
            NodeKind::Leaf { order } => {
                assert_eq!(node.height, 0, "leaf height at node {index}");
                assert_eq!(node.max_order, *order, "leaf max order at node {index}");
                (1, node.bounds.clone(), *order)
            }
            NodeKind::Internal { children } => {
                assert!(
                    (2..=MAX_CHILDREN).contains(&children.len()),
                    "internal child count at node {index}"
                );
                let mut leaf_count = 0;
                let mut expected_bounds: Option<Bounds<f32>> = None;
                let mut expected_max = 0;
                let mut child_min_height = u32::MAX;
                let mut child_max_height = 0u32;
                let mut last_child_max = 0;
                for &child in children.as_slice() {
                    let (child_leaves, child_bounds, child_max) = check_subtree(tree, child);
                    leaf_count += child_leaves;
                    expected_bounds = Some(match expected_bounds {
                        Some(bounds) => bounds.union(&child_bounds),
                        None => child_bounds,
                    });
                    expected_max = expected_max.max(child_max);
                    child_min_height = child_min_height.min(tree.nodes[child].height);
                    child_max_height = child_max_height.max(tree.nodes[child].height);
                    last_child_max = child_max;
                }
                assert!(
                    child_max_height - child_min_height <= 1,
                    "unbalanced children at node {index}: min={child_min_height}, max={child_max_height}"
                );
                assert_eq!(node.height, child_max_height + 1, "height at node {index}");
                assert_eq!(node.max_order, expected_max, "max order at node {index}");
                assert_eq!(
                    last_child_max, expected_max,
                    "max-order child must be last at node {index}"
                );
                assert_eq!(
                    node.bounds,
                    expected_bounds.unwrap(),
                    "bounds at node {index}"
                );
                (leaf_count, node.bounds.clone(), expected_max)
            }
        }
    }

    fn verify_structure_and_queries(tree: &mut BoundsTree<f32>, inserted: &[(Bounds<f32>, u32)]) {
        let Some(root) = tree.root else {
            assert!(inserted.is_empty());
            return;
        };
        let (leaf_count, _, max_order) = check_subtree(tree, root);
        assert_eq!(leaf_count, inserted.len());
        assert_eq!(tree.max_order(), max_order);
        let ceil_log2 = usize::BITS as usize - (leaf_count + 1).leading_zeros() as usize;
        let height = usize::try_from(tree.nodes[root].height).expect("tree height fits usize");
        assert!(
            height <= 2 * ceil_log2,
            "tree height {} exceeds conservative logarithmic bound for {leaf_count} leaves",
            height
        );

        for (index, (query, _)) in inserted.iter().enumerate().step_by(7) {
            let expected = inserted
                .iter()
                .filter_map(|(bounds, order)| bounds.intersects(query).then_some(*order))
                .max()
                .unwrap_or(0);
            assert_eq!(
                tree.find_max_ordering(query),
                expected,
                "query at insertion {index}"
            );
        }
    }

    fn exercise_sequence(sequence: Vec<(Bounds<f32>, bool, u32)>) {
        let mut tree = BoundsTree::default();
        let mut reference: Vec<(Bounds<f32>, u32)> = Vec::new();
        let mut floor = 0;
        for (index, (rect, insert_above_all, requested_floor)) in sequence.into_iter().enumerate() {
            floor = floor.max(requested_floor);
            tree.set_order_floor(floor);
            let expected = if insert_above_all {
                reference.iter().map(|(_, order)| *order).max().unwrap_or(0) + 1
            } else {
                reference
                    .iter()
                    .filter_map(|(old, order)| old.intersects(&rect).then_some(*order))
                    .max()
                    .unwrap_or(0)
                    .saturating_add(1)
                    .max(floor)
            };
            let actual = if insert_above_all {
                tree.insert_above_all(rect.clone())
            } else {
                tree.insert(rect.clone())
            };
            assert_eq!(actual, expected, "insert {index}");
            reference.push((rect, actual));
        }
        verify_structure_and_queries(&mut tree, &reference);
    }

    #[test]
    fn height_first_insertion_stays_balanced_for_adversarial_shapes() {
        const N: usize = 768;

        let monotonic_tall = (0..N)
            .map(|i| (bounds(0.0, i as f32 * 12.0, 8.0, 8.0), false, 0))
            .collect();
        exercise_sequence(monotonic_tall);

        let alternating_clusters = (0..N)
            .map(|i| {
                let x = if i % 2 == 0 { -10_000.0 } else { 10_000.0 };
                (
                    bounds(x + (i % 13) as f32 * 3.0, (i / 13) as f32 * 11.0, 4.0, 4.0),
                    false,
                    0,
                )
            })
            .collect();
        exercise_sequence(alternating_clusters);

        let overlap_heavy = (0..N)
            .map(|i| {
                let x = (i % 37) as f32 * 1.7;
                let y = ((i * 19) % 41) as f32 * 1.3;
                (bounds(x, y, 90.0, 90.0), false, 0)
            })
            .collect();
        exercise_sequence(overlap_heavy);

        let mixed_floor_and_global_order = (0..N)
            .map(|i| {
                let rect = bounds(
                    ((i * 17) % 43) as f32 * 9.0,
                    ((i * 29) % 47) as f32 * 7.0,
                    18.0 + (i % 5) as f32,
                    12.0 + (i % 3) as f32,
                );
                let above_all = i % 23 == 0;
                let floor = if i % 71 == 0 {
                    (i / 71 + 1) as u32 * 3
                } else {
                    0
                };
                (rect, above_all, floor)
            })
            .collect();
        exercise_sequence(mixed_floor_and_global_order);
    }

    #[test]
    fn test_insert() {
        let mut tree = BoundsTree::<f32>::default();
        let bounds1 = Bounds {
            origin: Point { x: 0.0, y: 0.0 },
            size: Size {
                width: 10.0,
                height: 10.0,
            },
        };
        let bounds2 = Bounds {
            origin: Point { x: 5.0, y: 5.0 },
            size: Size {
                width: 10.0,
                height: 10.0,
            },
        };
        let bounds3 = Bounds {
            origin: Point { x: 10.0, y: 10.0 },
            size: Size {
                width: 10.0,
                height: 10.0,
            },
        };

        // Insert the bounds into the tree and verify the order is correct
        assert_eq!(tree.insert(bounds1), 1);
        assert_eq!(tree.insert(bounds2), 2);
        assert_eq!(tree.insert(bounds3), 3);

        // Insert non-overlapping bounds and verify they can reuse orders
        let bounds4 = Bounds {
            origin: Point { x: 20.0, y: 20.0 },
            size: Size {
                width: 10.0,
                height: 10.0,
            },
        };
        let bounds5 = Bounds {
            origin: Point { x: 40.0, y: 40.0 },
            size: Size {
                width: 10.0,
                height: 10.0,
            },
        };
        let bounds6 = Bounds {
            origin: Point { x: 25.0, y: 25.0 },
            size: Size {
                width: 10.0,
                height: 10.0,
            },
        };
        assert_eq!(tree.insert(bounds4), 1); // bounds4 does not overlap with bounds1, bounds2, or bounds3
        assert_eq!(tree.insert(bounds5), 1); // bounds5 does not overlap with any other bounds
        assert_eq!(tree.insert(bounds6), 2); // bounds6 overlaps with bounds4, so it should have a different order
    }

    #[test]
    fn test_random_iterations() {
        let max_bounds = 100;
        for seed in 1..=1000 {
            // let seed = 44;
            let mut tree = BoundsTree::default();
            let mut rng = rand::rngs::StdRng::seed_from_u64(seed as u64);
            let mut expected_quads: Vec<(Bounds<f32>, u32)> = Vec::new();

            // Insert a random number of random AABBs into the tree.
            let num_bounds = rng.random_range(1..=max_bounds);
            for _ in 0..num_bounds {
                let min_x: f32 = rng.random_range(-100.0..100.0);
                let min_y: f32 = rng.random_range(-100.0..100.0);
                let width: f32 = rng.random_range(0.0..50.0);
                let height: f32 = rng.random_range(0.0..50.0);
                let bounds = Bounds {
                    origin: Point { x: min_x, y: min_y },
                    size: Size { width, height },
                };

                let expected_ordering = expected_quads
                    .iter()
                    .filter_map(|quad| quad.0.intersects(&bounds).then_some(quad.1))
                    .max()
                    .unwrap_or(0)
                    + 1;
                expected_quads.push((bounds, expected_ordering));

                // Insert the AABB into the tree and collect intersections.
                let actual_ordering = tree.insert(bounds);
                assert_eq!(actual_ordering, expected_ordering);
            }
        }
    }
}
