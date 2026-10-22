"""Lossless evidence packing, restoration and content verification."""
from pathlib import Path
import gzip,hashlib,json,sys
OUT=Path(__file__).resolve().parents[1]
def sha(data):return hashlib.sha256(data).hexdigest()
mode=sys.argv[1] if len(sys.argv)>1 else 'pack'
index=OUT/'packed-originals.json'
if mode=='unpack':
 for name,row in json.loads(index.read_text()).items():
  original=OUT/name;packed=OUT/(name+'.gz');data=gzip.decompress(packed.read_bytes())
  assert len(data)==row['bytes'] and sha(data)==row['sha256']
  if original.exists():assert original.read_bytes()==data
  else:original.write_bytes(data)
elif mode=='pack':
 rows=json.loads(index.read_text()) if index.exists() else {}
 candidates=[]
 for folder in ['checks','dhat','prior-controls']:
  candidates.extend(p for p in (OUT/folder).rglob('*') if p.is_file() and p.suffix in ['.log','.jsonl','.lock','.toml','.stderr','.stdout'])
 candidates.extend(p for p in (OUT/'checks').glob('*unit-graph.json'))
 candidates.extend([OUT/'checks/source.json',OUT/'checks/hal-unit-copy.json'])
 candidates.extend(p for p in (OUT/'dhat').glob('*.json') if not p.name.endswith('-summary.json'))
 for path in sorted(set(candidates)):
  if not path.exists():continue
  data=path.read_bytes();name=path.relative_to(OUT).as_posix()
  packed=gzip.compress(data,compresslevel=9,mtime=0);(OUT/(name+'.gz')).write_bytes(packed)
  rows[name]={'bytes':len(data),'sha256':sha(data),'packed_bytes':len(packed),'packed_sha256':sha(packed)}
  path.unlink()
 index.write_text(json.dumps(rows,indent=2)+'\n')
elif mode!='verify':raise ValueError(mode)
if index.exists():
 for name,row in json.loads(index.read_text()).items():
  packed=(OUT/(name+'.gz')).read_bytes();data=gzip.decompress(packed)
  assert sha(packed)==row['packed_sha256'] and sha(data)==row['sha256'] and len(data)==row['bytes']
  if (OUT/name).exists():assert (OUT/name).read_bytes()==data
print('evidence content verified')
