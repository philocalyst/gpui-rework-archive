from pathlib import Path
import subprocess,json,hashlib
r=Path(__file__).parent;artifacts={};fixtures={};shader_sources={}
for name,suffix,gate in [('candidate','','cost-fixture-lint-corrected'),('control','-control','cost-fixture-corrected'),('predecessor','-predecessor','cost-fixture-corrected'),('bounds','-bounds','cost-fixture-corrected')]:
 w=Path('/home/user/gpui-glyph-damage'+suffix+'-lab');g=Path('/home/user/gpui-glyph-damage'+suffix+'-evidence')/gate
 assert not subprocess.check_output(['git','status','--porcelain'],cwd=w).strip()
 assert json.loads((g/'guard-after.json').read_text())==[]
 for stage in ['test','clippy','gpu-headers','gpu-clippy']:assert json.loads((g/(stage+'.status.json')).read_text())['exit']==0
 subprocess.run(['python3',str(r/'preserve_unit.py'),str(g)],check=True)
 a=json.loads((g/'unit-artifact.json').read_text());src=subprocess.check_output(['git','rev-parse','HEAD'],cwd=w,text=True).strip();assert (g/'source.txt').read_text().strip()==src
 inputs=json.loads((g/'inputs.json').read_text())
 assert all((w/p).is_file() and hashlib.sha256((w/p).read_bytes()).hexdigest()==h for p,h in inputs.items())
 fp=Path(a['path']).parent.parent/'fingerprint/test-lib-gpui.json';j=json.loads(fp.read_text());assert 'x11' in json.loads(j['features']);assert 'native-core' in json.loads(j['features'])
 artifacts[name]={**a,'source':src,'worktree':str(w),'inputs':str(g/'inputs.json'),'gate':str(g),'fingerprint':j}
 fixtures[name]={p:hashlib.sha256((w/p).read_bytes()).hexdigest() for p in ['reactivity/crates/gpui/src/native/text_cost.rs','reactivity/crates/gpui/src/native/scroll_bench.rs']}
 shader_sources[name]={p:h for p,h in inputs.items() if p.endswith(('.wgsl','.wgsl.rs')) or (p.startswith('reactivity/crates/gpu/') and 'shader' in p) or p=='reactivity/crates/gpu/build.rs'}
for name in artifacts:
 assert fixtures[name]==fixtures['candidate'],('fixture mismatch',name)
 assert shader_sources[name]==shader_sources['candidate'],('shader source mismatch',name)
(r/'matrix-artifacts.json').write_text(json.dumps(artifacts,indent=2));(r/'matrix-fixture-equality.json').write_text(json.dumps(fixtures,indent=2));(r/'matrix-shader-source-equality.json').write_text(json.dumps(shader_sources,indent=2))
print('four immutable binaries, exact fixtures and shader sources verified')
