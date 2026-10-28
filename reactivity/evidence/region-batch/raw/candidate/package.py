from pathlib import Path
import json,hashlib,subprocess,shutil
r=Path(__file__).parent;w=Path('/home/user/gpui-region-batch-lab');d=w/'reactivity/evidence/region-batch';raw=d/'raw';assert not raw.exists();assert not subprocess.check_output(['git','status','--porcelain'],cwd=w).strip()
s=json.loads((r/'matrix-analysis/summary.json').read_text());a=json.loads((r/'matrix-artifacts.json').read_text());assert not json.loads((r/'matrix-analysis/verdict.json').read_text())['all_point_gates_pass']
report='''# Certified region batching — rejected

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
'''
for n,v in a.items():report+=f"| {n} | {v['source']} | {v['sha256']} |\n"
report+='\n| Case | /Original | /Static sparse | /Bounds | Point gates |\n|---|---:|---:|---:|---|\n'
for case,row in s.items():
 values=[row['comparisons'][v] for v in ['control','predecessor','bounds']];report+=f'| {case} | '+' | '.join(f"{v['median_paired_ratio']:.9f}" for v in values)+f" | {'pass' if all(v['pass'] for v in values) else '**FAIL**'} |\n"
report+='\nThe complete registered verdict is **FAIL**, with two failed comparisons.\n\n'
for case in ['stream','stream-owner']:
 q=s[case]['comparisons']['predecessor'];report+=f"- {case}/static sparse: {q['median_paired_ratio']:.9f},95% interval[{q['paired_bootstrap_95'][0]:.9f},{q['paired_bootstrap_95'][1]:.9f}].\n"
report+='\n| Streaming route | Candidate warm p50 | Static warm p50 | Candidate first update | Static first update |\n|---|---:|---:|---:|---:|\n'
for case in ['stream','stream-owner']:
 v=s[case]['variants'];report+=f"| {case} | {v['candidate']['p50_ns']/1e6:.6f}ms | {v['predecessor']['p50_ns']/1e6:.6f}ms | {v['candidate']['first_update_ns']/1e6:.6f}ms | {v['predecessor']['first_update_ns']/1e6:.6f}ms |\n"
report+='''
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
'''
(r/'dossier-draft.txt').write_text(report);raw.mkdir();shutil.copytree(r,raw/'candidate',ignore=shutil.ignore_patterns('__pycache__'))
for label,source in [('control','/home/user/gpui-glyph-damage-control-evidence'),('bounds','/home/user/gpui-glyph-damage-bounds-evidence'),('predecessor','/home/user/gpui-glyph-submit-evidence')]:
 for part in ['full-native','native-checks']:shutil.copytree(Path(source)/part,raw/'inherited'/label/part)
shutil.copytree('/home/user/gpui-glyph-damage-evidence/full-default',raw/'inherited/default');shutil.copytree('/home/user/gpui-glyph-damage-negative-evidence/wrong-sequence',raw/'inherited/wrong-sequence')
for name,before,after in [('production','c965a893364b46f965c83d10e2cf94a46dac1304','1f16b73c56f10044a4186c90fb69ffe3d4047ac6'),('omit-instance','1f16b73c56f10044a4186c90fb69ffe3d4047ac6','e19fec3f026969df96504d706e556b6d20d90b7b')]:
 (raw/(name+'.patch')).write_bytes(subprocess.check_output(['git','diff',before,after,'--','reactivity/crates'],cwd=w))
research=Path('/home/user/gpui-architecture-local')
for name in ['COST.md','COST.json','PROCESS_ORDER.json']:(d/name).write_bytes(subprocess.check_output(['git','show','6f1cf9e1ae170bcffef62665b3b3f91c22e880ab:reactivity/evidence/region-batch/'+name],cwd=research))
shutil.copy2(r/'verify_dossier.py',d/'verify.py');(d/'README.md').write_text(report)
manifest={str(p.relative_to(d)):hashlib.file_digest(p.open('rb'),'sha256').hexdigest() for p in d.rglob('*') if p.is_file() and p.name!='manifest.json'};(d/'manifest.json').write_text(json.dumps(manifest,indent=2)+'\n');print('packaged',len(manifest),'files')
