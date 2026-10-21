//! Identity lookup borrows the canonical nodes. Only a permuted tree needs an
//! index allocation; its entries are bounded positions, never repeated IDs.
//! Shared slice access keeps retained identities/order immutable until replace.
use super::{MAX_NODES, Node};
use std::ops::Deref;

#[derive(Default)]
pub(super) struct Nodes {
    items: Vec<Node>,
    order: Option<Box<[u32]>>,
}
impl Nodes {
    pub(super) fn take(&mut self) -> Vec<Node> {
        // Retain the permutation's allocation for the replacement. Lookup on
        // this empty tree returns None, including if reconciliation unwinds.
        std::mem::take(&mut self.items)
    }
    pub(super) fn replace(&mut self, items: Vec<Node>) {
        assert!(items.len() <= MAX_NODES);
        self.items = items;
        if self
            .items
            .windows(2)
            .all(|pair| pair[0].identity() < pair[1].identity())
        {
            self.order = None;
        } else {
            let mut order = self
                .order
                .take()
                .map_or_else(Vec::new, |order| order.into_vec());
            order.clear();
            order.extend(0..self.items.len() as u32);
            order.sort_unstable_by_key(|&index| self.items[index as usize].identity());
            self.order = Some(order.into_boxed_slice());
        }
    }
    pub(super) fn locate(&self, identity: u64) -> Option<usize> {
        let first = self.items.first()?;
        if let Some(order) = &self.order {
            order
                .binary_search_by_key(&identity, |&index| self.items[index as usize].identity())
                .ok()
                .map(|index| order[index] as usize)
        } else {
            // Initial and unchanged descriptions commonly have contiguous IDs.
            // The equality check also admits gaps without trusting arithmetic
            // as authority. A miss searches the already sorted canonical lane.
            if let Some(index) = identity
                .checked_sub(first.identity())
                .and_then(|offset| usize::try_from(offset).ok())
                .filter(|&index| {
                    self.items
                        .get(index)
                        .is_some_and(|node| node.identity() == identity)
                })
            {
                return Some(index);
            }
            self.items
                .binary_search_by_key(&identity, Node::identity)
                .ok()
        }
    }
    #[cfg(test)]
    pub(super) fn capacity(&self) -> usize {
        self.items.capacity()
    }
}
impl Deref for Nodes {
    type Target = [Node];
    fn deref(&self) -> &[Node] {
        &self.items
    }
}
#[cfg(test)]
mod tests {
    use super::*;
    use crate::{
        element::NodeKind,
        runtime::{Content, Parent, TextSlot},
    };
    use std::{collections::BTreeMap, num::NonZeroU64};

    fn nodes(ids: &[u64]) -> Vec<Node> {
        ids.iter()
            .map(|&identity| Node {
                identity: NonZeroU64::new(identity).unwrap(),
                parent: Parent::NONE,
                ordinal: 0,
                content: Content::new(NodeKind::Div, TextSlot::NONE),
                component_scope: 0,
                handler: None,
            })
            .collect()
    }
    fn compare(index: &Nodes, ids: &[u64]) {
        let oracle: BTreeMap<_, _> = ids
            .iter()
            .copied()
            .enumerate()
            .map(|(i, id)| (id, i))
            .collect();
        for id in ids
            .iter()
            .copied()
            .chain([0, 1, 2, 5, 9, 100, u64::MAX - 1, u64::MAX])
        {
            assert_eq!(index.locate(id), oracle.get(&id).copied(), "{ids:?}: {id}");
        }
    }
    #[test]
    fn sorted_gaps_extreme_ids_and_replacement_revoke_old_membership() {
        let mut index = Nodes::default();
        for ids in [
            &[][..],
            &[1, 2, 3],
            &[1, 3, 7, 100],
            &[u64::MAX - 2, u64::MAX - 1, u64::MAX],
            &[5, 2, 1],
            &[9, 100],
            &[],
        ] {
            index.replace(nodes(ids));
            compare(&index, ids);
            assert_eq!(
                index.order.is_none(),
                ids.windows(2).all(|pair| pair[0] < pair[1])
            );
        }
    }
    #[test]
    fn every_small_permutation_matches_the_independent_map() {
        fn visit(index: &mut Nodes, ids: &mut [u64], start: usize) {
            if start == ids.len() {
                index.replace(nodes(ids));
                compare(index, ids);
                return;
            }
            for next in start..ids.len() {
                ids.swap(start, next);
                visit(index, ids, start + 1);
                ids.swap(start, next);
            }
        }
        visit(
            &mut Nodes::default(),
            &mut [1, 2, 4, 7, 9, 100, u64::MAX],
            0,
        );
    }
    #[test]
    fn taken_tree_is_empty_even_with_a_retained_permutation() {
        let mut index = Nodes::default();
        index.replace(nodes(&[3, 1, 2]));
        drop(index.take());
        assert!(index.order.is_some());
        compare(&index, &[]);
        index.replace(nodes(&[5, 2, 9]));
        compare(&index, &[5, 2, 9]);
        index.replace(nodes(&[5, 7, 9]));
        assert!(index.order.is_none());
        compare(&index, &[5, 7, 9]);
    }
}
