from pathlib import Path
import hashlib,json,os,shutil,subprocess,tempfile,time
root=Path('/tmp/gpui-surface-config-root');out=Path('/tmp/gpui-surface-config-gates');out.mkdir(exist_ok=True)
h=lambda p:hashlib.sha256(p.read_bytes()).hexdigest();git=['git','-c','safe.directory='+str(root),'-C',str(root)]
source=subprocess.check_output(git+['rev-parse','HEAD'],text=True).strip();assert source=='46dc25a1368f4df3efca14f9f1eccabda4ea4077'
files=subprocess.check_output(git+['ls-files','reactivity/crates','reactivity/vendor','reactivity/Cargo.toml','reactivity/Cargo.lock'],text=True).splitlines();before={p:h(root/p) for p in files}
rows=[json.loads(s) for s in Path('/tmp/gpui-surface-config-build.jsonl').read_text().splitlines() if s.startswith('{')];a=[r for r in rows if r.get('reason')=='compiler-artifact' and r['target']['name']=='gpui' and r.get('executable')];assert len(a)==1
binary=out/'gpui-frozen';shutil.copyfile(a[0]['executable'],binary);binary.chmod(0o555);digest=h(binary)
baseline=Path('/tmp/gpui-compact-static-main-gates/gpui-frozen');basehash=h(baseline);assert basehash=='ee75adf3acb8eefc6c0c0b067f57b0eab3f6980d15c6f21c02df786054eff2ff'
results=[]
def guard():
 assert {p:h(root/p) for p in before}==before
 assert h(binary)==digest and h(baseline)==basehash
def run(name,command,env=None):
 guard()
 with (out/(name+'.log')).open('w') as log:r=subprocess.run(command,stdout=log,stderr=subprocess.STDOUT,env=env,timeout=90,cwd=root/'reactivity')
 results.append({'case':name,'command':command,'exit':r.returncode,'log_sha256':h(out/(name+'.log'))});(out/'results.json').write_text(json.dumps(results,indent=2)+'\n');assert r.returncode==0,name;assert '1 passed; 0 failed' in (out/(name+'.log')).read_text();guard()
for name,exe in [('baseline',baseline),('candidate',binary)]:run(name+'-header',[str(exe),'--exact','native::tests::packet_gpu_header_ledger','--nocapture','--test-threads=1'])
xvfb='/nix/store/iw8dx6lhrkdc5wzszjzqzl677y68y88r-xvfb-21.1.24/bin/Xvfb';launcher='/nix/store/4g39rajyrxqn3na1kd4pykdigsr82af5-at-spi2-core-2.60.6/libexec/at-spi-bus-launcher'
display=next(n for n in range(153,180) if not Path(f'/tmp/.X11-unix/X{n}').exists() and not Path(f'/tmp/.X{n}-lock').exists())
with tempfile.TemporaryDirectory(prefix='gpui-surface-config-') as directory:
 env=os.environ|{'DISPLAY':f':{display}','XDG_RUNTIME_DIR':directory,'XDG_DATA_DIRS':directory,'GPUI_ATSPI_LAUNCHER':launcher,'MESA_SHADER_CACHE_DISABLE':'true'}
 with (out/'xvfb.log').open('w') as log:
  process=subprocess.Popen([xvfb,env['DISPLAY'],'-screen','0','1280x1024x24','-nolisten','tcp','-ac'],stdout=log,stderr=subprocess.STDOUT)
  try:
   for _ in range(200):
    assert process.poll() is None
    if Path(f'/tmp/.X11-unix/X{display}').exists():break
    time.sleep(.05)
   else:raise RuntimeError('owned display readiness')
   for name,test in [('todo','native::tests::native_todo_port_presents_edits_pointer_actions_resize_and_inspection'),('early-reject-close','native::upgrade_tests::automatic_target_rejects_before_renderer_and_close_unmaps_a_worker_retained_window'),('blank-handoff','native::upgrade_tests::automatic_blank_stays_cold_across_resize_resume_then_upgrades_after_complex_cpu_frame')]:run(name,['dbus-run-session','--',str(binary),'--exact',test,'--ignored','--nocapture','--test-threads=1'],env)
  finally:
   process.terminate()
   try:process.wait(timeout=5)
   except subprocess.TimeoutExpired:process.kill();process.wait()
assert not Path(f'/tmp/.X11-unix/X{display}').exists();guard()
(out/'metadata.json').write_text(json.dumps({'source':source,'baseline_source':'ebfdb2ad459ab8d9801c295718c83f3bab563392','source_guard':before,'artifact':a[0],'frozen':str(binary),'sha256':digest,'baseline_sha256':basehash,'rustflags':'-C symbol-mangling-version=v0 --cfg tokio_unstable','features':'desktop,x11,wayland,gpui_canvas/parallel,cephal/verify-cache,gpui_gpu/offline-shader,gpui_gpu/vulkan-tests','source_and_binaries_unchanged':True,'owned_display_stopped':True,'display':display,'limits':'Header layout and Linux native behavior only; not timing/RSS/hardware/foreign-runtime.'},indent=2)+'\n')
print(json.dumps({'source':source,'cases':len(results),'owned_display_stopped':True}))
