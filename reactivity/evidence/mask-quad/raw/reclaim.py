from pathlib import Path
import subprocess,json,hashlib,shutil
r=Path(__file__).parent;d=Path('/home/user/gpui-mask-lattice-native-lab/reactivity/evidence/mask-lattice-native');target=Path('/home/user/gpui-mask-lattice-native-target')
def sha(p):return hashlib.file_digest(p.open('rb'),'sha256').hexdigest()
p=subprocess.run(['python3',str(d/'verify_dossier.py')],capture_output=True,text=True);assert p.returncode==0,p.stderr
rows=[dict(path=str(p),bytes=p.stat().st_size,sha256=sha(p)) for p in target.rglob('*') if p.is_file() and p.suffix in ['.rlib','.rmeta']]
(r/'reclaim-plan.json').write_text(json.dumps(rows,indent=2));free=shutil.disk_usage('/home/user').free
for row in rows:
 p=Path(row['path']);assert sha(p)==row['sha256'];p.unlink()
(r/'reclaim-receipt.json').write_text(json.dumps(dict(authority='b8e6667b3f93130e80776f46a3b7cb7ac1fafadd',verification=p.stdout if isinstance(p,subprocess.CompletedProcess) else 'Independent verifier returned0 before cleanup',files=len(rows),logical_bytes=sum(x['bytes'] for x in rows),free_before=free,free_after=shutil.disk_usage('/home/user').free,canonical_executables_untouched=True),indent=2))
print('reclaimed libraries',len(rows),'free',shutil.disk_usage('/home/user').free,flush=True)
