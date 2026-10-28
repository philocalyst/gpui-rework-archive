from pathlib import Path
import os,sys,json,hashlib,subprocess,signal,time,shutil,itertools,random
root=Path(__file__).resolve().parent; phase=sys.argv[1]; out=root/('matrix-'+phase); out.mkdir(exist_ok=False)
(out/'runner.py').write_bytes(Path(__file__).read_bytes())
definition=json.loads((root/'cost-definition.json').read_text()); cases=definition['cases']; variants=definition['variants']
artifacts=json.loads((root/'matrix-artifacts.json').read_text()); assert set(artifacts)==set(variants)
def guard():
 changes=[]
 for variant,a in artifacts.items():
  wt=Path(a['worktree']); before=json.loads(Path(a['inputs']).read_text())
  paths=subprocess.check_output(['git','ls-files','-z','reactivity','.cargo','clippy.toml'],cwd=wt).decode().split('\0')
  after={p:hashlib.sha256((wt/p).read_bytes()).hexdigest() for p in paths if p and (wt/p).is_file()}
  changes += [(variant,p) for p in set(before)|set(after) if before.get(p)!=after.get(p)]
  assert subprocess.check_output(['git','rev-parse','HEAD'],cwd=wt,text=True).strip()==a['source']
  assert not subprocess.check_output(['git','status','--porcelain'],cwd=wt).strip()
  assert hashlib.sha256(Path(a['preserved']).read_bytes()).hexdigest()==a['sha256']
 return changes
assert not guard(); (out/'artifacts.json').write_text(json.dumps(artifacts,indent=2))
manifest=root/'process-order.json'
assert hashlib.sha256(manifest.read_bytes()).hexdigest()==definition['process_manifest_sha256']
if phase=='timing':
 jobs=json.loads(manifest.read_text()); assert len(jobs)==2800
 # Independently reconstruct the preregistered order.
 sequences=[]
 for k in range(5):
  sequence=[(v+k)%5 for v in [0,1,4,2,3]];sequences.extend([sequence,sequence[::-1]])
 sequences=sequences*2;groups=[]
 assert all(sum(s[i]==v for s in sequences)==4 for i in range(5) for v in range(5))
 for ci,c in enumerate(cases):
  for pair in range(20):groups.append([dict(case=c,pair=pair,variant=variants[v],frames=64) for v in sequences[(pair+ci)%20]])
 random.Random(definition['seed']).shuffle(groups)
 assert jobs==[j for group in groups for j in group]
 for prior,count in [('qualification',420),('allocations',140)]:
  d=root/('matrix-'+prior); assert json.loads((d/'guard-after.json').read_text())==[]
  assert len(json.loads((d/'results.json').read_text()))==count and not (d/'failure.txt').exists()
  assert json.loads((d/'artifacts.json').read_text())==artifacts
 assert (root/'matrix-preflight.json').is_file()
elif phase in ['qualification','allocations']:
 jobs=[dict(case=c,pair=i,variant=v,frames=4) for c in cases for i in range(3 if phase=='qualification' else 1) for v in variants]
else:raise ValueError(phase)
(out/'jobs.json').write_text(json.dumps(jobs,indent=2));results=[]
try:
 for number,job in enumerate(jobs):
  assert shutil.disk_usage('/home/user').free>8*1024**3
  if phase=='timing':
   procs=subprocess.check_output(['ps','-eo','comm='],text=True).splitlines()
   assert not any(p.strip() in ['cargo','rustc','rust-lld','ld.lld','gcc','clang','cc1','clippy-driver'] for p in procs),'compiler overlaps timing'
  a=artifacts[job['variant']]; label=f'{number:04d}-{job["case"]}-{job["pair"]}-{job["variant"]}'
  env={**os.environ,'DISPLAY':':94','XDG_RUNTIME_DIR':'/home/user/gpui-xdg','VK_ICD_FILENAMES':'/usr/share/vulkan/icd.d/lvp_icd.json','LP_NUM_THREADS':'4','DBUS_SESSION_BUS_ADDRESS':'unix:path=/nonexistent','GPUI_SCROLL_CASE':job['case'],'GPUI_SCROLL_FRAMES':str(job['frames'])}
  if phase=='allocations':env['GPUI_SCROLL_ALLOC']='1'
  else:env.pop('GPUI_SCROLL_ALLOC',None)
  cmd=[a['preserved'],'native::scroll_bench::complete_workload_cost','--ignored','--exact','--nocapture','--test-threads=1']; started=time.time()
  with (out/(label+'.out')).open('w') as stdout,(out/(label+'.log')).open('w') as stderr:
   p=subprocess.Popen(cmd,env=env,stdout=stdout,stderr=stderr,start_new_session=True)
   try:code=p.wait(timeout=90)
   finally:
    try:os.killpg(p.pid,signal.SIGTERM)
    except ProcessLookupError:pass
    if p.poll() is None:p.wait(timeout=10)
  status={**job,'command':cmd,'exit':code,'wall_seconds':time.time()-started,'environment':{k:env[k] for k in ['DISPLAY','XDG_RUNTIME_DIR','VK_ICD_FILENAMES','LP_NUM_THREADS','DBUS_SESSION_BUS_ADDRESS','GPUI_SCROLL_CASE','GPUI_SCROLL_FRAMES']}}
  (out/(label+'.status.json')).write_text(json.dumps(status,indent=2));s=(out/(label+'.out')).read_text();assert code==0 and '1 passed; 0 failed' in s,label
  setup=[line[line.index('SETUP,'):].split(',') for line in s.splitlines() if 'SETUP,' in line];assert len(setup)==1
  rows=[line.split(',') for line in s.splitlines() if line.startswith('ALLOC,' if phase=='allocations' else 'FRAME,')];assert len(rows)==job['frames']+16
  size=64 if job['case']=='flat-tiny' else 512*512 if job['case']=='flat-full' else 32*32 if job['case']=='list-tiny' else 960*720
  assert [int(row[2]) for row in rows]==list(range(job['frames']+16))
  copied=size;image_bytes=size*4
  if job['variant'] in ['copy_bounds','candidate'] and job['case'] in ['scroll','both','list-flat','list-tiny']:
   overlap=240 if job['case']=='list-tiny' else 355120
   copied+=2*overlap;image_bytes+=4*overlap
  for row in rows:
   assert row[1]==job['case']
   assert int(row[8 if phase=='allocations' else 5])==copied,(label,'copy count',row)
   assert int(row[7 if phase=='allocations' else 6])==image_bytes,(label,'retained image bytes',row)
  result={**job,'label':label,'setup':setup[0][2:],'rows':[list(map(int,row[2:])) for row in rows]};results.append(result)
  if phase=='timing':
   with (out/'results.jsonl').open('a') as f:f.write(json.dumps(result)+'\n')
  else:(out/'results.json').write_text(json.dumps(results,indent=2))
  print(phase,number+1,len(jobs),job['case'],job['variant'],'pass',flush=True)
 for case in cases:
  values={(r['setup'][-2],r['setup'][-1]) for r in results if r['case']==case};assert len(values)==1,(case,'mismatched final pixels or source epoch',values)
except BaseException as error:
 (out/'failure.txt').write_text(repr(error)+'\n');raise
finally:
 if phase=='timing':(out/'results.json').write_text(json.dumps(results,indent=2))
 changes=guard();(out/'guard-after.json').write_text(json.dumps(changes));assert not changes
