from pathlib import Path
import hashlib,json,gzip,shutil,stat,re
root=Path('/home/user/gpui-list-overscan-target/release/build');out=Path('/home/user/gpui-list-source-evidence');archive=Path('/home/user/gpui-completed-test-binaries-archive');archive.mkdir(exist_ok=True);rows=[]
for package in ['gpui','gpui_canvas']:
 for p in (root/package).glob('*/out/*'):
  if not p.is_file() or not re.fullmatch(r'.+-[a-f0-9]{16}',p.name) or p.name.startswith('gpui-') or not p.stat().st_mode&stat.S_IXUSR:continue
  data=p.read_bytes();digest=hashlib.sha256(data).hexdigest();dest=archive/(digest+'.gz')
  if not dest.exists():
   with gzip.open(dest,'wb',compresslevel=1) as f:f.write(data)
  with gzip.open(dest,'rb') as f:assert hashlib.sha256(f.read()).hexdigest()==digest
  row={'path':str(p),'archive':str(dest),'sha256':digest,'bytes':len(data),'mode':p.stat().st_mode}
  with (out/'compressed-overscan-test-binaries.jsonl').open('a') as f:f.write(json.dumps(row)+'\n');f.flush()
  p.unlink();rows.append(row)
  if len(rows)%25==0:print('archived',len(rows),'free',shutil.disk_usage('/home/user').free,flush=True)
(out/'compressed-overscan-test-binaries.json').write_text(json.dumps(rows,indent=2));print('completed',len(rows),'free',shutil.disk_usage('/home/user').free,flush=True)
