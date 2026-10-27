from pathlib import Path
import re,hashlib,json,subprocess,os,signal
root=Path(__file__).resolve().parent;out=root/'native-scroll-exact-geometry';out.mkdir(exist_ok=False);wt=Path('/home/user/gpui-gpu-scroll-copy-lab');gate=root/'native-exact-geometry';log=(gate/'test.log').read_text();binary=Path(re.search(r'Running unittests src/lib.rs \(([^)]*/gpui/[^)]+)\)',log).group(1));digest=hashlib.sha256(binary.read_bytes()).hexdigest()
env={**os.environ,'DISPLAY':':94','XDG_RUNTIME_DIR':'/home/user/gpui-xdg','VK_ICD_FILENAMES':'/usr/share/vulkan/icd.d/lvp_icd.json','LP_NUM_THREADS':'4','DBUS_SESSION_BUS_ADDRESS':'unix:path=/nonexistent'}
(out/'artifact.json').write_text(json.dumps({'path':str(binary),'sha256':digest,'bytes':binary.stat().st_size},indent=2))
def run(name,cmd,timeout):
 with (out/(name+'.out')).open('w') as a,(out/(name+'.log')).open('w') as b:
  p=subprocess.Popen(cmd,env=env,stdout=a,stderr=b,start_new_session=True)
  try:code=p.wait(timeout=timeout)
  finally:
   try:os.killpg(p.pid,signal.SIGTERM)
   except ProcessLookupError:pass
   if p.poll() is None:p.wait(timeout=10)
 (out/(name+'.status.json')).write_text(json.dumps({'command':cmd,'exit':code}));assert code==0 and '1 passed; 0 failed' in (out/(name+'.out')).read_text();print(name,'pass',flush=True)
for i in [5]:
 old=json.loads(Path(f'/home/user/gpui-source-batch-evidence/composed/native-{i}.status.json').read_text());run('native-'+str(i),[str(binary)]+old['command'][1:],180)
before=json.loads((gate/'inputs.json').read_text());changes=[p for p,h in before.items() if not (wt/p).is_file() or hashlib.sha256((wt/p).read_bytes()).hexdigest()!=h];(out/'guard-after.json').write_text(json.dumps(changes));assert not changes and hashlib.sha256(binary.read_bytes()).hexdigest()==digest
