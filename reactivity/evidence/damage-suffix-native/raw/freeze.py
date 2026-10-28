from pathlib import Path
import json,hashlib,subprocess,shutil,datetime,random
r=Path(__file__).parent
assert not (r/'timing').exists() and not (r/'timing-inputs.json').exists()
def sha(p):return hashlib.file_digest(p.open('rb'),'sha256').hexdigest()
paths=['reactivity/crates','reactivity/vendor','reactivity/Cargo.toml','reactivity/Cargo.lock','reactivity/rust-toolchain.toml','.cargo','clippy.toml']
sources={};artifacts={};profiles={}
for name,wt in [('baseline','/home/user/gpui-native-workspace-lab'),('candidate','/home/user/gpui-damage-suffix-native-lab')]:
 w=Path(wt);g=r/('build-'+name);assert json.loads((g/'guard-after.json').read_text())==[]
 assert not subprocess.check_output(['git','status','--porcelain'],cwd=w).strip();compiled=(g/'source.txt').read_text().strip();current=subprocess.check_output(['git','rev-parse','HEAD'],cwd=w,text=True).strip();assert not subprocess.check_output(['git','diff','--name-only',compiled,'HEAD','--',*paths],cwd=w).strip()
 inputs=json.loads((g/'inputs.json').read_text());checked=0
 for p,h in inputs.items():
  if any(p==x or p.startswith(x+'/') for x in paths):assert sha(w/p)==h,p;checked+=1
 sources[name]=dict(worktree=str(w),compiled_source=compiled,current_source=current,build_paths=paths,checked_build_inputs=checked)
 a=json.loads((g/'build-artifacts.json').read_text());assert len(a)==1;a=a[0];assert sha(Path(a['preserved']))==a['sha256'];artifacts[name]=a
 profile=json.loads((g/'environment.json').read_text());profiles[name]={k:v for k,v in profile.items() if k not in ['CARGO_TARGET_DIR','CARGO_BUILD_JOBS']}
 assert json.loads((g/'test.status.json').read_text())['exit']==0 and '17 passed; 0 failed' in (g/'test.out').read_text()
 for part in ['build','test']:assert json.loads((g/(part+'.status.json')).read_text())['exit']==0
 for stage in ['capture','exact','owner']:
  p=r/'preflight'/name/stage;status=json.loads((p/'status.json').read_text());assert status['exit']==0 and status['failure'] is None
  s=json.loads((p/'summary.json').read_text());assert s['font_sha256']=='7da195a74c55bef988d0d48f9508bd5d849425c1770dba5d7bfc6ce9ed848954'
assert profiles['baseline']==profiles['candidate']
orders=[]
for route in ['exact','owner']:
 for group in range(8):orders.append(dict(route=route,group=group,order=['baseline','candidate'] if group%2==0 else ['candidate','baseline']))
random.Random(20261109).shuffle(orders);assert json.loads((r/'PROCESS_ORDER.json').read_text())==orders
comparison=subprocess.run(['compare','-metric','AE',str(r/'preflight/baseline/capture/native.png'),str(r/'preflight/candidate/capture/native.png'),'null:'],capture_output=True,text=True)
(r/'image-comparison.json').write_text(json.dumps(dict(exit=comparison.returncode,stdout=comparison.stdout,stderr=comparison.stderr),indent=2));assert comparison.returncode==0 and comparison.stderr.strip()=='0'
uihash='ea6e71d3da2bdb23d4971a14f0f55db389dbb45f9b2e9c05c85d4dc6363eb4d1';shaders=[]
for p in Path('/home/user/gpui-damage-suffix-native-target/release/build/gpui_gpu').glob('*/out/ui.wgsl'):
 assert sha(p)==uihash;data=p.read_bytes();q=r/('native-'+p.name);q.write_bytes(data);shaders.append(dict(path=str(p),sha256=uihash,bytes=len(data),elf_offset=Path(artifacts['candidate']['preserved']).read_bytes().find(data)))
assert shaders and all(s['elf_offset']>=0 for s in shaders)
base_shader=Path('/home/user/gpui-native-workspace-evidence/frozen/candidate-ui.wgsl');assert sha(base_shader)==uihash;assert Path(artifacts['baseline']['preserved']).read_bytes().find(base_shader.read_bytes())>=0
(r/'artifacts.json').write_text(json.dumps(artifacts,indent=2));(r/'profiles.json').write_text(json.dumps(profiles,indent=2));(r/'shaders.json').write_text(json.dumps(shaders,indent=2))
for name in ['PROTOCOL.md','PROCESS_ORDER.json']:assert (r/name).read_bytes()==(Path('/home/user/gpui-damage-suffix-native-lab/reactivity/evidence/damage-suffix-native')/name).read_bytes() if (r/name).exists() else True
shutil.copy2('/home/user/gpui-damage-suffix-native-lab/reactivity/evidence/damage-suffix-native/PROTOCOL.md',r/'PROTOCOL.md')
assert not any(x in subprocess.check_output(['ps','-eo','comm='],text=True).splitlines() for x in ['cargo','rustc','clippy-driver'])
(r/'environment.json').write_text(json.dumps(dict(uname=subprocess.check_output(['uname','-a'],text=True),display=':94',driver='llvmpipe LLVM20.1.2/Mesa25.2.8',num_threads=4,free_bytes=shutil.disk_usage('/home/user').free,utc=datetime.datetime.now(datetime.timezone.utc).isoformat()),indent=2))
files={str(p.relative_to(r)):sha(p) for p in r.rglob('*') if p.is_file() and '__pycache__' not in str(p) and p.name not in ['freeze.out','freeze.log']}
envpaths=[Path('/usr/lib/x86_64-linux-gnu/libvulkan_lvp.so'),Path('/usr/lib/x86_64-linux-gnu/libvulkan.so.1').resolve(),Path('/home/user/zgx-native-profile-lab/comparisons/fonts/DejaVuSans.ttf')]
(r/'timing-inputs.json').write_text(json.dumps(dict(files=files,sources=sources,environment_files={str(p):sha(p) for p in envpaths},frozen_utc=datetime.datetime.now(datetime.timezone.utc).isoformat()),indent=2));print('frozen',len(files),'inputs;32 processes; exact images; matching profiles')
