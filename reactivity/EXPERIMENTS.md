# Reactivity experiment and acceptance register

Each experiment compares complete alternatives on the same traces. Keep the
simple implementation as an oracle. Record source commits, compiler flags,
machine/driver, seeds, construction, warm and cold behavior, peak bytes and
p50/p95/p99. A microbenchmark win admits an end-to-end trial, not a public claim.

| Area | Alternatives to implement | Adversary and measurements | Adoption or rejection |
| --- | --- | --- | --- |
| Shared templates | Immutable BP topology + typed sparse/dense instance overlays; direct eager field pages | Repeated static versus tiny/fully customized, template revision/target remap, explicit style Set(default) | Lab measured repeated-case savings and dense losses; no whole-widget memory or stable-site implementation claim |
| Dynamic path products | Parent stream; parentwalk; affine and exact-translation link-cut | Cold/deep sparse versus dense leaf reads, cancellation/query reorder, extreme coordinates | Exact i64/i128 translation domain admitted for trial; unrestricted IEEE affine regrouping rejected |
| Coverage proofs | Direct implicit predicates; interval SDF/Lipschitz hierarchy; opaque tile pruning | Boundary-dense, shear, alpha changes, backdrop barriers, CPU/GPU precision mismatch | Lab measured complete plan+point-render wins/losses; area AA and backend envelopes still required |
| Handoff visibility | Per-worker SPSC + successful producer RMW/ack RMW; ready hints | Stale-empty queue, coalesced producers, bounded drain, hint-before-wake, close/reuse | Loom positive finite models plus four actual bad-protocol witnesses; native/GPU fairness not proven |
| Complete-pass algebra | Linear filter pushdown; analytic rectangular shadows; Gaussian fusion; implicit virtual positions | Clamp/alpha/backdrop/clip/grid changes, finite-kernel error, unique extents | Derivations in FORMULATIONS; integrated oracle/quality tests required before adoption |
| Tree topology | Intrusive 32-bit links; packed parent/child lanes; generatively scoped compact IDs | Million deep chain; wide root; arbitrary same-kind slot reuse; failed cycles; 1k/10k/100k/1M | No recursive destruction; O(removed) removal; namespace-safe crossing; report all directory/generation bytes |
| Paint order | Dense DFS; chunked 128/256/512 pages plus Fenwick; augmented B+ sequence; order labels | Uniform and clustered insertion, page split/merge, repeated between-neighbor insertion, subtree moves | Include global page-directory/Fenwick rebuild and label relabel cost; choose mutation/scan Pareto frontier |
| Dependency edges | Intrusive slab; CSR fanout cache; sorted small vectors | Dynamic branches replace read sets; one high-fanout theme; frequent subscriber teardown | O(changed closure), no dead edges or hidden whole-tree scan; cache rebuild must amortize |
| Dirty traversal | Direct sink queue; ancestor summaries; dense per-kind sweep | 0, .01, .1, 1, 10, 100 percent dirty at varying depth | Select crossover from local traces; include ancestor-mark cost and queue memory, not traversal alone |
| List identity | Contiguous items + directory; gap/chunk storage with explicit API; shared identity arena | Drag across lists/windows, failed drop, stale slot, move with focused text/IME | Preserve identity exactly once; never expose disjoint chunks as `[T]`; measure index maintenance and relocation |
| Layout cache | Cephal current 464B NodeCache; lazy allocation; one-entry and pooled spill vendor experiment | Cheap leaves, deeply nested intrinsic size, cache eviction, randomized cold parity | Lower total live/retained bytes without repeated measure storms; no cache-key/rollback mismatch |
| Style and packets | Interned defaults; inline patches; per-kind columns; static template instances | Unique styles, many equal styles, adversarial hash collisions, theme fanout | Equality confirms hits; unique-case overhead bounded; schema setters and impacts stay one source |
| Geometry | Full affine; tagged identity/translation; interned clip/space chains | Reflection, shear, tiny/huge coefficients, rotation, clip re-entry, large scroll | Paint/input/IME/a11y same epoch; no missing damage; count matrix/inverse recomputations and bytes |
| Hit tests | Reference linear scan; tiles; R-tree/BVH; paint-order candidate index | Many overlapping nodes, 30k geometry chain, moved parent, deep clips | Avoid Θ(N²) clip checks; exact local predicate; index mutation cost included |
| Damage | Exact small rects; tile words with sparse touched indexes; row runs; full surface | Thin scrolling bands, dispersed points, blur/backdrop, transparent animation, exposure | Zero missing pixels; report overdraw, upload and GPU bandwidth; representation switch uses complete cost |
| Owned text planning | Scoped fresh planners; exclusive cached font and paragraph state | Unicode/caret/authority/unwind oracles, four-way CPU and long-shrink allocation traces; [dossier](evidence/text-session/README.md) | CPU gates pass, 1044 tests and actual private X11 pass; unadopted with large retained paragraph cost and unresolved native/competitor gates |
| Retained GPU output | Existing complete compositor; one retained image with certified repair and full presentation copy | Sparse text/alpha versus flat/full damage, foreign window/epoch, failed preparation, fresh target, resize; [local dossier](evidence/retained-output-local/README.md) | Unadopted: exercised correctness passes; exploratory software-Vulkan wins and losses, no preregistered performance gate, cold/memory/hardware comparison pending |
| Retained compression | Shared defaults; dictionary spans; XOR/delta; succinct cold topology; zstd cold pages | Unique/churning payloads, eviction then input, frequent small edits | Lossless values and bounded decode latency; no compression on every hot access; no whole-cache decompression |
| Local sharing | Borrow; move/Box slice; std Arc; triomphe ArcBorrow/ThinArc/UniqueArc | Unique and 2/10/100 readers, thread handoff, payload destruction, slow reader | Include allocator size, clone/drop assembly, lease bytes and reclamation. Prefer no clone on reads |
| Worker ownership | Single owner; scoped jobs; demand-started pool; dedicated submit owner | Small input bursts during 100k cold layout; rapid cancellation/remount; worker fault | p99 input + total bytes improve; deterministic merge; owner graph never shared mutable; bounded queues |
| SIMD | Stable scalar/autovectorized loops; SSE2/AVX2/NEON dispatched kernels | 0..lane+1 lengths, misalignment, NaN/Inf, low occupancy, feature unavailable | Scalar equivalence, actual assembly inspection, feature proof; no portable binary illegal instructions |
| Kernel algorithms | Bitsets vs sorted sparse sets; incremental/Fenwick vs full sum; partial order vs sort | Tiny and huge universes, dense updates, adversarial insertion patterns | Choose from true operation distribution and all maintained metadata; prove asymptotic limits |
| Native startup | Lazy host; selected X11/Wayland/CSD; shared device; font on demand | Windowless launch, first visible frame, open/close 1/10/100 windows, suspend/resume | Record time, page faults, PSS/RSS, native/GPU/CPU buffers; no global loop created in headless mode |
| Binary/paging | Default vs ThinLTO/section GC; dynamic/static; read-only mapped templates | Cold page cache and warm cache, actual UI first frame, multi-process use | ELF bytes, executable pages, PSS, first paint and build time all reported; tiny exit-only program is not a GUI baseline |
| WSI/driver | FIFO/mailbox where available; 2/3 images; persistent upload ring; stable primitive slots | Slow GPU, resize/device loss, minimized window, repeated damage, multiple windows | Respect protocol release/fences; count completion latency + queue depth + memory; never overwrite leased ranges |
| Guest surfaces | Same-runtime nodes; native child; texture lease; wasm/process scene protocol | Transformed overlap, popup, focus/IME, device loss, slow guest, unmount | Capability-negotiated limits, bounded IPC/payloads, ordered reliable events, scale/damage coherence |
| Reflection/override | Typed field/part descriptors; one generated schema; derive-assisted user state | Private fields, invalid values, wrong T, override reset, library replacement | No string mutation in hot core; validation/impact mandatory; no blanket serialization promise |
| Testing/journal | Production host configured headless; semantic visitor; source-state serde | Crash with handoff, shared aliases, unknown plugins, redacted fields, async reorder | Same engine and entry points; deterministic replay; no leaked runtime IDs or lossy byte serialization |

