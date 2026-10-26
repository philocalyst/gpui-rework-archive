# 14 — Frontier data-structure research (Round 2 sources)

Status: research notes backing [../runtime/datastructures-2.md](../runtime/datastructures-2.md).
Three primary-source sweeps (2026-08-21): (A) bleeding-edge Rust memory crates, (B) tree-structure
literature with measured constants, (C) production engine internals. Facts were checked against
paper PDFs, crate/engine source, and official docs; explicitly-flagged gaps are listed at the end.
Nothing here is normative — the runtime contract lives in the datastructures docs; this file is
the evidence trail.

---

## A · Bleeding-edge Rust memory-representation techniques

### A1. `triomphe` — Servo's Arc fork

`triomphe::Arc<T>` is `#[repr(transparent)]` over one `NonNull<ArcInner<T>>` with
`ArcInner { count: AtomicUsize, data: T }` — vs std's `{ strong, weak, data }`. Dropping the
weak count removes 8 B from every allocation and the read-modify-write dance std needs for
weak-safety ("we don't do extra read-modify-update operations to handle the possibility of weak
references" — [docs.rs/triomphe](https://docs.rs/triomphe/latest/triomphe/)).

- **ThinArc/HeaderSlice**: `HeaderSlice<H, T: ?Sized>` is `#[repr(C)] { header: H, slice: T }`;
  `ThinArc<H, T>` stores the slice length *inside the allocation* (`HeaderWithLength`) so the
  handle is **one machine word** instead of a fat pointer; `thin_to_thick()` re-synthesizes the
  fat pointer on demand ([ThinArc docs](https://docs.rs/triomphe/latest/triomphe/struct.ThinArc.html)).
- **ArcBorrow**: `#[repr(transparent)] (NonNull<T>, PhantomData<&'a T>)` — bit-identical to
  `&T`; no refcount traffic to call `&self` methods; `with_arc()` reconstructs a
  `ManuallyDrop<Arc<T>>` temporarily.
- **UniqueArc**: build with plain non-atomic mutation, then freeze into `Arc`.
- **ArcUnion**: `Arc<A>`-or-`Arc<B>` in one word by stealing the low alignment bit; still
  `NonNull`, so `Option<ArcUnion>` is free.
- Servo/Stylo usage: the rule tree (one node per matched rule, shared across elements) and the
  style-sharing cache both clone Arcs on every element of every restyle — the exact hot path the
  no-weak, thin design serves ([stylo README](https://github.com/servo/stylo/blob/main/README.md)).

### A2. `elsa` — append-only collections with stable `&T`

`FrozenVec<T>` is literally `UnsafeCell<Vec<T>>` with `push(&self)`. Soundness does **not** come
from "never reallocates" — the outer Vec reallocates freely; it comes from restricting `T` to
`StableDeref` types (Box/String/Vec) and only ever handing out `&Target` (the pointee), which
survives moves of the pointer array. `!Sync`; no removal, ever. Costs a heap allocation per item
when `T` isn't naturally boxed ([Manishearth/elsa](https://github.com/Manishearth/elsa)).
`append-only-vec`/`boxcar` generalize to any `T` by chunking (geometric chunk growth, elements
never move) — the shape `datastructures-2.md` §S3 measures as strictly better.

### A3. `bumpalo` + Dodrio double-buffering

Bump chunks; allocation is align-round + bounds-check ("a small handful of instructions");
`bumpalo::collections::Vec<'bump, T>` growth abandons the old block (no dealloc until reset).
Dodrio's frame pattern: render frame N into arena A, diff against frame N−1 in arena B, emit
patches, reset B, swap — "the whole of the old virtual DOM tree is garbage" with a pointer reset
([Mozilla Hacks 2019](https://hacks.mozilla.org/2019/03/fast-bump-allocated-virtual-doms-with-rust-and-wasm/);
measured beating optimized Angular/Elm on TodoMVC in that post's setup). GPUI's own
`crates/gpui/src/arena.rs` is the same idea with an `Rc<Cell<bool>>` validity flag instead of
lifetimes (they tried bumpalo and rejected the lifetime pollution).

### A4. Small strings / cheap-clone vectors

- **compact_str**: 24 B total, **24 B inline capacity** — the trick: a trailing byte of valid
  UTF-8 never falls in 192..=255, so the last byte stores inline length (192+len) or acts as
  content; `Option<CompactString>` stays 24 B ([ParkMyCar/compact_str](https://github.com/ParkMyCar/compact_str)).
- **hipstr**: borrowed / 23 B-inline / Arc'd tri-state in one type, niche-packed Option.
- **ecow**: `EcoString` 16 B (15 inline); `EcoVec<T>` is **2 words** (`ptr + len`) with
  `{refs: AtomicUsize, capacity}` in a header *before* the data; clone = one relaxed fetch_add;
  copy-on-write on mutation with refs>1 ([typst/ecow](https://github.com/typst/ecow)).
- **smol_str**: 24 B, 23 inline, O(1) clone via `Arc<str>` heap arm.

Round 1's 24 B SSO `SharedString` sits in this family; compact_str's last-byte trick buys 24
(not 22) inline bytes if ever needed.

### A5. `thin-vec` and the SmallVec trap

`ThinVec<T>` keeps len/cap in the heap allocation (Gecko `nsTArray` layout): the handle is **one
word**, empty is a sentinel (no allocation), `Option<ThinVec>` is free, and it's FFI-compatible
with Gecko ([Gankra/thin-vec](https://github.com/Gankra/thin-vec)). The SmallVec trap is proven
in this repo: commit `b172d695cd` (PR #112) replaced
`SmallVec<[HistoryEntry; 1000]>` undo/redo stacks — `HistoryEntry` ≈ 80 B ⇒ ~78 KB inline per
stack, ~156 KB per `EditableTextHistory` *value*, blown thread stacks — with
`Vec::with_capacity(1000)`. Inline-N sizes the struct, not an optimization; every move pays it.

### A6. Slotmaps / generational arenas

`slotmap`: slot = `union { value, next_free } + version: u32`, **odd version = occupied** —
occupancy folded into the ABA generation; `HopSlotMap` (skip vacants via hop links),
`DenseSlotMap` (dense values + indirection, slice-speed iteration)
([orlp/slotmap](https://github.com/orlp/slotmap)). `thunderdome`: `Index` is 8 B with NonZero
generation ⇒ `Option<Index>` = 8 B. Round 1's SlotD chose the same niche independently.

### A7. Hashers (state of the art)

**foldhash** is hashbrown's current default: folded multiplication
(`(x as u128 * y) → lo ^ hi`) XOR per-process secrets. Benchmarks (Xeon 8481C,
[orlp/foldhash](https://github.com/orlp/foldhash)): u64 hash 0.79 ns (fx 0.67, ahash 1.23,
**siphash 9.09**); english-word hash 2.63 ns (fx 3.24, siphash 11.87). Average rank:
foldhash-fast > fxhash > foldhash-quality > ahash > siphash. Confirms Round 1's Flag B; fx
remains fine for trusted small-integer keys, foldhash where quality matters.

### A8. Concurrency-adjacent

- **boxcar**: lock-free append-only vec; chunk k holds 2^k slots, index→chunk by ⌊log2⌋; pushes
  never move elements ([ibraheemdev/boxcar](https://github.com/ibraheemdev/boxcar)).
- **sharded-slab**: per-thread shards + generational indices; wins only under concurrent churn.
- **left-right**: two full copies; readers wait-free on the exposed copy; writer applies twice +
  explicit `refresh()`; eventually consistent.
- **arc-swap**: atomically swappable `Arc`; loads mostly wait-free; "replace everything
  atomically" use-case, keeps performance under contention where RwLock degrades.

### A9. Pointer tagging, niches, NaN-boxing

Strict provenance (`addr`/`with_addr`/`map_addr`) is stable — tag without usize round-trips.
`tagged-pointer` uses it (CHERI-sound); tag budget = log2(align), manufacture bits with
`#[repr(align(N))]`. `ointers` steals *high* bits (48-bit VA ⇒ up to 16+, more with aligned
arenas). NaN-boxing crates (`nanbox` etc.) pack pointer+tag into f64 NaN space — 8 B dynamic
values. Round 1 already adopted NonZero niche-stacking; these are the escalation options.

### A10. Newer/edgier (2024–2026)

- **flatcontainer** / **columnar** (McSherry): regions — "O(n) objects in fewer than O(n)
  allocations"; derive-driven SoA reinterpretable as byte slices.
- **soa-rs** vs `soa_derive`: soa-rs manages **one allocation** for all field columns.
- **rkyv `RelPtr`**: self-relative offsets (i8..i64 widths; i32 common = half a pointer) —
  mmap-able archived trees; zerocopy for flat POD reinterpretation. The BP snapshot form +
  32-bit in-arena indices are the same discipline.
- **imara-diff**: histogram diff 10–100 % faster than Myers across workloads.

**Top tricks adopted into the contract** (see datastructures-2.md): no-weak thin Arc for shared
payloads; HeaderSlice single-allocation children/glyph runs; niche-packed generational ids
(already Round 1); double-buffered bump for frame scratch (already the tape); ecow-style 2-word
cheap-clone for text values; ThinVec-shaped fields for usually-empty lists; no inline-N in
movable structs (lint); foldhash/fx everywhere hot; 32-bit arena-relative indices in serialized
forms.

---

## B · Tree-structure literature (measured constants)

### B1. Packed-memory arrays

- **Itai–Konheim–Rodeh 1981**: original sparse table, O(log²N) amortized moves. Theory only.
- **Bender–Demaine–Farach-Colton (SICOMP 2005, cache-oblivious B-trees)**: density thresholds
  interpolated by depth; rebalance charged 2/(τ_{k+1}−τ_k)=O(lg P) per level ⇒ O(lg²P) moves;
  O(1 + log_{B+1}N) transfers ([paper](https://erikdemaine.org/papers/CacheObliviousBTrees_SICOMP/paper.pdf)).
- **Bender & Hu APMA (TODS 2007)**: thresholds τ₀=0.92→τ_h=0.70, ρ_h=0.30→ρ₀=0.08 (the numbers
  ds-lab's PMA uses); predictor makes rebalances uneven. Measured (P4, ~1.4M elems): sequential
  inserts **>4× fewer moves, ~7× faster** than plain PMA; bulk 2.3×/3.4×; uniform-random ~10 %
  *slower* than plain ([paper](https://www3.cs.stonybrook.edu/~bender/newpub/BenderHu07-TODS.pdf)).
- **CPMA (PPoPP 2024, Wheatman–Burns–Buluç–Xu)**: leaf delta-compression + parallel batch
  inserts; 64-core: batch-insert speedup 19×(PMA)/43×(CPMA); vs PaC-trees 3× insert / 4× range;
  **2.81 B/elt** at 10⁹; empirically optimal growth factor **1.5×**
  ([arXiv](https://arxiv.org/pdf/2305.05055)). PPCSR (ALENEX 2021): parallel PMA, up to 80M
  updates/sec ([paper](https://itshelenxu.github.io/files/papers/ppcsr-alenex-21.pdf)).

ds-lab verdict stands with the literature: PMA edits behave as advertised; the *scan* tax
(masked ctz iteration ~5× dense at all densities) is what disqualifies it as a per-frame-scanned
GUI store. Batch-APMA remains the fallback if edit patterns ever exceed the paged store.

### B2. Succinct trees

- **LOUDS** (Jacobson 1989): 2n bits but BFS-numbered — misaligned with a DFS SoA, and subtree
  data "spreads throughout the encoding" (per the DFUDS paper). Disqualified.
- **BP** (Munro–Raman 2001; Navarro–Sadakane SODA'10): DFS order matches the SoA exactly;
  range-min-max tree gives O(1)-ish everything in 2n+o(n) bits. Measured (ALENEX 2010, Core2,
  up to 350M nodes): **2.37–2.38 bits/node**, ops "within half a microsecond (30× a memory
  access)", up to 2 µs ([paper](https://users.dcc.uchile.cl/~gnavarro/algoritmos/ps/alenex10.pdf)).
- **DFUDS**: fixes indexed-child access, same 2n+o(n) bits.
- Rank/select substrate: poppy = 3.125 % rank overhead; modern measured rank ≈35–50 ns,
  select ≈100–200 ns at DRAM scale (Kurpicz, [arXiv 2206.01149](https://arxiv.org/pdf/2206.01149));
  a 1M-node topology bitvector is ~250 KB (L2-resident) so in-cache constants are far lower.
- **Dynamic succinct trees: not deployable.** Navarro–Sadakane dynamic BP pays O(log n) on all
  ops; Farzan–Munro O(1) only under a finger model; **no maintained general dynamic library
  exists in C++/Rust/Java** (checked sdsl-lite, DYNAMIC, crates). No engine ships one; Compose
  chose a gap buffer for the same problem.

### B3. Order maintenance

- **Dietz–Sleator (STOC 1987)**: integer labels, arena M>n²; one-compare order; O(1) amortized
  with one indirection level; O(1) worst-case with the 4-level variant
  ([paper](https://www.cs.cmu.edu/~sleator/papers/maintaining-order.pdf)).
- **Bender–Cole–Demaine–Farach-Colton–Zito (ESA 2002)**: virtual tree over tag space, threshold
  T^-i; tag width = log n/(1−log T) ⇒ **≈48 bits at n=10⁶ for T=1.5** (u64 ample); 32-bit tags
  handle ~430k elements vs Dietz–Sleator's ~64k at same width
  ([paper](https://erikdemaine.org/papers/DietzSleator_ESA2002/paper.pdf)).
- Practice: Figma's fractional base-95 strings grow unboundedly under adversarial monotone
  insertion; Fugue CRDT IDs are ~23 B/char; the Rust `order-maintenance` crate is embryonic.
  Essentially no mature production OM implementation exists — ds-lab's `order.rs` numbers
  (6–41 ns amortized, u64) are, as far as this research found, the only measured Rust datapoint.

### B4. Cache-conscious search layouts

**Khuong & Morin (JEA 2017)**: branch-free **Eytzinger + software prefetch beats binary search
and cache-line B-trees past L3** — "1/2 to 2/3 the time of std::lower_bound"; B-tree fanout =
line/key confirmed optimal; **vEB verdict: "not useful for in-memory searching"**
([arXiv 1509.05053](https://arxiv.org/pdf/1509.05053)). Relevance: search layouts apply to
auxiliary indexes (hit-test keys), not the scan-dominant tree; Round 1's tile buckets already
cover hit-testing.

### B5. Ropes / chunked sequences

- **Zed SumTree**: B+-tree, `TREE_BASE=6` (6–12 children), rope chunks ≤128 B, monoid
  `Summary` + multi-dimension cursor seeks; 20+ instantiations in Zed
  ([blog](https://zed.dev/blog/zed-decoded-rope-sumtree)).
- **xi-rope**: leaves 511–1024 B, children 4–8, `Metric` trait — the design SumTree refined.
- **jumprope**: skip-list of gap buffers; real-trace benchmarks (Ryzen 5800X):
  automerge-paper trace 6.66 ms vs Ropey 25.16 ms vs XiRope 518 ms; ~35–40M edits/sec
  ([josephg/jumprope-rs](https://github.com/josephg/jumprope-rs)). Lesson: local-gap-in-chunks
  wins on realistic (clustered) traces — the same shape as ds-lab's chunked pages.
- **Compose SlotTable**: two parallel gap buffers (groups: **5 packed ints** incl. a transitive
  descendant count ≈ subtree_size; slots: values), anchors for stable identity across gap moves;
  post-gap references stored as distance-from-end so they survive moves. Known weakness:
  O(distance) reorders; the experimental LinkBuffer (linked chunks) is reported "over 2× faster"
  at reordering (single-source claim, low confidence).

### B6. Diffing and incremental computation

- **Reps/Teitelbaum/Demers**: incremental attribute evaluation optimal in |AFFECTED| — the
  formal ancestor of dirty-closure layout.
- **Self-adjusting computation** (Acar; TOPLAS 2009): DDG + **order-maintenance virtual clock**;
  overhead 4–10× (drops toward ~2× as per-node work grows), end-to-end up to 3 orders faster;
  self-adjusting tree contraction ≈ Link-Cut-class dynamic trees with batch support
  ([thesis](https://www.cs.cmu.edu/~rwh/students/acar.pdf)).
- **Adapton (PLDI 2014)**: demand-driven DCG — "traditional IC gets 2×–20×... Adapton 7×–2000×";
  loses only when 100 % of output is re-demanded; memory 6.6–14×
  ([paper](http://matthewhammer.org/adapton/adapton-pldi2014.pdf)). Occluded/collapsed subtrees
  cost nothing until demanded — the virtualization story.
- **Tree edit distance is out at frame rate**: RTED joins over 5×~1000-node trees took
  140–2483 s ([VLDB 2012](https://arxiv.org/pdf/1201.0230)); React ships O(n) keyed
  reconciliation instead, with the documented two assumptions (type match, stable keys)
  ([React docs](https://legacy.reactjs.org/docs/reconciliation.html)). Myers is O(ND) — fine for
  content, bad for keyless reorders. (A widely-quoted git-histogram timing claim traced back to
  a *disagreement-rate* measurement, not latency — do not cite it.)

### B7. ECS hierarchies & cross-domain

- **flecs**: per-parent archetype fragmentation costs "over an order of magnitude" when
  iterating 1000 tables vs 1; flecs 4.1 moved asset hierarchies to one dense array per subtree
  ("roughly an order of magnitude faster", self-reported). Validates one dense store over
  parent-partitioned storage.
- **bevy 0.10**: transform propagation 4×, `many_foxes` frame ~10 ms→2.3 ms — by
  *parallelizing a full re-walk*, i.e. Bevy pays O(N) every frame for lack of a DFS+subtree
  structure ([release notes](https://bevy.org/news/bevy-0-10/)).
- **Unity DOTS**: 16 KB archetype chunks, change-version filters skip untouched chunks; but
  hierarchical transforms are 100 % recomputed each run (no dirty tracking) — a shipped
  negative datapoint on fine-grained hierarchy dirtying (hence ds-lab's *adaptive* cutover).
- **Bε-trees / BetrFS**: buffered writes flushed in batches — up to 2 orders on small random
  writes ([TOS 2015](https://www3.cs.stonybrook.edu/~bender/newpub/2015-JannenYuZh-TOS-BetrFS.pdf));
  blueprint for accumulating a frame's structural edits and applying once at commit.
- **C-Store delta-main (VLDB 2005)**: writeable store + read-optimized store + background
  merge; read-side 164× vs row store on TPC-H sample; caveat: write-side cost unmeasured in the
  paper. The describe→commit epoch split is this architecture per-frame.
- **Sea of Nodes**: V8 retired it (2022) partly for implicit-order debuggability — keep the
  authoritative paint order explicit/total; relaxed graphs only for invalidation bookkeeping.

---

## C · Production engine internals (what ships today)

| Engine | Node hot size | Storage | The one trick worth stealing |
|---|---|---|---|
| Servo/Stylo | 1 Arc/style-struct group | rule tree (triomphe, racy lock-free insert) + Arc'd style structs | sharing at *sub-struct* granularity; ancestor bloom filter for selector rejection |
| Blink | immutable fragments | fragment tree (child-only pointers!) + 4 flat property trees (transform/clip/effect/scroll) | style/geometry decomposed into flat trees indexed by tuple, not embedded per node |
| WebKit | few dozen B + tagged rare-data ptr | refcounted tree, `CompactUniquePtrTuple` (16-bit flags in pointer spare bits), 31/32 state bits used | bitfields inside pointer spare bits |
| Flutter | Widget ephemeral / Element retained / RenderObject retained | 3 parallel trees | relayout/repaint **boundaries** as invalidation circuit-breakers; O(1) inherited lookup via per-Element copied HashMap |
| Compose | 5 packed ints/group | two parallel gap buffers + anchors | anchors: logical identity decoupled from physical offset |
| SwiftUI/AG | undisclosed | closed pull-based dataflow graph | (nothing verifiable beyond pull-propagation; treat byte-level claims as speculation) |
| Slint | fixed, compile-time | flat static item arrays + vtable, index navigation; repeaters only allocate | compile topology to indices; 264 KB-RAM via line-by-line rendering, no framebuffer |
| ImGui/egui | 0 retained nodes | ID-hash stack + flat sorted `ImGuiStorage` / `IdTypeMap`; ImDrawList buffers never shrink | identity recomputed, not stored; steady-state zero-alloc frames |
| Xilem/Masonry | `TreeNode` Vec-of-children (safe default) | safe nested-Vec tree OR opt-in unsafe `HashMap<NodeId, Box<UnsafeCell<…>>>` | live admission that safe-fast general trees are unsolved — ships both behind a flag |
| Vello | 0 — no scene graph | flat parallel encoding streams (`path_tags/path_data/draw_tags/…`) + `StreamOffsets` splicing | full SoA scene; "no graph, just typed streams" |
| GPUI (today) | arena-bumped elements/frame | chunked bump arena + `Rc<Cell<bool>>` validity swap; entities leased from one owner; SumTree everywhere | validity-flag swap instead of per-object generations |
| Unity DOTS | columns in 16 KB chunks | archetype SoA | chunk-level change filters |
| Unreal Slate | undisclosed `SWidget` | retained C++ tree + invalidation roots | `Volatile` opt-out so per-frame content skips caching tax |
| Godot 4 | **Node 968 B / Control 2432 B** (measured, template_release) | heap OOP pointer tree | (anti-example: the per-node price of the conventional design) |
| Clay | fixed-size in one arena | single user-provided bump arena, reset per frame; ~4.8k LOC, 15 KB wasm | one file, one arena, one allocation strategy |
| LVGL | heap `lv_obj_t`, pool-allocated | classic pointer tree | scale to 16–32 KB RAM by feature-stripping, not topology |

**Gaps nobody ships** (the greenfield openings Round 2's contract takes):
1. succinct/implicit topology *alongside* columnar SoA payloads (Vello has no tree; Slint bakes
   topology at compile time) — taken as the BP cold form over the same DFS indices;
2. PMA-class gap-tolerant edits generalized beyond text — measured, rejected for scans, replaced
   with paged chunks (which Compose's LinkBuffer prototype independently validates);
3. structural sharing as a *default of the lowered form* rather than a style-only cache —
   Round 1 tape dedup + ThinArc;
4. content-addressed reuse of unchanged subtrees across frames (Compose memoizes by call-site,
   not content) — Round 1's span hashes are the content-address; the diff already skips
   byte-identical spans.

---

## Explicitly-flagged research gaps (do not cite as measured)

Itai–Konheim–Rodeh original constants (theory only); post-2010 succinct-tree navigation at
in-cache GUI scale; Joannou–Raman dynamic-BP experimental numbers; git histogram-diff *latency*
(the popular number is a misattribution); EnTT/Unity official hierarchy-throughput tables;
APTED-vs-RTED head-to-head timings; SwiftUI AttributeGraph memory layout (closed; OpenSwiftUI
reimplementation too early); Stylo style-sharing hit-rate percentages (Mozilla published
qualitative claims only); Compose LinkBuffer numbers (single unverified blog).
