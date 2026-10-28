# Preserve changed support across candidate publication

Local protocol c025341544b45f5b27e405ad8372c332aa333498, identity-label correction
b4188e7cedc008f6d8b48f03da6173af54c7458d. Candidate source
92bfac4445c8b518b945c384fe6ff83ed772ae4f at /home/user/gpui-scene-support-lab.
This follows the complete rejected scroll trial 53165424be4665a9874b6f3f5f31aa0d301e57ed;
that trial's two failed controls remain failures. No timing for this candidate
has been collected at this checkpoint.

## The precise transfer

BBTree's [batch design](https://github.com/XiangpengHao/bbtree/blob/1c72bd27994ed0a38694b029618e80115e22644f/design/12-batch-api.md)
separates gathered destinations from ordered mutation. Its private executor
interleaves independent cache-miss chains; it is not a general async I/O runtime.
The source's same-tree/input-order guarantee and invalidation on structural
change are as relevant as prefetch. Current GPUI software-Vulkan attribution
puts most scroll/mixed CPU in raster workers, so removing unnecessary raster
work is the immediate measured transfer. Earlier memory-lane experiments and
all their failures remain in the campaign; this trial does not rename them wins.

Solid stages and commits dependency values separately. Ripple groups compiler
update destinations and checks live block/request identity when executing.
Their pinned implementation analysis is in LOCALITY.md and SCHEDULING.md. This
experiment applies that distinction to an acknowledged image P and candidate
scenes C and N; it does not replay arbitrary View callbacks or infer their purity.

## Support composition

For complete images A and B, D(A,B) conservatively contains every pixel whose
value differs. Ordered identical contributions need no repair. A mismatched
pair adds both old and new support; unmatched tails add every remaining support.
Glyph equality requires dimensions, key and exact immutable coverage, plus the
existing geometry, clip, map and color predicate. Materials retain the canonical
predicate. At every pixel outside D, the remaining equal contributions have the
same order and therefore the same result. Changed clear/profile/size widens to
full support. The existing region cap can only add coverage.

If C supersedes acknowledged P and N supersedes C before presentation, then:

    D(P,N) is contained in D(P,C) union D(C,N).

A transition remembering only D(C,N) is wrong even when C and N have perfectly
valid source epochs. The implementation composes an earlier region certificate
only if it binds the full acknowledged P token to the current complete C token.
Otherwise it includes the existing conservative pending bounding damage. The new
certificate binds P to N. Native submission independently requires its actual
GPU image token to equal P before using any repair. Failed N admission leaves
C and its certificate eligible. After another presenter ACKs an unseen image,
GPU submission uses full reconstruction.

The existing cold metadata pointer now owns either a scroll certificate or
complete-scene regions. One region stays inline in DamageRegions and uses the
ordinary GPU path; multiple regions use the existing static regional submission.
TextPatch and SceneDamage fields, single-text source, ordinary GPU submission,
shader, app and all fixed cost fixtures are byte-identical to the predecessor.
A shared helper replaces the previous scroll-local glyph predicate. Full scene
comparison remains O(commands); this does not claim a B-tree complexity bound.
No new production unsafe code, dependency, executor or application API is added.

## Evidence checkpoint

349 Canvas/GPU tests pass, including exact CPU repairs and full-GPU equality in
three formats. The first strict Clippy attempt found an unused shared test
fixture constant; its preserved correction changes test lint handling only.
The corrected Canvas/GPU gate passes Clippy. Shipping code is 38,093 lines,
116 more than precise scroll. Generated code, stack, headers, allocations and
retained capacity still need measurement; source line count is not their proxy.
Full native composition is compiling. Two frozen fault variants remove one
repair region or drop prior pending damage; their pixel tests are still pending.

The new fixed primaries are the four zero-unrelated-label two/four-field
source/owner cases, each <=0.8 versus all four immutable controls. They isolate
separated repair work and, for source edits, pre-ACK composition. All other
registered gates and the inherited stream/scroll gains remain mandatory. The
five-way 2,800-process schedule and all thresholds were frozen before code.
The trial has not qualified, and no ZGX/hardware/scanout or cache-hit claim follows.


## Complete scene support: rejected, with publication lifetime follow-up

Dossier 7494c10970d3dc46e7611d4abe93ab8476682a6e at
/home/user/gpui-scene-support-lab/reactivity/evidence/scene-support independently
verifies 10,746 files, all 2,800 timing / 420 qualification / 140 allocation
processes, 930 preserved ELFs and 1,178 archived cache identities. Source
92bfac4445c8b518b945c384fe6ff83ed772ae4f follows preregistration c025341544b45f5b27e405ad8372c332aa333498
and identity correction b4188e7cedc008f6d8b48f03da6173af54c7458d.

The complete fixed gate rejects the candidate: 93 of 112 comparisons pass.
All sixteen new primary comparisons miss <=0.8. Candidate/prior-precise ratios
for zero-label two/four-field source/owner cases are 0.957668610, 0.978111523,
0.982732532 and 0.955903594. Repair areas shrink from 1,430 to 780 and 3,510 to
1,560 pixels, but complete operations improve only modestly. Three regression
failures remain: flat-tiny/static 1.059724779, 1000-label four-field source/original
1.052945383 and /prior-precise 1.051235628. No threshold change, selective rerun,
adoption or native ZGX comparison. Earlier failed trials remain failed.

All functional, native, minimal/default/offline and strict Clippy gates pass.
The omission fault fails GPU pixels at case 0/tick 3; a review script's incorrect
tick-1 expectation is preserved and corrected without rerunning. Dropping prior
pending damage fails the existing coalesced scroll+owner Rows fixture, with
2,540 of 20,480 image bytes wrong. The intact candidate also passes the new
multi-source Page fixtures; do not claim the negative run reached them.

Shipping code grows by 116 lines, native ELF by 7,912 bytes, and present_walk's
observed local stack reservation by 64 bytes. Header sizes stay unchanged, and
the shared SceneRepair enum fits the existing 72-byte allocation. The global
scene comparison is rejected. Do not infer its few-pixel savings remove the
fixed packet preparation, submission and complete presentation-copy costs.

Inspection before choosing another representation change found a more direct
repeated cost: try_sparse_text allocates TextPatch on every accepted update;
acknowledge consumes that box, and a coalesced full candidate drops it too.
DamageRegions may allocate another bounded vector each time. The allocation
lifetime need not equal the candidate's authority lifetime. A next isolated
hypothesis can retain an owned workspace while an Option payload marks whether
it contains a live candidate, clear region contents while retaining bounded
capacity, and keep full token checks. ACK must move text/geometry exactly once;
failed preparation and full supersession must retire active content without
publishing cached state. Reclaim the workspace with its text resources.

This is a concrete reuse question, not an assertion that heap work caused the
marginal failures. The previous text-session and cold-trim trials concern shaping
scratch, not this publication box. Do not carry the rejected global comparison
or assume the promising 72-byte enum itself improves execution. No next candidate
has been implemented or measured at this checkpoint.
