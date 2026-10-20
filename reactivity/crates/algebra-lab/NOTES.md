# Inverse-free affine path product frontier

This is an executable data-structure experiment, not a renderer integration or
an adoption recommendation. A rooted array-based link-cut forest updates a local
transform and exposes root-to-node products without touching descendants or
inverting matrices. Singular transforms can collapse and recover. There is no
subtree damage, bounds, layout, clipping index, paint skipping, GPU work, or host.

**Unrestricted f64 semantics block adoption.** Preferred-path regrouping changes
floating cancellation even with no source edits. The characterization test uses
four translations `[1e16, -1e16, 1, 0]`: the last node initially returns x=0;
querying earlier nodes reshapes the auxiliary tree and the last query returns
x=1. Overflow/underflow checks do not fix this. Treat this spike as evidence for
an algorithm frontier over well-conditioned approximate transforms; it does not
prove stable presentation/input coordinates over arbitrary finite f64 matrices.

## Run and scope

From `reactivity`:

```sh
cargo test -p gpui_reactivity_algebra_lab
cargo run --release -p gpui_reactivity_algebra_lab --example frontier -- 12 > frontier.csv
```

The standalone test harness used here points directly at the repository library,
public integration tests and example. It lives at
`/tmp/reactivity-algebra-harness/Cargo.toml` and has its own lockfile. No dependency
on another spike, legacy GPUI, third-party algorithm implementation, or native
host is required. All code is safe Rust with `forbid(unsafe_code)`.

Seven public tests cover 15,000 seeded randomized mutation steps with four
independent parentwalk queries per step, ordered noncommutative coefficients,
singular collapse/recovery, cut/link/reparent, failed cycles, foreign keys,
numeric-range recovery, explicit numerical non-equivalence, exact node storage,
and a 100,000-deep chain. The coefficient oracle has independent formulas and
rebuilds paths from an ordinary parent vector. Both debug and optimized tests
run. Deep cold access and destruction use no recursive stack.

## Representation and invariants

Each node has four u32 indexes (`left`, `right`, combined auxiliary/path `up`, and
represented `parent`) plus local and cached six-f64 matrices: **112 bytes** on
this target. Cached invalid products use a private NaN sentinel in coefficient
`a`. Admitted inputs are finite, so the sentinel is unambiguous without unsafe,
transmute, enum-layout tricks, or a separate eight-byte `Option` tag. The first
prototype used 120 bytes; the sentinel removes that extra tag. There is no
reversal bit, matrix inverse, recursive callback framework or path allocation.

A node's `up` is an auxiliary parent exactly when that parent's left/right link
names it; otherwise it names the next preferred-path parent. Auxiliary in-order
is root-first. `pull` forms `left_product × local × right_product`, preserving
noncommutative order. `access` splays successive path ancestors, replaces each
right preferred child, then splays the queried node. Detached preferred children
keep their old `up` as a path-parent link. Rotations update both affected products.

Represented roots retain a meaningful local transform. There is no reroot/evert
API because that would change the interpretation of node-local transforms.
`cut` detaches a node's exposed left path; `link` requires a represented root in
a different component. `reparent` validates keys, cuts, checks the proposed
parent's component root, and restores the old edge on a cycle. Failure is atomic
for represented topology and local values. Preferred paths and floating rounding
can change on failed operations; no bitwise world-value rollback is promised.

Public keys contain an arena namespace and append-only index. Namespace counters
are checked against exhaustion. Foreign keys fail before topology mutation.
There is no deletion, index reuse, generation reclamation, persistence or
cross-process capability. The extra represented parent is four bytes per node;
it avoids reconstructing the public parent accessor from preferred paths.

## Complexity and numerical domain

The algorithm is the rooted splay/preferred-path form of link-cut trees:
**amortized O(log n)** per expose/local update/cut/link/reparent. One access can
still take O(n), and the first deep query below does so. Insert links a fresh
append-only node directly in O(1), excluding Vec growth. This is a serial mutable
forest; even a read query takes `&mut self` because preferred paths change.

