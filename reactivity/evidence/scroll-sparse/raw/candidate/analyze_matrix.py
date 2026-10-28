from pathlib import Path
import json,statistics,random,hashlib
root=Path(__file__).resolve().parent;out=root/'matrix-analysis';out.mkdir(exist_ok=False)
rows=json.loads((root/'matrix-timing/results.json').read_text());assert len(rows)==2800
definition=json.loads((root/'cost-definition.json').read_text());cases=definition['cases']
def quantile(xs,q):
 a=sorted(xs);n=(len(a)-1)*q;i=int(n);return a[i]+(a[min(i+1,len(a)-1)]-a[i])*(n-i)
summary={};processes=[]
for row in rows:
 values=[r[1] for r in row['rows'] if r[0]>=16];assert len(values)==64
 processes.append({**{k:row[k] for k in ['case','variant','pair','label']},'p50_ns':statistics.median(values),'p95_ns':quantile(values,.95),'p99_ns':quantile(values,.99),'mount_ns':int(row['setup'][0]),'first_ns':int(row['setup'][1]),'hash':row['setup'][2],'epoch':int(row['setup'][3]),'first_update_ns':row['rows'][0][1],'image_bytes':max(r[4] for r in row['rows'])})
for case in cases:
 variants={v:{field:statistics.median([p[field] for p in processes if p['case']==case and p['variant']==v]) for field in ['p50_ns','p95_ns','p99_ns','mount_ns','first_ns','first_update_ns','image_bytes']} for v in definition['variants']}
 comparisons={}
 for baseline in [v for v in definition['variants'] if v!='candidate']:
  pairs=[]
  for pair in range(20):
   c=next(p for p in processes if p['case']==case and p['variant']=='candidate' and p['pair']==pair);b=next(p for p in processes if p['case']==case and p['variant']==baseline and p['pair']==pair)
   assert (c['hash'],c['epoch'])==(b['hash'],b['epoch'])
   pairs.append({'pair':pair,**{field:c[field]/b[field] for field in ['p50_ns','p95_ns','p99_ns','mount_ns','first_ns','first_update_ns']}})
  ratios=[p['p50_ns'] for p in pairs];rng=random.Random(20261104);boot=[statistics.median(rng.choices(ratios,k=20)) for _ in range(10000)];point=statistics.median(ratios);limit=definition['thresholds'][case][baseline]
  comparisons[baseline]={'median_paired_ratio':point,'paired_bootstrap_95':[quantile(boot,.025),quantile(boot,.975)],'limit':limit,'pass':point<=limit,'ratio_of_process_medians':variants['candidate']['p50_ns']/variants[baseline]['p50_ns'],'pairs':pairs}
 summary[case]={'variants':variants,'comparisons':comparisons}
(out/'processes.json').write_text(json.dumps(processes,indent=2));(out/'summary.json').write_text(json.dumps(summary,indent=2));(out/'verdict.json').write_text(json.dumps({'all_point_gates_pass':all(v['pass'] for s in summary.values() for v in s['comparisons'].values()),'source':'matrix-timing/results.json','source_sha256':hashlib.sha256((root/'matrix-timing/results.json').read_bytes()).hexdigest(),'estimator':'median of twenty paired process-median ratios; type-7 quantiles; paired median bootstrap seed20261104/10000 resamples'},indent=2))
for c,s in summary.items():
 for b,v in s['comparisons'].items():print(c,'vs',b,f"ratio={v['median_paired_ratio']:.9f}",f"CI={v['paired_bootstrap_95']}", 'PASS' if v['pass'] else 'FAIL')
