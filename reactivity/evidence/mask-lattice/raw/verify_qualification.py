from pathlib import Path
import json,hashlib,re,tarfile
root=Path(__file__).resolve().parent;r=root/'raw'
def sha(p):return hashlib.file_digest(Path(p).open('rb'),'sha256').hexdigest()
def read(p):return json.loads((r/p).read_text())
manifest=json.loads((root/'manifest.json').read_text())
assert set(manifest)=={str(p.relative_to(root)) for p in root.rglob('*') if p.is_file() and p!=root/'manifest.json'}
for p,h in manifest.items():assert sha(root/p)==h,p
source='9e4ef386f193a17d74bda63867b0ca4c86e0e59e'
def counts(p):
 rows=re.findall(r'test result: (?:ok|FAILED)\. (\d+) passed; (\d+) failed; (\d+) ignored',p.read_text())
 return [sum(int(x[i]) for x in rows) for i in range(3)]
for gate,filename,total,stages in [
 ('gpu-near-ties','test.out',[353,0,3],['test','clippy']),
 ('full-native-initial','test.out',[1108,0,45],['build','test','port','clippy']),
 ('minimal-library-initial','unit-build.out',[329,0,25],['unit-build','port','clippy']),
 ('default-initial','test.out',[1015,0,13],['test','clippy']),
 ('offline-initial','test.out',[83,0,0],['test','clippy'])]:
 d=r/gate;assert (d/'source.txt').read_text().strip()==source
 assert counts(d/filename)==total and read(gate+'/guard-after.json')==[]
 for stage in stages:
  status=read(gate+'/'+stage+'.status.json');assert status['exit']==0 and not status['storage_stop'] and status['minimum_free_bytes']>=8*1024**3
  assert all(x in status['command'] for x in ['+nightly-2026-10-23','checksum-freshness','--locked','--offline','--release'])
 if 'port' in stages:assert counts(d/'port.out')==[17,0,0]
for gate,n in [('native-checks-initial',11),('minimal-native-checks-initial',4)]:
 d=r/gate;files=list(d.glob('*.status.json'));assert len(files)==n and read(gate+'/guard-after.json')==[]
 for p in files:
  status=json.loads(p.read_text());assert status['exit']==0
  assert '1 passed; 0 failed' in p.with_name(p.name.replace('.status.json','.out')).read_text()
assert counts(r/'oracle-gpu-initial/test.out')==[350,0,3]
for stage in ['test','clippy']:assert read('oracle-gpu-initial/'+stage+'.status.json')['exit']==0
for gate in ['negative-width','negative-width-near-ties']:
 assert read(gate+'/test.status.json')['exit']==101 and counts(r/gate/'test.out')==[0,1,0]
 assert read(gate+'/guard-after.json')==[]
 log=(r/gate/'test.log').read_text();assert 'mask cell axis=0 phase=-256 scale=0.5 translation=0 point=0.125' in log and 'left: Some(1)' in log and 'right: Some(2)' in log
assert 'StopIteration' in (r/'negative-width.log').read_text()
assert 'InvalidScene' in (r/'gpu-initial/test.out').read_text() and read('gpu-initial/test.status.json')['exit']==101
assert counts(r/'gpu-fixture-corrected/test.out')==[353,0,3] and read('gpu-fixture-corrected/clippy.status.json')['exit']==101
assert read('gpu-format-corrected/clippy.status.json')['exit']==0
frames={}
for gate in ['oracle-gpu-initial','gpu-format-corrected','gpu-near-ties','offline-initial']:
 frames[gate]={p.name:sha(p) for p in (r/gate/'pixels').glob('*.rgba')};assert len(frames[gate])==336
assert frames['oracle-gpu-initial']==frames['gpu-near-ties']==frames['offline-initial']
failed={p for p,h in frames['oracle-gpu-initial'].items() if frames['gpu-format-corrected'][p]!=h};assert len(failed)==12
assert failed==set(read('exact-gpu-comparison.json')['different'])
for key in failed:
 assert key.split('-')[2:4]==['2','0']
