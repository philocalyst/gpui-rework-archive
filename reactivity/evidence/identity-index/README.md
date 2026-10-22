# Exact retained identity index: range, packed entries, affine runs

This is an isolated implementation/control tranche, not a completed-framework or universal-speed claim.

- Baseline: `59467a4136`, same production as de18 plus reviewed evidence cleanup.
- Packed candidate: `8da013d5f81d2687d9fdc7321f91109713e1e6c1`.
- Separate affine-run candidate: `75544537f7596a7e0929306ab27b48f9942b7062`, on top of the packed candidate. Only `runtime/identity_index.rs` changes in this follow-up.

The audit found one initialization and one whole-description replacement of `Runtime.by_identity`; there are no incremental mutations. The old `BTreeMap<u64, usize>` becomes a private 24-byte index. A consecutive preorder identity range needs only `{first,len}`, with no allocation. Otherwise the first candidate retains a sorted boxed array of exact `(u64 identity,u32 local index)` entries, 12 bytes each using safe `repr(C,packed(4))`. Every packed field access copies by value; no unaligned reference or unsafe code is used. `get` returns a copied `usize`, and already-admitted internal users call `required`. No public API changes.

The second candidate counts maximal identity+1 runs. When `16 * run_count < 12 * node_count`, it retains only sorted 16-byte `{first_id, first_index, len}` records, without staging a per-node table. Sorted run intervals must be disjoint. Lookup finds the preceding run, subtracts its first identity and checks the displacement against its length; this avoids overflowing an exclusive end at `u64::MAX`. The displacement is added to the original preorder index only after membership succeeds. Byte-size ties and densely reordered identities retain packed entries. The extra classification pass and enum arm have real costs below.

Identities are still monotonically admitted, never reused, and qualified by the existing window namespace. The index stores only live logical membership; it does not create a capability table, second tree, semantic cache, or historical map. Prepared/acknowledged authority rules are unchanged. Other reconciliation maps and full presentation walks remain.

## Layout and allocation qualification

Actual baseline and Runs measurements: Runtime header 2320 bytes (`Runtime<()>`, headless), Node 40, Presented 80, TextSite 80. The old map and both replacement index headers are 24 bytes. No ordinary node, owner, element or presentation field is added. Optimized Linux x86-64, Apple AArch64 and Windows MSVC x86-64 type assertions confirm packed entry 12/alignment 4, run 16, aligned control entry 16, index headers 24. These are measured 64-bit targets; this report makes no 32-bit size claim.

Isolated exact-construction ledger, excluding the common 24-byte header and caller-owned input IDs:

| Live IDs | Old map requests / retained / peak bytes | Consecutive index | Gapped/reversed packed index |
|---:|---:|---:|---:|
| 1 | 2 / 192 / 208 | 0 / 0 / 0 | 0 / 0 / 0 |
| 60 | 8 / 1440 / 2400 | 0 / 0 / 0 | 1 / 720 / 720 |
| 4096 | 377 / 75168 / 140704 | 0 / 0 / 0 | 1 / 49152 / 49152 |
| 65536 | 5963 / 1192416 / 2240992 | 0 / 0 / 0 | 1 / 786432 / 786432 |

A retained root plus 65,537 freshly replaced children needs two runs: **one 32-byte allocation**, instead of one 786,456-byte entry allocation. Empty indices and singleton ranges allocate nothing. Exact-capacity/fallback requests are asserted by meaningful tests. Old-map transient construction is charged, not treated as free.

Actual public-owner allocation controls (65,536 children plus root):

| Mount metric | Baseline | Packed / Runs |
|---|---:|---:|
| requests | 17101 | 11138 |
| cumulative bytes | 179792105 | 176502505 |
| net retained bytes | 58263521 | 57071105 |
| measured peak bytes | 63225641 | 62033225 |

