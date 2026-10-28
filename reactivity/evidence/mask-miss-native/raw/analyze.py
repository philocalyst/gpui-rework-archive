from pathlib import Path
import json,statistics,random,hashlib
from guard import check
r=Path(__file__).parent;check('guard-analysis.json');spec=json.loads((r/'SPEC.json').read_text());orders=json.loads((r/'PROCESS_ORDER.json').read_text());rows=[]
for group in orders:
 for name in group['order']:
  p=r/'timing'/group['mode']/str(group['group'])/name
  status=json.loads((p/'status.json').read_text()) if (p/'status.json').exists() else None
  s=json.loads((p/'summary.json').read_text()) if (p/'summary.json').exists() else None
  execution=status is not None and status['exit']==0 and status['failure'] is None
  qualified=execution and s is not None and s['cadence_pass'] and s['gap_gate_pass']
  rows.append(dict(mode=group['mode'],group=group['group'],name=name,status=status,summary=s,execution_pass=execution,work_pass=qualified))
def quantile(xs,q):
 a=sorted(xs);at=(len(a)-1)*q;i=int(at);return a[i]+(a[min(i+1,len(a)-1)]-a[i])*(at-i)
aggregates={};comparisons={}
for mode in spec['modes']:
 selected=[x for x in rows if x['mode']==mode];aggregates[mode]={}
 for name in ['baseline','candidate']:
  cells=[x for x in selected if x['name']==name];ss=[x['summary'] for x in cells if x['summary'] is not None]
  v=dict(observations=len(cells),execution_passes=sum(x['execution_pass'] for x in cells),work_passes=sum(x['work_pass'] for x in cells))
  for field in ['ticks','first_second_gaps_over25ms','later_gaps_over25ms','total_gaps_over25ms']:v[field]=[s[field] for s in ss]
  for field in ['cpu_cores','mean_rss_bytes','max_rss_bytes','visible_seconds']:
   values=[s[field] for s in ss if field in s];v[field+'_median']=statistics.median(values) if len(values)==8 else None
  aggregates[mode][name]=v
 eligible=all(x['work_pass'] for x in selected) and len(selected)==16
 if not eligible:
  comparisons[mode]=dict(eligible=False,passed=False,reason='Execution/work/cadence gate failed; comparative CPU ratio suppressed.');continue
 if mode=='idle':
  b=aggregates[mode]['baseline']['cpu_cores_median'];c=aggregates[mode]['candidate']['cpu_cores_median']
  comparisons[mode]=dict(eligible=True,baseline_cpu=b,candidate_cpu=c,passed=c<=b,ratio=None,rule=spec['idle_rule']);continue
 pairs=[]
 for group in range(8):
  b=next(x['summary'] for x in selected if x['name']=='baseline' and x['group']==group);c=next(x['summary'] for x in selected if x['name']=='candidate' and x['group']==group)
  pairs.append(dict(group=group,baseline_cpu=b['cpu_cores'],candidate_cpu=c['cpu_cores'],ratio=c['cpu_cores']/b['cpu_cores'] if b['cpu_cores']>0 else None))
 if any(p['ratio'] is None for p in pairs):
  comparisons[mode]=dict(eligible=False,passed=False,pairs=pairs,reason='Active baseline CPU denominator is zero; no finite comparative ratio.');continue
 values=[p['ratio'] for p in pairs];point=statistics.median(values);rng=random.Random(spec['seed']);boot=[statistics.median(rng.choices(values,k=8)) for _ in range(spec['bootstrap_resamples'])]
 comparisons[mode]=dict(eligible=True,pairs=pairs,median_paired_cpu_ratio=point,paired_bootstrap_95=[quantile(boot,.025),quantile(boot,.975)],limit=spec['limits'][mode],passed=point<=spec['limits'][mode])
result=dict(rows=rows,aggregates=aggregates,comparisons=comparisons,all_execution_pass=all(x['execution_pass'] for x in rows),candidate_passes=len(rows)==64 and all(x['execution_pass'] for x in rows) and all(v['passed'] for v in comparisons.values()),scope='Fixed visible+1..6 process CPU interval; cadence-qualified cohort only. Whole-run counts do not prove identical interval work. Software Vulkan, no ZGX/hardware/scanout or quality victory.')
(r/'analysis.json').write_text(json.dumps(result,indent=2));print(json.dumps(dict(candidate_passes=result['candidate_passes'],comparisons=comparisons),indent=2))
