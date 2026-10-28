from pathlib import Path
import json,hashlib,subprocess
r=Path(__file__).parent
def sha(p):return hashlib.file_digest(Path(p).open('rb'),'sha256').hexdigest()
def snapshot(w):
 return {p:sha(w/p) for p in subprocess.check_output(['git','ls-files','-z'],cwd=w).decode().split('\0') if p and (w/p).is_file()}
def guard():
 changes=[]
 for v,a in json.loads((r/'matrix-artifacts.json').read_text()).items():
  w=Path(a['worktree']);before=json.loads(Path(a['inputs']).read_text());after=snapshot(w)
  changes += [(v,p) for p in set(before)|set(after) if before.get(p)!=after.get(p)]
  assert subprocess.check_output(['git','rev-parse','HEAD'],cwd=w,text=True).strip()==a['current_source']
  assert not subprocess.check_output(['git','status','--porcelain'],cwd=w).strip()
  for artifact in [a,a['native_artifact']]:assert sha(artifact['preserved'])==artifact['sha256']
 return changes
def frozen():
 for p,h in json.loads((r/'runner-receipt.json').read_text())['files'].items():assert sha(r/p)==h,p
