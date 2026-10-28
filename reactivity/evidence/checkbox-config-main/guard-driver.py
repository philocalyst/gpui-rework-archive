from pathlib import Path
import hashlib,json,os,shutil,signal,subprocess,tempfile,time
root=Path('/root/gpui-ce3');cwd=root/'reactivity';out=Path('/tmp/gpui-checkbox-config-main-gates');out.mkdir(exist_ok=True)
h=lambda p:hashlib.sha256(p.read_bytes()).hexdigest();git=['git','-c',f'safe.directory={root}','-C',str(root)]
source=subprocess.check_output(git+['rev-parse','HEAD'],text=True).strip()
files=subprocess.check_output(git+['ls-files',*[f'reactivity/crates/{n}' for n in ('core','state','host','canvas','gpu','gpui')],'reactivity/Cargo.toml','reactivity/Cargo.lock','reactivity/.cargo','reactivity/vendor','reactivity/ports/hummingbird','reactivity/tools/test_atspi.sh'],text=True).splitlines()
def guard():return {n:h(root/n) for n in files}
before=guard();(out/'source-guard.json').write_text(json.dumps(before,indent=2)+'\n');results=[];executables={}
metadata={'source':source,'features':'desktop,x11,wayland,gpui_canvas/parallel,cephal/verify-cache,gpui_gpu/offline-shader,gpui_gpu/vulkan-tests','source_unchanged':None,'owned_display_stopped':None,'executables':executables,'limits':'Combined behavior and allocator/geometry accounting, not timing, RSS, native HDR, hardware conformance or foreign-OS runtime.'}
(out/'metadata.json').write_text(json.dumps(metadata,indent=2)+'\n')
def check():
 assert guard()==before
 assert all(h(Path(p))==v for p,v in executables.items())
def run(name,command,timeout=600,env=None):
 check()
 with (out/f'{name}.log').open('w') as log:
  p=subprocess.Popen(command,cwd=cwd,env=env,stdout=log,stderr=subprocess.STDOUT,start_new_session=True)
  try:code=p.wait(timeout=timeout)
  finally:
   try:os.killpg(p.pid,signal.SIGTERM)
   except ProcessLookupError:pass
 row={'case':name,'command':command,'exit':code,'log_sha256':h(out/f'{name}.log')};results.append(row);(out/'results.json').write_text(json.dumps(results,indent=2)+'\n');print(json.dumps(row),flush=True);assert code==0,row;check()
features=metadata['features']
run('gpui-full',['cargo','test','--offline','--locked','-p','gpui','--features',features,'--message-format=json'],1200)
artifacts=[]
for line in (out/'gpui-full.log').read_text().splitlines():
 try:r=json.loads(line)
 except ValueError:continue
 if r.get('reason')=='compiler-artifact' and r.get('executable'):artifacts.append(r)
a=next(r for r in artifacts if r['target']['kind']==['lib'] and r['target']['name']=='gpui' and r['profile']['test']);binary=out/'gpui-frozen';shutil.copyfile(a['executable'],binary);binary.chmod(0o555);executables[str(binary)]=h(binary);(out/'gpui-artifact.json').write_text(json.dumps(a,indent=2)+'\n')
run('gpui-strict',['cargo','clippy','--offline','--locked','-p','gpui','--features',features,'--all-targets','--','-D','warnings'],900)
run('format',['cargo','fmt','--package','gpui','--package','gpui_canvas','--package','gpui_gpu','--package','gpui_reactivity_core','--','--check'])
for name,target in [('apple','aarch64-apple-darwin'),('msvc','x86_64-pc-windows-msvc')]:
 run(name,['cargo','check','--offline','--locked','-p','gpui','--all-targets','--features','desktop,gpui_canvas/parallel,gpui_gpu/offline-shader','--target',target,'-Zbuild-std=std,panic_abort','--jobs','2'],1200,os.environ|{'RUSTC_BOOTSTRAP':'1'})
run('hummingbird-build',['cargo','build','--offline','--locked','--manifest-path','ports/hummingbird/Cargo.toml','--features','native','--bin','hummingbird-gpui-port','--message-format=json'],900)
artifacts=[]
for line in (out/'hummingbird-build.log').read_text().splitlines():
 try:r=json.loads(line)
 except ValueError:continue
 if r.get('reason')=='compiler-artifact' and r.get('executable'):artifacts.append(r)
