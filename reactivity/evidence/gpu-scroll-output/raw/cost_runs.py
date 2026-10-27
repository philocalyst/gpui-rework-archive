from pathlib import Path
import os,sys,json,hashlib,subprocess,signal,time,shutil
root=Path(__file__).resolve().parent;phase=sys.argv[1];out=root/('cost-'+phase);out.mkdir(exist_ok=False)
artifacts=json.loads((root/'cost-artifacts.json').read_text());cases=['scroll','both','stream','stream-owner','fractional','flat-tiny','flat-full','list-tiny','list-flat','exposure']
def guard():
 changes=[]
 for variant,a in artifacts.items():
  wt=Path(a['worktree']);before=json.loads(Path(a['inputs']).read_text())
  changes += [(variant,p) for p,h in before.items() if not (wt/p).is_file() or hashlib.sha256((wt/p).read_bytes()).hexdigest()!=h]
  assert not subprocess.check_output(['git','status','--porcelain'],cwd=wt).strip()
  assert hashlib.sha256(Path(a['preserved']).read_bytes()).hexdigest()==a['sha256']
 return changes
assert not guard();(out/'artifacts.json').write_text(json.dumps(artifacts,indent=2))
if phase=='timing':
 jobs=json.loads(Path(artifacts['candidate']['worktree'],'reactivity/evidence/gpu-scroll-output/PROCESS_ORDER.json').read_text());assert len(jobs)==450
elif phase in ['qualification','allocations']:
 jobs=[dict(case=c,pair=i,variant=v,frames=4) for c in cases for i in range(3 if phase=='qualification' else 1) for v in ['control','predecessor','candidate']]
else:raise ValueError(phase)
(out/'jobs.json').write_text(json.dumps(jobs,indent=2));results=[];failure=None
try:
 for number,job in enumerate(jobs):
  assert shutil.disk_usage('/home/user').free>8*1024**3
  if phase=='timing':
   procs=subprocess.check_output(['ps','-eo','comm='],text=True).splitlines()
   assert not any(p.strip() in ['cargo','rustc','rust-lld','ld.lld','gcc','clang','cc1'] for p in procs), 'compiler overlaps timing'
  a=artifacts[job['variant']];label=f'{number:03d}-{job["case"]}-{job["pair"]}-{job["variant"]}';env={**os.environ,'DISPLAY':':94','XDG_RUNTIME_DIR':'/home/user/gpui-xdg','VK_ICD_FILENAMES':'/usr/share/vulkan/icd.d/lvp_icd.json','LP_NUM_THREADS':'4','DBUS_SESSION_BUS_ADDRESS':'unix:path=/nonexistent','GPUI_SCROLL_CASE':job['case'],'GPUI_SCROLL_FRAMES':str(job['frames'])}
  if phase=='allocations':env['GPUI_SCROLL_ALLOC']='1'
  else:env.pop('GPUI_SCROLL_ALLOC',None)
  cmd=[a['preserved'],'native::scroll_bench::complete_workload_cost','--ignored','--exact','--nocapture','--test-threads=1'];started=time.time()
  with (out/(label+'.out')).open('w') as stdout,(out/(label+'.log')).open('w') as stderr:
   p=subprocess.Popen(cmd,env=env,stdout=stdout,stderr=stderr,start_new_session=True)
   try:code=p.wait(timeout=90)
   finally:
    try:os.killpg(p.pid,signal.SIGTERM)
    except ProcessLookupError:pass
    if p.poll() is None:p.wait(timeout=10)
  status={**job,'command':cmd,'exit':code,'wall_seconds':time.time()-started,'environment':{k:env[k] for k in ['DISPLAY','XDG_RUNTIME_DIR','VK_ICD_FILENAMES','LP_NUM_THREADS','GPUI_SCROLL_CASE','GPUI_SCROLL_FRAMES']}}
  (out/(label+'.status.json')).write_text(json.dumps(status,indent=2));s=(out/(label+'.out')).read_text();assert code==0 and '1 passed; 0 failed' in s,label
  setup=[line[line.index('SETUP,'):].split(',') for line in s.splitlines() if 'SETUP,' in line];assert len(setup)==1
  rows=[line.split(',') for line in s.splitlines() if line.startswith('ALLOC,' if phase=='allocations' else 'FRAME,')];assert len(rows)==job['frames']+16
  size=64 if job['case']=='flat-tiny' else 512*512 if job['case']=='flat-full' else 32*32 if job['case']=='list-tiny' else 960*720
  copies=job['variant']!='control' and job['case'] in ['scroll','both','list-flat','list-tiny'];overlap=16*15 if job['case']=='list-tiny' else 920*386
  for row in rows:
   assert int(row[8 if phase=='allocations' else 5]) == size + (2*overlap if copies else 0),(label,'copy count',row)
  result={**job,'label':label,'setup':setup[0][2:],'rows':[list(map(int,row[2:])) for row in rows]};results.append(result)
  (out/'results.json').write_text(json.dumps(results,indent=2));print(phase,number+1,len(jobs),job['case'],job['variant'],'pass',flush=True)
 for case in cases:
  values={(r['setup'][-2],r['setup'][-1]) for r in results if r['case']==case};assert len(values)==1,(case,'mismatched final pixels or source epoch',values)
except BaseException as error:
 failure=repr(error);(out/'failure.txt').write_text(failure+'\n');raise
finally:
 changes=guard();(out/'guard-after.json').write_text(json.dumps(changes));assert not changes
