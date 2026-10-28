"""Owned real X11 display, frozen Cargo artifact and ordinary native lifecycles."""
from pathlib import Path
import hashlib,json,os,shlex,shutil,subprocess,tempfile,time
ROOT=Path(__file__).resolve().parents[4];WORK=ROOT/'reactivity';CHECKS=WORK/'evidence/static-shader/checks';SOURCE='a871fc6fa924f31bf08fe2a51248930025582da1'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
snapshot=json.loads((CHECKS/'source.json').read_text())
def guard():assert {p:sha(ROOT/p) for p in snapshot['files']}==snapshot['files']
guard()
env_shell='source /tmp/gpui-native-env.sh\nexport CARGO_BUILD_JOBS=2 CARGO_TARGET_DIR=/tmp/gpui-static-shader-sol-target GPUI_SPIRV_VAL=/nix/store/z5hs3p3inrq3w8cv71jycz7l4y3ny5xk-spirv-tools-1.4.363.0/bin/spirv-val MESA_SHADER_CACHE_DISABLE=true\n'
command=['cargo','test','--offline','--locked','-p','gpui','--features','x11,gpui_gpu/offline-shader','--lib','--no-run','--message-format=json']
with (CHECKS/'x11-build.jsonl').open('w') as out,(CHECKS/'x11-build.log').open('w') as log:r=subprocess.run(['bash','-c',env_shell+'exec '+shlex.join(command)],stdout=out,stderr=log,cwd=WORK)
assert r.returncode==0;guard()
rows=[json.loads(s) for s in (CHECKS/'x11-build.jsonl').read_text().splitlines() if s.startswith('{')]
artifacts=[r for r in rows if r.get('reason')=='compiler-artifact' and r['target']['name']=='gpui' and r.get('executable')];assert len(artifacts)==1
binary=Path('/tmp/gpui-static-frozen-bins/gpui-x11');shutil.copyfile(artifacts[0]['executable'],binary);binary.chmod(0o755);before=sha(binary)
names=subprocess.check_output([str(binary),'--list'],text=True).splitlines()
xvfb=Path('/nix/store/iw8dx6lhrkdc5wzszjzqzl677y68y88r-xvfb-21.1.24/bin/Xvfb');xdotool=Path('/nix/store/qvckv6m6ycsa8f26w0f20mzk5w4v9ciq-xdotool-4.20260303.1/bin/xdotool')
assert not Path('/tmp/.X11-unix/X156').exists()
runtime=tempfile.mkdtemp(prefix='gpui-static-x11-runtime-');display=':156'
env=os.environ.copy();env['DISPLAY']=display;env['XDG_RUNTIME_DIR']=runtime
cases=[]
with (CHECKS/'xvfb.log').open('w') as log:
 process=subprocess.Popen([str(xvfb),display,'-screen','0','1280x800x24','-nolisten','tcp','-ac'],stdout=log,stderr=subprocess.STDOUT,env=env)
 try:
  ready=False
  for _ in range(50):
   if subprocess.run([str(xdotool),'getdisplaygeometry'],env=env,stdout=subprocess.DEVNULL,stderr=subprocess.DEVNULL).returncode==0:ready=True;break
   assert process.poll() is None
   time.sleep(0.1)
  assert ready
  for substring in ['automatic_target_rejects_before_renderer_and_close_unmaps_a_worker_retained_window','native_todo_port_presents_edits_pointer_actions_resize_and_inspection']:
   selected=[name.removesuffix(': test') for name in names if substring in name];assert len(selected)==1
   guard();assert sha(binary)==before
   args=['dbus-run-session','--',str(binary),'--exact',selected[0],'--ignored','--nocapture','--test-threads=1']
   shell=env_shell+'export DISPLAY='+display+' XDG_RUNTIME_DIR='+shlex.quote(runtime)+'\nexec '+shlex.join(args)
   path=CHECKS/('x11-'+substring+'.log')
   with path.open('w') as log:r=subprocess.run(['bash','-c',shell],stdout=log,stderr=subprocess.STDOUT,cwd=WORK,env=env)
   cases.append({'test':selected[0],'command':args,'exit':r.returncode,'log_sha256':sha(path)})
   assert r.returncode==0;guard();assert sha(binary)==before
 finally:
  process.terminate();process.wait(timeout=15);shutil.rmtree(runtime)
assert not Path('/tmp/.X11-unix/X156').exists() and not Path(runtime).exists()
(CHECKS/'x11-results.json').write_text(json.dumps({'source':SOURCE,'build':command,'cargo_artifact':artifacts[0]['executable'],'binary':str(binary),'sha256':before,'xvfb_sha256':sha(xvfb),'xdotool_sha256':sha(xdotool),'display':display,'cases':cases,'display_and_runtime_retired':True},indent=2)+'\n')
print(json.dumps({'source':SOURCE,'x11_tests':len(cases),'display_retired':True}))
