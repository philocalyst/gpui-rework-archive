# Counted style batches and literal construction controls

The isolated batch implementation removes the measured broad-cohort slowdown of
the counted-palette prototype. It is **not integrated**: these tests precede the
new Canvas paint-patch coupling, which must be merged without losing either
transactional admission or the shared-class transform. The separate literal
controls identify a substantial regression already present in compact reactive
style construction; the batch patch does not cause or repair that regression.

## Frozen sources and scope

| Variant | Source |
| --- | --- |
| Pre-port literal baseline | `f01947e679d9dd2ca7ef149b70dccff92dad67dc` |
| Compact reactive styles | `b6f71b4a3a0940f0159fcd1769f5006708d743cd` |
| Counted palette | `642aa715ecd0428420f7cb77fa9752d2418ef301` (cherry-pick of `19345abf5a`) |
| Batched counted palette | `1ff60868df690a566406637e0f936943a587143a` |

The batch source changes four files, 553 insertions/5 deletions, including unit
and public tests. It builds a bounded 32-entry `Coverage` array from a cloneable
iterator over the source's existing packed destinations. Fully covered classes
with one effective property mask transform once; partial users retain the counted
split path. No per-user edit vector, source graph, owner scan, new node field, or
unrelated-style read is needed for sparse updates. Inspector-masked fields advance
their sparse lower base but do not change effective styles.

Only completed full classes may be freed by coalescence; an unselected partial
class may be an equal merge target but is never repointed or freed. Only covered
users' selectors are rewritten. The common homogeneous case keeps its selector
allocation and bytes unchanged. Dead resident slots remain reusable, so this is
not a strict unique-live-value storage bound. A rare turn can conservatively fall
back to Dense at 32 resident slots before final coalescence, even if its eventual
unique-value count could fit. No append-only unbounded history is retained.

## Method and provenance

The same fixture bytes were installed in independent source worktrees and built
into distinct release target directories. Every root artifact was freshly
compiled (`fresh:false`) with its expected package path and source marker.
`frozen.json` records source, lockfile, caller, build-JSON and executable SHA-256
values. Capture checks them before/after every process, including the root
artifact producer rather than trusting Cargo Fresh output. Phase targets reused
dependency caches through separate copy-on-write directories; their root test
executables were rebuilt. Literal targets were built independently.

Captures ran built executables directly, pinned to CPU 2. All peers confirmed no
compiler, tests, native launches, or timed work. Six literal processes alternate
pair order over three repetitions; nine phase processes rotate three variants
over three repetitions. All correctness/provenance guards passed; no run was
excluded or repeated. Driver process elapsed times and complete stdout are in
`logs/` and `captures/`. Hash checks warm executable files: “first process mount”
is not a cold-disk startup measurement. Three samples/cell support descriptive
medians/min/max only, not p95/p99 or a general application latency claim.

CPU/I/O/memory pressure and process-name snapshots were captured before/after
each campaign. CPU some avg10 rose 0→1.78 during literal and 0.19→1.28 during
phase; I/O some avg10 was 1.12→0.41 and 1.56→0.30 respectively. Memory pressure
remained zero. These are shared-host observations, not a claim of an isolated
machine. No compiler processes were present in either boundary snapshot.

The phase separates private `Runtime::patch` attribution (typed source mutation,
without publishing source/presentation epochs) from complete public
`Win::set → prepare → acknowledge`. Each case verifies exact complete Style
digests, source/destination counters and headers across variants; independent
fresh CPU images also match. The semantic/pixel checks run outside their reported
phase timing. Warm reads report one full traversal, averaged over 16 traversals.
Mount retains its final owner during allocation measurement.

## Literal results: f019 → compact reactive styles

All builders allocate zero times. Median ns/operation:

