# Certified region batching — rejected

Local experiment; not adopted, merged or pushed. No application API changes.
A single instanced draw replaces separated scissor draws while preserving the
canonical fragment shader, complete packet, painter order, sample math and full
presentation copy. The private lazy pipeline shares a fresh explicit context
layout with the ordinary pipeline. It is held behind one extra pointer in the
already boxed backing; the offline-shader feature retains its old scissor route.
No dependency/vendor, ownership-model or unsafe production change.

The hypothesis fails. Streaming is8.4% slower than static sparse repair;
owner-driven streaming is7.2% slower. Both fail the required20% improvement.
All78 unaffected point comparisons pass, as do the four primary comparisons
against original/bounds. The inherited ~9x gain against original is not a new
batching win. No native ZGX comparison is run for this rejected candidate.

The measured first regional update is about99–100ms, versus2.6–2.8ms for static
sparse repair. A fresh GPU pipeline costs materially more than its small Rust
header. Fewer draw calls did not improve the complete measured endpoint; this
does not identify which driver/raster instruction caused the regression.

## Method and identity

Implementation preregistration74df3dee3d25a1b4298b98825a6a161811c5203a;
qualified/measured source1f16b73c56f10044a4186c90fb69ffe3d4047ac6. Separate cost
preregistration6f1cf9e1ae170bcffef62665b3b3f91c22e880ab lives in the research
worktree; its exact COST.md/COST.json/PROCESS_ORDER.json are copied here.

28 regimes ×24 balanced four-way groups =2688 fresh timing processes, all24
orders once per regime, seed20261103. Each has16 warmups and64 measured updates
(172032 measured updates). Before timing,336 correctness and112 allocation
processes pass complete pixels/model/epoch/work/copy/image checks. Every pair is
retained. Primary estimator: median of24 paired process-p50 ratios; type7
quantiles and10000 paired bootstrap draws, seed20261103. Both streaming routes
must be<=0.8 against original and static sparse, <=1.05 against bounds; every
unaffected comparison must be<=1.05 against all three controls. Confidence
intervals do not waive the fixed point gates.

Controls were rebuilt in unique targets with the same current deferred-control
example, benchmark fixtures, locked dependencies and repository-default release
profile. No old-app or fat-LTO executable was substituted. Pinned nightly2026-10-23,
private X11:94, llvmpipe LLVM20.1.2/Mesa25.2.8, LP_NUM_THREADS=4. No builds, other
tests, allocations, source edits, cleanup or analysis overlapped the fixed timing
run. All processes exit normally; all source/executable guards pass.

| Variant | Compiled source | Measured unit ELF SHA256 |
|---|---|---|
| control | 20919cb160f6fcc5ab85eca607b97d4173739409 | 5a8792f765b3ea8d75c8ba38a620547c187b1945166fef547d31a017655f6f1a |
| bounds | d67a538b9502fb778460d9c59e726d5bb502ce28 | 822ac490efbbce6d4ebe70e8e7a55b45572c8858fbdd9adf008d80b3b704b55c |
| predecessor | c965a893364b46f965c83d10e2cf94a46dac1304 | 13f0e7f29986087eeaec9c3aaac0e1490978d0b517948249b0ab24d211fbe48b |
| candidate | 1f16b73c56f10044a4186c90fb69ffe3d4047ac6 | 932c81b94ca4b574d9f001acc84dd1ce7b5eb6c6653bd1f07cf6c4197e6f0e86 |

