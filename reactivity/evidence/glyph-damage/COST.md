# Four-way complete native-bridge cost protocol

Registered before installing the small-text fixture and before any timing.
All variants contain qualified image placement and the exact acknowledged-image
prerequisite from AUTHORITY.md. The original source-epoch pixel failure and both
previous performance failures remain unchanged in their own dossiers.

Variants: control = original full-publication baseline6895a10440 plus exact image
identity (currently1e46391250); predecessor = failed local-publication957719565444
plus the identical authority fix; bounds = predecessor plus only Stage A's exact
changed-glyph bounding damage (Canvas implementation from5c7bf163d784, with no
test-only raw-support collection); candidate = bounded sparse repair and authority
correction (current production cee7b76d00). Test overlays do not change production.
Record final clean commit, all inputs, executable SHA, features/profile and fixture
hash equality for all four before execution. Do not use older uncorrected ELFs.

Keep the original ten cases and their Workload, warmups, frame counts, viewport,
fonts, owner/source operations and complete GPU pixel/hash/epoch oracles unchanged.
The added early small-case dispatch runs before the measured setup/update regions.
Add eighteen controls: unrelated label counts0/25/1000 × changed fields1/2/4 ×
source/owner routes. These are complete GPUI operations, distinct from the old
CPU-only inbox and pre-shaped GPU probes; they do not revise those earlier verdicts.
Use a960×720 white scene, black text, dynamic "0011"/"1100" labels at(8+i*80,8),
font12, a fixed ASCII resource reservoir at(8,128), and font10 static "label" cells
at(4+(i%25)*38,152+(i/25)*14), matching the old GPU small-text geometry. Ordinary
GPUI translated zero-size wrappers place the fixed text sites. All alternatives
use the same bundled font and application source. Source mode calls public set
for each changed field before one submit/ACK; owner mode makes one public update
callback for all changed fields. Record exact owner reruns and source epochs.
Include string creation, shaping, owner/scene preparation, native packet bridge,
GPU completion and ACK in the frame interval. No pre-shaping or skipped work.
Each process checks final model values, complete CPU pixels against a fresh owner,
and actual native output against a full GPU render. Primary Workload checks stay
unchanged. Independent presenters are covered by correctness witnesses, not added
to timing traces. Both source and owner controls retain their own epoch semantics.

Acceptance: candidate/control paired median process-median ratio <=0.8 for stream
AND stream-owner; <=1.05 for every other case. Candidate/predecessor AND candidate/
bounds <=1.05 for every case. No selective wins, rounding away failures or new
threshold after looking at timing. Confidence intervals and tail/cold results are
reported even when point gates pass; this VM does not establish physical adoption.

Use24 independent four-process groups per case, covering all24 variant permutations
once per case. This balances position and predecessor order without choosing a
winning subset.28 cases ×24 groups ×4 variants =2688 fresh timing processes;
16 warmup and64 measured updates per process. Shuffle the672 groups with seed
20261030. For each case, choose permutation index(pair+case_index)%24 from the
lexicographic permutations of control/predecessor/bounds/candidate. Commit the
flattened PROCESS_ORDER.json before timing. No early success stop or sample removal.

Before timing run three correctness-only processes per variant/case (336), then
one separate allocation process per variant/case (112), each16warm+4 measured
updates. Those phase latencies never become acceptance evidence. Preserve cold
mount/first-image allocation and latency, first update, every warmup, frame p50,
p95/p99, composited/copied pixels and explicit GPU image bytes. Invoking-thread
allocation counts are not total driver memory. The main estimator is the median
of24 paired process-p50 ratios. Use type7 quantiles and paired median bootstrap
10000 resamples, seed20261030; also publish raw process distributions and the
ratio of unpaired medians without substituting it for the registered estimator.

Same pinned nightly/locked offline release profile, fresh per-worktree targets,
private X11 :94, explicit llvmpipe and LP_NUM_THREADS=4. Preserve binaries before
rebuild. No compilers, other tests, allocation probes, source edits or cache cleanup
overlap timing. Maintain >=8GiB free; preserve invalid runs and failures. Pixel,
source-epoch, copy/image/admission counters must agree with intended work; every
process must pass. No timing until corrected controls, full default/X11/minimal
qualification, strict Clippy, GPU formats, native scripts and bounded pixel-negative
witnesses pass their intended gates. Count shipping code separately from fixtures;
report dependencies/shaders, complete ELF, caller/callee stack, headers and retained
capacity. This endpoint excludes OS dispatch, producer transport, WSI/scanout and
device startup. No ZGX ranking, cache-hit or physical-hardware claim follows.
