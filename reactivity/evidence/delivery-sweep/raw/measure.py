import pathlib,subprocess,json,hashlib,csv,statistics,platform,time
root=pathlib.Path(__file__).resolve().parent
out=root/'paired';out.mkdir(exist_ok=False)
names=['control','candidate'];cases=[(n,m) for n in [1,8,32,64] for m in ['idle','one','all','rotate']]
paths={n:pathlib.Path('/home/user/'+('gpui-delivery-sweep-target' if n=='candidate' else 'gpui-delivery-control-target')+'/release/examples/delivery_sweep_cost') for n in names}
hashes={n:hashlib.sha256(p.read_bytes()).hexdigest() for n,p in paths.items()}
meta={'binaries':{n:str(p) for n,p in paths.items()},'hashes':hashes,'sources':{n:(root/(n+'-qualified')/'source.txt').read_text().strip() for n in names},'cases':cases,'warmup':200,'batches':40,'ops':100,'cpu_affinity':2,'platform':platform.platform(),'compiler':subprocess.check_output(['rustc','+nightly-2026-10-23','-Vv'],text=True),'started':time.time()}
(out/'metadata.json').write_text(json.dumps(meta,indent=2));runs=[];finals={}
for repeat in range(5):
 for cell,(n,mode) in enumerate(cases):
  case=f'{n}-{mode}';order=names if (repeat+cell)%2==0 else names[::-1]
  for name in order:
   stem=f'{repeat}-{case}-{name}';cmd=['/usr/bin/time','-v','-o',str(out/(stem+'.time')),'taskset','-c','2',str(paths[name]),str(n),mode]
   with (out/(stem+'.csv')).open('w') as a,(out/(stem+'.log')).open('w') as b:result=subprocess.run(cmd,stdout=a,stderr=b)
   (out/(stem+'.status.json')).write_text(json.dumps({'command':cmd,'exit':result.returncode}));assert result.returncode==0,(stem,result.returncode)
   rows=list(csv.DictReader((out/(stem+'.csv')).open()));assert len(rows)==40 and [int(r['batch']) for r in rows]==list(range(40));assert all(int(r['lanes'])==n and r['mode']==mode and r['ops']=='100' for r in rows)
   final=next(s for s in (out/(stem+'.log')).read_text().splitlines() if s.startswith('FINAL,'));assert final==finals.setdefault(case,final),(stem,final,finals[case])
   record={'repeat':repeat,'case':case,'variant':name,'final':final}
   for clock in ['cpu','wall']:
    values=sorted(int(r[clock+'_ns'])/100 for r in rows);record[clock]={str(q):values[round(39*q)] for q in [.5,.95,.99]}
   runs.append(record)
  print(repeat,case,{r['variant']:round(r['cpu']['0.5'],1) for r in runs if r['case']==case and r['repeat']==repeat},flush=True)
ratios={}
for n,m in cases:
 case=f'{n}-{m}';values=[]
 for repeat in range(5):
  cells={r['variant']:r for r in runs if r['case']==case and r['repeat']==repeat};values.append(cells['candidate']['cpu']['0.5']/cells['control']['cpu']['0.5'])
 ratios[case]={'paired_ratios':values,'median':statistics.median(values),'range':[min(values),max(values)]}
assert all(hashlib.sha256(p.read_bytes()).hexdigest()==hashes[n] for n,p in paths.items())
(out/'summary.json').write_text(json.dumps({'runs':runs,'ratios':ratios},indent=2));print(json.dumps(ratios,indent=2),flush=True)
