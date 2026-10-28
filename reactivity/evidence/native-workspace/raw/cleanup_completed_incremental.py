from pathlib import Path
import json,hashlib,shutil
r=Path(__file__).parent
for name in ['gpui-target-retained','gpui-target-baseline','gpui-target-gpu-baseline','gpui-target-negative']:
 target=Path('/home/user')/name
 for d in Path('/proc').iterdir():
  if not d.name.isdigit():continue
  try:e=(d/'exe').resolve();cmd=(d/'cmdline').read_bytes().replace(b'\0',b' ').decode(errors='replace')
  except (OSError,RuntimeError):continue
  assert not (str(e).startswith(str(target)) or (str(target) in cmd and any(x in cmd for x in ['rustc --','cargo +','clippy-driver --'])))
 roots=[p for p in [target/'debug/incremental',target/'release/incremental'] if p.is_dir()];files=[p for root in roots for p in root.rglob('*') if p.is_file()]
 assert all(not p.is_symlink() for p in files)
 rows=[dict(path=str(p),bytes=p.stat().st_size,sha256=hashlib.file_digest(p.open('rb'),'sha256').hexdigest()) for p in files]
 (r/(name+'-incremental-cleanup-plan.json')).write_text(json.dumps(rows,indent=2));before=shutil.disk_usage('/home/user').free
 for root in roots:shutil.rmtree(root)
 (r/(name+'-incremental-cleanup.json')).write_text(json.dumps(dict(files=len(files),bytes=sum(x['bytes'] for x in rows),free_before=before,free_after=shutil.disk_usage('/home/user').free,scope='Only completed inactive Cargo incremental compilation caches. Sources, evidence, generated shaders/fingerprints and exact preserved/archived executable stores retained. Prior executable-cache preservation is sealed in scene-support 7494c10970d3 and patch-workspace f7b3f60c70fa.'),indent=2))
 print(name,len(files),sum(x['bytes'] for x in rows),flush=True)
