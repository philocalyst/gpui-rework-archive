# Resumable display-tree operations: preregistration

Base 6d5e409d6b; BBTree 1b0201087102f81189da0c4cd5054a91c8d97d62.
User-directed primary experiment: adapt BBTree's memory-latency scheduler to
actual display-tree update preparation, with synchronous application APIs.
Solid's read/dependency scheduling supplies the task/publication design, not
an assertion that network readiness is identical to cache residency.

First bounded kernel: LayoutTree::compute_inner classifies pending edits by
forest root, currently one dependent parent chain per edit. Evaluate 32
independent chains in interleaved lanes under one immutable Tree borrow; write
results in input order, then retain the existing serial layout/mutation pass.
No lane mutates topology or publishes a partial layout/scene. The kernel is
actual core code reached by ordinary compute(), not a surrogate tree.

Compare original scalar, validated-index scalar, level-wise loops, explicit
Future lanes without hints, and Future lanes with prefetch. Also test a
single-root topology proof where applicable: eliminating known work is a
required competitor to scheduling it. Charge each batch's filling, validation,
result collection and tail, not just parent loads. Do not attribute saved ID
validation to async. Gate batches at >=32 pending and >=32768 live nodes before
measurements; tiny updates use the existing scalar path. Lane width 32 chosen
before timing; any tuning is a new campaign with preserved failures.

Unsafe proposal is confined to a prefetch hint accepting a live shared Entry
borrow, never raw caller addresses. x86_64 baseline SSE supplies prefetcht0;
other targets initially use no hint. Tree allocation/links are immutable for
the entire synchronous batch. Futures are Unpin state machines and use safe
Pin::new; no unchecked projection/indexing, aliasing or memory loads. Preserve
forbid(unsafe_code) elsewhere by scoping the exception narrowly; if this needs
changing the crate lint, document that explicitly. Validate hints against
optimized safe no-hint assembly. Miri executes all state logic with hints
compiled out; no unsafe adoption without required validation. No dependency
on BBTree's unsafe storage implementation.

Correctness: exact root results versus public parent() traversal for shuffled
forests, equal roots, different depths, partial/empty batches, reparenting,
removal and reused slots, foreign/stale IDs, all-u32-bit boundaries admitted by
Tree. Existing core tree/layout differential tests stay unchanged. Mutating
result order/root selection must fail. Sequential public compute layouts,
pending root ownership, removal/reparent and invalid-input semantics must match.

Measurement: pin compiler/profile/source/binaries, five interleaved processes
per strategy; warmup and all p50/p95/p99 CPU/wall batches preserved. Public
compute() fixture must include full dirty-root recomputation and nonselected
root filtering, cold construction, 1/8/32/128-depth and sparse/dense pending,
contiguous versus shuffled allocations, single-root and multiple-root cases.
Require >=20% complete-operation improvement in large shuffled filtering and
no >5% regression in small/contiguous/full-compute cells. Noise is inconclusive.
Report stack/code/retained allocation costs and scheduler overhead. Kernel wins
alone admit GPUI full-scene/native trials; they never establish ZGX victory.

Task track: preserve source/Reader request stamps, actual cancellation/teardown
credit and C/P presentation epochs. Memory-yield lanes may be immediately polled
again; externally blocked tasks must park until wake/completion. Coherent prior
P remains readable while newer work is pending. No shared mutable root/window,
no arbitrary user callback replay, and no await holding a mutable window borrow.

## Frozen fixture details before any timings

Each process selects one of tiny, contiguous, shuffled, medium-depth, shallow,
single-full. Sizes are 256/32768/65536 live descendants; shuffled parent chains
are allocated in permuted breadth levels. Twenty warmup calls, forty batches
of five complete public compute calls. Full cells include set_style for every
edit; filtering cells query a separate clean root while the dirty root stays
pending, then compute the dirty root and hash every layout outside timing.
Filtering is explicitly a scheduler workload, not a full frame. Cold construction
and first complete compute are reported separately. A broad full-GPUI trial is
required even if these core cells pass. This fixed fixture is shared unchanged
by all six variants, with exact final layout hashes and stats checked.
