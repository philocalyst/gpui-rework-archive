from pathlib import Path
import json,hashlib
r=Path(__file__).parent;m=json.loads((r/'MANIFEST.json').read_text())
assert set(m)=={p.relative_to(r).as_posix() for p in r.rglob('*') if p.is_file() and p.name!='MANIFEST.json'}
for n,h in m.items():assert hashlib.sha256((r/n).read_bytes()).hexdigest()==h,n
roots=[r/'raw/candidate-first',r/'raw/baseline-first'];inputs=[];data=[]
for lane,c in zip(['candidate','baseline'],roots):
 for gate in ['build','clippy']:assert json.loads((c/(gate+'.status.json')).read_text())['exit']==0
 assert json.loads((c/'variety.status.json').read_text())['exit']==101
 assert json.loads((c/'overall.json').read_text())=={'failed_gates':['variety'],'decision':'FAILED'}
 assert json.loads((c/'guard.json').read_text())==[]
 assert (c/'source.txt').read_text()==(r/(lane+'-source.txt')).read_text()
 a=json.loads((c/'artifact.json').read_text());elf=Path(a['preserved']).read_bytes();assert hashlib.sha256(elf).hexdigest()==a['sha256'] and len(elf)==a['bytes'] and a['cargo_fresh'] is False
 shader=(c/'ui.wgsl').read_bytes()
 for q in json.loads((c/'shaders.json').read_text()).values():assert hashlib.sha256(shader).hexdigest()==q['sha256'] and elf[q['elf_offset']:q['elf_offset']+q['bytes']]==shader
 assert json.loads((c/'driver.json').read_text())['sha256']==hashlib.sha256((r/'raw/gate.py').read_bytes()).hexdigest()
 source_inputs=json.loads((c/'inputs-before.json').read_text());inputs.append(source_inputs)
 for p in (r/'frozen'/lane).rglob('*'):
  if p.is_file():assert hashlib.sha256(p.read_bytes()).hexdigest()==source_inputs['reactivity/crates/gpui/src/'+p.relative_to(r/'frozen'/lane).as_posix()]
 data.append(json.loads((c/'variety/trace.json').read_text()))
assert (roots[0]/'toolchain.txt').read_bytes()==(roots[1]/'toolchain.txt').read_bytes()
assert (roots[0]/'ui.wgsl').read_bytes()==(roots[1]/'ui.wgsl').read_bytes()
assert json.loads((roots[0]/'build.status.json').read_text())['args']==json.loads((roots[1]/'build.status.json').read_text())['args']
different={n for n in inputs[0].keys()|inputs[1].keys() if inputs[0].get(n)!=inputs[1].get(n)}
assert different=={'reactivity/crates/gpui/src/runtime.rs','reactivity/crates/gpui/src/runtime/structural_trace.rs','reactivity/crates/gpui/src/runtime/semantic_emission.rs'}
assert len(data[0])==len(data[1])==3
for x,y in zip(*data):
 assert x['operation']==y['operation'];op=x['operation'];assert x['scene']==y['scene'] and x['gpu']==y['gpu']
 assert x['observation']['semantic_emission']['current_lookup_matches_live_version'];assert y['observation'].get('semantic_emission') is None
 for kind in ['actual','cpu','fresh','full']:
  images=[(c/'variety'/f'{op}.{kind}.rgba').read_bytes() for c in roots];assert len(images[0])==16384 and images[0]==images[1]
 for c,entry in zip(roots,[x,y]):
  images=[(c/'variety'/f'{op}.{kind}.rgba').read_bytes() for kind in ['actual','cpu','fresh','full']];wrong=[sum(a!=b for a,b in zip(images[0],p)) for p in images[1:]]
  assert wrong==entry['pixel_wrong_bytes_cpu_fresh_full']==[48,48,0];assert images[1]==images[2]
comparison=json.loads((r/'raw/comparison.json').read_text());assert comparison['verdict']=='REPRODUCED WITHOUT MAPPING; exact cross-backend gate remains FAILED'
print(f'verified {len(m)} files; matched scenes/all backend pixels, discrepancy reproduced in control; both exact gates remain FAILED')
