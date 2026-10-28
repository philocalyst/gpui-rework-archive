from pathlib import Path
import sys,json,hashlib,gzip,shutil,os
# Restore one exact historical target path from its completed cache receipt.
rows=json.loads(Path(sys.argv[1]).read_text());row=next(r for r in rows if r['path']==sys.argv[2]);p=Path(row['path']);assert not p.exists();a=Path(row['archive']);tmp=p.with_name(p.name+'.restore-region-tmp');assert not tmp.exists();p.parent.mkdir(parents=True,exist_ok=True)
with (gzip.open(a,'rb') if row['archive_kind']=='gzip' else a.open('rb')) as src,tmp.open('xb') as dest:shutil.copyfileobj(src,dest)
assert hashlib.file_digest(tmp.open('rb'),'sha256').hexdigest()==row['sha256'];assert tmp.stat().st_size==row['bytes'];tmp.chmod(row['mode']);tmp.rename(p);print(p)
