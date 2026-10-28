from pathlib import Path
import hashlib,json,os,signal,subprocess
root=Path('/root/gpui-ce3');cwd=root/'reactivity';out=Path('/tmp/gpui-property-outline-main');out.mkdir(exist_ok=False)
h=lambda p:hashlib.file_digest(p.open('rb'),'sha256').hexdigest();git=['git','-c',f'safe.directory={root}','-C',str(root)]
source=subprocess.check_output(git+['rev-parse','HEAD'],text=True).strip()
files=subprocess.check_output(git+['ls-files','reactivity/crates','reactivity/vendor','reactivity/Cargo.toml','reactivity/Cargo.lock','.cargo/config.toml','reactivity/.cargo'],text=True).splitlines()
def guard():return {n:h(root/n) for n in files}
before=guard();(out/'source-guard.json').write_text(json.dumps(before,indent=2)+'\n');results=[]
metadata={'source':source,'producer':'49707a4a4afc07e204133183ed3d548b065f66ed','guarded_files':len(files),'source_unchanged':None,'scope':'Merged bounded property/union/shell/allocation regressions plus strict alltarget checks. Full parent main651/native/cross campaign remains c717; exact outlined producer carries native/cross qualification.'}
(out/'metadata.json').write_text(json.dumps(metadata,indent=2)+'\n')
features='desktop,x11,wayland,gpui_canvas/parallel,cephal/verify-cache,gpui_gpu/offline-shader,gpui_gpu/vulkan-tests'
commands=[('public',['cargo','test','--offline','--locked','-p','gpui','--test','property_actions','--test','property_selection','--test','property_change_union','--test','property_state_shell','--test','property_outline_allocations','--features',features,'--','--nocapture']),('strict',['cargo','clippy','--offline','--locked','-p','gpui','--all-targets','--features',features,'--','-D','warnings']),('format',['cargo','fmt','--package','gpui','--','--check'])]
for name,command in commands:
 assert guard()==before
 with (out/(name+'.log')).open('w') as log:
  p=subprocess.Popen(command,cwd=cwd,stdout=log,stderr=subprocess.STDOUT,start_new_session=True)
  try:code=p.wait(timeout=900)
  finally:
   try:os.killpg(p.pid,signal.SIGTERM)
   except ProcessLookupError:pass
 row={'name':name,'command':command,'exit':code,'log_sha256':h(out/(name+'.log'))};results.append(row);(out/'results.json').write_text(json.dumps(results,indent=2)+'\n');print(json.dumps(row),flush=True);assert code==0;assert guard()==before
metadata['source_unchanged']=True;(out/'metadata.json').write_text(json.dumps(metadata,indent=2)+'\n')
