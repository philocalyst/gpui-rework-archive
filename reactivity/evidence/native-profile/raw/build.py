from pathlib import Path
import os,sys,json,hashlib,subprocess,shutil,time,signal
root=Path(__file__).parent
name=sys.argv[1];gpui=name!='zgx';w=Path('/home/user/'+('gpui-native-profile-'+name+'-lab' if gpui else 'zgx-native-profile-lab'));t=Path('/home/user/'+('gpui-native-profile-'+name+'-target' if gpui else 'zgx-native-profile-target'));out=root/('build-'+name);out.mkdir(exist_ok=False)
def sha(p):return hashlib.file_digest(p.open('rb'),'sha256').hexdigest()
def inputs():
 return {p:sha(w/p) for p in subprocess.check_output(['git','ls-files','-z'],cwd=w).decode().split('\0') if p and (w/p).is_file()}
assert not subprocess.check_output(['git','status','--porcelain'],cwd=w).strip()
assert shutil.disk_usage('/home/user').free>=12*1024**3
before=inputs();(out/'inputs.json').write_text(json.dumps(before));(out/'source.txt').write_bytes(subprocess.check_output(['git','rev-parse','HEAD'],cwd=w))
profile={'CARGO_PROFILE_RELEASE_OPT_LEVEL':'3','CARGO_PROFILE_RELEASE_LTO':'fat','CARGO_PROFILE_RELEASE_CODEGEN_UNITS':'1','CARGO_PROFILE_RELEASE_DEBUG':'0','CARGO_PROFILE_RELEASE_STRIP':'none','CARGO_PROFILE_RELEASE_PANIC':'unwind','CARGO_PROFILE_RELEASE_INCREMENTAL':'false','RUSTFLAGS':'-C symbol-mangling-version=v0 --cfg tokio_unstable'}
env={**os.environ,**profile,'CARGO_TARGET_DIR':str(t),'CARGO_BUILD_JOBS':'4','DISPLAY':':94','XDG_RUNTIME_DIR':'/home/user/gpui-xdg','VK_ICD_FILENAMES':'/usr/share/vulkan/icd.d/lvp_icd.json','LP_NUM_THREADS':'4'}
assert not env.get('CARGO_ENCODED_RUSTFLAGS')
(out/'environment.json').write_text(json.dumps({k:env[k] for k in profile|{'CARGO_TARGET_DIR':0,'CARGO_BUILD_JOBS':0}},indent=2))
(out/'toolchain.txt').write_bytes(subprocess.check_output(['rustc','+nightly-2026-10-23','-vV']))
base=['cargo','+nightly-2026-10-23','-Z','checksum-freshness','--config','build.fingerprint="content"'];common=['--locked','--offline','--release','-p','gpui' if gpui else 'zgx-desktop','--example','zgx_native_lab' if gpui else 'component_workload','--message-format=json']+(['--features','x11'] if gpui else [])
try:
 for stage in ['build','test']:
  cmd=base+[stage]+common+(['--','--nocapture','--test-threads=1'] if stage=='test' else [])
  minimum=shutil.disk_usage('/home/user').free;started=time.monotonic();killed=False
  with (out/(stage+'.out')).open('w') as stdout,(out/(stage+'.log')).open('w') as stderr:
   p=subprocess.Popen(cmd,cwd=w/'reactivity' if gpui else w,env=env,stdout=stdout,stderr=stderr,start_new_session=True)
   while p.poll() is None:
    free=shutil.disk_usage('/home/user').free;minimum=min(minimum,free)
    if free<8*1024**3:os.killpg(p.pid,signal.SIGTERM);killed=True
    time.sleep(2)
   status=p.wait()
  (out/(stage+'.status.json')).write_text(json.dumps({'command':cmd,'exit':status,'seconds':time.monotonic()-started,'minimum_free_bytes':minimum,'storage_stop':killed},indent=2))
  artifacts=[]
  for line in (out/(stage+'.out')).read_text().splitlines():
   try:o=json.loads(line)
   except ValueError:continue
   if o.get('reason')=='compiler-artifact' and o.get('executable'):
    q=Path(o['executable']);h=sha(q);dest=Path('/home/user/gpui-preserved-test-binaries')/h
    if not dest.exists():shutil.copy2(q,dest)
    assert sha(dest)==h
    fingerprints=[]
    for fp in t.glob('release/build/*/*/fingerprint/*.json'):
     if fp.name.endswith(('zgx_native_lab.json','component_workload.json')):fingerprints.append({'path':str(fp),'content':json.loads(fp.read_text())})
    artifacts.append({'path':str(q),'sha256':h,'preserved':str(dest),'bytes':q.stat().st_size,'cargo':o,'fingerprints':fingerprints})
  (out/(stage+'-artifacts.json')).write_text(json.dumps(artifacts,indent=2));print(name,stage,status,'ELFs',len(artifacts),flush=True)
  assert status==0 and artifacts
finally:
 after=inputs();changed=sorted(p for p in before.keys()|after.keys() if before.get(p)!=after.get(p));(out/'guard-after.json').write_text(json.dumps(changed));assert not changed
# No consumer is running; keep executable and generated code, remove regenerable archives.
plan=[{'path':str(p),'bytes':p.stat().st_size,'sha256':sha(p)} for p in t.rglob('*') if p.is_file() and p.suffix in ('.rlib','.rmeta')]
(out/'cache-cleanup-plan.json').write_text(json.dumps(plan))
for item in plan:
 p=Path(item['path']);assert sha(p)==item['sha256'];p.unlink()
(out/'cache-cleanup.json').write_text(json.dumps({'files':len(plan),'free_bytes':shutil.disk_usage('/home/user').free}))
print(name,'qualified and preserved',flush=True)
