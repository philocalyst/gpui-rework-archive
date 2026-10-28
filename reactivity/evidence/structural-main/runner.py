from pathlib import Path
import hashlib,json,os,shutil,signal,subprocess,tempfile,time
root=Path('/root/gpui-ce3');cwd=root/'reactivity';out=Path('/tmp/gpui-structural-main-gates-v2');out.mkdir(exist_ok=False)
h=lambda p:hashlib.sha256(p.read_bytes()).hexdigest();git=['git','-c',f'safe.directory={root}','-C',str(root)]
source=subprocess.check_output(git+['rev-parse','HEAD'],text=True).strip()
files=subprocess.check_output(git+['ls-files',*[f'reactivity/crates/{n}' for n in ('core','state','host','canvas','gpu','gpui')],'.cargo/config.toml','reactivity/Cargo.toml','reactivity/Cargo.lock','reactivity/.cargo','reactivity/vendor','reactivity/ports/hummingbird','reactivity/tools/test_atspi.sh'],text=True).splitlines()
def guard():return {n:h(root/n) for n in files}
before=guard();(out/'source-guard.json').write_text(json.dumps(before,indent=2)+'\n');results=[];executables={}
metadata={'source':source,'features':'desktop,x11,wayland,gpui_canvas/parallel,cephal/verify-cache,gpui_gpu/offline-shader,gpui_gpu/vulkan-tests','spirv_val':os.environ['GPUI_SPIRV_VAL'],'rustc':subprocess.check_output(['rustc','-vV'],text=True),'cargo':subprocess.check_output(['cargo','-V'],text=True),'root_cargo_config_sha256':h(root/'.cargo/config.toml'),'guarded_files':len(files),'source_unchanged':None,'owned_display_stopped':None,'executables':executables,'limits':'Combined behavior and allocator/geometry accounting, not timing, RSS, native HDR, hardware conformance or foreign-OS runtime.'}
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
run('gpui-full',['cargo','test','--offline','--locked','-p','gpui','-p','gpui_gpu','--features',features,'--message-format=json'],1200)
artifacts=[]
for line in (out/'gpui-full.log').read_text().splitlines():
 try:r=json.loads(line)
 except ValueError:continue
 if r.get('reason')=='compiler-artifact' and r.get('executable'):artifacts.append(r)
a=next(r for r in artifacts if r['target']['kind']==['lib'] and r['target']['name']=='gpui' and r['profile']['test']);binary=out/'gpui-frozen';shutil.copyfile(a['executable'],binary);binary.chmod(0o555);executables[str(binary)]=h(binary);(out/'gpui-artifact.json').write_text(json.dumps(a,indent=2)+'\n')
run('gpui-strict',['cargo','clippy','--offline','--locked','-p','gpui','-p','gpui_gpu','--features',features,'--all-targets','--','-D','warnings'],900)
run('format',['cargo','fmt','--package','gpui','--package','gpui_canvas','--package','gpui_gpu','--package','gpui_reactivity_core','--','--check'])

check();metadata.update(source_unchanged=True,scope='Combined sibling CSR + lazy indirect Core: full GPUI/GPU tests, strict alltarget and format. No native Window/foreign compilation retag; exact producers retain their separate gates.');(out/'metadata.json').write_text(json.dumps(metadata,indent=2)+'\n')
