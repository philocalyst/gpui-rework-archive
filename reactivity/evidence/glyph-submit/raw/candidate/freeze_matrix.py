from pathlib import Path
import subprocess,json,hashlib
r=Path(__file__).parent;artifacts=json.loads((r/'control-artifacts.json').read_text());w=Path('/home/user/gpui-glyph-submit-lab');g=r/'cost-fixture'
assert json.loads((g/'guard-after.json').read_text())==[]
for stage in ['test','clippy','gpu-headers','gpu-clippy']:assert json.loads((g/(stage+'.status.json')).read_text())['exit']==0
subprocess.run(['python3',str(r/'preserve_unit.py'),str(g)],check=True)
a=json.loads((g/'unit-artifact.json').read_text());src=subprocess.check_output(['git','rev-parse','HEAD'],cwd=w,text=True).strip();assert (g/'source.txt').read_text().strip()==src
fp=json.loads((Path(a['path']).parent.parent/'fingerprint/test-lib-gpui.json').read_text());assert 'x11' in json.loads(fp['features'])
artifacts['candidate']={**a,'source':src,'worktree':str(w),'inputs':str(g/'inputs.json'),'gate':str(g),'fingerprint':fp}
fixtures={};shaders={}
for name,a in artifacts.items():
 w=Path(a['worktree']);assert not subprocess.check_output(['git','status','--porcelain'],cwd=w).strip();assert subprocess.check_output(['git','rev-parse','HEAD'],cwd=w,text=True).strip()==a['source']
 before=json.loads(Path(a['inputs']).read_text());paths=subprocess.check_output(['git','ls-files','-z','reactivity','.cargo','clippy.toml'],cwd=w).decode().split('\0');after={p:hashlib.sha256((w/p).read_bytes()).hexdigest() for p in paths if p and (w/p).is_file()};assert before==after
 assert hashlib.sha256(Path(a['preserved']).read_bytes()).hexdigest()==a['sha256']
 fixtures[name]={p:after[p] for p in ['reactivity/crates/gpui/src/native/text_cost.rs','reactivity/crates/gpui/src/native/scroll_bench.rs']}
 shaders[name]={p:h for p,h in after.items() if p.endswith(('.wgsl','.wgsl.rs')) or (p.startswith('reactivity/crates/gpu/') and 'shader' in p) or p=='reactivity/crates/gpu/build.rs'}
for name in artifacts:
 assert fixtures[name]==fixtures['candidate'];assert shaders[name]==shaders['candidate']
(r/'matrix-artifacts.json').write_text(json.dumps(artifacts,indent=2));(r/'matrix-fixture-equality.json').write_text(json.dumps(fixtures,indent=2));(r/'matrix-shader-source-equality.json').write_text(json.dumps(shaders,indent=2))
print('four immutable artifacts, source inputs, fixtures and shader sources verified')
