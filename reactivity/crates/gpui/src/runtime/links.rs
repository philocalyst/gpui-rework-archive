//! Three independently bounded logical indices share one word. No pointers or
//! externally actionable identities are compressed here.
use super::{MAX_NODES, Parent};

const BITS: u32 = usize::BITS - MAX_NODES.leading_zeros();
const MASK: u64 = (1 << BITS) - 1;
const VIEWPORT_ANCESTOR: u64 = 1 << (BITS * 3);
const VIEWPORT_SUBTREE: u64 = 1 << (BITS * 3 + 1);
const VIEWPORT_FLAGS: u64 = VIEWPORT_ANCESTOR | VIEWPORT_SUBTREE;
const _: () = assert!(BITS * 3 + 2 <= u64::BITS && MAX_NODES as u64 <= MASK);

pub(super) struct NodeLinks(u64);
impl NodeLinks {
    pub(super) fn new(parent: Option<usize>, ordinal: u32, handler: Option<usize>) -> Self {
        assert!((ordinal as usize) < MAX_NODES, "admitted sibling ordinal");
        Self(
            Self::optional(parent)
                | ((ordinal as u64) << BITS)
                | (Self::optional(handler) << (BITS * 2)),
        )
    }
    // Recomputed for every NEW admitted description, including reused nodes.
    // ancestor includes self; subtree includes self and every closed child.
    pub(super) fn set_viewport_flags(&mut self, ancestor: bool, subtree: bool) {
        self.0 = (self.0 & !VIEWPORT_FLAGS)
            | (u64::from(ancestor) * VIEWPORT_ANCESTOR)
            | (u64::from(subtree) * VIEWPORT_SUBTREE);
    }
    pub(super) fn viewport_ancestor(&self) -> bool {
        self.0 & VIEWPORT_ANCESTOR != 0
    }
    pub(super) fn viewport_subtree(&self) -> bool {
        self.0 & VIEWPORT_SUBTREE != 0
    }
    // A completed child can only add evidence to its parent's current subtree.
    pub(super) fn include_viewport_subtree(&mut self, present: bool) {
        self.0 |= u64::from(present) * VIEWPORT_SUBTREE;
    }
    fn optional(index: Option<usize>) -> u64 {
        index.map_or(0, |index| {
            assert!(index < MAX_NODES, "admitted logical index");
            index as u64 + 1
        })
    }
    pub(super) fn parent(&self) -> Parent {
        // Only new constructs this word, and it admits every stored index.
        // Zero maps to Parent::NONE; an encoded index + 1 maps to that index.
        Parent(((self.0 & MASK) as u32).wrapping_sub(1))
    }
    pub(super) fn ordinal(&self) -> u32 {
        ((self.0 >> BITS) & MASK) as u32
    }
    pub(super) fn handler(&self) -> Option<usize> {
        ((self.0 >> (BITS * 2)) & MASK)
            .checked_sub(1)
            .map(|index| index as usize)
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    #[inline(never)]
    fn emitted_parent_probe(links: &NodeLinks) -> Parent {
        links.parent()
    }
    #[test]
    fn independent_indices_cover_every_admitted_value_and_do_not_alias() {
        assert_eq!(size_of::<NodeLinks>(), 8);
        for index in 0..MAX_NODES {
            for (parent, handler) in [
                (None, None),
                (Some(index), None),
                (None, Some(index)),
                (Some(index), Some(MAX_NODES - 1 - index)),
            ] {
                let mut links = NodeLinks::new(parent, index as u32, handler);
                assert!(!links.viewport_ancestor());
                assert!(!links.viewport_subtree());
                for (ancestor, subtree) in [(false, false), (false, true),
                                            (true, false), (true, true)] {
                    links.set_viewport_flags(ancestor, subtree);
                    assert_eq!(links.viewport_ancestor(), ancestor);
                    assert_eq!(links.viewport_subtree(), subtree);
                    assert_eq!(
                        emitted_parent_probe(std::hint::black_box(&links)).index(),
                        parent
                    );
                    assert_eq!(links.ordinal(), index as u32);
                    assert_eq!(links.handler(), handler);
                    links.include_viewport_subtree(false);
                    assert_eq!(links.viewport_subtree(), subtree);
                    links.include_viewport_subtree(true);
                    assert!(links.viewport_subtree());
                    assert_eq!(links.viewport_ancestor(), ancestor);
                    assert_eq!(links.parent().index(), parent);
                    assert_eq!(links.ordinal(), index as u32);
                    assert_eq!(links.handler(), handler);
                    // Reset must clear earlier subtree evidence on reuse.
                    links.set_viewport_flags(false, false);
                    assert!(!links.viewport_ancestor());
                    assert!(!links.viewport_subtree());
                }
            }
        }
    }
    #[test]
    fn out_of_domain_indices_are_rejected_before_encoding() {
        for make in [
            || NodeLinks::new(Some(MAX_NODES), 0, None),
            || NodeLinks::new(None, MAX_NODES as u32, None),
            || NodeLinks::new(None, 0, Some(MAX_NODES)),
        ] {
            assert!(std::panic::catch_unwind(make).is_err());
        }
    }
}
