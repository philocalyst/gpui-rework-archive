from pathlib import Path
import json,math,statistics,sys
r=Path(sys.argv[1]);output=Path(sys.argv[2]);order=json.loads((r/'PROCESS_ORDER.json').read_text());assert len(order)==270
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
  assert s['queue_writes'] in (4,6)
 assert d['ledger']['index_steady_work']=={}
 stats={field:{label:quantile([s[field] for s in d['samples']],p) for label,p in [('p50',.50),('p95',.95),('p99',.99)]} for field in fields}
 record=dict(**item,stats=stats,cold_ns=d['cold_ns'],upload_bytes=sorted({s['upload_bytes'] for s in d['samples']}),request_utf8_bytes=[min(s['request_utf8_bytes'] for s in d['samples']),max(s['request_utf8_bytes'] for s in d['samples'])],ledger=d['ledger'],ready=d['ready'],owner_maxrss_kib=d['owner_maxrss_kib'],worker_maxrss_kib=d['worker_maxrss_kib'])
 cases[(item['scene'],item['n'],item['role'],item['round'])]=record;per_process.append(record)
rows=[];violations=[]
for scene in ['sparse','overlap','staircase']:
 for n in [1,9,32,256,1024]:
  by={role:[cases[scene,n,role,i] for i in range(6)] for role in ['control','indexed','raw']}
  ratios=[h['stats']['round_trip_ns']['p95']/b['stats']['round_trip_ns']['p95'] for h,b in zip(by['indexed'],by['control'],strict=True)]
  raw_hot=[raw['stats']['round_trip_ns']['p95']/hot['stats']['round_trip_ns']['p95'] for raw,hot in zip(by['raw'],by['indexed'],strict=True)]
  summary={role:dict(stats={field:{q:median([x['stats'][field][q] for x in rows]) for q in ['p50','p95','p99']} for field in fields},cold_ns=median([x['cold_ns'] for x in rows]),worker_maxrss_kib=median([x['worker_maxrss_kib'] for x in rows]),ledger=rows[0]['ledger'],ready=rows[0]['ready'],upload_bytes=rows[0]['upload_bytes']) for role,rows in by.items()}
  row=dict(scene=scene,n=n,primary_p95_ratios=ratios,median_primary_p95_ratio=median(ratios),raw_vs_indexed_p95_ratios=raw_hot,median_raw_vs_indexed_p95_ratio=median(raw_hot),roles=summary);rows.append(row)
  if n in [1,9,32] or (scene in ['overlap','staircase'] and n==1024):
   if median(ratios)>1.05:violations.append(dict(scene=scene,n=n,median_p95_ratio=median(ratios)))
primary=[row for row in rows if row['scene']=='sparse' and row['n'] in [256,1024]]
primary_pass=all(row['median_primary_p95_ratio']<=.95 for row in primary)
regression_pass=not violations
result=dict(measured_processes=270,measured_samples=138240,warmups=17280,quantile='nearest rank ceil(p*n)-1',primary_sparse_median_gate_pass=primary_pass,regression_median_gate_pass=regression_pass,regression_violations=violations,cost_admitted=primary_pass and regression_pass,verdict='admitted against original compressed traversal' if primary_pass and regression_pass else 'not admitted against original compressed traversal',aggregation_note='Median of six paired per-round p95 ratios for EVERY gain and regression clause, prospectively fixed; raw serial is a separate practical cost comparison.',rows=rows,processes=per_process,scope='serialized model binding patch through JSON/IPC/Vulkan completion and owner acknowledgement; software Vulkan; not production GPUI, scanout, hardware or ZGX latency')
output.write_text(json.dumps(result,indent=2));print(json.dumps({k:v for k,v in result.items() if k not in ['rows','processes']},indent=2))
