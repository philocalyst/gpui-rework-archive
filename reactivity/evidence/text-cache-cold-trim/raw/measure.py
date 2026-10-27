#!/usr/bin/env python3
import pathlib,json,csv,subprocess,hashlib,statistics,time,platform
root=pathlib.Path(__file__).resolve().parent
out=root/'paired-cold';out.mkdir(exist_ok=False)
bins={'sparse':'/home/user/gpui-sparse-text-target/release/examples/state_update_cost','cache':'/home/user/gpui-text-session-target/release/examples/state_update_cost','bounded':'/home/user/gpui-bounded-cache-target/release/examples/state_update_cost','cold':'/home/user/gpui-cold-trim-target/release/examples/state_update_cost'}
font='/home/user/zgx-reference-local/comparisons/fonts/DejaVuSans.ttf'
sources={'sparse':'d5848eb970','cache':'c7194c74e6','bounded':'fefa519956','cold':'606dd0f67d7a35b03338a3bd764564abeb420959'}
hashes={k:hashlib.sha256(pathlib.Path(p).read_bytes()).hexdigest() for k,p in {**bins,'font':font}.items()}
meta={'binaries':bins,'hashes':hashes,'production_source_pins':sources,'font':font,'warmup':200,'operations':2000,'batch':10,'repetitions':5,'rows':[0,1,4,40,400],'started':time.time(),'platform':platform.platform(),'compiler':subprocess.check_output(['rustc','+nightly-2026-10-23','-Vv'],text=True)}
(out/'metadata.json').write_text(json.dumps(meta,indent=2)+'\n')
records=[]
def quantile(a,p):return sorted(a)[round((len(a)-1)*p)]
for repeat in range(5):
 for cell,rows in enumerate(meta['rows']):
  labels=list(bins);shift=(repeat+cell)%4;labels=labels[shift:]+labels[:shift]
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
 for baseline in ['sparse','cache','bounded']:
  values=[]
  for repeat in range(5):
   cells={r['variant']:r['cpu']['0.5'] for r in records if r['rows']==rows and r['repeat']==repeat}
   values.append(cells['cold']/cells[baseline])
  ratios[rows][baseline]={'paired_ratios':values,'median':statistics.median(values),'range':[min(values),max(values)]}
assert all(hashlib.sha256(pathlib.Path(p).read_bytes()).hexdigest()==hashes[k] for k,p in {**bins,'font':font}.items())
(out/'summary.json').write_text(json.dumps({'runs':records,'ratios':ratios},indent=2)+'\n')
print(json.dumps(ratios,indent=2),flush=True)
