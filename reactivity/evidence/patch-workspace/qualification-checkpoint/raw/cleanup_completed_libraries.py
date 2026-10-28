from pathlib import Path
import subprocess,hashlib,shutil,json,os
r=Path(__file__).parent
for name in ['list-overscan','image-placement','line-height']:
 target=Path('/home/user/gpui-'+name+'-target');wt=Path('/home/user/gpui-'+name+'-lab')
 assert not subprocess.check_output(['git','status','--porcelain'],cwd=wt).strip()
 source=subprocess.check_output(['git','rev-parse','HEAD'],cwd=wt,text=True).strip()
 assert (wt/'reactivity/evidence').is_dir()
 for d in Path('/proc').iterdir():
  if not d.name.isdigit():continue
  try:e=(d/'exe').resolve();cmd=(d/'cmdline').read_bytes().replace(b'\0',b' ').decode(errors='replace')
  except (OSError,RuntimeError):continue
  assert not (str(e).startswith(str(target)) or (str(target) in cmd and any(x in cmd for x in ['rustc --','cargo +','clippy-driver --'])))
 files=[p for p in target.rglob('*') if p.is_file() and not p.is_symlink() and p.suffix in ['.rlib','.rmeta']]
 rows=[dict(path=str(p),bytes=p.stat().st_size,sha256=hashlib.file_digest(p.open('rb'),'sha256').hexdigest()) for p in files]
 output=r/(target.name+'-library-cleanup.json');assert not output.exists()
 (r/(target.name+'-library-cleanup-plan.json')).write_text(json.dumps(rows,indent=2))
 free=shutil.disk_usage('/home/user').free
 for p in files:p.unlink()
 output.write_text(json.dumps(dict(source=source,worktree=str(wt),files=len(rows),bytes=sum(x['bytes'] for x in rows),free_before=free,free_after=shutil.disk_usage('/home/user').free,scope='Completed inactive regenerable library caches only; all sources, evidence, ELF files, generated shaders and canonical raw/archive stores retained.'),indent=2))
 print(name,len(rows),sum(x['bytes'] for x in rows),flush=True)
