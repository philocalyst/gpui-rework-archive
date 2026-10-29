from pathlib import Path
import hashlib,json
r=Path(__file__).parent

def sha(p):
 with p.open('rb') as f:return hashlib.file_digest(f,'sha256').hexdigest()
manifest=json.loads((r/'MANIFEST.json').read_text())
for name,h in manifest.items():assert sha(r/name)==h,name
canonical=[];shaders=[]
for cohort in ['first','fixed-metadata','storage-observations']:
 g=r/'raw'/cohort;assert json.loads((g/'guard.json').read_text())==[]
 for gate in ['build','codec','structural','clippy']:assert json.loads((g/(gate+'.status.json')).read_text())['exit']==0
 a=json.loads((g/'artifact.json').read_text());assert not a['cargo_fresh'];p=Path(a['preserved'])
 if p.exists():assert sha(p)==a['sha256'];canonical.append(cohort)
 shaders.append((g/'ui.wgsl').read_bytes())
assert all(s==shaders[0] for s in shaders)
g=r/'raw/storage-observations';data=json.loads((g/'trace/trace.json').read_text());analysis=json.loads((g/'analysis.json').read_text());assert len(data['results'])==30
previous={};pixels=mutants=paint_counterexamples=0
for row in data['results']:
 case=row['case'];op=row['operation'];obs=row['observation'];c=obs['cold_correspondence'];nodes=obs['logical']
 images=[(g/'trace'/f'{case}-{op}.{kind}.rgba').read_bytes() for kind in ['actual','cpu','fresh','full']];assert len(images[0])==16384 and all(x==images[0] for x in images);pixels+=1
 if op=='failed-newer':assert c['status'].startswith('incomplete');continue
 assert c['status']=='complete logical correspondence'
 assert c['producer_records']==len(nodes) and c['run_payload_bytes']==12*c['run_count']
 for a in c['alternatives']:
  assert a['records']==len(nodes)
  assert a['retained_bytes']==a['store_header_bytes']+a['directory_capacity_bytes']+a['encoded_payload_bytes']
  assert a['encoded_bytes_produced']==a['encoded_payload_bytes']
  assert a['new_directory_bytes_written']==a['directory_capacity_bytes']
 assert c['alternatives'][0]['encoded_payload_bytes']==len(nodes)*24
 if op!='initial':
  old=previous[case];prior=old['observation']['logical'];replay=[];next_rank=0
  for run in c['runs']:
   assert run['new_start']==next_rank;next_rank+=run['len'];is_new=run['old_start']==4294967295;source=nodes if is_new else prior;start=run['new_start'] if is_new else run['old_start'];replay.extend(n['identity'] for n in source[start:start+run['len']])
  assert replay==[n['identity'] for n in nodes]
  assert obs['work']['reconciled']==len(nodes)==obs['work']['paint_nodes']
  assert obs['work']['layout_insertions']==(0 if case.startswith('unkeyed') and op=='move' else len(nodes))
  if op=='insert':
   bad=(g/'trace'/f'{case}-mutant-actual.rgba').read_bytes();good=(g/'trace'/f'{case}-mutant-expected.rgba').read_bytes();assert sum(a!=b for a,b in zip(bad,good))==326;mutants+=1
  if op=='move' and case.startswith('unkeyed'):
   before=(g/'trace'/f'{case}-remove.actual.rgba').read_bytes();assert sum(a!=b for a,b in zip(before,images[0]))==704;assert all(a['ordinal_block_rewrite_payload_bytes']==0 for a in c['alternatives']);paint_counterexamples+=1
 previous[case]=row
storage=[];fragment=[]
for line in (g/'codec.out').read_text().splitlines():
 if line.startswith('COLD_STORAGE '):storage.append(json.loads(line[13:]))
 if line.startswith('COLD_FRAGMENT '):fragment.append(json.loads(line[14:]))
assert len(storage)==26 and len(fragment)==1 and fragment[0]['run_count']==32 and fragment[0]['run_payload_bytes']==384
indices={(int(n),e=='true'):int(h)+int(b) for n,e,h,b in [l.split(',') for l in (r/'raw/identity-storage.csv').read_text().splitlines()]}
for raw,c in zip(storage,analysis['synthetic_storage']):
 assert raw['n']==c['n'] and raw['entropy']==c['entropy'] and raw['report']==c['report'];n=c['n'];common=indices[n,c['entropy']];assert common==c['existing_identity_index_bytes'];assert c['practical_raw_vector_plus_lookup_bytes']==24+24*n+common
 for a in c['report']['alternatives']:
  assert a['retained_bytes']==a['encoded_payload_bytes']+a['store_header_bytes']+a['directory_capacity_bytes']
  replacement=a['retained_bytes']+c['report']['run_header_bytes']+c['report']['run_capacity_bytes']+common
  assert replacement==c['replacement_with_journal_and_lookup_bytes'][a['mode']]
  if n<=8:assert a['raw_storage'] and a['encoded_payload_bytes']==n*24
assert (pixels,mutants,paint_counterexamples)==(30,6,3)
print(json.dumps(dict(verified=True,files=len(manifest),final_four_way_frames=pixels,outside_group_GPU_mutants=mutants,cold_equality_paint_counterexamples=paint_counterexamples,storage_cells=len(storage),fragmentation_runs=32,canonical_ELFs_checked=canonical,adoption=False,timing=False)))
