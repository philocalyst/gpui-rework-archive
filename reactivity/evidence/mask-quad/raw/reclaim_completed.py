from pathlib import Path
import json,subprocess,hashlib,shutil
r=Path(__file__).parent

def sha(p):return hashlib.file_digest(p.open('rb'),'sha256').hexdigest()
checks=[]
for path in ['/home/user/gpui-mask-lattice-lab/reactivity/evidence/mask-lattice/verify.py','/home/user/gpui-mask-lattice-native-lab/reactivity/evidence/mask-lattice-native/verify_dossier.py']:
 p=subprocess.run(['python3',path],capture_output=True,text=True);checks.append(dict(verifier=path,exit=p.returncode,stdout=p.stdout,stderr=p.stderr));assert p.returncode==0,p.stderr
rows=[]
for target in [Path('/home/user/gpui-mask-lattice-target'),Path('/home/user/gpui-mask-lattice-native-target'),Path('/home/user/gpui-mask-lattice-oracle-target')]:
 for p in target.rglob('*'):
  if not p.is_file() or p.is_symlink():continue
  if p.suffix=='.so':rows.append(dict(path=str(p),bytes=p.stat().st_size,sha256=sha(p),kind='regenerable-procedural-macro-library'));continue
  with p.open('rb') as f:magic=f.read(4)
  if magic!=b'\x7fELF':continue
  h=sha(p);saved=Path('/home/user/gpui-preserved-test-binaries')/h
  if saved.exists() and sha(saved)==h:rows.append(dict(path=str(p),bytes=p.stat().st_size,sha256=h,kind='exact-canonical-executable-copy',preserved=str(saved)))
(r/'completed-cleanup-plan.json').write_text(json.dumps(dict(qualification=checks,files=rows),indent=2));before=shutil.disk_usage('/home/user').free
for row in rows:
 p=Path(row['path']);assert sha(p)==row['sha256'];p.unlink()
(r/'completed-cleanup-receipt.json').write_text(json.dumps(dict(files=len(rows),bytes=sum(x['bytes'] for x in rows),free_before=before,free_after=shutil.disk_usage('/home/user').free),indent=2));print('reclaimed',len(rows),'verified completed cache files; free',shutil.disk_usage('/home/user').free,flush=True)
