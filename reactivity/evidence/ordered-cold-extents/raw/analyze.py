from pathlib import Path
import json,sys
r=Path(__file__).parent/sys.argv[1]
d=json.loads((r/'trace/trace.json').read_text());out=[];previous={}
for x in d['results']:
 case=x['case'];op=x['operation'];obs=x['observation'];c=obs['cold_correspondence'];o=obs['ordered_cold_extents'];n=len(obs['logical'])
 images=[(r/'trace'/f'{case}-{op}.{kind}.rgba').read_bytes() for kind in ['actual','cpu','fresh','full']]
 assert len(images[0])==16384 and all(i==images[0] for i in images)
 for a in o['alternatives']:
  assert a['records']==n
  for m in [a['current'],a['all_retained']]:
   assert m['bytes']==sum(m[k] for k in ['block_payload_bytes','block_control_bytes','version_control_bytes','directory_capacity_bytes','raw_buffer_capacity_bytes'])
   assert m['physical_block_records']==m['referenced_block_records']+m['unreferenced_block_records']
  assert a['current_and_history_plus_state_bytes']==a['all_retained']['bytes']+a['state_header_bytes']+a['history_handle_capacity_bytes']+a['pending_heap_bytes']
 if op=='failed-newer':
  assert all(a['status'].startswith('incomplete') for a in o['alternatives']);continue
 assert all(a['work']['producer_records']==n and a['work']['verification_decodes']==n for a in o['alternatives'])
 baseline=obs['raw_node_vec_header_bytes']+obs['node_capacity_bytes']+24+obs['identity_index_heap_bytes']
 combined=baseline+c['combined_store_run_trial_retained_bytes']+sum(a['current_and_history_plus_state_bytes'] for a in o['alternatives'])
 changed=0
 if case in previous:
  changed=sum(a!=b for a,b in zip(previous[case],images[0]))
 if op=='insert':
  bad=(r/'trace'/f'{case}-mutant-actual.rgba').read_bytes();good=(r/'trace'/f'{case}-mutant-expected.rgba').read_bytes();assert sum(a!=b for a,b in zip(bad,good))==326
 if op=='move' and case.startswith('unkeyed'):
  assert all(a['changed_records']==0 for a in c['alternatives']);assert changed==704
 out.append(dict(case=case,operation=op,records=n,existing_raw_and_identity_bytes=baseline,actual_mirror_and_all_controls_bytes=combined,run_header_and_capacity_bytes=c['run_header_bytes']+c['run_capacity_bytes'],run_count=c['run_count'],existing_identity_index_bytes=24+obs['identity_index_heap_bytes'],fixed_block_controls=c['alternatives'],ordered=o['alternatives'],global_work=obs['work'],allocation=x.get('allocation'),gpu=x.get('gpu'),changed_pixel_bytes=changed))
 previous[case]=images[0]
logs={}
for line in (r/'ordered.out').read_text().splitlines():
 if line.startswith('ORDERED_'):
  tag,data=line.split(' ',1);logs.setdefault(tag,[]).append(json.loads(data))
assert len(logs['ORDERED_STORAGE'])==78
assert len(logs['ORDERED_PERMUTATION'])==3 and len(logs['ORDERED_FRAGMENT'])==3 and len(logs['ORDERED_HELD_READER'])==3
for x in logs['ORDERED_STORAGE']:
 x['raw_vec_bytes']=24+24*x['n']
result=dict(scope='actual CPU immutable cold store; no adoption, timing, GPU consumer or local producer claim',live=out,synthetic=logs)
(r/'analysis.json').write_text(json.dumps(result,indent=2))
for x in out:
 if x['operation']=='initial':continue
 print(x['case'],x['operation'],'retained',[a['all_retained']['bytes'] for a in x['ordered']],'current',[a['current']['bytes'] for a in x['ordered']],'newbytes',[a['work']['new_encoded_bytes']+a['work']['compaction_encoded_bytes']+a['work']['raw_copied_bytes'] for a in x['ordered']],'reused',[a['work']['reusable_records'] for a in x['ordered']],'pieces',[a['current_pieces'] for a in x['ordered']],'compact',[a['work']['compactions'] for a in x['ordered']])
for x in logs['ORDERED_FRAGMENT']:print('fragment',x['mode'],x['work'])
