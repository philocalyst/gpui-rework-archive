# Matched control: discrepancy reproduces without mapping

**REPRODUCED WITHOUT MAPPING. The exact cross-backend pixel gate remains FAILED.**
Removing semantic emission mapping produces byte-identical scenes and images in
every backend for initial, insertion and removal. Candidate and control both
have48 differing RGB bytes between GPU and CPU in every frame. Retained GPU
matches full GPU exactly; current CPU matches independent fresh-window CPU.
No tolerance, shader change or scene simplification is used.

The discrepancy is inherited relative to the semantic mapping instrumentation.
This does not establish text/image four-way parity, identify its shader/numerical
cause, or prove every older historical uninstrumented GPUI configuration behaves
identically. All older cold-store controls remain in both builds. Within-backend
equality is evidence for this diagnostic, not a replacement for the original
exact four-way qualification gate. No adoption or timing claim.

## Matched inputs and sole difference

Protocol ccd843df9b36c8e19fc2cd15c39321110fb72ebe. Candidate source
e48a8167057a93bda9d233709f97e918b11eacff; control source
f4468d6ebc39a644383ab8a01f23ef6a76d52d0b. The exact fixture/oracle files, manifests,
dependencies, nightly2026-10-23, release profile and x11-minimal features match.
The Canvas emission observer feature remains compiled in both; control does not
call it.

Complete present-input digests differ in only three files: Runtime mapping
state/module/events/install are removed, the mapping module is removed, and its
observation report is removed. See raw/instrumentation-only.diff. No model/view,
layout, Canvas admission, GPU preparation, shader or presentation algorithm is
changed. Expected mapping presence/absence is checked separately using the same
fixture code; ordinary Source updates and all four pixel captures are identical.

Both generated shaders have SHA256
ea6e71d3da2bdb23d4971a14f0f55db389dbb45f9b2e9c05c85d4dc6363eb4d1,
verified inside independently built canonical executed ELFs. Driver-script digest,
commands, environment, compiler output, Cargo freshness and before/after source
guards are preserved per isolated worktree/target. Software Vulkan library/ICD
hashes and package versions are common. No benchmark/display latency is measured.

## Result

| Frame | Candidate GPU–CPU wrong bytes | Control GPU–CPU wrong bytes | Candidate–control pixels, each backend | Scene/GPU counters |
|---|---:|---:|---:|---|
| Initial |48|48|0|Identical|
| Insert |48|48|0|Identical|
| Remove |48|48|0|Identical|

No normalization of resource identities or scene fields was necessary: complete
scene observations match directly, including glyph coverage and image contents.
The final exact test assertion returns101 in both processes; each driver records
FAILED with variety as its failed gate. Build, strict Clippy and provenance
checks pass. All24 images and both failed test outputs remain inspectable.

Existing Source allocation observations also expose actual diagnostic cost.
Insertion allocates28,612B/145 allocations with mapping versus27,284B/141 without:
+1,328B/+4, retaining +1,280B. Removal allocates26,180B/140 versus25,012B/136:
+1,168B/+4, with no extra net retention because an old mapping retires. These
match1,280B/1,120B new mapping buffers plus48B total ancestor-stack allocations:
an initial16B buffer grows to32B. The previous trace's32B stack figure was maximum
single-Vec capacity, not total allocated bytes. Source peak deltas remain separate
from whole-process/Window peaks or latency. The272B Store header exists only in
the instrumented Runtime, outside these already-mounted Source intervals.

## Consequence and next boundary

Synchronous producer-range observations can continue to guide investigation with
their scope/costs explicit. They do not qualify the failed text/image pixels,
supply GPU/resource lifetime, or authorize output reuse. The136B dependency record
remains diagnostic; no production mapping format is selected. The326-byte escaped
sibling damage and704-byte unchanged-range/changed-color witnesses remain.

Next trace actual packet references under the original full renderer: semantic
identity, command ordinal, physical record address and shared resource identity
are distinct. Separate address changes caused solely by earlier record movement
from changed geometry/material/resource meaning. This must precede choosing
relocation patches or stable virtual addressing; submitted-version lifetime stays
open. Full layout rebuild is a separate measured boundary. No new paint, codec
or rendering-optimization campaign follows this targeted control.

All local. Run python3 verify.py here. Parent-cache reclamation preserved its
canonical executable. A sealing script stopped after an overly broad cleanliness
check noticed its own new evidence; sealing-note.json records that bookkeeping
failure. No build source, oracle or captured failure changed.
