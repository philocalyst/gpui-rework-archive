//! Experiment (ROUND 2, centerpiece): THE REAL TREE — editable flat-tree representations.
//!
//! Round 1 (`store.rs`) proved the flattened DFS (paint-order) SoA is 26–44x faster to traverse
//! than pointer-chase DFS, but priced structural edits at O(N) memmove and leaned on "describe
//! rebuilds paint order every turn". Round 2 attacks that price directly: can we keep the linear
//! scan AND make structural edits sublinear, so the retained store can absorb edits *without* a
//! full rebuild? Candidates (all keep nodes in DFS/paint order; hot record = 8 B
//! {subtree:u32, kind:u16, flags:u16}; `subtree` gives contiguous-range subtrees):
//!
//!   (R) REBUILD    — authoritative first_child/next_sibling pointer tree; O(1) edits; every frame
//!                    re-flattens by DFS into reused buffers. (The round-1 status quo.)
//!   (D) DENSE-MOVE — one dense Vec; insert/remove = Vec::insert/remove memmove + O(depth) ancestor
//!                    subtree fixups.
//!   (G) GAP        — Compose-SlotTable-style gap buffer over the same arrays; edit cost = distance
//!                    to gap; traversal = two linear runs.
//!   (K) CHUNKED    — rope-of-pages: 256-node chunks + Fenwick over chunk counts; edit = O(256)
//!                    shift + O(log chunks) locate; traversal = per-chunk linear runs.
//!   (P) PMA        — packed-memory array (Itai/Katriel; Bender et al. cache-oblivious B-tree
//!                    line): one array at ~50–70% density, gaps everywhere, O(log^2 N) amortized
//!                    moves per edit; traversal = occupancy-masked linear scan (ctz loop).
//!   (S) SUCCINCT   — balanced-parentheses topology (2 bits/node + ~0.25 bit rank aux), payload in
//!                    DFS order; measures the nav cost you pay for 8B -> 2.25bit topology.
//!
//! Edits are replayed from ONE logical edit script (generated against the dense reference), so
//! every candidate performs the *same* logical mutations: insert-leaf-as-last-child(P) and
//! remove-random-leaf, in UNIFORM (fresh random descent per edit) and CLUSTERED (one parent per
//! 32-edit burst — the realistic "a list changed this frame" shape) flavors.

use dslab::*;

const NIL: u32 = u32::MAX;

#[derive(Clone, Copy, Default)]
struct FlatNode {
    subtree: u32,
    kind: u16,
    flags: u16,
}

// ---------------------------------------------------------------- tree generator (as store.rs)
struct TreeSpec {
    parent: Vec<u32>,
    children: Vec<Vec<u32>>,
    order: Vec<u32>,
}
fn build_tree(n: usize, seed: u64) -> TreeSpec {
    let mut rng = Rng::new(seed);
    let mut parent = vec![NIL; n];
    let mut children: Vec<Vec<u32>> = vec![Vec::new(); n];
    for i in 1..n {
        let window = (i as u32).min(64);
        let p = i as u32 - 1 - rng.below(window);
        parent[i] = p;
        children[p as usize].push(i as u32);
    }
    let mut order = Vec::with_capacity(n);
    let mut stack = vec![0u32];
    while let Some(x) = stack.pop() {
        order.push(x);
        for &c in children[x as usize].iter().rev() {
            stack.push(c);
        }
    }
    TreeSpec { parent, children, order }
}

fn flatten(t: &TreeSpec) -> Vec<FlatNode> {
    let n = t.parent.len();
    let mut pos_of = vec![0u32; n];
    for (p, &id) in t.order.iter().enumerate() {
        pos_of[id as usize] = p as u32;
    }
    let mut out = vec![FlatNode::default(); n];
    fn calc(id: u32, ch: &[Vec<u32>], pos_of: &[u32], out: &mut [FlatNode]) -> u32 {
        let mut sz = 1u32;
        for &c in &ch[id as usize] {
            sz += calc(c, ch, pos_of, out);
        }
        let p = pos_of[id as usize] as usize;
        out[p].subtree = sz;
        out[p].kind = (id % 7) as u16;
        out[p].flags = (id % 3) as u16;
        sz
    }
    calc(0, &t.children, &pos_of, &mut out);
    out
}

// ---------------------------------------------------------------- logical edit script
// Generated against an evolving dense reference so positions are exact at apply time.
enum Edit {
    /// Insert a fresh leaf at logical position `at`; bump `subtree` at each ancestor position.
    Insert { at: u32, path: Vec<u32> },
    /// Remove the leaf at logical position `at`; decrement `subtree` at each ancestor position.
    Remove { at: u32, path: Vec<u32> },
}

