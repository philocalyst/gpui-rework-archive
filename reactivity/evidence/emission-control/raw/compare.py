from pathlib import Path
import json,hashlib
r=Path(__file__).parent;roots=[r/'candidate-first',r/'baseline-first'];data=[]
for lane,c in zip(['candidate','baseline'],roots):
 for gate in ['build','clippy']:assert json.loads((c/(gate+'.status.json')).read_text())['exit']==0
 assert json.loads((c/'variety.status.json').read_text())['exit']==101
 assert json.loads((c/'overall.json').read_text())=={'failed_gates':['variety'],'decision':'FAILED'}
 assert json.loads((c/'guard.json').read_text())==[]
 data.append(json.loads((c/'variety/trace.json').read_text()))
assert len(data[0])==len(data[1])==3
inputs=[json.loads((c/'inputs-before.json').read_text()) for c in roots]
diff={n:[d.get(n) for d in inputs] for n in inputs[0].keys()|inputs[1].keys() if inputs[0].get(n)!=inputs[1].get(n)}
assert set(diff)=={'reactivity/crates/gpui/src/runtime.rs','reactivity/crates/gpui/src/runtime/structural_trace.rs','reactivity/crates/gpui/src/runtime/semantic_emission.rs'}
assert (roots[0]/'ui.wgsl').read_bytes()==(roots[1]/'ui.wgsl').read_bytes()
assert (roots[0]/'toolchain.txt').read_bytes()==(roots[1]/'toolchain.txt').read_bytes()
assert json.loads((roots[0]/'build.status.json').read_text())['args']==json.loads((roots[1]/'build.status.json').read_text())['args']
for c in roots:
 assert json.loads((c/'driver.json').read_text())['sha256']==hashlib.sha256((r/'gate.py').read_bytes()).hexdigest()
results=[]
for x,y in zip(*data):
 assert x['operation']==y['operation'];op=x['operation']
 assert x['observation']['semantic_emission']['current_lookup_matches_live_version']
 assert y['observation'].get('semantic_emission') is None
 assert x['scene']==y['scene'],op
 frame=dict(operation=op,scene_identical=True,pixel_gate='FAILED',candidate=x['pixel_wrong_bytes_cpu_fresh_full'],baseline=y['pixel_wrong_bytes_cpu_fresh_full'])
 frame['cross_process_wrong_bytes']={}
 for kind in ['actual','cpu','fresh','full']:
  images=[(c/'variety'/f'{op}.{kind}.rgba').read_bytes() for c in roots];assert all(len(p)==16384 for p in images)
  wrong=sum(a!=b for a,b in zip(*images));assert wrong==0;frame['cross_process_wrong_bytes'][kind]=wrong
 for c,entry in zip(roots,[x,y]):
  images=[(c/'variety'/f'{op}.{kind}.rgba').read_bytes() for kind in ['actual','cpu','fresh','full']]
  counts=[sum(a!=b for a,b in zip(images[0],p)) for p in images[1:]];assert counts==entry['pixel_wrong_bytes_cpu_fresh_full']==[48,48,0]
  assert images[1]==images[2]
 frame['gpu_counters_identical']=x['gpu']==y['gpu'];assert frame['gpu_counters_identical']
 frame['source_allocations']=[x['allocation'],y['allocation']]
 results.append(frame)
result=dict(verdict='REPRODUCED WITHOUT MAPPING; exact cross-backend gate remains FAILED',scope='only semantic mapping instrumentation removed; older controls and renderer identical; no timing/cause/tolerance claim',changed_inputs=diff,shader_sha256=hashlib.sha256((roots[0]/'ui.wgsl').read_bytes()).hexdigest(),frames=results)
(r/'comparison.json').write_text(json.dumps(result,indent=2));print(json.dumps(result,indent=2))
