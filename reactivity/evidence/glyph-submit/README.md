# Static regional submission — failed full cost gate

Local experiment, not adopted into the original checkout. Application APIs are unchanged.
This isolates regional GPU submission at compile time, restoring ordinary Output,
retained render, backing output/stats and submit source bodies from the qualified
bounding-only control. A private static Submission trait selects ordinary or
regional submission at the existing generic preparation boundary. Preparation,
validation, submission and packet publication retain their order. No trait object,
executor, persistent field, shader change, dependency change or unsafe code.

BBTree motivates caller-type isolation and charging small-workload costs; this is
not evidence that asynchronous memory scheduling helps GPUI. Solid/Ripple's precise
publication lessons remain in the inherited exact-image authority and local damage
proofs. The earlier sparse-repair trial's six failed point comparisons remain sealed
at227a0567f912719d741a609c18b76f7f16d0e6c3. This trial was separately preregistered at
7d62be8d3f before implementation669487c35d and before any timing.

No hardware-GPU, cache-hit, ZGX or display-scanout victory follows. The endpoint is
public Win model operations through native GPU completion and ACK on llvmpipe,
LP_NUM_THREADS=4/private X11 :94. It excludes producer/OS dispatch, active NativeHost
accessibility projection, WSI/scanout and device startup. Hardware and remaining
ZGX task/input/render-quality/profile equivalence gates remain open.

## Fixed complete matrix

28 cases ×24 balanced four-process groups =2688 fresh timing processes. All24
variant permutations appear once per case; group shuffle seed20261031. Each process
has16 warmup and64 measured updates (172032 measured updates total). The estimator
is the median of24 paired process-p50 ratios; type7 quantiles and10000-resample
paired bootstrap95% intervals use seed20261031. Unpaired quotients, raw tails, cold
mount/first image/first update remain separate. No pair or case is discarded.

Candidate/control must be <=0.8 for stream and stream-owner, <=1.05 for every other
case; candidate/predecessor and candidate/bounds must be <=1.05 for every case.
Control is corrected original full publication, bounds is precise glyph bounding
repair, predecessor is the failed bounded sparse repair. Immutable preserved
comparator executables are reused; build caches are never shared with the candidate.
All variants have identical fixtures, shader sources and the exact image-authority
prerequisite. No builds/tests/allocations/source edits/cleanup overlap timing.

| Variant | Measured source | Executable SHA256 |
|---|---|---|
| control | bb83c5d8f3da446d4cc1c259141f335797b1b60d | 140a754feaf0715d09d37632e9292a141eac748f6c7045056da45fcbc0d26302 |
| bounds | be8300c1e3eafacedfa20c062bf2e31ed1ada9ca | 44bfdf22e404210b3d27977157a3da2890c32601b67199c52400409e329079d6 |
| predecessor | aed951bc175d7bdf624b293a95d4c05a3401849e | 42a031b65e2555336d04a696951efc276f9d1803f18cf14f04847b3121b466be |
| candidate | 669487c35d557d4cb480cfd519bb7476a07c4459 | 42b7264027bac0fcb38a215f985e8c40149d4a21963be0cc6b1386a2e8b3959d |

| Case | /Control | /Sparse predecessor | /Bounds | All point gates |
|---|---:|---:|---:|---|
| scroll | 0.997969464 | 1.004109225 | 1.007703204 | pass |
| both | 1.004143351 | 0.999707821 | 0.996646025 | pass |
| stream | 0.108943940 | 0.986666412 | 0.108172212 | pass |
| stream-owner | 0.106217773 | 1.009843302 | 0.106882352 | pass |
| fractional | 0.992506789 | 0.999597348 | 0.993578529 | pass |
| flat-tiny | 0.993990728 | 1.066663744 | 0.958555420 | **FAIL** |
| flat-full | 1.012678226 | 0.984793096 | 0.996874994 | pass |
| list-tiny | 1.037640463 | 1.029504164 | 1.002640940 | pass |
| list-flat | 1.009368623 | 0.986467880 | 1.011140912 | pass |
| exposure | 0.999710786 | 0.998914645 | 1.014412295 | pass |
| text-0-1-source | 0.985246179 | 1.028313906 | 1.017632336 | pass |
| text-0-1-owner | 0.983158305 | 1.016163162 | 0.970247551 | pass |
| text-0-2-source | 1.003248281 | 0.989360314 | 1.006228090 | pass |
| text-0-2-owner | 0.991246839 | 0.964333356 | 0.992758807 | pass |
| text-0-4-source | 1.014417888 | 0.983752792 | 1.024937471 | pass |
| text-0-4-owner | 1.029807097 | 1.042574917 | 1.027725779 | pass |
| text-25-1-source | 1.006860712 | 1.000547055 | 0.997401372 | pass |
| text-25-1-owner | 0.993648349 | 1.013962244 | 1.053730811 | **FAIL** |
| text-25-2-source | 0.993236498 | 1.002500522 | 0.986773096 | pass |
| text-25-2-owner | 1.003036482 | 1.009007119 | 0.975687657 | pass |
| text-25-4-source | 1.007337882 | 0.983805076 | 1.011092911 | pass |
| text-25-4-owner | 0.985608336 | 1.015025262 | 0.988841377 | pass |
| text-1000-1-source | 0.987900628 | 0.981184119 | 0.980404273 | pass |
| text-1000-1-owner | 0.798035292 | 1.032464842 | 1.023565146 | pass |
| text-1000-2-source | 1.000863183 | 0.983819663 | 0.994869372 | pass |
| text-1000-2-owner | 1.027080843 | 1.013851395 | 1.004965206 | pass |
| text-1000-4-source | 1.004757622 | 1.010675279 | 0.973501921 | pass |
| text-1000-4-owner | 1.043858519 | 1.034416534 | 1.012689253 | pass |

