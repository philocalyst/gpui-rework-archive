from pathlib import Path
import json,hashlib,gzip,subprocess,shutil,stat
r=Path(__file__).parent;roots=[Path('/home/user/'+n) for n in ['gpui-list-source-target','gpui-text-session-target','gpui-sparse-text-target','gpui-cold-trim-target','gpui-tree-admitted-target']];ps=subprocess.check_output(['ps','-eo','comm=,args='],text=True)
assert not any(l.strip().split()[0] in ['cargo','rustc','clippy-driver'] and any(str(t) in l for t in roots) for l in ps.splitlines())
record=dict(reason='Delete completed-target duplicate ELF files only after matching a separately preserved raw ELF or verified gzip archive by decompressed SHA256. Global preserved stores, generated shaders, fingerprints, source/evidence and nonmatching target files stay intact. No build/timing active in these targets.',free_before=shutil.disk_usage('/home/user').free,files=[]);checked=set()
for t in roots:
 for p in t.rglob('*'):
  if not p.is_file() or not p.stat().st_mode & stat.S_IXUSR:continue
  with p.open('rb') as f:
   if f.read(4)!=b'\x7fELF':continue
  h=hashlib.sha256(p.read_bytes()).hexdigest();saved=Path('/home/user/gpui-preserved-test-binaries')/h;compression=None
  if not saved.exists():saved=Path('/home/user/gpui-completed-test-binaries-archive')/(h+'.gz');compression='gzip'
  if not saved.exists():continue
  if h not in checked:
   data=gzip.decompress(saved.read_bytes()) if compression else saved.read_bytes();assert hashlib.sha256(data).hexdigest()==h;checked.add(h)
  record['files'].append(dict(path=str(p),preserved=str(saved),sha256=h,bytes=p.stat().st_size,compression=compression))
(r/'completed-duplicate-cleanup-plan.json').write_text(json.dumps(record,indent=2))
for f in record['files']:Path(f['path']).unlink()
record['free_after']=shutil.disk_usage('/home/user').free;(r/'completed-duplicate-cleanup.json').write_text(json.dumps(record,indent=2));print('removed',len(record['files']),'verified duplicates; free',record['free_after'])
assert record['free_after']>12*1024**3
