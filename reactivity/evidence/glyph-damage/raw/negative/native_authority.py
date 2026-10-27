from pathlib import Path
import os,sys,json,hashlib,subprocess,shutil,re,signal
root=Path(__file__).parent;w=Path('/home/user/gpui-glyph-damage-negative-lab');t=Path('/home/user/gpui-glyph-damage-negative-target');out=root/sys.argv[1];out.mkdir(exist_ok=False)
assert not subprocess.check_output(['git','status','--porcelain'],cwd=w).strip()
def inputs():
 return {p:hashlib.sha256((w/p).read_bytes()).hexdigest() for p in subprocess.check_output(['git','ls-files','-z','reactivity','.cargo','clippy.toml'],cwd=w).decode().split('\0') if p and (w/p).is_file()}
before=inputs();(out/'inputs.json').write_text(json.dumps(before));(out/'source.txt').write_bytes(subprocess.check_output(['git','rev-parse','HEAD'],cwd=w))
cmd=['cargo','+nightly-2026-10-23','-Z','checksum-freshness','--config','build.fingerprint="content"','test','--locked','--offline','--release','-p','gpui','--features','x11','--lib','--no-run']
assert shutil.disk_usage('/home/user').free>8*1024**3
try:
 with (out/'unit-build.out').open('w') as a,(out/'unit-build.log').open('w') as b:p=subprocess.run(cmd,cwd=w/'reactivity',env={**os.environ,'CARGO_TARGET_DIR':str(t),'CARGO_BUILD_JOBS':'2'},stdout=a,stderr=b)
 (out/'unit-build.status.json').write_text(json.dumps({'command':cmd,'exit':p.returncode}));print('build',p.returncode,flush=True)
 assert p.returncode==0
 paths=re.findall(r'Executable unittests src/lib.rs \(([^)]*/gpui/[^)]+)\)',(out/'unit-build.log').read_text());assert len(paths)==1
 b=Path(paths[0]);h=hashlib.sha256(b.read_bytes()).hexdigest();d=Path('/home/user/gpui-preserved-test-binaries')/h
 if not d.exists():shutil.copy2(b,d)
 assert hashlib.sha256(d.read_bytes()).hexdigest()==h
 (out/'artifact.json').write_text(json.dumps(dict(path=str(b),sha256=h,preserved=str(d),bytes=b.stat().st_size),indent=2))
 env={**os.environ,'DISPLAY':':94','XDG_RUNTIME_DIR':'/home/user/gpui-xdg','VK_ICD_FILENAMES':'/usr/share/vulkan/icd.d/lvp_icd.json','LP_NUM_THREADS':'4','DBUS_SESSION_BUS_ADDRESS':'unix:path=/nonexistent'}
 cmd=[str(d),'native::tests::native_todo_port_presents_edits_pointer_actions_resize_and_inspection','--ignored','--exact','--nocapture','--test-threads=1']
 with (out/'test.out').open('w') as a,(out/'test.log').open('w') as b:
  p=subprocess.Popen(cmd,env=env,stdout=a,stderr=b,start_new_session=True)
  try:code=p.wait(timeout=180)
  finally:
   try:os.killpg(p.pid,signal.SIGTERM)
   except ProcessLookupError:pass
   if p.poll() is None:p.wait(timeout=10)
 (out/'test.status.json').write_text(json.dumps({'command':cmd,'exit':code}));print('native',code,flush=True)
finally:
 after=inputs();changes=[p for p in set(before)|set(after) if before.get(p)!=after.get(p)];(out/'guard-after.json').write_text(json.dumps(changes));assert not changes