The algebraic argument requires an associative ordered product and an identity,
not a group, so singular matrices do not require special inverse handling. IEEE
f64 matrices approximate that algebra; reassociation is not bitwise invariant.
The independent moderate-input oracle compares with relative/absolute tolerance,
while a separate test exposes catastrophic cancellation instead of disguising it
as a passing epsilon result.

Local inputs must be finite normal values or zero; subnormal/NaN/infinite inputs
return `InvalidTransform` before mutation. Composition detects nonfinite results,
subnormal results, and a nonzero multiplication that underflows to zero. A cached
range failure returns `NumericRange`, never an identity or a truly singular map.
Local edits rebuild those aggregates, so range errors can recover. Error state
is conservative and depends on grouping: an intermediate out-of-range product
may reject a path whose exact final product would be finite. Cancellation and
ordinary rounding loss are not comprehensively diagnosed. This is not a
certified numerical model.

Before production adoption choose a geometric error budget with propagated
interval/error bounds, an exact/reproducible product representation, or a bounded
coordinate model proven adequate for real traces. An arbitrary fallback to the
naive path changes performance back to O(depth) and must be reported. The
characterization must become a stable-output or diagnosed-uncertainty test before
this implementation can define pixel/hit-test correctness.

## Benchmark protocol and evidence

`frontier.csv` contains 99 data rows plus a stable header. Every shape is run at
1k/10k/100k nodes. Root camera and branch edits are followed by 1, 16, 1024, or all
**leaf** queries. Budgets cap at actual leaf count: a deep chain has one leaf,
so all four budget labels honestly report one query. Balanced has about n/2
leaves; wide has n-1. Queries are evenly spread across the leaf list. On a wide
star the branch is a leaf; on a deep chain it is the midpoint; on a balanced tree
it is node 1. This deliberately includes leaf-local cases where eager wins.

Each timed trace includes the edit and every requested read. Reparent toggles a
subtree between its original parent and a detached root, then queries a leaf
inside the moved subtree. Cycle validation is included. Build and first-ever
leaf query are separate rows. Preferred query paths and eager scratch are warmed
before edit traces; new edit targets can still incur a first access. Rows run
sequentially on one retained tree, so they expose history-dependent amortization,
not independent identically warmed samples. Counters cover the full row; times
are total elapsed nanoseconds divided by rounds. There is no p99 inference from
these short traces.

The complete alternatives are:

- LCT local/cached matrix storage, preferred-path operations and checked compose.
- Eager local/cached matrix storage, four compact u32 parent/child/sibling links,
  descendant traversal, scratch high water, and checked compose. Queries load a
  cached matrix. This reference uses a Vec traversal stack, so its wide-tree
  scratch overhead is disclosed rather than a claim of optimal eager storage.
- Naive parentwalk with a u32 parent lane and local matrices, no cached worlds,
  no per-query path allocation, and checked compose. Products prepend ancestors
  while walking upward. Edits are direct stores; reparent cycle checks walk parents.

After timings, all queried outputs are compared across all alternatives. Checks
and query-index construction are outside the measured intervals. Root edits with
sparse reads are not presented as all-leaf frame wins. All alternatives use the
same checked scalar arithmetic; this is not a comparison against a SIMD-specialized
eager implementation. Naive baselines use validated benchmark indexes internally,
not public cross-arena capabilities. Workload parent/local/leaf/query vectors are
shared harness costs. The CSV's LCT bytes **include its additional 16-byte-per-node
client key vector**, since this example actually keeps one; eager/walk use the
shared index trace. Strip that 1.6 MB at 100k when comparing only internal records.

Recorded on the container's AMD Ryzen 7 3700X, x86-64, Rust 1.97.1,
`cargo --release` defaults, 12 rounds, single thread, no native renderer. CPU
scheduling/frequency were not pinned. These are local CPU microbenchmarks, not
end-to-end UI latency or claims against another framework.

