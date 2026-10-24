from pathlib import Path
import gzip,hashlib,json
root=Path('/tmp/gpui-delivery-isolation-sol/reactivity/evidence/delivery-isolation')
def digest(path):
 h=hashlib.sha256()
 with path.open('rb') as stream:
  while block:=stream.read(1024*1024):h.update(block)
 return h.hexdigest()
rows=json.loads((root/'file-index.json').read_text());original=0
for row in rows:
 p=root/row['archive'];assert digest(p)==row['archive_sha256'],p
 data=gzip.decompress(p.read_bytes()) if p.suffix=='.gz' else p.read_bytes()
 assert len(data)==row['original_bytes'] and hashlib.sha256(data).hexdigest()==row['original_sha256'],p
 original+=len(data)
external=json.loads((root/'external-artifacts.json').read_text())
for row in external:
 p=Path(row['path']);assert p.stat().st_size==row['bytes'] and digest(p)==row['sha256'],p
 if 'symlink_to' in row:assert str(p.resolve())==row['symlink_to']
print(json.dumps({'raw_payloads_checked':len(rows),'original_bytes_checked':original,'external_records_checked':len(external),'all_hashes_match':True}),flush=True)