| Same external caller | f019 | Compact | Change |
| --- | ---: | ---: | ---: |
| Width builder | 29.0 | 53.7 | +84.9% |
| Full literal fields builder | 41.2 | 443.6 | +977.3% |
| Literal Flex recipe builder | 48.5 | 460.7 | +849.7% |
| First process 139-node recording mount | 306,976 | 392,998 | +28.0% |
| Warm fields, 1 node | 3,931 | 4,700 | +19.6% |
| Warm fields, 60 nodes | 52,694 | 77,511 | +47.1% |
| Warm fields, 139 nodes | 117,302 | 174,902 | +49.1% |
| Warm fields, 4,096 nodes | 4,895,176 | 6,666,543 | +36.2% |
| Warm recipe, 1 node | 3,948 | 4,605 | +16.7% |
| Warm recipe, 60 nodes | 53,601 | 78,764 | +46.9% |
| Warm recipe, 139 nodes | 118,412 | 178,045 | +50.4% |
| Warm recipe, 4,096 nodes | 3,406,761 | 5,170,247 | +51.8% |

The aggregate child runtime is 0.064s f019 / 0.264s compact per process, but the
attributed cells above are the useful comparison. The literal caller only uses
APIs available in f019, including align/justify/wrap through Flex. Pixel guards
prove direct and recipe output equal at 1/60/139 nodes; this is a recording-owner
setup control, not native, AT, GPU or first-visible-frame timing.

Actual linked address-bounded disassembly is in `codegen/`. Width caller text is
365→300 B, but the compact caller now invokes a 947 B `property_operand<f64>`
callee with signal binding, optional unbind, geometry/error branches that cannot
occur for that literal type. Caller local stack rises 208→320 B, plus the callee's
128 B local stack and saved registers. Full-field caller text is 616→717 B and
calls five numeric operand helpers, two 955 B Color operand helpers, transform
handling and Flex apply. Recipe caller remains 674 B but also pays the helpers.
This is a concrete type-erasure boundary to fix separately; caller size alone
would conceal the regression. No whole-binary size difference is attributed to
one function. A separate sealed typed literal-dispatch prototype is warranted,
not blanket forced inlining of the large erased helper.

## Batch results at 65,536 children

Each owner has 65,537 style users including the root. Values below are median
ms/operation; four-turn phases are divided by four. All original rows and
all-cell comparisons/losses remain in CSV, including 60/139/4,096 sizes.

| Phase/case | Compact | Counted | Batch | Batch vs compact |
| --- | ---: | ---: | ---: | ---: |
| First all BG/FG patch | 12.690 | 13.995 | 7.245 | −42.9% |
| Warm all BG/FG patch | 10.307 | 13.626 | 7.136 | −30.8% |
| First all public acknowledgement | 22.354 | 26.142 | 17.600 | −21.3% |
| Warm all public acknowledgement | 23.223 | 25.315 | 18.322 | −21.1% |
| First partial patch | 5.530 | 7.052 | 6.450 | **+16.6%** |
| Warm partial patch | 5.182 | 7.424 | 4.397 | −15.1% |
| Warm partial public acknowledgement | 17.287 | 18.921 | 15.401 | −10.9% |
| First masked patch | 10.702 | 14.015 | 8.823 | −17.6% |
| Warm masked public acknowledgement | 22.432 | 25.432 | 19.009 | −15.3% |
| Warm converging public acknowledgement | 17.107 | 17.059 | 15.803 | −7.6% |
| Warm Dense/diverse public acknowledgement | 22.440 | 22.152 | 21.218 | −5.4% |
| First sparse single-user patch | 0.351 | 0.00548 | 0.00644 | −98.2% |
| Warm sparse single-user patch | 0.000265 | 0.000365 | 0.000433 | **+63.2%** |
| Warm sparse public acknowledgement | 11.522 | 11.063 | 10.425 | −9.5% |

Losses are material: first partial patch is +39.8% at 60 users and +29.3% at
139; warm converging patch is +39.9% at 60; warm sparse patch is +52.9–91.7%
against compact across all sizes (roughly 0.1–0.2µs absolute). Mount timings remain
roughly within ±1.3% at 65K. See `phase-latency-losses.csv` for every positive
median comparison, not just these examples.

Shared warm-read traversal is about equal to compact, but 23–27% slower than the
counted binary at 4K/65K. The counted and batch `read_probe` are each 4096 B, with
**identical normalized successful instruction paths through the first return**
(1,047 disassembly lines); differences are cold diagnostic addresses and linked
placement/alignment. No extra accessor instruction was found. The timing delta
remains unattributed; this audit does not turn it into an accessor speed claim.
Dense reads at 65K are +4.25% vs compact, +0.24% vs counted. Full disassembly and
the success-path comparison hash are retained.

## Allocation and storage ledger

