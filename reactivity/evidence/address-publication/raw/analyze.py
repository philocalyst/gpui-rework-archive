from pathlib import Path
import json,sys
r=Path(sys.argv[1]);cases=json.loads((r/'trace/trace.json').read_text());arena=json.loads((r/'trace/arena-bound.json').read_text())
rows=[];comparisons=0;stale=0;accepted=0;mutants=[];storage=[]
for case in cases:
 assert len(case['frames'])==case['retained_versions']<=4
 assert case['consumption_order']==list(reversed(range(1,len(case['frames']))))+[0]
 for check in case['comparisons']:
  f=case['frames'][check['index']];prefix=f"{case['case']}-{case['mode']}-{f['operation']}"
  assert (r/'trace'/f'{prefix}.candidate.rgba').read_bytes()==(r/'trace'/f'{prefix}.raw.rgba').read_bytes()
  assert check['wrong_bytes']==0 and check['ack_accepted']==(check['index']==len(case['frames'])-1)
  comparisons+=1;accepted+=check['ack_accepted'];stale+=not check['ack_accepted']
 for n in case['negative_controls']:
  assert n['wrong_bytes']>0
  mutants.append(dict(case=case['case'],mode=case['mode'],fault=n['fault'],wrong_bytes=n['wrong_bytes']))
 for frame in case['frames']:
  c=frame['candidate'];raw=frame['raw']
  assert sum(c['staged_by_domain'])==c['instance_staged_bytes']
  assert c['directory_staged_bytes']<=((c['directory_rows']+3)//4)*16
  assert c['fallback']==(case['case'] in ['bank-fallback','parent-fallback'])
  rows.append(dict(case=case['case'],mode=case['mode'],operation=frame['operation'],raw_instance_staged=raw['instance_staged_bytes'],candidate_instance_staged=c['instance_staged_bytes'],domains=c['staged_by_domain'],directory_staged=c['directory_staged_bytes'],gpu_copied=c['gpu_copy_bytes'],cpu_copied=c['cpu_copy_bytes'],scan=c['scan_bytes'],writes=c['write_calls'],tile_rows=c['tile_rows_examined'],tile_comparisons=c['tile_comparisons'],reused_tiles=c['tile_reused'],appended_indices=c['tile_appended_entries'],directory_written_entries=c['directory_entries'],handles_retained=frame['handles_retained_bytes'],raw_prepare_allocation=raw['prepare_allocation'],candidate_prepare_allocation=frame['prepare_allocation'],producer_work=frame['producer']['work'],fallback=c['fallback']))
 storage.append(dict(case=case['case'],mode=case['mode'],versions=case['retained_versions'],renderer_gpu_payload_bytes=case['unique_gpu_payload_bytes'],private_target_texture_bytes=case['retained_versions']*16384,one_readback_transient_bytes=16384,adapter_retained_bytes=case['retained_adapter_bytes'],cpu_array_capacity_bytes=sum(f['candidate']['cpu_array_capacity_bytes'] for f in case['frames']),packet_observer_bytes=sum(f['candidate']['observer_retained_bytes'] for f in case['frames']),handles_retained_bytes=case['frames'][-1]['handles_retained_bytes'],raw_current_gpu_payload_bytes=case['frames'][-1]['raw']['gpu_buffer_bytes']+case['frames'][-1]['raw']['atlas_bytes']))
assert comparisons==63 and stale==42 and accepted==21 and len(mutants)==2
assert arena['frames']==129 and arena['updates']==128 and arena['compactions']==2
for row in arena['rows']:
 assert row['retained_versions']<=2
 assert row['work']['resident_index_entries']<=4*row['dense_references']+1024
 assert sum(row['work']['staged_by_domain'])==row['work']['instance_staged_bytes']
assert sum(x['work']['arena_compactions'] for x in arena['rows'])==arena['compactions']
out=dict(decision='NO ADOPTION; bounded GPU encoding/lifetime comparison passed, cost timing not measured',pixel_comparisons=comparisons,accepted=accepted,stale_rejected=stale,negative_controls=mutants,arena_frames=arena['frames'],arena_compactions=arena['compactions'],arena_compaction_steps=[x['step'] for x in arena['rows'] if x['work']['arena_compactions']],rows=rows,storage=storage,exclusions=['Driver/allocator private state is not a retained-memory ledger','Source diagnostic cold and emission mirrors remain in producer; not a generic production journal','Original raw control serially reuses one renderer; candidates hold private versions','Allocation scopes differ: raw render includes draw submission, candidate prepare includes copy/flush but final draw submission separate','GPU payload excludes test oracle, expected CPU pixels, JSON and shader pipelines','Inherited mixed 48-byte CPU/GPU gate remains FAILED; encoding equality does not replace it'])
p=Path(__file__).with_name('analysis.json');p.write_text(json.dumps(out,indent=2)+'\n');print('verified',comparisons,'private frames and',arena['frames'],'arena frames; no timing verdict')