Full registered verdict: **FAIL**; 2 failed point comparisons.

- stream/control: 0.108943940,95% interval[0.104224052,0.111295456].
- stream-owner/control: 0.106217773,95% interval[0.103804908,0.110667075].
- Failed flat-tiny/predecessor: 1.066663744,95% interval[0.871492962,1.147115333].
- Failed text-25-1-owner/bounds: 1.053730811,95% interval[1.008951212,1.083360896].

Intervals do not waive failed point gates. The full raw matrix, individual frame
records, process p50/p95/p99, paired ratios and cold results are retained. No
successful subset substitutes for the complete verdict.

## Correctness and costs

Fresh qualification:1087 composed GPUI/Canvas tests (45 ignored),10 workload-port
tests,75 GPU tests including all three formats,320 minimal-native library tests
(25 ignored),11 actual native scripts,4 minimal-native scripts and strict Clippy.
Default non-native production qualification is inherited explicitly from the sealed
predecessor: only GPU files changed;1008 tracked GPUI/Canvas/core/state files match
byte for byte. The predecessor's1001 default tests and unchanged exact-sequence
native pixel mutant are retained as inherited evidence, not rerun claims.

The expanded public GPU test rejects invalid multi-region bounds without backing
and across resize, revokes image authority before failed admission, recovers with
full compositing, and checks actual pixels. A fresh omitted-region mutant fails
actual RGBA pixels on the new static route. All source guards are clean. Before
timing,336 correctness and112 allocation processes cover every variant/case and
pass independent full-GPU pixels, small-case fresh-owner CPU pixels, model/epoch
checks and full-copy/image counters. Typed/generated shader equality and exact
shader bytes in each measured ELF are verified separately.

Static isolation costs11 shipping source lines over the sparse predecessor:
37372 versus37361 (original36956, bounds37149). No retained field is added. Header
probes remain in cost-fixture raw logs. Output40, Backing112, RetainedRenderer920,
Renderer888, Runtime<()>1824 and GpuSurface1040 bytes remain unchanged. Region
capacity, packet rebuilding and the complete backing image/copy are unchanged.
All warm/cold requested allocations and invoking-thread peak/net bytes are in
matrix-allocation-summary.json; these are not total driver/process memory.

The shipping native example grows26306728→26319560 bytes (+12832). Ordinary submit
returns to636 bytes/1344 explicit local stack bytes; retained render returns to
2117/664, matching the bounds control. Regional render is663/120, regional submit
592/1320. There are now two preparation routines:11656 and11672 bytes, each with
1496 bytes of explicit local stack reservation; predecessor has one11656/1496
routine. Prologue reservations exclude pushes, callees and driver stacks. Complete
section sizes, selected functions and disassembly remain in machine-four-way-complete.
The first symbol extraction omitted generic routines whose names contain a closure;
its output is retained alongside the corrected extraction. Matching body size is
not proof of equal performance or a diagnosis of prior regressions.

Source hashes, immutable measured/executed ELFs, failed-mutant logs, cleanup receipts
and all raw processes are preserved locally. Run `python3
reactivity/evidence/glyph-submit/verify.py` for independent manifest/process/verdict/
ELF checks. The original checkout is untouched and no changes are pushed.
