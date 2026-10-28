use crate::Error;

const SAMPLE: usize = 32;

#[derive(Clone, Copy)]
struct WordIndex {
    opens_before: u32,
    net: i16,
    min: i16,
}

/// Immutable ordinal tree. One opening/closing bit per node, sampled select,
/// and per-word rank/min-excess summaries. This small index skips whole words;
/// it does not claim the asymptotic constant-time bounds of full succinct trees.
pub struct Topology {
    nodes: u32,
    bits: Box<[u64]>,
    index: Box<[WordIndex]>,
    samples: Box<[u32]>,
}
impl Topology {
    /// Parents must describe one rooted tree in preorder: root is None, and each
    /// later parent must still be on the preceding node's ancestor chain.
    pub fn new(parents: &[Option<u32>]) -> Result<Self, Error> {
        if parents.is_empty() || parents[0].is_some() || parents.len() > u32::MAX as usize / 2 {
            return Err(Error::Topology);
        }
        let mut bits = vec![0u64; (parents.len() * 2).div_ceil(64)];
        let mut stack = Vec::new();
        let mut samples = Vec::new();
        let mut position = 0usize;
        for (ordinal, &parent) in parents.iter().enumerate() {
            if ordinal != 0 {
                let parent = parent.ok_or(Error::Topology)?;
                while stack.last().copied() != Some(parent) {
                    stack.pop().ok_or(Error::Topology)?;
                    position += 1;
                }
            }
            if ordinal % SAMPLE == 0 {
                samples.push(position as u32);
            }
            bits[position / 64] |= 1u64 << (position % 64);
            position += 1;
            stack.push(ordinal as u32);
        }
        position += stack.len();
        debug_assert_eq!(position, parents.len() * 2);
        let mut index = Vec::with_capacity(bits.len());
        let mut opens_before = 0;
        for (word, &bits) in bits.iter().enumerate() {
            let mut net = 0i16;
            let mut min = 0;
            for bit in 0..64.min(position - word * 64) {
                net += if bits & (1 << bit) != 0 { 1 } else { -1 };
                min = min.min(net);
            }
            index.push(WordIndex {
                opens_before,
                net,
                min,
            });
            opens_before += bits.count_ones();
        }
        Ok(Self {
            nodes: parents.len() as u32,
            bits: bits.into_boxed_slice(),
            index: index.into_boxed_slice(),
            samples: samples.into_boxed_slice(),
        })
    }
    pub fn len(&self) -> usize {
        self.nodes as usize
    }
    pub fn is_empty(&self) -> bool {
        false
    }
    pub fn parent(&self, node: u32) -> Result<Option<u32>, Error> {
        let mut position = self.open(node)?;
        let mut balance = 0i32;
        while position != 0 {
            if position % 64 == 0 {
                let word = position / 64 - 1;
                let index = self.index[word];
                let reverse_min = i32::from(index.min - index.net);
                if balance + reverse_min >= 0 {
                    balance -= i32::from(index.net);
                    position -= 64;
                    continue;
                }
            }
            position -= 1;
            balance += if self.bit(position) { -1 } else { 1 };
            if balance == -1 {
                return Ok(Some(self.ordinal(position)));
            }
        }
        Ok(None)
    }
    pub fn first_child(&self, node: u32) -> Result<Option<u32>, Error> {
        let next = self.open(node)? + 1;
        Ok(self.bit(next).then(|| self.ordinal(next)))
    }
    pub fn next_sibling(&self, node: u32) -> Result<Option<u32>, Error> {
        let next = self.close(self.open(node)?) + 1;
        Ok((next < self.nodes as usize * 2 && self.bit(next)).then(|| self.ordinal(next)))
    }
    pub fn subtree_len(&self, node: u32) -> Result<usize, Error> {
        Ok((self.ordinal(self.close(self.open(node)?)) - node) as usize)
    }
    pub fn children(&self, node: u32) -> Result<Children<'_>, Error> {
        Ok(Children {
            topology: self,
            next: self.first_child(node)?,
        })
    }
    pub fn bit_bytes(&self) -> usize {
        self.bits.len() * 8
    }
    pub fn index_bytes(&self) -> usize {
        self.index.len() * std::mem::size_of::<WordIndex>() + self.samples.len() * 4
    }
    pub fn payload_bytes(&self) -> usize {
        std::mem::size_of::<Self>() + self.bit_bytes() + self.index_bytes()
    }
    fn open(&self, node: u32) -> Result<usize, Error> {
        if node >= self.nodes {
            return Err(Error::Node);
        }
        let sample = node as usize / SAMPLE;
        let mut position = self.samples[sample] as usize;
        let mut remaining = node as usize % SAMPLE;
        while remaining != 0 {
            position += 1;
            if self.bit(position) {
                remaining -= 1;
            }
        }
        Ok(position)
    }
    fn bit(&self, position: usize) -> bool {
        self.bits[position / 64] & (1u64 << (position % 64)) != 0
    }
    fn ordinal(&self, position: usize) -> u32 {
        let word = position / 64;
        let bit = position % 64;
        self.index[word].opens_before + (self.bits[word] & ((1u64 << bit) - 1)).count_ones()
    }
    fn close(&self, open: usize) -> usize {
        let mut position = open + 1;
        let mut balance = 1i32;
        loop {
            if position.is_multiple_of(64) && position + 64 <= self.nodes as usize * 2 {
                let index = self.index[position / 64];
                if balance + i32::from(index.min) > 0 {
                    balance += i32::from(index.net);
                    position += 64;
                    continue;
                }
            }
            balance += if self.bit(position) { 1 } else { -1 };
            if balance == 0 {
                return position;
            }
            position += 1;
        }
    }
}

pub struct Children<'a> {
    topology: &'a Topology,
    next: Option<u32>,
}
impl Iterator for Children<'_> {
    type Item = u32;
    fn next(&mut self) -> Option<u32> {
        let node = self.next?;
        self.next = self
            .topology
            .next_sibling(node)
            .expect("iterator ordinals are valid");
        Some(node)
    }
}
