from pathlib import Path
import json,hashlib,subprocess,shutil
r=Path(__file__).resolve().parent;w=Path('/home/user/gpui-list-source-lab');d=w/'reactivity/evidence/list-source';raw=d/'raw';assert not raw.exists();raw.mkdir()
for p in r.iterdir():
 if p.name=='__pycache__':continue
 if p.is_dir():shutil.copytree(p,raw/p.name)
 else:shutil.copy2(p,raw/p.name)
(raw/'change.patch').write_bytes(subprocess.check_output(['git','diff','41acc60740f4fef358ee4b8a8a1f0fa6caacc307','HEAD','--','reactivity/crates'],cwd=w))
negative=(r/'negative/source.txt').read_text().strip()
(raw/'negative.patch').write_bytes(subprocess.check_output(['git','diff','a971ac3ccf',negative,'--','reactivity/crates'],cwd=w))
(raw/'test-only-final.patch').write_bytes(subprocess.check_output(['git','diff','93f63b4a03','HEAD','--','reactivity/crates'],cwd=w))
shutil.copy2(r/'verify_dossier.py',d/'verify.py');shutil.copy2(r/'dossier-draft.txt',d/'README.md')
manifest={str(p.relative_to(d)):hashlib.sha256(p.read_bytes()).hexdigest() for p in d.rglob('*') if p.is_file() and p.name!='manifest.json'};(d/'manifest.json').write_text(json.dumps(manifest,indent=2))
