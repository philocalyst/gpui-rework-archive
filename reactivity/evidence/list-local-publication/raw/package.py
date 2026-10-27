from pathlib import Path
import subprocess,shutil,json,hashlib
r=Path(__file__).resolve().parent;w=Path('/home/user/gpui-local-publication-lab');d=w/'reactivity/evidence/list-local-publication';raw=d/'raw';assert not raw.exists()
assert not subprocess.check_output(['git','status','--porcelain'],cwd=w).strip()
raw.mkdir()
for p in r.iterdir():
 if p.name=='__pycache__':continue
 if p.is_dir():shutil.copytree(p,raw/p.name)
 else:shutil.copy2(p,raw/p.name)
shutil.copytree('/home/user/gpui-local-publication-negative-evidence',raw/'negative')
shutil.copytree('/home/user/gpui-local-publication-control-evidence',raw/'control')
for name,a,b in [('production','6895a10440','957719565444c9900c6e6c20916a6fb88c933395'),('wrong-row-negative','957719565444c9900c6e6c20916a6fb88c933395','1a720ef1ef'),('name-negative','957719565444c9900c6e6c20916a6fb88c933395','2a24197706')]:
 (raw/(name+'.patch')).write_bytes(subprocess.check_output(['git','diff',a,b,'--','reactivity/crates'],cwd=w))
shutil.copy2(r/'verify_dossier.py',d/'verify.py');shutil.copy2(r/'dossier-draft.txt',d/'README.md')
manifest={str(p.relative_to(d)):hashlib.sha256(p.read_bytes()).hexdigest() for p in d.rglob('*') if p.is_file() and p.name!='manifest.json'};(d/'manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
