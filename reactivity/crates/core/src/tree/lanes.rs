//! Synchronous batches of independent, immutable parent chains.
//! External tasks never enter this executor: Pending means one memory stage.
use super::{NIL, NodeId, Tree, TreeError};
use std::{
    future::Future,
    pin::Pin,
    task::{Context, Poll, Waker},
};

// Experiment alternatives: original=0, validated scalar=1, levels=2,
// Future without hints=3, Future with hints=4, single-root proof=5.
pub(crate) const STRATEGY: u8 = 4;
const WIDTH: usize = 32;

impl Tree {
    pub(crate) fn select_pending_root(
        &self,
        pending: impl Iterator<Item = NodeId>,
        root: NodeId,
    ) -> Vec<NodeId> {
        if STRATEGY == 5 && self.entries[self.first as usize].next == NIL {
            // compute validates root as a live root. Exactly one forest root
            // therefore proves every admitted pending node belongs to it.
            return pending.collect();
        }
        let mut selected = Vec::new();
        let mut pending = pending.peekable();
        while pending.peek().is_some() {
            let ids = std::array::from_fn::<_, WIDTH, _>(|_| pending.next());
            let roots = self.root_batch(ids).expect("pending IDs remain live");
            for (id, found) in ids.into_iter().zip(roots) {
                if found == Some(root) {
                    selected.push(id.unwrap());
                }
            }
        }
        selected
    }

    fn root_batch<const N: usize>(
        &self,
        ids: [Option<NodeId>; N],
    ) -> Result<[Option<NodeId>; N], TreeError> {
        assert!(N <= 64);
        // Admit the complete batch before scheduling. No topology mutation is
        // possible until every lane and its shared borrow has ended.
        let mut slots = [NIL; N];
        for (slot, id) in slots.iter_mut().zip(ids) {
            if let Some(id) = id {
                *slot = self.index(id)?;
            }
        }
        if STRATEGY == 1 {
            return Ok(slots.map(|mut index| {
                if index == NIL {
                    return None;
                }
                while self.parents[index as usize] != NIL {
                    index = self.parents[index as usize];
                }
                Some(self.id(index))
            }));
        }
        let mut output = [None; N];
        let mut live = slots.iter().enumerate().fold(0_u64, |bits, (i, slot)| {
            bits | (u64::from(*slot != NIL) << i)
        });
        if STRATEGY == 2 {
            while live != 0 {
                let mut round = live;
                while round != 0 {
                    let i = round.trailing_zeros() as usize;
                    round &= round - 1;
                    let parent = self.parents[slots[i] as usize];
                    if parent == NIL {
                        output[i] = Some(self.id(slots[i]));
                        live &= !(1_u64 << i);
                    } else {
                        slots[i] = parent;
                    }
                }
            }
            return Ok(output);
        }
        let mut lanes = slots.map(|index| {
            if index != NIL && STRATEGY == 4 {
                hint(&self.parents[index as usize]);
            }
            RootLane { tree: self, index }
        });
        let mut context = Context::from_waker(Waker::noop());
        while live != 0 {
            let mut round = live;
            while round != 0 {
                let i = round.trailing_zeros() as usize;
                round &= round - 1;
                if let Poll::Ready(root) = Pin::new(&mut lanes[i]).poll(&mut context) {
                    output[i] = Some(root);
                    live &= !(1_u64 << i);
                }
            }
        }
        Ok(output)
    }
}

// Explicit Unpin future: state is one immutable tree borrow and a current slot.
// No self-reference, heap allocation, vtable or unchecked pinned projection.
struct RootLane<'a> {
    tree: &'a Tree,
    index: u32,
}
impl Future for RootLane<'_> {
    type Output = NodeId;
    #[inline]
    fn poll(mut self: Pin<&mut Self>, _: &mut Context<'_>) -> Poll<NodeId> {
        let parent = self.tree.parents[self.index as usize];
        if parent == NIL {
            return Poll::Ready(self.tree.id(self.index));
        }
        self.index = parent;
        if STRATEGY == 4 {
            hint(&self.tree.parents[parent as usize]);
        }
        Poll::Pending
    }
}

#[inline]
#[allow(unsafe_code)]
fn hint(entry: &u32) {
    #[cfg(all(target_arch = "x86_64", not(miri)))]
    // SAFETY: SSE is baseline on x86_64. This is only a non-dereferencing cache
    // hint; the address also names a live, aligned parent slot throughout the batch.
    // No mutation/reallocation can occur under the owning Tree's shared borrow.
    unsafe {
        std::arch::x86_64::_mm_prefetch(
            std::ptr::from_ref(entry).cast(),
            std::arch::x86_64::_MM_HINT_T0,
        );
    }
    #[cfg(any(not(target_arch = "x86_64"), miri))]
    let _ = entry;
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::NodeKind;
    fn oracle(tree: &Tree, mut node: NodeId) -> NodeId {
        while let Some(parent) = tree.parent(node).unwrap() {
            node = parent;
        }
        node
    }
    #[test]
    fn batches_preserve_order_lifecycle_and_full_capabilities() {
        let mut tree = Tree::new();
        let roots: Vec<_> = (0..5)
            .map(|_| tree.insert(None, NodeKind::Element).unwrap())
            .collect();
        let mut nodes = roots.clone();
        for i in 0..511 {
            let parent = nodes[(i * 37 + 3) % nodes.len()];
            nodes.push(tree.insert(Some(parent), NodeKind::Element).unwrap());
        }
        for offset in 0..nodes.len() {
            let ids = std::array::from_fn::<_, 32, _>(|i| {
                (i % 7 != 0).then_some(nodes[(offset + i * 19) % nodes.len()])
            });
            assert_eq!(
                tree.root_batch(ids).unwrap(),
                ids.map(|id| id.map(|id| oracle(&tree, id)))
            );
        }
        assert_eq!(tree.root_batch::<0>([]).unwrap(), []);
        assert_eq!(tree.root_batch([None; 64]).unwrap(), [None; 64]);
        let moving = *nodes.last().unwrap();
        tree.reparent(moving, Some(roots[3])).unwrap();
        assert_eq!(
            tree.root_batch([Some(moving), Some(roots[0])]).unwrap(),
            [Some(roots[3]), Some(roots[0])]
        );
        tree.remove(moving).unwrap();
        let reused = tree.insert(Some(roots[2]), NodeKind::Element).unwrap();
        assert_eq!(tree.root_batch([Some(reused)]).unwrap(), [Some(roots[2])]);
        assert_eq!(tree.root_batch([Some(moving)]), Err(TreeError::InvalidNode));
        let mut foreign = Tree::new();
        let foreign = foreign.insert(None, NodeKind::Element).unwrap();
        assert_eq!(
            tree.root_batch([Some(foreign)]),
            Err(TreeError::InvalidNode)
        );
    }
}
