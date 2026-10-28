from pathlib import Path
import json,hashlib,re,subprocess
root=Path(__file__).resolve().parent;r=root/'raw'
def read(p):return json.loads(p.read_text())
def sha(p):return hashlib.file_digest(p.open('rb'),'sha256').hexdigest()
manifest=read(root/'manifest.json');assert set(manifest)=={str(p.relative_to(root)) for p in root.rglob('*') if p.is_file() and p.name!='manifest.json'}
for p,h in manifest.items():assert sha(root/p)==h,p
sources={'gpu-initial':'4af395b9664b724720ece82d8ce624d18a3b1bcc','gpu-corrected':'7565d788dcdf62f87c43a2d4910764a3ff2be764','negative-y':'849ea94409ab1a6b7cb1571ed16e3e622f8670f7'};elfs=set()
for gate,source in sources.items():
 g=r/gate;assert (g/'source.txt').read_text().strip()==source and read(g/'guard-after.json')==[];assert read(g/'test.status.json')['exit']==0
 totals=re.findall(r'test result: ok\. (\d+) passed; (\d+) failed; (\d+) ignored',(g/'test.out').read_text());counts=[sum(int(x[i]) for x in totals) for i in range(3)];assert counts==([1,0,0] if gate=='negative-y' else [353,0,3]),(gate,counts)
 if gate!='negative-y':assert read(g/'clippy.status.json')['exit']==(101 if gate=='gpu-initial' else 0)
 for a in read(g/'test-artifacts.json'):
  assert sha(Path(a['preserved']))==a['sha256'];elfs.add(a['sha256'])
 c=read(g/'independent-pixels.json');assert c['frames']==336
 expected=0 if gate!='negative-y' else None;bad=[]
 for row in c['rows']:
  p=row['file'];b=(r/'oracle-pixels'/p).read_bytes();v=(g/'pixels'/p).read_bytes();diff=[i for i,(x,y) in enumerate(zip(b,v)) if x!=y];assert len(b)==len(v)==row['bytes'] and hashlib.sha256(b).hexdigest()==row['oracle_sha256']==row['parent_sha256'] and hashlib.sha256(v).hexdigest()==row['candidate_sha256'];assert row['equal']==(not diff) and row['differing_bytes']==len(diff) and row['first_difference']==(diff[0] if diff else None)
  if diff:assert (row['first_expected'],row['first_actual'])==(b[diff[0]],v[diff[0]]);bad.append(row)
 assert c['mismatches']==len(bad) and c['exact_frames']==336-len(bad)
 if expected is None:assert bad and all('-true-' in x['file'] for x in bad),'mutant must reach banked cache'
 else:assert not bad
assert 'value assigned to `source` is never read' in (r/'gpu-initial/clippy.out').read_text()
receipt=read(r/'generated-shaders/receipt.json');sh=receipt['embedded'];data=Path(receipt['executed_render']['preserved']).read_bytes();assert hashlib.sha256(data[sh['offset']:sh['offset']+sh['bytes']]).hexdigest()==sh['sha256'];assert sha(r/'generated-shaders'/(sh['sha256']+'-ui.wgsl'))==sh['sha256'];assert not receipt['executed_render']['cargo']['fresh']
for x in receipt['generated']:assert x['sha256']==sh['sha256'] and x['bytes']==sh['bytes']
for gate in sources:
 records=[]
 for line in (r/gate/'test.out').read_text().splitlines():
  try:x=json.loads(line)
  except ValueError:continue
  if x.get('reason')=='compiler-artifact' and '/crates/gpu/' in x.get('manifest_path','') and x['target']['kind']==['lib']:records.append(x)
 assert records and any(not x['fresh'] for x in records),gate
w=Path('/home/user/gpui-mask-quad-lab');c='7565d788dcdf62f87c43a2d4910764a3ff2be764';m='849ea94409ab1a6b7cb1571ed16e3e622f8670f7';file='reactivity/crates/gpu/src/shader.rs';good=subprocess.check_output(['git','show',c+':'+file],cwd=w).decode();bad=subprocess.check_output(['git','show',m+':'+file],cwd=w).decode();assert good.replace('let index = offset.y as u32 * 2 + offset.x as u32;','let index = offset.x as u32;')==bad
for p in ['reactivity/crates/gpu/src/renderer.rs','reactivity/crates/gpu/src/renderer/mask_lattice.rs','reactivity/crates/gpu/tests/support/mask_lattice.rs']:
 assert subprocess.check_output(['git','show',c+':'+p],cwd=w)==subprocess.check_output(['git','show','9e4ef386:'+p],cwd=w)
assert read(r/'shipping-lines-candidate.json')['core_non_test_code_lines']==38163
print(json.dumps(dict(files=len(manifest),executable_identities=len(elfs),gpu_canvas_tests=353,ignored_tests=3,exact_frames=336,negative_frames=read(r/'negative-y/independent-pixels.json')['mismatches'],admission_correctness_passes=True,scope='Early shader-screen admission only; full configurations/offline/native/performance remain pending.')))
