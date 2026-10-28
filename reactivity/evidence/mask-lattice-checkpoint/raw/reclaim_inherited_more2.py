from pathlib import Path
import json,subprocess,hashlib,tarfile,shutil
r=Path(__file__).parent
shared=json.loads(Path('/home/user/gpui-damage-suffix-evidence/shared-source-archive-receipt.json').read_text());archive=Path(shared['shared_archive'])
def sha(p):return hashlib.file_digest(p.open('rb'),'sha256').hexdigest()
assert sha(archive)==shared['shared_sha256'];saved={}
with tarfile.open(archive,'r:gz') as t:
 for m in t:
  if m.isfile():saved[m.name]=hashlib.file_digest(t.extractfile(m),'sha256').hexdigest()
assert len(saved)==shared['files']
procs=subprocess.check_output(['ps','-eo','comm=,args='],text=True).splitlines()
assert not any(line.split()[0] in ['cargo','rustc','clippy-driver'] and any('/home/user/gpui-'+n+'-' in line for n in ['sparse-text','bounded-cache','state']) for line in procs)
plans=[]
for name in ['sparse-text','bounded-cache','state']:
 w=Path('/home/user/gpui-'+name+'-lab');source=subprocess.check_output(['git','rev-parse','HEAD'],cwd=w,text=True).strip()
 assert not subprocess.check_output(['git','status','--porcelain'],cwd=w).strip()
 paths=[p for p in subprocess.check_output(['git','ls-files','-z'],cwd=w).decode().split('\0') if p and (w/p).is_file()]
 hashes={p:sha(w/p) for p in paths}
 dirs=sorted({p.split('/')[2] for p in hashes if p.startswith('reactivity/evidence/') and len(p.split('/'))>3})
 omit=[d for d in dirs if all(saved.get(p)==h for p,h in hashes.items() if p.startswith('reactivity/evidence/'+d+'/'))]
 removed={p:h for p,h in hashes.items() if p.startswith('reactivity/evidence/') and len(p.split('/'))>3 and p.split('/')[2] in omit}
 keep=[d for d in dirs if d not in omit]
 non_evidence=subprocess.check_output(['git','ls-tree','-d','--name-only',source+':reactivity'],cwd=w,text=True).splitlines()
 cone=['reactivity/'+d for d in non_evidence if d!='evidence']+['reactivity/evidence/'+d for d in keep]+['.cargo','reactivity/evidence/_retain_root_files']
 plans.append(dict(worktree=str(w),source=source,old_cone=subprocess.check_output(['git','sparse-checkout','list'],cwd=w,text=True).splitlines(),new_cone=cone,removed=removed,retained={p:h for p,h in hashes.items() if p not in removed},bytes=sum((w/p).stat().st_size for p in removed)))
(r/'inherited-cleanup-more2-plan.json').write_text(json.dumps(dict(shared_archive=str(archive),shared_sha256=shared['shared_sha256'],plans=plans),indent=2))
before=shutil.disk_usage('/home/user').free;done=[]
for plan in plans:
 w=Path(plan['worktree'])
 assert subprocess.check_output(['git','rev-parse','HEAD'],cwd=w,text=True).strip()==plan['source']
 assert not subprocess.check_output(['git','status','--porcelain'],cwd=w).strip()
 for p,h in plan['removed'].items():assert sha(w/p)==saved[p]==h
 subprocess.run(['git','sparse-checkout','set',*plan['new_cone']],cwd=w,check=True)
 assert not subprocess.check_output(['git','status','--porcelain'],cwd=w).strip()
 assert all(not (w/p).exists() for p in plan['removed'])
 assert all(sha(w/p)==h for p,h in plan['retained'].items())
 done.append(dict(worktree=str(w),source=plan['source'],removed_files=len(plan['removed']),retained_files=len(plan['retained']),bytes=plan['bytes']))
 (r/'inherited-cleanup-more2-progress.json').write_text(json.dumps(done,indent=2))
 print(w.name,len(plan['removed']),'duplicate archived files omitted',flush=True)
(r/'inherited-cleanup-more2-receipt.json').write_text(json.dumps(dict(shared_archive=str(archive),shared_sha256=shared['shared_sha256'],records=done,free_before=before,free_after=shutil.disk_usage('/home/user').free,scope='Only completed duplicate inherited evidence checkout copies omitted. Every byte verified against shared immutable source archive and clean Git. All differing/own evidence and every production/vendor/build input retained. No canonical executable deleted. Restore old cone or archive before historical full-checkout guards.'),indent=2))
