from pathlib import Path
import os,json,subprocess,hashlib,sys,shutil,re
r=Path(__file__).parent;w=Path('/home/user/gpui-native-task-sync-lab');t=Path('/home/user/gpui-native-task-sync-target');out=r/sys.argv[1];out.mkdir(exist_ok=False)
def inputs():
 return {p:hashlib.sha256((w/p).read_bytes()).hexdigest() for p in subprocess.check_output(['git','ls-files','-z','reactivity','.cargo','clippy.toml'],cwd=w).decode().split('\0') if p and (w/p).is_file()}
assert not subprocess.check_output(['git','status','--porcelain'],cwd=w).strip();before=inputs();(out/'inputs.json').write_text(json.dumps(before));(out/'source.txt').write_bytes(subprocess.check_output(['git','rev-parse','HEAD'],cwd=w))
base=['cargo','+nightly-2026-10-23','-Z','checksum-freshness','--config','build.fingerprint="content"'];common=['--locked','--offline','--release','-p','gpui'];cmds=[('test',base+['test']+common+['--features','x11','--example','zgx_native_lab','deferred_control_tests::controls_yield_before_effects_and_keep_immediate_control_visible','--','--exact','--nocapture','--test-threads=1'])]
failed=False
try:
 for name,cmd in cmds:
  assert shutil.disk_usage('/home/user').free>8*1024**3
  with (out/(name+'.out')).open('w') as a,(out/(name+'.log')).open('w') as b:p=subprocess.run(cmd,cwd=w/'reactivity',env={**os.environ,'CARGO_TARGET_DIR':str(t),'CARGO_BUILD_JOBS':'6','DISPLAY':':94','XDG_RUNTIME_DIR':'/home/user/gpui-xdg','VK_ICD_FILENAMES':'/usr/share/vulkan/icd.d/lvp_icd.json','LP_NUM_THREADS':'4'},stdout=a,stderr=b)
  (out/(name+'.status.json')).write_text(json.dumps(dict(command=cmd,exit=p.returncode)));print(name,p.returncode,flush=True)
  artifacts=[]
  paths=re.findall(r'Running [^\n]* \(([^)]+)\)',(out/(name+'.log')).read_text())
  if 'build' in name and not p.returncode:
   alias=t/'release/examples/zgx_native_lab';h=hashlib.sha256(alias.read_bytes()).hexdigest();matches=[q for q in (t/'release/build/gpui').glob('*/out/zgx_native_lab') if hashlib.sha256(q.read_bytes()).hexdigest()==h];assert len(matches)==1;paths.append(str(matches[0]))
  for path in paths:
   q=Path(path);h=hashlib.sha256(q.read_bytes()).hexdigest();saved=Path('/home/user/gpui-preserved-test-binaries')/h
   if not saved.exists():shutil.copy2(q,saved)
   assert hashlib.sha256(saved.read_bytes()).hexdigest()==h
   record=dict(path=str(q),sha256=h,preserved=str(saved),bytes=q.stat().st_size)
   if 'build' in name:record['fingerprint']=json.loads((q.parent.parent/'fingerprint/example-zgx_native_lab.json').read_text())
   artifacts.append(record)
  (out/(name+'-artifacts.json')).write_text(json.dumps(artifacts,indent=2))
  if p.returncode:failed=True;break
finally:
 after=inputs();changes=[p for p in set(before)|set(after) if before.get(p)!=after.get(p)];(out/'guard-after.json').write_text(json.dumps(changes));assert not changes
assert not failed
