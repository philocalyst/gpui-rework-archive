from pathlib import Path
import json,hashlib,re,statistics,itertools,random,gzip
root=Path(__file__).resolve().parent;c=root/'raw/candidate'
def sha(p):return hashlib.file_digest(p.open('rb'),'sha256').hexdigest()
manifest=json.loads((root/'manifest.json').read_text())
assert set(manifest)=={str(p.relative_to(root)) for p in root.rglob('*') if p.is_file() and p!=root/'manifest.json'}
for p,h in manifest.items():assert sha(root/p)==h,p
for p in (root/'raw').rglob('guard-after.json'):assert json.loads(p.read_text())==[],str(p)
def completed(d,stages):
 for s in stages:assert json.loads((d/(s+'.status.json')).read_text())['exit']==0,(d,s)
def count(p):
 rows=re.findall(r'test result: ok\. (\d+) passed; (\d+) failed; (\d+) ignored',p.read_text());return [sum(int(x[i]) for x in rows) for i in range(3)]
for n,stages,f,total in [
 ('gpu-fixture-lint',['test','clippy'],'test.out',[349,0,3]),
 ('offline-initial',['test','clippy'],'test.out',[80,0,0]),
 ('full-native-initial',['build','test','port','clippy'],'test.out',[1105,0,45]),
 ('minimal-library-initial',['unit-build','port','clippy'],'unit-build.out',[329,0,25]),
 ('default-initial',['test','clippy'],'test.out',[1011,0,13])]:
 completed(c/n,stages);assert count(c/n/f)==total,(n,count(c/n/f))
for n in ['full-native-initial','minimal-library-initial']:assert count(c/n/'port.out')==[17,0,0]
for n,total in [('native-checks-initial',11),('minimal-native-checks-initial',4)]:
 files=list((c/n).glob('*.status.json'));assert len(files)==total
 for p in files:assert json.loads(p.read_text())['exit']==0
 assert any('NATIVE_SCENE_SUPPORT,coalescing/owner/source/stale/failed-newer/full-pixels=pass' in p.read_text() for p in (c/n).glob('*.log'))
for n in ['control','bounds','predecessor']:
 completed(root/'raw/reused-controls'/n,['build','test','gpu-test','port','clippy','gpu-clippy'])
 completed(root/'raw/inherited'/n/'full-native',['build','test','port','clippy'])
 for p in (root/'raw/inherited'/n/'native-checks').glob('*.status.json'):assert json.loads(p.read_text())['exit']==0
completed(root/'raw/inherited/scroll_precise/full-native',['build','test','port','clippy'])
for p in (root/'raw/inherited/scroll_precise/native-checks').glob('*.status.json'):assert json.loads(p.read_text())['exit']==0
assert json.loads((c/'negative-omit/test.status.json').read_text())['exit']==101
assert 'complete support case=0, tick=3, format=Rgba8UnormSrgb' in (c/'negative-omit/test.log').read_text()
assert json.loads((c/'negative-omit-review.json').read_text())['test_status']==json.loads((c/'negative-omit/test.status.json').read_text())
assert json.loads((c/'negative-pending/build.status.json').read_text())['exit']==0
assert json.loads((c/'negative-pending/native.status.json').read_text())['exit']==101
fault=(c/'negative-pending/native.log').read_text()
assert 'native patch vs independent full GPU renderer' in fault
assert 'scroll_copy_tests::Rows' in fault
import ast
left=ast.literal_eval(next(x.strip()[6:] for x in fault.splitlines() if x.strip().startswith('left: [')))
right=ast.literal_eval(next(x.strip()[7:] for x in fault.splitlines() if x.strip().startswith('right: [')))
assert len(left)==len(right)==80*64*4 and left!=right
spec=json.loads((c/'cost-definition.json').read_text());cases=spec['cases'];variants=spec['variants'];assert len(cases)==28 and len(variants)==5 and spec['seed']==20261105
sequences=[]
for k in range(5):
 sequence=[(v+k)%5 for v in [0,1,4,2,3]];sequences.extend([sequence,sequence[::-1]])
sequences=sequences*2
assert all(sum(s[i]==v for s in sequences)==4 for i in range(5) for v in range(5))
assert all(sum(s.index(a)<s.index(b) for s in sequences)==10 for a,b in itertools.combinations(range(5),2))
from collections import Counter
adj=Counter((a,b) for s in sequences for a,b in zip(s,s[1:]));assert len(adj)==20 and set(adj.values())=={4}
groups=[]
for ci,case in enumerate(cases):
 for pair in range(20):groups.append([dict(case=case,pair=pair,variant=variants[v],frames=64) for v in sequences[(pair+ci)%20]])