| Case | /Original | /Static sparse | /Bounds | Point gates |
|---|---:|---:|---:|---|
| scroll | 1.007889226 | 0.999608243 | 1.015237241 | pass |
| both | 1.001571533 | 0.997842101 | 0.994384792 | pass |
| stream | 0.109717815 | 1.083811621 | 0.110570419 | **FAIL** |
| stream-owner | 0.112888249 | 1.071761149 | 0.113137964 | **FAIL** |
| fractional | 1.003209704 | 0.999740241 | 1.000997807 | pass |
| flat-tiny | 0.938064139 | 1.019695930 | 0.952828871 | pass |
| flat-full | 1.005330347 | 1.003522932 | 1.009041452 | pass |
| list-tiny | 0.982274121 | 0.989202649 | 0.980677633 | pass |
| list-flat | 0.998983665 | 1.001127227 | 0.997220267 | pass |
| exposure | 1.008700271 | 1.001381268 | 1.011929432 | pass |
| text-0-1-source | 1.005534526 | 1.026392116 | 1.016253090 | pass |
| text-0-1-owner | 0.987393153 | 1.028820454 | 1.001664774 | pass |
| text-0-2-source | 0.981491866 | 1.013080170 | 0.995504439 | pass |
| text-0-2-owner | 1.001701442 | 0.995248693 | 0.993218623 | pass |
| text-0-4-source | 0.991506737 | 0.995841770 | 0.994457468 | pass |
| text-0-4-owner | 1.005325690 | 0.997078664 | 1.000531289 | pass |
| text-25-1-source | 0.988516162 | 0.968391197 | 0.988664396 | pass |
| text-25-1-owner | 0.960363904 | 1.014946429 | 1.008070850 | pass |
| text-25-2-source | 1.012074755 | 1.005195424 | 0.998619683 | pass |
| text-25-2-owner | 1.012545191 | 1.000644418 | 1.003859536 | pass |
| text-25-4-source | 1.017677266 | 0.992629152 | 1.006404459 | pass |
| text-25-4-owner | 0.987906200 | 0.993464176 | 1.001245100 | pass |
| text-1000-1-source | 0.979213597 | 0.992716629 | 0.996737187 | pass |
| text-1000-1-owner | 0.797540624 | 1.004625258 | 1.009658171 | pass |
| text-1000-2-source | 1.008209924 | 1.014834948 | 1.009970504 | pass |
| text-1000-2-owner | 1.008920229 | 1.011977028 | 1.014807980 | pass |
| text-1000-4-source | 0.998055225 | 1.002706753 | 0.982924993 | pass |
| text-1000-4-owner | 1.007434079 | 1.012166972 | 0.990815912 | pass |

The complete registered verdict is **FAIL**, with two failed comparisons.

- stream/static sparse: 1.083811621,95% interval[1.074792118,1.095054375].
- stream-owner/static sparse: 1.071761149,95% interval[1.037367527,1.087372095].

| Streaming route | Candidate warm p50 | Static warm p50 | Candidate first update | Static first update |
|---|---:|---:|---:|---:|
| stream | 2.403408ms | 2.210910ms | 99.376767ms | 2.588467ms |
| stream-owner | 2.477631ms | 2.304854ms | 99.882515ms | 2.772161ms |

The absolute medians above do not replace the paired-ratio estimator. Full process
p50/p95/p99, individual frames, first mount/image/update and allocations are in raw.
Fresh process/object cold observations are not cold shader-disk-cache measurements.
This endpoint is owner operation through native bridge GPU completion and ACK;
it excludes producer/OS dispatch, active-host accessibility projection, WSI/scanout
and startup from the warm frame metric. No hardware GPU/cache-hit/ZGX victory.
Hardware, quality/manual-input equivalence and two hardware classes remain open.

## Correctness and costs

Candidate:76 default GPU tests,78 offline-shader tests,1094 composed GPUI/Canvas
cases (45 ignored),327 minimal-native library cases (25 ignored),17 port tests in
each native profile,11 actual native scripts and4 minimal-native scripts; all
applicable strict Clippy gates pass. Controls rerun native unit/GPU/17 port/Clippy
gates and current native builds; unchanged whole-core/integration/native gates
are inherited explicitly from their qualified predecessors, with source diffs
showing only the qualified deferred-control example changed. Candidate nonnative
production and the old wrong-image-sequence mutant are inherited by source equality.
Fresh omitted-instance mutante19fec3f026969df96504d706e556b6d20d90b7b fails actual
67x53 pixels: corner44,9,78,255 instead of244,242,250,255. The intact candidate passes.

