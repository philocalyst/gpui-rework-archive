from pathlib import Path
import os,sys,json,hashlib,subprocess,shutil,time
w=Path('/home/user/gpui-semantic-emission-lab');r=Path(__file__).parent/sys.argv[1];r.mkdir(exist_ok=False);target=Path('/home/user/gpui-semantic-emission-target')
def sha(p):
 with p.open('rb') as f:return hashlib.file_digest(f,'sha256').hexdigest()
def guard():return {n:sha(w/n) for n in subprocess.check_output(['git','ls-files','-z'],cwd=w).decode().split('\0') if n and (w/n).is_file()}
def save(n,v):(r/n).write_text(json.dumps(v,indent=2))
assert not subprocess.check_output(['git','status','--porcelain'],cwd=w).strip()
assert shutil.disk_usage(w).free>=8*1024**3
before=guard();save('inputs-before.json',before);(r/'source.txt').write_bytes(subprocess.check_output(['git','rev-parse','HEAD'],cwd=w));(r/'toolchain.txt').write_bytes(subprocess.check_output(['rustc','+nightly-2026-10-23','-vV']))
env=dict(os.environ,CARGO_TARGET_DIR=str(target),CARGO_BUILD_JOBS='4',CARGO_INCREMENTAL='0',CARGO_PROFILE_RELEASE_DEBUG='0',VK_ICD_FILENAMES='/usr/share/vulkan/icd.d/lvp_icd.json',LP_NUM_THREADS='4',XDG_RUNTIME_DIR='/home/user/gpui-xdg',GPUI_STRUCTURAL_TRACE_OUTPUT=str(r/'trace'),GPUI_SEMANTIC_EMISSION_OUTPUT=str(r/'variety'))
save('environment.json',{k:env.get(k) for k in ['CARGO_TARGET_DIR','CARGO_BUILD_JOBS','CARGO_INCREMENTAL','CARGO_PROFILE_RELEASE_DEBUG','RUSTFLAGS','VK_ICD_FILENAMES','LP_NUM_THREADS','XDG_RUNTIME_DIR','GPUI_STRUCTURAL_TRACE_OUTPUT','GPUI_SEMANTIC_EMISSION_OUTPUT']})
failures=[]
def run(name,args,allow_failure=False):
 start=time.time()
 with (r/(name+'.out')).open('wb') as out,(r/(name+'.err')).open('wb') as err:p=subprocess.run(args,cwd=w/'reactivity',env=env,stdout=out,stderr=err)
 save(name+'.status.json',dict(args=args,exit=p.returncode,elapsed_seconds=time.time()-start));print(name,p.returncode,flush=True);assert p.returncode==0 or allow_failure,name
 if p.returncode:failures.append(name)
prefix=['cargo','+nightly-2026-10-23','-Z','checksum-freshness','--config','build.fingerprint="content"']
common=['--locked','--offline','--release','-p','gpui','--no-default-features','--features','x11-minimal']
try:
 if sys.argv[1]!='first':run('clean',prefix+['clean','--release','-p','gpui'])
 run('build',prefix+['test']+common+['--lib','--no-run','--message-format=json'])
 rows=[json.loads(line) for line in (r/'build.out').read_text().splitlines()]
 artifacts=[x for x in rows if x.get('reason')=='compiler-artifact' and x.get('executable') and x['target']['name']=='gpui'];assert len(artifacts)==1
 p=Path(artifacts[0]['executable']);h=sha(p);canonical=Path('/home/user/gpui-preserved-test-binaries')/h
 if not canonical.exists():shutil.copy2(p,canonical)
 assert sha(canonical)==h;save('artifact.json',dict(preserved=str(canonical),sha256=h,bytes=p.stat().st_size,cargo_fresh=artifacts[0]['fresh']))
 shaders={};elf=canonical.read_bytes()
 for p in (target/'release/build').rglob('ui.wgsl'):
  data=p.read_bytes();offset=elf.find(data)
  if offset>=0:shaders[str(p)]=dict(sha256=sha(p),bytes=len(data),elf_offset=offset);shutil.copy2(p,r/'ui.wgsl')
 assert shaders;save('shaders.json',shaders)
 run('variety',[str(canonical),'native::semantic_emission_tests::zero_multiple_and_shared_resources','--exact','--ignored','--nocapture','--test-threads=1'],allow_failure=True)
 run('structural',[str(canonical),'native::structural_trace_tests::live_structural_boundary','--exact','--ignored','--nocapture','--test-threads=1'])
 run('clippy',prefix+['clippy']+common+['--all-targets','--','-D','warnings'])
finally:
 after=guard();save('guard.json',[n for n in before.keys()|after.keys() if before.get(n)!=after.get(n)]);save('disk.json',dict(free=shutil.disk_usage(w).free));assert before==after

save("overall.json",dict(failed_gates=failures,decision="FAILED" if failures else "PASSED"))
if failures:raise SystemExit(1)
