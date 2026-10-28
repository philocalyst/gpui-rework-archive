from pathlib import Path
import json,hashlib,subprocess,shutil,datetime,random
from guard import snapshot
r=Path(__file__).parent
assert not (r/'timing').exists() and not (r/'timing-inputs.json').exists()
def sha(p):return hashlib.file_digest(Path(p).open('rb'),'sha256').hexdigest()
def save(p,v): (r/p).write_text(json.dumps(v,indent=2))
paths=['reactivity/crates','reactivity/vendor','reactivity/Cargo.toml','reactivity/Cargo.lock','reactivity/rust-toolchain.toml','.cargo','clippy.toml']
q=json.loads((r/'qualification-reference.json').read_text());d=Path(q['dossier']);assert sha(d/'manifest.json')==q['manifest_sha256'] and sha(d/'verify.py')==q['verifier_sha256']
p=subprocess.run(['python3',str(d/'verify.py')],capture_output=True,text=True);save('qualification-reverification.json',dict(exit=p.returncode,stdout=p.stdout,stderr=p.stderr));assert p.returncode==0
audit=json.loads((r/'audit-reference.json').read_text());ad=Path(audit['dossier']);assert sha(ad/'manifest.json')==audit['manifest_sha256'] and sha(ad/'verify.py')==audit['verifier_sha256']
p=subprocess.run(['python3',str(ad/'verify.py')],capture_output=True,text=True);save('audit-reverification.json',dict(exit=p.returncode,stdout=p.stdout,stderr=p.stderr));assert p.returncode==0
sources={};artifacts={};profiles={};shaders=[];images={}
for name,wt in [('baseline','/home/user/gpui-damage-suffix-native-lab'),('candidate','/home/user/gpui-mask-miss-native-lab')]:
 w=Path(wt);g=r/('build-'+name);assert json.loads((g/'guard-after.json').read_text())==[]
 assert not subprocess.check_output(['git','status','--porcelain'],cwd=w).strip();compiled=(g/'source.txt').read_text().strip();current=subprocess.check_output(['git','rev-parse','HEAD'],cwd=w,text=True).strip();assert not subprocess.check_output(['git','diff','--name-only',compiled,'HEAD','--',*paths],cwd=w).strip()
 inputs=json.loads((g/'inputs.json').read_text());checked=0
 for p,h in inputs.items():
  if any(p==x or p.startswith(x+'/') for x in paths):assert sha(w/p)==h,p;checked+=1
 save(name+'-current-inputs.json',snapshot(w));sources[name]=dict(worktree=str(w),compiled_source=compiled,current_source=current,build_paths=paths,checked_build_inputs=checked)
 aa=json.loads((g/'build-artifacts.json').read_text());assert len(aa)==1;a=aa[0];assert sha(a['preserved'])==a['sha256'];artifacts[name]=a
 profile=json.loads((g/'environment.json').read_text());profiles[name]={k:v for k,v in profile.items() if k not in ['CARGO_TARGET_DIR','CARGO_BUILD_JOBS']}
 assert '17 passed; 0 failed' in (g/'test.out').read_text()
 for part in ['build','test']:assert json.loads((g/(part+'.status.json')).read_text())['exit']==0
 for stage in ['capture-0','capture-190','stream','scroll','both']:
  p=r/'preflight'/name/stage;status=json.loads((p/'status.json').read_text());assert status['exit']==0 and status['failure'] is None
  s=json.loads((p/'summary.json').read_text());assert s['font_sha256']=='7da195a74c55bef988d0d48f9508bd5d849425c1770dba5d7bfc6ce9ed848954'
 shader=(Path('/home/user/gpui-native-workspace-evidence/frozen/candidate-ui.wgsl') if name=='baseline' else d/'raw/generated-shaders/2df8c6754318e54df054be3f438a4eeba0c433034f75470816d0600986e8a52e-ui.wgsl')
 expected='ea6e71d3da2bdb23d4971a14f0f55db389dbb45f9b2e9c05c85d4dc6363eb4d1' if name=='baseline' else '2df8c6754318e54df054be3f438a4eeba0c433034f75470816d0600986e8a52e'
 assert sha(shader)==expected;data=shader.read_bytes();offset=Path(a['preserved']).read_bytes().find(data);assert offset>=0
 (r/(name+'-ui.wgsl')).write_bytes(data);shaders.append(dict(name=name,sha256=expected,bytes=len(data),elf_offset=offset))
 if name=='candidate':
  generated=list(Path('/home/user/gpui-mask-miss-native-target/release/build/gpui_gpu').glob('*/out/ui.wgsl'));assert generated and all(sha(p)==expected for p in generated)
assert profiles['baseline']==profiles['candidate']
assert (r/'build-baseline/toolchain.txt').read_bytes()==(r/'build-candidate/toolchain.txt').read_bytes()
b=Path(sources['baseline']['worktree']);c=Path(sources['candidate']['worktree']);example='reactivity/crates/gpui/examples/zgx_native_lab.rs';assert (b/example).read_bytes()==(c/example).read_bytes()
spec=json.loads((r/'SPEC.json').read_text());orders=[dict(mode=m,group=g,order=['baseline','candidate'] if g%2==0 else ['candidate','baseline']) for m in spec['modes'] for g in range(8)];random.Random(spec['seed']).shuffle(orders);assert json.loads((r/'PROCESS_ORDER.json').read_text())==orders and sha(r/'PROCESS_ORDER.json')==spec['order_sha256']
for initial in [0,190]:
 p=subprocess.run(['compare','-metric','AE',str(r/f'preflight/baseline/capture-{initial}/native.png'),str(r/f'preflight/candidate/capture-{initial}/native.png'),'null:'],capture_output=True,text=True);images[str(initial)]=dict(exit=p.returncode,stdout=p.stdout,stderr=p.stderr);assert p.returncode==0 and p.stderr.strip()=='0'
save('image-comparison.json',images);save('artifacts.json',artifacts);save('profiles.json',profiles);save('shaders.json',shaders)
for name in ['PROTOCOL.md','SPEC.json','PROCESS_ORDER.json']:assert (r/name).read_bytes()==(c/'reactivity/evidence/mask-miss-native'/name).read_bytes()
assert not any(x.strip() in ['cargo','rustc','clippy-driver'] for x in subprocess.check_output(['ps','-eo','comm='],text=True).splitlines())
save('environment.json',dict(uname=subprocess.check_output(['uname','-a'],text=True),display=':94',driver='llvmpipe LLVM20.1.2/Mesa25.2.8',num_threads=4,free_bytes=shutil.disk_usage('/home/user').free,utc=datetime.datetime.now(datetime.timezone.utc).isoformat()))
files={str(p.relative_to(r)):sha(p) for p in r.rglob('*') if p.is_file() and '__pycache__' not in str(p) and p.name not in ['freeze.out','freeze.log']}
envpaths=[Path('/usr/lib/x86_64-linux-gnu/libvulkan_lvp.so'),Path('/usr/lib/x86_64-linux-gnu/libvulkan.so.1').resolve(),Path('/usr/share/vulkan/icd.d/lvp_icd.json'),Path('/home/user/zgx-native-profile-lab/comparisons/fonts/DejaVuSans.ttf')]
save('timing-inputs.json',dict(files=files,sources=sources,environment_files={str(p):sha(p) for p in envpaths},frozen_utc=datetime.datetime.now(datetime.timezone.utc).isoformat()));print('frozen',len(files),'inputs;64 processes; exact images; matched profiles; early shader admission reverified')
