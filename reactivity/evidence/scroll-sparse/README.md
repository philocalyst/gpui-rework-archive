# Precise repair outside a copied scroll — complete gate rejected

Local experiment; not adopted, merged or pushed. Existing application APIs and
all workload fixtures remain unchanged. Exact translated overlap and precise
outside damage compose successfully, but the complete fixed cost gate fails two
text controls.110 of112 comparisons pass. No native ZGX comparison follows this
failure, and no hardware/cache-hit/scanout or overall ZGX victory is claimed.

The mixed-update lead is real within this software-Vulkan endpoint: candidate
time is0.066503121 of the corrected original and0.150539480 of the bounding-copy
ablation. The latter isolates the new repair derivation. Scroll/original is
0.083086662; scroll/copy-bounds is1.021030455. Streaming's inherited sparse-repair
gain remains; it is not a new win from the scroll derivation. All tiny-list
comparisons pass in this cohort, without changing the earlier failed trial's verdict.

The failures below are mandatory point gates. Their intervals do not waive them:

- text-0-2-source/predecessor: 1.050606079,95% paired interval[1.014711041,1.080154960], limit1.05.

- text-1000-1-source/bounds: 1.052126970,95% paired interval[0.993000873,1.072074686], limit1.05.

## Method and execution identities

Implementation protocol372d3960dbebc85d02ed6526d88250b6b0977cab; separate cost/order
freeze a13c3629f0efc6a6a640a02530400d640244faf9. Candidate and copy-bounds differ
only in `outside_damage`; their representation, copy, repair iteration, submission,
ordinary render bodies, shader, application and benchmark fixtures are shared.
The other three current-app immutable controls come from the region-batch dossier,
with source/profile/fixture/ELF guards. Copy-bounds is built in a unique target.

28 cases ×20 paired five-way groups =2800 fresh timing processes. Each runs16
warmups and64 measured updates (179200 measured updates total). Two cycles of
a five-treatment Williams design balance positions and adjacent orders; groups
are shuffled with seed20261104. Before timing,420 correctness and140 allocation
processes pass exact final pixels/source epoch and per-operation copy/image gates.
No successful cell is selected for adoption and no failed comparison is rerun.

Primary estimator: median of20 paired process-p50 ratios, type7 quantiles and10000
paired bootstrap draws with seed20261104. Scroll/mixed must be<=0.8 versus original,
glyph-bounds and static sparse; mixed<=0.8 and scroll<=1.05 versus copy-bounds.
Stream/owner-stream must be<=0.8 versus original/glyph-bounds and<=1.05 versus both
newer controls. Every other comparison must be<=1.05. Exact thresholds and process
order are in COST.json and PROCESS_ORDER.json.

Pinned nightly2026-10-23, locked offline dependencies, repository-default release
profile, private X11:94, llvmpipe LLVM20.1.2/Mesa25.2.8 and LP_NUM_THREADS=4. No build,
other test, allocation probe, source edit, analysis or cleanup overlaps fixed timing.
All2800 processes finish and all before/after source/executable guards pass.

| Variant | Compiled source | Measured unit ELF SHA256 |
|---|---|---|
| control | 20919cb160f6fcc5ab85eca607b97d4173739409 | 5a8792f765b3ea8d75c8ba38a620547c187b1945166fef547d31a017655f6f1a |
| bounds | d67a538b9502fb778460d9c59e726d5bb502ce28 | 822ac490efbbce6d4ebe70e8e7a55b45572c8858fbdd9adf008d80b3b704b55c |
| predecessor | c965a893364b46f965c83d10e2cf94a46dac1304 | 13f0e7f29986087eeaec9c3aaac0e1490978d0b517948249b0ab24d211fbe48b |
| candidate | 5a07d7c28ffe500a5d24e25fdf1f31ce4857811f | cdc8811324153f68408374e258ba99f860e893733645ecaa0560520f2bde44ff |
| copy_bounds | 599e36c149ea252f96056f3d8e827da137f71197 | ea81ba1d039c325105e9c7b051324f640af12e5b63a6db82ba40d3a153c27828 |