a=next(r for r in artifacts if r['target']['kind']==['bin'] and r['target']['name']=='hummingbird-gpui-port');hb=out/'hummingbird-frozen';shutil.copyfile(a['executable'],hb);hb.chmod(0o555);executables[str(hb)]=h(hb);(out/'hummingbird-artifact.json').write_text(json.dumps(a,indent=2)+'\n')
run('hummingbird-tests',['cargo','test','--offline','--locked','--manifest-path','ports/hummingbird/Cargo.toml','--features','native'],900)
run('hummingbird-headless',[str(hb),'--headless'])
run('catalog-client',['cargo','test','--offline','--locked','--manifest-path','evidence/typed-catalog/client-fixture/Cargo.toml'],900)
launcher='/nix/store/4g39rajyrxqn3na1kd4pykdigsr82af5-at-spi2-core-2.60.6/libexec/at-spi-bus-launcher';xvfb='/nix/store/iw8dx6lhrkdc5wzszjzqzl677y68y88r-xvfb-21.1.24/bin/Xvfb';python='/nix/store/9r02ykx9y35lf4gk6gc30gnag1y8ncp7-python3-3.13.15/bin/python3'
for policy in ('gpu',):
 display=next(n for n in range(152,180) if not Path(f'/tmp/.X11-unix/X{n}').exists() and not Path(f'/tmp/.X{n}-lock').exists())
 run(f'hummingbird-{policy}',['dbus-run-session','--',python,str(cwd/'ports/hummingbird/native-transcript.py'),str(hb),'--xvfb',xvfb,'--xdotool','/nix/store/qvckv6m6ycsa8f26w0f20mzk5w4v9ciq-xdotool-4.20260303.1/bin/xdotool','--atspi-launcher',launcher,'--output',str(out/f'hummingbird-{policy}.json'),'--display',f':{display}','--renderer',policy],90)
 assert not Path(f'/tmp/.X11-unix/X{display}').exists()
display=next(n for n in range(181,199) if not Path(f'/tmp/.X11-unix/X{n}').exists() and not Path(f'/tmp/.X{n}-lock').exists())
with tempfile.TemporaryDirectory(prefix='gpui-checkbox-config-main-') as temporary:
 env=os.environ|{'DISPLAY':f':{display}','XDG_RUNTIME_DIR':temporary,'XDG_DATA_DIRS':temporary,'GSETTINGS_BACKEND':'memory','GPUI_ATSPI_LAUNCHER':launcher}
 with (out/'xvfb.log').open('w') as log:
  p=subprocess.Popen([xvfb,env['DISPLAY'],'-screen','0','1280x1024x24','-nolisten','tcp','-ac'],stdout=log,stderr=subprocess.STDOUT)
  try:
   for _ in range(200):
    assert p.poll() is None
    if Path(f'/tmp/.X11-unix/X{display}').exists():break
    time.sleep(.05)
   else:raise RuntimeError('owned Xvfb readiness')
   run('actual-registry',['bash',str(cwd/'tools/test_atspi.sh'),launcher,str(binary)],90,env)
   for name,test in [('checkbox-native','native::accessibility::linux_tests::checkbox::native_atspi_checkbox_action_state_and_events'),('late-service','native::accessibility::linux_tests::native_atspi_late_service_owner_replacement_and_destroy'),('future-wake','native::question_tests::native_future_cancellation_and_result_wake_without_unrelated_input'),('blank-handoff','native::upgrade_tests::automatic_blank_stays_cold_across_resize_resume_then_upgrades_after_complex_cpu_frame')]:
    run(name,['dbus-run-session','--',str(binary),test,'--ignored','--exact','--nocapture','--test-threads=1'],90,env)
    assert '1 passed; 0 failed' in (out/f'{name}.log').read_text()
  finally:
   p.terminate()
   try:p.wait(timeout=5)
   except subprocess.TimeoutExpired:p.kill();p.wait()
assert not Path(f'/tmp/.X11-unix/X{display}').exists();check();metadata.update(source_unchanged=True,owned_display_stopped=True,display=f':{display}');(out/'metadata.json').write_text(json.dumps(metadata,indent=2)+'\n')
