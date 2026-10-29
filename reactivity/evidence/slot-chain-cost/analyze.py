from pathlib import Path
import json,math,statistics,collections,hashlib
r=Path(__file__).parent;t=r/'timing'
def percentile(xs,p):return sorted(xs)[math.ceil(p*len(xs))-1]
assert json.loads((t/'guard.json').read_text())==[]
assert json.loads((t/'inputs-before.json').read_text())==json.loads((t/'inputs-after.json').read_text())
order=json.loads((r/'order.json').read_text());assert len(order)==408
groups=collections.defaultdict(list);processes=[]
for case in order:
 name=case['name'];d=t/name;data=json.loads((d/'result.json').read_text());assert data['config']=={k:v for k,v in case.items() if k!='name'}
 assert not data['preflight'] and len(data['samples'])==512 and len(data['warmups'])==64
 assert json.loads((t/(name+'.status.json')).read_text())['exit']==0
 events=[json.loads(x) for x in (d/'events.jsonl').read_text().splitlines()];assert events==data['warmups']+data['samples']
 for label in ['initial','after-warmup','final']:
  images=[(d/(label+'-'+s+'.rgba')).read_bytes() for s in ['actual','cpu','fresh','full']];assert len(images[0])==16384 and all(x==images[0] for x in images)
 rows=data['samples'];stages={k:{str(p):percentile([x[k] for x in rows],p) for p in [.5,.95,.99]} for k in ['endpoint_ns','source_ns','render_submit_ns','completion_wait_ns','ack_ns']}
 record=dict(**case,stages=stages,cold_ns=data['cold_ns'],maxrss_kib=data['process_maxrss_kib'],storage=data['storage'],work=sorted(set((x['upload_bytes'],x['validated_draws'],x['binning_tile_visits']) for x in rows)))
 processes.append(record);groups[(case['mode'],case['n'])].append(record)
cells=[]
for (mode,n),ps in groups.items():
 ratios=[]
 for rnd in range(6):
  p={role:[x['stages']['endpoint_ns']['0.95'] for x in ps if x['round']==rnd and x['role']==role] for role in ['control','candidate']};assert all(len(x)==2 for x in p.values());ratios.append(math.sqrt(math.prod(p['candidate'])/math.prod(p['control'])))
 threshold=.8 if mode in ['coalesced','return-original'] and n in [256,1024] else 1.05
 summary={role:dict(endpoint_p95_ns=statistics.median([x['stages']['endpoint_ns']['0.95'] for x in ps if x['role']==role]),cold_ns=statistics.median([x['cold_ns'] for x in ps if x['role']==role]),maxrss_kib=statistics.median([x['maxrss_kib'] for x in ps if x['role']==role]),work=[list(y) for y in sorted(set(tuple(y) for x in ps if x['role']==role for y in x['work']))],storage=ps[next(i for i,x in enumerate(ps) if x['role']==role)]['storage']) for role in ['control','candidate']}
 cells.append(dict(mode=mode,n=n,ratios=ratios,ratio=statistics.median(ratios),threshold=threshold,passed=statistics.median(ratios)<=threshold,summary=summary))
report=dict(verdict='ADMITTED TO FURTHER INTEGRATION ONLY' if all(x['passed'] for x in cells) else 'NOT ADMITTED',processes=408,samples=208896,warmups=26112,cells=cells,process_details=processes)
(r/'analysis.json').write_text(json.dumps(report,indent=2))
print(report['verdict'])
for c in cells:print(c['mode'],c['n'],round(c['ratio'],6),c['threshold'],c['passed'],*[round(c['summary'][role]['endpoint_p95_ns']/1e6,4) for role in ['control','candidate']])
