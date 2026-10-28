from pathlib import Path
import hashlib, json, os, shutil, subprocess
root=Path('/tmp/gpui-text-column-reuse-sol')
out=Path(__file__).parent
build=Path('/tmp/gpui-text-column-a11y-isolated-build.log')
target=Path('/tmp/gpui-text-column-reuse-target')
def digest(path):
    with path.open('rb') as stream: return hashlib.file_digest(stream,'sha256').hexdigest()
def git(*args):
    return subprocess.check_output(['git','-c',f'safe.directory={root}','-C',str(root),*args],text=True)
def sources():
    names=git('ls-files','-z','--','.cargo','reactivity/Cargo.toml','reactivity/Cargo.lock','reactivity/crates','reactivity/vendor').split('\0')
    return {name:digest(root/name) for name in names if name and (root/name).is_file()}
owner=json.loads((out/'candidate-metadata.json').read_text())
before=sources()
assert before==owner['files_before']
assert git('rev-parse','HEAD').strip()==owner['source']
artifacts=[]
for line in build.read_text().splitlines():
    try: row=json.loads(line)
    except ValueError: continue
    if row.get('reason')=='compiler-artifact' and row['target']['name']=='gpui' and row.get('executable'): artifacts.append(row)
artifact=artifacts[-1]
assert not artifact['fresh']
assert artifact['executable'].startswith(str(target)+'/')
assert 'accessibility' in artifact['features'] and 'x11' in artifact['features']
binary=out/'qualified-a11y-frozen'
shutil.copyfile(artifact['executable'],binary)
binary.chmod(0o555)
meta={'source':owner['source'],'owner_source_guard_sha256':digest(out/'candidate-metadata.json'),'artifact':artifact,'binary_sha256':digest(binary),'generic_rustflags':'unset','jobs':1,'commands':[]}
metadata=out/'a11y-qualified.json'
metadata.write_text(json.dumps(meta,indent=2)+'\n')
env=dict(os.environ)
env.pop('RUSTFLAGS',None)
env.pop('CARGO_ENCODED_RUSTFLAGS',None)
env.update(CARGO_BUILD_JOBS='1',CARGO_TARGET_DIR=str(target))
def run(name,args):
    row={'name':name,'argv':args}
    with (out/f'a11y-qualified-{name}.log').open('w') as log:
        row['exit']=subprocess.call(args,cwd=root,env=env,stdout=log,stderr=subprocess.STDOUT)
    meta['commands'].append(row)
    metadata.write_text(json.dumps(meta,indent=2)+'\n')
    print(name,row['exit'],flush=True)
    assert row['exit']==0
for name,test in [('text-column','runtime::text_geometry::column_tests'),('observer','runtime::accessibility'),('geometry','native::accessibility::geometry_tests'),('selection','native::accessibility::selection_tests'),('transitions','native::accessibility::transitions')]:
    run(name,[str(binary),test,'--nocapture','--test-threads=1'])
run('public',['cargo','test','--manifest-path',str(root/'reactivity/Cargo.toml'),'--locked','-p','gpui','--no-default-features','--features','x11','--test','text_geometry','--test','text_selection','--test','text_selection_compound','--test','lists','--message-format=json-render-diagnostics'])
assert sources()==before
assert digest(binary)==meta['binary_sha256']
meta['sources_unchanged']=True
meta['binary_unchanged']=True
metadata.write_text(json.dumps(meta,indent=2)+'\n')
