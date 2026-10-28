from pathlib import Path
import json,statistics,random,math
r=Path(__file__).parent;orders=json.loads((r/'timing/order.json').read_text());rng=random.Random(20261101);rows={};comparisons={}
def median(v):return statistics.median(v)
def quantile(v,p):
 v=sorted(v);at=(len(v)-1)*p;i=int(at);return v[i]+(v[min(i+1,len(v)-1)]-v[i])*(at-i)
for mode in ['idle','stream','scroll','both']:
 items={n:[] for n in ['control','sparse','zgx']}
 for g in range(6):
  for n in items:
   d=r/'timing'/mode/str(g)/n;s=json.loads((d/'status.json').read_text())
   if not (d/'summary.json').exists():raise RuntimeError(('incomplete observation requires explicit analysis',str(d),s))
   x=json.loads((d/'summary.json').read_text());x['qualified']=s['exit']==0 and s['failure'] is None;x['failure']=s['failure'];items[n].append(x)
 rows[mode]={n:{'processes':len(v),'qualified':[x['qualified'] for x in v],'failures':[x['failure'] for x in v],'cpu_cores_median':median([x['cpu_cores'] for x in v]),'cpu_cores_all':[x['cpu_cores'] for x in v],'ticks_all':[x['ticks'] for x in v],'interval_seconds_all':[x['interval_seconds'] for x in v],'median_mean_rss_bytes':median([x['mean_rss_bytes'] for x in v]),'maximum_sampled_rss_bytes':max(x['max_rss_bytes'] for x in v),'native_acknowledgements_all':[x['native_acknowledgements'] for x in v]} for n,v in items.items()}
 comparisons[mode]={}
 for a,b in [('sparse','control'),('control','zgx'),('sparse','zgx')]:
  ratios=[x['cpu_cores']/y['cpu_cores'] if y['cpu_cores'] and x['qualified'] and y['qualified'] else None for x,y in zip(items[a],items[b])]
  record={'paired_cpu_rate_ratios':ratios,'equal_total_ticks_each_pair':[x['ticks']==y['ticks'] for x,y in zip(items[a],items[b])]}
  if all(v is not None for v in ratios):
   boots=[median([rng.choice(ratios) for _ in ratios]) for _ in range(10000)]
   record.update({'median_ratio':median(ratios),'bootstrap_95_type7':[quantile(boots,.025),quantile(boots,.975)]})
  else:record['note']='zero denominator or failed observation; complete six-pair ratio not inferred'
  comparisons[mode][a+'/'+b]=record
out={'verdict':'diagnostic only; no performance/adoption/ZGX or physical-display qualification','processes':72,'rows':rows,'comparisons':comparisons,'limitations':['software Vulkan CPU includes GPU emulation','no measured physical scanout or presentation count for reference','total ticks do not identify exact work in sampled interval','wheel and render-quality equivalence remain open','all previous fixed failed gates remain failed']}
(r/'analysis.json').write_text(json.dumps(out,indent=2))
for mode in rows:
 print(mode,{n:round(v['cpu_cores_median'],4) for n,v in rows[mode].items()},'ticks',{n:v['ticks_all'] for n,v in rows[mode].items()})
