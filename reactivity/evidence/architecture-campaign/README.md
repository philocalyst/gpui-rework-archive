# Local architecture campaign: active, no competitor victory

User scope: improve the clean-room GPUI architecture against ZGX with little or
no application API change. Keep every change local. Follow the repository's
isolated worktree, preregistration, freeze, oracle, mutant and evidence rules.

| Local branch / worktree | Experiment | Current disposition |
| --- | --- | --- |
| `local/image-placement` / `/home/user/gpui-image-placement-lab` | Correct double application of image layout position | Qualified dossier `131c05c3c9`: independent baseline pixel failures;991 default/1065 X11,10 port tests,11 native scripts; two expression changes, no API/header/source-line growth |
| `local/list-local-publication` / `/home/user/gpui-local-publication-lab` | Preserve precise text publication beside unrelated retained lists | Failed whole-frame gate; dossier `9725cfa267` verifies1433 files. Final direct/owner admission80/80 each;997 default/1082 X11,10 port,11 native,2 mutants,300 timed/60 qualification/20 allocation processes. Paired stream1.016588093 and owner1.023470685 miss0.8; all other point controls pass. Saves29 allocations/64324 bytes per stream update but adds151 lines/3104 ELF bytes. Damage propagation diagnosis remains open |
| `local/architecture-performance` / `/home/user/gpui-architecture-local` | Retained GPU output | Unadopted; sparse software-Vulkan wins, flat/full-damage losses; exact pixels and actual private X11 exercised |
| `local/state-segments` / `/home/user/gpui-state-lab` | Full state-update control | Production baseline `75a9e2b06b`, identical model/font and independent final pixel oracle |
| `local/text-witness-replay` / `/home/user/gpui-text-witness-lab` | Replay admitted unchanged text witnesses | Rejected: 15% gain misses 20% target and 10K-label regression exceeds 5%; complete dossier at `reactivity/evidence/state-segments` |
| `local/sparse-text-publication` / `/home/user/gpui-sparse-text-lab` | Bounded text run + sparse C/P publication | Inconclusive: large wins but noisy zero-static cell; complete dossier at `reactivity/evidence/sparse-text`, commit `a91fd03b9b` |
| `local/text-session-cache` / `/home/user/gpui-text-session-lab` | Owned font/planning scratch across passes | CPU-qualified at compatible `c7194c74e6`; complete dossier `bc964a0c0a`; unadopted pending broader gates, 3.3 MB retained long-paragraph scratch |
| `local/zgx-native-comparison` / `/home/user/gpui-native-comparison-lab` | Public native workload port + capacity stress | Diagnostic port `6d5e409d6b`; private X11 exercised, typography/control equivalence incomplete; no native ranking |
| `local/text-cache-bounded` / `/home/user/gpui-bounded-cache-lab` | Bound paragraph scratch | Memory gate passes at 45 KB; two CPU cells exceed 5%, unadopted; dossier `e6bda77dfc` |
| `local/gpu-draw-major` / `/home/user/gpui-draw-major-lab` | Load each draw once for sixteen samples | Rejected: exact pixels pass, text gains 7–9% miss 20%; complete `evidence/gpu-draw-major` dossier |
| `local/gpu-pixel-uniform` / `/home/user/gpui-pixel-uniform-lab` | Certify identical per-pixel coverage | Rejected: stripes 8.33x and text-stripes 30% faster but flat +16.6%; complete dossier `173e7c1a34`, 70 GPU tests and exact pixels |
| `local/text-cache-cold-trim` / `/home/user/gpui-cold-trim-lab` | BBTree-inspired cold path isolation | Complete dossier `6b03ad48ad`: 45 KB retention, median CPU gates pass but paired uncertainty remains; 1,045 composed tests and actual native Todo pass; unadopted |
| `local/tree-memory-lanes` / `/home/user/gpui-tree-lanes-lab` | Actual core parent walks: scalar/level/Future/prefetch/proof | Rejected: 2.48x deep level-loop gain, contiguous regression; complete six-way dossier, Miri and mutant |
| `local/tree-parent-columns` / `/home/user/gpui-tree-columns-lab` | Compact authoritative parent routing | Rejected: selective deep 4.11x but outlined scalar fallback 6.88x slower; complete six-way dossier and code-generation evidence |
| `local/tree-admitted-walk` / `/home/user/gpui-tree-admitted-lab` | Validate parent walk once per immutable borrow | Unadopted: deep 3.71x, longer shallow +9.86% and single-full +5.05%; complete dossier `ef335bb664`, 1,044 composed tests and native Todo pass |
| `local/delivery-sweep` / `/home/user/gpui-delivery-sweep-lab` | Structural admission of inbox/task work | Rejected: 64 ready +2.61%, budget-one +14.2%; 707 tests/exact outputs pass, assembly proves indexed control uses jump tables |
| `local/source-batch-publication` / `/home/user/gpui-source-batch-lab` | Preserve distinct typed text edits through one publication | Numerical gates pass: 25–27% less complete publication CPU at 1000 labels; 711 default / 1049 composed tests and six actual native scripts; complete dossier `1830d9d54f`, local application trial candidate, uncertainty/hardware limits remain |
| `local/question-source-set` / `/home/user/gpui-question-source-set-lab` | Preserve exact typed source sets through one Question graph refresh | Rejected performance variant: unrelated 1000-label 18.0x/16.6x gains, dependent25 +5.394% and owner1000 +5.134% fail controls; complete dossier `394e246b9b`, 718 default / 791 native GPUI tests and six actual native scripts |
| `local/question-source-borrowed` / `/home/user/gpui-question-source-borrowed-lab` | Borrow source authority for one synchronous graph refresh | Rejected: primary 18.8x/17.4x, zero-label dependent two-field +7.65%; complete dossier `6553d9a6df`, 719 default / 792 X11 GPUI tests, six native scripts, separate owned comparison |
| `local/sparse-text-batch` / `/home/user/gpui-sparse-batch-lab` | Atomically prepare disjoint sparse command/geometry runs | Rejected: primary 14.4x/8.1x, 25-label two-field owner +5.62%; complete dossier `2d55c3dff1`, 975 default / 1048 X11 GPUI+Canvas tests, six native scripts |
| `local/sparse-text-outline` / `/home/user/gpui-sparse-outline-lab` | Isolate batch preparation from the single-run routine | Rejected: primary 15.2x/8.0x, 1000-label four-field owner +5.0214% fails fixed control; complete dossier `5b670209df`, 975 default / 1048 X11 tests and six native scripts; single routine 2133 B vs 5337 B inline |
| `local/gpu-text-packet` / `/home/user/gpui-gpu-text-packet-lab` | Preserve admitted GPU records/resources across bounded text transactions; repack complete CSR | Rejected at local dossier de8e4f6fea: large two/four-field completion ratios .690910/.547986; tiny full controls1.080780/1.076605 fail.75 GPU,975 default,1048 native tests,6 actual native scripts, mutant and42 allocation probes; temporary bytes increase |
| `local/gpu-text-tiles` / `/home/user/gpui-gpu-text-tiles-lab` | Repaint only tile spans whose admitted references or glyph/common words change; same shader | Rejected dossier3dd29a0ebd: stream ratios .2040/.2222/.2145 vs full and .2557/.2534/.2277 vs packet-only; short one-field0/25 controls1.1000/1.0733 fail.78 GPU,975 default,1048 native,6 native scripts, old-tile mutant,240 timed and42 allocation processes verified |
| `local/gpu-text-gated` / `/home/user/gpui-gpu-text-gated-lab` | Outline tile equivalence and admit only bounding damage>=4096 pixels | Rejected dossier d9aa807a2c: full-comparison primary/control medians pass, but ungated mechanism controls fail at 25-label single 1.0815 and stream25/1000 1.0697/1.0632. 79 GPU,975 default,1048 native tests,6 native scripts;252 timed and42 allocation processes independently verified |

