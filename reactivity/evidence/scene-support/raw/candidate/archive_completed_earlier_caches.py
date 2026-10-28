from pathlib import Path
import os,json,hashlib,gzip,shutil,sys
root=Path(sys.argv[1]).resolve();assert root in {Path('/home/user/gpui-scroll-output-target'), Path('/home/user/gpui-glyph-submit-target'), Path('/home/user/gpui-sparse-batch-target'), Path('/home/user/gpui-target-retained'), Path('/home/user/gpui-target-baseline')}
r=Path(__file__).parent;out=r/('archive-'+root.name);out.mkdir(exist_ok=False)
# Only completed, inactive target executables; leave source, evidence, generated
# files and the canonical preserved ELF stores intact. An exact path/hash receipt
# permits restoring any cached ELF before rerunning a historical path-based gate.
processes=[]
for d in Path('/proc').iterdir():
 if not d.name.isdigit():continue
 try:
  e=(d/'exe').resolve();cmd=(d/'cmdline').read_bytes().replace(b'\0',b' ').decode(errors='replace')
 except (OSError,RuntimeError):continue
 if str(e).startswith(str(root)) or (str(root) in cmd and any(s in cmd for s in ['rustc --','cargo +','clippy-driver --'])):processes.append((d.name,str(e),cmd))
assert not processes,processes
store=Path('/home/user/gpui-completed-test-binaries-archive');raw=Path('/home/user/gpui-preserved-test-binaries');rows=[]
def sha_stream(f):return hashlib.file_digest(f,'sha256').hexdigest()
for parent,ds,fs in os.walk(root):
 for f in fs:
  p=Path(parent)/f
  if p.is_symlink() or p.stat().st_size<1_000_000:continue
  with p.open('rb') as q:
   if q.read(4)!=b'\x7fELF':continue
  with p.open('rb') as q:h=sha_stream(q)
  rows.append({'path':str(p),'bytes':p.stat().st_size,'sha256':h,'mode':p.stat().st_mode & 0o777})
(out/'plan.json').write_text(json.dumps(rows,indent=2));completed=[];free0=shutil.disk_usage('/home/user').free
for i,row in enumerate(rows):
 p=Path(row['path']);h=row['sha256'];q=raw/h;z=store/(h+'.gz');kind='raw'
 if q.exists():
  with q.open('rb') as f:assert sha_stream(f)==h
 else:
  kind='gzip'
  if not z.exists():
   temporary=z.with_suffix('.gz.region-tmp');assert not temporary.exists()
   with p.open('rb') as a,gzip.open(temporary,'wb',compresslevel=6) as b:shutil.copyfileobj(a,b)
   with gzip.open(temporary,'rb') as f:assert sha_stream(f)==h
   temporary.rename(z)
  with gzip.open(z,'rb') as f:assert sha_stream(f)==h
 row.update(archive=str(q if kind=='raw' else z),archive_kind=kind)
 assert hashlib.file_digest(p.open('rb'),'sha256').hexdigest()==h
 p.unlink();completed.append(row)
 (out/'completed.json').write_text(json.dumps(completed,indent=2))
 assert shutil.disk_usage('/home/user').free>8*1024**3
 if i%25==0:print(i+1,len(rows),'preserved and removed cache',flush=True)
(out/'result.json').write_text(json.dumps({'files':len(rows),'logical_bytes':sum(x['bytes'] for x in rows),'free_before':free0,'free_after':shutil.disk_usage('/home/user').free,'scope':'Only completed target ELF cache copies; every exact binary remains verified in the canonical raw or compressed store. No source or evidence removed.'},indent=2));print('completed',len(rows),'free',shutil.disk_usage('/home/user').free,flush=True)
