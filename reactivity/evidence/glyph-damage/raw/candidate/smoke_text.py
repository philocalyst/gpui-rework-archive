from pathlib import Path
import json,os,subprocess,hashlib,signal
r=Path(__file__).parent;g=r/'cost-fixture-lint-corrected';out=r/'small-text-smoke';out.mkdir(exist_ok=False)
a=next(a for a in json.loads((g/'test-artifacts.json').read_text()) if '/gpui/' in a['path']);b=a['preserved']; assert hashlib.sha256(Path(b).read_bytes()).hexdigest()==a['sha256'];(out/'artifact.json').write_text(json.dumps(a,indent=2))
for case in ['text-0-1-owner','text-0-1-source','text-25-2-source','text-1000-4-owner']:
 env={**os.environ,'DISPLAY':':94','XDG_RUNTIME_DIR':'/home/user/gpui-xdg','VK_ICD_FILENAMES':'/usr/share/vulkan/icd.d/lvp_icd.json','LP_NUM_THREADS':'4','DBUS_SESSION_BUS_ADDRESS':'unix:path=/nonexistent','GPUI_SCROLL_CASE':case,'GPUI_SCROLL_FRAMES':'4'};env.pop('GPUI_SCROLL_ALLOC',None)
 cmd=[b,'native::scroll_bench::complete_workload_cost','--ignored','--exact','--nocapture','--test-threads=1']
 with (out/(case+'.out')).open('w') as stdout,(out/(case+'.log')).open('w') as stderr:
  p=subprocess.Popen(cmd,env=env,stdout=stdout,stderr=stderr,start_new_session=True)
  try:code=p.wait(timeout=120)
  finally:
   try:os.killpg(p.pid,signal.SIGTERM)
   except ProcessLookupError:pass
   if p.poll() is None:p.wait(timeout=10)
 (out/(case+'.status.json')).write_text(json.dumps(dict(command=cmd,case=case,exit=code)));print(case,code,flush=True);assert code==0
w=Path('/home/user/gpui-glyph-damage-lab');before=json.loads((g/'inputs.json').read_text());changes=[p for p,h in before.items() if hashlib.sha256((w/p).read_bytes()).hexdigest()!=h];(out/'guard-after.json').write_text(json.dumps(changes));assert not changes