## Unsafe admission

Safe code is the baseline. Each unsafe proposal supplies a local invariant,
ownership/lifetime diagram, exact preconditions at every call site, comparison
against optimized safe assembly, a measured bottleneck, and Miri/sanitizer/fuzz
results. Candidate experiments include unchecked slab access behind one validated
phase borrow, pointer-tagged enum storage with proven alignment/provenance, and
custom SIMD loads. Safe niche enums, `NonZero` indexes and plain loop restructuring
must be compared first. Rust enums without stable layout cannot be transmuted;
serde's untagged enums are a wire-format choice, not a guarantee of tag-free
in-memory storage. Strict provenance and atomic ordering remain requirements.

No unsafe experiment is accepted while its required validation is unavailable.
An unsafe reference-counting or arena trick is a poor default if it turns a short
safe kernel into a larger proof burden without a product-level improvement.

## Integration review and gates

The integrating agent reads the complete final diff and public tests, challenges
storage/lifetime/cross-tree assumptions, rewrites overlapping types, then commits
only the reviewed coherent result. A spike's standalone test success does not
validate its interaction with the combined core. Isolated `*-lab` crates are
competing experiments with deliberately separate private types; they are not
all selected production subsystems. Never merge two different node,
epoch, identity or dirty-mask abstractions merely because both compile.

Required before public parity claims: production-path headless input, cold-layout
and full-paint differential tests, compile-fail API corpus, layout/text/IME/a11y
fixtures, all allocation categories attributed, no idle render/scan, bounded
teardown/late work, clean-tree skip proofs by counters, and competitor workload
ports on two hardware classes. The full gate catalog in the supplied
`designs/reactivity/final/10-quality.md` remains required for the later feature
slices; this register adds experiments rather than weakening those gates.
