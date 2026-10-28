from pathlib import Path
import json,subprocess,hashlib,shutil
r=Path(__file__).parent;w=Path('/home/user/gpui-damage-suffix-lab');target=Path('/home/user/gpui-damage-suffix-target');seal='380db598cdbed2dd81c5a41745473c40a876f148'
assert subprocess.check_output(['git','rev-parse','HEAD'],cwd=w,text=True).strip()==seal
assert not subprocess.check_output(['git','status','--porcelain'],cwd=w).strip()
assert not any(n in subprocess.check_output(['ps','-eo','comm='],text=True).splitlines() for n in ['cargo','rustc','clippy-driver'])
d=w/'reactivity/evidence/damage-suffix-qualification'
for p,h in json.loads((d/'manifest.json').read_text()).items():assert hashlib.file_digest((d/p).open('rb'),'sha256').hexdigest()==h
files=[p for p in target.rglob('*') if p.is_file() and not p.is_symlink() and p.suffix in ['.rlib','.rmeta']]
rows=[dict(path=str(p),bytes=p.stat().st_size,sha256=hashlib.file_digest(p.open('rb'),'sha256').hexdigest()) for p in files];(r/'qualified-library-cleanup-plan.json').write_text(json.dumps(rows,indent=2));before=shutil.disk_usage('/home/user').free
for p,row in zip(files,rows):
 assert hashlib.file_digest(p.open('rb'),'sha256').hexdigest()==row['sha256'];p.unlink()
(r/'qualified-library-cleanup.json').write_text(json.dumps(dict(seal=seal,files=len(rows),bytes=sum(x['bytes'] for x in rows),free_before=before,free_after=shutil.disk_usage('/home/user').free,scope='Only inactive regenerable library caches after independent qualification verification and seal. Source, evidence, every executable and generated shader/fingerprint remain preserved.'),indent=2));print('reclaimed',len(rows),'libraries; free',shutil.disk_usage('/home/user').free)
