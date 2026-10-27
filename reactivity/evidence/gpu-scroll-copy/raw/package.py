from pathlib import Path
import subprocess,shutil,json,hashlib
r=Path(__file__).resolve().parent;w=Path('/home/user/gpui-gpu-scroll-copy-lab');d=w/'reactivity/evidence/gpu-scroll-copy';raw=d/'raw';assert not raw.exists();raw.mkdir()
assert not subprocess.check_output(['git','status','--porcelain'],cwd=w).strip()
for p in r.iterdir():
 if p.name=='__pycache__':continue
 if p.is_dir():shutil.copytree(p,raw/p.name)
 else:shutil.copy2(p,raw/p.name)
for name,a,b in [('change','4afe067fe3e243fac40369301321f44962aa808d','8eebb25bd8'),('test-only-final','49514e3cb6','8eebb25bd8'),('content-negative','2123124d66','eb0efec660'),('token-negative','2123124d66','674960d414'),('control-overlay','4afe067fe3e243fac40369301321f44962aa808d','6269bdfafc')]:
 (raw/(name+'.patch')).write_bytes(subprocess.check_output(['git','diff',a,b,'--','reactivity/crates'],cwd=w))
shutil.copy2(r/'verify_dossier.py',d/'verify.py');shutil.copy2(r/'dossier-draft.txt',d/'README.md')
manifest={str(p.relative_to(d)):hashlib.sha256(p.read_bytes()).hexdigest() for p in d.rglob('*') if p.is_file() and p.name!='manifest.json'};(d/'manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
