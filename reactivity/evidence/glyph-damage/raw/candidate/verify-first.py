from pathlib import Path
import json,hashlib,re,statistics,itertools,random,gzip
root=Path(__file__).resolve().parent; raw=root/'raw'; c=raw/'candidate'
manifest=json.loads((root/'manifest.json').read_text())
for n,h in manifest.items():assert hashlib.sha256((root/n).read_bytes()).hexdigest()==h,n
for p in raw.rglob('guard-after.json'):assert json.loads(p.read_text())==[],str(p)
def completed(d,stages):
 for stage in stages:assert json.loads((d/(stage+'.status.json')).read_text())['exit']==0,(d,stage)
def totals(p):
 rows=re.findall(r'test result: ok\. (\d+) passed; (\d+) failed; (\d+) ignored',p.read_text())
 return [sum(int(row[i]) for row in rows) for i in range(3)]
for name,stages,file,total in [('full-default',['test','clippy'],'test.out',[1001,0,13]),('full-native',['build','test','port','clippy'],'test.out',[1086,0,45]),('gpu-full',['test','clippy'],'test.out',[74,0,0]),('minimal-library',['unit-build','clippy'],'unit-build.out',[319,0,25])]:
 completed(c/name,stages);assert totals(c/name/file)==total,(name,totals(c/name/file))
for name,count in [('control',1075),('predecessor',1083),('bounds',1085)]:
 completed(raw/name/'full-native',['build','test','port','clippy']);assert totals(raw/name/'full-native/test.out')==[count,0,45]
for name in ['candidate','control','predecessor','bounds']:
 d=raw/name;assert '10 passed; 0 failed' in (d/'full-native/port.out').read_text()
 p=d/'native-checks';a=list(p.glob('*.status.json'));assert len(a)==11
 for status in a:assert json.loads(status.read_text())['exit']==0
 assert 'NATIVE_TEXT_REPAIR,stale-predecessor/coalescing/failed-newer/full-pixels=pass' in (p/'native-5.log').read_text()
 gate='cost-fixture-lint-corrected' if name=='candidate' else 'cost-fixture-corrected';completed(d/gate,['test','clippy','gpu-headers','gpu-clippy'])
a=list((c/'minimal-native-checks').glob('*.status.json'));assert len(a)==4
for p in a:assert json.loads(p.read_text())['exit']==0
assert json.loads((raw/'negative/omit-region/test.status.json').read_text())['exit']==101
assert 'assertion `left == right` failed: Rgba8UnormSrgb' in (raw/'negative/omit-region/test.log').read_text()
assert json.loads((raw/'negative/wrong-sequence/test.status.json').read_text())['exit']==101
assert 'native sparse text differs from full GPU after publication transition' in (raw/'negative/wrong-sequence/test.log').read_text()
# Preserve real positive failures and the fixture-only correction trail.
assert json.loads((c/'cost-fixture-first/clippy.status.json').read_text())['exit']==101
assert json.loads((c/'authority-first/test.status.json').read_text())['exit']==101
assert json.loads((raw/'control/authority-before/test.status.json').read_text())['exit']==101
assert json.loads((raw/'control/authority-after/test.status.json').read_text())['exit']==0
spec=json.loads((c/'cost-definition.json').read_text());cases=spec['cases'];variants=spec['variants'];assert len(cases)==28 and len(variants)==4
perms=list(itertools.permutations(sorted(variants)));groups=[]
for ci,case in enumerate(cases):
 for pair in range(24):groups.append([dict(case=case,pair=pair,variant=v,frames=64) for v in perms[(pair+ci)%24]])
