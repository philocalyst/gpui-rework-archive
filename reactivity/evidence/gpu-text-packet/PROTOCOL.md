# Text record transactions in retained GPU packets

Base 5b670209df18941f8604bea2ee2d2bfe3597da78. The base's outlined CPU batch
failed its fixed owner-dependent control; this is a separate GPU hypothesis,
not adoption of the base or a reinterpretation of its evidence.

Native sparse text publication currently calls full RendererState preparation:
validate every draw, rebuild records/CSR, walk atlas resources, upload the whole
packet and recreate its bind group. Test preserving unchanged admitted records,
common words, correction table, atlas and images. Gather at most four same-length
compact masked runs; check all geometry/common state/resources before writes.
Then replace their glyph words and reconstruct surviving painter-order tile lists.
Initially repack the complete CSR from existing admitted lists plus changed-run
bounds. This intentionally still scans/copies/uploads global tile/index storage;
do not call it O(changed) or a bounded whole-frame commit. A per-tile spare-capacity
alternative is deferred to another trial. Charge all new run-map, scratch, upload,
bind-group and retained capacity costs, including full-scene preparation.

Masked runs cannot change the existing opaque-solid cutoff. Reapply that cutoff
to new memberships; preserve painter order, clear/uniform tiles and complete old
and new damage. Reject changed run length/common words, clip chains, absent atlas
keys, wrong target/context, duplicate slots and resource/buffer limits before
any mutation. Rejection leaves the previous packet/image replayable. Revoke
packet authority before queue writes; queued earlier frames retain WGPU ordering.
A native caller additionally requires the exact preceding complete scene token;
missed/coalesced transitions, changed resources or layout take full preparation.
No new unsafe, custom task executor or application View/Signal/Source changes.
Small additive low-level scene/renderer accessors may describe positional runs.

First freeze identical complete-operation GPU fixtures: 0/25/1000 static labels,
two/four short exact text runs, 735-character stream text, and full-scene/one-field
controls. Include actual full preparation and fresh independent pixel equality;
run through queue completion, with cold creation, CPU preparation, upload bytes,
GPU/process memory and p50/p95/p99 recorded separately. Five alternating fresh
process pairs, 10 warmups and 60 measured updates, same compiler/features/font/
driver/affinity. Primary 1000-label two/four-field completion ratios <=.8;
all full-scene and one-field control medians <=1.05. Stream admission and cost
must be reported even if fallback loses. Preserve all runs and pair ranges.
No compiler, tests, source edits or allocator probes alongside timing.

Require exact CPU/GPU tests for moved tile boundaries, overlapping painter order,
uniform-to-sampled conversion, opacity cutoffs, transforms, SDR/HDR, grouped-mode
fallback, new masks and late-member rejection. A mutant that omits new tile
membership must fail an exact public image comparison. Native integration needs
actual frame tests, old-P/new-C/failed-newer and older-ACK authority, then the
complete composed suite and native task/input scripts. Pin build-only executables
before test feature-unification overwrites aliases, full input guards and generated
shader/ELF identities. Shader logic is unchanged; any shader change is out of scope.

This VM uses llvmpipe/private X11. No physical GPU/scanout or ZGX victory follows.
Competitor equivalence, matched release profiles and two hardware classes remain
separate mandatory gates. No automatic merge or push; keep all work local.


## Pre-timing numerical-envelope correction

The first frozen candidate a3495f600d failed both new public tests with
ChangedCommon, before any paired timing. Full validation derives two error-bound
lanes from glyph local origins/extents, so legitimate position/content changes
can change those lanes even when transform/clip/color/correction identity match.
Recompute both bounds for the complete changed run and upload those derived
common lanes with its placements. Continue requiring all other common words to
match exactly. Preserve the failed suite and its clean input guard. The exact
new-tile, painter-order and late-failure tests and thresholds are unchanged.
