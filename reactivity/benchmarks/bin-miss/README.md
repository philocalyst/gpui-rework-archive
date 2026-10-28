# CPU raster membership: miss construction and contained reuse

This experiment keeps the frozen parent and first lazy-cache candidate intact.
The first lazy candidate regressed alternating distant repairs; the following
formulations isolate the work responsible before expanding reuse.

| Source | Formulation |
|---|---|
| `b1fc101435` | Parent: rebuild each requested CSR inside generic render output |
| `3724ece72f` | Lazy scratch owner, exact-envelope cache, outlined construction |
| `ac2ec9cb88` | Inline only the two-call-site tile visitor |
| `6a5b205350` | Project ordered integer bounds; no material reconstruction |
| `0c7aa122fd` (production `521da7978b`) | Above plus reuse any containing cached CSR |

The measured fixture is byte-identical across every source. It times recording,
first blank CPU output, first 4,096-panel scene, repeated same-tile color repair,
alternating distant repair, full color raster, and structural replacement. All
six image digests must agree before a result is accepted. The runner checks each
source HEAD, tracked diff, fixture digest, and frozen executable digest before
and after every run. No source swapping occurs during capture.

## Why the original miss became slower

The actual frozen release cursor pass reconstructs `BorrowedCommand` via
`DisplayList::get`, then copies its 140-byte payload into the enumeration tuple
and calls an outlined tile visitor. At 4,096 commands that adds 573,440 copied
payload bytes plus 4,096 helper calls to the second scan, including commands
outside a one-tile repair. The parent uses the getter result in place and has no
outlined visitor. Both versions perform two scans; this is not an extra-scan
claim. The inline-only release removes the per-command copy and visitor call,
but still reconstructs every command twice. Its prepare callee grows from
1,749 to 1,969 bytes. The remaining cursor `memcpy` copies the offset array once.

`ordered_bounds` instead resolves each existing private order address directly
to `Geometry.bounds: [u16; 4]`. Neither CSR scan reads a Common, material tag,
image, inverse transform, glyph resource, or full borrowed command. Enumeration
still supplies exactly the painter ordinal stored in CSR indices. Bounds and
floor/ceil tile intersection are unchanged.

## Cache authority and workers

A successful scene structural mutation invalidates the sole cached bounds.
Color-only edits preserve geometry and order; raster-time opacity cuts and
working colors are always recomputed. Scratch invalidates before allocating or
rebuilding so a caught construction panic cannot publish partial membership.

For one fixed command sequence, the membership and order for a physical tile
are independent of which enclosing request caused construction. A contained
request therefore uses the existing cached origin and stride for lookup while
its own tile rectangle continues to limit bands, columns, and output writes.
A miss builds only its actual requested rectangle. There is no viewport
prebuild, union of disjoint caches, second CSR, or new retained field.

The owner finishes mutable CSR construction before workers borrow immutable
`Frame`. The cursor is not read or mutated by raster workers. Replacing two
borrowed slices by one scratch reference reduces Frame by 24 bytes; it does not
introduce a shared mutable owner. Serial and Rayon use the same physical tile
lookup. `tile_references` sums requested tiles' unpruned lists during raster;
it does not report the potentially larger retained cache's list length.

The pool's existing full-command scheduling estimate remains unchanged. A
cache hit does not mean all command traversal or pixel work has disappeared.
External image preservation and buffer-age validation remain the caller's
responsibility.

## Correctness and costs

The public oracle checks mixed rounded solids, shared glyph runs, and images;
nonzero cached origins and a different requested stride; distant containment;
regional-first misses; structural changes; current opacity/color; dropped and
failed work; diagnostic interleaving; and serial/parallel output and reference
statistics. The private bounds oracle compares the projection against the old
borrowed-command path and independently computes every tile's members.

A first version of that private unit oracle loaded the global bundled font and
interfered with the separate font registry lifetime unit test. Its final version
uses both private address forms with a grouped solid copied from already
admitted geometry. Mixed glyph resources remain covered in the public test
binary. This test isolation correction does not alter production storage.

