from pathlib import Path
import json,hashlib,random,shutil
r=Path(__file__).parent;d=Path('/home/user/gpui-damage-suffix-cost-lab/reactivity/evidence/damage-suffix-cost');d.mkdir()
old=json.loads(Path('/home/user/gpui-patch-workspace-evidence/cost-definition.json').read_text());cases=old['cases'];variants=['baseline','candidate'];pairs=old['pairs_by_case'];groups=[]
for case in cases:
 for pair in range(pairs[case]):groups.append([dict(case=case,pair=pair,variant=v,frames=64) for v in (variants if pair%2==0 else variants[::-1])])
random.Random(20261110).shuffle(groups);jobs=[j for g in groups for j in g];assert len(jobs)==4160
order=json.dumps(jobs,indent=2).encode();(r/'process-order.json').write_bytes(order);(d/'PROCESS_ORDER.json').write_bytes(order)
spec=dict(cases=cases,variants=variants,pairs_by_case=pairs,seed=20261110,frames=64,warmup=16,timing_processes=4160,bootstrap_resamples=10000,thresholds={c:{'baseline':1.05} for c in cases},process_manifest_sha256=hashlib.sha256(order).hexdigest(),qualification_processes=168,allocation_processes=56,header_gates={'RuntimeUnit':1824,'Prepared':40,'TextPatch_native':96,'TextResources':168,'SceneDamage':40},allocation_gates={'reference':'baseline','cases':cases,'fields':['requests','requested_bytes','net_bytes','peak_bytes'],'rule':'candidate warm medians no greater than baseline'},work_gates='Exact final pixels/epochs; identical copied pixels/image storage; candidate composited pixels <= baseline in every qualification frame. Support may shrink, model work may not.')
(r/'cost-definition.json').write_text(json.dumps(spec,indent=2));(d/'COST.json').write_text(json.dumps(spec,indent=2))
(d/'PROTOCOL.md').write_text('''# Exact suffix complete regression matrix — continuation

The original pre-implementation protocol0a7f3b822b09744e7e45a1ac9961d8aaa183a416
specified this28-case4160-process gate after startup qualification. Production
source df8ca59f69813e7dd05711fead98ed4278f1688d passes correctness/code-cost dossier
380db598cdbed2dd81c5a41745473c40a876f148 and the native startup screen sealed at
bea6c4cf9135f494925ccd80b05f584e20fe7ff4. All16 candidate native runs achieve479
updates/8s and one first-second gap>25ms; baseline445–455 and17 gaps. No earlier
failed cohort changes. No ZGX/hardware victory or adoption.

Local branch/worktree local/damage-suffix-cost at /home/user/gpui-damage-suffix-cost-lab;
external /home/user/gpui-damage-suffix-cost-evidence. No compilation or new target:
reuse the exact independently qualified repository-default-release unit ELFs.
Baseline compiled41a67473 uses a clean production-identical checkout at
/home/user/gpui-native-phase-lab (own diagnostic documents differ). Candidate
compileddf8ca59f uses /home/user/gpui-damage-suffix-lab (own qualification documents
differ). Record compiled and current source separately, validate every recorded
build input and Git diff across crates/vendors/manifests/.cargo, then freeze the
entire present source inventory. All hashes must survive through the last run.
The evidence worktree is separate from both frozen executable source checkouts.

Benchmark scroll_bench.rs, text_cost.rs, shared Workload and all actual CostFixture
functions are unchanged. The candidate example adds only the cfg(test) cold-stream
visitor exercised in qualification; preserve that exact source difference and
verify the remainder byte-for-byte. It is never called by the timed benchmark.
Record exact profile/features/toolchain/shader and actual ELF identities. No
application/API/shader/dependency change in this trial.

COST.json and PROCESS_ORDER.json instantiate the already specified seed20261110:
20 paired groups for scroll/both/stream/stream-owner,120 for flat-tiny/list-tiny,
80 for every other22 cases. Alternating AB/BA pairs per case, all2080 complete
groups shuffled together.4160 fresh processes,16 warmups and64 measured complete
owner→native packet→GPU completion→ACK operations each. No new benefit threshold:
the new primary benefit is startup, already separately qualified. Every28 paired
median process-p50 ratio candidate/baseline must be<=1.05. Report10000 paired
bootstrap draws/type7 intervals, seed reset per case; uncertainty never waives
the fixed point gate. Report cold mount/first frame/update and p95/p99 separately.

Before timing,168 qualification and56 invoking-thread allocation processes:
three qualification repetitions and one allocation probe per case/variant,
16 warmups+4 observed updates each. Exact output hashes and source epochs are
mandatory. Copy pixels and retained image bytes remain equal; charge both scroll
overlap copies and scratch. Smaller composited support is allowed for this damage
algorithm, but never more composited pixels in any qualification frame and never
reduced model work. Require warm medians of requests/requested bytes/net bytes/peak
bytes no greater than baseline in all28 cases. These are invoking-thread allocator
measurements, not total process/driver/GPU memory. The unchanged headers are
mandatory. All gates, fallbacks and work counts remain visible.

Freeze runner, analyzer, allocation/work checker and independent verifier before
observations. Preserve every failure without retries or passing subsets. If any
qualification gate fails, stop before timing and retain the failure. All groups
in a started timing schedule must be retained; execution or resource failure
invalidates the trial rather than selecting completed pairs. Source guards and
exact artifact identities before/after are mandatory. Keep8GiB free, reclaim only
completed verified caches before timing, no builds/tests/edits/analysis/cleanup
during timing. Software Vulkan/private X11 :94, LP_NUM_THREADS=4, same environment
and unchanged fixture. No physical GPU/scanout/quality or ZGX claim follows this
local regression gate. All changes remain local; the overall goal stays active.
''')
s=Path('/home/user/gpui-damage-suffix-native-evidence/cleanup_qualified_libraries.py').read_text().replace("w=Path('/home/user/gpui-damage-suffix-lab')","w=Path('/home/user/gpui-damage-suffix-native-lab')").replace("target=Path('/home/user/gpui-damage-suffix-target')","target=Path('/home/user/gpui-damage-suffix-native-target')").replace('380db598cdbed2dd81c5a41745473c40a876f148','bea6c4cf9135f494925ccd80b05f584e20fe7ff4').replace("d=w/'reactivity/evidence/damage-suffix-qualification'","d=w/'reactivity/evidence/damage-suffix-native'");(r/'cleanup_native_libraries.py').write_text(s)
print('frozen schedule prepared',len(jobs),'processes',spec['process_manifest_sha256'])