Selected complete-operation means from the committed run (100k nodes):

| Trace | LCT | Eager | Parentwalk |
| --- | ---: | ---: | ---: |
| Deep first leaf query | 15.07 ms | 0.00022 ms | 3.51 ms |
| Deep camera + one leaf | 0.000378 ms | 4.17 ms | 3.57 ms |
| Deep first midpoint-edit row + leaf | 0.383 ms | 2.04 ms | 3.53 ms |
| Balanced camera + 16 leaves | 0.0125 ms | 4.31 ms | 0.0131 ms |
| Balanced camera + 1024 leaves | 0.925 ms | 4.29 ms | 0.658 ms |
| Balanced camera + all 50k leaves | 37.76 ms | 4.24 ms | 27.73 ms |
| Wide camera + one leaf | 0.000199 ms | 3.83 ms | 0.000058 ms |
| Wide camera + all 99,999 leaves | 14.83 ms | 4.14 ms | 3.63 ms |
| Wide leaf edit + all leaves | 14.98 ms | 0.239 ms | 3.62 ms |
| Balanced reparent + affected leaf | 0.00197 ms | 2.62 ms | 0.000750 ms |

The cold deep query takes 99,999 rotations and 349,995 compositions. Repeated
100k-deep camera/leaf rows take 24 rotations and 72 compositions across 12 rounds;
eager visits 1.2M nodes. Balanced all-leaf camera reads require about 3.44M LCT
rotations across 12 rounds. This is the frontier: LCT removes sparse path-depth
work, but pays branchy restructuring and loses dense-read cases badly.

With exact pre-reservation, internal LCT payload is 11.2 MB at 100k, matching
112-byte eager records. LCT's measured total is 12.8 MB including client keys.
Eager totals are 11.200032 MB deep, 11.200256 MB balanced, and 12.248576 MB wide
including scratch. Parentwalk is 5.2 MB. These exclude container headers,
allocator bookkeeping and shared harness input arrays. Without pre-reservation,
Vec geometric growth adds unused capacity; `allocated_bytes` reports capacity,
not just live elements. Empty `Forest::new` allocates no node storage.

## Assembly inspection

Ran `cargo rustc --release --lib -- --emit=asm` through the same standalone
harness and inspected the generated `.s` for compose, pull and rotate. The target
uses scalar `mulsd`/`addsd`, floating/integer classification branches and calls to
`is_admitted`; no automatic packed matrix multiply appears. Rotate is indexed
loads/stores, bounds checks and two pull calls. Removing numeric checks or bounds
checks would change the comparison and/or safety contract; no unsafe or unchecked
variant is adopted here. This inspection is code evidence, not a perf-counter or
instruction-retirement measurement. The source-counter comparison already shows
that dense traversal loses before attempting a SIMD rewrite.

## Primary sources and provenance

Original code here was written for this experiment, not copied from a contest
implementation. The rooted preferred-path decomposition and amortized analysis
come from Sleator and Tarjan's
[A Data Structure for Dynamic Trees (1983)](https://www.cs.cmu.edu/~sleator/papers/dynamic-trees.pdf).
Their [Self-Adjusting Binary Search Trees (1985), section 6](https://www.cs.cmu.edu/~sleator/papers/self-adjusting.pdf)
describes the splay-based link/cut variant. Both primary papers were opened and
read for this task. The experiment augments ordered auxiliary paths with affine
products and omits rerooting and path-wide updates. The asymptotic claim concerns
sequences of dynamic-tree operations, not a worst-case bound on one camera event.

Keep this as an opt-in lab candidate. The measured sparse deep win warrants
further work; neither that win nor the data structure's mathematical pedigree
resolves floating reproducibility, dense-query losses, memory, subtree geometry
or UI lifecycle obligations.
