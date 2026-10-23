from pathlib import Path
import os,subprocess,json,hashlib,shutil
root=Path('/tmp/gpui-intrinsic-width-sol');out=Path('/tmp/gpui-intrinsic-width-qualification');target=Path('/tmp/gpui-intrinsic-width-target');h=lambda p:hashlib.file_digest(p.open('rb'),'sha256').hexdigest();env=dict(os.environ);env.pop('RUSTFLAGS',None);env.pop('CARGO_ENCODED_RUSTFLAGS',None);env.update(CARGO_BUILD_JOBS='1',CARGO_TARGET_DIR=str(target));meta={'source':subprocess.check_output(['git','rev-parse','HEAD'],cwd=root,text=True).strip(),'shipping':'dbe8a82755db81fc6853ecf1642c6c5eb44d760d','commands':[],'timing_claim':False,'generic_flags_unset':True,'jobs':1};meta['rustc']=subprocess.check_output(['rustc','-vV'],env=env,text=True)
names=subprocess.check_output(['git','ls-files','-z','--','.cargo','reactivity/Cargo.toml','reactivity/Cargo.lock','reactivity/crates','reactivity/vendor'],cwd=root).decode().split('\0');before={n:h(root/n)for n in names if n and(root/n).is_file()};(out/'before.json').write_text(json.dumps(before,indent=2)+'\n')
commands=[('gpui-text',['test','-p','gpui','--test','intrinsic_text','--test','text_geometry','--test','text_selection','--test','text_selection_compound','--message-format=json-render-diagnostics']),('canvas-unicode',['test','-p','gpui_canvas','--test','unicode','--test','render','--message-format=json-render-diagnostics']),('core-layout',['test','-p','gpui_reactivity_core','--features','layout','--lib','--message-format=json-render-diagnostics']),('strict',['clippy','-p','gpui','-p','gpui_reactivity_core','-p','gpui_canvas','--all-targets','--','-D','warnings'])]
for name,args in commands:
 argv=['cargo',args[0],'--manifest-path','reactivity/Cargo.toml','--locked']+args[1:];record={'name':name,'argv':argv};meta['commands'].append(record)
 with(out/(name+'.log')).open('w')as f:code=subprocess.call(argv,cwd=root,env=env,stdout=f,stderr=subprocess.STDOUT)
 record['exit']=code
 if name!='strict':
  events=[json.loads(s)for s in(out/(name+'.log')).read_text().splitlines()if s.startswith('{')];record['artifacts']=[]
  for e in events:
   if e.get('reason')=='compiler-artifact'and e.get('executable')and e['profile']['test']:
    src=Path(e['executable']);binary=out/(name+'-'+src.name);shutil.copyfile(src,binary);binary.chmod(0o555);suffix=src.name.rsplit('-',1)[1];fps=list((target/'debug/.fingerprint').glob('*-'+suffix+'/*.json'));assert fps
    fingerprint=[]
    for fp in fps:
     data=json.loads(fp.read_text());assert data['rustflags']==['-C','symbol-mangling-version=v0','--cfg','tokio_unstable'];fingerprint.append({'path':str(fp),'sha256':h(fp),'data':data})
    record['artifacts'].append({'event':e,'binary':str(binary),'sha256':h(binary),'bytes':binary.stat().st_size,'fingerprints':fingerprint})
 (out/'metadata.json').write_text(json.dumps(meta,indent=2)+'\n');print(name,code,flush=True)
 if code:break
after={n:h(root/n)for n in before};assert after==before;(out/'after.json').write_text(json.dumps(after,indent=2)+'\n');meta['source_unchanged']=True;(out/'metadata.json').write_text(json.dumps(meta,indent=2)+'\n')
