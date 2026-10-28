from pathlib import Path
import json,subprocess,hashlib,tarfile,shutil
r=Path(__file__).parent;store=Path('/home/user/gpui-completed-source-archives');store.mkdir(exist_ok=True);base='41a67473a0177fbb17df1f7b8e2f2f36dd6940f6';w=Path('/home/user/gpui-damage-suffix-lab')
def sha(p):return hashlib.file_digest(p.open('rb'),'sha256').hexdigest()
q=store/(base+'-inherited-evidence.tar.gz');assert not q.exists()
subprocess.run(['git','archive','--format=tar.gz','--output='+str(q),base,'reactivity/evidence'],cwd=w,check=True)
seen={}
with tarfile.open(q,'r:gz') as t:
 for m in t:
  if m.isfile():seen[m.name]=hashlib.file_digest(t.extractfile(m),'sha256').hexdigest()
records=[]
for name in ['native-phase','native-workspace']:
 d=r/('inherited-'+name);receipt=json.loads((d/'receipt.json').read_text());before=json.loads((d/'files-before.json').read_text());wt=Path(receipt['worktree']);archive=Path(receipt['archive']);assert sha(archive)==receipt['archive_sha256']
 removed=set(receipt['removed_checkout_copies']);assert all(seen.get(p)==before[p] for p in removed)
 remaining={p:h for p,h in before.items() if p not in removed};assert all((wt/p).is_file() and sha(wt/p)==h for p,h in remaining.items())
 assert not subprocess.check_output(['git','diff','--name-only',receipt['source'],'HEAD','--','reactivity/evidence'],cwd=wt).strip()
 records.append(dict(original_archive=str(archive),original_sha256=sha(archive),original_bytes=archive.stat().st_size,source=receipt['source'],all_removed_files_in_shared_archive=True,removed_files=len(removed),own_dossier_files_verified_in_original_worktree_and_git=len(remaining),worktree=str(wt)))
free=shutil.disk_usage('/home/user').free
(r/'shared-source-archive-plan.json').write_text(json.dumps(dict(shared_archive=str(q),shared_sha256=sha(q),base=base,files=len(seen),records=records),indent=2))
for x in records:Path(x['original_archive']).unlink()
(r/'shared-source-archive-receipt.json').write_text(json.dumps(dict(shared_archive=str(q),shared_sha256=sha(q),shared_bytes=q.stat().st_size,base=base,files=len(seen),records=records,free_before=free,free_after=shutil.disk_usage('/home/user').free,scope='Duplicate inherited evidence bytes consolidated into one verified immutable source archive. All omitted checkout files map exactly to this archive; each experiment own sealed dossier remains in its original worktree and Git. The superseded tar containers were newly created cleanup artifacts, not historical execution bytes. No canonical executable or historical source/evidence content removed.'),indent=2));print('shared source archive',len(seen),'files;free',shutil.disk_usage('/home/user').free)
