from pathlib import Path
import os,sys,json,hashlib,subprocess,shutil,time
w=Path('/home/user/gpui-display-hot-lab');r=Path(__file__).parent/sys.argv[1];r.mkdir(exist_ok=False);target=Path('/home/user/gpui-display-hot-target')
def sha(p):
 with p.open('rb') as f:return hashlib.file_digest(f,'sha256').hexdigest()
def guard():return {n:sha(w/n) for n in subprocess.check_output(['git','ls-files','-z'],cwd=w).decode().split('\0') if n and (w/n).is_file()}
def save(name,data):(r/name).write_text(json.dumps(data,indent=2))
assert not subprocess.check_output(['git','status','--porcelain'],cwd=w).strip()
assert shutil.disk_usage(w).free>=8*1024**3
before=guard();save('inputs-before.json',before);(r/'source.txt').write_bytes(subprocess.check_output(['git','rev-parse','HEAD'],cwd=w));(r/'toolchain.txt').write_bytes(subprocess.check_output(['rustc','+nightly-2026-10-23','-vV']))
font=Path('/home/user/zgx-native-profile-lab/comparisons/fonts/DejaVuSans.ttf');font_sha=sha(font);save('font.json',dict(path=str(font),bytes=font.stat().st_size,sha256=font_sha))
env=dict(os.environ,CARGO_TARGET_DIR=str(target),CARGO_BUILD_JOBS='4',CARGO_INCREMENTAL='0',CARGO_PROFILE_RELEASE_DEBUG='0',VK_ICD_FILENAMES='/usr/share/vulkan/icd.d/lvp_icd.json',LP_NUM_THREADS='4',XDG_RUNTIME_DIR='/home/user/gpui-xdg',PYTHONDONTWRITEBYTECODE='1')
save('environment.json',{k:env.get(k) for k in ['CARGO_TARGET_DIR','CARGO_BUILD_JOBS','CARGO_INCREMENTAL','CARGO_PROFILE_RELEASE_DEBUG','RUSTFLAGS','VK_ICD_FILENAMES','LP_NUM_THREADS','XDG_RUNTIME_DIR','PYTHONDONTWRITEBYTECODE']})
def run(name,args,expected=0):
 start=time.time()
 with (r/(name+'.out')).open('wb') as out,(r/(name+'.err')).open('wb') as err:p=subprocess.run(args,cwd=w/'reactivity',env=env,stdout=out,stderr=err)
 save(name+'.status.json',dict(args=args,exit=p.returncode,expected=expected,elapsed_seconds=time.time()-start));print(name,p.returncode,flush=True)
 assert p.returncode==expected,name
try:
 run('hot-checks',['python3',str(w/'reactivity/crates/display-span-lab/model/hot_checks.py'),str(r/'checks')])
 run('build',['cargo','+nightly-2026-10-23','-Z','checksum-freshness','--config','build.fingerprint="content"','build','--locked','--offline','--release','-p','gpui_display_span_lab','--bin','hot_gpu','--message-format=json'])
 artifacts={}
 for name in ['hot_gpu']:
  p=target/'release'/name;h=sha(p);canonical=Path('/home/user/gpui-preserved-test-binaries')/h
  if not canonical.exists():shutil.copy2(p,canonical)
  assert sha(canonical)==h;artifacts[name]=dict(preserved=str(canonical),sha256=h,bytes=p.stat().st_size)
 save('artifacts.json',artifacts)
 shader=w/'reactivity/crates/display-span-lab/src/hot.wgsl';s=shader.read_bytes();elf=Path(artifacts['hot_gpu']['preserved']).read_bytes();at=elf.find(s);assert at>=0;save('shader.json',dict(sha256=sha(shader),bytes=len(s),elf_offset=at))
 baseline=Path('/home/user/gpui-display-radix-lab/reactivity/evidence/display-radix')
 for name,h in json.loads((baseline/'MANIFEST.json').read_text()).items():assert sha(baseline/name)==h
 capture=baseline/'raw/combined-set-error'
 shutil.copytree(capture/'public',r/'public')
 save('baseline.json',dict(seal='bb21d11455b6a03d134f99377c5a16b983fac27f',manifest_sha=sha(baseline/'MANIFEST.json'),scope='unchanged actual public source/full-render oracle capture reused'))
 run('jobs',['python3',str(w/'reactivity/crates/display-span-lab/model/hot_jobs.py'),str(r/'public'),str(r/'jobs')])
 for case in json.loads((r/'jobs/summary.json').read_text()):
  name=case['name'];run('gpu-'+name,[artifacts['hot_gpu']['preserved'],str(r/'jobs'/name/'jobs.json')],101 if case['mutant'] else 0)
 for name in ['point-1024-overlap-compressed-m0','resource-overlap-compressed-m0','geometry-m0','structural-97']:
  control=r/('control-'+name);control.mkdir()
  for p in (capture/'jobs'/name).iterdir():
   if p.is_file():shutil.copy2(p,control/p.name)
  run('gpu-control-'+name,[artifacts['hot_gpu']['preserved'],str(control/'jobs.json')])
 run('clippy',['cargo','+nightly-2026-10-23','-Z','checksum-freshness','--config','build.fingerprint="content"','clippy','--locked','--offline','--release','-p','gpui_display_span_lab','--all-targets','--','-D','warnings'])
finally:
 after=guard();save('guard.json',[n for n in before.keys()|after.keys() if before.get(n)!=after.get(n)]);save('disk.json',dict(free=shutil.disk_usage(w).free));assert before==after;assert sha(font)==font_sha
