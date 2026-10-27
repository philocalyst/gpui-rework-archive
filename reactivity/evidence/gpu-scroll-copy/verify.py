from pathlib import Path
import json,hashlib,re,gzip,statistics
root=Path(__file__).resolve().parent;raw=root/'raw'
manifest=json.loads((root/'manifest.json').read_text())
for name,h in manifest.items():assert hashlib.sha256((root/name).read_bytes()).hexdigest()==h,name
for p in raw.rglob('guard-after.json'):assert json.loads(p.read_text())==[],str(p)
for name,count,ignored in [('full-default',995,13),('full-native',1070,44),('full-gpu',74,0)]:
 for stage in ['test','clippy']:assert json.loads((raw/name/(stage+'.status.json')).read_text())['exit']==0
 pairs=re.findall(r'test result: ok\. (\d+) passed; (\d+) failed; (\d+) ignored',(raw/name/'test.out').read_text());assert [sum(int(a[i]) for a in pairs) for i in range(3)]==[count,0,ignored]
assert '10 passed; 0 failed' in (raw/'full-native/port.out').read_text()
for name in ['benchmark-native-corrected','benchmark-control-corrected']:
 for stage in ['unit-build','clippy']:assert json.loads((raw/name/(stage+'.status.json')).read_text())['exit']==0
p=list((raw/'native-checks').glob('*.status.json'));assert len(p)==11
for status in p:assert json.loads(status.read_text())['exit']==0
assert json.loads((raw/'native-workload-final/native-5.status.json').read_text())['exit']==0
assert '6 passed; 0 failed' in (raw/'canvas-adversaries/test.out').read_text()
assert json.loads((raw/'content-negative/test.status.json').read_text())['exit']==101
assert 'changed overlap reused stale pixels' in (raw/'content-negative/test.log').read_text()
assert json.loads((raw/'token-negative-native/native-5.status.json').read_text())['exit']==101
assert 'native patch vs independent full GPU renderer' in (raw/'token-negative-native/native-5.log').read_text()
for phase,count,frames in [('qualification',60,4),('allocations',20,4),('timing',300,64)]:
 d=raw/('cost-'+phase);results=json.loads((d/'results.json').read_text());assert len(results)==count
 assert len(list(d.glob('*.status.json')))==count
 for p in d.glob('*.status.json'):assert json.loads(p.read_text())['exit']==0
 for r in results:
  assert len(r['rows'])==16+frames
  case=r['case'];size=64 if case=='flat-tiny' else 512*512 if case=='flat-full' else 32*32 if case=='list-tiny' else 960*720
  copy=r['variant']=='candidate' and case in ['scroll','both','list-flat','list-tiny'];overlap=16*15 if case=='list-tiny' else 920*386
  assert all(row[6 if phase=='allocations' else 3]==size+(2*overlap if copy else 0) for row in r['rows'])
 for case in {r['case'] for r in results}:assert len({tuple(r['setup'][-2:]) for r in results if r['case']==case})==1
assert json.loads((raw/'cost-timing/jobs.json').read_text())==json.loads((root/'PROCESS_ORDER.json').read_text())
s=json.loads((raw/'cost-analysis/summary.json').read_text());assert s['scroll']['pass'] and s['both']['pass'];assert not s['flat-tiny']['pass'] and s['flat-tiny']['median_paired_ratio']>1.05
assert {c for c,v in s.items() if not v['pass']}=={'flat-tiny'}
assert not json.loads((raw/'cost-analysis/verdict.json').read_text())['all_point_gates_pass']
a=json.loads((raw/'cost-environment/analysis-definition.json').read_text());assert hashlib.sha256((raw/'analyze_cost.py').read_bytes()).hexdigest()==a['analysis_sha256'];assert hashlib.sha256((raw/'cost_runs.py').read_bytes()).hexdigest()==a['run_driver_sha256']
assert json.loads((raw/'shipping-lines-final.json').read_text())['core_non_test_code_lines']==37434
assert json.loads((raw/'control-shipping-lines.json').read_text())['core_non_test_code_lines']==36962
for name in ['benchmark-native-corrected','benchmark-control-corrected','content-negative','token-negative-native','full-native','control-gpu-headers']:
 a=json.loads((raw/name/'artifact.json').read_text());assert hashlib.sha256(Path(a['preserved']).read_bytes()).hexdigest()==a['sha256']
for a in json.loads((raw/'full-gpu/artifacts.json').read_text()):assert hashlib.sha256(Path(a['preserved']).read_bytes()).hexdigest()==a['sha256']
for a in json.loads((raw/'completed-test-cache-cleanup.json').read_text()):
 with gzip.open(a['archive'],'rb') as f:assert hashlib.file_digest(f,'sha256').hexdigest()==a['sha256']
print(f'verified {len(manifest)} files;300 timing/60 qualification/20 allocation processes; failed flat-tiny gate preserved')