struct Dense {
    nodes: Vec<FlatNode>,
}
impl Dense {
    fn children_of(&self, p: usize) -> Vec<usize> {
        let end = p + self.nodes[p].subtree as usize;
        let mut q = p + 1;
        let mut out = Vec::new();
        while q < end {
            out.push(q);
            q += self.nodes[q].subtree as usize;
        }
        out
    }
    /// Random descent from root; returns path root..=chosen (logical positions).
    fn descend(&self, rng: &mut Rng, stop_at_leaf: bool) -> Vec<u32> {
        let mut path = vec![0u32];
        let mut cur = 0usize;
        loop {
            let ch = self.children_of(cur);
            if ch.is_empty() {
                break;
            }
            if !stop_at_leaf && rng.below(4) == 0 {
                break; // stop at an interior node 25% of the time
            }
            cur = ch[rng.below(ch.len() as u32) as usize];
            path.push(cur as u32);
        }
        path
    }
    fn apply(&mut self, e: &Edit) {
        match e {
            Edit::Insert { at, path } => {
                for &a in path {
                    self.nodes[a as usize].subtree += 1;
                }
                self.nodes.insert(
                    *at as usize,
                    FlatNode { subtree: 1, kind: 9, flags: 1 },
                );
            }
            Edit::Remove { at, path } => {
                for &a in path {
                    self.nodes[a as usize].subtree -= 1;
                }
                self.nodes.remove(*at as usize);
            }
        }
    }
}

/// Generate `count` edits (≈50/50 insert/remove) against `dense`, mutating it.
/// `cluster`: if Some(k), a new parent is chosen every k edits and inserts all target it
/// (removals remove its just-inserted leaves) — the "one list changed this frame" shape.
fn gen_script(dense: &mut Dense, rng: &mut Rng, count: usize, cluster: Option<usize>) -> Vec<Edit> {
    let mut edits = Vec::with_capacity(count);
    let mut anchor: Vec<u32> = Vec::new(); // path to the cluster parent
    for i in 0..count {
        if let Some(k) = cluster {
            if i % k == 0 || anchor.is_empty() {
                anchor = dense.descend(rng, false);
            }
        }
        let insert = rng.below(2) == 0;
        if insert {
            let path = if cluster.is_some() { anchor.clone() } else { dense.descend(rng, false) };
            let p = *path.last().unwrap() as usize;
            let at = (p + dense.nodes[p].subtree as usize) as u32; // last child of p
            let e = Edit::Insert { at, path };
            dense.apply(&e);
            // positions after `at` shifted; the anchor path is all ≤ p, unaffected. ✓
            edits.push(e);
        } else {
            // remove a random leaf (never the root)
            let mut path = if cluster.is_some() && anchor.len() > 0 {
                // descend from the cluster parent to a leaf below it
                let mut path = anchor.clone();
                let mut cur = *path.last().unwrap() as usize;
                loop {
                    let ch = dense.children_of(cur);
                    if ch.is_empty() {
                        break;
                    }
                    cur = ch[rng.below(ch.len() as u32) as usize];
                    path.push(cur as u32);
                }
                path
            } else {
                dense.descend(rng, true)
            };
            if path.len() < 2 {
                continue; // root is the only node on the path; skip
            }
            let at = path.pop().unwrap();
            // if the cluster anchor itself is being removed, invalidate the anchor
            if anchor.last() == Some(&at) {
                anchor.clear();
            }
            let e = Edit::Remove { at, path };
            dense.apply(&e);
            edits.push(e);
        }
    }
    edits
}

// ---------------------------------------------------------------- (G) gap buffer
struct GapTree {
    buf: Vec<FlatNode>, // physical; [gap_start, gap_end) is the gap
    gap_start: usize,
    gap_end: usize,
}
impl GapTree {
    fn new(nodes: &[FlatNode], gap: usize) -> Self {
        let mut buf = Vec::with_capacity(nodes.len() + gap);
        buf.extend_from_slice(nodes);
        buf.resize(nodes.len() + gap, FlatNode::default());
        // gap sits at the end initially
        GapTree { gap_start: nodes.len(), gap_end: nodes.len() + gap, buf }
    }
    #[inline]
    fn phys(&self, i: usize) -> usize {
        if i < self.gap_start { i } else { i + (self.gap_end - self.gap_start) }
    }
    fn move_gap(&mut self, to: usize) {
        let glen = self.gap_end - self.gap_start;
        if to < self.gap_start {
            // shift [to, gap_start) right by glen
            self.buf.copy_within(to..self.gap_start, to + glen);
            self.gap_start = to;
            self.gap_end = to + glen;
        } else if to > self.gap_start {
            // shift [gap_end, gap_end + (to - gap_start)) left by glen
            let n = to - self.gap_start;
            self.buf.copy_within(self.gap_end..self.gap_end + n, self.gap_start);
            self.gap_start = to;
            self.gap_end = to + glen;
        }
    }
    fn apply(&mut self, e: &Edit) {
        match e {
            Edit::Insert { at, path } => {
                for &a in path {
                    let p = self.phys(a as usize);
                    self.buf[p].subtree += 1;
                }
                if self.gap_start == self.gap_end {
                    // regrow: realloc with a fresh gap at the insertion point (counted, rare)
                    let extra = self.buf.len() / 2 + 1024;
                    let old = std::mem::take(&mut self.buf);
                    self.buf = Vec::with_capacity(old.len() + extra);
                    self.buf.extend_from_slice(&old);
                    self.buf.resize(old.len() + extra, FlatNode::default());
                    self.gap_start = old.len();
                    self.gap_end = old.len() + extra;
                }
                self.move_gap(*at as usize);
                self.buf[self.gap_start] = FlatNode { subtree: 1, kind: 9, flags: 1 };
                self.gap_start += 1;
            }
            Edit::Remove { at, path } => {
                for &a in path {
                    let p = self.phys(a as usize);
                    self.buf[p].subtree -= 1;
                }
                self.move_gap(*at as usize);
                self.gap_end += 1; // swallow the element just after the gap
            }
        }
    }
    fn traverse(&self) -> u64 {
        let mut acc = 0u64;
        for n in &self.buf[..self.gap_start] {
            acc = acc.wrapping_add(n.flags as u64 ^ n.kind as u64);
        }
        for n in &self.buf[self.gap_end..] {
            acc = acc.wrapping_add(n.flags as u64 ^ n.kind as u64);
        }
        acc
    }
}

