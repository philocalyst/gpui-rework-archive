from pathlib import Path
import json,hashlib,gzip,subprocess
root=Path(__file__).resolve().parent;raw=root/'raw';r=raw/'candidate'
manifest=json.loads((root/'manifest.json').read_text())
for p,h in manifest.items():assert hashlib.sha256((root/p).read_bytes()).hexdigest()==h,p
for p in raw.rglob('guard-after.json'):assert json.loads(p.read_text())==[],str(p)
g=r/'first'
for stage in ['test','clippy','build','minimal-build','minimal-clippy']:assert json.loads((g/(stage+'.status.json')).read_text())['exit']==0
assert '17 passed; 0 failed; 0 ignored' in (g/'test.out').read_text()
assert 'CONTROL_HEADERS,Lab=128,Controls=48,Task=2,Remote=8,Inbox=24' in (g/'test.log').read_text()
assert 'inbox_requests=1,inbox_bytes=120,inbox_retained=120,queue_requests=5,queue_bytes=248,queue_retained=128,queue_capacity=64' in (g/'test.log').read_text()
assert 'CONTROL_FIRST_POLL_COUNTERS,Counters { owner_reruns: 1, descriptions: 1, source_operations: 1, source_reads: 0, destination_compares: 103, text_promotions: 0, text_bytes_copied: 0, layout_runs: 0, measure_calls: 0, presentations: 0, paint_passes: 0' in (g/'test.log').read_text()
expected=[]
for op,before,after in [('Rewrite',(0,0),(0,-1)),('Append',(0,-1),(3,0)),('Rewrite',(3,0),(3,0)),('Append',(3,0),(4,-1))]:
 expected += [f'GPUI_CONTROL,queued,{op},{before[0]},{before[1]}',f'GPUI_CONTROL,yielded,{op},{before[0]},{before[1]}',f'GPUI_CONTROL,applied,{op},{after[0]},{after[1]}']
expected.append('GPUI_CONTROL,immediate,999,4,999')
for stage in ['build','minimal-build']:
 p=r/('native-'+stage+'-corrected');assert json.loads((p/'status.json').read_text())['exit']==0;assert json.loads((p/'expected-trace.json').read_text())==expected
 lines=(p/'app.log').read_text().splitlines();assert [s for s in lines if s.startswith('GPUI_CONTROL,')]==expected
 assert max(i for i,s in enumerate(lines) if s.startswith('GPUI_ACK,'))>max(i for i,s in enumerate(lines) if s.startswith('GPUI_CONTROL,'))
 assert 'PRESENTATION_ERROR' not in '\n'.join(lines)
 a=json.loads((g/(stage+'-artifacts.json')).read_text())[0];assert json.loads((p/'artifact.json').read_text())==a
 features=json.loads(a['fingerprint']['features']);assert ('accessibility' in features)==(stage=='build') and 'x11-minimal' in features
# Failed native harness attempts remain failures, not silently replaced records.
assert json.loads((r/'native-build/status.json').read_text())['exit'] is None
assert any('BadWindow' in q['stderr'] for q in json.loads((r/'native-build/commands.json').read_text()))
assert json.loads((r/'native-minimal-build/status.json').read_text())['exit'] is None
assert [s for s in (r/'native-build/app.log').read_text().splitlines() if s.startswith('GPUI_CONTROL,')]==expected
for name,gate,marker in [('sync','sync','click must only enqueue'),('sync','sync-restored-floor','click must only enqueue'),('skip-yield','skip-yield','first poll must yield')]:
 p=raw/name/gate;assert json.loads((p/'test.status.json').read_text())['exit']==101;assert marker in (p/'test.log').read_text();assert '1 failed' in (p/'test.out').read_text()
assert json.loads((raw/'sync/sync-restored-floor/test.status.json').read_text())['free_bytes']>8*1024**3
source=(g/'source.txt').read_text().strip();base=json.loads((r/'inherited-core.json').read_text())['base'];changed=subprocess.check_output(['git','diff','--name-only',base,source,'--','reactivity/crates','.cargo','clippy.toml'],cwd=root,text=True).splitlines();assert changed==['reactivity/crates/gpui/examples/zgx_native_lab.rs']
for p in [g,raw/'sync/sync',raw/'skip-yield/skip-yield']:
 src=(p/'source.txt').read_text().strip();file='reactivity/crates/gpui/examples/zgx_native_lab.rs';data=subprocess.check_output(['git','show',src+':'+file],cwd=root);assert hashlib.sha256(data).hexdigest()==json.loads((p/'inputs.json').read_text())[file]
assert json.loads((r/'inventory.json').read_text())['core_non_test_code_lines']==36956
shader=(r/'generated-ui.wgsl').read_bytes()
for stage,s in json.loads((r/'shader-receipt.json').read_text()).items():
 assert hashlib.sha256(shader).hexdigest()==s['sha256'];a=json.loads((g/(stage+'-artifacts.json')).read_text())[0];data=Path(a['preserved']).read_bytes();assert data[s['offset']:s['offset']+s['bytes']]==shader
seen=set()
def records(v):
 if isinstance(v,dict):
  if 'sha256' in v and 'preserved' in v:yield v
  for x in v.values():yield from records(x)
 elif isinstance(v,list):
  for x in v:yield from records(x)
for p in raw.rglob('*.json'):
 for a in records(json.loads(p.read_text())):
  h=a['sha256']
  if h in seen:continue
  b=Path(a['preserved']);data=b.read_bytes()
  if a.get('compression')=='gzip' or b.suffix=='.gz':data=gzip.decompress(data)
  assert hashlib.sha256(data).hexdigest()==h,(p,b);seen.add(h)
print('verified',len(manifest),'files;17 port tests,2 actual native scripts,2 intended mutant failures plus restored-floor repeat;',len(seen),'preserved ELF/module identities')
