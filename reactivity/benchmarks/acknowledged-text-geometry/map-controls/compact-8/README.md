# Compact canonical maps: final control and qualified tradeoffs

Final shipping source79199bda9153d577d0252fbb746296fe18da2e84, complete test/header
pin d77d3b92822797857059ff6073e6c4e3ef2f7909, is frozen independently of all earlier
controls. This branch contains the reviewed immutable Arc/acknowledged-geometry
foundation A, safe usize Part control B, consuming-break work cut, and this map
formulation. Main was not edited. The parent-owned intrinsic Min/Max suppression
control is not incorporated or credited. No owner-local arena is implemented.

The canonical common record is exactly byte:u32+x:f32 (8 B), with no quantization
or narrowed source/line admission. A whole map remains general12B byte/x/mask if
any complete producer group is not [mask3] or [mask1,mask2]. Group2 order remains
upstream/downstream; singleton3 retains upstream geometry bits. The Box enum
keeps the existing24B optional map-owner slot and80B Details allocation. A private
24B borrowed view shares the query implementation across both representations.
Its transient tag/index checks are charged in the measured query costs below.

A32B optional stack builder emits8B records immediately. It promotes the complete
prefix to12B only at the first exceptional group, then remains general. The
producer supplies one complete increasing byte group per ICU grapheme boundary;
paragraph separators keep consecutive paragraph source ranges strictly separate.
This uses the existing producer Rect validation/equality merging and source order,
not a different shaping/segmentation algorithm or per-character rectangle tree.
Freezing only trims the selected representation. No census/conversion pass occurs
on the common production path. General promotion still copies the prior common
prefix and may grow Vec capacity; rare-path allocation performance is not claimed
free. Unit tests cover late exclusive1/2 promotion and subsequent groups, unusual
masks, signed zero, large x and fullu32 offsets; actual producer oracles cover real
Unicode shaping. There is no extra retained flag/index or new caller-facing API.

Geometry comes from the existing source-owned Line top/height. Width preserves
the producer f32 addition before f64 subtraction. Public caret_line and validation
borrow checked stop membership without reconstructing unused rectangles; motion
uses its already validated position. Intervals reuse their known downstream line
unless a preceding content-end equality requires the canonical upstream alias.
Byte0 coercion and soft-wrap/empty-line signed-zero bits are preserved. Ownership
is never inferred from caret y. The direct Parley oracle now independently checks
interval top/height bits as well as caret rectangles/line indices for zero/small
line height, wraps, consecutive/trailing CRLF/U+2028 and mixed bidi. No cached
per-stop line number is needed.

Measured64bit headers stay Layout56, Details80, Node40, Presented80, TextSite80,
Part16, Prepared40, Metadata264, Handler16 and El176. Runtime is1824 default or
1840 with verify-cache. Cold TextResources120/Entry24 and Cohort/Input carriers
are unchanged. The frozen owner is24B, borrowed view24B, CommonStop8B, General
Stop12B, builder32B and Option<builder>32B. Thus builder representation grows8B
of temporary scratch versus Option<Vec<Stop>>24B; no node/presentation/header tax
is added. These measurements are not a public ABI promise.

| First-C owner, default features | Allocations | Requested B | Peak extra B | Retained B |
|---|---:|---:|---:|---:|
| A24B growable / original batch snapshots | 33,912 | 26,284,982 | 15,569,616 | 2,262,476 |
| Consuming-break24B growable | 399 | 26,217,956 | 15,569,616 | 2,262,476 |
| 24B trimmed | 400 | 27,022,268 | 15,569,616 | 1,493,924 |
| 12B trimmed | 400 | 23,474,480 | 13,603,536 | 1,091,768 |
| 8B from12B conversion (losing construction) | 401 | 23,864,716 | 13,341,392 | 957,716 |
| 8B direct producer builder | 400 | 22,291,884 | 12,948,176 | 957,716 |

The first8B construction did not receive std in-place reuse for12→8 element
sizes. Its intrinsic65,536-stop map needed a fresh524,288B destination, costing
an additional allocation. The direct builder removes that conversion/census
work. These source-pinned losing controls are retained. The final full-feature
campaign adds exactly16 requested/retained/peak bytes to first-C from its runtime
layout:400/22,291,900/12,948,192/957,732. Do not mix feature-qualified ledgers.
Capacity/12B results were also rerun under explicit empty rustflags matching the
producer and direct8B controls; every numerical field reproduced exactly.

Scoped32KiB ASCII has32,768 glyphs/524,288B glyph capacity,745 lines/runs and33,513
stops. Geometry capacity goes1,622,016B (24grow)→853,464 (24trim)→451,308 (12trim)
→317,256 (8direct). Scoped retained goes2,146,440→1,377,888→975,732→841,680B. The
8direct scope requests6,225,728B and peaks5,428,548B versus A8,054,712/7,001,412B.
It remains260 allocation events versus growable batch24B259 because freezing can
reallocate; shrinking is not called free. Empty/short/bidi/long-grapheme raw rows
are included. General fallback retains12B rather than splitting a grapheme.

Final old-P/new-C adds347,784 retained bytes; old-P/old-C/failed-L adds349,488;
old-C ACK allocates zero and releases350,472B. L/T/C/P remain separate immutable
lifetimes. Glyph/font paint leases are not retained by geometry. Pending or failed
new layout cannot lend coordinates to old P; late provider activation uses the
acknowledged map. The arena alternative remains parked pending these measured
costs, not claimed implemented or zero-overhead.

