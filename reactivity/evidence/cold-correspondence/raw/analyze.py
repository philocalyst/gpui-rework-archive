from pathlib import Path
import json,sys
identity_header=int((Path(__file__).parent/'identity-header-bytes.txt').read_text());index_cells={(int(n),e=='true'):int(h)+int(b) for n,e,h,b in [line.split(',') for line in (Path(__file__).parent/'identity-storage.csv').read_text().splitlines()]};r=Path(__file__).parent/sys.argv[1];d=json.loads((r/'trace/trace.json').read_text());rows=[];previous={}
for x in d['results']:
 case=x['case'];op=x['operation'];obs=x['observation'];c=obs['cold_correspondence'];nodes=obs['logical'];images=[(r/'trace'/f'{case}-{op}.{kind}.rgba').read_bytes() for kind in ['actual','cpu','fresh','full']];assert len(images[0])==16384 and all(i==images[0] for i in images)
 if op=='failed-newer':assert c['status'].startswith('incomplete');continue
 assert c['status']=='complete logical correspondence';assert c['producer_records']==len(nodes)
 assert all(a['records']==len(nodes) for a in c['alternatives']);assert c['run_payload_bytes']==12*c['run_count']
 for a in c['alternatives']:assert a['retained_bytes']==a['store_header_bytes']+a['directory_capacity_bytes']+a['encoded_payload_bytes']
 raw,absolute,relative=c['alternatives'];assert raw['encoded_payload_bytes']==24*len(nodes)
 if op!='initial':
  old=previous[case];oldnodes=old['observation']['logical'];order=[]
  for run in c['runs']:
   source=nodes if run['old_start']==4294967295 else oldnodes;start=run['new_start'] if run['old_start']==4294967295 else run['old_start'];order.extend(n['identity'] for n in source[start:start+run['len']])
  assert order==[n['identity'] for n in nodes]
  if op=='insert':
   bad=(r/'trace'/f'{case}-mutant-actual.rgba').read_bytes();good=(r/'trace'/f'{case}-mutant-expected.rgba').read_bytes();assert sum(a!=b for a,b in zip(bad,good))==326
  changed_pixels=sum(a!=b for a,b in zip((r/'trace'/f"{case}-{old['operation']}.actual.rgba").read_bytes(),images[0]))
  baseline=obs['raw_node_vec_header_bytes']+obs['node_capacity_bytes']
  entry=dict(case=case,operation=op,logical_nodes=len(nodes),reconciliation_visits=obs['work']['reconciled'],layout_insertions=obs['work']['layout_insertions'],paint_visits=obs['work']['paint_nodes'],run_count=c['run_count'],run_metadata_bytes=c['run_header_bytes']+c['run_capacity_bytes'],literal_canonical_bytes=c['raw_canonical_literal_bytes'],baseline_raw_node_vector_bytes=baseline,actual_raw_mirror_plus_three_alternatives_and_trial_bytes=baseline+c['combined_store_run_trial_retained_bytes'],hypothetical_replacement_with_journal_bytes={a['mode']:a['retained_bytes']+c['run_header_bytes']+c['run_capacity_bytes'] for a in c['alternatives']},alternatives=c['alternatives'],changed_pixel_bytes=changed_pixels,gpu=x['gpu'],allocation=x['allocation'])
  common_index=identity_header+obs['identity_index_heap_bytes'];entry['existing_identity_index_bytes']=common_index;entry['baseline_node_vector_plus_existing_lookup_bytes']=baseline+common_index;entry['actual_shadow_plus_existing_lookup_bytes']=entry['actual_raw_mirror_plus_three_alternatives_and_trial_bytes']+common_index;entry['hypothetical_replacement_with_journal_and_existing_lookup_bytes']={k:v+common_index for k,v in entry['hypothetical_replacement_with_journal_bytes'].items()};rows.append(entry)
 previous[case]=x
storage=[];fragment=[]
for line in (r/'codec.out').read_text().splitlines():
 if line.startswith('COLD_STORAGE '):storage.append(json.loads(line[len('COLD_STORAGE '):]))
 if line.startswith('COLD_FRAGMENT '):fragment.append(json.loads(line[len('COLD_FRAGMENT '):]))
assert len(storage)==26 and len(fragment)==1 and fragment[0]['run_count']==32
for cell in storage:
 c=cell['report'];n=cell['n'];assert all(a['records']==n for a in c['alternatives'])
 for a in c['alternatives']:
  assert a['retained_bytes']==a['store_header_bytes']+a['directory_capacity_bytes']+a['encoded_payload_bytes']
  if n<=8:assert a['raw_storage'] and a['encoded_payload_bytes']==24*n
 cell['practical_raw_vector_bytes']=24+24*n;cell['replacement_with_journal_bytes']={a['mode']:a['retained_bytes']+c['run_header_bytes']+c['run_capacity_bytes'] for a in c['alternatives']}
for cell in storage:
 common=index_cells[cell['n'],cell['entropy']];cell['existing_identity_index_bytes']=common;cell['practical_raw_vector_plus_lookup_bytes']=cell['practical_raw_vector_bytes']+common;cell['replacement_with_journal_and_lookup_bytes']={k:v+common for k,v in cell['replacement_with_journal_bytes'].items()}
result=dict(scope='cold representation only; no adoption/timing/GPU publication; producer remains global',live=rows,synthetic_storage=storage,fragmentation=fragment)
(r/'analysis.json').write_text(json.dumps(result,indent=2))
for x in rows:print(x['case'],x['operation'],'runs',x['run_count'],'payload',[a['encoded_payload_bytes'] for a in x['alternatives']],'rewrites',[a['ordinal_block_rewrite_payload_bytes'] for a in x['alternatives']],'baseline/actualshadow',x['baseline_raw_node_vector_bytes'],x['actual_raw_mirror_plus_three_alternatives_and_trial_bytes'])
for c in storage:
 if c['n'] in [0,1,8,9,32,257]:print('storage',c['n'],c['entropy'],'baseline',c['practical_raw_vector_bytes'],'alternatives+journal',c['replacement_with_journal_bytes'])
