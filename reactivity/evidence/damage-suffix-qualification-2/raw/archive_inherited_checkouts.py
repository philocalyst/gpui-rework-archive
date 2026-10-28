from pathlib import Path
import subprocess,json,hashlib,tarfile,shutil
r=Path(__file__).parent
for name,keep,seal in [('native-phase','native-phase','a34b61c86fbbc6906d834e071bdb7c4fb70aac8d'),('native-workspace','native-workspace','344c7f8ddd55326dca2c88322f67530914c97733')]:
 w=Path('/home/user/gpui-'+name+'-lab');out=r/('inherited-'+name);out.mkdir(exist_ok=False)
 assert subprocess.check_output(['git','rev-parse','HEAD'],cwd=w,text=True).strip()==seal
 assert not subprocess.check_output(['git','status','--porcelain'],cwd=w).strip()
 paths=subprocess.check_output(['git','ls-files','-z','reactivity/evidence'],cwd=w).decode().split('\0');paths=[p for p in paths if p and (w/p).is_file()]
 def sha(p):return hashlib.file_digest(p.open('rb'),'sha256').hexdigest()
 hashes={p:sha(w/p) for p in paths};(out/'files-before.json').write_text(json.dumps(hashes,indent=2))
 archive=out/'committed-evidence.tar.gz';subprocess.run(['git','archive','--format=tar.gz','--output='+str(archive),seal,'reactivity/evidence'],cwd=w,check=True)
 seen={}
 with tarfile.open(archive,'r:gz') as t:
  for m in t:
   if m.isfile():seen[m.name]=hashlib.file_digest(t.extractfile(m),'sha256').hexdigest()
 assert all(seen.get(p)==h for p,h in hashes.items())
 before=shutil.disk_usage('/home/user').free
 dirs=subprocess.check_output(['git','ls-tree','-d','--name-only',seal+':reactivity'],cwd=w,text=True).splitlines();cone=['reactivity/'+d for d in dirs if d!='evidence']+['reactivity/evidence/'+keep,'.cargo']
 subprocess.run(['git','sparse-checkout','set',*cone],cwd=w,check=True)
 assert not subprocess.check_output(['git','status','--porcelain'],cwd=w).strip()
 remaining={p:sha(w/p) for p in paths if (w/p).is_file()};assert all(hashes[p]==h for p,h in remaining.items())
 assert all(p in remaining for p in paths if p.startswith('reactivity/evidence/'+keep+'/'))
 removed=[p for p in paths if p not in remaining]
 (out/'receipt.json').write_text(json.dumps(dict(source=seal,worktree=str(w),archive=str(archive),archive_sha256=sha(archive),archived_files=len(seen),previous_files=len(paths),remaining_files=len(remaining),removed_checkout_copies=removed,cone=cone,free_before=before,free_after=shutil.disk_usage('/home/user').free,scope='Only duplicate inherited evidence checkout copies omitted from completed worktrees. Every byte verified in an exact committed-evidence archive and Git; own sealed dossier and all production/vendor/build inputs remain present. Original historical experiment worktrees untouched. Restore omitted paths from archive or git sparse-checkout add before a historical full-checkout guard.'),indent=2));print(name,len(removed),'inherited checkout copies archived; free',shutil.disk_usage('/home/user').free,flush=True)
