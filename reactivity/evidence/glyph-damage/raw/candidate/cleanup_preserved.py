from pathlib import Path
import json,hashlib,shutil,time
r=Path(__file__).parent;out=r/'completed-executable-cleanup.json';assert not out.exists()
roots=[Path('/home/user/gpui-image-placement-target'),Path('/home/user/gpui-local-publication-target'),Path('/home/user/gpui-scroll-output-target')];rows=[];seen={};verified=set();before=shutil.disk_usage('/home/user').free
for root in roots:
 for p in root.rglob('*'):
  if not p.is_file() or p.is_symlink():continue
  with p.open('rb') as f:magic=f.read(4)
  if magic!=b'\x7fELF':continue
  st=p.stat();key=(st.st_dev,st.st_ino)
  h=seen.get(key)
  if h is None:h=hashlib.sha256(p.read_bytes()).hexdigest();seen[key]=h
  saved=Path('/home/user/gpui-preserved-test-binaries')/h
  if not saved.is_file():continue
  if h not in verified:assert hashlib.sha256(saved.read_bytes()).hexdigest()==h;verified.add(h)
  rows.append(dict(path=str(p),sha256=h,preserved=str(saved),bytes=st.st_size))
a={'reason':'Only completed inactive target ELF paths with independently verified immutable preserved copies; active candidate/control targets untouched; no timing active','free_before':before,'files':rows,'started_unix':time.time()};out.write_text(json.dumps(a,indent=2)+'\n')
for row in rows:
 p=Path(row['path']);assert p.stat().st_size==row['bytes'];p.unlink()
a['free_after']=shutil.disk_usage('/home/user').free;a['completed_unix']=time.time();out.write_text(json.dumps(a,indent=2)+'\n');print(len(rows),'paths',len(verified),'distinct verified preserved binaries; free GiB',a['free_after']/1024**3)
