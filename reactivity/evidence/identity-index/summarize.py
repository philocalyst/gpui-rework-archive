#!/usr/bin/env python3
"""All samples, operation distributions, and allocation observations retained."""
import csv
import json
from pathlib import Path
import statistics
HERE=Path(__file__).resolve().parent
rows={};guards={}
for path in sorted((HERE/'capture').glob('*.txt')):
 kind=path.name.split('-')[0]
 parsed=list(csv.reader(path.read_text().splitlines()))
 current=sorted(','.join(f) for f in parsed if f and f[0]=='guard')
 if kind in guards:assert current==guards[kind]
 else:guards[kind]=current
 for f in parsed:
  if not f or f[0]!='cost':continue
  if kind=='owner':tag=path.stem.split('-')[-1];key=(kind,f[1],'owner',int(f[2]),tag);values=f[3:]
  else:key=(kind,f[1],f[3],int(f[4]),f[2]);values=f[5:]
  rows.setdefault(key,[]).append([int(x) for x in values])
result=[]
for (kind,phase,mode,count,tag),samples in sorted(rows.items()):
 assert len(samples)==(3 if kind=='owner' else 4)
 times=[s[1]/s[0] for s in samples]
 baseline='baseline' if kind=='owner' else 'tree'
 packed='packed' if kind=='owner' else 'packed12'
 old=statistics.median(s[1]/s[0] for s in rows[kind,phase,mode,count,baseline])
 first=statistics.median(s[1]/s[0] for s in rows[kind,phase,mode,count,packed])
 median=statistics.median(times)
 result.append({'kind':kind,'phase':phase,'mode':mode,'count':count,'variant':tag,'median_ns':median,'min_ns':min(times),'max_ns':max(times),'versus_baseline_percent':100*(median/old-1),'versus_packed_percent':100*(median/first-1),'ns_per_operation':times,'samples':samples})
assert sum(len(r['samples']) for r in result)==996
(HERE/'summary.json').write_text(json.dumps(result,indent=2)+'\n')
with (HERE/'summary.csv').open('w') as stream:
 writer=csv.writer(stream,lineterminator='\n');writer.writerow(['kind','phase','mode','count','variant','samples','median_ns','min_ns','max_ns','versus_baseline_percent','versus_packed_percent'])
 for r in result:writer.writerow([r[k] if k!='samples' else len(r[k]) for k in ['kind','phase','mode','count','variant','samples','median_ns','min_ns','max_ns','versus_baseline_percent','versus_packed_percent']])
print('ALL996ROWS_RETAINED; cross-round full oracles agree')
