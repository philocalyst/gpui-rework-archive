from pathlib import Path
import json,subprocess,hashlib,shutil,re
store=Path('/tmp/gpui-text-map-query-refinements');store.mkdir(exist_ok=True)
variants={'24trim':('/root/gpui-text-map-capacity','/tmp/gpui-text-map-capacity-target','32e8ee128494e452927cf12632fb2f866c7171a5'),'12checked':('/root/gpui-text-map-12-query','/tmp/gpui-text-map-12-query-target','4b864b6b2f2909dc4add325af2f181637a15d556'),'8direct':('/root/gpui-text-map-8-direct','/tmp/gpui-text-map-8-direct-target','f515b1dcfc6a229aa994526c07a5de98bd8afcf8')}
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
manifest={}
for variant,(tree,target,source) in variants.items():
 assert subprocess.check_output(['git','rev-parse','HEAD'],cwd=tree,text=True).strip()==source
 subprocess.run(['git','diff','--exit-code','HEAD','--','reactivity/crates/canvas/src'],cwd=tree,check=True)
 directory=store/variant;directory.mkdir(exist_ok=True)
 binary=Path(target)/'release/examples/selection_queries';frozen=directory/'selection_queries';shutil.copy2(binary,frozen)
 symbols=subprocess.check_output(['nm','-S','--defined-only','--demangle',str(frozen)],text=True)
 selected=[]
 for line in symbols.splitlines():
  fields=line.split(maxsplit=3)
  if len(fields)!=4:continue
  address,size,kind,name=fields
  if name.startswith(('selection_queries::hit','selection_queries::motion','selection_queries::selected','<gpui_canvas::text::TextLayout>::')) or ('gpui_canvas::text::layout::' in name and 'drop_glue' not in name):
   selected.append({'address':address,'bytes':int(size,16),'kind':kind,'name':name})
 (directory/'symbols.json').write_text(json.dumps(selected,indent=2)+'\n')
 for index,symbol in enumerate(selected):
  address=int(symbol['address'],16);args=['objdump','-Cd',f'--start-address={address}',f'--stop-address={address+symbol["bytes"]}',str(frozen)]
  (directory/f'{index:02d}.asm').write_bytes(subprocess.check_output(args))
 (directory/'size.txt').write_bytes(subprocess.check_output(['size','-A',str(frozen)]))
 files=['reactivity/Cargo.toml','reactivity/Cargo.lock','reactivity/crates/canvas/src/text/layout.rs','reactivity/crates/canvas/src/text/layout/interaction.rs','reactivity/crates/canvas/src/text/planner.rs','reactivity/crates/canvas/examples/selection_queries.rs']
 manifest[variant]={'source':source,'target':target,'features':'default simd','profile':'release defaults','binary':str(frozen),'sha256':sha(frozen),'source_files_sha256':{p:sha(Path(tree)/p) for p in files}}
(store/'artifacts.json').write_text(json.dumps(manifest,indent=2)+'\n')
print(json.dumps({k:{'sha256':v['sha256'],'symbols':len(json.loads((store/k/'symbols.json').read_text()))} for k,v in manifest.items()},indent=2))
