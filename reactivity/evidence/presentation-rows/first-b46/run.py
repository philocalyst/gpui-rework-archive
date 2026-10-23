from pathlib import Path
import hashlib,subprocess,json,os,shutil
root=Path('/tmp/gpui-presented-changes-sol');out=Path('/tmp/gpui-presented-changes-first-controls');pin='b46a311e7c9baa71c63012afcad39c08f1037b72';assert subprocess.check_output(['git','rev-parse','HEAD'],cwd=root,text=True).strip()==pin
h=lambda p:hashlib.file_digest(p.open('rb'),'sha256').hexdigest();names=subprocess.check_output(['git','ls-files','-z','--','.cargo','reactivity/Cargo.toml','reactivity/Cargo.lock','reactivity/crates','reactivity/vendor'],cwd=root).decode().split('\0');files={n:h(root/n)for n in names if n and(root/n).is_file()}
env=dict(os.environ);env.pop('RUSTFLAGS',None);env.pop('CARGO_ENCODED_RUSTFLAGS',None);env.update(CARGO_BUILD_JOBS='1',CARGO_TARGET_DIR='/tmp/gpui-presented-basis-target')
meta={'source':pin,'files':files,'commands':[],'generic_rustflags':'unset','jobs':1};(out/'before.json').write_text(json.dumps(meta,indent=2)+'\n')
entries=[json.loads(s)for s in Path('/tmp/gpui-presented-changes-owner-build.log').read_text().splitlines()if s.startswith('{')];entry=next(e for e in entries if e.get('reason')=='compiler-artifact' and e['target']['name']=='gpui' and e.get('executable'));assert not entry['fresh'];binary=out/'owner-frozen';shutil.copyfile(entry['executable'],binary);binary.chmod(0o555);meta['binary']={'path':str(binary),'sha256':h(binary),'bytes':binary.stat().st_size,'fresh':False};(out/'metadata.json').write_text(json.dumps(meta,indent=2)+'\n')
def run(name,args,extra=None):
 record={'name':name,'argv':args,'env':extra};meta['commands'].append(record)
 with(out/(name+'.log')).open('w')as log:code=subprocess.call(args,cwd=root,env={**env,**(extra or {})},stdout=log,stderr=subprocess.STDOUT)
 record['exit']=code;(out/'metadata.json').write_text(json.dumps(meta,indent=2)+'\n');print(name,code,flush=True);assert code==0,name
for case in ['tiny1','workspace32','sparse16k','text32k','transformed32','inspector32']:
 run(case,[str(binary),'--exact','runtime::rows::owner_tests::whole_window_candidate_owner_costs','--ignored','--nocapture','--test-threads=1'],{'GPUI_ROW_OWNER_CASE':case})
for name,test in [('rows','runtime::rows::tests'),('focus','focus_release_tests'),('oracle','runtime::inspector::tests'),('images','runtime::image::tests')]:
 run(name,[str(binary),test,'--nocapture','--test-threads=1'])
run('public',['cargo','test','--manifest-path','reactivity/Cargo.toml','--locked','-p','gpui','--test','presentation_rows','--test','pointer','--test','pointer_focus','--test','inspector','--message-format=json-render-diagnostics'])
after={n:h(root/n)for n in files};assert after==files;assert h(binary)==meta['binary']['sha256'];meta['unchanged']=True;(out/'after.json').write_text(json.dumps(after,indent=2)+'\n');(out/'metadata.json').write_text(json.dumps(meta,indent=2)+'\n');print(json.dumps({'source':pin,'passed':True,'guarded_files':len(files)}))
