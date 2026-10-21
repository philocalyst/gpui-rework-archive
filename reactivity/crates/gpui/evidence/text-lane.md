# Dense retained text lane

The final change moves visual text values, their binding and their current-width
layout cache out of every logical node into one exclusively owned text lane.
On this x86-64 target a logical node shrinks **216→136 bytes**. Text sites add one
80-byte lane entry, so dense all-text header payload remains 216 bytes/site.
Containers save 80 bytes each. The window adds one 24-byte Vec header; a nonempty
lane adds one allocation. Presented remains 88 bytes/node.

This is a retained-storage improvement, not a speed result. The complete window
still owns layout topology/caches, strings, glyph positions, font/raster caches,
commands, presentation sheets and optional CPU pixels. Their requested heap
allocations all remain in the measured totals.

## Ownership and invariants

`TextSite { value, field, shaped }` is stored in a dense
`Vec<Option<TextSite>>`; every live slot is Some outside reconciliation. Ordinary
mutable borrows move each complete site with a surviving identity. Unchanged
text and glyph buffers retain their allocations. Removed sites drop their
buffers; the replacement lane has exact text-count capacity, with no visited-site
history or holes. The preceding presented sheet keeps its ordinary immutable
text leases independently of the logical lane.

`Content(u32)` encodes the six closed node kinds in three bits and text-index+1
in the remaining bits; zero means no text. Both encoding and decoding use safe
explicit matches, and MAX_NODES is checked against the packed domain at compile
time. Index construction also checks admission in release builds. There is no
transmute, unsafe code, shared mutable owner, per-node cache Box/Arc, extra
mutable topology or map lookup added to a shape read. The existing layout-ID
measurement lookup is unchanged.

Width keys retain the original clamped float-bit behavior and one-width cache.
Text edits and font-size changes clear the cache; failed shape replacement does
not install a partial layout. Structural remounts get new sites. Presentation
panic cleanup drops the font service and clears every lane cache. Source edits,
inspector overrides, logical semantic-name fallback and sorted visual/name/
description fanout all use the same lane; metadata remains cold. Parent/finite
transform packing, conjunctive queries and metadata publication guards survive
integration unchanged.

## Measured comparison

The definitive pair is main 0c3dd8b3e1 versus cb3ce8db8d, including the same cold
metadata implementation and packed FieldId in both. The fixture is byte-identical
in both binaries, at SHA-256 4d2078701d980a4e425b844366ce494cdeada11fa8770f568688643c71a3351f.
[Machine provenance](text-lane.json) pins exact source/binary hashes and checks.
[Raw ordinary turns](text-lane.csv) contain 1,080 rows; [held candidates](text-lane-pending.csv)
contain 160 rows. Every operation succeeds or fails as asserted, and every final
drop balances exactly after charging the initial source string.

Five alternating fresh-process repetitions per variant and fixture ran pinned
to CPU 0 on a Ryzen 7 3700X, Rust 1.97.1, Cargo default release. A separate owner
warms code/allocator pages and checks roles, nonempty commands and actual text
pixels; timed owners have fresh caches. Other machine activity is not excluded.
These are requested allocation bytes and wall-clock fixture times, not RSS,
allocator usable sizes, native startup, presentation/scanout or device memory.

`total_retained` is the allocation-counter delta after the operation. The initial
16-byte model String was allocated before measurement: add 16 to obtain the full
owner+framework requested-byte total at every stage. After direct replacement,
its free and the new source allocation are included in subsequent deltas. Final
`drop` is therefore -16, and adding the initial 16 gives zero. Source/model headers
inside Runtime are included. No font, mask, layout, command, candidate or shape
scratch allocation is excluded.

Recording mount medians, after acknowledging the complete candidate:

| Nodes/text sites | Inline retained B | Compact retained B | Mount peak B | Mount ms |
| ---: | ---: | ---: | ---: | ---: |
| 1/0 | 6,292 | 6,236 | 6,732 → 6,676 | 0.006 → 0.006 |
| 2/1 | 15,642 | 15,586 | 251,685 → 251,629 | 0.206 → 0.210 |
| 33/32 | 70,674 | 70,618 | 312,282 → 312,226 | 2.320 → 2.752 |
| 4,097/0 | 2,612,428 | 2,284,692 | 3,030,068 → 2,918,840 | 3.592 → 3.674 |
| 4,097/256 | 2,850,506 | 2,543,250 | 3,503,570 → 3,196,314 | 20.431 → 20.361 |
| 4,097/4,096 | 6,317,458 | 6,317,402 | 6,972,922 → 6,972,866 | 260.967 → 264.081 |

At 4,097 nodes, controls save 327,736 B (12.5% of the whole retained window); sparse
256-text trees save 307,256 B (10.8%). Dense 4096-text trees save 56 B, entirely the
root-container saving minus the added window header. Both trees still retain
one owned layout/glyph vector per visual text site, even when strings are shared.
Direct fanout tests prove one source read and one promoted text allocation per
changed source; they do not claim shared shaping across text sites.

CPU mode includes optional image allocation and an actual pixel render inside
each measured operation; recording mode never calls a CPU diagnostic while timed:

| Text sites /4,097 nodes | Inline→compact retained B | Inline→compact mount ms |
| ---: | ---: | ---: |
| 0 | 2,620,316 → 2,292,580 | 3.640 → 3.792 |
| 256 | 2,858,490 → 2,551,234 | 20.182 → 20.364 |
| 4,096 | 6,326,274 → 6,326,218 | 263.497 → 264.837 |

