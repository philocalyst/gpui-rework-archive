from pathlib import Path
import os,json,hashlib,subprocess,shutil
r=Path(__file__).parent;t=Path('/home/user/gpui-damage-suffix-target');raw=Path('/home/user/gpui-preserved-test-binaries');checkpoint=Path('/home/user/gpui-damage-suffix-checkpoint-lab')
assert subprocess.check_output(['git','rev-parse','HEAD'],cwd=checkpoint,text=True).strip()=='342e9495b10d7ab41ec9200b2d6a28acbb2af956'
assert not any(x in subprocess.check_output(['ps','-eo','comm='],text=True).splitlines() for x in ['rustc','cargo','clippy-driver'])
for d in Path('/proc').iterdir():
 if d.name.isdigit():
  try:assert not str((d/'exe').resolve()).startswith(str(t))
  except (OSError,RuntimeError):pass
def sha(p):return hashlib.file_digest(p.open('rb'),'sha256').hexdigest()
rows=[]
for p in t.rglob('*'):
 if not p.is_file() or p.is_symlink() or p.stat().st_size<1_000_000:continue
 with p.open('rb') as f:
  if f.read(4)!=b'\x7fELF':continue
 h=sha(p);q=raw/h
 if not q.is_file():continue
 assert sha(q)==h;rows.append(dict(path=str(p),preserved=str(q),bytes=p.stat().st_size,sha256=h,mode=p.stat().st_mode&0o777))
(r/'candidate-cache-reclamation-2-plan.json').write_text(json.dumps(rows,indent=2));before=shutil.disk_usage('/home/user').free;done=[]
for row in rows:
 p=Path(row['path']);assert sha(p)==row['sha256'];assert sha(Path(row['preserved']))==row['sha256'];p.unlink();done.append(row)
 (r/'candidate-cache-reclamation-2-completed.json').write_text(json.dumps(done,indent=2))
after=shutil.disk_usage('/home/user').free
(r/'candidate-cache-reclamation-2.json').write_text(json.dumps(dict(checkpoint='342e9495b10d7ab41ec9200b2d6a28acbb2af956',files=len(rows),bytes=sum(x['bytes'] for x in rows),free_before=before,free_after=after,scope='Only completed ELF cache copies already verified in canonical raw storage. No new archive allocation below reserve; source/evidence/libraries/shaders/fingerprints and all canonical bytes retained. No build/test/timing overlaps cleanup.'),indent=2));assert after>8*1024**3;print('reclaimed',len(rows),'cache copies; free',after)
