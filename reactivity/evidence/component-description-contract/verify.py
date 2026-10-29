from pathlib import Path
import json,hashlib
r=Path(__file__).parent;sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
m=json.loads((r/'MANIFEST.json').read_text());assert set(m)=={p.relative_to(r).as_posix() for p in r.rglob('*') if p.is_file() and p.name!='MANIFEST.json'}
for n,h in m.items():assert sha(r/n)==h,n
b=r/'raw/first'
for g in ['build','tests','clippy']:assert json.loads((b/(g+'.status.json')).read_text())['exit']==0
assert json.loads((b/'guard.json').read_text())==[]
a=json.loads((b/'artifact.json').read_text());assert sha(Path(a['preserved']))==a['sha256'] and Path(a['preserved']).stat().st_size==a['bytes'] and not a['cargo_fresh']
assert json.loads((b/'driver.json').read_text())['sha256']==sha(r/'raw/gate.py')
assert (r/'source.txt').read_bytes()==(b/'source.txt').read_bytes()
inputs=json.loads((b/'inputs-before.json').read_text())
for p in (r/'frozen').rglob('*'):
 if p.is_file():assert sha(p)==inputs[p.relative_to(r/'frozen').as_posix()]
rows=[]
for l in (b/'build.out').read_text().splitlines():
 d=json.loads(l)
 if d.get('reason')=='compiler-artifact' and d['target']['name'] in ['gpui','component_description_contract','gpui_canvas','gpui_gpu']:rows.append({k:d[k] for k in ['target','profile','features','fresh','executable']})
assert rows==json.loads((b/'compiled-profiles.json').read_text());gpui=next(x for x in rows if x['target']['name']=='gpui');assert not gpui['profile']['test'] and gpui['features']==[] and not gpui['fresh']
x=json.loads((b/'trace/trace.json').read_text());assert len(x)==3
for label,count in [('equal-setter',1152),('future-decoration',1536)]:
 c=next(c for c in x if c['case']==label);a=(b/'trace'/f'{label}-full.rgba').read_bytes();z=(b/'trace'/f'{label}-omitted-caller-model.rgba').read_bytes();assert len(a)==len(z)==16384;assert sum(i!=j for i,j in zip(a,z))==c['wrong_pixel_bytes']==count;assert c['parent_child_view_calls']==[1,1] and c['counters']['owner_reruns']==1;assert c['before']['nodes'][1]['identity']==c['after']['nodes'][1]['identity']
c=next(c for c in x if c['case']=='repeated-occurrence');assert c['parent_child_view_calls']==[1,2] and c['counters']['owner_reruns']==1
print(f'verified {len(m)} files; equal-setter1152/future-decoration1536 wrong bytes and repeated occurrence; no replay optimization or timing')
