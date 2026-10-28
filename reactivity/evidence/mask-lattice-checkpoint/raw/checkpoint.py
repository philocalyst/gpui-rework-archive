from pathlib import Path
import subprocess,json,shutil,hashlib,re
r=Path(__file__).parent;w=Path('/home/user/gpui-mask-lattice-checkpoint-lab');base='9e4ef386f193a17d74bda63867b0ca4c86e0e59e'
assert not w.exists()
subprocess.run(['git','worktree','add','--no-checkout','-b','local/mask-lattice-qualification',str(w),base],cwd='/home/user/gpui-mask-lattice-lab',check=True,stdout=subprocess.DEVNULL)
subprocess.run(['git','sparse-checkout','set','reactivity/evidence/mask-lattice','.cargo'],cwd=w,check=True)
subprocess.run(['git','read-tree','--reset','-u','HEAD'],cwd=w,check=True)
assert not subprocess.check_output(['git','status','--porcelain'],cwd=w).strip()
d=w/'reactivity/evidence/mask-lattice-checkpoint';raw=d/'raw';raw.mkdir(parents=True)
exclude={'__pycache__','gpu-near-ties','gpu-near-ties.out','gpu-near-ties.log','checkpoint.out','checkpoint.log'}
for p in r.iterdir():
 if p.name in exclude:continue
 if p.is_dir():shutil.copytree(p,raw/p.name)
 else:shutil.copyfile(p,raw/p.name)
(d/'README.md').write_text('''# Mask lattice pre-narrowing checkpoint — exact GPU gate fails

All files here precede the revised near-tie qualification. They preserve the
original uninitialized-index setup commit and exact-base recovery, the cleanup
root-file afterguard failure and restoration, initial missing opaque clear,
strict-Clippy numeric grouping failure/correction, all exact artifacts and
source guards, independent pre-change GPU oracle,336 raw frames per complete
capture and the12-frame exact GPU failure. No timing observation has begun.

Original mask implementation837a23d4 passes353 tests and strict Clippy but fails
12/336 independent exact GPU frames. The width omission mutant60ec5377 fails
actual sample authority (texel1 instead of2); its witness writer then failed
on a retained old panic substring. The parser-only correction reuses the same
raw execution without rerunning. All these failures remain visible.

A narrowed certificate is source9e4ef386; its new qualification is not included
or claimed here. Oracle6faae98a is complete350/0/3 tests plus strict Clippy.
This checkpoint permits reclamation of only inactive oracle/mutant library
caches after verifying the manifest and exact preserved executables. No
production source, test executable, shader, fingerprint or evidence is removed.
All changes local; overall ZGX/hardware/quality goals remain open.
''')
sha=lambda p:hashlib.file_digest(p.open('rb'),'sha256').hexdigest()
manifest={str(p.relative_to(d)):sha(p) for p in d.rglob('*') if p.is_file()};(d/'manifest.json').write_text(json.dumps(manifest,indent=2))
for p,h in manifest.items():assert sha(d/p)==h
for name in ['gpu-initial','gpu-fixture-corrected','gpu-format-corrected','oracle-gpu-initial','negative-width']:
 gate=raw/name;assert json.loads((gate/'guard-after.json').read_text())==[]
 for a in json.loads((gate/'test-artifacts.json').read_text()):assert sha(Path(a['preserved']))==a['sha256']
left={p.name:sha(p) for p in (raw/'oracle-gpu-initial/pixels').glob('*.rgba')};right={p.name:sha(p) for p in (raw/'gpu-format-corrected/pixels').glob('*.rgba')}
assert len(left)==len(right)==336 and sum(left[p]!=right[p] for p in left)==12
subprocess.run(['git','add','--sparse',str(d.relative_to(w))],cwd=w,check=True)
subprocess.run(['git','commit','-qm','Preserve mask lattice setup, qualification, exact GPU rejection and width fault evidence'],cwd=w,check=True)
print('verified',len(manifest),'files; checkpoint',subprocess.check_output(['git','rev-parse','HEAD'],cwd=w,text=True).strip())
