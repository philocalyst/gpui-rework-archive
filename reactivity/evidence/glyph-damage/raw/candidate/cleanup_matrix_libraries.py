from pathlib import Path
import json,hashlib,shutil,time
r=Path(__file__).parent;out=r/'matrix-completed-library-cleanup.json';assert not out.exists();assert not (r/'matrix-timing').exists()
roots=[Path('/home/user/gpui-glyph-damage-target'),Path('/home/user/gpui-glyph-damage-control-target')]
for p in Path('/proc').iterdir():
 if not p.name.isdigit():continue
 try:
  if (p/'comm').read_text().strip() not in ['cargo','rustc','clippy-driver']:continue
  command=(p/'cmdline').read_bytes().decode()
  assert not any(str(t) in command for t in roots),'selected target still active'
 except (FileNotFoundError,PermissionError):pass
artifacts=json.loads((r/'matrix-artifacts.json').read_text())
for n in ['candidate','control']:
 a=artifacts[n];assert json.loads((Path(a['gate'])/'guard-after.json').read_text())==[]
 assert hashlib.sha256(Path(a['preserved']).read_bytes()).hexdigest()==a['sha256']
rows=[]
for t in roots:
 for p in t.rglob('*'):
  if p.is_file() and not p.is_symlink() and p.suffix in ['.rlib','.rmeta']:rows.append({'path':str(p),'bytes':p.stat().st_size})
a={'reason':'Regenerable Rust library/metadata caches only from inactive candidate/control targets after completed fixture gates. Frozen source commits, complete input receipts, generated shaders, all executed/measured ELFs and evidence retained. No timing started. Fresh per-worktree targets remain isolated.','free_before':shutil.disk_usage('/home/user').free,'files':rows,'started_unix':time.time()};out.write_text(json.dumps(a,indent=2))
for row in rows:
 p=Path(row['path']);assert p.stat().st_size==row['bytes'];p.unlink()
a['free_after']=shutil.disk_usage('/home/user').free;a['completed_unix']=time.time();out.write_text(json.dumps(a,indent=2));print(len(rows),'regenerable files removed; free GiB',a['free_after']/1024**3)
