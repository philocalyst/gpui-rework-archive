from pathlib import Path
import json,hashlib,subprocess,shutil
r=Path(__file__).parent;w=Path('/home/user/gpui-mask-lattice-checkpoint-lab');seal='0b01889e5db5f4dc47ac60418db8c70c205f8978';d=w/'reactivity/evidence/mask-lattice-checkpoint'
def sha(p):return hashlib.file_digest(Path(p).open('rb'),'sha256').hexdigest()
assert subprocess.check_output(['git','rev-parse','HEAD'],cwd=w,text=True).strip()==seal
assert not subprocess.check_output(['git','status','--porcelain'],cwd=w).strip()
for p,h in json.loads((d/'manifest.json').read_text()).items():assert sha(d/p)==h
assert not any(n.strip() in ['cargo','rustc','clippy-driver'] for n in subprocess.check_output(['ps','-eo','comm='],text=True).splitlines())
selected={}
for gate in ['gpu-initial','gpu-fixture-corrected','gpu-format-corrected','gpu-near-ties','full-native-initial']:
 for a in json.loads((r/gate/'test-artifacts.json').read_text()):
  p=Path(a['path'])
  if a['cargo']['profile']['test'] and p.is_file() and sha(p)==a['sha256']:
   assert sha(a['preserved'])==a['sha256'];selected[str(p)]=a
wt=Path('/home/user/gpui-mask-lattice-width-lab');assert subprocess.check_output(['git','rev-parse','HEAD'],cwd=wt,text=True).strip()=='4c53d8d984ed74bc9cf243b76c3308cc8d208f3f'
assert not subprocess.check_output(['git','status','--porcelain'],cwd=wt).strip()
libs=[p for p in Path('/home/user/gpui-mask-lattice-width-target').rglob('*') if p.is_file() and not p.is_symlink() and p.suffix in ['.rlib','.rmeta']]
rows=[dict(path=str(p),bytes=p.stat().st_size,sha256=sha(p)) for p in libs]
(r/'completed-cache-reclamation-plan.json').write_text(json.dumps(dict(checkpoint=seal,executable_cache_copies=list(selected.values()),mutant_libraries=rows),indent=2));before=shutil.disk_usage('/home/user').free
for p,a in selected.items():assert sha(p)==sha(a['preserved'])==a['sha256'];Path(p).unlink()
for p,a in zip(libs,rows):assert sha(p)==a['sha256'];p.unlink()
(r/'completed-cache-reclamation.json').write_text(json.dumps(dict(checkpoint=seal,cached_executables_removed=len(selected),mutant_libraries_removed=len(rows),free_before=before,free_after=shutil.disk_usage('/home/user').free,scope='Completed target cache copies only, after exact canonical execution-byte verification and committed checkpoint. Inactive mutant libraries regenerable. Every canonical ELF/source/evidence/generated shader/fingerprint retained.'),indent=2));print('cache executables',len(selected),'libraries',len(rows),'free',shutil.disk_usage('/home/user').free)