The full-feature plain owner remains21alloc/5,588B and warm inspector idle0alloc.
The actual28-node inspector is356alloc/75,494B versus A356/82,694B:7,200 retained
bytes removed, no allocation-event increase. Native765-node/763-run/32,768-unit
projection remains6,885alloc/906,623requested/733,455retained; consumer construction
3,860alloc/1,425,711requested/809,407retained consumes that update. Do not add those
retentions as independent live copies. Repeated Consumer character-length full
validation remains unchanged and is not described as constant-time conversion.

## Query costs are explicit

All query phases use the unchanged ordinary selection_queries example, identical
locks/toolchain/defaultsimd/release flags, distinct targets and frozen binaries.
Every process has source/binary/flags guards; per-pair output signatures match.
Shaping and first-query warmup are outside the timed loop. Seven alternating
pairs are measured on CPU0 for15B/4line and27,000B/5,401line documents. All losing
140/210/210record phases and complete selected map/driver bodies are retained.
No builds/tests overlap the timing windows. Root was unavailable with a recorded
model-capacity error; all other agents were completed and a process audit found
no CPU build/test job before each brief START/END window.

| Long document query, median ns | 24trim | 12B known-line reuse | 8B fused |
|---|---:|---:|---:|
| Hit first | 72.5 | 78.7 | 107.2 |
| Hit last | 121.9 | 137.3 | 137.0 |
| Previous visual | 267.3 | 298.1 | 337.7 |
| Local selection | 158.9 | 163.9 | 170.3 |
| Whole selection | 969,589 | 1,015,995 | 1,061,039 |

8B long local/whole costs are+7.2%/+9.4%; first-hit+48%, motion+26%. Short8B
queries are26–72% slower (absolute10–47ns); this loss is real. The smaller-source
12B alternative costs+3.1%/+4.8% for long local/whole. Initial12B repeated unused
geometry reconstruction had+59%/+34% and is preserved as an immutable control.
This is a retention/constructor improvement, not a blanket query speedup claim.

Linked.text is1,174,408B (24trim),1,174,776 (+368,12reuse),1,181,976 (+7,568,8fused).
Complete selected map/driver body sums are7,519/7,997/12,582B. These include the
constructor/decoder/helper bodies, not only unchanged tiny driver wrappers; moved
work is not presented as code elimination. Assembly/metadata/raw output all ship
with this evidence; binaries remain external at the manifest paths.

## Exact gates and source order

At completed test pind77: full Canvas+parallel194passed/4ignored; full desktop,
x11,wayland,parallel,verify-cache GPUI506passed/25ignored (including182library/
22ignored and23doctests); strict full-feature all-target Canvas+GPUI Clippy passes.
Release direct producer oracle4/4 and real Parley selection geometry10/10 pass.
Both Apple aarch64 and WindowsMSVC all-target build-std checks pass; these are
compile gates, not foreign runtime claims. Actual Linux Registry protocol matches
Greek/Hebrew/Arabic extents→hit→ordinary P, reversed selection/caret, atomic UTF8/
USV InsertText/DeleteText and invalid-range rejection. Late service/provider
activation, reactivation, owner replacement and destruction pass. Header/plain/
old-epoch/native-allocation/cohort probes pass from the same frozen executable
whose hash matches the completed full GPUI campaign. Owned Xvfb is stopped.

The original native runner had a path-substitution NameError before any case;
its raw harness error is preserved and excluded from gates. A filtered12B command
ran zero selection cases; it is preserved and excluded. The corrected unfiltered
10case selection suite passes. Earlier public width0 and unsupported emoji-font
census attempts likewise remain rejected controls. Final census reports the
bundled-font MissingGlyph explicitly and uses admitted Latin/Arabic ZWJ text;
it does not claim a shaped emoji fixture or all-browser word/IME behavior.

Useful source pins (all separate from evidence): producerbb0c+test09680; capacity
ca1b; precompression rect oracle8c6e;12B8dab;12B checked membership4b864;12B line
reuseeeee; initial8B068497; direct8Bf515;8B fused79199+testd77. The8B fused ancestry
contains the equivalent checked-membership/line reuse itself; do not also apply
4b/eeee onto it. To review/adopt the coherent compact-map delta, compare Canvas
text files from09680e2a313dbf6ecb25e92c8243cd7c2bb75ba3 to d77 (after the separate
producer/B/font-lock changes). No GPUI runtime/semantic/native source edit is
introduced by compact maps. Existing A/B and producer archives are carried here
unchanged as historical evidence, not relabeled as d77 gates.

The shipping core is29,289 code lines including13build lines (+179 versus the
B/consuming-break base29,110); the initial12B field control is29,126 and
the measured12B known-line-reuse alternative is29,140, separately available.
Full physical source inventory including all captured assembly/helpers is charged
separately. No owner-local arena, shared-line template/rank codec or additional
per-node state is implemented. The reusable contained-owner inspector text-entry
adapter remains the next parked product scope, not silently replaced by step
buttons or included in this text-geometry batch.


Full physical non-test inventory at evidence d645fb9149614e5270e7bec1238075eaab391bff
is346,933 active lines:86,961 first-party +39,955 generated +220,017 vendor.
It includes all historical control archives now carried on this branch, captured
assembly and committed measurement/helper scripts; it is a different measure
from29,289 shipping code lines. Raw all-source inventory/provenance is included.
The first counter invocation used HEAD, which the main-repository-owned tool
resolved to unrelated mainf9fe; that output is explicitly rejected/preserved.
The credited run uses the exact d645 hash, never that HEAD alias. Data-only JSON
counter followups and prose do not add programming source to this inventory.
Root integration must recount its actual combined source rather than sum branch
ledgers or assume this older pinned library graph equals current main.