random.Random(20261030).shuffle(groups);jobs=[j for group in groups for j in group]
assert jobs==json.loads((root/'PROCESS_ORDER.json').read_text())
assert hashlib.sha256((root/'PROCESS_ORDER.json').read_bytes()).hexdigest()==spec['process_manifest_sha256']
artifacts=json.loads((c/'matrix-artifacts.json').read_text())
for phase,count,frames in [('qualification',336,4),('allocations',112,4),('timing',2688,64)]:
 d=c/('matrix-'+phase);rows=json.loads((d/'results.json').read_text());assert len(rows)==count and not (d/'failure.txt').exists()
 assert json.loads((d/'artifacts.json').read_text())==artifacts
 expected=jobs if phase=='timing' else [dict(case=case,pair=i,variant=v,frames=4) for case in cases for i in range(3 if phase=='qualification' else 1) for v in variants]
 assert json.loads((d/'jobs.json').read_text())==expected
 assert len(list(d.glob('*.status.json')))==count
 for row,job in zip(rows,expected):
  assert {k:row[k] for k in job}==job
  status=json.loads((d/(row['label']+'.status.json')).read_text());assert status['exit']==0 and status['command'][0]==artifacts[row['variant']]['preserved']
  assert {k:status[k] for k in job}==job
  s=(d/(row['label']+'.out')).read_text();assert '1 passed; 0 failed' in s
  setup=[line[line.index('SETUP,'):].split(',')[2:] for line in s.splitlines() if 'SETUP,' in line];assert setup==[row['setup']]
  lines=[line.split(',') for line in s.splitlines() if line.startswith('ALLOC,' if phase=='allocations' else 'FRAME,')]
  assert row['rows']==[list(map(int,line[2:])) for line in lines]
  assert [x[0] for x in row['rows']]==list(range(16+frames))
  size=64 if row['case']=='flat-tiny' else 512*512 if row['case']=='flat-full' else 32*32 if row['case']=='list-tiny' else 960*720
  assert all(x[6 if phase=='allocations' else 3]==size and x[5 if phase=='allocations' else 4]==size*4 for x in row['rows'])
 for case in cases:assert len({tuple(row['setup'][-2:]) for row in rows if row['case']==case})==1
 if phase=='timing':assert rows==[json.loads(line) for line in (d/'results.jsonl').read_text().splitlines()]
definition=json.loads((c/'matrix-analysis-definition.json').read_text())
assert hashlib.sha256((c/'analyze_matrix.py').read_bytes()).hexdigest()==definition['analysis_sha256']
assert hashlib.sha256((c/'matrix-timing/runner.py').read_bytes()).hexdigest()==definition['run_driver_sha256']
assert (c/'matrix_runs.py').read_bytes()==(c/'matrix-timing/runner.py').read_bytes()
rows=json.loads((c/'matrix-timing/results.json').read_text());summary=json.loads((c/'matrix-analysis/summary.json').read_text());fail=[]
for case in cases:
 for baseline in ['control','predecessor','bounds']:
  ratios=[]
  for pair in range(24):
   values=[]
   for variant in ['candidate',baseline]:
    r=next(r for r in rows if r['case']==case and r['variant']==variant and r['pair']==pair)
    values.append(statistics.median(x[1] for x in r['rows'] if x[0]>=16))
   ratios.append(values[0]/values[1])
  point=statistics.median(ratios);limit=.8 if baseline=='control' and case in ['stream','stream-owner'] else 1.05;s=summary[case]['comparisons'][baseline]
  assert s['median_paired_ratio']==point and s['limit']==limit and s['pass']==(point<=limit)
  if point>limit:fail.append((case,baseline))
assert fail==[('flat-tiny','control'),('flat-tiny','predecessor'),('flat-tiny','bounds'),('flat-full','control'),('flat-full','bounds'),('text-25-4-source','bounds')],fail
verdict=json.loads((c/'matrix-analysis/verdict.json').read_text());assert not verdict['all_point_gates_pass'];assert verdict['source_sha256']==hashlib.sha256((c/'matrix-timing/results.json').read_bytes()).hexdigest()
for n,lines in [('candidate',37361),('control',36956),('predecessor',37107),('bounds',37149)]:assert json.loads((c/('core-lines-cost-'+n+'.json')).read_text())['core_non_test_code_lines']==lines
for n in variants:assert json.loads((c/'matrix-shaders'/(n+'.status.json')).read_text())['exit']==0
seen=set()
def artifacts_in(v):
 if isinstance(v,list):
  for item in v:yield from artifacts_in(item)
 elif isinstance(v,dict):
  if 'sha256' in v and ('preserved' in v or 'path' in v):yield v
  for item in v.values():yield from artifacts_in(item)
for p in raw.rglob('*.json'):
 if not any(s in p.name for s in ['artifact','machine','summary','receipt','cleanup']):continue
 for a in artifacts_in(json.loads(p.read_text())):
  h=a['sha256']
  if h in seen:continue
  b=Path(a.get('preserved','/home/user/gpui-preserved-test-binaries/'+h))
  if not b.exists():b=Path('/home/user/gpui-preserved-test-binaries')/h
  assert b.exists(),(p,b)
  assert hashlib.sha256(b.read_bytes()).hexdigest()==h,(p,b);seen.add(h)
print(f'verified {len(manifest)} files, 2688 timing/336 qualification/112 allocation processes, six failed point gates, {len(seen)} preserved ELFs')
