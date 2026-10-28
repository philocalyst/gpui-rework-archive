# Independent B: spatial traversal, unchanged records

Bounded correctness passed; timing and adoption remain open. This branch starts
at bb21d11455b6a03d134f99377c5a16b983fac27f and contains no A hot encoding.
Preregistration f0dcdc8884f2824ebd8468f47050b79a0bd20e46; CPU gate
f5eab1717bfb6787ad7c60e048cab5095fb12b50; actual GPU/source gate
2a83616d8acf3537cf8d572cbb3fac83960fdedf. All changes are local laboratory code;
zero shipping-library changes and no ZGX inference.

The independent interpreter verifies 368 simulated submissions, 303 exact actual
GPU frames, 82 CPU checks and five actual GPU mutants. Shader bytes match the
executed preserved ELF; source guards are empty; strict Clippy passes. Replay:
`PYTHONDONTWRITEBYTECODE=1 python3 reactivity/evidence/display-traversal/verify.py`.
The machine is software Vulkan llvmpipe, with four driver threads. This is not
physical GPU evidence or scanout measurement.

## Mechanism and decisive trace

A 256-byte immutable root points to 64 ordered tile lists of conservative chunk
contributors. The original compressed/raw twelve-u32 record encoding, node COW
directory and painter predicates remain unchanged. A frame leases its spatial
root together with node/resource versions. Paint changes do no index maintenance;
geometry changes update affected page masks and tile lists. Tiny scenes bypass
indexing. Structural edits deliberately rebuild order/ranks and bounds globally.

Ordinary Source paint resolves one admitted cached identity/property binding;
the public fixture reports one source read, zero owner/layout/description/paint
passes and no new snapshot or draw enumeration. The restricted adapter performs
one identity lookup, five field loads, decodes 32 rows, records two old/new damage
supports, rewrites one compressed page and copies a 256-byte directory leaf plus
128-byte directory root and 64-byte frame descriptor. The first 1,024-node paint
writes 488 payload bytes and 936 total heap bytes, plus parameters and authority.
It increments 37 heap references (bounded directory fanout plus spatial lease).
There is no resource-table search or spatial list copy on this paint path.

Staged queue writes precede submitted work; completion fences and authoritative
sequence/namespace determine presentation and reclamation. Deferred oldest work
still audits its own immutable metadata but cannot overwrite newer pixels.
Reverse completion notifications, failed newer public edits and old/new integer
translation damage match fresh full-Window rendering. Translation legitimately
runs one public paint pass. This is an admitted integer rectangular subset, not
a generic production dependency journal, arbitrary clip/effect implementation,
coherent CPU/GPU shared memory or constant total update work.

## Actual GPU record visits

| Scene | Nodes | B visits | Original full traversal |
| --- | ---: | ---: | ---: |
| Sparse fixed edit | 256 | 32,768 | 131,072 |
| Sparse fixed edit | 1,024 | 32,768 | 524,288 |
| Original overlap | 256 | 69,632 | 131,072 |
| Original overlap | 1,024 | 217,088 | 524,288 |
| Visible staircase | 256 | 221,184 | 1,048,576 |
| Visible staircase | 1,024 | 542,720 | 4,194,304 |

The staircase has a visible pixel for every sibling. Its edit damages 64×64;
other families damage 32×16. Do not compare timings across families. The inherited
ledger field `gpu_pixel_record_visits` is the full-scan reference estimate;
`expected_gpu_record_visits` and actual per-pixel `visits-*.u32` are B counts.
Stale suppressed commands have zero render visits, while audits still execute.

## Storage and update counterexamples

At 1,024 sparse records the current index adds 256 root bytes and 1,288 list
payload bytes. CPU wire metadata adds 1,032 membership bytes, 256 mask bytes,
128 order bytes and 256 rank key/value bytes. Heap allocation fragmentation,
Python graph sizes, scratch and every retained version are separately recorded
per frame in raw ledgers; these wire categories are not total memory. The first
paint has 14,560-byte traced CPU peak and 215,538 reachable Python bytes, including
store/publication/index graph. Construction examines all 1,024 bounds.

The first public translation examines 32 bounds rows/128 fields, copies 114
encoded words, tests 194 row/tile intersections, copies 24 membership entries,
examines 16 deletion entries and eight order comparisons, and writes 160 list
bytes plus the 256-byte root. Thus localized maintenance has real CPU work.
The 97-node move visits 194 extent records, examines 2,231 identity entries,
relocates 82 rows and rewrites 4,776 record bytes. B additionally rebuilds six
page ranks, examines all 99 live bounds and 228 row/tile intersections, rebuilds
106 memberships and writes 392 list bytes plus 256 root bytes. Total heap staging
is 5,872 bytes before parameters/authority. Direct start lookup does not make
structural extent enumeration or index rebuild constant.

| Actual mutant | Audit wrong bytes | Pixel wrong bytes |
| --- | ---: | ---: |
| Omit contributing staircase page | 0 | 162 |
| Reverse painter page order | 0 | 1,488 |
| Stale index with new nodes | 32 | 1,024 |
| Omit old support | 0 | 1,536 |
| Premature index lease reclamation | 76 | 0 |

The last mutant is a lifetime failure despite correct final pixels. Image/glyph
resource leases and byte/pixel audits are carried through a separate unchanged
full-traversal resource control; this does not establish indexed text/image
integration. Glyph bytes are audited, not glyph-rendered.

## Requirement matrix and next decision

| Requirement | Status |
| --- | --- |
| Compressed addressable chunks, stable identity, bounded COW directories | Implemented in executable model |
| Damage to GPU decoding and exact final pixels | Implemented for admitted fixtures |
| Unrelated subtrees do not increase fixed-edit visits | Implemented; 256/1,024 sparse gate passes |
| Ordinary public Source to model delta | Restricted cached-binding adapter only |
| Geometry/structural index maintenance, old/new support | Implemented and charged; structural rebuild O(N) |
| Overlapping submissions and spatial lifetime | Implemented bounded positive/negative gates |
| Indexed text/images, general effects and generic production journal | Still missing |
| Coherent shared memory, native/physical GPU/ZGX advantage | Still missing |
| Complete-endpoint cost admission | Pending prospectively frozen comparison |

Next compare complete B with original compressed traversal and raw serial using
PROTOCOL.md's explicit median-of-six paired p95 aggregation for every gain and
regression clause. Preserve A uncombined. A's median target gains were observed,
but admission remains withheld because its regression aggregation was unspecified
and the conservative interpretation failed; noisy individual pairs do not prove
a reproducible causal regression. Its raw serial alternative beat compressed A
at every measured 32/256/1,024 case. B must confront that simpler alternative.
