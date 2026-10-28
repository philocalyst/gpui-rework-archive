from pathlib import Path
import json,subprocess,hashlib
from guard import sha,snapshot
r=Path(__file__).parent
artifacts={};fixtures={};shaders={};builds={}
for v,w,g,source in [
 ('baseline','/home/user/gpui-native-phase-lab','/home/user/gpui-patch-workspace-evidence/full-native-initial','41a67473a0177fbb17df1f7b8e2f2f36dd6940f6'),
 ('candidate','/home/user/gpui-damage-suffix-lab','/home/user/gpui-damage-suffix-evidence/full-native-initial','df8ca59f69813e7dd05711fead98ed4278f1688d')]:
 w=Path(w);g=Path(g)
 assert not subprocess.check_output(['git','status','--porcelain'],cwd=w).strip()
 head=subprocess.check_output(['git','rev-parse','HEAD'],cwd=w,text=True).strip()
 assert (g/'source.txt').read_text().strip()==source
 assert json.loads((g/'guard-after.json').read_text())==[]
 for stage in ['build','test']:assert json.loads((g/(stage+'.status.json')).read_text())['exit']==0
 a=json.loads((g/'unit-artifact.json').read_text());native=json.loads((g/'artifact.json').read_text())
 old=json.loads((g/'inputs.json').read_text());present=snapshot(w)
 buildpaths=[p for p in old if p.startswith(('reactivity/crates/','reactivity/vendor/','.cargo/')) or p in ['clippy.toml','reactivity/clippy.toml','reactivity/Cargo.toml','reactivity/Cargo.lock','reactivity/rust-toolchain.toml','rust-toolchain.toml']]
 assert buildpaths and all(present.get(p)==old[p] for p in buildpaths)
 pathspec=['reactivity/crates','reactivity/vendor','.cargo','clippy.toml','reactivity/clippy.toml','reactivity/Cargo.toml','reactivity/Cargo.lock','reactivity/rust-toolchain.toml','rust-toolchain.toml']
 assert not subprocess.check_output(['git','diff',source,head,'--',*pathspec],cwd=w)
 snapshotpath=r/(v+'-current-inputs.json');snapshotpath.write_text(json.dumps(present,indent=2))
 builds[v]={p:old[p] for p in buildpaths}
 for artifact in [a,native]:assert sha(artifact['preserved'])==artifact['sha256']
 fp=json.loads((Path(a['path']).parent.parent/'fingerprint/test-lib-gpui.json').read_text())
 assert 'x11' in json.loads(fp['features'])
 artifacts[v]={**a,'variant':v,'source':source,'current_source':head,'worktree':str(w),'inputs':str(snapshotpath),'compiled_inputs':str(g/'inputs.json'),'gate':str(g),'fingerprint':fp,'native_artifact':native}
 paths=['reactivity/crates/gpui/src/native/scroll_bench.rs','reactivity/crates/gpui/src/native/text_cost.rs','reactivity/Cargo.toml','reactivity/Cargo.lock','.cargo/config.toml']
 fixtures[v]={p:present[p] for p in paths}
 target=Path(a['path']).parents[4]
 files=list((target/'release/build/gpui_gpu').glob('*/out/ui.wgsl'))
 assert files,(target,a['path'])
 values={sha(p):p.read_bytes() for p in files};assert set(values)=={'ea6e71d3da2bdb23d4971a14f0f55db389dbb45f9b2e9c05c85d4dc6363eb4d1'}
 h,data=next(iter(values.items()));offsets=[]
 for artifact in [a,native]:
  offset=Path(artifact['preserved']).read_bytes().find(data);assert offset>=0;offsets.append(offset)
 shaders[v]={'canonical_sha256':h,'bytes':len(data),'unit_elf_offset':offsets[0],'native_elf_offset':offsets[1],'typed_source_sha256':present['reactivity/crates/gpu/src/shader.rs']}
 assert a['cargo']['fresh'] is False
assert fixtures['baseline']==fixtures['candidate']
for field in ['profile','features']:assert artifacts['baseline']['cargo'][field]==artifacts['candidate']['cargo'][field]
assert shaders['baseline']['typed_source_sha256']==shaders['candidate']['typed_source_sha256']
p='reactivity/crates/gpui/examples/zgx_native_lab.rs'
b=(Path(artifacts['baseline']['worktree'])/p).read_bytes();c=(Path(artifacts['candidate']['worktree'])/p).read_bytes()
start=c.index(b'#[cfg(test)]\n#[allow(dead_code)]\npub(crate) fn visit_cold_stream_frames(')
end=c.index(b'#[cfg(test)]\n#[allow(dead_code)]\npub(crate) struct CostFixture',start)
assert c[:start]+c[end:]==b
(r/'cold-visitor-test-only.rs').write_bytes(c[start:end])
fixtures['test_only_exception']={'path':p,'baseline_sha256':hashlib.sha256(b).hexdigest(),'candidate_sha256':hashlib.sha256(c).hexdigest(),'removed_start':start,'removed_end':end,'removed_sha256':sha(r/'cold-visitor-test-only.rs'),'remainder_exactly_equal':True}
for src,dest in [('PROCESS_ORDER.json','process-order.json'),('COST.json','cost-definition.json')]:
 assert subprocess.check_output(['git','show','64e90ba23d:reactivity/evidence/damage-suffix-cost/'+src],cwd='/home/user/gpui-damage-suffix-cost-lab')==(r/dest).read_bytes()
for name,value in [('matrix-artifacts',artifacts),('matrix-fixture-equality',fixtures),('matrix-shader-receipt',shaders),('compiled-build-inputs',builds)]:
 p=r/(name+'.json');assert not p.exists();p.write_text(json.dumps(value,indent=2))
print('Two exact qualified artifacts; compiled/current sources, build inputs, fixture exception and embedded shaders verified.')
