//! Experiment (ADVENTUROUS): the retained DISPLAY STORE — the structure that holds all nodes.
//!
//! Contract (memory.md §0/§3, fastpath §3/§4/§7, scheduler "before drawing"):
//!  - "There is no retained tree of element OBJECTS ... only compact lowered records persist ...
//!     kind-segregated SoA slabs (a node's hot header is a few machine words; cold data is side-tabled)."
//!  - The store is traversed in PAINT ORDER every presentation build (style/layout/hit/paint), and
//!    queried by region (hit test) and by z/extent (order sum-tree).
//!  - Structural novelty is page-granular; steady state re-describe patches in place.
//!
//! We test three layouts for the dominant op (a full paint-order traversal of 10k nodes) and for the
//! parent-chain walk (hit/focus), plus header size and child-list strategies. The adventurous entry
//! is (C) a FLATTENED DFS-ORDER SoA scene: nodes are stored in paint order so a full traversal is a
//! LINEAR SCAN (perfect prefetch) and any subtree is a contiguous range [i, i+subtree_size).

use dslab::*;

// ---------- Build a realistic UI tree: ~10k nodes, variable fanout, moderate depth ----------
struct TreeSpec {
    parent: Vec<u32>,        // parent[i], u32::MAX for root
    children: Vec<Vec<u32>>, // children[i] in paint order
    order: Vec<u32>,         // a DFS (paint) order of node ids
}
fn build_tree(n: usize, seed: u64) -> TreeSpec {
    let mut rng = Rng::new(seed);
    let mut parent = vec![u32::MAX; n];
    let mut children: Vec<Vec<u32>> = vec![Vec::new(); n];
    // grow a tree: each new node attaches to a recent-ish existing node (bias toward shallow, wide UI)
    for i in 1..n {
        // pick a parent among the last window of nodes to keep depth moderate and fanout varied
        let window = (i as u32).min(64);
        let p = i as u32 - 1 - rng.below(window);
        parent[i] = p;
        children[p as usize].push(i as u32);
    }
    // DFS paint order from root 0
    let mut order = Vec::with_capacity(n);
    let mut stack = vec![0u32];
    while let Some(x) = stack.pop() {
        order.push(x);
        // push children reversed so they pop in paint order
        for &c in children[x as usize].iter().rev() {
            stack.push(c);
        }
    }
    TreeSpec { parent, children, order }
}

// ---------- (A) AoS fat-node pointer tree ----------
#[derive(Clone, Copy)]
struct NodeAoS {
    parent: u32,
    first_child: u32,
    next_sibling: u32,
    kind: u16,
    flags: u16,
    // cold-ish payload kept inline in the fat node (the anti-pattern we're measuring):
    payload: [u32; 4],
}
const NIL: u32 = u32::MAX;

// ---------- (C) flattened DFS-order SoA ----------
struct FlatScene {
    // arrays are in PAINT (DFS) order; index = paint position
    subtree_size: Vec<u32>, // number of nodes in this subtree incl self -> skip = i+subtree_size
    kind: Vec<u16>,
    flags: Vec<u16>,
    payload_idx: Vec<u32>, // index into a kind-segregated payload slab (side-tabled)
    depth: Vec<u16>,
}

