from pathlib import Path
import json,hashlib,subprocess,shutil
r=Path(__file__).parent;q=json.loads((r/'audit-reference.json').read_text());d=Path(q['dossier'])
def sha(p):return hashlib.file_digest(p.open('rb'),'sha256').hexdigest()
p=subprocess.run(['python3',str(d/'verify.py')],capture_output=True,text=True);assert p.returncode==0,p.stderr
rows=[dict(path=str(p),bytes=p.stat().st_size,sha256=sha(p)) for p in Path('/home/user/gpui-mask-grid-audit-target').rglob('*') if p.is_file() and p.suffix in ['.rlib','.rmeta','.so']]
(r/'audit-cache-cleanup-plan.json').write_text(json.dumps(dict(verification=dict(exit=p.returncode,stdout=p.stdout,stderr=p.stderr),files=rows),indent=2));free=shutil.disk_usage('/home/user').free
for row in rows:
 p=Path(row['path']);assert sha(p)==row['sha256'];p.unlink()
(r/'audit-cache-cleanup.json').write_text(json.dumps(dict(files=len(rows),logical_bytes=sum(x['bytes'] for x in rows),free_before=free,free_after=shutil.disk_usage('/home/user').free,canonical_executables_untouched=True),indent=2));print('Reclaimed',len(rows),'completed libraries; free',shutil.disk_usage('/home/user').free,flush=True)
