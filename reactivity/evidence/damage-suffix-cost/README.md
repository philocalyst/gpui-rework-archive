# Exact suffix regression gate: all28 fixed comparisons pass

Production source **df8ca59f69813e7dd05711fead98ed4278f1688d** completes the
pre-implementation0a7f3b82 and continuation64e90ba23d protocol. All4,160 timing,
168 qualification and56 allocation processes finish normally. No retries,
subsets, source changes, threshold changes or concurrent builds/analysis during
timing. Independent verification rederives the complete schedule, raw observations,
allocation/work/header gates, paired ratios and bootstrap intervals.

This qualifies a local startup improvement with no application API change; it
is not a ZGX victory. Native startup dossier **bea6c4cf9135f494925ccd80b05f584e20fe7ff4**
separately verifies16/16 candidate runs at479 updates/8s and one first-second
ACK gap>25ms, versus baseline445–455 updates and17 gaps. The new change trims
an exactly unchanged suffix when draw counts differ and retains both supports
at the first unequal reverse pair. Correctness and bounded mutant dossier:
**380db598cdbed2dd81c5a41745473c40a876f148**. No new shader, dependency, storage,
unsafe code or custom async runtime is introduced.

## Fixed complete-operation measurements

Each timing process performs16 warmups and64 measured owner→native packet→GPU
completion→ACK operations. The estimator is the median of paired process-p50
ratios, candidate/baseline. Every point must be<=1.05.10,000 paired bootstrap
resamples use seed20261110 reset per case and type7 intervals. Some intervals
cross1.05; a passing point gate does not establish a statistical upper bound.
Cold mount, first presentation, first update, p95 and p99 remain separately
reported in raw/matrix-analysis/processes.json and summary.json.

| Case | Paired median ratio | Bootstrap95% interval | Fixed gate |
| --- | ---: | --- | --- |
| scroll | 1.012279115 | [0.965472447, 1.048415303] | pass |
| both | 0.988990942 | [0.918458539, 1.052465499] | pass |
| stream | 1.019494719 | [0.995684912, 1.032240208] | pass |
| stream-owner | 0.979462007 | [0.961285162, 1.019429027] | pass |
| fractional | 1.001441884 | [0.997321792, 1.006043927] | pass |
| flat-tiny | 1.010222976 | [0.980388041, 1.061096049] | pass |
| flat-full | 0.992415458 | [0.968711346, 1.012528134] | pass |
| list-tiny | 1.000834802 | [0.957853839, 1.062705145] | pass |
| list-flat | 1.007232073 | [0.971350237, 1.041385978] | pass |
| exposure | 0.997630379 | [0.981577117, 1.023090505] | pass |
| text-0-1-source | 1.009498434 | [0.993559133, 1.031387525] | pass |
| text-0-1-owner | 1.014419535 | [0.978040969, 1.036395986] | pass |
| text-0-2-source | 0.998879117 | [0.970280510, 1.024108358] | pass |
| text-0-2-owner | 0.991352698 | [0.971389977, 1.014688116] | pass |
| text-0-4-source | 0.991022341 | [0.964420559, 1.006064448] | pass |
| text-0-4-owner | 0.996654954 | [0.970091190, 1.016347361] | pass |
| text-25-1-source | 1.003913515 | [0.985247897, 1.019666420] | pass |
| text-25-1-owner | 0.985345593 | [0.969547691, 1.017637440] | pass |
| text-25-2-source | 1.007119246 | [0.986268584, 1.029126367] | pass |
| text-25-2-owner | 0.989116072 | [0.965998857, 1.027709466] | pass |
| text-25-4-source | 0.981652414 | [0.963195858, 1.002369397] | pass |
| text-25-4-owner | 0.987385677 | [0.960878059, 1.021844394] | pass |
| text-1000-1-source | 0.995714159 | [0.963867047, 1.010841787] | pass |
| text-1000-1-owner | 1.014287421 | [0.997742089, 1.027162965] | pass |
| text-1000-2-source | 0.993466166 | [0.981065991, 1.021806138] | pass |
| text-1000-2-owner | 0.989927766 | [0.982779264, 1.018935668] | pass |
| text-1000-4-source | 0.998421888 | [0.984455097, 1.013528667] | pass |
| text-1000-4-owner | 0.973507727 | [0.961129075, 1.003901983] | pass |

All112 allocation comparisons pass: warm medians of invoking-thread requests,
requested bytes, net bytes and peak bytes never exceed baseline across28 cases.
These probes do not measure total process/driver/GPU allocations. Mount, first
presentation and first-update allocations are retained separately.

All qualification frames retain exact final pixel hashes and source epochs.
Candidate composited support never exceeds baseline; copy pixels and retained
image bytes remain exactly equal, including both overlap copies and scratch.
RuntimeUnit1824, Prepared40, native TextPatch96, TextResources168 and SceneDamage40
byte headers remain unchanged. Timed benchmark and cost functions are byte-equal;
only the separately qualified cfg(test) cold-stream visitor differs in the
example, with the exact removed block and byte-equal remainder preserved.

## Provenance and limits

Baseline unit was compiled from41a67473 and candidate fromdf8ca59f, using the
same repository-default release profile, features and toolchain. Executed unit
ELFs are61,399,440 and61,436,168 bytes. Default-release native ELFs are26,389,256
and26,390,120 bytes. Shipping lines grow38,016→38,028. Hot routine code/stack costs
and the full fresh-build/strict-Clippy/native/pixel mutant gates are in the
qualification dossier. This trial reuses those independently qualified exact
ELFs; it does not claim that later documentation commits were compiled.

Clean production-identical source checkouts currenta34b61c8 and380db598c are
recorded separately from compiled sources. All actual recorded build inputs,
complete present source inventories, scripts, executable hashes and embedded
canonical shaders are checked before/after. No evidence archive or preserved ELF
is deleted. Completed native-profile libraries were removed only after verifying
bea6c4cf's sealed manifest; receipts remain in raw. The first freeze attempt used
an incorrect target ancestor and stopped before observations; its script/log and
corrected attempt are preserved. No benchmark run was repeated for that setup fix.

Private X11:94 and llvmpipe software Vulkan, four raster threads, AMD9950X KVM
8-vCPU guest. Fresh process/object observations do not imply cold disk shader
cache. Hardware GPU, scanout, two-hardware-class and visual quality gates remain
open. The earlier native-workspace scroll/mixed CPU ratios8.07/6.06 versus ZGX
remain failures. No broad adoption or overall performance superiority follows
from this local startup/regression qualification. All changes remain local.

Run `python3 raw/verify_dossier.py` to verify the manifest and every fixed result.
Exact preserved ELF paths are in raw/matrix-artifacts.json. The verifier was
frozen before any cost observation; no expected pass/fail is supplied to it.
