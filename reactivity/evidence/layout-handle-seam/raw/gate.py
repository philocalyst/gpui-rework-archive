from pathlib import Path
import os,subprocess,json,hashlib,shutil,time
w=Path('/home/user/gpui-layout-handle-seam-lab');r=Path(__file__).parent/'first';r.mkdir(exist_ok=False);target=Path('/home/user/gpui-layout-handle-seam-target')
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def save(n,v):(r/n).write_text(json.dumps(v,indent=2))
def guard():return {n:sha(w/n) for n in subprocess.check_output(['git','ls-files','-z'],cwd=w).decode().split('\0') if n and (w/n).is_file()}
assert not subprocess.check_output(['git','status','--porcelain'],cwd=w).strip();assert shutil.disk_usage(w).free>=2*1024**3
before=guard();save('inputs-before.json',before);save('driver.json',dict(path=__file__,sha256=sha(Path(__file__))));(r/'source.txt').write_bytes(subprocess.check_output(['git','rev-parse','HEAD'],cwd=w));(r/'toolchain.txt').write_bytes(subprocess.check_output(['rustc','+nightly-2026-10-23','-vV']))
env=dict(os.environ,CARGO_TARGET_DIR=str(target),CARGO_BUILD_JOBS='4',CARGO_INCREMENTAL='0',CARGO_PROFILE_RELEASE_DEBUG='0',GPUI_LAYOUT_HANDLE_OUTPUT=str(r/'trace'));save('environment.json',{k:env.get(k) for k in ['CARGO_TARGET_DIR','CARGO_BUILD_JOBS','CARGO_INCREMENTAL','CARGO_PROFILE_RELEASE_DEBUG','RUSTFLAGS']})
def run(name,args):
 start=time.time()
 with (r/(name+'.out')).open('wb') as out,(r/(name+'.err')).open('wb') as err:p=subprocess.run(args,cwd=w/'reactivity',env=env,stdout=out,stderr=err)
 save(name+'.status.json',dict(args=args,exit=p.returncode,elapsed_seconds=time.time()-start));print(name,p.returncode,flush=True);assert p.returncode==0,name
prefix=['cargo','+nightly-2026-10-23','-Z','checksum-freshness','--config','build.fingerprint="content"'];common=['--locked','--offline','--release','-p','gpui','--no-default-features','--features','x11-minimal']
try:
 run('build',prefix+['test']+common+['--lib','--no-run','--message-format=json'])
 rows=[json.loads(s) for s in (r/'build.out').read_text().splitlines()];a=[x for x in rows if x.get('reason')=='compiler-artifact' and x.get('executable') and x['target']['name']=='gpui'];assert len(a)==1 and not a[0]['fresh']
 p=Path(a[0]['executable']);h=sha(p);canonical=Path('/home/user/gpui-preserved-test-binaries')/h
 if not canonical.exists():shutil.copy2(p,canonical)
 assert sha(canonical)==h;save('artifact.json',dict(preserved=str(canonical),sha256=h,bytes=p.stat().st_size,cargo_fresh=a[0]['fresh']))
 shaders={};elf=canonical.read_bytes()
 for p in (target/'release/build').rglob('ui.wgsl'):
  data=p.read_bytes();offset=elf.find(data)
  if offset>=0:shaders[str(p)]=dict(sha256=sha(p),bytes=len(data),elf_offset=offset);shutil.copy2(p,r/'ui.wgsl')
 assert shaders;save('shaders.json',shaders)
 parent=Path('/home/user/gpui-address-publication-evidence/accounted/ui.wgsl');assert (r/'ui.wgsl').read_bytes()==parent.read_bytes()
 run('trace',[str(canonical),'native::layout_handle_tests::live_layout_handles','--exact','--ignored','--nocapture','--test-threads=1'])
 run('clippy',prefix+['clippy']+common+['--all-targets','--','-D','warnings'])
finally:
 after=guard();save('guard.json',[n for n in before.keys()|after.keys() if before.get(n)!=after.get(n)]);save('disk.json',dict(free=shutil.disk_usage(w).free));assert before==after
save('overall.json',dict(decision='PASSED; diagnostic layout trace only'))
