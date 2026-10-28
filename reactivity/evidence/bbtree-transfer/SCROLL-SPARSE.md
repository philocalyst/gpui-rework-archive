# Composing independent image facts

Local experiment `local/scroll-sparse-repair` starts from the failed static sparse
variant with corrected image authority and qualified deferred controls. Its protocol
is frozen at372d3960dbebc85d02ed6526d88250b6b0977cab; the five-way cost order is
frozen separately ata13c3629f0efc6a6a640a02530400d640244faf9. No performance samples
have been collected at this checkpoint. The original checkout remains unchanged.

The prior native thread attribution puts98–99% of scroll/mixed CPU in llvmpipe
raster workers. The old scroll trial proved translated overlap but then repaired
one bounding rectangle with that overlap removed. A changed header can therefore
repaint the otherwise untouched gap down to the list. This is the concrete cost
being tested; adding a memory-latency executor alone would not remove it.

BBTree's preserved rightmost-leaf certificate across nonstructural value changes
motivates retaining an unaffected fact through an unrelated edit. Solid/Ripple's
dependency and publication boundaries motivate marking the actual affected
support. Here these are two independently proved facts about complete scenes:

1. Pixels in destination D equal translated pixels in the exact predecessor's
   source rectangle. Existing ordered contribution checks establish this.
2. Outside D, identical ordered contributions remain identical. Mismatched pairs
   contribute both old and new bounds, including every unmatched tail.

For a pixel outside D and outside all marked support, every mismatched command
has zero coverage. Remaining matched commands retain their order, geometry,
clip, material and color, with identical clear/profile/dimensions. They therefore
produce the same pixel. Commands wholly supported in D can be removed from this
comparison. Bounded region merging may add work, never remove necessary support.
Subtracting D from repair rectangles is valid because the first proof owns D.
The GPU repairs complete pixels, preserving the complete scene's paint order.

Immutable glyph leases can differ in address. Equality additionally checks the
key, dimensions and exact coverage identity or bytes before reusing the canonical
unchanged-command predicate for geometry, clip and color. A key alone is not
authority. Existing PresentationToken from/to checks still bind the copy to the
actual GPU image; a source epoch or same-window identity is insufficient.

The copy-bounds control599e36c149ea252f96056f3d8e827da137f71197 and precise candidate
5a07d7c28ffe500a5d24e25fdf1f31ce4857811f differ in one production function. Both use
the same private static Submission adapter, canonical shader, lazy boxed scratch
texture, bounded region representation and repair iterator. Ordinary render and
preparation bodies and application/cost fixtures remain exact source matches.
There is no new executor, dependency, production unsafe code or View purity claim.

At this checkpoint both pass346 Canvas/GPU tests and strict Clippy. The bounding
composition additionally passes1102 composed tests,17 port tests and11 native
scripts; precise native and the independently built control gates are in progress.
Shared fixtures cover edits, removals, order, outside materials, overflow and
transparent HDR. SDR preserves its existing opaque-clear admission. Earlier
fixture/compile failures and the incomplete first preclean snapshot are retained
in the experiment evidence. Original executed GPU test ELFs contain the identical
canonical WGSL. The corrected preclean helper preserves192 package files.

Observed headers: ordinary Output40B, Renderer888B, RetainedRenderer920B; Backing
112→120B; ScrollCopy40B, ScrollTransition72B and SceneDamage32→40B. These are
object headers, not complete retained/driver memory. Copy scratch images and both
overlap copies must pass the fixed counters. Shipping code counts are37933 for
copy-bounds and37977 for precise, versus37372 for their static sparse base.

The candidate still has to pass fresh omission/authority pixel mutants, default,
minimal and full native gates, all work counters and every registered comparison
in the2800-process matrix. No timing or ZGX/hardware victory follows from these
proofs or layout observations.


## Precise scroll repair: complete rejected trial

Sealed dossier `53165424be4665a9874b6f3f5f31aa0d301e57ed`, measured source
`5a07d7c28ffe500a5d24e25fdf1f31ce4857811f`, is local at
`/home/user/gpui-scroll-sparse-lab/reactivity/evidence/scroll-sparse`.
Independent verification covers 11,054 files, 2,800 timing / 420 correctness /
140 allocation processes, 1,066 preserved ELFs and 1,190 archived cache identities.
The initial packaging manifest accidentally skipped two nested manifest.json files;
its preserved copy and corrected exact-path coverage check document the repair.

110 of 112 fixed comparisons pass. Text-0-2-source/static is 1.050606079
(95% paired interval [1.014711041, 1.080154960]); text-1000-1-source/glyph-bounds
is 1.052126970 ([0.993000873, 1.072074686]). Both exceed the fixed 1.05 point
limit. The trial is rejected; intervals do not waive either failure. No native
ZGX comparison or selective rerun follows this result.

Scroll/original is 0.083086662; mixed/original 0.066503121 and mixed/copy-bounds
0.150539480. Precise repair reduces mixed repaired pixels from 169,280 to 15,770;
both copy variants charge 1,401,440 copied pixels and 4,185,280 retained image
bytes per ordinary workload update. All tiny-list comparisons pass in this
cohort without revising older failures. Candidate first updates have no new
pipeline spike. Full/minimal/default/offline GPU gates and strict Clippy pass;
omitting a repair and bypassing the exact predecessor each fail actual pixels.

Runtime/Output/Renderer/RetainedRenderer headers are unchanged. Backing grows
112 to 120 bytes; Metadata 264 to 272; SceneDamage 32 to 40. Shipping code is
37,977 versus static sparse 37,372, and native ELF grows 42,888 bytes. Ordinary
render source is unchanged but its machine code grows 36 bytes. These are
observations, not proof that the two marginal failures are caused by ABI size.
In particular text-1000-1-source/static is 1.003176, while the failure compares
to an older glyph-bounds control. Do not assign a cause from this timing alone.

The next investigation found another concrete lost fact: complete scene commit
collapses all changed command support to one bounding rectangle. Successive
public source edits before ACK also require the union of all preceding candidate
damage; simply applying precise damage from the latest candidate would omit
older edits. A new trial will test bounded support accumulation with exact
P-to-C token authority, preserving existing scroll and single-text paths.
This transfers preservation of unaffected facts and coherent publication from
BBTree/Solid/Ripple; it is not a cache-hit or custom-runtime claim.