for gate in ['oracle-gpu-initial','gpu-near-ties','offline-initial']:
 assert 'test mask_lattice::public_mask_lattice_readbacks_replay_clips_and_density_fallbacks ... ok' in (r/gate/'test.out').read_text()
headers={}
for p in (r/'headers').glob('candidate-*'):
 if p.suffix in ['.out','.log']:headers.update({k:int(v) for k,v in re.findall(r'([A-Za-z_]+)=(\d+)',p.read_text())})
for k,v in dict(RuntimeUnit=1824,Prepared=40,TextPatch=96,TextResources=168,SceneDamage=40).items():assert headers[k]==v
inventory=read('shipping-lines-candidate.json');assert inventory['source_commit']==source and inventory['core_non_test_code_lines']==38089==sum(x['code_lines'] for x in inventory['files'].values())
assert read('shipping-lines-baseline.json')['core_non_test_code_lines']==38028
machine=read('machine-costs/summary.json');assert machine['variants']['baseline']['artifact']['bytes']==26390120 and machine['variants']['candidate']['artifact']['bytes']==26391352
helper=[f for f in machine['variants']['candidate']['functions'] if f['symbol']=='gpui_gpu::renderer::mask_lattice::lowered_mask_rect'];assert len(helper)==1 and helper[0]['bytes']==1086 and helper[0]['local_sub_rsp_prologue']==[96]
shaders=read('generated-shaders/receipt.json');assert len(shaders['binaries'])==4 and len(shaders['generated_files'])==28
for item in shaders['generated_files']:assert sha(r/'generated-shaders'/Path(item['saved']).name)==item['sha256']
assert len(shaders['validator']['results'])==5
for v in shaders['validator']['results']:assert v['exit']==0
seen=set()
def artifact(a):
 if a['sha256'] not in seen:assert sha(a['preserved'])==a['sha256'];seen.add(a['sha256'])
for b in shaders['binaries']:
 artifact(b['artifact']);data=Path(b['artifact']['preserved']).read_bytes()
 for item in b['embedded']:assert hashlib.sha256(data[item['offset']:item['offset']+item['bytes']]).hexdigest()==item['sha256']
for p in r.rglob('*artifacts.json'):
 value=json.loads(p.read_text())
 for a in value if isinstance(value,list) else value.values():
  if isinstance(a,dict) and 'preserved' in a:artifact(a)
for gate in ['full-native-initial','gpu-near-ties','offline-initial']:
 stage='build' if gate=='full-native-initial' else 'test'
 built=[]
 for line in (r/gate/(stage+'.out')).read_text().splitlines():
  try:a=json.loads(line)
  except ValueError:continue
  if a.get('reason')=='compiler-artifact' and a['manifest_path'].endswith('/crates/gpu/Cargo.toml') and a['target']['kind']==['lib']:built.append(a)
 assert any(a['fresh'] is False for a in built),gate
# Verify all omitted inherited checkout bytes remain in the shared immutable archive.
plans=[read(name) for name in ['inherited-cleanup-plan.json','inherited-cleanup-more-plan.json','inherited-cleanup-more2-plan.json']]
assert len({p['shared_archive'] for p in plans})==1 and len({p['shared_sha256'] for p in plans})==1
archive=Path(plans[0]['shared_archive']);assert sha(archive)==plans[0]['shared_sha256'];saved={}
with tarfile.open(archive,'r:gz') as t:
 for m in t:
  if m.isfile():saved[m.name]=hashlib.file_digest(t.extractfile(m),'sha256').hexdigest()
for plan in plans:
 for record in plan['plans']:
  assert all(saved.get(p)==h for p,h in record['removed'].items())
for a in read('completed-cache-reclamation-plan.json')['executable_cache_copies']:artifact(a)
for gate in ['full-native-initial','minimal-library-initial','default-initial']:
 assert read(gate+'/guard-after.json')==[]
print(json.dumps(dict(files=len(manifest),qualified_elf_identities=len(seen),configurations=5,actual_native_processes=15,exact_frames_per_variant=336,independent_pixel_variants=3,preserved_prior_pixel_failures=12,shipping_lines=38089,native_elf_bytes=26391352,qualification_passes=True,timing_observations=0),indent=2))
