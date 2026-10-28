from pathlib import Path
import os,subprocess,json,hashlib,shutil,sys,time
r=Path(__file__).parent;w=Path('/home/user/gpui-display-spans-lab');target=Path('/home/user/gpui-display-spans-target');attempt=r/sys.argv[1];attempt.mkdir(exist_ok=False)
def sha(p):
 with p.open('rb') as f:return hashlib.file_digest(f,'sha256').hexdigest()
def inputs():
 names=subprocess.check_output(['git','ls-files','-z'],cwd=w).decode().split('\0')
 return {p:sha(w/p) for p in names if p and (w/p).is_file()}
def write(name,data): (attempt/name).write_text(json.dumps(data,indent=2))
env=os.environ.copy();env.update(CARGO_TARGET_DIR=str(target),CARGO_BUILD_JOBS='4',CARGO_INCREMENTAL='0',CARGO_PROFILE_RELEASE_DEBUG='0',VK_ICD_FILENAMES='/usr/share/vulkan/icd.d/lvp_icd.json',LP_NUM_THREADS='4',XDG_RUNTIME_DIR='/home/user/gpui-xdg')
write('environment.json',{k:env.get(k) for k in ['CARGO_TARGET_DIR','CARGO_BUILD_JOBS','CARGO_INCREMENTAL','CARGO_PROFILE_RELEASE_DEBUG','RUSTFLAGS','VK_ICD_FILENAMES','LP_NUM_THREADS','XDG_RUNTIME_DIR']})
assert not subprocess.check_output(['git','status','--porcelain'],cwd=w).strip()
source=subprocess.check_output(['git','rev-parse','HEAD'],cwd=w).decode().strip();(attempt/'source.txt').write_text(source+'\n');before=inputs();write('inputs-before.json',before)
(attempt/'toolchain.txt').write_bytes(subprocess.check_output(['rustc','+nightly-2026-10-23','-vV']))
write('disk-before.json',dict(free=shutil.disk_usage(w).free))
def run(stage,args):
 start=time.time()
 with (attempt/(stage+'.out')).open('wb') as out,(attempt/(stage+'.err')).open('wb') as err:p=subprocess.run(args,cwd=w/'reactivity',env=env,stdout=out,stderr=err)
 write(stage+'.status.json',dict(args=args,exit=p.returncode,elapsed_seconds=time.time()-start));print(stage,p.returncode,flush=True)
 if p.returncode:raise RuntimeError(stage)
try:
 run('build',['cargo','+nightly-2026-10-23','-Z','checksum-freshness','--config','build.fingerprint="content"','build','--locked','--offline','--release','-p','gpui_display_span_lab','--bins','--message-format=json'])
 artifacts={}
 for name in ['consume','public_trace']:
  p=target/'release'/name;h=sha(p);saved=Path('/home/user/gpui-preserved-test-binaries')/h
  if not saved.exists():shutil.copy2(p,saved)
  assert sha(saved)==h;artifacts[name]=dict(path=str(p),sha256=h,bytes=p.stat().st_size,preserved=str(saved))
 write('artifacts.json',artifacts)
 shader=w/'reactivity/crates/display-span-lab/src/consume.wgsl';data=shader.read_bytes();elf=Path(artifacts['consume']['preserved']).read_bytes();at=elf.find(data);assert at>=0;write('shader.json',dict(bytes=len(data),sha256=sha(shader),elf_offset=at))
 run('public',[artifacts['public_trace']['preserved'],str(attempt/'public')])
 run('model',['python3',str(w/'reactivity/crates/display-span-lab/model/experiment.py'),str(attempt/'model'),str(attempt/'public/public-trace.json')])
 run('gpu',[artifacts['consume']['preserved'],str(attempt/'model/jobs.json')])
 run('clippy',['cargo','+nightly-2026-10-23','-Z','checksum-freshness','--config','build.fingerprint="content"','clippy','--locked','--offline','--release','-p','gpui_display_span_lab','--all-targets','--','-D','warnings'])
finally:
 after=inputs();write('inputs-after.json',after);write('guard.json',[p for p in before.keys()|after.keys() if before.get(p)!=after.get(p)]);write('disk-after.json',dict(free=shutil.disk_usage(w).free));assert before==after