// ---------------------------------------------------------------- (K) chunked pages + Fenwick
const CHUNK: usize = 256;
struct Chunked {
    chunks: Vec<Box<[FlatNode; CHUNK]>>,
    counts: Vec<u32>,
    fen: Vec<u32>, // Fenwick over counts, 1-based, rebuilt on chunk add/remove
    total: usize,
}
impl Chunked {
    fn new(nodes: &[FlatNode]) -> Self {
        let fill = CHUNK / 2 + CHUNK / 4; // 75% fill so early edits don't all split
        let mut chunks = Vec::new();
        let mut counts = Vec::new();
        let mut i = 0;
        while i < nodes.len() {
            let take = fill.min(nodes.len() - i);
            let mut c: Box<[FlatNode; CHUNK]> = Box::new([FlatNode::default(); CHUNK]);
            c[..take].copy_from_slice(&nodes[i..i + take]);
            chunks.push(c);
            counts.push(take as u32);
            i += take;
        }
        let mut s = Chunked { chunks, counts, fen: Vec::new(), total: nodes.len() };
        s.rebuild_fen();
        s
    }
    fn rebuild_fen(&mut self) {
        let n = self.counts.len();
        self.fen = vec![0u32; n + 1];
        for i in 0..n {
            let j = i + 1;
            // standard O(n) fenwick build
            self.fen[j] += self.counts[i];
            let k = j + (j & j.wrapping_neg());
            if k <= n {
                let v = self.fen[j];
                self.fen[k] += v;
            }
        }
    }
    #[inline]
    fn fen_add(&mut self, i: usize, delta: i64) {
        let mut j = i + 1;
        while j < self.fen.len() {
            self.fen[j] = (self.fen[j] as i64 + delta) as u32;
            j += j & j.wrapping_neg();
        }
    }
    /// Find (chunk, offset) for logical position `pos` (0 ≤ pos ≤ total).
    #[inline]
    fn locate(&self, mut pos: u32) -> (usize, usize) {
        // Fenwick binary descent
        let n = self.counts.len();
        let mut idx = 0usize;
        let mut mask = n.next_power_of_two();
        while mask > 0 {
            let next = idx + mask;
            if next < self.fen.len() && self.fen[next] <= pos {
                idx = next;
                pos -= self.fen[next];
            }
            mask >>= 1;
        }
        // idx = number of full chunks before the target
        if idx == self.counts.len() {
            // append past the very end -> last chunk
            let last = self.counts.len() - 1;
            return (last, self.counts[last] as usize);
        }
        (idx, pos as usize)
    }
    fn apply(&mut self, e: &Edit) {
        match e {
            Edit::Insert { at, path } => {
                for &a in path {
                    let (c, o) = self.locate(a);
                    self.chunks[c][o].subtree += 1;
                }
                let (c, o) = self.locate(*at);
                let cnt = self.counts[c] as usize;
                if cnt == CHUNK {
                    // split: move upper half into a new chunk
                    let mut newc: Box<[FlatNode; CHUNK]> = Box::new([FlatNode::default(); CHUNK]);
                    let half = CHUNK / 2;
                    newc[..CHUNK - half].copy_from_slice(&self.chunks[c][half..]);
                    self.chunks.insert(c + 1, newc);
                    self.counts[c] = half as u32;
                    self.counts.insert(c + 1, (CHUNK - half) as u32);
                    self.rebuild_fen();
                    // recompute target after split
                    let (c2, o2) = if o < half { (c, o) } else { (c + 1, o - half) };
                    return self.insert_in_chunk(c2, o2);
                }
                self.insert_in_chunk(c, o);
            }
            Edit::Remove { at, path } => {
                for &a in path {
                    let (c, o) = self.locate(a);
                    self.chunks[c][o].subtree -= 1;
                }
                let (c, o) = self.locate(*at);
                let cnt = self.counts[c] as usize;
                self.chunks[c].copy_within(o + 1..cnt, o);
                self.counts[c] -= 1;
                self.fen_add(c, -1);
                self.total -= 1;
                if self.counts[c] == 0 {
                    self.chunks.remove(c);
                    self.counts.remove(c);
                    self.rebuild_fen();
                }
            }
        }
    }
    fn insert_in_chunk(&mut self, c: usize, o: usize) {
        let cnt = self.counts[c] as usize;
        self.chunks[c].copy_within(o..cnt, o + 1);
        self.chunks[c][o] = FlatNode { subtree: 1, kind: 9, flags: 1 };
        self.counts[c] += 1;
        self.fen_add(c, 1);
        self.total += 1;
    }
    fn traverse(&self) -> u64 {
        let mut acc = 0u64;
        for (c, cnt) in self.chunks.iter().zip(&self.counts) {
            for n in &c[..*cnt as usize] {
                acc = acc.wrapping_add(n.flags as u64 ^ n.kind as u64);
            }
        }
        acc
    }
    fn bytes(&self) -> usize {
        self.chunks.len() * CHUNK * 8 + self.counts.len() * 4 + self.fen.len() * 4
    }
}

