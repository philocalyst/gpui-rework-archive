#!/usr/bin/env python3
import pathlib,json,csv,subprocess,hashlib,statistics,time,platform
root=pathlib.Path(__file__).resolve().parent
out=root/'paired';out.mkdir(exist_ok=False)
bins={'full':'/home/user/gpui-state-target-baseline/release/examples/state_update_cost','sparse':'/home/user/gpui-sparse-text-target/release/examples/state_update_cost','cache':'/home/user/gpui-text-session-target/release/examples/state_update_cost'}
font='/home/user/zgx-reference-local/comparisons/fonts/DejaVuSans.ttf'
sources={'full':'75a9e2b06b','sparse':'d5848eb970','cache':'42a83c7bca'}
hashes={k:hashlib.sha256(pathlib.Path(p).read_bytes()).hexdigest() for k,p in {**bins,'font':font}.items()}
meta={'binaries':bins,'hashes':hashes,'production_source_pins':sources,'font':font,'warmup':200,'operations':2000,'batch':10,'repetitions':5,'rows':[0,1,4,40,400],'started':time.time(),'platform':platform.platform(),'compiler':subprocess.check_output(['rustc','+nightly-2026-10-23','-Vv'],text=True)}
(out/'metadata.json').write_text(json.dumps(meta,indent=2)+'\n')
records=[]
def quantile(a,p):return sorted(a)[round((len(a)-1)*p)]
for repeat in range(5):
 for cell,rows in enumerate(meta['rows']):
  labels=list(bins);shift=(repeat+cell)%3;labels=labels[shift:]+labels[:shift]
  if repeat%2:labels.reverse()
  for label in labels:
   stem=f'{repeat}-{rows}-{label}'
   command=['/usr/bin/time','-v','-o',str(out/(stem+'.time')),bins[label],str(rows),font]
   with (out/(stem+'.csv')).open('w') as stdout,(out/(stem+'.log')).open('w') as stderr:
    run=subprocess.run(command,stdout=stdout,stderr=stderr)
   (out/(stem+'.status.json')).write_text(json.dumps({'command':command,'exit':run.returncode})+'\n')
   assert run.returncode==0,(stem,run.returncode)
   data=list(csv.DictReader((out/(stem+'.csv')).open()))
   assert len(data)==200 and [int(d['batch']) for d in data]==list(range(200))
   assert all(int(d['rows'])==rows and int(d['ops'])==10 for d in data)
   record={'repeat':repeat,'rows':rows,'variant':label}
   for clock in ['cpu','wall']:
    values=[int(d[clock+'_ns'])/10 for d in data]
    record[clock]={str(p):quantile(values,p) for p in [0.5,0.95,0.99]}
   records.append(record);print(stem,record['cpu']['0.5'],flush=True)
ratios={}
for rows in meta['rows']:
 ratios[rows]={}
 for baseline in ['full','sparse']:
  values=[]
  for repeat in range(5):
   cells={r['variant']:r['cpu']['0.5'] for r in records if r['rows']==rows and r['repeat']==repeat}
   values.append(cells['cache']/cells[baseline])
  ratios[rows][baseline]={'paired_ratios':values,'median':statistics.median(values),'range':[min(values),max(values)]}
assert all(hashlib.sha256(pathlib.Path(p).read_bytes()).hexdigest()==hashes[k] for k,p in {**bins,'font':font}.items())
(out/'summary.json').write_text(json.dumps({'runs':records,'ratios':ratios},indent=2)+'\n')
print(json.dumps(ratios,indent=2),flush=True)
