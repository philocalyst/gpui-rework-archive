//! Exact logical emission membership and rank in monotonically appended P.
const BLOCK_BITS: usize = u64::BITS as usize;

struct Block {
    bits: u64,
    base: u32,
}
pub(super) struct Published {
    blocks: Vec<Block>,
}
impl Published {
    pub(super) fn new(nodes: usize) -> Self {
        Self {
            blocks: Vec::with_capacity(nodes.div_ceil(BLOCK_BITS)),
        }
    }
    // Every logical node is visited once, including omitted virtual rows.
    pub(super) fn record(&mut self, logical: usize, presented: usize, emitted: bool) {
        if logical.is_multiple_of(BLOCK_BITS) {
            self.blocks.push(Block {
                bits: 0,
                base: presented as u32,
            });
        }
        if emitted {
            self.blocks[logical / BLOCK_BITS].bits |= 1 << (logical % BLOCK_BITS);
        }
    }
    pub(super) fn get(&self, logical: usize) -> Option<usize> {
        let block = self.blocks.get(logical / BLOCK_BITS)?;
        let bit = 1 << (logical % BLOCK_BITS);
        (block.bits & bit != 0)
            .then(|| block.base as usize + (block.bits & (bit - 1)).count_ones() as usize)
    }
}

#[cfg(test)]
mod tests {
    use super::super::Parent;
    use super::*;

    #[test]
    fn emission_rank_matches_dense_mapping_and_final_identity_checks() {
        let patterns: [fn(usize) -> bool; 6] = [
            |_| true,
            |_| false,
            |index| index % 64 == 0,
            |index| index % 64 == 63,
            |index| !(64..128).contains(&index),
            |index| index % 11 < 3,
        ];
        for nodes in [0, 1, 3, 4, 63, 64, 65, 127, 128, 129, 10000] {
            for emitted in patterns {
                let mut rank = Published::new(nodes);
                let mut dense = Vec::new();
                let mut identities = Vec::new();
                let mut ancestor = Parent::NONE;
                for logical in 0..nodes {
                    let present = emitted(logical);
                    rank.record(logical, identities.len(), present);
                    if present {
                        ancestor = Parent::new(Some(identities.len()));
                        identities.push(logical);
                    }
                    dense.push(ancestor);
                }
                for (logical, entry) in dense.iter().enumerate() {
                    let expected = entry.index().filter(|&index| identities[index] == logical);
                    assert_eq!(
                        rank.get(logical),
                        expected,
                        "logical {logical}, nodes {nodes}"
                    );
                    if !emitted(logical) {
                        assert!(rank.get(logical).is_none());
                    }
                }
                assert!(rank.get(nodes).is_none());
            }
        }
        assert_eq!(size_of::<Block>(), 16);
        println!(
            "PUBLISHED_LAYOUT block={} bits={BLOCK_BITS}",
            size_of::<Block>()
        );
    }
}