Native parity follow-up local/native-workload-parity at
/home/user/gpui-native-parity-lab: completed dossier3d60e5b4a8. UI-owned Workload
publishes stream through existing with_inbox_for; no library/API change.
Eight tests/Clippy and five actual X11 modes/routes pass qualification. Logs
retain coalescing and repeated ACKs; no performance verdict. Typography,
controlled wheel/keyed overscan, deferred controls and equal profiles remain.
Completed local/text-line-height dossier49f2221f8f2: additive explicit pitch,
old defaults preserved; 967 default/1040 X11 tests, eight native scripts and
source-invalidation mutant. Shipping +79 lines; Style +8B. Both native images
show seven lines at20px pitch; text edges differ, so no exact cross-framework
quality equivalence. Optional keyed list overscan is now qualified in the follow-up below.

Completed local/list-overscan at /home/user/gpui-list-overscan-lab: optional
bounded keyed buffer; default0 preserves prior policy. Dossier41acc60740f4. 974 default/1048 X11 tests, strict Clippy and10 actual
native scripts pass. Fresh wrong-key mutant preserves images but fails public
authority and keyed bounds; both outcomes retained. Shipping+42 lines, cold
ElementExtra56→64B; hot node/row/runtime headers unchanged. This is prerequisite
behavior, not a speed result. Controlled source offset and native integration are now qualified below; deferred
controls and equal profiles remain.

