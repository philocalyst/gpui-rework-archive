from pathlib import Path
import json,hashlib,subprocess,shutil
r=Path(__file__).parent
# Completed native source/evidence commits were independently verified before
# these regenerable library caches are reclaimed. Preserve exact ELF files here.
for target_name,wt_name,seal in [('gpui-native-workspace-target','gpui-native-workspace-lab','344c7f8ddd55326dca2c88322f67530914c97733')]:
 target=Path('/home/user')/target_name;w=Path('/home/user')/wt_name
 assert subprocess.check_output(['git','rev-parse','HEAD'],cwd=w,text=True).strip()==seal
 assert not subprocess.check_output(['git','status','--porcelain'],cwd=w).strip()
 for d in Path('/proc').iterdir():
  if not d.name.isdigit():continue
  try:e=(d/'exe').resolve();cmd=(d/'cmdline').read_bytes().replace(b'\0',b' ').decode(errors='replace')
  except (OSError,RuntimeError):continue
  assert not (str(e).startswith(str(target)) or (str(target) in cmd and any(x in cmd for x in ['rustc --','cargo +','clippy-driver --'])))
 files=[p for p in target.rglob('*') if p.is_file() and not p.is_symlink() and p.suffix in ['.rlib','.rmeta']]
 rows=[dict(path=str(p),bytes=p.stat().st_size,sha256=hashlib.file_digest(p.open('rb'),'sha256').hexdigest()) for p in files];out=r/(target_name+'-library-cleanup.json');assert not out.exists()
 (r/(target_name+'-library-cleanup-plan.json')).write_text(json.dumps(rows,indent=2));before=shutil.disk_usage('/home/user').free
 for p,row in zip(files,rows):
  assert hashlib.file_digest(p.open('rb'),'sha256').hexdigest()==row['sha256'];p.unlink()
 out.write_text(json.dumps(dict(seal=seal,files=len(rows),bytes=sum(x['bytes'] for x in rows),free_before=before,free_after=shutil.disk_usage('/home/user').free,scope='Completed regenerable library caches only; all source/evidence/executable/shader/fingerprint identities remain preserved.'),indent=2));print(target_name,len(rows),'libraries reclaimed')
