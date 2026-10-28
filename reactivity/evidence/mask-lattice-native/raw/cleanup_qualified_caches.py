from pathlib import Path
import json,subprocess,hashlib,shutil
r=Path(__file__).parent;w=Path('/home/user/gpui-mask-lattice-lab');t=Path('/home/user/gpui-mask-lattice-target');q=w/'reactivity/evidence/mask-lattice';seal='677b1fb7a51a7bab12dbad0bf4e8815fcd254b74'
def sha(p):return hashlib.file_digest(Path(p).open('rb'),'sha256').hexdigest()
assert subprocess.check_output(['git','rev-parse','HEAD'],cwd=w,text=True).strip()==seal
assert not subprocess.check_output(['git','status','--porcelain'],cwd=w).strip()
manifest=json.loads((q/'manifest.json').read_text())
for p,h in manifest.items():assert sha(q/p)==h
assert not any(n.strip() in ['cargo','rustc','clippy-driver'] for n in subprocess.check_output(['ps','-eo','comm='],text=True).splitlines())
selected={}
for p in (q/'raw').glob('*/test-artifacts.json'):
 for a in json.loads(p.read_text()):
  cache=Path(a['path'])
  if t in cache.parents and a['cargo']['profile']['test'] and cache.is_file() and sha(cache)==a['sha256']:
   assert sha(a['preserved'])==a['sha256'];selected[str(cache)]=a
libs=[p for p in t.rglob('*') if p.is_file() and not p.is_symlink() and p.suffix in ['.rlib','.rmeta']]
rows=[dict(path=str(p),bytes=p.stat().st_size,sha256=sha(p)) for p in libs]
(r/'qualified-cache-cleanup-plan.json').write_text(json.dumps(dict(seal=seal,libraries=rows,executable_cache_copies=list(selected.values())),indent=2));before=shutil.disk_usage('/home/user').free
for p,a in selected.items():assert sha(p)==sha(a['preserved'])==a['sha256'];Path(p).unlink()
for p,a in zip(libs,rows):assert sha(p)==a['sha256'];p.unlink()
(r/'qualified-cache-cleanup.json').write_text(json.dumps(dict(seal=seal,libraries=len(rows),cached_executables=len(selected),free_before=before,free_after=shutil.disk_usage('/home/user').free,scope='Only regenerable inactive libraries and completed executable cache copies after verified full qualification seal. Every canonical executed ELF, generated shader/fingerprint, source and evidence retained.'),indent=2))
(r/'qualification-reference.json').write_text(json.dumps(dict(source='9e4ef386f193a17d74bda63867b0ca4c86e0e59e',seal=seal,worktree=str(w),dossier=str(q),manifest_sha256=sha(q/'manifest.json'),verifier_sha256=sha(q/'verify.py'),verification=json.loads(Path('/home/user/gpui-mask-lattice-evidence/qualification-verification.out').read_text())),indent=2))
print('Removed',len(rows),'libraries and',len(selected),'cached ELF copies; free',shutil.disk_usage('/home/user').free)
