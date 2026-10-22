from pathlib import Path
import os,subprocess,signal,time,json,tempfile,hashlib
root=Path('/root/gpui-zbus6-atspi');out=Path('/tmp/gpui-zbus6-evidence');out.mkdir(exist_ok=True)
messages=[json.loads(l)for l in Path('/tmp/gpui-zbus6-build.jsonl').read_text().splitlines()]
artifacts=[m for m in messages if m.get('reason')=='compiler-artifact'and m.get('target',{}).get('name')=='gpui'and m.get('profile',{}).get('test')and m.get('executable')]
assert len(artifacts)==1;binary=Path(artifacts[0]['executable']);binary_hash=hashlib.sha256(binary.read_bytes()).hexdigest()
files=['reactivity/Cargo.lock','reactivity/crates/gpui/Cargo.toml','reactivity/crates/gpui/src/native/accessibility/linux_tests.rs','reactivity/crates/gpui/src/native/accessibility/linux_tests/lifecycle.rs','reactivity/vendor/accesskit_unix/Cargo.toml','reactivity/vendor/accesskit_unix/src/adapter.rs']
def guard():return {f:hashlib.sha256((root/f).read_bytes()).hexdigest()for f in files}
before=guard();(out/'before-source.json').write_text(json.dumps(before,indent=2)+'\n')
xvfb_binary='/nix/store/iw8dx6lhrkdc5wzszjzqzl677y68y88r-xvfb-21.1.24/bin/Xvfb'
launcher='/nix/store/4g39rajyrxqn3na1kd4pykdigsr82af5-at-spi2-core-2.60.6/libexec/at-spi-bus-launcher'
display=next(n for n in range(125,150)if not Path(f'/tmp/.X11-unix/X{n}').exists()and not Path(f'/tmp/.X{n}-lock').exists())
results=[]
with tempfile.TemporaryDirectory(prefix='gpui-zbus6-native-')as task_dir:
 env=os.environ.copy();env['DISPLAY']=f':{display}';env['CARGO_TARGET_DIR']='/tmp/gpui-zbus6-atspi-target';env['CARGO_BUILD_JOBS']='2';env['XDG_DATA_DIRS']=task_dir;env['XDG_RUNTIME_DIR']=task_dir;env['GSETTINGS_BACKEND']='memory'
 with (out/'xvfb.log').open('w')as log:
  xvfb=subprocess.Popen([xvfb_binary,env['DISPLAY'],'-screen','0','1280x1024x24','-nolisten','tcp','-ac'],stdout=log,stderr=subprocess.STDOUT,start_new_session=True)
  try:
   for _ in range(200):
    assert xvfb.poll()is None,'owned Xvfb exited'
    if Path(f'/tmp/.X11-unix/X{display}').exists():break
    time.sleep(.05)
   else:raise RuntimeError('owned Xvfb readiness timeout')
   tests=[('lifecycle',['dbus-run-session','--',str(binary),'native::accessibility::linux_tests::native_atspi_late_service_owner_replacement_and_destroy','--exact','--ignored','--nocapture','--test-threads=1'],{}),('real-registry',['bash',str(root/'reactivity/tools/test_atspi.sh'),launcher],{}),('no-session',[str(binary),'native::accessibility::linux_tests::native_accessible_profile_without_session_bus_still_presents','--exact','--ignored','--nocapture','--test-threads=1'],{'DBUS_SESSION_BUS_ADDRESS':'unix:path=/tmp/gpui-no-session-bus'})]
   for name,cmd,extra in tests:
    assert guard()==before;assert hashlib.sha256(binary.read_bytes()).hexdigest()==binary_hash
    with(out/(name+'.log')).open('w')as log:
     process=subprocess.Popen(cmd,env=env|extra,cwd=root,stdout=log,stderr=subprocess.STDOUT,start_new_session=True)
     try:code=process.wait(timeout=75)
     finally:
      try:os.killpg(process.pid,signal.SIGTERM)
      except ProcessLookupError:pass
    result={'gate':name,'command':cmd,'exit':code};results.append(result);(out/'results.json').write_text(json.dumps(results,indent=2)+'\n');print(json.dumps(result),flush=True)
    assert code==0,(name,code)
    assert hashlib.sha256(binary.read_bytes()).hexdigest()==binary_hash
  finally:
   xvfb.terminate()
   try:xvfb.wait(timeout=5)
   except subprocess.TimeoutExpired:xvfb.kill();xvfb.wait()
 assert not Path(f'/tmp/.X11-unix/X{display}').exists(),'owned Xvfb socket not removed'
after=guard();assert before==after;(out/'after-source.json').write_text(json.dumps(after,indent=2)+'\n')
(out/'native-metadata.json').write_text(json.dumps({'base':subprocess.check_output(['git','-c','safe.directory='+str(root),'-C',str(root),'rev-parse','HEAD'],text=True).strip(),'binary':str(binary),'binary_sha256':binary_hash,'artifact':artifacts[0],'display':f':{display}','xvfb':xvfb_binary,'launcher':launcher,'source_before_after_identical':True,'owned_xvfb_stopped':True,'limits':'Actual X11/Xvfb/private D-Bus protocol gates, no OS screen-reader, physical display or hardware GPU assertion. Production AccessKit retains zbus5.19; test harness uses zbus6.'},indent=2)+'\n')
