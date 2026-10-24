from pathlib import Path
import base64,hashlib,json,tarfile
from gateway import execute
local=Path('/tmp/gpui-boolean-cohort-mac-3fc-sol');remote='/Users/mileswirht/gpui-reactivity-20261024-root/component-3fc07815-sol'
code='''from pathlib import Path
import fcntl,hashlib,json,os,shutil,tarfile
p=Path(REMOTE);q=p/'qualification';status=json.loads((q/'status.json').read_text());assert status['state'] in ['complete','failed'],status['state']
with (p.parent/'host.lock').open('a') as lock:
 fcntl.flock(lock,fcntl.LOCK_EX|fcntl.LOCK_NB)
 for row in status['binaries']+status.get('application',[]):assert hashlib.sha256((q/row['file']).read_bytes()).hexdigest()==row['sha256']
 archive=p/'metadata-compact.tar.gz';assert not archive.exists()
 seen={};members={}
 candidates=[(child,'qualification/'+child.name) for child in sorted(q.iterdir()) if child.is_file() and child.suffix in ['.json','.txt','.log','.stdout','.stderr']]
 candidates += [(child,child.name) for child in [p/'job.py',p/'launcher.log',p/'source/source-pin.json'] if child.exists()]
 with tarfile.open(archive,'w:gz') as tar:
  for child,name in candidates:
   data=child.read_bytes();digest=hashlib.sha256(data).hexdigest();members[name]=dict(bytes=len(data),sha256=digest)
   if digest in seen:
    info=tar.gettarinfo(str(child),arcname=name);info.type=tarfile.LNKTYPE;info.linkname=seen[digest];info.size=0;tar.addfile(info)
   else:tar.add(child,arcname=name);seen[digest]=name
  index=p/'metadata-members.json';index.write_text(json.dumps(members,indent=2)+chr(10));tar.add(index,arcname='metadata-members.json')
 result=dict(source=status['source'],state=status['state'],passed=status.get('passed'),failed=status.get('failed'),ignored=status.get('ignored'),bytes=archive.stat().st_size,sha256=hashlib.sha256(archive.read_bytes()).hexdigest(),path=str(archive),binaries=len(status['binaries'])+len(status.get('application',[])),final_free=shutil.disk_usage(p).free)
 print(json.dumps(result))
'''.replace('REMOTE',repr(remote))
receipt=json.loads(execute(code,'gateway-metadata-compact-seal').strip());(local/'metadata-receipt.json').write_text(json.dumps(receipt,indent=2)+'\n')
path=local/'metadata.tar.gz';assert not path.exists()
with path.open('wb') as f:
 for offset in range(0,receipt['bytes'],65536):
  code='from pathlib import Path;import base64;p=Path('+repr(receipt['path'])+');f=p.open("rb");f.seek('+str(offset)+');print(base64.b64encode(f.read(65536)).decode())'
  chunk=execute(code,'gateway-compact-fetch-'+str(offset));f.write(base64.b64decode(chunk.strip(),validate=True));print(offset,flush=True)
assert path.stat().st_size==receipt['bytes'];assert hashlib.sha256(path.read_bytes()).hexdigest()==receipt['sha256']
q=local/'collected';q.mkdir()
with tarfile.open(path) as tar:
 for member in tar:
  assert (member.isfile() or member.islnk()) and not Path(member.name).is_absolute() and '..' not in Path(member.name).parts
  target=q/member.name;target.parent.mkdir(parents=True,exist_ok=True);target.write_bytes(tar.extractfile(member).read())

for name,row in json.loads((q/'metadata-members.json').read_text()).items():
 data=(q/name).read_bytes();assert len(data)==row['bytes'] and hashlib.sha256(data).hexdigest()==row['sha256'],name
print(json.dumps(receipt))
