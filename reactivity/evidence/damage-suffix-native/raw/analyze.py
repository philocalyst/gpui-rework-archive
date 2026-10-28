from pathlib import Path
import json,re,statistics
from guard import check
r=Path(__file__).parent;check('guard-analysis.json');orders=json.loads((r/'PROCESS_ORDER.json').read_text());rows=[];failures=[]
for g in orders:
 for name in g['order']:
  p=r/'timing'/g['route']/str(g['group'])/name;status=json.loads((p/'status.json').read_text());row=dict(route=g['route'],group=g['group'],name=name,status=status,summary=json.loads((p/'summary.json').read_text()) if (p/'summary.json').exists() else None)
  if row['summary'] is None or status['exit']!=0:row['execution_pass']=False;row['gate_pass']=False
  else:
   s=row['summary'];expected=repr(AssertionError(('unequal/insufficient admitted work',s['ticks']))) if not s['cadence_pass'] else repr(AssertionError(('first-second ACK gap gate',s['first_second_gaps_over25ms']))) if not s['gap_gate_pass'] else None;row['execution_pass']=status['failure'] is None or (name=='candidate' and status['failure']==expected);row['gate_pass']=status['failure'] is None and s['cadence_pass'] and s['gap_gate_pass']
  rows.append(row)
  if not row['execution_pass'] or (name=='candidate' and not row['gate_pass']):failures.append(dict(route=g['route'],group=g['group'],name=name,status=status,summary=row['summary']))
aggregates={}
for route in ['exact','owner']:
 aggregates[route]={}
 for name in ['baseline','candidate']:
  group=[x for x in rows if x['route']==route and x['name']==name];assert len(group)==8;values=[x['summary'] for x in group if x['summary'] is not None]
  item=dict(observations=len(group),execution_passes=sum(x['execution_pass'] for x in group),gate_passes=sum(x['gate_pass'] for x in group),ticks=[s['ticks'] for s in values],first_second_gaps_over25ms=[s['first_second_gaps_over25ms'] for s in values],total_gaps_over25ms=[s['total_gaps_over25ms'] for s in values])
  if len(values)==8:item.update(dict(cpu_cores_median=statistics.median(s['cpu_cores'] for s in values),mean_rss_bytes_median=statistics.median(s['mean_rss_bytes'] for s in values)))
  aggregates[route][name]=item
result=dict(rows=rows,failures=failures,aggregates=aggregates,candidate_passes=all(x['gate_pass'] for x in rows if x['name']=='candidate') and all(x['execution_pass'] for x in rows),limits='Startup cadence mechanism screen only; no CPU superiority ratio, warm-regression acceptance, ZGX or hardware result.')
(r/'analysis.json').write_text(json.dumps(result,indent=2));print(json.dumps({'aggregates':aggregates,'candidate_passes':result['candidate_passes']},indent=2))
