# Certified sample partitions: preregistration

Mask-grid screen0d48eb1d rejects stream .865797657 and mixed .870368870 versus
.8, despite all64 work/cadence gates passing and planned work almost halved.
Preserve that result. This separate trial starts from mask-miss productionb817779c
(16x16 bins); it does not inherit fine-grid index costs or claim earlier adoption.

Hypothesis: many sample lanes execute identical color operations. Partition the
4x4 sample lattice by x/y cut bitsets, initially one group sharing clear. For
each draw, union its certified source cuts with prior cuts; copy each newly
created representative's exact old color BEFORE any blend. Blend once per
resulting group. Never merge previously distinct groups based on float equality.
Every logical sample retains the same ordered source-over expression sequence;
final reduction still executes all16 original anchor/delta operations in row
order. Do not average source colors, omit zero arithmetic or reassociate blends.

Permitted source certificates: existing whole-pixel lowered-mask miss (one
zero-source class); existing lowered-mask plus full-pixel rectangular clip
(cuts where sampled mask-cell floor changes); existing LOWERED_SOLID host proof
(cuts where quarter-grid rectangle axis membership changes). Generic material,
transform or clip uncertainty refines to all16 singleton samples. Once fully
split, retain ordinary16-sample handling. Existing four-cell fetch reuse remains.
Keep16vec4 color storage, add two small partition bitsets/control temporaries;
charge compiler/register/spill and branching costs. No new buffer, pipeline,
record format, host geometry, resource bound, API, dependency or unsafe.

GPU admission: fresh GPU/canvas suite and strict Clippy; all336 unchanged public
mask-lattice images exact against independently compiled pre-change oracle6faae98a.
Add public adversaries with overlapping glyphs at differing quarter phases,
narrow lowered solids, generic transforms/clips, SDR/HDR signedzero/subnormals,
inline/compact,banked/literal and replay. Their simple oracle is literal
proof-disabled sample-major execution; that path remains unchanged. Preserve
original336 independent compilation as a separate cross-compiler-image check.
Bounded mutant disables x-cut refinement only; exact public output must fail
internally or against the independent images. Keep unexpected test exit codes
and external-oracle failures honestly distinguished. No tolerances/fixture edits.

Existing native path audit2520aeec proves selected literal mask traversal with
unit-axis masks. Reverify it and prove all host renderer/workload bytes unchanged
fromb817 before timing; do not relabel its old shader/counts as a new partition
execution counter. New actual native preflight images must match exactly.
No speed or saved-blend claim from inherited counts. Actual shader bytes inside
the new executed ELF and all source guards required.

Then unchanged matched64-process native screen seed20261121 against qualified
suffixbaseline compiled2684821f,17 workload tests each,10 preflights,opt3/fatLTO/
CGU1,nightly2026-10-23,X11:94,llvmpipe4,pinnedfont,960x720,initial0,trace,8s,
8 AB/BApairs peridle/scroll/stream/both. Exactingress onlystream,ownerothers.
CPU visible+1..6s spans>=4.8s. Active464–488updates,<=2 earlyACKgaps>25ms,zero
later;idle0. Workfailure suppresses its whole mode. PairedmedianCPU<=.8 stream/
mixed,<=1.05scroll;idleobservedCPU<=baseline,nozero ratio.10000pairedbootstrap/
type7,seedresetmode. No retries/subsets/threshold changes. Freeze source/scripts
beforeobservations;no builds/tests/edits/analysis/cleanup duringtiming;8GiBreserve.

A pass admits full configurations/native/offline and unchanged28-case4160process
costmatrix seed20261122,then matchedZGX. All allocation/cold/capacity/code/stack/
shader/dependency costs charged. Physical GPU,two hardwareclasses,scanout and
quality remain mandatory. All local; no BBTree executor or cache-hit claim.
