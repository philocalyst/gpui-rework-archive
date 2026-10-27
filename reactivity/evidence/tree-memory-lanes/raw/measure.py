import pathlib,subprocess,json,hashlib,csv,statistics,platform,time
root=pathlib.Path(__file__).resolve().parent;out=root/'paired';out.mkdir(exist_ok=False)
names=['original','scalar','levels','nohint','hint','proof']
paths={n:pathlib.Path('/home/user/gpui-tree-'+('lanes' if n=='hint' else n)+'-target/release/examples/tree_lane_cost') for n in names}
cases=['tiny','contiguous','shuffled','medium-depth','shallow','single-full']
hashes={n:hashlib.sha256(p.read_bytes()).hexdigest() for n,p in paths.items()}
meta={'variants':{n:str(p) for n,p in paths.items()},'hashes':hashes,'cases':cases,'repetitions':5,'warmup':20,'batches':40,'ops_per_batch':5,'platform':platform.platform(),'compiler':subprocess.check_output(['rustc','+nightly-2026-10-23','-Vv'],text=True),'started':time.time(),'sources':{n:(root/('qualified' if n=='hint' else n)/'source.txt').read_text().strip() for n in names}}
(out/'metadata.json').write_text(json.dumps(meta,indent=2));runs=[];finals={}
for repeat in range(5):
 for cell,case in enumerate(cases):
  shift=(repeat+cell)%6;order=names[shift:]+names[:shift]
  if repeat%2:order.reverse()
  for name in order:
   stem=f'{repeat}-{case}-{name}';cmd=['/usr/bin/time','-v','-o',str(out/(stem+'.time')),str(paths[name]),case]
   with (out/(stem+'.csv')).open('w') as a,(out/(stem+'.log')).open('w') as b: result=subprocess.run(cmd,stdout=a,stderr=b)
   (out/(stem+'.status.json')).write_text(json.dumps({'command':cmd,'exit':result.returncode}));assert result.returncode==0,(stem,result.returncode)
   rows=list(csv.DictReader((out/(stem+'.csv')).open()));assert len(rows)==40 and [int(r['batch']) for r in rows]==list(range(40));assert all(r['case']==case and r['ops']=='5' for r in rows)
   final=next(s for s in (out/(stem+'.log')).read_text().splitlines() if s.startswith('FINAL,'));assert final==finals.setdefault(case,final),(stem,final,finals[case])
   record={'repeat':repeat,'case':case,'variant':name,'final':final}
   for clock in ['cpu','wall']:
    values=sorted(int(r[clock+'_ns'])/5 for r in rows);record[clock]={str(q):values[round(39*q)] for q in [.5,.95,.99]}
   runs.append(record)
  print(repeat,case,{r['variant']:round(r['cpu']['0.5'],1) for r in runs if r['case']==case and r['repeat']==repeat},flush=True)
ratios={}
for case in cases:
 ratios[case]={}
 for name in names[1:]:
  values=[]
  for repeat in range(5):
   cells={r['variant']:r for r in runs if r['case']==case and r['repeat']==repeat};values.append(cells[name]['cpu']['0.5']/cells['original']['cpu']['0.5'])
  ratios[case][name]={'paired_ratios':values,'median':statistics.median(values),'range':[min(values),max(values)]}
assert all(hashlib.sha256(p.read_bytes()).hexdigest()==hashes[n] for n,p in paths.items())
(out/'summary.json').write_text(json.dumps({'runs':runs,'ratios':ratios},indent=2));print(json.dumps(ratios,indent=2),flush=True)
