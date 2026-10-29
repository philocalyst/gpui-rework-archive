from pathlib import Path
import hashlib,json
r=Path(__file__).parent;m=json.loads((r/'MANIFEST.json').read_text())
assert set(m)=={p.relative_to(r).as_posix() for p in r.rglob('*') if p.is_file() and p.name!='MANIFEST.json'}
for n,h in m.items():assert hashlib.sha256((r/n).read_bytes()).hexdigest()==h,n
for cohort in ['first','radius-corrected','complete-counterexample']:
 c=r/'raw'/cohort;a=json.loads((c/'artifact.json').read_text());elf=Path(a['preserved']).read_bytes();assert hashlib.sha256(elf).hexdigest()==a['sha256'] and len(elf)==a['bytes'] and a['cargo_fresh'] is False
 shader=(c/'ui.wgsl').read_bytes()
 for v in json.loads((c/'shaders.json').read_text()).values():assert hashlib.sha256(shader).hexdigest()==v['sha256'] and elf[v['elf_offset']:v['elf_offset']+v['bytes']]==shader
 assert json.loads((c/'guard.json').read_text())==[]
 assert json.loads((c/'build.status.json').read_text())['exit']==0
 assert json.loads((c/'variety.status.json').read_text())['exit']==101
c=r/'raw/complete-counterexample'
assert json.loads((c/'overall.json').read_text())=={'failed_gates':['variety'],'decision':'FAILED'}
for name in ['structural','clippy']:assert json.loads((c/(name+'.status.json')).read_text())['exit']==0
assert (c/'source.txt').read_text()==(r/'source.txt').read_text()
inputs=json.loads((c/'inputs-before.json').read_text())
for p in (r/'frozen').rglob('*'):
 if p.is_file():assert hashlib.sha256(p.read_bytes()).hexdigest()==inputs['reactivity/crates/'+p.relative_to(r/'frozen').as_posix()]
assert json.loads((r/'raw/rounded-clip-fresh/build.status.json').read_text())['exit']==101
assert json.loads((r/'raw/rounded-clip-fresh/guard.json').read_text())==[]
for cohort in ['rounded-clip','rounded-clip-qualified','rounded-radius-type']:
 assert json.loads((r/'raw'/cohort/'preflight-rejected.json').read_text())['free']<8*1024**3

def mapping(x):
 obs=x['observation'];store=obs['semantic_emission'];v=store['current'];rows=v['rows'];logical=obs['logical'];draws=x['scene']['draws'];deps=v['dependencies'];assert len(rows)==len(logical)==len(deps)
 assert store['current_lookup_matches_live_version'];assert [p['identity'] for p in rows]==[p['identity'] for p in logical]
 cursor=0
 for i,row in enumerate(rows):
  assert row['start']==cursor;cursor=row['end'];desc=[]
  for j in range(i,len(rows)):
   p=j
   while p is not None and p!=i:p=logical[p]['parent']
   if p==i:desc.append(j)
  assert desc==list(range(i,row['node_end']));assert row['subtree_end']==rows[row['node_end']-1]['end']
  bounds=[d['bounds'] for d in draws[row['start']:row['end']]]
  support=[min(b[0] for b in bounds),min(b[1] for b in bounds),max(b[0]+b[2] for b in bounds),max(b[1]+b[3] for b in bounds)] if bounds else None
  assert support==deps[i]['support']
 assert cursor==len(draws);assert v['work']['support_draw_visits']==len(draws);assert v['work']['cursor_reads']==2*len(rows)
 assert v['row_bytes']==24 and v['dependency_bytes']==136 and store['store_header_bytes']==272
 assert v['heap_bytes']==v['row_capacity_bytes']+v['dependency_capacity_bytes']
 assert store['retained_heap_bytes']==v['heap_bytes']+(store['previous']['heap_bytes'] if store['previous'] else 0)

structural=json.loads((c/'trace/trace.json').read_text())['results'];assert len(structural)==30
for x in structural:
 case=x['case'];op=x['operation'];images=[(c/'trace'/f'{case}-{op}.{kind}.rgba').read_bytes() for kind in ['actual','cpu','fresh','full']];assert len(images[0])==16384 and all(p==images[0] for p in images)
 if op=='failed-newer':assert not x['observation']['semantic_emission']['current_lookup_matches_live_version'];continue
 mapping(x)
 if op=='insert':
  bad=(c/'trace'/f'{case}-mutant-actual.rgba').read_bytes();good=(c/'trace'/f'{case}-mutant-expected.rgba').read_bytes();assert sum(a!=b for a,b in zip(bad,good))==326
 if op=='move' and case.startswith('unkeyed'):
  assert all(a['changed_records']==0 for a in x['observation']['cold_correspondence']['alternatives']);old=(c/'trace'/f'{case}-remove.actual.rgba').read_bytes();assert sum(a!=b for a,b in zip(old,images[0]))==704
variety=json.loads((c/'variety/trace.json').read_text());assert len(variety)==3
for x in variety:
 mapping(x);op=x['operation'];images=[(c/'variety'/f'{op}.{kind}.rgba').read_bytes() for kind in ['actual','cpu','fresh','full']]
 assert all(len(p)==16384 for p in images);assert images[0]==images[3] and images[1]==images[2]
 diff=[sum(a!=b for a,b in zip(images[0],p)) for p in images[1:]]
 assert diff==x['pixel_wrong_bytes_cpu_fresh_full']==[48,48,0]
 assert max(abs(a-b) for a,b in zip(images[0],images[1]))==1
 assert x['one_node_one_command_wrong_rows']==(7 if op=='insert' else 6)
 assert x['scene']['masks']==x['scene']['images']==1 and x['scene']['resource_entries']==3
analysis=json.loads((c/'analysis.json').read_text());assert analysis['exact_variety_gate_passed'] is False
for x in analysis['structural']:
 if x['operation']=='insert':assert len(x['outside_group_changed_output'])==1
print(f'verified {len(m)} files; 30 exact structural frames, 6 damage witnesses, 3 explicitly FAILED CPU/GPU variety frames; no adoption')