Ordinary headers are unchanged: Style 88 B, Styles 40 B, Runtime<()> 2384 B,
Source fanout 32 B and packed Destination 4 B. The fixture's `Runtime<Theme>` is
2416 B in all variants. Counted/batch pattern entries are 92 B (88 B Style + u32
users), at most 128 B extra for 32 resident entries over compact entries. Default
owners allocate no style lane. Stack Coverage is 256 B, scoped to a transform;
there is no retained edit vector or global registry.

At 65K children, retained style payload after relevant phases:

| Case/phase | Compact | Counted | Batch |
| --- | ---: | ---: | ---: |
| First all patch | 5,767,256 B Dense | 67,193 B Shared | 66,365 B Shared |
| First sparse patch | 5,767,256 B Dense | 66,457 B Shared | 66,457 B Shared |
| First partial patch | 5,767,256 B Dense | 67,193 B Shared | 67,101 B Shared |
| First masked patch | 5,767,256 B Dense | 67,285 B Shared | 66,549 B Shared |
| After four converging patches | 5,767,256 B Dense | 5,767,256 B Dense | 67,837 B Shared |
| Diverse/Dense | 5,767,256 B | 5,767,256 B | 5,767,256 B |

Batch all first/repeated patches request **zero allocations**, preserving the
existing palette and selector allocations. Counted all first patch requests nine
allocations, 11,592 cumulative bytes. Batch sparse first patch has one 920 B
request (92 B net), then none. Batch first partial patch has eight requests,
9,936 cumulative/736 net/2,208 peak-net B; repeated partial patches have none.
Masked first batch is two requests/1,932 cumulative/184 net/1,104 peak-net B.
Converging four turns still request eight allocations/15,824 cumulative/736
net/2,944 peak-net B, reaching 25 resident slots (only nine live final values).
This does not claim that every convergence is allocation-free.

`allocation_counter.bytes_current` is allocation-minus-free **net within the
measurement**, and can be negative because an old lane allocated before the
measurement is freed during it. `bytes_max` is peak net, not total owner resident
memory or RSS. `after` retained style bytes are the authoritative lane ledger;
the separate cumulative/request metrics show construction churn. Every allocation
metric and positive regression is retained in the summary/allocation-loss CSVs.
Whole public prepare/ack still allocates; zero-allocation claims above refer only
to the specified private patches or builders, not the whole UI turn.

## Correctness gates and follow-up

`cargo test -p gpui` on the isolated implementation passed 374 tests across 40
summaries (8 ignored explicit native/manual controls), including 23 compile-fail
doc tests. Strict headless all-target Clippy passed; the pinned Parley dependency
still reports its pre-existing deprecated ICU warning. Focused lane tests and
public style-port/cohort tests passed. Cases cover 100 convergence cycles,
unselected/masked peers, selected partial arrival, same-node BG/FG, mixed masks,
Dense fallback vs independent arrays, no-op counters and inspector Inherit.
The release phase guards additionally assert complete pixel/digest equality at
65K in every process. No new batch-native or GPU timing claim is made.

The first codegen audit attempt used a raw symbol with demangling and generated
empty objdump sections. It was detected and replaced by actual nm address/size
bounded disassembly before capture; all retained `.asm` files contain code.
There were no stale-linked captures or excluded latency rows.

Commands used after coordinated approval:

```sh
STYLE_CONTROLS_QUIET=approved python3 reactivity/evidence/style-batch/run_controls.py literal --rounds 3 --deadline 60 --output reactivity/evidence/style-batch/captures/literal-first
STYLE_CONTROLS_QUIET=approved python3 reactivity/evidence/style-batch/run_controls.py phase --rounds 3 --deadline 180 --output reactivity/evidence/style-batch/captures/phase-first
python3 reactivity/evidence/style-batch/analyze.py
```

The capture runner deliberately pins implementation HEAD, not this later evidence
commit. Reproduction uses the source pins above plus the identical fixture and
one test-only style-ledger hook in this evidence commit. `run_controls.py guard`
is expected to reject a different HEAD; do not weaken that guard to rerun from an
arbitrary newer source. `build/*.jsonl` preserves the original artifact provenance
and `logs/` the qualification outputs. No performance rerun is justified without a
new implementation or a concrete invalidity in these rows.
