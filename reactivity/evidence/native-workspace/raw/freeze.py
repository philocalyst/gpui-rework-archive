from pathlib import Path
import subprocess,hashlib,json,os
r=Path(__file__).parent;out=r/'frozen';out.mkdir(exist_ok=False)
worktrees=json.loads((r/'source-worktrees.json').read_text());gates=json.loads((r/'build-gates.json').read_text());records={};fixtures={}
def sha(p):return hashlib.file_digest(p.open('rb'),'sha256').hexdigest()
for name in ['control','sparse','candidate','zgx']:
 g=r/gates[name];w=Path(worktrees[name])
 assert not subprocess.check_output(['git','status','--porcelain'],cwd=w).strip()
 assert subprocess.check_output(['git','rev-parse','HEAD'],cwd=w,text=True).strip()==(g/'source.txt').read_text().strip()
 before=json.loads((g/'inputs.json').read_text());after={p:sha(w/p) for p in subprocess.check_output(['git','ls-files','-z'],cwd=w).decode().split('\0') if p and (w/p).is_file()};assert before==after
 assert json.loads((g/'guard-after.json').read_text())==[]
 for stage in ['build','test']:assert json.loads((g/(stage+'.status.json')).read_text())['exit']==0
 aa=json.loads((g/'build-artifacts.json').read_text());assert len(aa)==1;a=aa[0];elf=Path(a['preserved']).read_bytes();assert hashlib.sha256(elf).hexdigest()==a['sha256']
 shaders=[]
 if name!='zgx':
  if name=='candidate':
   paths=list(Path('/home/user/gpui-native-workspace-target/release/build/gpui_gpu').glob('*/out/ui.wgsl'));assert paths
   assert {sha(p) for p in paths}=={'ea6e71d3da2bdb23d4971a14f0f55db389dbb45f9b2e9c05c85d4dc6363eb4d1'};data=paths[0].read_bytes()
  else:
   paths=[Path('/home/user/gpui-native-profile-evidence/frozen')/(name+'-ui.wgsl')];data=paths[0].read_bytes()
  offset=elf.find(data);assert offset>=0
  (out/(name+'-ui.wgsl')).write_bytes(data);shaders.append(dict(paths=list(map(str,paths)),sha256=hashlib.sha256(data).hexdigest(),bytes=len(data),elf_offset=offset))
  fixtures[name]=sha(w/'reactivity/crates/gpui/examples/zgx_native_lab.rs')
 else:
  for p in (w/'crates/zgx-gpu/src').glob('*.wgsl'):
   data=p.read_bytes();offset=elf.find(data);shaders.append(dict(path=str(p.relative_to(w)),sha256=sha(p),bytes=len(data),elf_offset=offset,embedded_whole=offset>=0))
  assert any(s['embedded_whole'] for s in shaders)
 records[name]=dict(source=(g/'source.txt').read_text().strip(),source_worktree=str(w),gate=gates[name],artifact=a,shaders=shaders,profile=json.loads((g/'environment.json').read_text()))
assert len(set(fixtures.values()))==1
profiles={n:{k:v for k,v in d['profile'].items() if k not in ['CARGO_TARGET_DIR','CARGO_BUILD_JOBS']} for n,d in records.items()}
assert all(v==profiles['candidate'] for v in profiles.values())
# Full candidate source equality with the already-qualified library composition.
w=Path(worktrees['candidate']);qualified=json.loads(Path('/home/user/gpui-patch-workspace-evidence/full-native-initial/inputs.json').read_text())
used={p:h for p,h in qualified.items() if p.startswith(('reactivity/crates/','reactivity/vendor/','.cargo/')) or p in ['reactivity/Cargo.toml','reactivity/Cargo.lock','clippy.toml']}
assert all(sha(w/p)==h for p,h in used.items())
(out/'composition.json').write_text(json.dumps(dict(candidate_qualified_source='41a67473a0177fbb17df1f7b8e2f2f36dd6940f6',qualified_dossier='f7b3f60c70faf6d548fffda530d4de83b2570e34',identical_production_build_inputs=used,example_hashes=fixtures,matched_profiles=profiles),indent=2))
(out/'artifacts.json').write_text(json.dumps(records,indent=2))
env={**os.environ,'DISPLAY':':94','XDG_RUNTIME_DIR':'/home/user/gpui-xdg','VK_ICD_FILENAMES':'/usr/share/vulkan/icd.d/lvp_icd.json','LP_NUM_THREADS':'4'}
for name,cmd in [('uname',['uname','-a']),('display',['xdpyinfo']),('vulkan',['python3',str(r/'driver_probe.py')]),('processes',['ps','-eo','pid,etime,pcpu,comm'])]:
 p=subprocess.run(cmd,env=env,capture_output=True,text=True);(out/(name+'.out')).write_text(p.stdout);(out/(name+'.log')).write_text(p.stderr);(out/(name+'.status.json')).write_text(json.dumps(dict(command=cmd,exit=p.returncode)));assert p.returncode==0
(out/'cpuinfo.txt').write_text(Path('/proc/cpuinfo').read_text());(out/'device.json').write_text(json.dumps(dict(dev_dri_exists=Path('/dev/dri').exists())))
print('Four source/profile/fixture/ELF/shader sets frozen; candidate core equals qualified source')
