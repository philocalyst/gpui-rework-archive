from pathlib import Path
from collections import Counter
import json,hashlib,statistics,random,re,sys
r=Path(__file__).resolve().parent
# Run against the external capture, or the self-contained copied raw directory.
def sha(p):return hashlib.file_digest(Path(p).open('rb'),'sha256').hexdigest()
def read(p):return json.loads((r/p).read_text())
if (r/'manifest.json').exists():
 manifest=read('manifest.json')
 assert set(manifest)=={str(p.relative_to(r)) for p in r.rglob('*') if p.is_file() and p!=r/'manifest.json'}
 for p,h in manifest.items():assert sha(r/p)==h,p
spec=read('cost-definition.json');cases=spec['cases'];variants=spec['variants']
assert len(cases)==len(set(cases))==28 and variants==['baseline','candidate']
assert spec['seed']==20261110 and spec['frames']==64 and spec['warmup']==16 and spec['timing_processes']==4160 and spec['bootstrap_resamples']==10000
assert spec['qualification_processes']==168 and spec['allocation_processes']==56
assert spec['header_gates']==dict(RuntimeUnit=1824,Prepared=40,TextPatch_native=96,TextResources=168,SceneDamage=40)
groups=[]
for case in cases:
 count=20 if case in ['scroll','both','stream','stream-owner'] else 120 if case in ['flat-tiny','list-tiny'] else 80
 assert spec['pairs_by_case'][case]==count and spec['thresholds'][case]=={'baseline':1.05}
 for i in range(count):groups.append([dict(case=case,pair=i,variant=v,frames=64) for v in (variants if i%2==0 else list(reversed(variants)))])
random.Random(20261110).shuffle(groups);jobs=[j for group in groups for j in group]
assert jobs==read('process-order.json') and sha(r/'process-order.json')==spec['process_manifest_sha256']
a=read('matrix-artifacts.json');assert set(a)==set(variants)
for v,x in a.items():
 for artifact in [x,x['native_artifact']]:assert sha(artifact['preserved'])==artifact['sha256']
 assert x['source']==('41a67473a0177fbb17df1f7b8e2f2f36dd6940f6' if v=='baseline' else 'df8ca59f69813e7dd05711fead98ed4278f1688d')
 assert x['cargo']['fresh'] is False
 current=read(v+'-current-inputs.json');compiled=read('compiled-build-inputs.json')[v]
 assert all(current.get(p)==h for p,h in compiled.items())
 assert compiled=={p:h for p,h in read('reference/'+v+'/inputs.json').items() if p.startswith(('reactivity/crates/','reactivity/vendor/','.cargo/')) or p in ['clippy.toml','reactivity/clippy.toml','reactivity/Cargo.toml','reactivity/Cargo.lock','reactivity/rust-toolchain.toml','rust-toolchain.toml']}
 for stage in ['build','test']:
  status=read('reference/'+v+'/'+stage+'.status.json');assert status['exit']==0
  assert all(t in status['command'] for t in ['+nightly-2026-10-23','--release','--locked','--offline','checksum-freshness'])
 assert read('reference/'+v+'/unit-artifact.json')['sha256']==x['sha256']
 assert read('reference/'+v+'/guard-after.json')==[]
 assert (r/'reference'/v/'source.txt').read_text().strip()==x['source']
 shader=read('matrix-shader-receipt.json')[v]
 for artifact,key in [(x,'unit_elf_offset'),(x['native_artifact'],'native_elf_offset')]:
  data=Path(artifact['preserved']).read_bytes();offset=shader[key]
  assert hashlib.sha256(data[offset:offset+shader['bytes']]).hexdigest()==shader['canonical_sha256']=='ea6e71d3da2bdb23d4971a14f0f55db389dbb45f9b2e9c05c85d4dc6363eb4d1'