The owner still retains tens of megabytes in this deliberately eager 65K-node workload. Growth/acknowledgement peak is **44,564,704 bytes in every variant**; other scratch dominates. Runs removes 786,424 cumulative bytes versus Packed for that growth, but does not lower the whole-operation peak. Net growth allocation can be greater for the new index on tiny cases because it moves from a zero-heap range to a small table; absolute owner retained memory is still lower. All signed net values remain in the raw data. Allocation counters measure requested bytes, not RSS/PSS or allocator/server/GPU residency.

## Correctness and source gates

Packed: full headless suite 385 passing cases (including 23 compile-fail doctests), followed by all six final index tests including the added ledger. Strict headless all-target and accessible-X11 library Clippy pass. Runs: 367 selected lib/public tests, all eleven index tests in debug and release, strict headless all-target and accessible-X11 library Clippy pass. No public interface changes invalidate the earlier doctests.

The exact previous `BTreeMap` is an independent lookup oracle for gaps, permutations, near-`u64::MAX`, chunk movement, holes and misses. Tests assert replacement retirement, profitable-run selection, byte ties, even/odd and reverse fallback, and duplicate/overlapping internal identity admission rejection. Existing public list reorder/scroll, stale-target, component namespace, failed-preparation and recovery cases also pass.

The same public caller uses `Win::recording`, real model `update`, `presented`, `visit`, `property`, and inspector `set_property`. At 1/60/4096/65536 children, all three executables agree on complete CPU pixels, every presented local rectangle's digest, property checksums, stable target retention, retired child rejection after growth, and inspector targeting. Table controls additionally validate **every present identity's exact original index**, plus missing 0 and `u64::MAX`, before each lookup measurement; checksum equality is not the sole oracle.

There is no new native/GPU protocol in this change. Accessible-X11 compilation checks the changed conditional metadata lookup path. This evidence does not claim new OS runtime conformance or a new GPU optimization.

## Actual code generation

`asm/linked-sizes.json` and exact address/size disassembly come from the linked Linux public-owner executables, not standalone `.s` output. Display-only trailing whitespace and blank log terminators are removed; captured measurement stdout remains unchanged.

| Function | Baseline | Packed | Runs |
|---|---:|---:|---:|
| same public read-properties caller | 552 B | 552 B | 552 B |
| runtime resolve | 564 B | 482 B | 482 B |
| non-generic index get | embedded old map | 123 B | 283 B |
| identity construction | old map collect | 549 B | 1359 B |

`get` remains an out-of-line call through the linked interface in these candidates. The common contiguous arm is small, but the third arm grows the callee and changes branch placement. This is a concrete reason to inspect a separate targeted-inline candidate; annotations have not been silently applied to either frozen source.

`codegen/` separately records optimized source-level assembly for a control compiling these exact production modules, the old map, and aligned entries on Linux, Apple and MSVC. It confirms by-value packed loads (ordinary x86-64 loads and AArch64 `ldr`), twelve-byte address multiplication versus sixteen-byte addressing, and target layouts. It is an emitted-assembly control, **not linked desktop application or hardware timing evidence**. Its unused-method warnings are confined to this small control; production strict checks pass.

## Frozen timing protocol and limitations

`run.py`, `frozen.json`, `phase-one-frozen.json`, compiler-artifact records and executable/root-library hashes pin the source and consumers. Packed source/control artifacts were frozen before Runs was implemented. All three owner executables freshly build their own root library in separate targets; the identical caller bytes carry compile-time source/variant markers. Evidence-only descendants are permitted by the runner only when relevant source bits still equal the pinned source commit. No compiler is invoked during capture.

Nine owner processes use three rotated variants/three rounds. Four table processes rotate Packed12, Aligned16, Tree and Runs through all internal positions. Every process pins CPU 2. All 996 cost rows, all thirteen process results and pre/post guards pass, with **no retries, exclusions or discarded attempts**. Cross-round full oracles also agree. The 180-second whole-campaign deadline is failure containment; actual processes finish in about 0.465–1.117 seconds for owner and 0.766 seconds for table. See `capture/elapsed.json`.

