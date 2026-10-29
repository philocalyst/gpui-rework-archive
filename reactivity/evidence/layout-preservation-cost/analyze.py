from pathlib import Path
import math,json,statistics,sys
r=Path(sys.argv[1]);destination=Path(sys.argv[2]) if len(sys.argv)>2 else Path(__file__).parent/'analysis.json'
order=json.loads((r/'order.json').read_text());done=json.loads((r/'completed.json').read_text());assert len(order)==len(done)==288
quant=lambda a,q:sorted(a)[math.ceil(len(a)*q)-1]
def ratio(a,b):return a/b if b else (1 if a==0 else math.inf)
processes=[];index={}
for spec,d in zip(order,done):
 assert d['exit']==0
 for k in ['block','family','direction','mode']:assert spec[k]==d[k]
 p=r/d['path'];data=json.loads((p/'result.json').read_text());assert data['final_wrong_bytes']==0
 assert (p/'final.rgba').read_bytes()==(p/'oracle.rgba').read_bytes();assert (p/'final.cpu.rgba').read_bytes()==(p/'fresh.cpu.rgba').read_bytes()
 assert len(data['samples'])==416 and len(data['allocations'])==2
 entry=dict(**spec,path=d['path'],memory=data['memory'],setup={k:data[k] for k in ['owner_setup_ns','device_pipeline_setup_ns']},initial=data['initial'],sample_capacity_bytes=data['sample_capacity_bytes'],cells=[])
 for direction in [0,1]:
  samples=[s for s in data['samples'] if s['measured'] and s['direction']==direction];assert len(samples)==192
  structural=spec['family'] in ['keyed4','unkeyed4','keyed256','reorder256','measured']
  for s in samples:
   w=s['layout']['work'];prod=s['layout']['producer']
   if structural:
    if spec['mode']=='automatic':assert prod['layout_full_rebuilds']==1 and w['plan_attempts']==0
    else:assert prod['layout_full_rebuilds']==0 and w['plan_attempts']==1 and w['preserved_nodes']>0 and w['authority_declines']==0
   else:assert prod['layout_full_rebuilds']==0 and w['plan_allocations']==0
   if spec['family']=='unkeyedmove':assert prod['layout_computes']==0
  alloc=next(x for x in data['allocations'] if x['direction']==direction)
  cell=dict(direction=direction,latency={k:{str(q):quant([s[k] for s in samples],q) for q in [.5,.95,.99]} for k in ['total_ns','source_ns','prepare_submit_ns','completion_ack_ns']},layout_max=max(s['layout']['known_layout_bytes'] for s in samples),gpu_max=max(s['renderer_gpu_bytes'] for s in samples),allocation=alloc,work_ranges={k:[min(s['layout']['work'][k] for s in samples),max(s['layout']['work'][k] for s in samples)] for k in samples[0]['layout']['work']},producer_ranges={k:[min(s['layout']['producer'][k] for s in samples),max(s['layout']['producer'][k] for s in samples)] for k in samples[0]['layout']['producer']},gpu_work_ranges={k:[min(s[k] for s in samples),max(s[k] for s in samples)] for k in ['instance_staged_bytes','mask_staged_bytes','image_staged_bytes','submissions','validations','bin_visits','renderer_index_bytes','composited_pixels','copied_pixels']})
  entry['cells'].append(cell);index[spec['block'],spec['family'],spec['direction'],spec['mode'],direction]=cell
 processes.append(entry)
families=['keyed4','unkeyed4','keyed256','reorder256','unkeyedmove','resources','constraints','measured'];results={}
for mode in ['ordered','append']:
 cells=[];failures=[]
 for family in families:
  for direction in [0,1]:
   primary=family in ['keyed256','reorder256'];scores={};block_scores={}
   for metric in ['source_ns','total_ns']:
    scores6=[]
    for block in range(6):
     rr=[ratio(index[block,family,orderway,mode,direction]['latency'][metric]['0.95'],index[block,family,orderway,'automatic',direction]['latency'][metric]['0.95']) for orderway in ['forward','reverse']];scores6.append(math.sqrt(rr[0]*rr[1]))
    score=statistics.median(scores6);limit=(.8 if metric=='source_ns' else .95) if primary else 1.05;scores[metric]=score;block_scores[metric]=scores6
    if score>limit:failures.append(dict(family=family,direction=direction,metric=metric,score=score,limit=limit))
   storage={}
   for metric in ['layout_max','gpu_max','allocation_peak']:
    pairs=[]
    for block in range(6):
     for orderway in ['forward','reverse']:
      a=index[block,family,orderway,mode,direction];b=index[block,family,orderway,'automatic',direction]
      x=a['allocation']['peak_delta'] if metric=='allocation_peak' else a[metric];y=b['allocation']['peak_delta'] if metric=='allocation_peak' else b[metric];pairs.append(ratio(x,y))
    score=max(pairs);storage[metric]=score
    if score>1.1:failures.append(dict(family=family,direction=direction,metric=metric,score=score,limit=1.1))
   displayed={}
   for m in ['automatic',mode]:
    displayed[m]={metric:statistics.median([index[b,family,o,m,direction]['latency'][metric]['0.95'] for b in range(6) for o in ['forward','reverse']]) for metric in ['source_ns','total_ns']}
   cells.append(dict(family=family,direction=direction,primary=primary,scores=scores,block_scores=block_scores,storage=storage,displayed_median_process_p95=displayed))
 results[mode]=dict(verdict='NOT ADMITTED' if failures else 'ADMITTED LOCAL TRIAL ONLY',failures=failures,cells=cells)
result=dict(scope='matched feature selectors on original native packet decision/serial retained raw renderer; software completion/ack, no shipping or ZGX inference',results=results,processes=processes)
destination.write_text(json.dumps(result,indent=2)+'\n')
for mode,result in results.items():print(mode,result['verdict'],'failed clauses',len(result['failures']))
