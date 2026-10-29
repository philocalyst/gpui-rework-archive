from pathlib import Path
import json,math,statistics,sys
r=Path(sys.argv[1]);order=json.loads((r/'order.json').read_text());completed=json.loads((r/'completed.json').read_text());assert len(order)==len(completed)==288
assert json.loads((r/'guard.json').read_text())==[]
assert json.loads((r/'overall.json').read_text())['decision'].startswith('COMPLETE')
def quant(values,q):
 values=sorted(values);return values[math.ceil(q*len(values))-1]
def median(x):return statistics.median(x)
process={};metrics=[];adapters=set();pixels={};compactions={};scope={}
for expected,status in zip(order,completed):
 assert all(status[k]==v for k,v in expected.items()) and status['exit']==0
 p=r/status['path'];x=json.loads((p/'result.json').read_text());assert x['final_wrong_bytes']==0
 actual=(p/'final.rgba').read_bytes();assert actual==(p/'oracle.rgba').read_bytes()
 assert pixels.setdefault(x['family'],actual)==actual
 adapters.add(x['adapter']);assert x['warm']==32 and x['measured']==384
 assert [s['step'] for s in x['samples']]==list(range(1,417))
 assert not any(s['fallback'] for s in x['samples'])
 assert all(s['total_ns']==s['source_ns']+s['prepare_submit_ns']+s['completion_ack_retire_ns'] for s in x['samples'])
 for direction in [0,1]:
  samples=[s for s in x['samples'] if s['measured'] and s['direction']==direction];assert len(samples)==192
  assert all(s['measured']==(s['step']>32) and s['direction']==int(s['step']%2==0) for s in x['samples'])
  assert all(s['submissions']==(1 if x['mode']=='raw' else 3) for s in samples)
  for s in samples:
   if s['staged_domains'] is not None:assert sum(s['staged_domains'])==s['instance_staged_bytes']
  quantiles={name:{str(q):quant([s[name] for s in samples],q) for q in [.5,.95,.99]} for name in ['total_ns','source_ns','prepare_submit_ns','completion_ack_retire_ns']}
  peakcpu=max(s['peak_known_cpu_bytes'] for s in samples);peakgpu=max(s['peak_renderer_gpu_bytes'] for s in samples)
  keys=['instance_staged_bytes','image_staged_bytes','mask_staged_bytes','gpu_copy_bytes','cpu_copy_bytes','scan_bytes','directory_staged_bytes','directory_rows','directory_entries_written','tile_rows_examined','tile_comparisons','reused_tiles','appended_indices','resident_indices','superseded_buffer_bytes','key_comparisons','key_insertions','key_moved_bytes','resource_keys_examined','resource_map_cloned_capacity','copy_commands','handles_bytes','current_known_cpu_bytes','current_renderer_gpu_bytes']
  work={k:dict(min=min(s[k] for s in samples),max=max(s[k] for s in samples),median=median([s[k] for s in samples])) for k in keys}
  item=dict(block=status['block'],pair_direction=status['direction'],family=x['family'],mode=x['mode'],direction=direction,quantiles=quantiles,peak_known_cpu_bytes=peakcpu,peak_renderer_gpu_bytes=peakgpu,work=work,compactions=sum(s['compactions'] for s in samples),cold=dict(device_pipeline_ns=x['device_pipeline_setup_ns'],owner_ns=x['owner_setup_ns'],initial_frame_ns=x['initial']['total_ns']),memory=x['memory'])
  process[status['block'],status['direction'],x['family'],x['mode'],direction]=item;metrics.append(item)
  compactions.setdefault((x['family'],x['mode'],direction),[]).append(item['compactions'])
 scope.setdefault(x['family'],x['final_producer']['work']);assert scope[x['family']]==x['final_producer']['work']
