from pathlib import Path
import json,subprocess,hashlib
R=Path(__file__).parent
def sha(p):return hashlib.file_digest(Path(p).open('rb'),'sha256').hexdigest()
def snapshot(w):return {p:sha(w/p) for p in subprocess.check_output(['git','ls-files','-z'],cwd=w).decode().split('\0') if p and (w/p).is_file()}
def check(output):
 f=json.loads((R/'timing-inputs.json').read_text());errors=[]
 for p,h in f['files'].items():
  if sha(R/p)!=h:errors.append(['input',p])
 for p,h in f['environment_files'].items():
  if sha(p)!=h:errors.append(['environment',p])
 for name,s in f['sources'].items():
  w=Path(s['worktree']);before=json.loads((R/(name+'-current-inputs.json')).read_text());after=snapshot(w)
  errors += [['source-byte',name,p] for p in set(before)|set(after) if before.get(p)!=after.get(p)]
  head=subprocess.check_output(['git','rev-parse','HEAD'],cwd=w,text=True).strip();dirty=subprocess.check_output(['git','status','--porcelain'],cwd=w,text=True)
  if head!=s['current_source'] or dirty:errors.append(['source',name,head,dirty])
 for n,a in json.loads((R/'artifacts.json').read_text()).items():
  if sha(a['preserved'])!=a['sha256']:errors.append(['artifact',n])
 (R/output).write_text(json.dumps(errors,indent=2));assert not errors,errors
