from pathlib import Path
import json,hashlib,subprocess
R=Path(__file__).parent
def sha(p):return hashlib.file_digest(p.open('rb'),'sha256').hexdigest()
def check(output):
 f=json.loads((R/'timing-inputs.json').read_text());errors=[]
 for p,h in f['files'].items():
  if sha(R/p)!=h:errors.append(['input',p])
 for p,h in f['environment_files'].items():
  if sha(Path(p))!=h:errors.append(['environment',p])
 for n,s in f['sources'].items():
  w=s['worktree']
  head=subprocess.check_output(['git','rev-parse','HEAD'],cwd=w,text=True).strip();dirty=subprocess.check_output(['git','status','--porcelain'],cwd=w,text=True);diff=subprocess.check_output(['git','diff','--name-only',s['compiled_source'],'HEAD','--',*s['build_paths']],cwd=w,text=True)
  if head!=s['current_source'] or dirty or diff:errors.append(['source',n,head,dirty,diff])
 for n,a in json.loads((R/'artifacts.json').read_text()).items():
  if sha(Path(a['preserved']))!=a['sha256']:errors.append(['artifact',n])
 (R/output).write_text(json.dumps(errors,indent=2));assert not errors,errors
