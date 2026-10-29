from pathlib import Path
import os,sys,json,hashlib,subprocess,shutil,time
w=Path('/home/user/gpui-address-cost-lab');e=Path(__file__).parent;r=e/'campaign';r.mkdir(exist_ok=False)
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def save(n,v):(r/n).write_text(json.dumps(v,indent=2))
def guard():return {n:sha(w/n) for n in subprocess.check_output(['git','ls-files','-z'],cwd=w).decode().split('\0') if n and (w/n).is_file()}
assert not subprocess.check_output(['git','status','--porcelain'],cwd=w).strip()
assert shutil.disk_usage(w).free>=2*1024**3
build=e/'build-first';assert json.loads((build/'guard.json').read_text())==[];assert json.loads((build/'overall.json').read_text())['decision'].startswith('PASSED')
a=json.loads((build/'artifact.json').read_text());binary=Path(a['preserved']);assert sha(binary)==a['sha256']
# All existing build inputs must still match. Additional frozen evidence scripts
# do not alter any compiled source. No writes to this worktree during campaign.
inputs=json.loads((build/'inputs-before.json').read_text());before=guard();assert all(before.get(n)==h for n,h in inputs.items())
assert subprocess.run(['pgrep','-x','rustc'],stdout=subprocess.DEVNULL).returncode==1
assert subprocess.run(['pgrep','-x','cargo'],stdout=subprocess.DEVNULL).returncode==1
save('inputs-before.json',before);save('artifact.json',a);save('driver.json',dict(path=__file__,sha256=sha(Path(__file__)),analysis_sha256=sha(e/'analyze.py')));(r/'source.txt').write_bytes(subprocess.check_output(['git','rev-parse','HEAD'],cwd=w))
for source,dest in [('/proc/cpuinfo','cpuinfo.txt'),('/proc/meminfo','meminfo-before.txt')]:shutil.copy2(source,r/dest)
(r/'uname.txt').write_bytes(subprocess.check_output(['uname','-a']));save('processes-before.json',subprocess.check_output(['ps','-eo','pid,etime,pcpu,comm']).decode());save('disk-before.json',dict(free=shutil.disk_usage(w).free))
env=dict(os.environ,VK_ICD_FILENAMES='/usr/share/vulkan/icd.d/lvp_icd.json',LP_NUM_THREADS='4',XDG_RUNTIME_DIR='/home/user/gpui-xdg')
save('environment.json',{k:env.get(k) for k in ['VK_ICD_FILENAMES','LP_NUM_THREADS','XDG_RUNTIME_DIR','RUSTFLAGS']})
base=['raw','relocation','relative','stable'];families=['keyed4','unkeyed4','keyed256','reorder256','mixed','resources'];order=[]
for block in range(6):
 modes=base[block%4:]+base[:block%4]
 for family in families:
  for direction,sequence in [('forward',modes),('reverse',list(reversed(modes)))]:
   for mode in sequence:order.append(dict(block=block,family=family,direction=direction,mode=mode))
assert len(order)==288;save('order.json',order)
failures=[];completed=[]
try:
 for i,item in enumerate(order):
  if shutil.disk_usage(w).free<2*1024**3:raise RuntimeError('local disk floor breached; incomplete campaign invalid')
  name=f"{i:03d}-{item['block']}-{item['family']}-{item['direction']}-{item['mode']}";out=r/name
  processenv=dict(env,GPUI_ADDRESS_COST_OUTPUT=str(out),GPUI_ADDRESS_COST_MODE=item['mode'],GPUI_ADDRESS_COST_FAMILY=item['family'])
  args=[str(binary),'native::address_publication_tests::cost::complete_endpoint','--exact','--ignored','--nocapture','--test-threads=1']
  start=time.time()
  with (r/(name+'.out')).open('wb') as stdout,(r/(name+'.err')).open('wb') as stderr:p=subprocess.run(args,cwd=w/'reactivity',env=processenv,stdout=stdout,stderr=stderr)
  status=dict(index=i,**item,path=name,exit=p.returncode,elapsed_seconds=time.time()-start,args=args);save(name+'.status.json',status);completed.append(status)
  if p.returncode:failures.append(name)
  else:
   data=json.loads((out/'result.json').read_text());assert data['mode']==item['mode'] and data['family']==item['family'];assert len(data['samples'])==416
   assert data['final_wrong_bytes']==0 and (out/'final.rgba').read_bytes()==(out/'oracle.rgba').read_bytes()
  save('progress.json',dict(completed=len(completed),total=len(order),failed=failures,last=name))
  if (i+1)%8==0:print(f"completed {i+1}/288 ({item['family']}, block {item['block']}), failures {len(failures)}",flush=True)
finally:
 after=guard();save('guard.json',[n for n in before.keys()|after.keys() if before.get(n)!=after.get(n)]);save('completed.json',completed);save('disk-after.json',dict(free=shutil.disk_usage(w).free));shutil.copy2('/proc/meminfo',r/'meminfo-after.txt');assert before==after
save('overall.json',dict(decision='INVALID' if failures else 'COMPLETE; evaluate frozen gates separately',failed=failures,processes=len(completed)))
if failures:raise SystemExit(1)
