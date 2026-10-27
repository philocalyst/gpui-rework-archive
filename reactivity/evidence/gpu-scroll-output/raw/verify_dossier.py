from pathlib import Path
import json,hashlib,re,statistics
root=Path(__file__).resolve().parent;raw=root/'raw';manifest=json.loads((root/'manifest.json').read_text())
for n,h in manifest.items():assert hashlib.sha256((root/n).read_bytes()).hexdigest()==h,n
for p in raw.rglob('guard-after.json'):assert json.loads(p.read_text())==[],str(p)
for name,count,ignored in [('full-default',995,13),('full-native',1080,45),('gpu-first',74,0)]:
 for stage in ['test','clippy']:assert json.loads((raw/name/(stage+'.status.json')).read_text())['exit']==0
 a=re.findall(r'test result: ok\. (\d+) passed; (\d+) failed; (\d+) ignored',(raw/name/'test.out').read_text());assert [sum(int(x[i]) for x in a) for i in range(3)]==[count,0,ignored]
assert '10 passed; 0 failed' in (raw/'full-native/port.out').read_text()
a=list((raw/'native-checks').glob('*.status.json'));assert len(a)==11
for p in a:assert json.loads(p.read_text())['exit']==0
assert json.loads((raw/'clear-negative/test.status.json').read_text())['exit']==101
assert '0 passed; 1 failed' in (raw/'clear-negative/test.out').read_text()
for phase,count,frames in [('qualification',90,4),('allocations',30,4),('timing',450,64)]:
 d=raw/('cost-'+phase);rows=json.loads((d/'results.json').read_text());assert len(rows)==count
 a=list(d.glob('*.status.json'));assert len(a)==count
 for p in a:assert json.loads(p.read_text())['exit']==0
 for r in rows:assert len(r['rows'])==16+frames
 for c in {r['case'] for r in rows}:assert len({tuple(r['setup'][-2:]) for r in rows if r['case']==c})==1
assert json.loads((raw/'cost-timing/jobs.json').read_text())==json.loads((root/'PROCESS_ORDER.json').read_text())
a=json.loads((raw/'analysis-definition.json').read_text())
for p,k in [(raw/'analyze_cost.py','analysis_sha256'),(raw/'cost_runs.py','run_driver_sha256'),(root/'PROCESS_ORDER.json','process_manifest_sha256')]:assert hashlib.sha256(p.read_bytes()).hexdigest()==a[k]
s=json.loads((raw/'cost-analysis/summary.json').read_text());rows=json.loads((raw/'cost-timing/results.json').read_text());fail=[]
for c,v in s.items():
 for b in ['control','predecessor']:
  ratios=[]
  for k in range(15):
   values=[]
   for variant in ['candidate',b]:
    r=next(r for r in rows if r['case']==c and r['pair']==k and r['variant']==variant);values.append(statistics.median(x[1] for x in r['rows'] if x[0]>=16))
   ratios.append(values[0]/values[1])
  x=v['comparisons'][b];assert statistics.median(ratios)==x['median_paired_ratio'];limit=.8 if b=='control' and c in ['scroll','both'] else 1.05
  assert x['limit']==limit and x['pass']==(statistics.median(ratios)<=limit)
  if not x['pass']:fail.append((c,b))
assert fail==[('list-tiny','predecessor')]
assert not json.loads((raw/'cost-analysis/verdict.json').read_text())['all_point_gates_pass']
assert json.loads((raw/'core-lines-candidate.json').read_text())['core_non_test_code_lines']==37473
seen=set()
for p in raw.rglob('*artifact*.json'):
 v=json.loads(p.read_text());rows=v if isinstance(v,list) else [v] if 'sha256' in v else list(v.values())
 for a in rows:
  if not isinstance(a,dict) or 'sha256' not in a:continue
  h=a['sha256']
  if h in seen:continue
  b=Path(a.get('preserved','/home/user/gpui-preserved-test-binaries/'+h));assert hashlib.sha256(b.read_bytes()).hexdigest()==h;seen.add(h)
for v in json.loads((raw/'machine-first/summary.json').read_text()).values():
 a=v['artifact'];b=Path(a.get('preserved','/home/user/gpui-preserved-test-binaries/'+a['sha256']));assert hashlib.sha256(b.read_bytes()).hexdigest()==a['sha256']
print(f'verified {len(manifest)} files; 450 timed/90 qualification/30 allocation; tiny-list predecessor failure retained; {len(seen)} preserved ELFs')
