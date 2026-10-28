from pathlib import Path
import subprocess,json,hashlib,shutil
r=Path(__file__).parent;w=Path('/home/user/gpui-mask-lattice-checkpoint-lab');d=w/'reactivity/evidence/mask-lattice-checkpoint';raw=d/'raw'
assert not subprocess.check_output(['git','status','--porcelain'],cwd=w).strip()
sha=lambda p:hashlib.file_digest(p.open('rb'),'sha256').hexdigest()
for p,h in json.loads((d/'manifest.json').read_text()).items():assert sha(d/p)==h
for name in ['gpu-near-ties','negative-width-near-ties','full-native-initial']:
 gate=r/name;assert json.loads((gate/'guard-after.json').read_text())==[]
 shutil.copytree(gate,raw/name)
 for prefix in [name+'.out',name+'.log']:
  if (r/prefix).exists():shutil.copyfile(r/prefix,raw/prefix)
for p in r.iterdir():
 if p.is_file() and p.suffix in ['.py','.json']:
  dest=raw/p.name
  if dest.exists():assert dest.read_bytes()==p.read_bytes(),p
  else:shutil.copyfile(p,dest)
comparison=json.loads((r/'exact-gpu-near-ties-comparison.json').read_text());assert comparison['all_equal'] and comparison['frames']==336
for gate,stages in [('gpu-near-ties',['test','clippy']),('full-native-initial',['build','test','port','clippy'])]:
 for stage in stages:assert json.loads((r/gate/(stage+'.status.json')).read_text())['exit']==0
assert json.loads((r/'negative-width-near-ties/test.status.json').read_text())['exit']==101
(d/'README.md').write_text((d/'README.md').read_text()+'''

## Revised certificate checkpoint

Source9e4ef386 now passes353 GPU/canvas tests, strict Clippy and all336 exact
independent GPU readbacks. Revised width mutant4c53d8d9 fails texel authority
exactly. Full-native build,1108 tests,17 port tests and strict Clippy pass.
Actual native/minimal/default/offline gates are pending and not claimed here.
Shipping lines38089 (+61), default-release native ELF26391352 (+1232).
This extension preserves the successful revised observations alongside every
previous failure. It permits only completed verified cache-copy/library cleanup.
''')
manifest={str(p.relative_to(d)):sha(p) for p in d.rglob('*') if p.is_file() and p!=d/'manifest.json'};(d/'manifest.json').write_text(json.dumps(manifest,indent=2))
for p,h in manifest.items():assert sha(d/p)==h
for gate in ['gpu-near-ties','negative-width-near-ties','full-native-initial']:
 for artifactfile in (raw/gate).glob('*artifacts.json'):
  for a in json.loads(artifactfile.read_text()):assert sha(Path(a['preserved']))==a['sha256']
subprocess.run(['git','add','--sparse',str(d.relative_to(w))],cwd=w,check=True);subprocess.run(['git','commit','-qm','Checkpoint exact revised mask readbacks, width witness and full native qualification'],cwd=w,check=True)
print(subprocess.check_output(['git','rev-parse','HEAD'],cwd=w,text=True).strip(),len(manifest),'files verified')