// ---------------------------------------------------------------- (P) packed-memory array
struct Pma {
    data: Vec<FlatNode>,
    occ: Vec<u64>,      // one bit per slot
    fen: Vec<u32>,      // Fenwick over per-word popcounts
    n: usize,
    cap: usize,
    rebalances: usize,
    grows: usize,
}
const T_LEAF: f64 = 0.92;
const T_ROOT: f64 = 0.70;
impl Pma {
    fn new(nodes: &[FlatNode]) -> Self {
        let cap = (nodes.len() * 2).next_power_of_two().max(128);
        let mut s = Pma {
            data: vec![FlatNode::default(); cap],
            occ: vec![0u64; cap / 64],
            fen: Vec::new(),
            n: 0,
            cap,
            rebalances: 0,
            grows: 0,
        };
        s.fill_even(nodes);
        s
    }
    fn fill_even(&mut self, nodes: &[FlatNode]) {
        self.occ.iter_mut().for_each(|w| *w = 0);
        let m = nodes.len();
        for (i, nd) in nodes.iter().enumerate() {
            let pos = i * self.cap / m;
            self.data[pos] = *nd;
            self.occ[pos / 64] |= 1u64 << (pos % 64);
        }
        self.n = m;
        self.rebuild_fen();
    }
    fn rebuild_fen(&mut self) {
        let n = self.occ.len();
        self.fen = vec![0u32; n + 1];
        for i in 0..n {
            let j = i + 1;
            self.fen[j] += self.occ[i].count_ones();
            let k = j + (j & j.wrapping_neg());
            if k <= n {
                let v = self.fen[j];
                self.fen[k] += v;
            }
        }
    }
    #[inline]
    fn fen_add(&mut self, word: usize, delta: i64) {
        let mut j = word + 1;
        while j < self.fen.len() {
            self.fen[j] = (self.fen[j] as i64 + delta) as u32;
            j += j & j.wrapping_neg();
        }
    }
    /// Physical slot of rank r (r < n).
    #[inline]
    fn select(&self, mut r: u32) -> usize {
        let n = self.occ.len();
        let mut idx = 0usize;
        let mut mask = n.next_power_of_two();
        while mask > 0 {
            let next = idx + mask;
            if next < self.fen.len() && self.fen[next] <= r {
                idx = next;
                r -= self.fen[next];
            }
            mask >>= 1;
        }
        // idx = word index; find (r+1)-th set bit in that word
        let mut bits = self.occ[idx];
        for _ in 0..r {
            bits &= bits - 1;
        }
        idx * 64 + bits.trailing_zeros() as usize
    }
    /// Insert `nd` before rank `r` (r ≤ n).
    fn insert(&mut self, r: u32, nd: FlatNode) {
        loop {
            let word = if self.n == 0 {
                0
            } else if (r as usize) < self.n {
                self.select(r) / 64
            } else {
                self.select(self.n as u32 - 1) / 64
            };
            if (self.occ[word].count_ones() as usize) < 64 {
                // gather word, splice in the new element at its in-word rank, write back compact
                let base_rank = self.prefix_rank(word);
                let in_word = (r - base_rank).min(self.occ[word].count_ones()) as usize;
                let mut tmp = [FlatNode::default(); 65];
                let mut cnt = 0usize;
                let mut bits = self.occ[word];
                while bits != 0 {
                    let b = bits.trailing_zeros() as usize;
                    tmp[cnt] = self.data[word * 64 + b];
                    cnt += 1;
                    bits &= bits - 1;
                }
                tmp.copy_within(in_word..cnt, in_word + 1);
                tmp[in_word] = nd;
                cnt += 1;
                // write back with even spacing inside the word
                let old_pop = self.occ[word].count_ones() as i64;
                self.occ[word] = 0;
                for i in 0..cnt {
                    let pos = i * 64 / cnt;
                    self.data[word * 64 + pos] = tmp[i];
                    self.occ[word] |= 1u64 << pos;
                }
                self.fen_add(word, cnt as i64 - old_pop);
                self.n += 1;
                // density check upward
                self.enforce_density(word);
                return;
            }
            // word full: rebalance the smallest legal window, then retry
            self.rebalance_around(word);
        }
    }
    #[inline]
    fn prefix_rank(&self, word: usize) -> u32 {
        let mut j = word;
        let mut s = 0u32;
        while j > 0 {
            s += self.fen[j];
            j -= j & j.wrapping_neg();
        }
        s
    }
    fn height(&self) -> u32 {
        (self.occ.len() as f64).log2().ceil() as u32
    }
    fn tau(&self, level: u32) -> f64 {
        let h = self.height().max(1);
        T_LEAF - (T_LEAF - T_ROOT) * (level as f64) / (h as f64)
    }
    fn enforce_density(&mut self, word: usize) {
        // check leaf upward; rebalance the first violated window
        let mut level = 0u32;
        loop {
            let wwords = 1usize << level;
            if wwords > self.occ.len() {
                break;
            }
            let start = word & !(wwords - 1);
            let cnt = self.count_words(start, wwords);
            let slots = wwords * 64;
            if (cnt as f64) <= self.tau(level) * slots as f64 {
                return; // this window is fine; done
            }
            if wwords == self.occ.len() {
                self.grow();
                return;
            }
            level += 1;
            // keep walking up until we find a window we can redistribute INTO (satisfying tau)
            let wwords2 = 1usize << level;
            if wwords2 <= self.occ.len() {
                let start2 = word & !(wwords2 - 1);
                let cnt2 = self.count_words(start2, wwords2);
                if (cnt2 as f64) <= self.tau(level) * (wwords2 * 64) as f64 {
                    self.redistribute(start2, wwords2);
                    return;
                }
            } else {
                self.grow();
                return;
            }
        }
    }
    fn rebalance_around(&mut self, word: usize) {
        let mut level = 1u32;
        loop {
            let wwords = 1usize << level;
            if wwords > self.occ.len() {
                self.grow();
                return;
            }
            let start = word & !(wwords - 1);
            let cnt = self.count_words(start, wwords);
            if (cnt as f64) <= self.tau(level) * (wwords * 64) as f64 {
                self.redistribute(start, wwords);
                return;
            }
            level += 1;
        }
    }
    fn count_words(&self, start: usize, len: usize) -> u32 {
        self.prefix_rank((start + len).min(self.occ.len())) - self.prefix_rank(start)
    }
    fn redistribute(&mut self, start: usize, wwords: usize) {
        self.rebalances += 1;
        let mut tmp: Vec<FlatNode> = Vec::with_capacity(wwords * 64);
        for w in start..start + wwords {
            let mut bits = self.occ[w];
            while bits != 0 {
                let b = bits.trailing_zeros() as usize;
                tmp.push(self.data[w * 64 + b]);
                bits &= bits - 1;
            }
            self.occ[w] = 0;
        }
        let slots = wwords * 64;
        let m = tmp.len();
        for (i, nd) in tmp.iter().enumerate() {
            let pos = start * 64 + i * slots / m;
            self.data[pos] = *nd;
            self.occ[pos / 64] |= 1u64 << (pos % 64);
        }
        self.rebuild_fen(); // amortized fine; rebalances are rare
    }
    fn grow(&mut self) {
        self.grows += 1;
        let mut tmp: Vec<FlatNode> = Vec::with_capacity(self.n);
        for w in 0..self.occ.len() {
            let mut bits = self.occ[w];
            while bits != 0 {
                let b = bits.trailing_zeros() as usize;
                tmp.push(self.data[w * 64 + b]);
                bits &= bits - 1;
            }
        }
        self.cap *= 2;
        self.data = vec![FlatNode::default(); self.cap];
        self.occ = vec![0u64; self.cap / 64];
        self.fill_even(&tmp);
    }
    fn remove(&mut self, r: u32) {
        let s = self.select(r);
        self.occ[s / 64] &= !(1u64 << (s % 64));
        self.fen_add(s / 64, -1);
        self.n -= 1;
        // (deliberately no shrink/min-density maintenance; noted in the doc)
    }
    /// subtree fixup by rank
    fn bump(&mut self, r: u32, delta: i32) {
        let s = self.select(r);
        self.data[s].subtree = (self.data[s].subtree as i64 + delta as i64) as u32;
    }
    fn apply(&mut self, e: &Edit) {
        match e {
            Edit::Insert { at, path } => {
                for &a in path {
                    self.bump(a, 1);
                }
                self.insert(*at, FlatNode { subtree: 1, kind: 9, flags: 1 });
            }
            Edit::Remove { at, path } => {
                for &a in path {
                    self.bump(a, -1);
                }
                self.remove(*at);
            }
        }
    }
    fn traverse(&self) -> u64 {
        let mut acc = 0u64;
        for (w, &bits0) in self.occ.iter().enumerate() {
            let mut bits = bits0;
            while bits != 0 {
                let b = bits.trailing_zeros() as usize;
                let n = self.data[w * 64 + b];
                acc = acc.wrapping_add(n.flags as u64 ^ n.kind as u64);
                bits &= bits - 1;
            }
        }
        acc
    }
    fn bytes(&self) -> usize {
        self.cap * 8 + self.occ.len() * 8 + self.fen.len() * 4
    }
}

