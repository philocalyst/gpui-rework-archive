from pathlib import Path
import os,sys,json,subprocess,hashlib,time,shutil,signal
w=Path('/home/user/gpui-display-traversal-cost-lab');base=Path(__file__).parent;qualified=base/'initial';out=base/sys.argv[1];out.mkdir(exist_ok=False)
def sha(p):
 with p.open('rb') as f:return hashlib.file_digest(f,'sha256').hexdigest()
def save(name,value):(out/name).write_text(json.dumps(value,indent=2))
def guard():return {n:sha(w/n) for n in subprocess.check_output(['git','ls-files','-z'],cwd=w).decode().split('\0') if n and (w/n).is_file()}
assert not subprocess.check_output(['git','status','--porcelain'],cwd=w).strip();assert shutil.disk_usage(w).free>=8*1024**3
for path in qualified.glob('*.status.json'):assert json.loads(path.read_text())['exit']==0
assert len(list(qualified.glob('preflight-*.status.json')))==45
assert json.loads((qualified/'guard.json').read_text())==[]
artifact=json.loads((qualified/'artifacts.json').read_text())['cost_worker'];worker=Path(artifact['preserved']);assert sha(worker)==artifact['sha256']
source=subprocess.check_output(['git','rev-parse','HEAD'],cwd=w).decode().strip();save('source.json',dict(source=source,worker=artifact,build_source=(qualified/'source.txt').read_text().strip(),timing_script_sha=sha(Path(__file__))))
assert source==(qualified/'source.txt').read_text().strip()
def dataset():return {str(p.relative_to(qualified/'public')):sha(p) for p in (qualified/'public').rglob('*') if p.is_file()}
dataset_before=dataset();assert dataset_before==json.loads((qualified/'public-digests.json').read_text());save('dataset-before.json',dataset_before)
pre=guard();save('inputs-before.json',pre)
env=dict(os.environ,PYTHONDONTWRITEBYTECODE='1',VK_ICD_FILENAMES='/usr/share/vulkan/icd.d/lvp_icd.json',LP_NUM_THREADS='4',XDG_RUNTIME_DIR='/home/user/gpui-xdg')
save('environment.json',{k:env.get(k) for k in ['VK_ICD_FILENAMES','LP_NUM_THREADS','XDG_RUNTIME_DIR','PYTHONDONTWRITEBYTECODE']})
order=[]
for round,first in enumerate(['control','indexed','indexed','control','control','indexed']):
 for n in [1,9,32,256,1024]:
  for scene in ['sparse','overlap','staircase']:
   for role in [first,'indexed' if first=='control' else 'control','raw']:order.append(dict(round=round,n=n,scene=scene,role=role))
save('PROCESS_ORDER.json',order)
def run(item,mode):
 name=(f"r{item['round']}-{item['scene']}-{item['n']}-{item['role']}" if mode=='timing' else f"logging-preflight-{item['role']}")
 args=['python3',str(w/'reactivity/crates/display-span-lab/model/cost_owner.py'),str(worker),str(qualified/'public'/item['scene']/str(item['n'])),item['role'],str(out/name),mode]
 start=time.time();load=Path('/proc/loadavg').read_text().strip()
 with (out/(name+'.out')).open('wb') as stdout,(out/(name+'.err')).open('wb') as stderr:
  p=subprocess.Popen(args,cwd=w/'reactivity',env=env,stdout=stdout,stderr=stderr,start_new_session=True)
  try:code=p.wait(timeout=180)
  except subprocess.TimeoutExpired:os.killpg(p.pid,signal.SIGKILL);p.wait();code=-999
 save(name+'.status.json',dict(args=args,exit=code,started_unix_seconds=start,elapsed_seconds=time.time()-start,load_before=load,free_disk_after=shutil.disk_usage(w).free));assert code==0,name
 print(name,code,flush=True)
try:
 save('admission.json',dict(ready=True,prior_exact_endpoint_preflights=45,source=source,worker_sha=artifact['sha256'],dataset_count=len(dataset_before),aggregation='median of six paired per-round p95 ratios for ALL gain and regression clauses'))
 for item in order:run(item,'timing')
finally:
 dataset_after=dataset();save('dataset-after.json',dataset_after);assert dataset_before==dataset_after;assert sha(worker)==artifact['sha256']
 after=guard();save('guard.json',[n for n in pre.keys()|after.keys() if pre.get(n)!=after.get(n)]);assert pre==after