Coverage tests include all three formats, separated rectangles/holes/edges,
fractional/translucent content, images and existing text fixtures,1px dimensions,
8191-pixel axes,64 regions/overflow, redraw/slot patches, failed bounds, resize
and distinct-context authority. At16384 the unchanged full renderer rejects even
identity geometry under its conservative1/32-pixel precision ceiling. That
rejection is preserved; maximum-axis clear packets test addressing only. Their
unchanged pixels alone cannot detect an omitted instance; the smaller admitted
changed-pixel fixtures provide that witness. No tolerance/precision limit is relaxed.

Original typed/generated fragment+ordinary-vertex WGSL remains byte-identical:
ea6e71d3da2bdb23d4971a14f0f55db389dbb45f9b2e9c05c85d4dc6363eb4d1,18995B.
New region vertex WGSL6af2f8ac8608e407756c3d4afd2bfe736f58886bc193be00fecbf8c0577afc0c
is validated and present in the executed GPU render and measured native unit ELF.
The ordinary GPU unit ELF legitimately dead-strips unused regional callers.
Offline artifacts retain their existing checked path and separate tests.

Shipping code37613 lines: +241 over static sparse37372; original36956, bounds37149.
No vendor/dependency change. Backing112→120B; lazy RegionBatch40B plus1024B GPU
instance buffer and up to1024B CPU edge scratch. Output40, Renderer888,
RetainedRenderer920, GpuContext48, Runtime1824 and SceneDamage32 remain unchanged.
The complete canonical packet and2764800B retained image/691200-pixel presentation
copy remain charged on the960x720 streaming workloads.

Warm stream has221 allocation requests/124821B versus221/131315B for static sparse;
owner stream381/220750B versus381/227244B. First stream update8860 requests/3010902B
versus232/186035B, with measured invoking-thread net476356B versus27840B. These
are measured allocator counts, not total driver/process or GPU memory. All cold,
warm, peak/net and per-regime observations are retained; pipeline compilation and
queue-upload resources are not treated as free.

Native example26345432→26412144B (+66712); measured unit61349728→61444096B (+94368).
Ordinary submit remains636B/1344B local stack reservation; ordinary retained render
is2153B/664B versus2117B/664B. The ordinary method texts are identical, but changed
transitive backing destruction can affect generated code. Two preparation bodies
remain11656B and11676B, with1496B local reservations each. Regional write484B/1112B,
submit520B/1296B, constructor867B/360B, regional render781B/136B. These are local
prologue reservations, not call-chain/driver stack bounds. All four whole-ELF
sections and selected caller/callee disassemblies are retained.

## Preserved failures and reproduction

Initial builds exposed unsupported WGSL parameter attributes, Wgpu vertex-buffer
Option syntax and test dimension types; each attempt is retained. Two image-fixture
attempts hit the ordinary maximum-axis precision rejection. The subsequent
dimension diagnostic disproved the unverified image-scaling explanation; the
boundary fixture now preserves the real admission contract. First offline build
lacked locked cached crates; fetching them did not change manifests/lockfile.
spirv-val was downloaded from the configured Ubuntu package repository and
extracted locally, with hashes; it was not installed into the system.

Initial Cargo clean lacked CACHEDIR.TAG and failed before any usable GPU artifact;
the failure, generated files/build script and successful subsequent clean are
retained. A preferred12GiB preflight was17,272,832B short and its shell continued;
the hard8GiB monitor stayed enabled and never stopped a build. A receipt initially
required a dead-stripped shader in an unused unit caller, and another used a
nonexistent native/gpu.rs path. Both receipt mistakes and corrected attempts are
preserved; neither changes the pixel/work gates or verdict.

Executed/measured binaries remain in the canonical SHA256 store. Completed old
target ELF cache copies were individually verified in raw/compressed archives
before removal; path/hash/mode receipts and a restore script are retained. No
source, evidence or canonical preserved binary was removed. Regenerable library
cache cleanup receipts remain separate. Every owned build/test process was reaped.

Run `python3 reactivity/evidence/region-batch/verify.py` to independently verify
manifests, process order/rows/work, ratios/bootstrap intervals, failed mutants,
shader bytes and preserved binaries. The original checkout remains untouched.
Keep this failure before any new hypothesis. Fewer draw calls alone did not reduce
the measured work; the earlier scroll-copy lead remains a separate failed trial.
