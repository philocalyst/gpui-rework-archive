# First sorted-row ownership control

Review source **b46a311e7c9baa71c63012afcad39c08f1037b72**, isolated
`/tmp/gpui-presented-changes-sol`, base **d0bd2f4ea541cf3483c71d5e8228aea5a8a1c7cc**.
This is an implementation/owner control, not shipping qualification. No main or
frozen inspector tree was edited. Normal-path codegen, matched baseline owner
controls, native/cross/strict closure and controlled performance are pending.
No timing or RSS claim is made from test harness elapsed times.

`CandidateRows` owns Full(Vec<Presented>) or sorted Changes(Vec<Change>). The
builder proves each emitted identity and parent index against P online and
checks final length. Topology divergence, truncation, or a prospective changed
buffer at least as large as full P promotes once to Full. It moves already
owned changes, clones only unchanged prefix rows, and keeps no extra complete
candidate/discovery vector. That promotion temporarily overlaps the sparse
buffer with Full: dense/fallback peaks still require matched pricing.
The sparse buffer starts at capacity1 and grows geometrically, avoiding Vec's
four-row minimum. Tiny changed one-row output chooses Full before allocation.

A private generic Presented<Text=SharedText> is one schema; lowering borrows
SharedText and clones a lease only into an owned row. All scalar words, kind,
actions, complete packed parent/skip word and map key are compared exactly.
Text uses pointer identity: equal bytes in different immutable leases are
conservatively changed ownership, with no new long-string scan. A focused test
preserves that extra-owned-row behavior. Parent topology compares parent index;
changed skip words are still stored. No padding comparison/hash/unsafe is used.

C's borrowed Rows view merges P and owned changes. Forward/reverse iterators
are O(N+K), random parent lookup O(log K). The static RowAccess slice
implementation keeps ordinary P query/semantic/input carriers as slices; C
alone uses the overlay. Candidate parent basis and freeze-membership reads use
the merged candidate prefix, not P directly. Encoded basis keys are compared
for row ownership, then resolved through their own C geometry bank. Same-index
new coefficients do not borrow the old bank. Full independent geometry,
metadata, image and TextGeometry columns remain and are explicitly charged.

P rows mutate only at ACK. New C2 is rebuilt against the same unchanged P,
never C1. All builder/fallback work remains before the nonfallible Canvas and
column commit tail; failure leaves old exact C1/token/columns alive. ACK moves
changed rows into P in place, preserving unchanged rows, leases and allocation.
Full still swaps; KEEP still uses an empty zero-allocation owner. The enum costs
an extra8 retained bytes even when no candidate exists.

Measured 64-bit types: Presented and borrowed draft64, Change72,
CandidateRows/Option32, Prepared/Option48 (base40), Runtime<()>1832 (base1824),
C Rows32; P HitSheet56 unchanged, C HitSheet72. These are static carriers, not
aggregate stack peaks. Syn/Tokei15 counter **30,636→30,950 = +314 shipping code
lines**, excluding separately retained tests/probes/evidence. No public API,
new dependency, or per-row dyn dispatch.

Exact-source controls passed: 3 private owner/iterator tests, 3 focus-release,
4 inspector/oracle, 2 image-lifetime, and40 public cases (new4, inspector15,
pointer9, pointer_focus12): **52 focused cases**. Six additional fresh-process
owner fixtures passed. The recorded source/config/vendor guard has1,971 files;
all unchanged after tests; frozen unit executable is hash-qualified in metadata.
Cargo jobs1, generic flags unset, checked-out root configuration. Initial GPUI
unit build is fresh:false/default+simd; fingerprint flags assert v0 and
tokio_unstable. Public integration build is recorded separately in public.log.

Initial errors are preserved: compile-time trait/lifetime adaptations and the
new consumer fixture initially passed Vec instead of Iterator; its first run
also used current-only selector queries while C was pending and incorrectly
assumed a=0 made a general affine singular (nonzero b/c kept it invertible).
The repaired fixture uses acknowledged visits, an actually singular map, and
the existing keyed-list anchor/reversal contract. No production admission was
weakened for those fixture failures.

Whole-window C1 actuals below include logical reconciliation, Canvas work and
all remaining columns. They are not matched savings claims. Mount, C2 and ACK
raw allocation/retention/peak records are in each log. P is fully acknowledged
before C1; C1 remains alive while C2 is constructed. `peak_extra` is allocator
high-water above the phase's starting live bytes, not process RSS.

| case | P rows / row capacity bytes | C owned rows / bytes | full C text-geometry bytes | full C geometry bytes | C1 retained delta | C1 peak extra |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| tiny1 | 1 /64 | 1 /64 Full | 0 | 0 |64 |1,436 |
| workspace32 |33 /2,112 |1 /72 |0 |0 |160 |21,760 |
| sparse16k |16,385 /1,048,640 |1 /72 |0 |0 |160 |11,141,120 |
| text32k |32,769 /2,097,216 |1 /72 |786,432 |0 |786,592 |22,282,240 |
| transformed32 |33 /2,112 |1 /72 |0 |1,024 |1,184 |22,272 |
| inspector32 |63 /4,032 |1 /72 |768 |1,024 |2,352 |30,248 |

The inspector owner fixture has its ordinary unselected inspector (26 text
maps); selected-caption/input behavior is covered by the focused inspector
suite, not claimed by that owner cohort. Text32k retains32,768 C text map leases
and its786,432B entry bank. Its Presented SharedText lease sum is65,537 while C
exists, dropping to65,536 on ACK: just one additional Presented text lease, not
one per row. All six fixtures currently have no images; the two separate image
lifetime tests cover those unchanged resource columns, not an image memory win.
Large scenes still do substantial full logical/Canvas/text-column work. Sparse
row savings alone do not establish a whole-window speed or peak improvement.
