from pathlib import Path
import subprocess,shutil,json,hashlib
r=Path(__file__).resolve().parent;w=Path('/home/user/gpui-image-placement-lab');d=w/'reactivity/evidence/image-placement';raw=d/'raw';assert not raw.exists()
assert not subprocess.check_output(['git','status','--porcelain'],cwd=w).strip()
for gate in ['corrected-default','corrected-native','native-checks']:
 assert json.loads((r/gate/'guard-after.json').read_text())==[]
raw.mkdir()
for p in r.iterdir():
 if p.name=='__pycache__':continue
 if p.is_dir():shutil.copytree(p,raw/p.name)
 else:shutil.copy2(p,raw/p.name)
for name,a,b in [('production','5c4a6c47d07dbf0e36f24e79b5ef19fc0059698b','2c4e7e65b174b98c1efc41aff1920c0f352b4bf7'),('oracle','4afe067fe3e243fac40369301321f44962aa808d','5c4a6c47d07dbf0e36f24e79b5ef19fc0059698b')]:
 (raw/(name+'.patch')).write_bytes(subprocess.check_output(['git','diff',a,b,'--','reactivity/crates'],cwd=w))
shutil.copy2(r/'verify_dossier.py',d/'verify.py');shutil.copy2(r/'dossier-draft.txt',d/'README.md')
manifest={str(p.relative_to(d)):hashlib.sha256(p.read_bytes()).hexdigest() for p in d.rglob('*') if p.is_file() and p.name!='manifest.json'};(d/'manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
