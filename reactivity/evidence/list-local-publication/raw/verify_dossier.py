from pathlib import Path
import json,hashlib,re,statistics,random
root=Path(__file__).resolve().parent;raw=root/'raw'
manifest=json.loads((root/'manifest.json').read_text())
for name,h in manifest.items():assert hashlib.sha256((root/name).read_bytes()).hexdigest()==h,name
for p in raw.rglob('guard-after.json'):assert json.loads(p.read_text())==[],str(p)
for name,count,ignored in [('owner-default',997,13),('owner-native',1082,45)]:
 for stage in ['test','clippy']:assert json.loads((raw/name/(stage+'.status.json')).read_text())['exit']==0
 rows=re.findall(r'test result: ok\. (\d+) passed; (\d+) failed; (\d+) ignored',(raw/name/'test.out').read_text());assert [sum(int(a[i]) for a in rows) for i in range(3)]==[count,0,ignored]
assert '10 passed; 0 failed' in (raw/'owner-native/port.out').read_text()
statuses=list((raw/'native-checks').glob('*.status.json'));assert len(statuses)==11
for s in statuses:assert json.loads(s.read_text())['exit']==0
for name in ['wrong-row','omitted-name','wrong-row-membership','omitted-name-membership']:
 d=raw/'negative'/name;assert json.loads((d/'test.status.json').read_text())['exit']==101
 assert '0 passed; 1 failed' in (d/'test.out').read_text()
assert 'failed: variant=1' in (raw/'negative/omitted-name-membership/test.log').read_text()
assert 'patches=0,full=80' in (raw/'admission-clip-bits/test.out').read_text()
assert 'LOCAL_PUBLICATION,stream,updates=80,patches=80,full=0' in (raw/'raster-admission/test.out').read_text()
assert 'LOCAL_PUBLICATION,stream-owner,updates=80,patches=0,full=80' in (raw/'raster-admission/test.out').read_text()
assert json.loads((raw/'owner-admission/test.status.json').read_text())['exit']==101
for case in ['stream','stream-owner']:assert f'LOCAL_PUBLICATION,{case},updates=80,patches=80,full=0,unchanged_layout=80' in (raw/'owner-membership-admission/test.out').read_text()
assert json.loads((raw/'raster-public/clippy.status.json').read_text())['exit']==101
assert json.loads((raw/'raster-public-lint/clippy.status.json').read_text())['exit']==0
assert json.loads((raw/'focused-first/test.status.json').read_text())['exit']==101
for phase,count,frames in [('qualification',60,4),('allocations',20,4),('timing',300,64)]:
 d=raw/('cost-'+phase);results=json.loads((d/'results.json').read_text());assert len(results)==count
 statuses=list(d.glob('*.status.json'));assert len(statuses)==count
 for p in statuses:assert json.loads(p.read_text())['exit']==0
 for r in results:
  assert len(r['rows'])==16+frames
  size=64 if r['case']=='flat-tiny' else 512*512 if r['case']=='flat-full' else 32*32 if r['case']=='list-tiny' else 960*720
  assert all(row[6 if phase=='allocations' else 3]==size for row in r['rows'])
 for case in {r['case'] for r in results}:assert len({tuple(r['setup'][-2:]) for r in results if r['case']==case})==1
assert json.loads((raw/'cost-timing/jobs.json').read_text())==json.loads((root/'PROCESS_ORDER.json').read_text())
a=json.loads((raw/'analysis-definition.json').read_text())
assert hashlib.sha256((raw/'analyze_cost.py').read_bytes()).hexdigest()==a['analysis_sha256']
assert hashlib.sha256((raw/'cost_runs.py').read_bytes()).hexdigest()==a['run_driver_sha256']
assert hashlib.sha256((root/'PROCESS_ORDER.json').read_bytes()).hexdigest()==a['process_manifest_sha256']
s=json.loads((raw/'cost-analysis/summary.json').read_text());results=json.loads((raw/'cost-timing/results.json').read_text())
for case,v in s.items():
 ratios=[]
 for pair in range(15):
  c=next(r for r in results if r['case']==case and r['pair']==pair and r['variant']=='candidate')
  b=next(r for r in results if r['case']==case and r['pair']==pair and r['variant']=='control')
  ratios.append(statistics.median(x[1] for x in c['rows'] if x[0]>=16)/statistics.median(x[1] for x in b['rows'] if x[0]>=16))
 assert statistics.median(ratios)==v['comparisons']['control']['median_paired_ratio']
assert {c for c,v in s.items() if not v['comparisons']['control']['pass']}=={'stream','stream-owner'}
assert not json.loads((raw/'cost-analysis/verdict.json').read_text())['all_point_gates_pass']
assert json.loads((raw/'core-lines-owner.json').read_text())['core_non_test_code_lines']==37113
seen=set()
for p in raw.rglob('*artifact*.json'):
 value=json.loads(p.read_text())
 rows=value if isinstance(value,list) else [value] if 'sha256' in value else list(value.values())
 for a in rows:
  if not isinstance(a,dict) or 'sha256' not in a:continue
  h=a['sha256']
  if h in seen:continue
  binary=Path(a.get('preserved','/home/user/gpui-preserved-test-binaries/'+h))
  assert binary.is_file(),str(binary)
  assert hashlib.sha256(binary.read_bytes()).hexdigest()==h;seen.add(h)
for v in json.loads((raw/'machine-first/summary.json').read_text()).values():
 a=v['artifact'];binary=Path(a['preserved']);assert hashlib.sha256(binary.read_bytes()).hexdigest()==a['sha256']
print(f'verified {len(manifest)} files;997 default/1082 X11,10 port,11 native;300 timed/60 qualification/20 allocation processes; both primary failures retained;{len(seen)} preserved ELFs')
