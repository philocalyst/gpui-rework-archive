from pathlib import Path
import json,shutil,subprocess,hashlib
from guard import guard,frozen
r=Path(__file__).parent;w=Path('/home/user/gpui-damage-suffix-cost-lab');d=w/'reactivity/evidence/damage-suffix-cost';raw=d/'raw'
assert not guard();frozen()
assert not raw.exists();raw.mkdir()
for p in r.iterdir():
 if p.name=='__pycache__':continue
 if p.is_dir():shutil.copytree(p,raw/p.name)
 else:shutil.copyfile(p,raw/p.name)
summary=json.loads((r/'matrix-analysis/summary.json').read_text());allocation=json.loads((r/'allocation-verdict.json').read_text())
rows=[]
for case,s in summary.items():
 v=s['comparisons']['baseline'];ci=v['paired_bootstrap_95'];rows.append(f"| {case} | {v['median_paired_ratio']:.9f} | [{ci[0]:.9f}, {ci[1]:.9f}] | {'pass' if v['pass'] else 'FAIL'} |")
text='''# Exact suffix regression gate: all28 fixed comparisons pass

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
'''+ '\n'.join(rows)+'''

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
'''
(d/'README.md').write_text(text)
sha=lambda p:hashlib.file_digest(p.open('rb'),'sha256').hexdigest()
manifest={str(p.relative_to(raw)):sha(p) for p in raw.rglob('*') if p.is_file()}
(raw/'manifest.json').write_text(json.dumps(manifest,indent=2));print('Packaged',len(manifest),'raw files')
