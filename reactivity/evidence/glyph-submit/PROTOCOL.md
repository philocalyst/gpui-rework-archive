# Static isolation of regional GPU submission

Preregistered before implementation or timing. Previous complete sparse-repair
trial227a0567f912719d741a609c18b76f7f16d0e6c3 has ~9.3x/9.1x streaming wins but
six failed point comparisons: flat-tiny versus all three controls, flat-full
versus original/bounds, and25-label four-field source versus bounds. Retain that
failure. Wide intervals and unpaired quotients do not reverse the verdict.

Hypothesis: the shared Repair enum changes ordinary retained-render and submit
code even when regional repair is absent. Restore the original ordinary Output,
RetainedRenderer::render, Backing output/stats and GpuContext::submit bodies from
the corrected bounding-only control. Keep regional render behind its own entry.
Use static internal output types at the existing generic preparation boundary:
ordinary Output and a cold regional output containing the borrowed region set.
A private trait exposes the target view and final submit operation; no trait
object, runtime mode match, executor or public API change. Inline only this small
static glue. Keep preparation/validation/packet publication order unchanged.
Specialization can duplicate the large preparation routine; charge complete ELF,
function/caller/callee stack and cold costs. Do not call code size a proven cause.

Regional invalidation must precede any failing admission. Validate dimensions,
target and every region even if the backing is absent or resized; those cases
use ordinary full render after validation. Existing one-region forwarding stays.
Do not change Canvas support,64-region cap, source/owner admission, coalescing,
exact window/sequence image authority, resource retirement, shaders or GPU copies.
No new persistent storage or unsafe code. The scope is GPU dispatch/code generation.

Controls in CONTROLS.json are immutable measured artifacts, not reused build
caches: corrected original140a754feaf0, bounding-only44bfdf22e404, and rejected
sparse-repair42a031b65e25. A fresh source-only predecessor worktree at aed951bc175d
exactly matches every input hash of the old sparse executable. It has its own
reserved target if any later build becomes necessary. The original worktree now
contains a sealed evidence commit; no checkout/reset of that worktree is used.
The new candidate has its own fresh target. All fixtures must remain byte-identical.
Record explicit source, features/profile, input guards and ELF hashes for every
variant. Validate generated shader bytes and actual compiled ordinary code.

Required correctness before timing: focused/full GPU exact pixels in all supported
formats, native composed GPUI/Canvas suite and10 port tests, strict Clippy,11
native scripts and minimal-native library/actual scripts. Unchanged default
GPUI/Canvas production qualification is inherited explicitly from cee7b76d00;
only GPU source is changed and gpui_gpu is optional outside native features.
Run a fresh omitted-region GPU pixel mutant to prove the new static dispatch
reaches the region path. The exact-window/sequence native certificate and its
actual pixel mutant are inherited unchanged, with source equality checked.
Preserve all compilation/test failures and source guards. No source edits until
that worktree's own compilers/tests/guards finish.

Use the unchanged28 complete native-bridge cases from the preceding trial,
including0/25/1000 unrelated labels ×1/2/4 fields ×source/owner controls.
Three correctness processes per variant/case (336), then one allocation process
per variant/case (112), each16 warmups/4 post-warmup updates. Require independent
full GPU pixels, small-case fresh-owner CPU pixels, final hashes/source epochs,
copy/image counters and exact model/owner-run checks. Those latencies are excluded.

Timing:24 balanced groups/case covering all24 variant permutations once; shuffle
672 groups with seed20261031. PROCESS_ORDER.json is fixed before implementation.
28×24×4 =2688 fresh processes;16 warmups/64 measured updates. Main estimator is
median of24 paired process-p50 ratios, type7 quantiles and10000-resample paired
bootstrap95% intervals, seed20261031. Also report all raw/cold/tail distributions
and unpaired median quotients without substituting estimators or selecting samples.
Candidate/control <=0.8 in stream AND stream-owner; <=1.05 in every other case.
Candidate/predecessor AND candidate/bounds <=1.05 in every case. No early success,
threshold changes or adoption of a successful subset. An unchanged failure remains
failed; do not rerun or select pairs to make it pass.

Same pinned nightly, locked offline release profile, private X11 :94, llvmpipe
LP_NUM_THREADS=4; >=8GiB free. No builds, other tests, allocations, source edits or
cleanup during timing. Endpoint remains Win operation through native GPU completion
and ACK; exclude OS/producer dispatch, active NativeHost accessibility projection,
WSI/scanout and device startup. No hardware/cache-hit/ZGX victory follows. Preserve
source/evidence/artifacts and seal an independently verified dossier before any
further hypothesis. All changes stay local.
