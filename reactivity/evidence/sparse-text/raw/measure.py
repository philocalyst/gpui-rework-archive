#!/usr/bin/env python3
import csv,hashlib,json,pathlib,subprocess,statistics,sys,time
root=pathlib.Path(__file__).resolve().parent
out=root/'paired-sparse';out.mkdir(exist_ok=False)
bins={'baseline':'/home/user/gpui-state-target-baseline/release/examples/state_update_cost','sparse':'/home/user/gpui-sparse-text-target/release/examples/state_update_cost'}
font='/home/user/zgx-reference-local/comparisons/fonts/DejaVuSans.ttf'
hashes={k:hashlib.sha256(pathlib.Path(p).read_bytes()).hexdigest() for k,p in {**bins,'font':font}.items()}
(out/'metadata.json').write_text(json.dumps({'binaries':bins,'hashes':hashes,'clock':'process CPU and wall','warmup':200,'ops':2000,'batches':200,'rows':[0,1,4,40,400],'repetitions':5,'started':time.time()},indent=2)+'\n')
reports=[]
def q(a,p): return sorted(a)[round((len(a)-1)*p)]
for repeat in range(5):
 for rows in [0,1,4,40,400]:
  order=['baseline','sparse'] if (repeat+[0,1,4,40,400].index(rows))%2==0 else ['sparse','baseline']
  for label in order:
   name=f'{repeat}-{rows}-{label}'
   command=['/usr/bin/time','-v','-o',str(out/(name+'.time')),bins[label],str(rows),font]
   with (out/(name+'.csv')).open('w') as stdout,(out/(name+'.log')).open('w') as stderr:
    p=subprocess.run(command,stdout=stdout,stderr=stderr)
   (out/(name+'.status.json')).write_text(json.dumps({'command':command,'exit':p.returncode})+'\n')
   assert p.returncode==0,(name,p.returncode)
   data=list(csv.DictReader((out/(name+'.csv')).open()))
   assert len(data)==200
   assert [int(d['batch']) for d in data]==list(range(200))
   assert all(int(d['rows'])==rows and int(d['ops'])==10 for d in data)
   cpu=[int(d['cpu_ns'])/10 for d in data];wall=[int(d['wall_ns'])/10 for d in data]
   r={'repeat':repeat,'rows':rows,'variant':label,'cpu':{str(p):q(cpu,p) for p in [0.5,0.95,0.99]},'wall':{str(p):q(wall,p) for p in [0.5,0.95,0.99]}}
   reports.append(r)
   print(name,r['cpu']['0.5'],flush=True)
ratios={}
for rows in [0,1,4,40,400]:
 vals=[]
 for repeat in range(5):
  cells={r['variant']:r for r in reports if r['repeat']==repeat and r['rows']==rows}
  vals.append(cells['sparse']['cpu']['0.5']/cells['baseline']['cpu']['0.5'])
 ratios[rows]={'paired_ratios':vals,'median':statistics.median(vals),'range':[min(vals),max(vals)]}
assert all(hashlib.sha256(pathlib.Path(p).read_bytes()).hexdigest()==hashes[k] for k,p in {**bins,'font':font}.items())
(out/'summary.json').write_text(json.dumps({'runs':reports,'ratios':ratios},indent=2)+'\n')
print(json.dumps(ratios,indent=2))
