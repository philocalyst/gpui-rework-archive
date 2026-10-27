#!/usr/bin/env python3
from pathlib import Path
import hashlib,json,re,struct
root=Path(__file__).resolve().parent
manifest=json.loads((root/'manifest.json').read_text())
for p,h in manifest.items():assert hashlib.sha256((root/p).read_bytes()).hexdigest()==h,p
raw=root/'raw'
for phase in ['exact-source-first','exact-source-qualified']:
 d=raw/phase;assert json.loads((d/'guard-after.json').read_text())==[]
 for name in ['build','test','clippy']:
  expected=101 if (phase,name)==('exact-source-first','clippy') else 0
  assert json.loads((d/(name+'.status.json')).read_text())['exit']==expected
 assert '8 passed; 0 failed' in (d/'test.out').read_text()
a=json.loads((raw/'exact-source-qualified/artifact.json').read_text());p=Path(a['path']);assert p.stat().st_size==a['bytes'] and hashlib.sha256(p.read_bytes()).hexdigest()==a['sha256']
rows=[]
for mode,route,folder in [('stream','exact','wm-close'),('stream','owner','wm-close'),('scroll','owner','wm-close'),('both','owner','wm-close'),('idle','owner','idle-completion')]:
 d=raw/('native-exact-source-qualified-'+folder);name=mode+'-'+route;s=(d/(name+'.log')).read_text();assert 'PRESENTATION_ERROR' not in s and 'workload_error' not in s
 ticks=int(re.search(r'WORKLOAD_FINISHED admitted_ticks=(\d+)',s)[1]);total,admitted,mounted=map(int,re.search(r'workload_ticks=(\d+) admitted_ticks=(\d+) mounted_rows=(\d+)',s).groups());assert total==190+ticks and admitted==ticks and mounted<=19
 acks=[tuple(map(int,m)) for m in re.findall(r'GPUI_ACK,(\d+),(\d+),(\d+)',s)];assert acks and all(x[1]<=y[1] for x,y in zip(acks,acks[1:]));reported=int(re.search(r'native_acknowledgements=(\d+)',s)[1]);assert reported==len(acks)
 if mode=='idle':assert ticks==0 and len(acks)<=2
 else:assert ticks>0 and len(acks)>1
 png=(d/(name+'.png')).read_bytes();assert png[:8]==b'\x89PNG\r\n\x1a\n' and struct.unpack('>II',png[16:24])==(960,720)
 rows.append({'mode':mode,'route':route,'ticks':ticks,'acknowledgements':len(acks),'distinct_epochs':len({a[1] for a in acks}),'final_source_epoch':acks[-1][0]})
assert rows==json.loads((root/'native-summary.json').read_text())
assert json.loads((raw/'native-exact-source-qualified-idle-completion/guard-after.json').read_text())==[]
print(json.dumps({'verified_files':len(manifest),'tests':8,'native':rows,'performance_verdict':'not measured; parity incomplete'},indent=2))