Completed local/list-source at /home/user/gpui-list-source-lab: additive
registered offset operand, gathered/validated ordered wheel writeback and Owner
fanout invalidation. Production93f63b4a03; dossier954ccd59a44d.989 default/1063
X11 GPUI+Canvas tests, strict Clippy and11 actual native scripts. Fresh missing-owner
mutant and epoch-overflow regression fail as expected before correction. Native
test cursor placement failure is preserved and fixed without changing production.
Shipping+263 lines; common ElementExtra restored64->56B, ListState112->120B;
complete allocation and ELF/stack costs recorded. No speed verdict.

Completed local/native-list-parity dossier19e47ef37f at
/home/user/gpui-native-list-parity-lab: public keyed100K list/overscan2/controlled
offset with readback before UI timer work.10 tests, strict Clippy, frozen positional
pixel oracle, reference ranges, exact stream path and6 actual native runs pass.
Those native runs overlap compilation and are correctness only. Shipping delta0;
example ELF+1032B. Misleading nominal mounted-row log removed; native retained-count
observability remains open.

Input correction: earlier wheel28 notes confused row height with native wheel
conversion. Pinned ZGX Linux defaults to40px, can read desktop settings and enables
resampling by default; GPUI remains32px with direct events. Fixed14px timer traces
match. Default interactive trajectories, deferred controls, native retained counts,
matched profiles, text quality and physical hardware remain separate gates.

Completed local/gpu-scroll-copy at /home/user/gpui-gpu-scroll-copy-lab:
dossier8041b7a7fe4f21f27498110e30034d300fee5a7f independently verifies1468 files.
Exact integer canonical contributions plus exact predecessor tokens admit lazy
scratch-copy/repair with unchanged application calls.995 default/1070 X11
GPUI+Canvas,74 GPU,10 port tests and11 native scripts pass. Two bounded mutants
fail actual pixels; the exact100K-row native Workload model passes scroll/mixed
full-render oracles.300 paired-cost processes give scroll ratio.082524407 and
mixed.443327737, but8x8 flat1.071750023 fails the fixed1.05 control. The variant
is **unadopted**; no selective large-workload verdict.60 qualification and20
allocation processes pass; no timing overlaps compilation. Shipping+472 lines,
ELF+22584B, native Metadata+8B, Output+8B, Backing+80B;960x720 scroll scratch
adds1420480 explicit GPU bytes. This is offscreen complete owner/packet/GPU/ACK
work, not native WSI/scanout or a ZGX ranking. A separate output-layout trial
will challenge ordinary dispatch/header overhead without changing this verdict.

