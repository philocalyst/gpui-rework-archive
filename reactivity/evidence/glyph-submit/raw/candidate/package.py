from pathlib import Path
import json,hashlib,subprocess,shutil
r=Path(__file__).parent;w=Path('/home/user/gpui-glyph-submit-lab');d=w/'reactivity/evidence/glyph-submit';raw=d/'raw';assert not raw.exists();assert not subprocess.check_output(['git','status','--porcelain'],cwd=w).strip()
s=json.loads((r/'matrix-analysis/summary.json').read_text());a=json.loads((r/'matrix-artifacts.json').read_text());verdict=json.loads((r/'matrix-analysis/verdict.json').read_text());passed=verdict['all_point_gates_pass'];fail=[(c,b,v) for c,row in s.items() for b,v in row['comparisons'].items() if not v['pass']]
report='# Static regional submission — '+('software endpoint cost gate passed' if passed else 'failed full cost gate')+'\n\n'
report+='''Local experiment, not adopted into the original checkout. Application APIs are unchanged.
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
'''
for n,v in a.items():report+=f"| {n} | {v['source']} | {v['sha256']} |\n"
report+='\n| Case | /Control | /Sparse predecessor | /Bounds | All point gates |\n|---|---:|---:|---:|---|\n'
for c,v in s.items():
 xs=[v['comparisons'][n] for n in ['control','predecessor','bounds']];report+=f'| {c} | '+' | '.join(f"{x['median_paired_ratio']:.9f}" for x in xs)+f" | {'pass' if all(x['pass'] for x in xs) else '**FAIL**'} |\n"
report+=f'\nFull registered verdict: **{"PASS" if passed else "FAIL"}**; {len(fail)} failed point comparisons.\n\n'
for c in ['stream','stream-owner']:
 v=s[c]['comparisons']['control'];report+=f"- {c}/control: {v['median_paired_ratio']:.9f},95% interval[{v['paired_bootstrap_95'][0]:.9f},{v['paired_bootstrap_95'][1]:.9f}].\n"
for c,b,v in fail:report+=f"- Failed {c}/{b}: {v['median_paired_ratio']:.9f},95% interval[{v['paired_bootstrap_95'][0]:.9f},{v['paired_bootstrap_95'][1]:.9f}].\n"
report+='''
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
'''
(r/'dossier-draft.txt').write_text(report);raw.mkdir();shutil.copytree(r,raw/'candidate',ignore=shutil.ignore_patterns('__pycache__'))
for label,source,gate in [('control',Path('/home/user/gpui-glyph-damage-control-evidence'),'cost-fixture-corrected'),('bounds',Path('/home/user/gpui-glyph-damage-bounds-evidence'),'cost-fixture-corrected'),('predecessor',Path('/home/user/gpui-glyph-damage-evidence'),'cost-fixture-lint-corrected')]:
 dest=raw/label;dest.mkdir()
 for name in [gate,'full-native','native-checks']+(['full-default'] if label=='predecessor' else []):shutil.copytree(source/name,dest/name)
(raw/'negative').mkdir()
for name,source in [('omit-region',Path('/home/user/gpui-glyph-submit-negative-evidence')),('wrong-sequence',Path('/home/user/gpui-glyph-damage-negative-evidence'))]:shutil.copytree(source/name,raw/'negative'/name)
for name,before,after in [('production','aed951bc175d7bdf624b293a95d4c05a3401849e',a['candidate']['source']),('omit-region',a['candidate']['source'],'2e5e030e64')]:
 (raw/(name+'.patch')).write_bytes(subprocess.check_output(['git','diff',before,after,'--','reactivity/crates'],cwd=w))
shutil.copy2(r/'verify_dossier.py',d/'verify.py');(d/'README.md').write_text(report)
manifest={str(p.relative_to(d)):hashlib.sha256(p.read_bytes()).hexdigest() for p in d.rglob('*') if p.is_file() and p!=d/'manifest.json'};(d/'manifest.json').write_text(json.dumps(manifest,indent=2)+'\n');print('packaged',len(manifest),'files;',len(fail),'failed point comparisons')
