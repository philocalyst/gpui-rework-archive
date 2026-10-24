//! Bounded inherited state for validated preorder walks. Leaves need no entry.
const INLINE: usize = 4;

pub(super) struct Frontier<T> {
    inline: [T; INLINE],
    spill: Vec<T>,
    len: usize,
    root: T,
    spill_capacity: usize,
}
impl<T: Copy> Frontier<T> {
    pub(super) fn new(root: T, depth: usize) -> Self {
        Self {
            inline: [root; INLINE],
            spill: Vec::new(),
            len: 0,
            root,
            spill_capacity: depth.saturating_sub(INLINE),
        }
    }
    pub(super) fn top(&self) -> T {
        if self.len == 0 {
            self.root
        } else if self.len <= INLINE {
            self.inline[self.len - 1]
        } else {
            self.spill[self.len - 1 - INLINE]
        }
    }
    pub(super) fn pop(&mut self) {
        self.len -= 1;
    }
    pub(super) fn push(&mut self, value: T) {
        if self.len < INLINE {
            self.inline[self.len] = value;
        } else {
            let slot = self.len - INLINE;
            if slot < self.spill.len() {
                self.spill[slot] = value;
            } else {
                if self.spill.is_empty() {
                    // Admission already measured the exact maximum ancestor
                    // depth. Reserve once, initializing only visited entries.
                    self.spill.reserve_exact(self.spill_capacity);
                }
                self.spill.push(value);
            }
        }
        self.len += 1;
    }
}

#[cfg(test)]
mod tests {
    use super::super::{ClipFrame, MAX_LAYOUT_DEPTH, Parent, Runtime};
    use super::*;
    use gpui_reactivity_core::CoordinateSpace;

    #[test]
    fn branches_cross_inline_storage_then_reuse_deep_sibling_entries() {
        let mut frontier = Frontier::new(0usize, MAX_LAYOUT_DEPTH);
        for depth in 0..MAX_LAYOUT_DEPTH {
            assert_eq!(frontier.top(), depth);
            frontier.push(depth + 1);
        }
        for _ in 3..MAX_LAYOUT_DEPTH {
            frontier.pop();
        }
        assert_eq!(frontier.top(), 3);
        frontier.push(42);
        assert_eq!(frontier.top(), 42);
        frontier.pop();
        assert_eq!(frontier.top(), 3);
        for _ in 0..3 {
            frontier.pop();
        }
        assert_eq!(frontier.top(), 0);
    }

    #[test]
    fn shallow_branches_and_wide_leaves_allocate_no_frontier_storage() {
        let cost = allocation_counter::measure(|| {
            let mut frontier = Frontier::new(0usize, MAX_LAYOUT_DEPTH);
            for depth in 0..INLINE {
                frontier.push(depth);
            }
            for _ in 0..10000 {
                assert_eq!(frontier.top(), INLINE - 1);
            }
        });
        assert_eq!(cost.count_total, 0);
        println!(
            "FRONTIER_LAYOUT coordinate={} clip={} coordinate_frontier={} clip_frontier={} scroll_frontier={} runtime={}",
            size_of::<CoordinateSpace>(),
            size_of::<ClipFrame>(),
            size_of::<Frontier<CoordinateSpace>>(),
            size_of::<Frontier<ClipFrame>>(),
            size_of::<Frontier<(CoordinateSpace, Parent)>>(),
            size_of::<Runtime<()>>()
        );
    }
}