The final recording medians lose about 2.3% for controls and 1.2% for dense text;
sparse text is 0.34% faster in these samples. CPU medians lose about 4.2%,0.90%
and 0.51% for controls, sparse and dense text, respectively.
The samples do not support a speed improvement. Tiny-window timing is especially
variable and is retained in raw data. All text-bearing mounts/descriptions add
one lane allocation; controls add none. The one-width shaping behavior and the
large shaping allocation counts are unchanged.

## Pending sheets and migration scratch

The hold-ack mode uses the exact public token path. After resize it verifies
queries still read the acknowledged geometry, while the latest token names the
new candidate. Only `presented(token)` publishes that geometry. The table charges
logical nodes/text, the old P, the pending candidate and all other live storage:

| Text sites /4,097 nodes | Inline pending retained B | Compact pending retained B | Compact prepare delta B | Ack delta B /allocations |
| ---: | ---: | ---: | ---: | ---: |
| 0 | 2,972,964 | 2,645,228 | 360,536 | -360,536 / 0 |
| 256 | 3,211,338 | 2,904,082 | 360,832 | -360,536 / 0 |
| 2,048 | 4,831,242 | 4,667,346 | 362,992 | -360,536 / 0 |
| 4,096 | 6,682,242 | 6,682,186 | 364,784 | -360,536 / 0 |

Acknowledgement releases exactly 4,097 × 88 = 360,536 B of the old presented-vector
allocation and allocates nothing. The preparation delta includes that vector
plus any newly admitted canvas/cache storage. These candidates are retained
explicitly, rather than hidden inside a post-ack total.

Ordinary turns acknowledge inside the measured operation. Their `peak_new_bytes`
charges simultaneous old/new text lanes, old P/candidate, replacement canvas and
layout/shape scratch. The complete cohort peak is the preceding total_retained
plus peak_new_bytes(plus the initial 16-byte source). Equal descriptions retain
existing glyph buffers but temporarily own both 80-byte lane headers per text
site. The raw data retains that allocation and its peak.

Dense restoration after a text-free sheet adds327,680 B of new 80 × 4,096 text-lane
storage to incremental scratch compared with inline storage. The old lane is
empty in that case: this is new required retained storage, not duplicate cache
migration. The compact logical tree offsets that amount in the complete cohort.
An in-place permutation would require ownership remapping and careful growth/
shrink handling; it cannot remove this empty-old-lane cost. Earlier description
scratch already dominates the measured equal-description peak. No more complex
arena was admitted without a measured whole-cohort benefit.

## Rejected representations and code footprint

[Design captures](text-lane-design.csv) preserve five-repetition comparisons
before metadata integration: original inline 224, packed-inline 216, a144-byte
node plus88-byte TextSite, and a144-byte node plus80-byte TextSite. The latter
loses 8 B/text against packed-inline 216; at 4096 texts it retains32,720 B more.
That losing opportunity cost led to Content packing rather than being hidden
by comparison with the older224-byte baseline.

A [cache-only alternative](text-lane-cache-only.csv), isolated source c0c1a6282e,
measures Node 168 + cache 56: 224 B/text and one lane allocation. Combined Node 144 +
TextSite 80 has the same all-text cost while saving another 24 B/container; final
Content 136 removes the remaining 8-byte all-text loss. The alternatives are
retained in evidence, without integrating their dead code. The initial
[exploratory capture](text-lane-exploratory.csv) ran during compilation; its
noisy timings are retained but are not the definitive comparison.

The final fixture executable's .text section is 2,603,799→2,608,103 B (+4,304 B,
0.16%). This is linked fixture code, not an instruction-count measurement.
The [assembly excerpts](text-lane-assembly.txt) show 216-byte baseline versus
136-byte final node strides, local AND7+range-check kind decoding, and SHR3/DEC
followed by 80-byte text-lane indexing. No outlined kind/text-slot getter remains.

Assembly initially found a 41-byte Node::kind getter through the crate GOT.
Explicit inline getters remove that call and add 800 B of .text versus source 602f.
A complete helper audit also found TextSlot::get/get_mut (75 B each) and
Content::new (62 B) newly outlined. Their inline bodies remove those calls for
another 48 B of .text. TextSlot::take was already inlined. TextSite::shape remains
outlined at 280 B, compared with the baseline Node::shape at 311 B; large shaping
logic was not force-inlined. The [getter-only ordinary](text-lane-getters.csv)
and [getter-only hold-ack](text-lane-pending-getters.csv) captures preserve the
intermediate 75f76 result. [Outlined ordinary](text-lane-outline.csv) and [outlined hold-ack](text-lane-pending-outline.csv)
captures preserve that alternative too. Removing a call is not reported as a
measured frame-time win; instruction-cache misses and hardware retired
instructions were not measured.

## Verification boundary

Exact source cb3ce8db8d passes 193 gpui cases/doctests, strict x11+wayland
all-target Clippy, formatting, and the release fixture. New tests exhaust every
kind×admitted index and reject the first unadmitted index; inspect dense slot
uniqueness/exact capacity and unchanged glyph allocation; exercise repeated
sources at distinct widths, action remounts, resize, font override/inherit and
failed shaping against fresh fixed-description pixels and public counters.
Existing library/ports/lists/metadata/publication/focus/recovery tests all pass.

Native CPU/GPU runtime execution is left to the parent integration gates.
This slice does not claim a complete GPUI replacement, Hummingbird port, audio
stack or finished native accessibility integration.