families=['keyed4','unkeyed4','keyed256','reorder256','mixed','resources'];modes=['raw','relocation','relative','stable'];cells=[]
for family in families:
 for direction in [0,1]:
  for mode in modes:
   rows=[process[b,p,family,mode,direction] for b in range(6) for p in ['forward','reverse']]
   cells.append(dict(family=family,direction=direction,mode=mode,median_process_p50_ns=median([x['quantiles']['total_ns']['0.5'] for x in rows]),median_process_p95_ns=median([x['quantiles']['total_ns']['0.95'] for x in rows]),median_process_p99_ns=median([x['quantiles']['total_ns']['0.99'] for x in rows]),max_known_cpu_bytes=max(x['peak_known_cpu_bytes'] for x in rows),max_renderer_gpu_bytes=max(x['peak_renderer_gpu_bytes'] for x in rows),measured_compactions=sum(x['compactions'] for x in rows)))
ratios=[]
for family in families:
 for direction in [0,1]:
  for candidate,control in [('relocation','raw'),('relative','relocation'),('relative','raw'),('stable','relocation'),('stable','raw')]:
   blocks=[];cpu=[];gpu=[]
   for b in range(6):
    pair=[]
    for p in ['forward','reverse']:
     a=process[b,p,family,candidate,direction];c=process[b,p,family,control,direction]
     pair.append(a['quantiles']['total_ns']['0.95']/c['quantiles']['total_ns']['0.95']);cpu.append(a['peak_known_cpu_bytes']/c['peak_known_cpu_bytes']);gpu.append(a['peak_renderer_gpu_bytes']/c['peak_renderer_gpu_bytes'])
    blocks.append(math.sqrt(pair[0]*pair[1]))
   score=median(blocks);primary=(candidate=='relative' and family=='mixed') or (candidate=='stable' and family=='keyed256');threshold=.8 if primary else 1.05
   ratios.append(dict(family=family,direction=direction,candidate=candidate,control=control,block_paired_p95_ratios=blocks,score=score,primary=primary,threshold=threshold if candidate!='relocation' else None,timing_pass=score<=threshold if candidate!='relocation' else None,worst_paired_cpu_ratio=max(cpu),worst_paired_gpu_ratio=max(gpu),storage_pass=max(cpu)<=4 and max(gpu)<=4))
# The fixed churn workload must actually include compaction, not call it setup.
assert all(v>0 for v in compactions['keyed4','stable',1])
for family in families:
 for direction in [0,1]:
  for b in range(6):
   for pair in ['forward','reverse']:
    stable=process[b,pair,family,'stable',direction];raw=process[b,pair,family,'raw',direction]
    assert stable['work']['resident_indices']['max'] <= 4*raw['work']['resident_indices']['max']+1024
verdicts={}
for candidate in ['relative','stable']:
 chosen=[r for r in ratios if r['candidate']==candidate];timing=all(x['timing_pass'] for x in chosen);storage=all(x['storage_pass'] for x in chosen if x['control']=='raw')
 verdicts[candidate]=dict(verdict='ADMITTED LOCAL COST HYPOTHESIS ONLY' if timing and storage else 'NOT ADMITTED',timing=timing,storage=storage,failed_timing=[dict(family=x['family'],direction=x['direction'],control=x['control'],score=x['score'],threshold=x['threshold']) for x in chosen if not x['timing_pass']],failed_storage=[dict(family=x['family'],direction=x['direction'],cpu=x['worst_paired_cpu_ratio'],gpu=x['worst_paired_gpu_ratio']) for x in chosen if x['control']=='raw' and not x['storage_pass']])
output=dict(verdicts=verdicts,processes=288,measured_updates=288*384,adapters=sorted(adapters),producer_work=scope,cells=cells,paired_ratios=ratios,process_metrics=metrics,scope='restricted native recording endpoint including copies, submissions, completion, ack, retirement; original raw serial versus private versions have different lifetime services; no CPU/GPU parity, hardware, WSI or ZGX inference')
Path(__file__).with_name('analysis.json').write_text(json.dumps(output,indent=2)+'\n');print(json.dumps(verdicts,indent=2))
