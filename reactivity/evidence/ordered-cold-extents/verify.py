from pathlib import Path
import hashlib,json
r=Path(__file__).parent
manifest=json.loads((r/'MANIFEST.json').read_text())
assert set(manifest)=={p.relative_to(r).as_posix() for p in r.rglob('*') if p.is_file() and p.name!='MANIFEST.json'}
for n,h in manifest.items():assert hashlib.sha256((r/n).read_bytes()).hexdigest()==h,n
frames=0;mutants=0
for cohort in ['first','accounting-fixed-fresh']:
 c=r/'raw'/cohort
 for gate in ['build','ordered','codec','structural','clippy']:
  assert json.loads((c/(gate+'.status.json')).read_text())['exit']==(101 if cohort=='first' and gate=='clippy' else 0)
 assert json.loads((c/'guard.json').read_text())==[]
 a=json.loads((c/'artifact.json').read_text());elf=Path(a['preserved']).read_bytes();assert hashlib.sha256(elf).hexdigest()==a['sha256'];assert len(elf)==a['bytes'];assert a['cargo_fresh'] is False
 shaders=json.loads((c/'shaders.json').read_text());shader=(c/'ui.wgsl').read_bytes();assert all(x['sha256']==hashlib.sha256(shader).hexdigest() and elf[x['elf_offset']:x['elf_offset']+x['bytes']]==shader for x in shaders.values())
 rows=json.loads((c/'trace/trace.json').read_text())['results'];assert len(rows)==30
 for x in rows:
  case=x['case'];op=x['operation'];obs=x['observation'];o=obs['ordered_cold_extents']['alternatives'];n=len(obs['logical'])
  images=[(c/'trace'/f'{case}-{op}.{kind}.rgba').read_bytes() for kind in ['actual','cpu','fresh','full']];assert len(images[0])==16384 and all(i==images[0] for i in images);frames+=1
  for v in o:
   assert v['records']==n
   for m in [v['current'],v['all_retained']]:
    assert m['bytes']==sum(m[k] for k in ['block_payload_bytes','block_control_bytes','version_control_bytes','directory_capacity_bytes','raw_buffer_capacity_bytes'])
    assert m['physical_block_records']==m['referenced_block_records']+m['unreferenced_block_records']
   assert v['current_and_history_plus_state_bytes']==v['all_retained']['bytes']+v['state_header_bytes']+v['history_handle_capacity_bytes']+v['pending_heap_bytes']
   if op=='failed-newer':assert v['status'].startswith('incomplete')
   else:
    assert v['work']['producer_records']==n and v['work']['verification_decodes']==n
    if v['current_pieces']:assert v['current_pieces']<=2*((n+31)//32)+2
  if op=='insert':
   bad=(c/'trace'/f'{case}-mutant-actual.rgba').read_bytes();good=(c/'trace'/f'{case}-mutant-expected.rgba').read_bytes();assert sum(a!=b for a,b in zip(bad,good))==326;mutants+=1
  if op=='move' and case.startswith('unkeyed'):
   assert all(v['changed_records']==0 for v in obs['cold_correspondence']['alternatives'])
   before=(c/'trace'/f'{case}-remove.actual.rgba').read_bytes();assert sum(a!=b for a,b in zip(before,images[0]))==704
   assert all(v['work']['new_encoded_bytes']==0 for v in o[1:])
 logs={}
 for line in (c/'ordered.out').read_text().splitlines():
  if line.startswith('ORDERED_'):
   tag,data=line.split(' ',1);logs.setdefault(tag,[]).append(json.loads(data))
 assert len(logs['ORDERED_STORAGE'])==78
 assert len(logs['ORDERED_PERMUTATION'])==len(logs['ORDERED_FRAGMENT'])==len(logs['ORDERED_HELD_READER'])==3
 assert logs['ORDERED_CONTROLS'][0]['block_allocation']==40 and logs['ORDERED_CONTROLS'][0]['version_allocation']==80
 for v in logs['ORDERED_FRAGMENT'][1:]:assert v['work']['compactions']==1 and v['work']['compaction_decodes']==65
 for v in logs['ORDERED_HELD_READER']:assert v['held_plus_owner']['versions']==4 and v['owner']['retained_old_versions']==2
final=r/'raw/accounting-fixed-fresh';assert (r/'source.txt').read_text()==(final/'source.txt').read_text()
inputs=json.loads((final/'inputs-before.json').read_text())
for p in (r/'frozen').rglob('*'):
 if p.is_file():assert hashlib.sha256(p.read_bytes()).hexdigest()==inputs['reactivity/crates/gpui/src/'+p.relative_to(r/'frozen').as_posix()]
assert json.loads((r/'raw/accounting-fixed/preflight-rejected.json').read_text())['free']<8*1024**3
before=json.loads((r/'raw/first/analysis.json').read_text())['live'];after=json.loads((final/'analysis.json').read_text())['live']
for x,y in zip(before,after):
 assert (x['case'],x['operation'],x['global_work'])==(y['case'],y['operation'],y['global_work'])
 for a,b in zip(x['ordered'],y['ordered']):
  assert a['current']==b['current'] and a['all_retained']==b['all_retained']
  for k in ['new_encoded_bytes','compaction_encoded_bytes','raw_copied_bytes','reusable_records','compactions']:assert a['work'][k]==b['work'][k]
print(f'verified {len(manifest)} files, {frames} exact frames, {mutants} inherited damage counterexamples, both frozen executable cohorts; no adoption or timing claim')