The release allocation/header ledger and paired results follow. No speedup is
inferred from the source reduction alone.

## Emitted code and allocation ledger

All sizes below are from the actual default-feature release phase executable,
not a synthetic wrapper or an inferred inlining claim. Complete prepare
callees and the parent builder excerpt are in `asm/`.

| Formulation | Prepare bytes | Explicit prepare stack subtraction | Serial render output bytes | Linked `.text` bytes |
|---|---:|---:|---:|---:|
| Parent | In generic renderer | — | 26,424 | 948,460 |
| First lazy | 1,749 | 488 | 23,708 | 948,944 |
| Inline visitor | 1,969 | 328 | 23,708 | 948,740 |
| Bounds projection | 2,393 | 216 | 23,708 | 948,452 |
| Contained reuse | 2,449 | 216 | 23,978 | 948,788 |

The stack column excludes saved registers and the return address. The bounds
callee is larger despite doing less material work; it contains both inlined
address/tile scans. Whole linked text is not the sum of just these symbols.
The final renderer additionally uses cached physical tile coordinates and sums
processed references. No timing benefit is inferred from callee size.

On this 64-bit build, all lazy formulations retain Canvas 488 B plus an optional
80 B scratch allocation; the parent Canvas is 552 B with the Vec headers
inline. Active lazy storage is therefore 16 B larger before vector bodies,
while recording-only Canvas is 64 B smaller and allocates no scratch. The final
source does not add another retained field or allocation. Frame is 88 B instead
of 112 B, and RenderStats stays 96 B. The 32×32 blank first raster requests three
allocations totaling 152 B: the 80 B owner plus 72 B of CSR/cursor capacities.
The repeated raster requests zero allocations. Large capacities are retained;
contained reuse does not claim to free them or bound them below the existing
admitted scene/reference limits. `gates/ledger.log` preserves the actual counts.

The final full parallel-feature release suite passes 138 cases/doc tests with
five explicit ignores, and all-target parallel Clippy passes with `-D warnings`.
The existing vendored Parley deprecation warning is a dependency warning, not a
first-party lint exemption. This isolated kernel change has no GPU or native
host source change; combined application/native gates remain integration work.


## Guarded five-way result

Capture `2026-10-22T01:13:05Z`–`01:13:16Z`, AMD Ryzen 7 3700X, Linux x86-64,
Rust 1.97.1 / LLVM 22.1.6, Cargo release opt-level 3, default features. Fifteen
fresh processes run in three alternating forward/reverse five-way rounds, all
pinned to CPU 0. There are 105 phase rows and no exclusions or reruns. All 90
image-digest observations match; source/executable/fixture pre/postguards pass.
The original rejected first-cache campaign remains separate and unchanged.

Each cell below is the median per operation of three processes. Raw times,
ranges, iteration counts, allocation totals, and every process log remain in
`capture/`; this small campaign does not establish a confidence interval.

| Operation | Parent | First lazy | Inline only | Bounds only | Contained reuse |
|---|---:|---:|---:|---:|---:|
| Recording only | 35 ns | 33 ns | 33 ns | 33 ns | 33 ns |
| First blank CPU | 3.456 µs | 3.578 µs | 3.418 µs | 3.414 µs | 3.423 µs |
| First 4,096 panels | 2.727 ms | 2.736 ms | 2.759 ms | 2.659 ms | 2.689 ms |
| Same-tile repair | 42.522 µs | 2.956 µs | 3.026 µs | 2.967 µs | 2.951 µs |
| Alternating distant repair | 42.561 µs | 85.760 µs | 40.884 µs | 21.240 µs | 2.740 µs |
| Full color raster | 2.060 ms | 1.851 ms | 1.981 ms | 1.885 ms | 1.889 ms |
| Full structural replacement | 12.912 ms | 12.239 ms | 12.281 ms | 12.166 ms | 12.144 ms |

