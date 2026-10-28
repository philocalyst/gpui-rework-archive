from pathlib import Path
import json,statistics,random,hashlib
r=Path(__file__).parent;spec=json.loads((r/'COST.json').read_text());names=spec['names'];rows={};comparisons={};gates={}
def median(xs):return statistics.median(xs) if xs and all(x is not None for x in xs) else None
def quantile(xs,p):
 a=sorted(xs);at=(len(a)-1)*p;i=int(at);return a[i]+(a[min(i+1,len(a)-1)]-a[i])*(at-i)
for mode in spec['modes']:
 items={n:[] for n in names}
 for group in range(8):
  for n in names:
   p=r/'timing'/mode/str(group)/n;status=json.loads((p/'status.json').read_text())
   x=json.loads((p/'summary.json').read_text()) if (p/'summary.json').exists() else {}
   items[n].append(dict(summary=x,status=status,qualified=bool(x) and status['exit']==0 and status['failure'] is None))
 rows[mode]={}
 for n,values in items.items():
  rates=[v['summary'].get('cpu_cores') for v in values];rss=[v['summary'].get('mean_rss_bytes') for v in values];peak=[v['summary'].get('max_rss_bytes') for v in values]
  rows[mode][n]=dict(processes=len(values),complete_summaries=sum(bool(v['summary']) for v in values),qualified=[v['qualified'] for v in values],failures=[v['status']['failure'] for v in values],cpu_cores_all=rates,cpu_cores_median=median(rates),ticks_all=[v['summary'].get('ticks') for v in values],interval_seconds_all=[v['summary'].get('interval_seconds') for v in values],median_mean_rss_bytes=median(rss),maximum_sampled_rss_bytes=max(peak) if all(v is not None for v in peak) else None,native_acknowledgements_all=[v['summary'].get('native_acknowledgements') for v in values],visible_seconds_all=[v['summary'].get('visible_seconds') for v in values])
 comparisons[mode]={}
 for a,b in [('candidate','zgx'),('candidate','control'),('candidate','sparse')]:
  ratios=[];equal=[]
  for x,y in zip(items[a],items[b]):
   xx=x['summary'];yy=y['summary'];den=yy.get('cpu_cores')
   ratios.append(xx['cpu_cores']/den if x['qualified'] and y['qualified'] and den else None)
   equal.append(xx.get('ticks')==yy.get('ticks') if xx and yy else None)
  record=dict(paired_cpu_rate_ratios=ratios,equal_total_ticks_each_pair=equal)
  if all(v is not None for v in ratios):
   rng=random.Random(spec['seed']);boot=[statistics.median(rng.choices(ratios,k=8)) for _ in range(spec['bootstrap_resamples'])]
   record.update(median_ratio=statistics.median(ratios),bootstrap_95_type7=[quantile(boot,.025),quantile(boot,.975)])
  else:record['note']='Incomplete/failed observation or zero denominator; no passing-subset or complete eight-pair CPU ratio inferred.'
  comparisons[mode][a+'/'+b]=record
 if mode=='idle':
  gates[mode]=dict(pass_gate=all(v['qualified'] and v['summary'].get('ticks')==0 and v['summary'].get('cpu_cores',float('inf'))<=spec['idle_cpu_cores_limit'] for v in items['candidate']),limit_cpu_cores=spec['idle_cpu_cores_limit'])
 else:
  qualified=all(v['qualified'] for n in ['candidate','zgx'] for v in items[n]);ratio=comparisons[mode]['candidate/zgx'].get('median_ratio')
  gates[mode]=dict(candidate_and_zgx_all_qualified=qualified,median_ratio=ratio,limit=spec['candidate_cpu_ratio_limit'],pass_gate=qualified and ratio is not None and ratio<=spec['candidate_cpu_ratio_limit'])
result=dict(local_native_gates_pass=all(v['pass_gate'] for v in gates.values()),processes=128,rows=rows,comparisons=comparisons,gates=gates,order_sha256=hashlib.file_digest((r/'timing/order.json').open('rb'),'sha256').hexdigest(),limits=['Software Vulkan/process CPU includes raster workers.','Whole-run admitted ticks and sampled CPU have different boundaries; no per-update normalization.','Hardware/two-class, scanout, wheel/input-policy and render-quality gates remain open.','No global ZGX/framework victory is inferred from this local trial.'])
(r/'analysis.json').write_text(json.dumps(result,indent=2));print(json.dumps(gates,indent=2));print('LOCAL_NATIVE_GATES_PASS',result['local_native_gates_pass'])