Capture: 2026-10-22 03:02:20–31 UTC. No active Cargo/rustc/Clippy/linker processes in recorded snapshots. CPU some-pressure avg10 0.00→0.63. Background I/O some-pressure avg10 **34.96→26.49**, full **34.84→26.36**. This is a coordinated CPU window, not storage/system isolation. Hash guards warm executable files, so this is not cold-disk startup.

**Small-case sampling limitation:** this first caller uses sixteen lookup rounds. One-child phases therefore have only 32–48 property reads per process; 60-child phases have roughly 1K reads, versus roughly 1M at 65K. Their nanosecond percentages are short descriptive observations, not confident steady-state regression estimates. A subsequent separately pinned inline candidate and normalized identical caller must test the small-case dispatch hypothesis; these original rows remain unchanged.

## All gains and losses retained

Medians of three owner processes, ns/read or ms/whole operation:

| 65K owner case | Tree baseline | Packed | Runs |
|---|---:|---:|---:|
| fresh ordered read | 74.51 ns | 8.13 ns | 9.30 ns |
| fresh permuted read | 121.48 ns | 8.60 ns | 9.85 ns |
| post-growth ordered read | 73.85 ns | 61.68 ns | 12.87 ns |
| post-growth permuted read | 121.05 ns | 85.95 ns | 13.86 ns |
| mount | 118.55 ms | 116.33 ms | 115.20 ms |
| stable description/ack | 67.89 ms | 65.78 ms | 64.49 ms |
| growth/ack | 120.79 ms | 111.06 ms | 108.22 ms |

Runs adds about 13–16% (about 1–1.4 ns) to common 65K range reads versus Packed in this capture, while remaining roughly 88–92% faster than Tree. Tiny ordered first reads are 24.38→30.94 ns (+26.9%), and warm tiny ordered reads 10.31→11.56 ns (+12.1%); the short-budget caveat above applies. Whole 60-child growth is +3.2% and stable update +1.3% versus Tree. These losses are not removed from the summary.

Four-sample median 65K primitive construction:

| Shape | Tree | Packed | Runs | Runs vs Tree |
|---|---:|---:|---:|---:|
| contiguous | 1.211 ms | 0.043 ms | 0.041 ms | −96.6% |
| retained-root/new-child gap | 0.721 ms | 0.311 ms | 0.087 ms | −87.9% |
| four-item moved chunks | 1.979 ms | 1.596 ms | 0.429 ms | −78.3% |
| arbitrary permutation | 1.959 ms | 1.457 ms | 1.699 ms | −13.3% |
| even-then-odd | 0.880 ms | 1.458 ms | **1.791 ms** | **+103.6%** |
| ascending gaps | 0.741 ms | 0.086 ms | 0.347 ms | −53.2% |
| reverse | 0.760 ms | 0.131 ms | 0.374 ms | −50.8% |

Runs ascending-gap construction is +303% and reverse +186% against Packed, and permutation +16.6%; the additional classification work is charged. Even/odd construction is a real losing regime despite lower retained memory. Primitive fallback lookup beats Tree by about 35–41%, while Packed12 also beats the Aligned16 control at 65K in these cases; that does not establish performance on Apple/Windows hardware. Primitive loops can hoist immutable classification and are not a substitute for the public owner results.

`summary.json` retains every sample, nanoseconds per operation, min/median/max, all request/cumulative/net/peak allocation observations, and comparison percentages. `summary.csv` covers every case and variant. No adoption recommendation is made from representation size alone; retain these frozen candidates while evaluating the separate common-path dispatch refinement.

Reproduction after arranging the shared quiet window:

```sh
IDENTITY_INDEX_QUIET=approved python3 reactivity/evidence/identity-index/run.py \
  capture --output reactivity/evidence/identity-index/capture
python3 reactivity/evidence/identity-index/summarize.py
```

Fixtures are outside ordinary Cargo targets; benchmark example copies remain untracked and are excluded from source/evidence commits. Thus normal all-target checks need no marker variables. Full build records preserve the exact worktree/target paths, opt-level and source marker environment. Initial source-only codegen warnings and a corrected test using a non-ExactSize `Chain` are retained as qualification history, not hidden timed failures.