| Case | /Original | /Glyph bounds | /Static sparse | /Copy bounds | Gate |
|---|---:|---:|---:|---:|---|
| scroll | 0.083086662 | 0.083657458 | 0.084147643 | 1.021030455 | pass |
| both | 0.066503121 | 0.066716529 | 0.066349145 | 0.150539480 | pass |
| stream | 0.101429370 | 0.101080926 | 0.982892033 | 0.983681301 | pass |
| stream-owner | 0.104418103 | 0.104054479 | 0.992713832 | 1.009793617 | pass |
| fractional | 0.997089823 | 0.997164302 | 0.991803241 | 0.999842900 | pass |
| flat-tiny | 0.959247899 | 0.960242062 | 0.983038281 | 1.047712415 | pass |
| flat-full | 1.005326618 | 1.006568248 | 1.007395660 | 1.009757660 | pass |
| list-tiny | 0.539185871 | 0.504021225 | 0.513723435 | 0.999202435 | pass |
| list-flat | 0.099929391 | 0.099878256 | 0.101492878 | 0.994667176 | pass |
| exposure | 0.994032291 | 1.000933536 | 0.992999087 | 0.993595033 | pass |
| text-0-1-source | 1.014487982 | 0.978415032 | 0.988936192 | 0.998009577 | pass |
| text-0-1-owner | 1.002013299 | 0.995714350 | 1.028720232 | 1.019809049 | pass |
| text-0-2-source | 1.003863956 | 1.026377031 | 1.050606079 | 0.995747123 | **FAIL** |
| text-0-2-owner | 0.989225561 | 0.982509572 | 1.002177853 | 0.981524485 | pass |
| text-0-4-source | 0.983697303 | 1.010340326 | 1.005030806 | 1.014248804 | pass |
| text-0-4-owner | 0.980491270 | 0.992765702 | 0.995098222 | 0.998458516 | pass |
| text-25-1-source | 1.004488065 | 0.994428910 | 0.998722668 | 1.006032085 | pass |
| text-25-1-owner | 0.976743200 | 0.984382679 | 0.981965649 | 1.010470359 | pass |
| text-25-2-source | 1.043086425 | 1.013118577 | 1.033983240 | 1.009994996 | pass |
| text-25-2-owner | 0.994342872 | 1.010274705 | 1.007804067 | 0.995912928 | pass |
| text-25-4-source | 0.997817895 | 1.012520206 | 0.990419283 | 0.994566181 | pass |
| text-25-4-owner | 0.994105053 | 1.012637246 | 0.997247937 | 1.013392175 | pass |
| text-1000-1-source | 1.003874072 | 1.052126970 | 1.003176210 | 1.027442483 | **FAIL** |
| text-1000-1-owner | 0.763622459 | 1.003211129 | 1.005948071 | 0.971245186 | pass |
| text-1000-2-source | 0.987884035 | 0.993455929 | 0.986886147 | 0.984198928 | pass |
| text-1000-2-owner | 1.005594884 | 0.996098771 | 0.996279184 | 1.000717535 | pass |
| text-1000-4-source | 0.984228271 | 0.972409724 | 1.012949501 | 0.997440455 | pass |
| text-1000-4-owner | 0.999081121 | 0.988568567 | 0.985390567 | 0.999267512 | pass |

| Case | Candidate warm p50 | Copy-bounds warm p50 | Original warm p50 | Candidate first update |
|---|---:|---:|---:|---:|
| scroll | 2.851178ms | 2.770612ms | 34.291086ms | 2.960441ms |
| both | 3.768476ms | 25.009670ms | 56.837808ms | 4.118271ms |
| stream | 2.197926ms | 2.251129ms | 21.753926ms | 2.749759ms |
| stream-owner | 2.273380ms | 2.253468ms | 21.771552ms | 2.697131ms |
| list-tiny | 0.155720ms | 0.158443ms | 0.291905ms | 0.450997ms |

Absolute medians are descriptive; their ratio is not the paired gate estimator.
Full per-frame, cold, tail and per-process observations remain in raw. The endpoint
is owner operation through native packet preparation, GPU completion and ACK. It
excludes OS/producer dispatch, active-host accessibility projection, WSI/scanout
and initial GPU-context construction from the warm metric. Fresh process/object
observations are not a cold shader-disk-cache measurement. Manual input/render
quality equivalence and two physical hardware classes remain open for the user goal.

## Mechanism, work and storage

The existing complete-scene proof certifies translated ordered contributions.
Outside the copied destination, the candidate compares complete filtered command
streams. Identical geometry/clip/color/material remains unchanged; every mismatched
old AND new contribution retains its conservative support, including both tails.
Glyph equality additionally requires key/dimensions and identical coverage identity
or bytes. Existing bounded DamageRegions collapses overflow to conservative bounds;
subtracting the copied destination yields at most256 scissor rectangles without
another unbounded queue. Exact PresentationToken from/to authority remains mandatory.

This applies BBTree's preservation of unaffected facts and Solid/Ripple's precise
publication boundaries. It does not add an executor or infer arbitrary View purity.
The earlier thread attribution identified raster workers as98–99% of scroll/mixed
CPU; the experiment reduces raster work rather than claiming memory-latency overlap.

Median mixed repair is15770 pixels versus169280 with bounding copy and524400 for
the non-copy alternatives. Both copy variants perform1401440 copied pixels and
retain4185280 image bytes at960x720: full presentation plus both overlap copies,
and backing plus scratch. Ordinary variants copy691200 and retain2764800B.
Scroll repairs12880 pixels in both copy variants. Tiny-list repairs16 versus256,
but still charges1504 copied pixels and5056 retained image bytes. Every operation,
including first use and warmups, meets its registered copy/image accounting.

Warm mixed allocation medians: candidate553.5 requests/358360B, copy-bounds549.5/
351576B; first update459/340212B versus455/333428B. Scroll and tiny-list candidate
allocations equal copy-bounds in the measured allocation run. Full mount, first,
warm, peak and net observations are retained. These count the invoking thread's
allocator calls, not all driver/process or GPU memory.

