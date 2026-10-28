from pathlib import Path
import json,math,statistics,sys
r=Path(sys.argv[1]);output=Path(sys.argv[2]);order=json.loads((r/'PROCESS_ORDER.json').read_text());assert len(order)==180
assert json.loads((r/'guard.json').read_text())==[]
def read(p):return json.loads(p.read_text())
def quantile(xs,p):return sorted(xs)[math.ceil(len(xs)*p)-1]
def median(xs):return statistics.median(xs)
cases={};per_process=[];end=0
fields=['round_trip_ns','preparation_ns','serialization_ns','transport_response_ns','owner_ack_ns','staging_ns','encoding_ns','submit_completion_ns','worker_ns']
for item in order:
 name=f"r{item['round']}-{item['scene']}-{item['n']}-{item['role']}";d=read(r/name/'result.json');status=read(r/(name+'.status.json'));assert status['exit']==0 and status['started_unix_seconds']>=end;end=status['started_unix_seconds']+status['elapsed_seconds']
 assert d['n']==item['n'] and d['role']==item['role'] and len(d['warmups'])==64 and len(d['samples'])==512 and d['all_fenced_heap_allocations_released']
 events=[json.loads(x) for x in (r/name/'events.jsonl').read_text().splitlines()];assert len(events)==576
 for phase,rows,start in [('warmup',d['warmups'],0),('timing',d['samples'],64)]:
  for a,b in zip(rows,events[start:start+len(rows)],strict=True):assert b==dict(phase=phase,**a)
 for s in d['samples']:
  assert s['complete'] and s['round_trip_ns']>=s['preparation_ns']+s['serialization_ns']+s['worker_ns']+s['owner_ack_ns']
  assert s['worker_ns']==s['staging_ns']+s['encoding_ns']+s['submit_completion_ns']
  assert s['queue_writes']==4 if item['role']=='hot' else s['queue_writes'] in (4,6)
  if item['role']=='hot':assert s['upload_bytes']==108
 stats={field:{label:quantile([s[field] for s in d['samples']],p) for label,p in [('p50',.50),('p95',.95),('p99',.99)]} for field in fields}
 record=dict(**item,stats=stats,cold_ns=d['cold_ns'],upload_bytes=sorted({s['upload_bytes'] for s in d['samples']}),request_utf8_bytes=[min(s['request_utf8_bytes'] for s in d['samples']),max(s['request_utf8_bytes'] for s in d['samples'])],ledger=d['ledger'],ready=d['ready'],owner_maxrss_kib=d['owner_maxrss_kib'],worker_maxrss_kib=d['worker_maxrss_kib'])
 cases[(item['scene'],item['n'],item['role'],item['round'])]=record;per_process.append(record)
rows=[];violations=[]
for scene in ['sparse','overlap']:
 for n in [1,9,32,256,1024]:
  by={role:[cases[scene,n,role,i] for i in range(6)] for role in ['control','hot','raw']}
  ratios=[h['stats']['round_trip_ns']['p95']/b['stats']['round_trip_ns']['p95'] for h,b in zip(by['hot'],by['control'],strict=True)]
  raw_hot=[raw['stats']['round_trip_ns']['p95']/hot['stats']['round_trip_ns']['p95'] for raw,hot in zip(by['raw'],by['hot'],strict=True)]
  summary={role:dict(stats={field:{q:median([x['stats'][field][q] for x in rows]) for q in ['p50','p95','p99']} for field in fields},cold_ns=median([x['cold_ns'] for x in rows]),worker_maxrss_kib=median([x['worker_maxrss_kib'] for x in rows]),ledger=rows[0]['ledger'],ready=rows[0]['ready'],upload_bytes=rows[0]['upload_bytes']) for role,rows in by.items()}
  row=dict(scene=scene,n=n,primary_p95_ratios=ratios,median_primary_p95_ratio=median(ratios),raw_vs_hot_p95_ratios=raw_hot,median_raw_vs_hot_p95_ratio=median(raw_hot),roles=summary);rows.append(row)
  if n in [1,9,32] or (scene=='overlap' and n==1024):
   for i,value in enumerate(ratios):
    if value>1.05:violations.append(dict(scene=scene,n=n,round=i,p95_ratio=value))
primary=[row for row in rows if row['scene']=='sparse' and row['n'] in [256,1024]]
primary_pass=all(row['median_primary_p95_ratio']<=.95 for row in primary)
median_regression_pass=all(row['median_primary_p95_ratio']<=1.05 for row in rows if row['n'] in [1,9,32] or row['scene']=='overlap' and row['n']==1024)
result=dict(measured_processes=180,measured_samples=92160,warmups=11520,quantile='nearest rank ceil(p*n)-1',primary_sparse_median_gate_pass=primary_pass,median_regression_reading_pass=median_regression_pass,per_round_regression_reading_pass=not violations,regression_violations=violations,verdict='not admitted under conservative per-round regression reading',aggregation_note='Prereg explicitly assigns median per-round ratios to sparse target limits, but not explicitly to regression clauses. Median-only reading passes; three individual tiny pairs exceed1.05. Both are retained; no post-result choice of the lenient interpretation, no rerun or sample removal.',rows=rows,processes=per_process,scope='serialized model binding patch through JSON/IPC/Vulkan completion and owner acknowledgement; software Vulkan; not production GPUI, scanout, hardware or ZGX latency')
output.write_text(json.dumps(result,indent=2));print(json.dumps({k:v for k,v in result.items() if k not in ['rows','processes']},indent=2))