[BBTree transfer research](../bbtree-transfer/README.md) records the pinned
implementation, failed historical trials, applicability and next hypotheses.

All later candidates start from the retained-output experiment, so their gains
are not independent adoption evidence for that earlier GPU change. Application
View/Signal/Source remain unchanged. The text cache adds lower-level APIs only;
its original scoped `shaper()` retains non-lexical borrow compatibility.

Unmodified ZGX is pinned at `a3678578980ef239058c557338ef9c544d356b0c`
in `/home/user/zgx-reference-local`. Its unchanged `RENDER=0` microbenchmark
performs layout/damage while GPUI's recorder additionally materializes canonical
glyph commands. Those endpoints and initial profiles differ: no speed ranking
may be derived from their numbers. Native equivalents must match typography,
content, overscan, keyed row retention, controls, timing and acknowledged output before measurement. The reference plus/equals controls explicitly yield before their batched update; the current port still performs them synchronously. Controlled wheel writeback and keyed lists are qualified; native input policy and deferred controls remain unmatched. Explicit line pitch is qualified locally.

This VM has no `/dev/dri`. Software Vulkan is llvmpipe, not a hardware GPU.
The documented `ssh mothership` does not resolve and no SSH keys are installed.
Hardware access has been requested from the user; meaningful implementation and
local qualification continue while it is pending. Two hardware classes and the
required platform/feature gates remain necessary for a competitor victory.

External raw staging directories are `/home/user/gpui-state-evidence`,
`/home/user/gpui-sparse-text-evidence`, `/home/user/gpui-text-session-evidence`
and `/home/user/gpui-native-evidence`. Completed experiments copy their raw data,
failures, source/compiler/binary receipts and independent verifier into their
own committed dossier. Pending staging data is not an acceptance verdict.

Completed scroll-output follow-up at /home/user/gpui-scroll-output-lab:
dossier 6bdfad2b75541bfb0cbac2882329c3e31e885bde verifies 1842 files and 232
preserved ELFs. 450 three-way timing processes, 90 qualification and 30 allocation
processes pass exact oracles. Original-control gates pass (scroll .084791941,
mixed .443562072), but tiny-list candidate/predecessor 1.108649280 fails the fixed
1.05 ceiling, CI [.968239,1.243926]. Unadopted; no threshold change or selective win.
995 default/1080 X11/74 GPU, 10 port and 11 native gates pass; Clear-for-Load mutant
fails pixels. Output/SlotGuard restored 40/80 bytes, Backing remains 192; shipping
37473 lines, example 26329864 bytes. Image-placement correction is absent from all
three historical variants (none of these ten workloads contains images).

New isolated exact-glyph diagnostic at /home/user/gpui-glyph-damage-lab, protocol
f9cbf7e1ecbe19457747ebc5a86756f262ffa9c8, baseline failed-local-publication
957719565444c9900c6e6c20916a6fb88c933395. Existing raw frame counters show exactly
7.921545% more composited pixels in all 15 pairs of both streaming modes. Stage A
checks exact changed glyph support and independent pixel repair before any sparse
GPU implementation or new timing. This is a post-verdict hypothesis, not causation
or an accepted performance result. Application API unchanged; the additive low-level
Canvas observer must retain exact common/resource/lifetime validation.

Glyph-damage follow-up: Stage A source5c7bf163d784 diagnoses median99495 bounding
pixels versus2891 exact changed support on both streaming routes (80/80 each),
with60 complete GPU qualification processes passing. Stage B bounded regions
use median16 rectangles/2905 pixels and pass the three-format full-GPU oracle.
No timing verdict. The subsequent native unseen-ACK witness found a real stale
image failure: matching source epochs do not identify matching GPU images.
AUTHORITY.md preregisters exact acknowledged token reuse for all native damage;
the original baseline is challenged independently and every future comparator
must receive the same correction. Candidate cee7b76d00 is in full qualification;
original failure and later invalid-literal fixture failure remain preserved.


