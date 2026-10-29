from pathlib import Path
import hashlib,json,tarfile,math,statistics,collections
root=Path(__file__).parent

def sha(p):
 with p.open('rb') as f:return hashlib.file_digest(f,'sha256').hexdigest()
manifest=json.loads((root/'MANIFEST.json').read_text())
for name,h in manifest.items():assert sha(root/name)==h,name
raw=json.loads((root/'RAW_MANIFEST.json').read_text());archive=tarfile.open(root/'raw.tar.gz','r:gz')
# Sequential integrity pass avoids expanding the capture on disk.
seen=set()
for m in archive:
 assert m.isfile() and m.name in raw and m.name not in seen,m.name
 f=archive.extractfile(m);assert hashlib.file_digest(f,'sha256').hexdigest()==raw[m.name]['sha256'];assert m.size==raw[m.name]['bytes'];seen.add(m.name)
assert seen==set(raw)
archive.close();archive=tarfile.open(root/'raw.tar.gz','r:gz')
# A second streaming pass retains only analysis inputs, logs and pixels.
blobs={m.name:archive.extractfile(m).read() for m in archive if m.isfile() and (m.name.endswith(('.json','.jsonl','.rgba','.wgsl')) or m.name in ['campaign.py','analyze.py','qualify.py','build_gate.py'])}
def read(name):return blobs[name]
def j(name):return json.loads(read(name))
assert j('timing/guard.json')==[]
assert j('timing/inputs-before.json')==j('timing/inputs-after.json')
assert read('candidate-gate/ui.wgsl')==read('control-gate/ui.wgsl')
assert (root/'frozen/candidate-harness.rs').read_bytes()==(root/'frozen/control-harness.rs').read_bytes()
for name in ['campaign.py','analyze.py','qualify.py','build_gate.py']:assert (root/name).read_bytes()==read(name)
canonical=[]
for role in ['control','candidate']:
 assert j(role+'-gate/guard.json')==[]
 assert j(role+'-gate/clippy.status.json')['exit']==0
 a=j(role+'-gate/artifact.json');assert not a['cargo_fresh'];p=Path(a['preserved'])
 if p.exists():assert sha(p)==a['sha256'];canonical.append(role)
preflight=0
for role,cells in j('qualification.json').items():
 for cell,q in cells.items():
  base=role+'-gate/'+cell;data=j(base+'/result.json');assert data['preflight'] and len(data['checked'])==12
  assert j(role+'-gate/preflight-'+cell+'.status.json')['exit']==0
  for label in ['initial']+[f'check-{i}' for i in range(12)]:
   images=[read(base+'/'+label+'-'+suffix+'.rgba') for suffix in ['actual','cpu','fresh','full']];assert len(images[0])==16384 and all(x==images[0] for x in images);preflight+=1
order=j('order.json');assert len(order)==408
# Reconstruct the entire preregistered process ordering independently.
expected=[]
for rnd in range(6):
 sizes=[1,9,32,256,1024];sizes=sizes[rnd%5:]+sizes[:rnd%5]
 for n in sizes:
  modes=['single','coalesced','return-original'];modes=modes[::-1] if rnd%2 else modes
  for mode in modes+(['geometry'] if n in [1,1024] else []):
   for role in (['candidate','control','control','candidate'] if rnd%2 else ['control','candidate','candidate','control']):
    expected.append(dict(name=f'{len(expected):03d}-{role}-{mode}-{n}',index=len(expected),round=rnd,n=n,mode=mode,role=role))
assert order==expected
ps=collections.defaultdict(list);samples=warmups=pixels=0
for c in order:
 name=c['name'];base='timing/'+name;d=j(base+'/result.json');config={k:v for k,v in c.items() if k!='name'};assert d['config']==config==j('configs/'+name+'.json');assert not d['preflight']
 assert j('timing/'+name+'.status.json')['exit']==0
 rows=d['samples'];assert len(rows)==512 and len(d['warmups'])==64;samples+=512;warmups+=64
 events=[json.loads(l) for l in read(base+'/events.jsonl').splitlines()];assert events==d['warmups']+rows
 allowed=j('qualification.json')[c['role']][f"{c['mode']}-{c['n']}"]['work']
 for row in events:
  assert [row[k] for k in ['upload_bytes','validated_draws','binning_tile_visits']] in allowed
  assert sum(row[k] for k in ['source_ns','render_submit_ns','completion_wait_ns','ack_ns'])==row['endpoint_ns']
 for phase,count in [('warmup',64),('timing',512)]:assert [(x['phase'],x['i']) for x in events if x['phase']==phase]==[(phase,i) for i in range(count)]
 for label in ['initial','after-warmup','final']:
  images=[read(base+'/'+label+'-'+suffix+'.rgba') for suffix in ['actual','cpu','fresh','full']];assert len(images[0])==16384 and all(x==images[0] for x in images);pixels+=1
 p95=sorted(x['endpoint_ns'] for x in rows)[math.ceil(.95*512)-1];ps[(c['mode'],c['n'],c['round'],c['role'])].append(p95)
a=j('analysis.json');assert a==json.loads((root/'analysis.json').read_text())
failed=[]
for c in a['cells']:
 ratios=[math.sqrt(math.prod(ps[(c['mode'],c['n'],rnd,'candidate')])/math.prod(ps[(c['mode'],c['n'],rnd,'control')])) for rnd in range(6)]
 threshold=.8 if c['mode'] in ['coalesced','return-original'] and c['n'] in [256,1024] else 1.05
 assert ratios==c['ratios'] and statistics.median(ratios)==c['ratio'] and threshold==c['threshold'] and c['passed']==(c['ratio']<=threshold)
 if not c['passed']:failed.append((c['mode'],c['n']))
assert failed==[('single',1024)] and a['verdict']=='NOT ADMITTED'
assert (preflight,pixels,samples,warmups)==(442,1224,208896,26112)
print(json.dumps(dict(verified=True,archived_files=len(raw),preflight_pixel_comparisons=preflight,timing_pixel_comparisons=pixels,samples=samples,warmups=warmups,canonical_ELFs_checked=canonical,verdict=a['verdict'],failed=failed)))