The staged controls support a concrete causal conclusion: visitor inlining
removes the extra per-command copy/call and restores the distant-miss cost near
the parent; direct bounds projection halves the remaining construction cost;
contained reuse then avoids construction after full priming. An initially
regional request that later changes extent still pays a miss, now through the
bounds-only builder. No claim is made that every request is a cache hit.

Losses are retained. Relative to first lazy, inline-only full color is +7.02%,
first panels +0.83%, same-tile repair +2.37%, and structural replacement +0.34%.
Bounds-only full color is +1.81% and same-tile +0.37%. The final formulation is
+2.05% for full color versus first lazy (range 1.887–1.889 ms, compared with
1.847–1.948 ms); it remains −8.32% versus the parent. It is −96.81% for distant
repairs versus first lazy and −93.56% versus the parent. Its other final medians
are lower than both controls in this capture; nanosecond recording differences
and small cold-path differences should not be promoted to product speed claims.

Every warmed color-repair and full-raster phase requests zero allocations in
all five formulations. First 64×48 blank construction/raster retains the lazy
allocation penalty: three requests / 280 B per iteration versus parent's two /
200 B. First-panel construction likewise adds one 80 B owner allocation per
Canvas; its eight iterations request 296 allocations / 9,016,640 B versus
288 / 9,016,000 B. Structural replacement allocation totals are unchanged.
Every measured phase ends with zero additional live bytes because its temporary
objects have dropped; that is not a claim that the retained Canvas is free.

No compiler/test/native workload appeared in either boundary snapshot. The
raw snapshots remain at the recorded `/tmp` paths with SHA-256s in
`capture/process-audit.json`; it stores only the relevant process identities,
not unrelated process arguments. `/proc/pressure/{cpu,io}` snapshots are also
preserved. CPU some-stall total grew by 506,147 µs and IO some-stall total by
159,704 µs across the approximately 11-second window; full CPU stall stayed
zero. These system counters are context, not proof that all observed variation
comes from the formulation.

Recommendation: adopt the bounds projection and contained reuse together after
combined application/native verification. They fix the observed miss regression
with no new retained state, preserve the first regional request's scope, and
keep the recording-only header reduction. Accept explicitly the lazy owner's
extra first-raster allocation, active +16 B header total, and measured +2.05%
full-color tradeoff versus first lazy. There is no reason to ship the isolated
inline-only formulation as the final design.

## Reproduction and trust boundaries

`inputs.json` records capture-time checkout paths and HEADs. An evidence commit
necessarily advances this worktree afterward; a repeat must recreate the frozen
source checkouts (or create a fresh manifest pointing to those same source
commits). Do not weaken the exact HEAD/diff guard to run against newer code.
Copy `bin_phase.rs` byte-for-byte to each Canvas `tests/` directory. Build each
formulation in its own target directory with:

```
CARGO_BUILD_JOBS=2 CARGO_TARGET_DIR=<dedicated target> \
  cargo test --manifest-path reactivity/Cargo.toml -p gpui_canvas \
  --release --test bin_phase --no-run --message-format=json-render-diagnostics
```

Select the executable only from the matching Cargo JSON artifact and verify the
source feature set and actual callee before freezing a SHA-named copy. In a
coordinated quiet window, `run.py inputs.json <new directory> --rounds 3` captures
all five formulations; `summarize.py <directory>` preserves every row and derives
the medians. Both scripts use only Python's standard library. The immutable
original capture and manifest must not be rewritten for a repeat.

`rejected-shared-target.json` documents an artifact-provenance failure caught
before timing: Cargo reported the changed source as fresh in a shared target
and reused the inline executable. That attempt was rejected, not silently
recaptured as a timing loss. Dedicated source-specific target directories,
`fresh=false` Canvas/test artifact records, and callee differences establish the
three accepted new artifacts. No local Miri or new unsafe proof is involved;
all new production code is safe Rust and reuses the existing ordered lanes.
