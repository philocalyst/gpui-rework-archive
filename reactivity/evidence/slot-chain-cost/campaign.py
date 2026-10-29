from pathlib import Path
import os,sys,json,hashlib,subprocess,time,shutil
root=Path(__file__).parent

def sha(p):
 with p.open('rb') as f:return hashlib.file_digest(f,'sha256').hexdigest()
def save(p,v):p.write_text(json.dumps(v,indent=2))
def worktree(role):return Path('/home/user/gpui-slot-chain-cost'+('-control' if role=='control' else '')+'-lab')
def inputs():
 paths=[Path(__file__),root/'build_gate.py',root/'analyze.py',root/'qualify.py',root/'qualification.json',root/'order.json']+list((root/'configs').glob('*.json'))
 for role in ['control','candidate']:
  w=worktree(role)
  assert not subprocess.check_output(['git','status','--porcelain'],cwd=w).strip()
  paths += [w/n for n in subprocess.check_output(['git','ls-files','-z'],cwd=w).decode().split('\0') if n and (w/n).is_file()]
  paths += [Path(json.loads((root/(role+'-gate')/'artifact.json').read_text())['preserved']),root/(role+'-gate')/'ui.wgsl']
 return {str(p):sha(p) for p in paths}
if sys.argv[1]=='prepare':
 (root/'configs').mkdir(exist_ok=False);order=[]
 for rnd in range(6):
  sizes=[1,9,32,256,1024];sizes=sizes[rnd%5:]+sizes[:rnd%5]
  for n in sizes:
   modes=['single','coalesced','return-original'];modes=modes[::-1] if rnd%2 else modes
   for mode in modes+(['geometry'] if n in [1,1024] else []):
    for role in (['candidate','control','control','candidate'] if rnd%2 else ['control','candidate','candidate','control']):
     config=dict(index=len(order),round=rnd,n=n,mode=mode,role=role);name=f'{len(order):03d}-{role}-{mode}-{n}'
     save(root/'configs'/(name+'.json'),config);order.append(dict(name=name,**config))
 assert len(order)==408;save(root/'order.json',order);print('prepared 408 immutable configs')
elif sys.argv[1]=='run':
 r=root/'timing';r.mkdir(exist_ok=False)
 assert shutil.disk_usage(root).free>=8*1024**3
 assert (root/'qualification.json').exists()
 before=inputs();save(r/'inputs-before.json',before)
 env=dict(os.environ,VK_ICD_FILENAMES='/usr/share/vulkan/icd.d/lvp_icd.json',LP_NUM_THREADS='4',XDG_RUNTIME_DIR='/home/user/gpui-xdg');env.pop('GPUI_CHAIN_COST_PREFLIGHT',None)
 save(r/'environment.json',{k:env.get(k) for k in ['VK_ICD_FILENAMES','LP_NUM_THREADS','XDG_RUNTIME_DIR']})
 (r/'uname.txt').write_bytes(subprocess.check_output(['uname','-a']));shutil.copyfile('/proc/cpuinfo',r/'cpuinfo.txt')
 try:
  for case in json.loads((root/'order.json').read_text()):
   name=case['name'];artifact=json.loads((root/(case['role']+'-gate')/'artifact.json').read_text());args=[artifact['preserved'],'native::slot_chain_cost::live_chain_cost','--exact','--ignored','--nocapture','--test-threads=1'];start=time.time()
   with (r/(name+'.out')).open('wb') as out,(r/(name+'.err')).open('wb') as err:
    p=subprocess.run(args,cwd=worktree(case['role'])/'reactivity',env=dict(env,GPUI_CHAIN_COST_CONFIG=str(root/'configs'/(name+'.json')),GPUI_CHAIN_COST_OUTPUT=str(r/name)),stdout=out,stderr=err)
   save(r/(name+'.status.json'),dict(args=args,exit=p.returncode,elapsed_seconds=time.time()-start));print(name,p.returncode,flush=True);assert p.returncode==0,name
 finally:
  after=inputs();save(r/'inputs-after.json',after);save(r/'guard.json',[p for p in before.keys()|after.keys() if before.get(p)!=after.get(p)]);assert before==after
else:raise ValueError(sys.argv[1])