random.Random(spec['seed']).shuffle(groups);jobs=[j for g in groups for j in g];assert jobs==json.loads((root/'PROCESS_ORDER.json').read_text());assert sha(root/'PROCESS_ORDER.json')==spec['process_manifest_sha256']
artifacts=json.loads((c/'matrix-artifacts.json').read_text())
for phase,total,frames in [('qualification',420,4),('allocations',140,4),('timing',2800,64)]:
 d=c/('matrix-'+phase);rows=json.loads((d/'results.json').read_text());assert len(rows)==total and not (d/'failure.txt').exists();assert json.loads((d/'artifacts.json').read_text())==artifacts
 expected=jobs if phase=='timing' else [dict(case=case,pair=i,variant=v,frames=4) for case in cases for i in range(3 if phase=='qualification' else 1) for v in variants]
 assert json.loads((d/'jobs.json').read_text())==expected;assert len(list(d.glob('*.status.json')))==total
 for row,job in zip(rows,expected):
  assert {k:row[k] for k in job}==job;status=json.loads((d/(row['label']+'.status.json')).read_text());assert status['exit']==0 and status['command'][0]==artifacts[row['variant']]['preserved'];assert {k:status[k] for k in job}==job
  out=(d/(row['label']+'.out')).read_text();assert '1 passed; 0 failed' in out
  assert [l[l.index('SETUP,'):].split(',')[2:] for l in out.splitlines() if 'SETUP,' in l]==[row['setup']]
  lines=[l.split(',') for l in out.splitlines() if l.startswith('ALLOC,' if phase=='allocations' else 'FRAME,')];assert row['rows']==[list(map(int,l[2:])) for l in lines];assert [x[0] for x in row['rows']]==list(range(16+frames))
  size=64 if row['case']=='flat-tiny' else 512*512 if row['case']=='flat-full' else 32*32 if row['case']=='list-tiny' else 960*720
  copied=size;image=size*4
  if row['variant'] in ['candidate','scroll_precise'] and row['case'] in ['scroll','both','list-flat','list-tiny']:
   overlap=240 if row['case']=='list-tiny' else 355120;copied+=2*overlap;image+=4*overlap
  assert all(x[6 if phase=='allocations' else 3]==copied and x[5 if phase=='allocations' else 4]==image for x in row['rows'])
 for case in cases:assert len({tuple(x['setup'][-2:]) for x in rows if x['case']==case})==1
 if phase=='timing':assert rows==[json.loads(l) for l in (d/'results.jsonl').read_text().splitlines()]
runner=json.loads((c/'runner-receipt.json').read_text());assert sha(root/'verify.py')==runner['verifier_sha256'];assert sha(c/'matrix_runs.py')==runner['timing_sha256'];assert sha(c/'analyze_matrix.py')==runner['analysis_sha256'];assert (c/'matrix_runs.py').read_bytes()==(c/'matrix-timing/runner.py').read_bytes()
rows=json.loads((c/'matrix-timing/results.json').read_text());summary=json.loads((c/'matrix-analysis/summary.json').read_text());fail=[]
def quantile(xs,q):
 a=sorted(xs);n=(len(a)-1)*q;i=int(n);return a[i]+(a[min(i+1,len(a)-1)]-a[i])*(n-i)
for case in cases:
 for baseline in [v for v in variants if v!='candidate']:
  ratios=[]
  for pair in range(20):
   medians=[]
   for v in ['candidate',baseline]:
    row=next(x for x in rows if x['case']==case and x['variant']==v and x['pair']==pair);medians.append(statistics.median(x[1] for x in row['rows'] if x[0]>=16))
   ratios.append(medians[0]/medians[1])
  point=statistics.median(ratios);limit=spec['thresholds'][case][baseline];v=summary[case]['comparisons'][baseline];assert v['median_paired_ratio']==point and v['limit']==limit and v['pass']==(point<=limit)
  rng=random.Random(spec['seed']);boot=[statistics.median(rng.choices(ratios,k=20)) for _ in range(10000)];assert v['paired_bootstrap_95']==[quantile(boot,.025),quantile(boot,.975)]
  if point>limit:fail.append((case,baseline))
# The verdict is derived from every fixed comparison; no expected pass/fail is supplied.
verdict=json.loads((c/'matrix-analysis/verdict.json').read_text());assert verdict['all_point_gates_pass']==(not fail);assert verdict['source_sha256']==sha(c/'matrix-timing/results.json')
assert json.loads((c/'shipping-lines-candidate.json').read_text())['core_non_test_code_lines']==38093
for n in variants:
 s=json.loads((c/'matrix-shader-receipt.json').read_text())[n];data=Path(artifacts[n]['preserved']).read_bytes();assert hashlib.sha256(data[s['unit_elf_offset']:s['unit_elf_offset']+s['bytes']]).hexdigest()==s['canonical_sha256']

shaders=json.loads((c/'generated-shaders/receipt.json').read_text())
for generated in shaders['generated_files']:
 saved=c/'generated-shaders'/Path(generated['saved']).name
 assert sha(saved)==generated['sha256']
for binary in shaders['binaries']:
 data=Path(binary['artifact']['preserved']).read_bytes()
 assert hashlib.sha256(data).hexdigest()==binary['artifact']['sha256']
 for item in binary['embedded']:
  assert hashlib.sha256(data[item['offset']:item['offset']+item['bytes']]).hexdigest()==item['sha256']
for item in shaders['validator']['results']:assert item['exit']==0
seen=set()
def preserved(v):
 if isinstance(v,list):
  for x in v:yield from preserved(x)
 elif isinstance(v,dict):
  if 'preserved' in v and 'sha256' in v:yield v
  for x in v.values():yield from preserved(x)
for p in (root/'raw').rglob('*.json'):
 if not any(x in p.name for x in ['artifact','receipt','summary','progress']):continue
 for a in preserved(json.loads(p.read_text())):
  h=a['sha256']
  if h not in seen:assert sha(Path(a['preserved']))==h;seen.add(h)
archive_seen=set()
for p in c.glob('archive-*/completed.json'):
 for a in json.loads(p.read_text()):
  h=a['sha256']
  if h in archive_seen:continue
  with (gzip.open(a['archive'],'rb') if a['archive_kind']=='gzip' else Path(a['archive']).open('rb')) as f:assert hashlib.file_digest(f,'sha256').hexdigest()==h
  archive_seen.add(h)
print(f'verified {len(manifest)} files, 2800 timing/420 qualification/140 allocation processes, {len(fail)} failed comparisons, {len(seen)} preserved ELFs, {len(archive_seen)} archived cache identities')
