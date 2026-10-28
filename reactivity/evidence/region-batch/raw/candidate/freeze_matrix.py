from pathlib import Path
import subprocess,json,hashlib,shutil
r=Path(__file__).parent;specs=json.loads((r/'cost-control-sources.json').read_text());specs.append({'variant':'candidate','worktree':'/home/user/gpui-region-batch-lab','target':'/home/user/gpui-region-batch-target','source':'1f16b73c56f10044a4186c90fb69ffe3d4047ac6'});artifacts={};fixtures={};shaders={}
def sha(p):return hashlib.file_digest(p.open('rb'),'sha256').hexdigest()
for s in specs:
 n=s['variant'];w=Path(s['worktree']);g=r/('full-native' if n=='candidate' else 'cost-build-'+n);assert json.loads((g/'guard-after.json').read_text())==[]
 for stage in ['build','test','port','clippy']+([] if n=='candidate' else ['gpu-test','gpu-clippy']):assert json.loads((g/(stage+'.status.json')).read_text())['exit']==0
 a=json.loads((g/'unit-artifact.json').read_text());assert sha(Path(a['preserved']))==a['sha256'];assert not subprocess.check_output(['git','status','--porcelain'],cwd=w).strip();assert subprocess.check_output(['git','rev-parse','HEAD'],cwd=w,text=True).strip()==s['source'];assert (g/'source.txt').read_text().strip()==s['source']
 before=json.loads((g/'inputs.json').read_text());after={p:sha(w/p) for p in subprocess.check_output(['git','ls-files','-z','reactivity','.cargo','clippy.toml'],cwd=w).decode().split('\0') if p and (w/p).is_file()};assert before==after
 fp=json.loads((Path(a['path']).parent.parent/'fingerprint/test-lib-gpui.json').read_text());assert 'x11' in json.loads(fp['features']);artifacts[n]={**a,**s,'inputs':str(g/'inputs.json'),'gate':str(g),'fingerprint':fp,'native_artifact':json.loads((g/'artifact.json').read_text())}
 fixtures[n]={p:after[p] for p in ['reactivity/crates/gpui/examples/zgx_native_lab.rs','reactivity/crates/gpui/src/native/scroll_bench.rs','reactivity/crates/gpui/src/native/text_cost.rs','reactivity/Cargo.toml','reactivity/Cargo.lock','.cargo/config.toml']}
 files=list((Path(s['target'])/'release/build/gpui_gpu').glob('*/out/ui.wgsl'));assert files;values={sha(p):p.read_bytes() for p in files};assert set(values)=={'ea6e71d3da2bdb23d4971a14f0f55db389dbb45f9b2e9c05c85d4dc6363eb4d1'};h,data=next(iter(values.items()));elf=Path(a['preserved']).read_bytes();offset=elf.find(data);assert offset>=0
 shaders[n]={'canonical_sha256':h,'bytes':len(data),'unit_elf_offset':offset,'typed_source_sha256':after['reactivity/crates/gpu/src/shader.rs']}
 if n=='candidate':
  files=list((Path(s['target'])/'release/build/gpui_gpu').glob('*/out/region.wgsl'));assert files;values={sha(p):p.read_bytes() for p in files};assert set(values)=={'6af2f8ac8608e407756c3d4afd2bfe736f58886bc193be00fecbf8c0577afc0c'};h,data=next(iter(values.items()));offset=elf.find(data);assert offset>=0;shaders[n]['region']={'sha256':h,'bytes':len(data),'unit_elf_offset':offset}
for n,a in artifacts.items():
 assert fixtures[n]==fixtures['candidate'];assert a['cargo']['profile']==artifacts['candidate']['cargo']['profile'];assert a['cargo']['features']==artifacts['candidate']['cargo']['features'];assert shaders[n]['typed_source_sha256']==shaders['candidate']['typed_source_sha256']
research=Path('/home/user/gpui-architecture-local');commit='6f1cf9e1ae170bcffef62665b3b3f91c22e880ab'
for src,dest in [('PROCESS_ORDER.json','process-order.json'),('COST.json','cost-definition.json')]:assert subprocess.check_output(['git','show',commit+':reactivity/evidence/region-batch/'+src],cwd=research)==(r/dest).read_bytes()
(r/'matrix-artifacts.json').write_text(json.dumps(artifacts,indent=2));(r/'matrix-fixture-equality.json').write_text(json.dumps(fixtures,indent=2));(r/'matrix-shader-receipt.json').write_text(json.dumps(shaders,indent=2));print('four exact source/artifact/profile/fixture/shader sets frozen')
