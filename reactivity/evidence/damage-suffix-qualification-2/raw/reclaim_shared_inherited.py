from pathlib import Path
import json,subprocess,hashlib,tarfile,shutil
r=Path(__file__).parent;shared=json.loads((r/'shared-source-archive-receipt.json').read_text());archive=Path(shared['shared_archive'])
def sha(p):return hashlib.file_digest(p.open('rb'),'sha256').hexdigest()
assert sha(archive)==shared['shared_sha256'];saved={}
with tarfile.open(archive,'r:gz') as t:
 for m in t:
  if m.isfile():saved[m.name]=hashlib.file_digest(t.extractfile(m),'sha256').hexdigest()
w=Path('/home/user/gpui-patch-workspace-lab');seal='f7b3f60c70faf6d548fffda530d4de83b2570e34';keep='patch-workspace'
assert subprocess.check_output(['git','rev-parse','HEAD'],cwd=w,text=True).strip()==seal
assert not subprocess.check_output(['git','status','--porcelain'],cwd=w).strip()
paths=[p for p in subprocess.check_output(['git','ls-files','-z','reactivity/evidence'],cwd=w).decode().split('\0') if p and (w/p).is_file()];hashes={p:sha(w/p) for p in paths};removed=[p for p in paths if not p.startswith('reactivity/evidence/'+keep+'/')];assert all(saved.get(p)==hashes[p] for p in removed)
(r/'patch-workspace-inherited-plan.json').write_text(json.dumps(dict(worktree=str(w),source=seal,shared_archive=str(archive),shared_sha256=sha(archive),removed={p:hashes[p] for p in removed}),indent=2));before=shutil.disk_usage('/home/user').free
dirs=subprocess.check_output(['git','ls-tree','-d','--name-only',seal+':reactivity'],cwd=w,text=True).splitlines();cone=['reactivity/'+d for d in dirs if d!='evidence']+['reactivity/evidence/'+keep,'.cargo'];subprocess.run(['git','sparse-checkout','set',*cone],cwd=w,check=True)
assert not subprocess.check_output(['git','status','--porcelain'],cwd=w).strip()
for p,h in hashes.items():
 if p not in removed:assert sha(w/p)==h
(r/'patch-workspace-inherited-receipt.json').write_text(json.dumps(dict(source=seal,removed_files=len(removed),retained_own_dossier_files=len(paths)-len(removed),shared_archive=str(archive),shared_sha256=sha(archive),free_before=before,free_after=shutil.disk_usage('/home/user').free,scope='Only duplicate ancestor evidence checkout files omitted. All exact bytes verified in shared committed-source archive; own full patch-workspace dossier and every production/vendor input remain in place. Restore inherited paths before historical full-checkout input checks.'),indent=2));print('omitted',len(removed),'verified ancestor checkout copies; free',shutil.disk_usage('/home/user').free)
