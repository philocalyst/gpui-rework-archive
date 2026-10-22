from pathlib import Path
import json,shutil,subprocess,hashlib
root=Path('/tmp/gpui-vulkan-stage-ownership')
git=['git','-c',f'safe.directory={root}','-C',str(root)]
head=subprocess.check_output(git+['rev-parse','HEAD'],text=True).strip()
assert head.startswith('52701c8cc7')
source=root/'reactivity/vendor/wgpu-hal/src/vulkan/device.rs'
digest=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
expected=subprocess.check_output(git+['show',f'{head}:reactivity/vendor/wgpu-hal/src/vulkan/device.rs'])
assert source.read_bytes()==expected
rows=[json.loads(s) for s in Path('/tmp/gpui-vulkan-stage-527-unit-build.jsonl').read_text().splitlines() if s.startswith('{')]
x=[r for r in rows if r.get('reason')=='compiler-artifact' and r['target']['name']=='wgpu_hal' and r.get('executable')]
assert len(x)==1
p=Path('/tmp/gpui-vulkan-stage-527-unit')
shutil.copyfile(x[0]['executable'],p);p.chmod(0o755)
names=subprocess.check_output([str(p),'--list'],text=True)
name=[s.removesuffix(': test') for s in names.splitlines() if 'stage_temporaries_retire_' in s]
assert len(name)==1
before=digest(p)
r=subprocess.run([str(p),'--exact',name[0],'--nocapture'],capture_output=True,text=True)
Path('/tmp/gpui-vulkan-stage-527-unit.log').write_text(r.stdout+r.stderr)
print(r.stdout)
assert r.returncode==0
assert digest(p)==before
assert source.read_bytes()==expected
Path('/tmp/gpui-vulkan-stage-527-unit.json').write_text(json.dumps({'source':head,'cargo_artifact':x[0]['executable'],'test':name[0],'sha256':before,'source_sha256':digest(source),'test_graph_sha256':digest(root/'reactivity/vendor/wgpu-hal/Cargo.lock'),'source_unchanged':True,'binary_unchanged':True},indent=2)+'\n')
shutil.copyfile('/tmp/gpui-vulkan-stage-upstream.lock',root/'reactivity/vendor/wgpu-hal/Cargo.lock')
assert not subprocess.check_output(git+['diff','--name-only'],text=True).strip()
