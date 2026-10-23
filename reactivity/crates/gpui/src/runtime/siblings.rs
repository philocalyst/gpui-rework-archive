//! Temporary direct-child addressing for a complete logical description.
use super::{Node, Parent};

#[derive(Default)]
pub(super) enum Siblings {
    #[default]
    Empty,
    Root,
    Indexed(Vec<u32>),
}
impl Siblings {
    pub(super) fn new(nodes: &[Node]) -> Self {
        if nodes.is_empty() {
            return Self::default();
        }
        if nodes.len() == 1 {
            debug_assert!(nodes[0].parent.index().is_none());
            return Self::Root;
        }
        // Slot zero is the virtual root; every real parent uses its old row + 1.
        // Admission bounds both row indices and prefix sums by MAX_NODES.
        let mut words = vec![0u32; nodes.len() * 2 + 2];
        let (offsets, children) = words.split_at_mut(nodes.len() + 2);
        for node in nodes {
            offsets[slot(node.parent) + 1] += 1;
        }
        for index in 1..offsets.len() {
            offsets[index] += offsets[index - 1];
        }
        for (index, node) in nodes.iter().enumerate() {
            // Ordinals already enumerate each parent's admitted child run.
            children[(offsets[slot(node.parent)] + node.ordinal) as usize] = index as u32;
        }
        Self::Indexed(words)
    }

    pub(super) fn children(&self, parent: Parent) -> &[u32] {
        let words = match self {
            Self::Empty => return &[],
            Self::Root => return if parent.index().is_none() { &[0] } else { &[] },
            Self::Indexed(words) => words,
        };
        // A nonempty buffer holds N+2 offsets followed by N child addresses.
        let (offsets, children) = words.split_at(words.len() / 2 + 1);
        match offsets.get(slot(parent)..slot(parent) + 2) {
            Some([start, end]) => &children[*start as usize..*end as usize],
            _ => &[],
        }
    }
}
fn slot(parent: Parent) -> usize {
    parent.index().map_or(0, |index| index + 1)
}

#[cfg(test)]
mod tests {
    use super::super::{Content, MAX_NODES, NodeKind, TextSlot};
    use super::*;
    use std::{collections::BTreeMap, num::NonZeroU64};

    fn tree(count: usize, shape: usize) -> Vec<Node> {
        let mut ordinals = vec![0; count + 1];
        (0..count)
            .map(|index| {
                let parent = if index == 0 || index % 19 == 0 {
                    None
                } else {
                    Some(match shape {
                        0 => 0,
                        1 => index - 1,
                        _ => (index * 17 + 31) % index,
                    })
                };
                let ordinal = &mut ordinals[parent.map_or(0, |parent| parent + 1)];
                let node = Node {
                    // Reverse full-width identities force the non-affine lookup.
                    identity: NonZeroU64::new(u64::MAX - index as u64 * 2).unwrap(),
                    parent: Parent::new(parent),
                    ordinal: *ordinal,
                    content: Content::new(
                        match index % 4 {
                            0 => NodeKind::Div,
                            1 => NodeKind::Button,
                            2 => NodeKind::CheckBox(false),
                            _ => NodeKind::CheckBox(true),
                        },
                        TextSlot::NONE,
                    ),
                    component_scope: 0,
                    handler: None,
                };
                *ordinal += 1;
                node
            })
            .collect()
    }

    #[test]
    fn flat_children_match_the_previous_identity_ordinal_kind_maps() {
        for count in [0, 1, 2, 32, 1024, MAX_NODES] {
            for shape in 0..3 {
                let nodes = tree(count, shape);
                let parent_id = |node: &Node| node.parent.index().map(|i| nodes[i].identity());
                let mut counts = BTreeMap::new();
                let mut sites = BTreeMap::new();
                for (index, node) in nodes.iter().enumerate() {
                    *counts.entry(parent_id(node)).or_insert(0) += 1;
                    sites.insert(
                        (parent_id(node), node.ordinal, node.kind().site_kind()),
                        index,
                    );
                }
                let siblings = Siblings::new(&nodes);
                for parent in std::iter::once(None).chain((0..nodes.len()).map(Some)) {
                    let id = parent.map(|index| nodes[index].identity());
                    let children = siblings.children(Parent::new(parent));
                    assert_eq!(children.len(), counts.get(&id).copied().unwrap_or(0));
                    for (ordinal, &index) in children.iter().enumerate() {
                        let node = &nodes[index as usize];
                        assert_eq!(
                            sites.get(&(id, ordinal as u32, node.kind().site_kind())),
                            Some(&(index as usize))
                        );
                    }
                }
            }
        }
    }

    #[test]
    fn scratch_is_two_bounded_arrays_and_empty_or_root_allocates_nothing() {
        assert_eq!(size_of::<Siblings>(), 24);
        for count in [0, 1, 32, 1024, MAX_NODES] {
            let nodes = tree(count, 2);
            let mut siblings = Siblings::default();
            let allocation = allocation_counter::measure(|| siblings = Siblings::new(&nodes));
            assert_eq!(allocation.count_total, u64::from(count > 1));
            let requested = if count <= 1 {
                0
            } else {
                (count * 2 + 2) * size_of::<u32>()
            };
            assert_eq!(allocation.bytes_total, requested as u64);
            assert_eq!(allocation.bytes_current, requested as i64);
            assert_eq!(
                siblings.children(Parent::NONE).len(),
                nodes
                    .iter()
                    .filter(|node| node.parent.index().is_none())
                    .count()
            );
        }
    }
}