for field in ['profile','features']:assert a['baseline']['cargo'][field]==a['candidate']['cargo'][field]
fixture=read('matrix-fixture-equality.json');assert fixture['baseline']==fixture['candidate']
base=(r/'reference/baseline/zgx_native_lab.rs').read_bytes();candidate=(r/'reference/candidate/zgx_native_lab.rs').read_bytes();ex=fixture['test_only_exception']
assert sha(r/'reference/baseline/zgx_native_lab.rs')==ex['baseline_sha256'] and sha(r/'reference/candidate/zgx_native_lab.rs')==ex['candidate_sha256']
assert candidate[:ex['removed_start']]+candidate[ex['removed_end']:]==base
assert candidate[ex['removed_start']:ex['removed_end']]==(r/'cold-visitor-test-only.rs').read_bytes()
assert sha(r/'cold-visitor-test-only.rs')==ex['removed_sha256']
for p,h in read('runner-receipt.json')['files'].items():assert sha(r/p)==h,p
allrows={}
for phase,total,frames in [('qualification',168,4),('allocations',56,4),('timing',4160,64)]:
 d=r/('matrix-'+phase);rows=json.loads((d/'results.json').read_text());allrows[phase]=rows
 assert len(rows)==total and not (d/'failure.txt').exists() and json.loads((d/'guard-after.json').read_text())==[]
 assert json.loads((d/'artifacts.json').read_text())==a
 expected=jobs if phase=='timing' else [dict(case=c,pair=i,variant=v,frames=4) for c in cases for i in range(3 if phase=='qualification' else 1) for v in variants]
 assert json.loads((d/'jobs.json').read_text())==expected and len(list(d.glob('*.status.json')))==total
 assert (d/'runner.py').read_bytes()==(r/'matrix_runs.py').read_bytes()
 for row,job in zip(rows,expected):
  assert {k:row[k] for k in job}==job
  status=json.loads((d/(row['label']+'.status.json')).read_text());assert status['exit']==0 and {k:status[k] for k in job}==job
  assert status['command']==[a[row['variant']]['preserved'],'native::scroll_bench::complete_workload_cost','--ignored','--exact','--nocapture','--test-threads=1']
  env=status['environment'];assert env['DISPLAY']==':94' and env['LP_NUM_THREADS']=='4' and env['VK_ICD_FILENAMES']=='/usr/share/vulkan/icd.d/lvp_icd.json' and env['GPUI_SCROLL_CASE']==row['case'] and env['GPUI_SCROLL_FRAMES']==str(frames)
  output=(d/(row['label']+'.out')).read_text();assert '1 passed; 0 failed' in output
  assert [l[l.index('SETUP,'):].split(',')[2:] for l in output.splitlines() if 'SETUP,' in l]==[row['setup']]
  lines=[l.split(',') for l in output.splitlines() if l.startswith('ALLOC,' if phase=='allocations' else 'FRAME,')]
  assert row['rows']==[list(map(int,l[2:])) for l in lines] and [x[0] for x in row['rows']]==list(range(16+frames))
  assert all(l[1]==row['case'] for l in lines)
  size=64 if row['case']=='flat-tiny' else 262144 if row['case']=='flat-full' else 1024 if row['case']=='list-tiny' else 691200
  overlap=(240 if row['case']=='list-tiny' else 355120) if row['case'] in ['scroll','both','list-flat','list-tiny'] else 0
  assert all(x[6 if phase=='allocations' else 3]==size+2*overlap and x[5 if phase=='allocations' else 4]==4*(size+overlap) for x in row['rows'])
 for case in cases:assert len({tuple(x['setup'][-2:]) for x in rows if x['case']==case})==1
 if phase=='timing':assert rows==[json.loads(l) for l in (d/'results.jsonl').read_text().splitlines()]
allocation=read('allocation-verdict.json');assert allocation['source_sha256']==sha(r/'matrix-allocations/results.json')
allocpass=[]
for case in cases:
 for pair in range(3):
  byvariant={x['variant']:x for x in allrows['qualification'] if x['case']==case and x['pair']==pair}
  assert all(c[2]<=b[2] and c[3:]==b[3:] for c,b in zip(byvariant['candidate']['rows'],byvariant['baseline']['rows']))
 for i,field in enumerate(['requests','requested_bytes','net_bytes','peak_bytes'],1):
  values={v:statistics.median(frame[i] for x in allrows['allocations'] if x['case']==case and x['variant']==v for frame in x['rows'] if frame[0]>=16) for v in variants}
  passed=values['candidate']<=values['baseline'];allocpass.append(passed)
  assert allocation['gates'][case][field]==dict(reference=values['baseline'],candidate=values['candidate'],passed=passed)
assert allocation['all_pass']==all(allocpass)==True
for v in variants:
 headers={}
 for p in (r/'headers').glob(v+'-*'):
  if p.suffix in ['.out','.log']:headers.update({k:int(n) for k,n in re.findall(r'([A-Za-z_]+)=(\d+)',p.read_text())})
 for k,n in spec['header_gates'].items():assert headers['TextPatch' if k=='TextPatch_native' else k]==n
for p in (r/'headers').glob('*.status.json'):
 status=json.loads(p.read_text());assert status['exit']==0 and '1 passed; 0 failed' in p.with_name(p.name.replace('.status.json','.out')).read_text()
summary=read('matrix-analysis/summary.json');fail=[]
def quantile(xs,q):
 s=sorted(xs);at=(len(s)-1)*q;lo=int(at);return s[lo]+(s[min(lo+1,len(s)-1)]-s[lo])*(at-lo)
for case in cases:
 ratios=[]
 for pair in range(spec['pairs_by_case'][case]):
  med={x['variant']:statistics.median(f[1] for f in x['rows'] if f[0]>=16) for x in allrows['timing'] if x['case']==case and x['pair']==pair}
  ratios.append(med['candidate']/med['baseline'])
 point=statistics.median(ratios);v=summary[case]['comparisons']['baseline']
 assert v['median_paired_ratio']==point and v['limit']==1.05 and v['pass']==(point<=1.05)
 rng=random.Random(20261110);boot=[statistics.median(rng.choices(ratios,k=len(ratios))) for _ in range(10000)]
 assert v['paired_bootstrap_95']==[quantile(boot,.025),quantile(boot,.975)]
 if point>1.05:fail.append(case)
verdict=read('matrix-analysis/verdict.json');assert verdict['all_point_gates_pass']==(not fail) and verdict['source_sha256']==sha(r/'matrix-timing/results.json')
print(json.dumps(dict(verified_files=len(manifest) if 'manifest' in globals() else None,timing_processes=4160,qualification_processes=168,allocation_processes=56,failed_comparisons=fail,all_point_gates_pass=not fail),indent=2))
