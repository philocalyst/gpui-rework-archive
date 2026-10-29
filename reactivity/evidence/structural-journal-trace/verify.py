from pathlib import Path
import hashlib,json
r=Path(__file__).parent

def sha(p):
 with p.open('rb') as f:return hashlib.file_digest(f,'sha256').hexdigest()
manifest=json.loads((r/'MANIFEST.json').read_text())
for name,h in manifest.items():assert sha(r/name)==h,name
raw=r/'raw';canonical=[];shaders=[]
for name,success in [('first',False),('owner-dependency',False),('bound-failure',True)]:
 g=raw/name;assert json.loads((g/'guard.json').read_text())==[]
 assert json.loads((g/'build.status.json').read_text())['exit']==0
 assert (json.loads((g/'structural.status.json').read_text())['exit']==0)==success
 a=json.loads((g/'artifact.json').read_text());assert not a['cargo_fresh'];p=Path(a['preserved'])
 if p.exists():assert sha(p)==a['sha256'];canonical.append(name)
 shaders.append((g/'ui.wgsl').read_bytes())
assert all(x==shaders[0] for x in shaders)
assert json.loads((raw/'bound-failure/clippy.status.json').read_text())['exit']==0
base=raw/'bound-failure';trace=json.loads((base/'trace/trace.json').read_text());assert len(trace['results'])==30
pixels=mutants=0;old={}
for row in trace['results']:
 case=row['case'];op=row['operation']
 images=[(base/'trace'/f'{case}-{op}.{kind}.rgba').read_bytes() for kind in ['actual','cpu','fresh','full']];assert len(images[0])==16384 and all(x==images[0] for x in images);pixels+=1
 obs=row['observation'];nodes=obs['logical'];assert len({n['identity'] for n in nodes})==len(nodes)
 if op=='failed-newer':assert obs['source_epoch']>obs['complete_epoch'];continue
 if op=='initial':old[case]=nodes;continue
 before=old[case];old_ids={n['identity']:n for n in before};new_ids={n['identity']:n for n in nodes};survivors=old_ids.keys()&new_ids.keys();work=obs['work']
 assert work['reconciled']==len(nodes)==work['paint_nodes']==work['identity_index_input']
 assert work['survived']==len(survivors) and work['minted']==len(new_ids.keys()-old_ids.keys())
 assert work['relocated']==sum(old_ids[i]['index']!=new_ids[i]['index'] for i in survivors)
 assert work['layout_insertions']==(0 if case.startswith('unkeyed') and op=='move' else len(nodes))
 assert row['gpu']['copied_pixels']==4096
 assert row['scene']['masks']==row['scene']['images']==row['scene']['gradients']==0
 assert row['scene']['resource_entries']==(6 if op=='insert' else 5) if case.startswith('keyed') else row['scene']['resource_entries']==1
 assert row['scene']['resource_header_bytes']==128
 if op=='insert':
  bad=(base/'trace'/f'{case}-mutant-actual.rgba').read_bytes();good=(base/'trace'/f'{case}-mutant-expected.rgba').read_bytes();assert sum(a!=b for a,b in zip(bad,good))==row['subtree_damage_mutant']['wrong_bytes']==326;mutants+=1
 old[case]=nodes
assert (pixels,mutants)==(30,6)
probe=json.loads((base/'address-probe.json').read_text());assert len(probe)==18
old={};lookup={(x['case'],x['operation']):x for x in probe}
for row in trace['results']:
 case=row['case'];op=row['operation'];nodes=row['observation']['logical']
 if op=='failed-newer':continue
 if op=='initial':old[case]=nodes;continue
 p=lookup[case,op];before=old[case]
 for relative,key in [(False,'absolute_parent_record_changes'),(True,'relative_parent_record_changes')]:
  def rec(n):return (n['identity'],None if n['parent'] is None else n['index']-n['parent'] if relative else n['parent'],n['kind'])
  prior={n['identity']:rec(n) for n in before};assert p[key]==sum(prior.get(n['identity'])!=rec(n) for n in nodes)
 replay=[]
 for run in p['identity_order_runs']:
  source=before if run['kind']=='old' else nodes;start=run['old_start'] if run['kind']=='old' else run['new_start'];replay.extend(n['identity'] for n in source[start:start+run['len']])
 assert replay==[n['identity'] for n in nodes]
 assert p['input_nodes_walked']==len(before)+len(nodes);old[case]=nodes
print(json.dumps(dict(verified=True,files=len(manifest),four_oracle_frames=pixels,actual_GPU_mutants=mutants,topology_probe_cells=len(probe),canonical_ELFs_checked=canonical,no_timing_or_adoption=True)))
