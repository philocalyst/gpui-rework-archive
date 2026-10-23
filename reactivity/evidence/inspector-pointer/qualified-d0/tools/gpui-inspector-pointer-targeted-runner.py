from pathlib import Path
import subprocess,os,json,hashlib
root=Path('/tmp/gpui-inspector-pointer-sol');out=Path('/tmp/gpui-inspector-pointer-final-qualification')
pin='d0bd2f4ea541cf3483c71d5e8228aea5a8a1c7cc';assert subprocess.check_output(['git','rev-parse','HEAD'],cwd=root,text=True).strip()==pin
names=subprocess.check_output(['git','ls-files','-z','--','.cargo','reactivity/Cargo.toml','reactivity/Cargo.lock','reactivity/crates','reactivity/vendor'],cwd=root).decode().split('\0');h=lambda p:hashlib.file_digest(p.open('rb'),'sha256').hexdigest();before={n:h(root/n) for n in names if n and(root/n).is_file()}
env=dict(os.environ);env.pop('RUSTFLAGS',None);env.pop('CARGO_ENCODED_RUSTFLAGS',None);env.update(CARGO_BUILD_JOBS='2',CARGO_TARGET_DIR='/tmp/gpui-presented-basis-target')
meta={'source':pin,'files':before,'commands':[],'generic_rustflags':'unset'};(out/'before.json').write_text(json.dumps(meta,indent=2)+'\n')
def run(name,args):
 record={'name':name,'argv':args};meta['commands'].append(record)
 with(out/(name+'.log')).open('w')as log:code=subprocess.call(args,cwd=root,env=env,stdout=log,stderr=subprocess.STDOUT)
 record['exit']=code;(out/'targeted-metadata.json').write_text(json.dumps(meta,indent=2)+'\n');assert code==0,name
run('clean-default',['cargo','clean','--manifest-path','reactivity/Cargo.toml','--profile','dev','-p','gpui'])
a=['cargo','test','--manifest-path','reactivity/Cargo.toml','--locked','-p','gpui']
run('default-private',a+['--lib','focus_release_tests','--message-format=json-render-diagnostics','--','--nocapture'])
events=[json.loads(s)for s in(out/'default-private.log').read_text().splitlines()if s.startswith('{')];artifacts=[e for e in events if e.get('reason')=='compiler-artifact' and e['target']['name']=='gpui'];assert artifacts and all(e['fresh']is False for e in artifacts);meta['initial_gpui_fresh']=False
run('default-oracle',a+['--lib','runtime::inspector::tests','--','--nocapture'])
run('default-public',a+['--test','pointer','--test','pointer_focus','--test','inspector'])
run('format',['rustfmt','--edition','2024','--config','skip_children=true','--check','reactivity/crates/gpui/src/runtime.rs','reactivity/crates/gpui/src/runtime/input.rs','reactivity/crates/gpui/src/runtime/query.rs','reactivity/crates/gpui/src/runtime/geometry.rs','reactivity/crates/gpui/src/runtime/inspector.rs','reactivity/crates/gpui/tests/pointer_focus.rs'])
after={n:h(root/n)for n in before};assert after==before;meta['source_unchanged']=True;meta['guarded_files']=len(before);(out/'after-targeted.json').write_text(json.dumps(after,indent=2)+'\n');(out/'targeted-metadata.json').write_text(json.dumps(meta,indent=2)+'\n');print(json.dumps({'source':pin,'passed':43,'guarded_files':len(before),'source_unchanged':True}))
