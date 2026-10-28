from pathlib import Path
import json,subprocess,hashlib,shutil,tarfile
r=Path(__file__).parent;plan=json.loads((r/'inherited-cleanup-plan.json').read_text())
def sha(p):return hashlib.file_digest(p.open('rb'),'sha256').hexdigest()
archive=Path(plan['shared_archive']);assert sha(archive)==plan['shared_sha256'];saved={}
with tarfile.open(archive,'r:gz') as t:
 for m in t:
  if m.isfile():saved[m.name]=hashlib.file_digest(t.extractfile(m),'sha256').hexdigest()
assert not any(n.strip() in ['cargo','rustc','clippy-driver'] for n in subprocess.check_output(['ps','-eo','comm='],text=True).splitlines())
(r/'inherited-cleanup-correction.json').write_text(json.dumps(dict(cause='First completed checkout had no differing evidence subdirectory to retain; cone omitted evidence-root files as well. The retained-file afterguard caught this immediately.',correction='Include a nonexisting child cone to retain evidence-root files without restoring duplicate subdirectories. Preserve initial failure and plan. Restore and revalidate all retained hashes before continuing.',no_build_or_timing_observation=True),indent=2))
free_start=shutil.disk_usage('/home/user').free;done=[]
for i,p in enumerate(plan['plans']):
 w=Path(p['worktree']);assert subprocess.check_output(['git','rev-parse','HEAD'],cwd=w,text=True).strip()==p['source']
 assert not subprocess.check_output(['git','status','--porcelain'],cwd=w).strip()
 for name,h in p['removed'].items():
  assert saved.get(name)==h
  if (w/name).exists():assert sha(w/name)==h
  else:assert i==0
 for name,h in p['retained'].items():
  if (w/name).exists():assert sha(w/name)==h
  else:assert i==0 and name.startswith('reactivity/evidence/') and len(name.split('/'))==3,name
 cone=p['new_cone']+['reactivity/evidence/_retain_root_files']
 subprocess.run(['git','sparse-checkout','set',*cone],cwd=w,check=True)
 assert not subprocess.check_output(['git','status','--porcelain'],cwd=w).strip()
 assert all(not (w/name).exists() for name in p['removed'])
 assert all(sha(w/name)==h for name,h in p['retained'].items())
 done.append(dict(worktree=str(w),source=p['source'],removed_files=len(p['removed']),retained_files=len(p['retained']),bytes=p['bytes'],new_cone=cone))
 (r/'inherited-cleanup-progress.json').write_text(json.dumps(done,indent=2));print(w.name,len(p['removed']),'archived duplicate files omitted; all retained bytes exact',flush=True)
(r/'inherited-cleanup-receipt.json').write_text(json.dumps(dict(shared_archive=str(archive),shared_sha256=plan['shared_sha256'],records=done,free_after_initial_stop=free_start,free_after=shutil.disk_usage('/home/user').free,scope='Only completed duplicate ancestor evidence checkout copies omitted. Every byte verified in immutable archive; differing/own evidence, root files and all actual source/build inputs retained exactly. No executable deleted. Restore old cone or archive before historical full-checkout guards. Initial root-file guard failure restored and retained.'),indent=2))