## Complete glyph-damage result and next isolated hypothesis

The complete four-way dossier is227a0567f912719d741a609c18b76f7f16d0e6c3 on
local/glyph-damage. Its independent verifier checks10421 files,1131 preserved
ELFs,2688 timing processes,336 qualification and112 allocation processes.
Source-stream/control0.107037387 (95% interval[0.105273399,0.112999304]) and
owner-stream/control0.109522705 ([0.106187406,0.119072611]) are substantial wins.
The fixed verdict nevertheless fails: flat-tiny exceeds1.05 versus all three
controls (1.073339175/1.056318804/1.117021753); flat-full versus original/bounds
is1.058354510/1.069131172;25-label four-field source versus bounds is1.058992056.
Wide intervals on tiny-flat do not waive the registered failure. No adoption or
ZGX/hardware ranking follows. Every process passes exact output/work checks.

The source/candidate image authority prerequisite is qualified in all variants.
Candidate1001 default/1086 X11/74 GPU/319 minimal-library tests,10 port,11 native,
4 minimal scripts and strict Clippy pass; corrected predecessor/bounds1083/1085
X11,10 ports each and11 native scripts each also pass. Region omission and
same-window/wrong-sequence mutants fail actual pixels. Main runtime, renderer,
backing and GPU surface headers remain equal across variants; candidate TextPatch
40→96 and SceneDamage24→32. Streaming adds5 allocations/7320 bytes over bounds,
with unchanged net bytes and GPU image/copy work. Shipping37361 lines versus
original36956; native example26306728 versus26306384 bytes.

Next hypothesis: separate ordinary and regional GPU submission through static
internal output types, restoring the original ordinary Output, retained render
and GpuContext submit bodies. Shared preparation can specialize per output type;
charge any duplicate machine code and cold cost explicitly. This applies BBTree's
call-site isolation lesson without adding an executor, changing update admission,
weakening image authority or introducing new shaders/resources. The current shared
repair enum changes ordinary render/submit code; that is a concrete difference to
test, not an established cause of the six failed comparisons. A new preregistered
trial must retain original, bounding-only and failed sparse-repair controls.


## Static regional submission: complete failed follow-up

Local dossier5cec749179f43f50abc18d7512b7e90ae402bb0a (local/glyph-submit)
independently verifies9877 evidence files,627 preserved ELFs,2688 timing/336
qualification/112 allocation processes. Production/measured source669487c35d;
preregistration7d62be8d3f. No application API, native admission, shader, dependency,
retained field or image/copy change. Ordinary Output/render/backing/submit source
bodies exactly match the bounds control; static output types split preparation.

The full fixed verdict is FAILED. Source-stream/control0.108943940 (95% interval
[0.104224052,0.111295456]) and owner-stream/control0.106217773
([0.103804908,0.110667075]) retain the large streaming gain. Tiny-flat versus the
sparse predecessor is1.066663744 ([0.871492962,1.147115333]);25-label single-field
owner versus bounds is1.053730811 ([1.008951212,1.083360896]). All other point
comparisons pass, including the previously failed flat-full and25-label four-field
source cells. Wide intervals and different failed cells do not waive rejection,
establish a causal code-layout diagnosis, or authorize selecting successful runs.

Fresh qualification1087 composed/75 GPU/320 minimal-library tests,10 port tests,
11 native/4 minimal scripts and strict Clippy passes. Default non-native production
and exact-sequence native mutant are explicitly inherited with1008-file source
equality. A fresh omitted-region static-path mutant fails actual pixels.
Shipping37372 lines (+11 sparse predecessor), native example26319560 bytes
(+12832). Ordinary submit636/1344 and retained render2117/664 machine/local-stack
bytes match bounds. Two preparation bodies11656/11672 bytes each reserve1496
local bytes; predecessor has one11656/1496. All headers and observed allocation
mechanisms remain unchanged from sparse repair; detailed per-case/cold data remain.