// ---------------------------------------------------------------- (S) succinct BP topology
struct Bp {
    bits: Vec<u64>,   // 2n bits: '(' = 1 at preorder visit, ')' = 0
    // per-word aux for findclose block skipping:
    excess_delta: Vec<i16>, // 2*popcount(word) - 64
    min_excess: Vec<i16>,   // minimum running excess within the word (relative to word start)
    nbits: usize,
}
impl Bp {
    fn from_flat(nodes: &[FlatNode]) -> Self {
        let n = nodes.len();
        let nbits = 2 * n;
        let mut bits = vec![0u64; (nbits + 63) / 64];
        // emit via subtree ranges: '(' at open, ')' after subtree — iterative with explicit stack
        let mut bitpos = 0usize;
        let mut i = 0usize;
        let mut ends: Vec<usize> = Vec::new();
        while i < n || !ends.is_empty() {
            while let Some(&e) = ends.last() {
                if e == i {
                    ends.pop();
                    bitpos += 1; // ')' is a 0 bit; nothing to set
                } else {
                    break;
                }
            }
            if i < n {
                bits[bitpos / 64] |= 1u64 << (bitpos % 64);
                bitpos += 1;
                ends.push(i + nodes[i].subtree as usize);
                i += 1;
            }
        }
        debug_assert_eq!(bitpos, nbits);
        let words = bits.len();
        let mut excess_delta = vec![0i16; words];
        let mut min_excess = vec![0i16; words];
        for w in 0..words {
            let word = bits[w];
            let mut e: i16 = 0;
            let mut me: i16 = i16::MAX;
            let valid = if (w + 1) * 64 <= nbits { 64 } else { nbits - w * 64 };
            for b in 0..valid {
                e += if (word >> b) & 1 == 1 { 1 } else { -1 };
                me = me.min(e);
            }
            excess_delta[w] = e;
            min_excess[w] = if me == i16::MAX { 0 } else { me };
        }
        Bp { bits, excess_delta, min_excess, nbits }
    }
    /// find the matching ')' for the '(' at bit position i; returns bit position of the ')'.
    fn findclose(&self, i: usize) -> usize {
        // scan rest of the current word bit by bit
        let mut excess: i32 = 0;
        let w0 = i / 64;
        let start_b = i % 64;
        let end0 = if (w0 + 1) * 64 <= self.nbits { 64 } else { self.nbits - w0 * 64 };
        for b in start_b..end0 {
            excess += if (self.bits[w0] >> b) & 1 == 1 { 1 } else { -1 };
            if excess == 0 {
                return w0 * 64 + b;
            }
        }
        // block-skip whole words while the answer cannot be inside
        let mut w = w0 + 1;
        loop {
            let me = self.min_excess[w] as i32;
            if excess + me <= 0 {
                // answer is inside this word: bit scan
                let word = self.bits[w];
                let valid = if (w + 1) * 64 <= self.nbits { 64 } else { self.nbits - w * 64 };
                for b in 0..valid {
                    excess += if (word >> b) & 1 == 1 { 1 } else { -1 };
                    if excess == 0 {
                        return w * 64 + b;
                    }
                }
                unreachable!("min_excess promised a zero crossing");
            }
            excess += self.excess_delta[w] as i32;
            w += 1;
        }
    }
    fn bytes(&self) -> usize {
        self.bits.len() * 8 + self.excess_delta.len() * 2 + self.min_excess.len() * 2
    }
}

