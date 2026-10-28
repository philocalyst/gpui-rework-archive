from pathlib import Path
import os,sys,json,hashlib,subprocess,time,re
root=Path(__file__).resolve().parent;gate=root/sys.argv[1];out=root/('native-'+sys.argv[1]+('-'+sys.argv[2] if len(sys.argv)>2 else ''));out.mkdir(exist_ok=False);wt=Path('/home/user/gpui-native-list-parity-lab')
artifact=json.loads((gate/'artifact.json').read_text());binary=Path(artifact['path']);assert hashlib.sha256(binary.read_bytes()).hexdigest()==artifact['sha256']
env={**os.environ,'DISPLAY':':94','XDG_RUNTIME_DIR':'/home/user/gpui-xdg','VK_ICD_FILENAMES':'/usr/share/vulkan/icd.d/lvp_icd.json','LP_NUM_THREADS':'4','DBUS_SESSION_BUS_ADDRESS':'unix:path=/nonexistent','ZGX_SECONDS':'2','ZGX_INITIAL_TICKS':'190','GPUI_LAB_TRACE':'1'}
subprocess.run(['xdotool','keyup','Alt_L','Alt_R','F4'],env=env,check=True)
results=[]
for mode,ingress,wheel in [('stream','exact',False),('stream','owner',False),('scroll','owner',False),('both','owner',False),('idle','owner',False),('both','owner',True)]:
 if len(sys.argv)>3 and mode not in sys.argv[3:]:continue
 name=mode+'-'+ingress+('-wheel' if wheel else '');log=out/(name+'.log');stdout=out/(name+'.out');p=None
 try:
  with log.open('w') as err,stdout.open('w') as of:
   p=subprocess.Popen([str(binary)],env={**env,'ZGX_MODE':mode,'GPUI_LAB_INGRESS':ingress},stdout=of,stderr=err)
   deadline=time.monotonic()+35;wid=None;injected=False
   while time.monotonic()<deadline:
    assert p.poll() is None,log.read_text()
    if wid is None:
     r=subprocess.run(['xdotool','search','--pid',str(p.pid),'--name','GPUI ZGX lab'],env=env,capture_output=True,text=True)
     if r.returncode==0 and r.stdout.strip():wid=r.stdout.splitlines()[0]
    text=log.read_text()
    if wheel and not injected and wid is not None and 'GPUI_ACK,' in text:
     subprocess.run(['xdotool','windowactivate','--sync',wid],env=env,check=True,timeout=5)
     subprocess.run(['xdotool','mousemove','--window',wid,'100','310'],env=env,check=True,timeout=5)
     subprocess.run(['xdotool','click','5'],env=env,check=True,timeout=5);injected=True
    if 'WORKLOAD_FINISHED' in text and wid is not None:break
    time.sleep(.05)
   else:raise AssertionError('native completion timeout')
   assert wid
   capture=subprocess.run(['import','-window',wid,str(out/(name+'.png'))],env=env,capture_output=True,text=True,timeout=10)
   assert capture.returncode==0,capture.stderr
   subprocess.run(['xdotool','windowactivate','--sync',wid],env=env,check=True,timeout=5)
   subprocess.run(['wmctrl','-ic',hex(int(wid))],env=env,check=True,timeout=5)
   exitcode=p.wait(timeout=15)
  text=log.read_text();assert exitcode==0,text
  assert 'PRESENTATION_ERROR' not in text and 'workload_error' not in text
  ticks=int(re.search(r'WORKLOAD_FINISHED admitted_ticks=(\d+)',text)[1]);total,received=map(int,re.search(r'workload_ticks=(\d+) admitted_ticks=(\d+)',text).groups())
  offset=float(re.search(r'workload_scroll_offset=([0-9.]+)',text)[1])
  expected=2660.+(14.*ticks if mode in ['scroll','both'] else 0.)+(32. if wheel else 0.)
  assert total==190+ticks and received==ticks and offset==expected,(offset,expected)
  assert not wheel or injected
  acks=[tuple(map(int,m)) for m in re.findall(r'GPUI_ACK,(\d+),(\d+),(\d+)',text)];assert acks
  assert all(a[1]<=b[1] for a,b in zip(acks,acks[1:]))
  if mode=='idle':assert ticks==0 and len(acks)<=2
  else:assert ticks>0 and len(acks)>1
  results.append({'mode':mode,'ingress':ingress,'exit':exitcode,'ticks':ticks,'total_ticks':total,'acknowledgements':len(acks),'distinct_presentation_epochs':len({a[1] for a in acks}),'final_ack_source_epoch':acks[-1][0],'final_workload_offset':offset,'wheel':wheel,'screenshot':name+'.png'})
  print(name,results[-1],flush=True)
 finally:
  if p is not None and p.poll() is None:p.terminate();p.wait(timeout=10)
(out/'results.json').write_text(json.dumps(results,indent=2));(out/'artifact.json').write_text(json.dumps(artifact,indent=2))
before=json.loads((gate/'inputs.json').read_text());changes=[p for p,h in before.items() if not (wt/p).is_file() or hashlib.sha256((wt/p).read_bytes()).hexdigest()!=h];(out/'guard-after.json').write_text(json.dumps(changes));assert not changes;assert hashlib.sha256(binary.read_bytes()).hexdigest()==artifact['sha256']