Do not start another dispatch/layout variation merely to obtain passing noisy
point gates. Preserve both failed complete trials. The next work closes the actual
native ZGX task/interaction equivalence gaps, starting with deferred control work
and its observable scheduling/close/capacity semantics. This follows SCHEDULING.md's
requirement to stop microbenchmark refinement until a representative native
comparison can test complete application work. Hardware, wheel resampling, render
quality and equal-profile gates remain open; no ZGX or cache-hit claim follows.


## Deferred native workload controls qualified

Dossier6a3ae55a05a25fd12b53304d795fc1e0136af73f (local/native-task-parity)
closes the synchronous-control mismatch against pinned ZGX. Preregistered7478ef16;
implementation8de61164 on corrected originalbb83c5d8. Only the workload example
changes, with no library/API/dependency/shader change. UI-owned FIFO operations
use one coalesced wake and two frozen deliveries: first yield, then apply. Third
control999 stays immediate; pending work is canceled on close. This specializes
two finite workload operations, not a general executor or a cache-hit claim.

Independent verifier111 files/385 preserved ELF and compiler-module identities.
All17 public port tests, full/minimal actual-window scripts, X11 all-target Clippy
and minimal example Clippy pass. Synchronous and skip-yield mutants fail the two
separate intermediate-state witnesses. Model128B/new Controls48B; wake allocation
120B;64 queued2B operations retain128B after248B/5 allocation requests. A yield-only
delivery costs one owner rerun/description and103 destination compares, with no
layout/paint/presentation in that test. Shipping core36956 lines unchanged; full
native ELF26339472B (+33088 against corrected original). Costs remain charged.

Preserved failures: native harness close/visibility races, corrected using the
same frozen ELF; verifier's nested-path diff bug; temporary7.6G free-space dip in
the first synchronous-mutant build. Its exact ELF fails the intended assertion
again above8GiB. Verified inactive compiler-module archives restore>12GiB before
the independent skip-yield build. No timings occurred in this prerequisite.

Next remaining input-equivalence gap is default display-paced wheel behavior:
ZGX normalizes line notches with40 logical pixels and resamples/eases motion at
display refreshes; GPUI currently applies32-scaled line deltas on arrival. Do not
silently disable the reference's default smoothing or change existing GPUI defaults
to claim equivalence. Investigate an explicit, narrowly scoped native input policy
and deterministic timing/gesture/close tests before another comparative claim.
Render-quality, equal-profile and physical-hardware gates also remain open.

## Matched-profile native diagnosis before further optimization

Read-only wheel investigation confirms that implementing a resampler also requires
frame pacing, captured input position, visibility/gesture lifetime and platform
wheel normalization. No wheel worktree, implementation or public API was created.
The reference's automatic workloads do not inject wheel events. We can therefore
diagnose those modes now while retaining manual wheel equivalence as an open gate;
this does not waive any previous qualification or failed performance comparison.

Protocol20919cb160f6fcc5ab85eca607b97d4173739409 on local/native-profile-control
registers equal fat-LTO/one-codegen-unit native diagnostics of baseline, failed
static sparse repair and pinned ZGX. The sparse composition copies the exact
qualified deferred-control example (c965a893364b46f965c83d10e2cf94a46dac1304);
no production libraries change. Separate worktrees/targets and preserved artifacts
remain mandatory. Software Vulkan CPU/RSS and automatic ticks can identify the
next measurement target, but cannot establish display latency or a framework win.

The renewed upstream BBTree study is recorded in
[UPSTREAM-2026-10-28.md](../bbtree-transfer/UPSTREAM-2026-10-28.md). Its new value-only
update change preserves the last-leaf append proof and tests removed work with
comparison counts. This strengthens the hypothesis of preserving valid dependency
facts across unrelated updates, without adding a coroutine runtime by analogy.

## Native diagnostics complete: rendering work is the immediate bottleneck

