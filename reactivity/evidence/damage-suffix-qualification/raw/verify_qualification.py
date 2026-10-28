from pathlib import Path
import json,hashlib,subprocess,re,gzip,tarfile
root=Path(__file__).resolve().parent;r=root/'raw'
def sha(p):return hashlib.file_digest(p.open('rb'),'sha256').hexdigest()
manifest=json.loads((root/'manifest.json').read_text());assert set(manifest)=={str(p.relative_to(root)) for p in root.rglob('*') if p.is_file() and p.name!='manifest.json'}
for p,h in manifest.items():assert sha(root/p)==h,p
q=json.loads((r/'qualification.json').read_text());assert q['source']=='df8ca59f69813e7dd05711fead98ed4278f1688d';seen={}
expected={'gpu-initial':('test',349,3),'full-native-initial':('test',1108,45),'minimal-library-initial':('unit-build',329,25),'default-initial':('test',1015,13),'offline-initial':('test',79,0)}
for gate,stages in q['gates'].items():
 d=r/gate;assert json.loads((d/'guard-after.json').read_text())==[]
 if (d/'source.txt').exists():assert (d/'source.txt').read_text().strip()==q['source']
 for stage,claimed in stages.items():
  status=json.loads((d/(stage+'.status.json')).read_text());assert status==claimed['status'] and status['exit']==0 and not status.get('storage_stop',False)
  triples=re.findall(r'test result: ok\. (\d+) passed; (\d+) failed; (\d+) ignored',(d/(stage+'.out')).read_text());passed=sum(int(a) for a,b,c in triples);ignored=sum(int(c) for a,b,c in triples);assert passed==claimed['passed'] and ignored==claimed['ignored'] and all(int(b)==0 for a,b,c in triples)
  if stage=='clippy':assert status['command'][-2:]==['-D','warnings']
  p=d/(stage+'-artifacts.json')
  if p.exists():
   for a in json.loads(p.read_text()):
    if a['sha256'] not in seen:assert sha(Path(a['preserved']))==a['sha256'];seen[a['sha256']]=a
for gate,(stage,passed,ignored) in expected.items():assert (q['gates'][gate][stage]['passed'],q['gates'][gate][stage]['ignored'])==(passed,ignored)
for gate in ['full-native-remainder','minimal-library-initial']:assert q['gates'][gate]['port']['passed']==17
assert sum(v['passed'] for v in q['gates']['native-checks-initial'].values())==11
assert sum(v['passed'] for v in q['gates']['minimal-native-checks-initial'].values())==4
assert len(seen)==q['unique_executables']
for gate,package in [('gpu-initial','gpui_canvas'),('full-native-initial','gpui')]:
 text=(r/gate/('test.out' if gate=='gpu-initial' else 'build.out')).read_text();objects=[]
 for line in text.splitlines():
  try:a=json.loads(line)
  except ValueError:continue
  if a.get('reason')=='compiler-artifact' and a['target']['name']==package and a['target']['kind']==['lib']:objects.append(a)
 assert objects and any(not a['fresh'] for a in objects)
negative=r/'negative-omit';status=json.loads((negative/'test.status.json').read_text());assert status['exit']==101 and not status['stopped'] and json.loads((negative/'guard-after.json').read_text())==[]
assert 'lost reverse mismatch at 44,2' in (negative/'test.log').read_text() and '0 passed; 1 failed' in (negative/'test.out').read_text()
for a in json.loads((negative/'test-artifacts.json').read_text()):assert sha(Path(a['preserved']))==a['sha256']
for gate in ['full-native-initial','default-initial']:
 assert 'AssertionError' in (r/(gate+'.log')).read_text()
 missing='port' if gate=='full-native-initial' else 'clippy';assert not (r/gate/(missing+'.status.json')).exists()
