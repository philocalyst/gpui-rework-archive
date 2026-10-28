from pathlib import Path
import subprocess,hashlib,shutil,json
r=Path(__file__).parent;target=Path('/home/user/gpui-patch-workspace-target');wt=Path('/home/user/gpui-patch-workspace-lab')
checkpoint=json.loads((r/'cache-qualification-checkpoint.json').read_text())
assert checkpoint['source']=='41a67473a0177fbb17df1f7b8e2f2f36dd6940f6'
assert not subprocess.check_output(['git','status','--porcelain'],cwd=wt).strip()
assert subprocess.check_output(['git','rev-parse','HEAD'],cwd=wt,text=True).strip()==checkpoint['source']
for d in Path('/proc').iterdir():
 if not d.name.isdigit():continue
 try:e=(d/'exe').resolve();cmd=(d/'cmdline').read_bytes().replace(b'\0',b' ').decode(errors='replace')
 except (OSError,RuntimeError):continue
 assert not (str(e).startswith(str(target)) or (str(target) in cmd and any(x in cmd for x in ['rustc --','cargo +','clippy-driver --'])))
files=[p for p in target.rglob('*') if p.is_file() and not p.is_symlink() and p.suffix in ['.rlib','.rmeta']]
rows=[dict(path=str(p),bytes=p.stat().st_size,sha256=hashlib.file_digest(p.open('rb'),'sha256').hexdigest()) for p in files]
output=r/'candidate-library-cleanup.json';assert not output.exists()
(r/'candidate-library-cleanup-plan.json').write_text(json.dumps(rows,indent=2))
free=shutil.disk_usage('/home/user').free
for p in files:p.unlink()
output.write_text(json.dumps(dict(checkpoint=checkpoint,files=len(rows),bytes=sum(x['bytes'] for x in rows),free_before=free,free_after=shutil.disk_usage('/home/user').free,scope='Completed inactive regenerable library caches only, after qualification evidence commit. All source, evidence, exact ELF files, fingerprints, generated shaders and canonical raw/archive stores retained. The initial ELF-cache archive stopped at its reserve check after preserving/removing one cache copy; no build/test/timing was active.'),indent=2))
print(len(rows),sum(x['bytes'] for x in rows),shutil.disk_usage('/home/user').free)
