from pathlib import Path
import hashlib,gzip,shutil,json,subprocess
root=Path('/home/user/gpui-target-native'); out=Path(__file__).parent/'old-native-executable-cleanup.json'; assert not out.exists()
archive=Path('/home/user/gpui-completed-test-binaries-archive'); archive.mkdir(exist_ok=True)
raw=Path('/home/user/gpui-preserved-test-binaries')
rows=[]
for p in root.rglob('*'):
 if not p.is_file() or p.is_symlink(): continue
 with p.open('rb') as f:
  if f.read(4)!=b'\x7fELF': continue
 h=hashlib.file_digest(p.open('rb'),'sha256').hexdigest(); target=raw/h; n=p.stat().st_size
 if target.exists():
  assert hashlib.file_digest(target.open('rb'),'sha256').hexdigest()==h
 else:
  target=archive/(h+'.gz')
  if not target.exists():
   with p.open('rb') as src,gzip.open(target,'wb',compresslevel=1) as dst:shutil.copyfileobj(src,dst)
  with gzip.open(target,'rb') as f: assert hashlib.file_digest(f,'sha256').hexdigest()==h
 rows.append({'path':str(p),'sha256':h,'bytes':n,'preserved':str(target)})
 out.write_text(json.dumps({'scope':'all ELF artifacts in completed old native cache; source/evidence/fingerprints retained','files':rows},indent=2))
 p.unlink()
 if len(rows)%100==0:print(len(rows),sum(r['bytes'] for r in rows),flush=True)
print('complete',len(rows),sum(r['bytes'] for r in rows),flush=True)
