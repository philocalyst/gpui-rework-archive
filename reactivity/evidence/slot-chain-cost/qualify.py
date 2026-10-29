from pathlib import Path
import json,hashlib
r=Path(__file__).parent
harnesses=[Path('/home/user/gpui-slot-chain-cost'+('-control' if role=='control' else '')+'-lab/reactivity/crates/gpui/src/native/slot_chain_cost.rs').read_bytes() for role in ['control','candidate']]
assert harnesses[0]==harnesses[1]
assert (r/'control-gate/ui.wgsl').read_bytes()==(r/'candidate-gate/ui.wgsl').read_bytes()
summary={}
for role in ['control','candidate']:
 g=r/(role+'-gate');assert json.loads((g/'guard.json').read_text())==[]
 assert json.loads((g/'clippy.status.json').read_text())['exit']==0
 artifact=json.loads((g/'artifact.json').read_text());p=Path(artifact['preserved'])
 with p.open('rb') as f:assert hashlib.file_digest(f,'sha256').hexdigest()==artifact['sha256']
 assert not artifact['cargo_fresh'];summary[role]={}
 for n in [1,9,32,256,1024]:
  for mode in ['single','coalesced','return-original']+(['geometry'] if n in [1,1024] else []):
   cell=f'{mode}-{n}';c=g/cell;data=json.loads((c/'result.json').read_text());rows=data['checked'];assert len(rows)==12 and data['preflight']
   for label in ['initial']+[f'check-{i}' for i in range(12)]:
    images=[(c/(label+'-'+name+'.rgba')).read_bytes() for name in ['actual','cpu','fresh','full']]
    assert len(images[0])==16384 and all(x==images[0] for x in images)
   work=sorted(set((x['upload_bytes'],x['validated_draws'],x['binning_tile_visits']) for x in rows))
   if mode=='single' or (role=='candidate' and mode=='coalesced'):assert work==[(16,0,0)],(role,cell,work)
   if role=='candidate' and mode=='return-original':assert work==[(0,0,0)],(role,cell,work)
   if mode=='geometry' or (role=='control' and mode!='single'):assert all(x[1]==n and x[2]>0 for x in work),(role,cell,work)
   summary[role][cell]=dict(work=work,storage=data['storage'])
(r/'qualification.json').write_text(json.dumps(summary,indent=2));print('34 preflight processes, 442 exact four-oracle comparisons; byte/work paths, shaders, harnesses, ELFs and guards qualified')
