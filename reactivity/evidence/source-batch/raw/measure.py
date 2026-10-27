import pathlib,subprocess,json,hashlib,csv,statistics,platform,time
root=pathlib.Path(__file__).resolve().parent;out=root/'paired';out.mkdir(exist_ok=False)
names=['control','candidate'];cases=[(rows,n,mode) for rows in [0,1,40] for mode in ['exact','owner'] for n in [1,2,4]]+[(rows,4,'opaque') for rows in [0,1,40]]
paths={n:pathlib.Path('/home/user/'+('gpui-source-batch-target' if n=='candidate' else 'gpui-source-batch-control-target')+'/release/examples/source_batch_cost') for n in names}
font=pathlib.Path('/home/user/zgx-reference-local/comparisons/fonts/DejaVuSans.ttf');hashes={n:hashlib.sha256(p.read_bytes()).hexdigest() for n,p in {**paths,'font':font}.items()}
for n in names:assert hashes[n]==json.loads((root/('fixture' if n=='candidate' else 'control')/'artifact.json').read_text())['sha256']
meta={'binaries':{n:str(p) for n,p in paths.items()},'hashes':hashes,'font':str(font),'sources':{n:(root/('fixture' if n=='candidate' else 'control')/'source.txt').read_text().strip() for n in names},'cases':cases,'warmup':200,'batches':40,'ops':100,'cpu_affinity':2,'platform':platform.platform(),'compiler':subprocess.check_output(['rustc','+nightly-2026-10-23','-Vv'],text=True),'started':time.time()}
(out/'metadata.json').write_text(json.dumps(meta,indent=2));runs=[];finals={}
for repeat in range(5):
 for cell,(rows,n,mode) in enumerate(cases):
  case=f'{rows}-{n}-{mode}';order=names if (repeat+cell)%2==0 else names[::-1]
  for name in order:
   stem=f'{repeat}-{case}-{name}';cmd=['/usr/bin/time','-v','-o',str(out/(stem+'.time')),'taskset','-c','2',str(paths[name]),str(rows),str(n),mode,str(font)]
   with (out/(stem+'.csv')).open('w') as a,(out/(stem+'.log')).open('w') as b:result=subprocess.run(cmd,stdout=a,stderr=b)
   (out/(stem+'.status.json')).write_text(json.dumps({'command':cmd,'exit':result.returncode}));assert result.returncode==0,(stem,result.returncode)
   data=list(csv.DictReader((out/(stem+'.csv')).open()));assert len(data)==40 and [int(r['batch']) for r in data]==list(range(40));assert all(int(r['rows'])==rows and int(r['fields'])==n and r['mode']==mode and r['ops']=='100' for r in data)
   log=(out/(stem+'.log')).read_text().splitlines();final=next(s for s in log if s.startswith('FINAL,'));assert final==finals.setdefault(case,final),(stem,final,finals[case])
   counters=next(s for s in log if s.startswith('COUNTERS,'));expected=0 if mode=='exact' and (n==1 or name=='candidate') else 4000;assert f'owner_reruns: {expected},' in counters,(stem,counters)
   record={'repeat':repeat,'case':case,'variant':name,'final':final,'counters':counters}
   for clock in ['cpu','wall']:
    values=sorted(int(r[clock+'_ns'])/100 for r in data);record[clock]={str(q):values[round(39*q)] for q in [.5,.95,.99]}
   runs.append(record)
  print(repeat,case,{r['variant']:round(r['cpu']['0.5'],1) for r in runs if r['case']==case and r['repeat']==repeat},flush=True)
ratios={}
for rows,n,mode in cases:
 case=f'{rows}-{n}-{mode}';values=[]
 for repeat in range(5):
  cells={r['variant']:r for r in runs if r['case']==case and r['repeat']==repeat};values.append(cells['candidate']['cpu']['0.5']/cells['control']['cpu']['0.5'])
 ratios[case]={'paired_ratios':values,'median':statistics.median(values),'range':[min(values),max(values)]}
assert all(hashlib.sha256(p.read_bytes()).hexdigest()==hashes[n] for n,p in {**paths,'font':font}.items())
(out/'summary.json').write_text(json.dumps({'runs':runs,'ratios':ratios},indent=2));print(json.dumps(ratios,indent=2),flush=True)