// ---------------------------------------------------------------- driver
trait Candidate {
    fn apply(&mut self, e: &Edit);
    fn traverse(&self) -> u64;
}
impl Candidate for Dense {
    fn apply(&mut self, e: &Edit) {
        Dense::apply(self, e)
    }
    fn traverse(&self) -> u64 {
        let mut acc = 0u64;
        for nd in &self.nodes {
            acc = acc.wrapping_add(nd.flags as u64 ^ nd.kind as u64);
        }
        acc
    }
}
impl Candidate for GapTree {
    fn apply(&mut self, e: &Edit) {
        GapTree::apply(self, e)
    }
    fn traverse(&self) -> u64 {
        GapTree::traverse(self)
    }
}
impl Candidate for Chunked {
    fn apply(&mut self, e: &Edit) {
        Chunked::apply(self, e)
    }
    fn traverse(&self) -> u64 {
        Chunked::traverse(self)
    }
}
impl Candidate for Pma {
    fn apply(&mut self, e: &Edit) {
        Pma::apply(self, e)
    }
    fn traverse(&self) -> u64 {
        Pma::traverse(self)
    }
}

fn frame_bench<C: Candidate>(
    label: &str,
    script: &[Edit],
    edits_per_frame: usize,
    cand: &mut C,
) -> (f64, f64) {
    // apply the whole script frame by frame, timing edits and traversal separately
    let frames = script.len() / edits_per_frame;
    let mut edit_ns = Vec::with_capacity(frames);
    let mut trav_ns = Vec::with_capacity(frames);
    let mut acc = 0u64;
    for f in 0..frames {
        let t0 = Instant::now();
        for e in &script[f * edits_per_frame..(f + 1) * edits_per_frame] {
            cand.apply(e);
        }
        edit_ns.push(t0.elapsed().as_nanos() as f64 / edits_per_frame as f64);
        let t1 = Instant::now();
        acc = acc.wrapping_add(cand.traverse());
        trav_ns.push(t1.elapsed().as_nanos() as f64);
    }
    bb(acc);
    edit_ns.sort_by(|a, b| a.partial_cmp(b).unwrap());
    trav_ns.sort_by(|a, b| a.partial_cmp(b).unwrap());
    let em = edit_ns[edit_ns.len() / 2];
    let tm = trav_ns[trav_ns.len() / 2];
    println!(
        "    {label:<44} edit {em:>9.0} ns/edit   traverse {tm:>9.0} ns/frame",
    );
    (em, tm)
}