actual=[dict(owner=a=='true',tick=int(b),pixels=int(c)) for a,b,c in re.findall(r'COLD_STREAM_SUPPORT,(false|true),(\d+),(\d+)',(r/'native-checks-initial/native-5.out').read_text())]
assert actual==json.loads((r/'cold-work-observations.json').read_text()) and len(actual)==100
for owner in [False,True]:
 for tick in range(25):assert sum(x['owner']==owner and x['tick']==tick for x in actual)==2
headers=json.loads((r/'headers/summary.json').read_text())
for k,n in [('RuntimeUnit',1824),('Prepared',40),('TextPatch',96),('TextResources',168),('SceneDamage',40)]:assert headers['baseline'][k]==headers['candidate'][k]==n
for p in (r/'headers').glob('*.status.json'):
 status=json.loads(p.read_text());assert status['exit']==0 and '1 passed; 0 failed' in p.with_name(p.name.replace('.status.json','.out')).read_text()
shipping=json.loads((r/'shipping-lines-candidate.json').read_text());assert shipping['source_commit']==q['source'] and shipping['core_non_test_code_lines']==38028
machine=json.loads((r/'machine-costs/summary.json').read_text());assert machine['shipping_lines']=={'candidate':38028,'baseline':38016}
assert machine['variants']['candidate']['artifact']['bytes']-machine['variants']['baseline']['artifact']['bytes']==864
shader=json.loads((r/'generated-shaders/receipt.json').read_text());spv=set()
for a in shader['generated_files']:
 p=r/'generated-shaders'/Path(a['saved']).name;assert sha(p)==a['sha256']
 if p.suffix=='.spv':spv.add(a['sha256'])
assert len(spv)==5 and len(shader['binaries'])==3
for b in shader['binaries']:
 data=Path(b['artifact']['preserved']).read_bytes();assert hashlib.sha256(data).hexdigest()==b['artifact']['sha256']
 for a in b['embedded']:assert hashlib.sha256(data[a['offset']:a['offset']+a['bytes']]).hexdigest()==a['sha256']
 assert any(a['sha256']=='ea6e71d3da2bdb23d4971a14f0f55db389dbb45f9b2e9c05c85d4dc6363eb4d1' for a in b['embedded'])
 if b['gate']=='offline-initial':assert spv<={a['sha256'] for a in b['embedded']}
for v in shader['validator']['results']:assert v['exit']==0
# All removed target executable copies remain exact in canonical raw/gzip stores.
archived=set()
for p in r.glob('archive-*/completed.json'):
 for a in json.loads(p.read_text()):
  if a['sha256'] in archived:continue
  path=Path(a['archive'])
  if a['archive_kind']=='raw':assert sha(path)==a['sha256']
  else:
   with gzip.open(path,'rb') as f:assert hashlib.file_digest(f,'sha256').hexdigest()==a['sha256']
  archived.add(a['sha256'])
for p in r.glob('candidate-cache-reclamation*-completed.json'):
 for a in json.loads(p.read_text()):assert sha(Path(a['preserved']))==a['sha256']
shared=json.loads((r/'shared-source-archive-receipt.json').read_text());path=Path(shared['shared_archive']);assert sha(path)==shared['shared_sha256'];contents={}
with tarfile.open(path,'r:gz') as t:
 for m in t:
  if m.isfile():contents[m.name]=hashlib.file_digest(t.extractfile(m),'sha256').hexdigest()
for name in ['native-phase','native-workspace']:
 d=r/('inherited-'+name);receipt=json.loads((d/'receipt.json').read_text());before=json.loads((d/'files-before.json').read_text());assert all(contents.get(p)==before[p] for p in receipt['removed_checkout_copies'])
p=json.loads((r/'patch-workspace-inherited-plan.json').read_text());assert all(contents.get(p)==h for p,h in p['removed'].items())
print('verified',len(manifest),'files;',len(seen),'qualified executable identities;',len(archived),'archived cache identities; all five test configurations,15 actual native scripts, exact pixel omission witness, shaders and source archive; no timing verdict')
