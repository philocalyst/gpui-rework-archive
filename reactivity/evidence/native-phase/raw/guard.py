from pathlib import Path
import json,hashlib,subprocess
R=Path(__file__).parent
def sha(p):return hashlib.file_digest(p.open('rb'),'sha256').hexdigest()
def check(output):
 f=json.loads((R/'freeze.json').read_text());errors=[]
 for p,h in f['inputs'].items():
  if sha(R/p)!=h:errors.append(['input',p])
 for p,h in f['driver_files'].items():
  if sha(Path(p))!=h:errors.append(['driver',p])
 for name,a in json.loads((R/'artifacts.json').read_text()).items():
  if sha(Path(a['artifact']['preserved']))!=a['artifact']['sha256']:errors.append(['artifact',name])
 for name,a in f['source_guards'].items():
  w=a['worktree'];head=subprocess.check_output(['git','rev-parse','HEAD'],cwd=w,text=True).strip()
  dirty=subprocess.check_output(['git','status','--porcelain'],cwd=w,text=True)
  diff=subprocess.check_output(['git','diff','--name-only',a['frozen_source'],'HEAD','--',*a['paths']],cwd=w,text=True)
  if head!=a['current_source'] or dirty or diff:errors.append(['source',name,head,dirty,diff])
 (R/output).write_text(json.dumps(errors,indent=2));assert not errors,errors
if __name__=='__main__':check('guard-manual.json')
