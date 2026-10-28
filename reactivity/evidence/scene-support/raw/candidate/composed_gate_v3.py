from pathlib import Path
import os,json,subprocess,hashlib,sys,shutil,time,signal
r=Path(__file__).parent;w=Path('/home/user/gpui-scene-support-lab');target=Path('/home/user/gpui-scene-support-target');mode=sys.argv[1];out=r/sys.argv[2];out.mkdir(exist_ok=False)
def sha(p):return hashlib.file_digest(p.open('rb'),'sha256').hexdigest()
def inputs():return {p:sha(w/p) for p in subprocess.check_output(['git','ls-files','-z','reactivity','.cargo','clippy.toml'],cwd=w).decode().split('\0') if p and (w/p).is_file()}
assert not subprocess.check_output(['git','status','--porcelain'],cwd=w).strip();before=inputs();(out/'inputs.json').write_text(json.dumps(before));(out/'source.txt').write_bytes(subprocess.check_output(['git','rev-parse','HEAD'],cwd=w))
base=['cargo','+nightly-2026-10-23','-Z','checksum-freshness','--config','build.fingerprint="content"'];common=['--locked','--offline','--release','--message-format=json'];env={**os.environ,'CARGO_TARGET_DIR':str(target),'CARGO_BUILD_JOBS':'4','VK_ICD_FILENAMES':'/usr/share/vulkan/icd.d/lvp_icd.json','LP_NUM_THREADS':'4','XDG_RUNTIME_DIR':'/home/user/gpui-xdg'}
(out/'environment.json').write_text(json.dumps({k:v for k,v in env.items() if k.startswith(('CARGO_','RUST','VK_','LP_')) or k=='XDG_RUNTIME_DIR'},indent=2))
feature='gpui/x11-minimal' if mode=='minimal-library' else 'gpui/x11'
shared=['-p','gpui','-p','gpui_canvas','--features',feature]
if mode=='full-native':commands=[('build',base+['build']+common+['-p','gpui','--features','x11','--example','zgx_native_lab']),('test',base+['test']+common+shared),('port',base+['test']+common+['-p','gpui','--features','x11','--example','zgx_native_lab']),('clippy',base+['clippy']+common+shared+['--all-targets','--','-D','warnings'])]
elif mode=='minimal-library':commands=[('unit-build',base+['test']+common+shared+['--lib']),('port',base+['test']+common+['-p','gpui','--features','x11-minimal','--example','zgx_native_lab']),('clippy',base+['clippy']+common+shared+['--all-targets','--','-D','warnings'])]
elif mode=='default':commands=[('test',base+['test']+common+['-p','gpui','-p','gpui_canvas']),('clippy',base+['clippy']+common+['-p','gpui','-p','gpui_canvas','--all-targets','--','-D','warnings'])]
else:raise ValueError(mode)
try:
 for name,cmd in commands:
  minimum=shutil.disk_usage('/home/user').free;assert minimum>8*1024**3;started=time.monotonic();stopped=False
  with (out/(name+'.out')).open('w') as a,(out/(name+'.log')).open('w') as b:
   p=subprocess.Popen(cmd,cwd=w/'reactivity',env=env,stdout=a,stderr=b,start_new_session=True)
   while p.poll() is None:
    free=shutil.disk_usage('/home/user').free;minimum=min(minimum,free)
    if free<8*1024**3:os.killpg(p.pid,signal.SIGTERM);stopped=True
    time.sleep(2)
   code=p.wait()
  (out/(name+'.status.json')).write_text(json.dumps({'command':cmd,'exit':code,'minimum_free_bytes':minimum,'storage_stop':stopped,'seconds':time.monotonic()-started},indent=2))
  artifacts=[];log=(out/(name+'.log')).read_text()
  for line in (out/(name+'.out')).read_text().splitlines():
   try:o=json.loads(line)
   except ValueError:continue
   if o.get('reason')=='compiler-artifact' and o.get('executable'):
    q=Path(o['executable']);h=sha(q);dest=Path('/home/user/gpui-preserved-test-binaries')/h
    if not dest.exists():shutil.copy2(q,dest)
    assert sha(dest)==h;record={'path':str(q),'sha256':h,'preserved':str(dest),'bytes':q.stat().st_size,'executed':str(q) in log,'cargo':o};artifacts.append(record)
    if name=='build' and o['target']['name']=='zgx_native_lab':(out/'artifact.json').write_text(json.dumps(record,indent=2))
    if name in ['test','unit-build'] and o['target']['name']=='gpui' and o['profile']['test']:(out/'unit-artifact.json').write_text(json.dumps(record,indent=2))
  (out/(name+'-artifacts.json')).write_text(json.dumps(artifacts,indent=2));print(name,code,'artifacts',len(artifacts),flush=True);assert code==0
finally:
 after=inputs();changes=sorted(p for p in before.keys()|after.keys() if before.get(p)!=after.get(p));(out/'guard-after.json').write_text(json.dumps(changes));assert not changes