use std::time::Instant;

fn run_at(n: usize, edits_total: usize, edits_per_frame: usize) {
    section(&format!(
        "TREE SHOOTOUT @ N={n} — {edits_per_frame} edits/frame, {edits_total} edits total"
    ));
    let spec = build_tree(n, 42);
    let flat0 = flatten(&spec);

    for (cname, cluster) in [("UNIFORM", None), ("CLUSTERED (32-edit bursts)", Some(32usize))] {
        println!("\n  -- {cname} edit script --");
        // generate the script against a fresh dense copy
        let mut generator = Dense { nodes: flat0.clone() };
        let mut rng = Rng::new(7 + cluster.unwrap_or(0) as u64);
        let script = gen_script(&mut generator, &mut rng, edits_total, cluster);

        // (D) dense memmove
        let mut d = Dense { nodes: flat0.clone() };
        frame_bench("(D) dense Vec  insert/remove memmove", &script, edits_per_frame, &mut d);

        // (G) gap buffer
        let mut g = GapTree::new(&flat0, 4096);
        frame_bench("(G) gap buffer (SlotTable-style)", &script, edits_per_frame, &mut g);

        // (K) chunked
        let mut k = Chunked::new(&flat0);
        frame_bench("(K) chunked 256-node pages + Fenwick", &script, edits_per_frame, &mut k);

        // (P) PMA
        let mut p = Pma::new(&flat0);
        frame_bench("(P) packed-memory array (~50-70% dense)", &script, edits_per_frame, &mut p);
        note(&format!(
            "PMA: {} rebalances, {} grows over {} edits; resting density {:.0}%",
            p.rebalances, p.grows, script.len(),
            100.0 * p.n as f64 / p.cap as f64
        ));

        // sanity: all candidates agree with the generator
        let dsum: u64 = d.nodes.iter().map(|n| n.flags as u64 ^ n.kind as u64).sum();
        let gsum = g.traverse();
        let ksum = k.traverse();
        let psum = p.traverse();
        let refsum: u64 = generator.nodes.iter().map(|n| n.flags as u64 ^ n.kind as u64).sum();
        assert_eq!(dsum, refsum, "dense diverged");
        assert_eq!(gsum, refsum, "gap diverged");
        assert_eq!(ksum, refsum, "chunked diverged");
        assert_eq!(psum, refsum, "pma diverged");
        assert_eq!(d.nodes.len(), generator.nodes.len());
        // structural sanity: subtree fields agree between dense and generator
        assert!(d.nodes.iter().zip(&generator.nodes).all(|(a, b)| a.subtree == b.subtree));
        note("sanity: all four candidates converged to identical logical trees ✓");

        // (R) rebuild baseline: cost of one full DFS re-flatten from a pointer tree (per frame)
        // (edits on the pointer tree are ~free pointer surgery; the frame cost is the rebuild)
        let spec2 = build_tree(n, 42);
        let mut out: Vec<FlatNode> = Vec::with_capacity(n);
        let mut stack: Vec<u32> = Vec::with_capacity(64);
        let (_, rmed, _) = bench(1, 200, 20, || {
            out.clear();
            stack.clear();
            stack.push(0);
            while let Some(x) = stack.pop() {
                out.push(FlatNode { subtree: 1, kind: (x % 7) as u16, flags: (x % 3) as u16 });
                for &c in spec2.children[x as usize].iter().rev() {
                    stack.push(c);
                }
            }
            bb(out.len());
        });
        println!(
            "    {:<44} edit {:>9} ns/edit   rebuild  {:>9.0} ns/frame  (O(N) every frame)",
            "(R) rebuild-from-pointer-tree baseline", "~0", rmed
        );
    }

    // memory
    let g = GapTree::new(&flat0, 4096);
    let k = Chunked::new(&flat0);
    let p = Pma::new(&flat0);
    println!("\n  bytes/node (hot topology record only, N={n}):");
    println!("    dense 8.0   gap {:.1}   chunked {:.1}   pma {:.1}",
        g.buf.len() as f64 * 8.0 / n as f64,
        k.bytes() as f64 / n as f64,
        p.bytes() as f64 / n as f64);
}

