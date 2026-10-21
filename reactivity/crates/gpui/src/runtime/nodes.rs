//! Identity lookup borrows the canonical nodes. Only a permuted tree needs an
//! index allocation; its entries are bounded positions, never repeated IDs.
//! Shared slice access keeps retained identities/order immutable until replace.
use super::{MAX_NODES, Node};
use std::ops::Deref;

#[derive(Default)]
pub(super) struct Nodes {
    items: Vec<Node>,
    index: Option<Box<Index>>,
}
enum Index {
    // The bounded span belongs to the current tree, not its lifetime ID history.
    Dense { first: u64, positions: Box<[u32]> },
    Sorted(Box<[u32]>),
}
impl Index {
    fn take_positions(&mut self) -> Vec<u32> {
        std::mem::take(match self {
            Self::Dense { positions, .. } | Self::Sorted(positions) => positions,
        })
        .into_vec()
    }
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
            self.index = None;
        } else {
            let first = self.items.iter().map(Node::identity).min().unwrap();
            let last = self.items.iter().map(Node::identity).max().unwrap();
            let span = last.checked_sub(first).and_then(|n| n.checked_add(1));
            let mut index = self.index.take();
            let mut positions = index
                .as_deref_mut()
                .map_or_else(Vec::new, Index::take_positions);
            positions.clear();
            let replacement = if let Some(span) = span
                .and_then(|span| usize::try_from(span).ok())
                .filter(|&span| span <= self.items.len() * 2)
            {
                positions.resize(span, u32::MAX);
                for (position, node) in self.items.iter().enumerate() {
                    positions[(node.identity() - first) as usize] = position as u32;
                }
                Index::Dense {
                    first,
                    positions: positions.into_boxed_slice(),
                }
            } else {
                positions.extend(0..self.items.len() as u32);
                positions.sort_unstable_by_key(|&index| self.items[index as usize].identity());
                Index::Sorted(positions.into_boxed_slice())
            };
            if let Some(index) = &mut index {
                **index = replacement;
            } else {
                index = Some(Box::new(replacement));
            }
            self.index = index;
        }
    }
    pub(super) fn locate(&self, identity: u64) -> Option<usize> {
        let first = self.items.first()?;
        if let Some(index) = self.index.as_deref() {
            return match index {
                Index::Dense { first, positions } => identity
                    .checked_sub(*first)
                    .and_then(|offset| usize::try_from(offset).ok())
                    .and_then(|offset| positions.get(offset))
                    .copied()
                    .filter(|&position| position != u32::MAX)
                    .map(|position| position as usize),
                Index::Sorted(order) => order
                    .binary_search_by_key(&identity, |&index| self.items[index as usize].identity())
                    .ok()
                    .map(|index| order[index] as usize),
            };
        }
        // Initial and unchanged descriptions commonly have contiguous IDs.
        // The equality check also admits gaps without trusting arithmetic
        // as authority. A miss searches the already sorted canonical lane.
        let offset = identity.checked_sub(first.identity())?;
        let index = usize::try_from(offset)
            .unwrap_or(usize::MAX)
            .min(self.items.len() - 1);
        let node = &self.items[index];
        if node.identity() == identity {
            return Some(index);
        }
        // One corrective probe handles a uniform gap before this position
        // without retained gap metadata. Clamping also checks the last node
        // directly. These are predictions: canonical ID equality is authority.
        if let Some(corrected) = node
            .identity()
            .checked_sub(identity)
            .and_then(|gap| usize::try_from(gap).ok())
            .and_then(|gap| index.checked_sub(gap))
            .filter(|&corrected| self.items[corrected].identity() == identity)
        {
            return Some(corrected);
        }
        self.items
            .binary_search_by_key(&identity, Node::identity)
            .ok()
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
            .chain(0..=20)
            .chain([100, u64::MAX - 1, u64::MAX])
        {
            assert_eq!(index.locate(id), oracle.get(&id).copied(), "{ids:?}: {id}");
        }
        if let Some(Index::Dense { positions, .. }) = index.index.as_deref()
            && !index.items.is_empty()
        {
            assert!(positions.len() <= index.items.len() * 2);
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
                index.index.is_none(),
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
        for mut ids in [
            [1, 2, 3, 4, 5, 6, 7],
            [1, 2, 4, 7, 9, 10, 11],
            [1, 2, 4, 7, 9, 100, u64::MAX],
        ] {
            visit(&mut Nodes::default(), &mut ids, 0);
        }
    }
    #[test]
    fn dense_and_sparse_domains_replace_each_other_without_lifetime_id_growth() {
        let mut index = Nodes::default();
        let first = nodes(&[6, 1, 3]);
        let allocation = allocation_counter::measure(|| index.replace(first));
        assert_eq!(allocation.count_total, 2);
        assert_eq!(
            allocation.bytes_current,
            (std::mem::size_of::<Index>() + 6 * std::mem::size_of::<u32>()) as i64
        );
        println!(
            "Nodes={} Index={} dense_first_allocations={} dense_first_requested={}",
            std::mem::size_of::<Nodes>(),
            std::mem::size_of::<Index>(),
            allocation.count_total,
            allocation.bytes_current
        );
        for ids in [
            &[5, 1, 3][..],
            &[6, 1, 3], // Dense at the exact inclusive 2N boundary, with holes.
            &[7, 1, 3], // Sparse just beyond that boundary.
            &[u64::MAX, 1],
            &[u64::MAX, u64::MAX - 2, u64::MAX - 1],
            &[100, 101, 102],
        ] {
            index.replace(nodes(ids));
            compare(&index, ids);
            if ids.windows(2).all(|pair| pair[0] < pair[1]) {
                assert!(index.index.is_none());
            } else {
                let span = ids.iter().max().unwrap() - ids.iter().min().unwrap();
                assert_eq!(
                    matches!(index.index.as_deref(), Some(Index::Dense { .. })),
                    span < (ids.len() * 2) as u64
                );
            }
        }
        for gap in 1..32 {
            let ids: Vec<_> = (1..64).map(|n| n + u64::from(n >= 8) * gap).collect();
            index.replace(nodes(&ids));
            compare(&index, &ids);
            for missing in 8..8 + gap {
                assert_eq!(index.locate(missing), None);
            }
        }
    }
    #[test]
    fn taken_tree_is_empty_even_with_a_retained_permutation() {
        let mut index = Nodes::default();
        index.replace(nodes(&[3, 1, 2]));
        drop(index.take());
        assert!(index.index.is_some());
        compare(&index, &[]);
        index.replace(nodes(&[5, 2, 9]));
        compare(&index, &[5, 2, 9]);
        index.replace(nodes(&[5, 7, 9]));
        assert!(index.index.is_none());
        compare(&index, &[5, 7, 9]);
    }
}