fn main() {
    section("The retained DISPLAY STORE — layouts for paint-order traversal (10k nodes)");

    const N: usize = 10_000;
    let t = build_tree(N, 1234);

    // ---- header sizes ----
    size_line::<NodeAoS>("(A) NodeAoS fat node (parent,fc,ns,kind,flags,payload[4])");
    #[derive(Clone, Copy)]
    struct HeaderSoA {
        parent: u32,
        first_child: u32,
        next_sibling: u32,
        kind: u16,
        flags: u16,
    }
    size_line::<HeaderSoA>("(B) SoA header {parent,fc,ns,kind,flags} (16B)");
    #[derive(Clone, Copy)]
    struct FlatNode {
        subtree_size: u32,
        kind: u16,
        flags: u16,
    }
    size_line::<FlatNode>("(C) Flat DFS node {subtree_size,kind,flags} (8B)");
    note("Fat AoS node is 32B; a paint traversal touching only {flags,kind} still drags payload[4] through");
    note("cache. SoA header is 16B; flat-DFS hot record is 8B. Cold payload is side-tabled in both B and C.");

    // ---- Build (A) AoS ----
    let mut aos = vec![
        NodeAoS { parent: NIL, first_child: NIL, next_sibling: NIL, kind: 0, flags: 0, payload: [0; 4] };
        N
    ];
    for i in 0..N {
        aos[i].parent = t.parent[i];
        aos[i].kind = (i % 7) as u16;
        aos[i].flags = (i % 3) as u16;
        let ch = &t.children[i];
        if let Some(&f) = ch.first() {
            aos[i].first_child = f;
        }
        for w in ch.windows(2) {
            aos[w[0] as usize].next_sibling = w[1];
        }
    }
    // NOTE: AoS nodes are in ID order, not paint order -> traversal pointer-chases across memory.

    // ---- Build (B) SoA header (arrays in ID order) ----
    let mut b_parent = vec![NIL; N];
    let mut b_fc = vec![NIL; N];
    let mut b_ns = vec![NIL; N];
    let mut b_kind = vec![0u16; N];
    let mut b_flags = vec![0u16; N];
    for i in 0..N {
        b_parent[i] = t.parent[i];
        b_kind[i] = (i % 7) as u16;
        b_flags[i] = (i % 3) as u16;
        let ch = &t.children[i];
        if let Some(&f) = ch.first() {
            b_fc[i] = f;
        }
        for w in ch.windows(2) {
            b_ns[w[0] as usize] = w[1];
        }
    }

    // ---- Build (C) flat DFS scene ----
    // paint position of each id:
    let mut pos_of = vec![0u32; N];
    for (p, &id) in t.order.iter().enumerate() {
        pos_of[id as usize] = p as u32;
    }
    // subtree size via a post-order pass on the DFS order
    let mut subtree = vec![1u32; N]; // by paint position
    // compute subtree sizes: process paint order in reverse, add child subtree sizes to parent
    // easier: recompute from children
    fn calc_subtree(id: u32, children: &[Vec<u32>], pos_of: &[u32], out: &mut [u32]) -> u32 {
        let mut sz = 1u32;
        for &c in &children[id as usize] {
            sz += calc_subtree(c, children, pos_of, out);
        }
        out[pos_of[id as usize] as usize] = sz;
        sz
    }
    calc_subtree(0, &t.children, &pos_of, &mut subtree);
    let mut flat = FlatScene {
        subtree_size: subtree,
        kind: vec![0; N],
        flags: vec![0; N],
        payload_idx: vec![0; N],
        depth: vec![0; N],
    };
    for (p, &id) in t.order.iter().enumerate() {
        flat.kind[p] = (id as usize % 7) as u16;
        flat.flags[p] = (id as usize % 3) as u16;
        flat.payload_idx[p] = id;
    }

    // ================= FULL PAINT-ORDER TRAVERSAL =================
    // (A) AoS via first_child/next_sibling DFS
    let (amin, amed, _) = bench(1, 500, 50, || {
        let mut acc = 0u64;
        let mut stack = vec![0u32];
        while let Some(x) = stack.pop() {
            let n = aos[x as usize];
            acc = acc.wrapping_add(n.flags as u64 ^ n.kind as u64);
            let mut c = n.first_child;
            // push children (reversed order not needed for a sum)
            while c != NIL {
                stack.push(c);
                c = aos[c as usize].next_sibling;
            }
        }
        bb(acc);
    });

    // (B) SoA header DFS
    let (bmin, bmed, _) = bench(1, 500, 50, || {
        let mut acc = 0u64;
        let mut stack = vec![0u32];
        while let Some(x) = stack.pop() {
            let xi = x as usize;
            acc = acc.wrapping_add(b_flags[xi] as u64 ^ b_kind[xi] as u64);
            let mut c = b_fc[xi];
            while c != NIL {
                stack.push(c);
                c = b_ns[c as usize];
            }
        }
        bb(acc);
    });

    // (C) flat DFS = LINEAR SCAN, no stack, no pointer chase
    let (cmin, cmed, _) = bench(1, 500, 50, || {
        let mut acc = 0u64;
        for p in 0..N {
            acc = acc.wrapping_add(flat.flags[p] as u64 ^ flat.kind[p] as u64);
        }
        bb(acc);
    });

    println!("\n  FULL paint-order traversal of {} nodes (accumulate flags^kind):", N);
    println!("    (A) AoS fat-node  first_child/next_sibling DFS : {:>6.0}ns ({:.2}ns/node)", amed, amed / N as f64);
    println!("    (B) SoA header    DFS over dense u32 arrays     : {:>6.0}ns ({:.2}ns/node)", bmed, bmed / N as f64);
    println!("    (C) flat DFS SoA  LINEAR SCAN (paint order)     : {:>6.0}ns ({:.2}ns/node)", cmed, cmed / N as f64);
    println!("    speedup C vs A = {:.1}x   C vs B = {:.1}x", amed / cmed, bmed / cmed);
    let _ = (amin, bmin, cmin);

    // ================= SUBTREE SKIP (C's superpower): "reflow this subtree only" =================
    // In flat DFS, a subtree at paint pos p is exactly [p, p+subtree_size[p]) -> a contiguous slice.
    let mut rng = Rng::new(9);
    let probe: Vec<usize> = (0..1000).map(|_| rng.below(N as u32) as usize).collect();
    let (ssmin, ssmed, _) = bench(1, 1000, 100, || {
        let mut acc = 0u64;
        for &p in &probe {
            let end = p + flat.subtree_size[p] as usize;
            for q in p..end {
                acc = acc.wrapping_add(flat.flags[q] as u64);
            }
        }
        bb(acc);
    });
    println!("\n  (C) subtree traversal of 1000 random subtrees (contiguous ranges): {:.0}ns", ssmed);
    note("In flat-DFS a subtree is a CONTIGUOUS slice [p, p+subtree_size) -> 'relayout the dependency");
    note("closure, not the window' (fastpath §7) becomes a linear scan of one slice. No tree walk.");
    let _ = ssmin;

    // ================= PARENT-CHAIN WALK (hit/focus resolution) =================
    // Both need a parent[] array; the flat scene also keeps a parent-by-position for this.
    let mut c_parent_pos = vec![NIL; N];
    // parent position: for each id, parent's paint position
    for id in 0..N {
        let pid = t.parent[id];
        if pid != NIL {
            c_parent_pos[pos_of[id] as usize] = pos_of[pid as usize];
        }
    }
    let leaves: Vec<u32> = (0..N).filter(|&i| t.children[i].is_empty()).map(|i| pos_of[i]).collect();
    let sample: Vec<u32> = (0..1000).map(|_| leaves[rng.below(leaves.len() as u32) as usize]).collect();
    let (pmin, pmed, _) = bench(1, 1000, 100, || {
        let mut acc = 0u64;
        for &start in &sample {
            let mut cur = start;
            while cur != NIL {
                acc = acc.wrapping_add(cur as u64);
                cur = c_parent_pos[cur as usize];
            }
        }
        bb(acc);
    });
    println!("  parent-chain walk (1000 leaves -> root, SoA parent[]): {:.0}ns", pmed);
    note("Parent walk is a pointer chase either way; a dense u32 parent[] array keeps it cache-friendly.");
    let _ = pmin;

    println!();
    verdict("ADOPT a kind-segregated SoA store with a FLATTENED DFS (paint-order) hot layer:");
    verdict("  · hot record per node = 8B {subtree_size:u32, kind:u16, flags:u16}, stored in PAINT ORDER;");
    verdict("  · cold/per-kind payload side-tabled, reached by a payload_idx (kind-segregated slabs);");
    verdict("  · a dense u32 parent[] (by paint position) for hit/focus parent-chain walks.");
    verdict("Full paint traversal becomes a LINEAR SCAN (measured multiples faster than pointer-chase DFS);");
    verdict("any subtree is a contiguous range [p, p+subtree_size) -> dependency-closure relayout is a slice.");
    verdict("COST: structural edits (insert/move subtree) are O(N) memmoves of the flat arrays — acceptable");
    verdict("because describe already rebuilds paint order into reused bump pages each turn (memory.md §3);");
    verdict("the flat scene is the LOWERED, diff-stable form, not an incrementally-pointer-mutated tree.");
}