fn main() {
    run_at(10_000, 8192, 64);
    run_at(100_000, 8192, 64);
    run_at(1_000_000, 2048, 64);

    // ---------------- succinct BP: what does 2.25-bit topology cost to navigate? ----------------
    section("SUCCINCT balanced-parentheses topology vs explicit subtree_size (static)");
    for n in [10_000usize, 1_000_000] {
        let spec = build_tree(n, 42);
        let flat = flatten(&spec);
        let bp = Bp::from_flat(&flat);
        // random nodes to probe (their bit position = position of the i-th '(' = select1(i);
        // precompute open positions directly from the flat form)
        let mut open_pos = vec![0usize; n];
        {
            let mut bitpos = 0usize;
            let mut ends: Vec<usize> = Vec::new();
            let mut i = 0usize;
            while i < n || !ends.is_empty() {
                while let Some(&e) = ends.last() {
                    if e == i {
                        ends.pop();
                        bitpos += 1;
                    } else {
                        break;
                    }
                }
                if i < n {
                    open_pos[i] = bitpos;
                    bitpos += 1;
                    ends.push(i + flat[i].subtree as usize);
                    i += 1;
                }
            }
        }
        let mut rng = Rng::new(5);
        let probes: Vec<usize> = (0..1000).map(|_| rng.below(n as u32) as usize).collect();
        // verify findclose against subtree_size on the probes
        for &p in &probes {
            let close = bp.findclose(open_pos[p]);
            // number of '(' strictly inside (open, close) must be subtree-1;
            // equivalently close position corresponds to end of subtree:
            let expect_close = {
                // position of ')' for node p: open_pos of next node after subtree, minus… — instead
                // verify via excess identity: bits between open and close balance out (checked by
                // construction of findclose); cross-check subtree via count of opens in range:
                let mut opens = 0usize;
                for b in open_pos[p]..=close {
                    if (bp.bits[b / 64] >> (b % 64)) & 1 == 1 {
                        opens += 1;
                    }
                }
                opens
            };
            assert_eq!(expect_close, flat[p].subtree as usize, "findclose mismatch");
        }
        let (_, fmed, _) = bench(1, 300, 30, || {
            let mut acc = 0usize;
            for &p in &probes {
                acc = acc.wrapping_add(bp.findclose(open_pos[p]));
            }
            bb(acc);
        });
        let (_, smed, _) = bench(1, 300, 30, || {
            let mut acc = 0usize;
            for &p in &probes {
                acc = acc.wrapping_add(p + flat[p].subtree as usize);
            }
            bb(acc);
        });
        println!(
            "  N={n:>7}: findclose(BP) {:>7.1} ns/op   subtree_size lookup {:>5.2} ns/op   ({:.0}x) \
             topology bytes: BP {:.2} bits/node vs flat 64 bits/node",
            fmed / 1000.0,
            smed / 1000.0,
            fmed / smed,
            bp.bytes() as f64 * 8.0 / n as f64
        );
    }
    note("BP topology is ~21x smaller but navigation is far slower — a COLD/serialized form, not the");
    note("live tree. (Our findclose block-skips word-by-word, i.e. linear in subtree span; a production");
    note("BP adds a range-min tree for O(log) jumps — tens of ns — still 1-2 orders above one load.");
    note("Dynamic BP with O(log n) updates exists — Navarro/Sadakane — with larger constants still.)");

    // ---------------- occupancy-masked scan tax vs density (PMA steady-state cost) ----------------
    section("Occupancy-masked linear scan: traversal tax vs density (decoupled from edits)");
    // The PMA rows above sit at pow2-forced 30-48% density. A production PMA targets 70-90%.
    // Measure the pure scan tax of the ctz-masked loop at several densities, vs a dense scan.
    const M: usize = 1_000_000;
    let mut rng = Rng::new(77);
    let dense: Vec<FlatNode> =
        (0..M).map(|i| FlatNode { subtree: 1, kind: (i % 7) as u16, flags: (i % 3) as u16 }).collect();
    let (_, dmed, _) = bench(1, 30, 5, || {
        let mut acc = 0u64;
        for nd in &dense {
            acc = acc.wrapping_add(nd.flags as u64 ^ nd.kind as u64);
        }
        bb(acc);
    });
    println!("  dense linear scan of {M} nodes: {:.0} µs ({:.3} ns/node)", dmed / 1000.0, dmed / M as f64);
    for target in [0.90f64, 0.75, 0.50] {
        let cap = ((M as f64 / target) as usize + 63) / 64 * 64;
        let mut data = vec![FlatNode::default(); cap];
        let mut occ = vec![0u64; cap / 64];
        // place M nodes at even spacing with jitter
        for i in 0..M {
            let mut pos = i * cap / M;
            pos += (rng.below(2)) as usize; // slight jitter
            let mut p = pos.min(cap - 1);
            while occ[p / 64] >> (p % 64) & 1 == 1 {
                p = (p + 1) % cap;
            }
            data[p] = dense[i];
            occ[p / 64] |= 1u64 << (p % 64);
        }
        let (_, mmed, _) = bench(1, 30, 5, || {
            let mut acc = 0u64;
            for (w, &bits0) in occ.iter().enumerate() {
                let mut bits = bits0;
                while bits != 0 {
                    let b = bits.trailing_zeros() as usize;
                    let nd = data[w * 64 + b];
                    acc = acc.wrapping_add(nd.flags as u64 ^ nd.kind as u64);
                    bits &= bits - 1;
                }
            }
            bb(acc);
        });
        println!(
            "  masked scan @ {:>2.0}% density: {:.0} µs ({:.3} ns/node) — {:.2}x dense",
            target * 100.0,
            mmed / 1000.0,
            mmed / M as f64,
            mmed / dmed
        );
    }
    note("The masked-scan tax is the PMA's steady-state price for O(polylog) edits: bounded and");
    note("density-controlled, but always above the dense scan the chunked layout nearly matches.");
}