Runtime1824B, ordinary Output40B, Renderer888B and RetainedRenderer920B stay fixed.
Backing112→120B adds a lazy boxed texture handle. Existing boxed Metadata264→272B
and ephemeral SceneDamage32→40B are charged. ScrollCopy40B and ScrollTransition72B;
multiple repair regions can retain64×8B in their bounded allocation. These header
sizes do not describe the entire driver allocation. Root/window ownership remains
exclusive; there is no new production unsafe, Rc/Cell/RefCell or dependency/vendor change.

Shipping code37977 lines versus37933 for copy-bounds and37372 for static sparse.
Native ELF26388320B versus26385576B and26345432B respectively. Measured unit ELFs
are61312240B,61309528B and61349728B; unit and native reachability differ. Canonical
WGSL remains18995B, SHA256 ea6e71d3da2bdb23d4971a14f0f55db389dbb45f9b2e9c05c85d4dc6363eb4d1.
Actual regular/offline GPU and native ELFs contain the checked shader artifacts.
All five unique generated SPIR-V modules validate and occur in the offline render ELF.

Ordinary submit636B/1344B local stack reservation is unchanged; ordinary retained
render2153B/664B versus2117B/664B in static sparse. Its method text is identical,
but transitive backing work can change generated code. Ordinary preparation11664B/
1496B; regional and scroll preparation11701B/1512B each. Scroll submit733B/1512B,
scroll render1851B/264B. Precise outside derivation3478B/1672B versus107B/32B for
bounding derivation. These are local prologue reservations, not total call-chain,
driver or GPU stack bounds. Full selected disassembly and whole-ELF sections remain.

## Correctness, failures and reproduction

Candidate gates:346 combined Canvas/GPU tests (3 ignored),79 offline-shader GPU
tests,1102 composed tests (45 ignored),1009 default tests (13 ignored),328 minimal
library tests (25 ignored),17 workload-port tests in each native configuration,
11 actual native scripts and4 minimal scripts. All applicable strict Clippy gates
pass. The new copy-bounds source additionally has a fresh build/unit/GPU/port/Clippy
gate; identical-source full/native qualification is preserved. Older controls retain
their independently qualified composition and native evidence explicitly.

Shared exact-pixel fixtures cover positive/negative movement, outside edits and
insertions/removals, paint order, glyph identity, images/gradients/clips, changed
clear, failed/resize recovery, pending candidates, stale image authority and region
overflow. All three formats run against the independent ordinary full GPU renderer.
Transparent CPU/HDR and translucent SDR overlaps are covered; opaque-clear SDR
admission and all existing precision/fallback rules remain unchanged.

Omission mutant d6c1efceff015d68c7deff1367c0bcb532c3f268 skips the first repair and
fails actual pixels in case0/tick1/Rgba8UnormSrgb. Authority mutant
0a0a496e4640e80797bfc89f3a82731ffd3d7043 accepts a stale predecessor for the scroll
branch; the same-window Rows fixture differs in2893 of20480 bytes, first byte62
instead of54. The intact candidate passes both witnesses. No tolerance is introduced.

Preserved failed attempts include a Paint-specific test helper used for other
models, transparent content passed to opaque BGRX/SDR APIs, and a fault attempting
to access private token fields. Corrections affect fixtures/faults and preserve
production admission. A preclean helper used Cargo's old directory pattern and
copied zero build-script files; prior executed ELFs remain preserved, with identical
canonical shader bytes verified. The missed original build-script executable is
not claimed recovered. The corrected helper preserves192 package files before
the next clean. A preferred12GiB reserve failure accidentally launched a control
build due to missing fail-fast shell behavior; that owned build was stopped,
recorded and retried successfully. The hard8GiB build monitors remain active.
Receipt selector and verifier-extension helper mistakes stopped before timing and
are retained. They change neither the fixed gates nor this failure verdict.

Executed binaries remain in canonical SHA256 storage. Completed historical target
ELF cache copies were verified in raw/compressed archives before removal; exact
path/hash/mode receipts and a restore helper remain. Only separately recorded
regenerable libraries were removed. No source, evidence or canonical binary was
deleted. All owned processes were reaped. The original checkout is unchanged.

Run `python3 reactivity/evidence/scroll-sparse/verify.py` to independently check the
manifest, complete process order/rows/counters, point estimates/bootstrap intervals,
fault witnesses, shader bytes and preserved executables/cache archives. Keep this
failed result before testing another hypothesis. The extra ordinary publication
header and generated-code changes are candidate follow-up questions, not established
causes of the two small-text failures.

Packaging audit: the first manifest omitted two nested files also named manifest.json.
Both were added to the complete manifest, and the first manifest/verification receipt
is retained. The frozen statistical verifier is unchanged. Also run
`python3 reactivity/evidence/scroll-sparse/raw/candidate/verify_manifest_coverage.py`
to check that every dossier file is covered.
