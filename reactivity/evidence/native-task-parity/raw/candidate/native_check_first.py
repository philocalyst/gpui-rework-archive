from pathlib import Path
import os,sys,json,hashlib,subprocess,time,signal
r=Path(__file__).parent;g=r/sys.argv[1];stage=sys.argv[2];out=r/('native-'+stage);out.mkdir(exist_ok=False);w=Path('/home/user/gpui-native-task-parity-lab')
assert json.loads((g/'guard-after.json').read_text())==[];a=json.loads((g/(stage+'-artifacts.json')).read_text());assert len(a)==1;a=a[0];b=Path(a['preserved']);assert hashlib.sha256(b.read_bytes()).hexdigest()==a['sha256'];(out/'artifact.json').write_text(json.dumps(a,indent=2))
env={**os.environ,'DISPLAY':':94','XDG_RUNTIME_DIR':'/home/user/gpui-xdg','VK_ICD_FILENAMES':'/usr/share/vulkan/icd.d/lvp_icd.json','LP_NUM_THREADS':'4','DBUS_SESSION_BUS_ADDRESS':'unix:path=/nonexistent','ZGX_MODE':'idle','ZGX_SECONDS':'0','GPUI_LAB_TRACE':'1','GPUI_LAB_RENDERER':'gpu'};env.pop('GPUI_LAB_SNAPSHOT',None)
log=out/'app.log';commands=[]
def xdo(*args):
 cmd=['xdotool',*map(str,args)];q=subprocess.run(cmd,env=env,stdout=subprocess.PIPE,stderr=subprocess.PIPE,text=True,timeout=20);commands.append(dict(command=cmd,exit=q.returncode,stdout=q.stdout,stderr=q.stderr));assert q.returncode==0,q.stderr;return q.stdout.strip()
def wait_for(predicate,timeout=45):
 end=time.monotonic()+timeout
 while time.monotonic()<end:
  if predicate():return
  assert proc.poll() is None,('application exited',proc.returncode)
  time.sleep(.03)
 raise TimeoutError('native control progress')
code=None
try:
 with (out/'app.out').open('w') as stdout,log.open('w') as stderr:
  proc=subprocess.Popen([str(b)],env=env,stdout=stdout,stderr=stderr,start_new_session=True)
  try:
   wait_for(lambda:'GPUI_ACK,' in log.read_text())
   ids=xdo('search','--onlyvisible','--name','^GPUI ZGX lab$').splitlines();assert len(ids)==1;window=ids[0]
   xdo('windowactivate','--sync',window)
   expected=[]
   for control,op,before,after in [(1,'Rewrite',(0,0),(0,-1)),(0,'Append',(0,-1),(3,0)),(1,'Rewrite',(3,0),(3,0)),(0,'Append',(3,0),(4,-1))]:
    xdo('mousemove','--window',window,30+control*60,65);xdo('click','1')
    expected += [f'GPUI_CONTROL,queued,{op},{before[0]},{before[1]}',f'GPUI_CONTROL,yielded,{op},{before[0]},{before[1]}',f'GPUI_CONTROL,applied,{op},{after[0]},{after[1]}']
    wait_for(lambda:len([l for l in log.read_text().splitlines() if l.startswith('GPUI_CONTROL,')])>=len(expected))
    rows=[l for l in log.read_text().splitlines() if l.startswith('GPUI_CONTROL,')];assert rows==expected,(rows,expected)
   xdo('mousemove','--window',window,150,65);xdo('click','1');expected.append('GPUI_CONTROL,immediate,999,4,999')
   wait_for(lambda:'GPUI_CONTROL,immediate,999,4,999' in log.read_text());assert [l for l in log.read_text().splitlines() if l.startswith('GPUI_CONTROL,')]==expected
   xdo('key','--window',window,'alt+F4');code=proc.wait(timeout=20);assert code==0
   assert 'PRESENTATION_ERROR' not in log.read_text();(out/'expected-trace.json').write_text(json.dumps(expected,indent=2))
  finally:
   try:os.killpg(proc.pid,signal.SIGTERM)
   except ProcessLookupError:pass
   if proc.poll() is None:proc.wait(timeout=10)
finally:
 (out/'commands.json').write_text(json.dumps(commands,indent=2));(out/'status.json').write_text(json.dumps(dict(exit=code,environment={k:env[k] for k in ['DISPLAY','XDG_RUNTIME_DIR','VK_ICD_FILENAMES','LP_NUM_THREADS','ZGX_MODE','ZGX_SECONDS','GPUI_LAB_TRACE','GPUI_LAB_RENDERER']}),indent=2))
 before=json.loads((g/'inputs.json').read_text());paths=subprocess.check_output(['git','ls-files','-z','reactivity','.cargo','clippy.toml'],cwd=w).decode().split('\0');after={p:hashlib.sha256((w/p).read_bytes()).hexdigest() for p in paths if p and (w/p).is_file()};changes=[p for p in set(before)|set(after) if before.get(p)!=after.get(p)];(out/'guard-after.json').write_text(json.dumps(changes));assert not changes and hashlib.sha256(b.read_bytes()).hexdigest()==a['sha256']
print(stage,'actual native deferred controls pass',flush=True)