Matched-profile dossier a7fbf5e2fe5807d1eb87021918d210e9d65a693e verifies887 files,
72 fresh timed processes,15 native preflights,35 application tests and six
preserved executables. No production library/API change. All36 active GPUI
observations fail the fixed58–61 updates/second gate; ZGX completes479 updates
in every eight-second active run. Baseline/sparse/ZGX median streaming admissions
are330.5/453/479; scroll243.5/241/479; mixed144.5/144.5/479. CPU cores are
3.667/.575/.128,3.850/3.859/.075,3.889/3.890/.147 respectively. The sampling and
whole-workload intervals differ, so these are not per-update costs. No qualifying
paired speedup can be inferred. Both earlier sparse complete-cost verdicts stay
failed. Source, harness, shader and executable guards pass.

The two GPUI native images at tick190 are pixel-identical. ZGX content/geometry
match visibly but glyph rasterization/blending differ. Same font,960x720,scale1,
fat LTO/one codegen unit; llvmpipe only, no /dev/dri. Linux presentation policy
also differs: GPUI FIFO/maximum frame latency1, reference AutoVsync/default2.
No claim of equivalent physical presentation or rendering quality is made.

Attribution dossier ba1d3122a896679cea0a39ea25ccb75b7a756e52 independently verifies
313 files and27 native observations with the same three ELFs. In scroll/mixed,
GPUI main-thread CPU is about.02–.03 cores while named llvmpipe workers consume
3.79–3.86 cores. Sparse streaming uses about.058 main/.487 raster cores versus
baseline.044/3.613. All other thread names and sampling residuals remain recorded;
no source-stack, hardware-GPU, cache-hit or blocked-wait claim follows. This is
strong evidence against expecting a traversal-only change to remove the dominant
CPU cost on this VM.

The next local hypothesis is batching certified disjoint repair rectangles into
one instanced draw, preserving the exact current fragment program and image-token
authority. Current code issues one draw/scissor per region. This transfers
independent-operation batching to the measured rendering path, with pipeline,
vertex-upload, retained storage and full unaffected controls charged. It is not
yet implemented and does not solve mixed scroll+text certification. No general
async executor or application API change is proposed.


## Region batching: complete rejected trial

Sealed local dossier `b165ec9b62a8cf308c0b693f8a92fe819c30a5e4`, implementation
`1f16b73c56f10044a4186c90fb69ffe3d4047ac6`, worktree
`/home/user/gpui-region-batch-lab`, evidence `reactivity/evidence/region-batch`.
The separately frozen cost protocol is `6f1cf9e1ae170bcffef62665b3b3f91c22e880ab`.
All2688 timed/336 correctness/112 allocation processes pass their work/pixel gates,
but the candidate fails both incremental stream primaries: /static sparse
1.083811621 [1.074792118,1.095054375], owner1.071761149 [1.037367527,1.087372095],
against a<=0.8 requirement. All78 unaffected comparisons pass. Preserve the
older static sparse trial's failure; this does not reverse its earlier verdict.

First regional update is99.4/99.9ms versus2.59/2.77ms; first stream allocations
3010902B versus186035B. Shipping code+241 lines, Backing+8B, lazy40B host object
and1024B instance buffer; native ELF+66712B. Canonical fragment and ordinary
method texts remain identical, but fewer draws are not an end-to-end win here.
No native comparison follows a failed cost gate. The dossier verifier checks
10019 files,636 preserved ELFs and888 archived cache identities, and independently
reconstructs the process order, frame/work records, paired ratios and intervals.

Next investigation: compose the existing exact scroll-copy proof with sparse
repair *outside* the copied destination, retaining ordinary scissor submission.
The older scroll-output trial already admitted mixed work and reduced its cost;
its tiny-list failure remains sealed. Its `list_mode` is simply the presence of
viewports, not a prohibition on mixed owner edits. The concrete lost locality is
`subtract(damage_bounding_box, copied_destination)`: a changed header glyph and
scroll can force a large intervening strip to redraw. A separately registered
candidate must compare complete staged scenes outside the proved copy, preserve
exact GPU predecessor tokens, and keep all cold, unaffected and full-copy costs.
No new implementation or victory is implied by this observation.
