from pathlib import Path
import json,hashlib,subprocess,shutil,datetime
r=Path(__file__).parent;w=Path('/home/user/gpui-mask-grid-audit-lab');g=r/'build-candidate'
def sha(p):return hashlib.file_digest(p.open('rb'),'sha256').hexdigest()
def save(p,v):(r/p).write_text(json.dumps(v,indent=2))
assert not (r/'observations').exists() and not (r/'timing-inputs.json').exists();assert not subprocess.check_output(['git','status','--porcelain'],cwd=w).strip();assert json.loads((g/'guard-after.json').read_text())==[]
parent=json.loads((r/'parent-reference.json').read_text());pd=Path(parent['dossier']);assert sha(pd/'manifest.json')==parent['manifest_sha256'];pv=subprocess.run(['python3',str(pd/'verify.py')],capture_output=True,text=True);save('parent-reverification.json',dict(exit=pv.returncode,stdout=pv.stdout,stderr=pv.stderr));assert pv.returncode==0;assert sha(r/'parent-analysis.json')==parent['analysis_sha256']
source=subprocess.check_output(['git','rev-parse','HEAD'],cwd=w,text=True).strip();assert source==(g/'source.txt').read_text().strip()
for stage in ['build','test']:assert json.loads((g/(stage+'.status.json')).read_text())['exit']==0
assert '17 passed; 0 failed' in (g/'test.out').read_text()
inputs=json.loads((g/'inputs.json').read_text());assert all(sha(w/p)==h for p,h in inputs.items());save('candidate-current-inputs.json',inputs)
a=json.loads((g/'build-artifacts.json').read_text());assert len(a)==1;a=a[0];assert sha(Path(a['preserved']))==a['sha256'];save('artifacts.json',dict(candidate=a))
qualified=Path('/home/user/gpui-mask-grid-lab/reactivity/evidence/mask-grid');p=subprocess.run(['python3',str(qualified/'verify.py')],capture_output=True,text=True);save('shader-admission-reverification.json',dict(exit=p.returncode,stdout=p.stdout,stderr=p.stderr));assert p.returncode==0
h='07a94fa243212e5261309a7f5d7234e7c7f0ae668302cac1fae27f6939fa7a7e';shader=(qualified/'raw/generated-shaders'/(h+'-ui.wgsl')).read_bytes();assert hashlib.sha256(shader).hexdigest()==h;(r/'ui.wgsl').write_bytes(shader);data=Path(a['preserved']).read_bytes();offset=data.find(shader);assert offset>=0 and b'MASK_PACKET' in data
paths=list(Path('/home/user/gpui-mask-grid-audit-target/release/build/gpui_gpu').glob('*/out/ui.wgsl'));assert paths and all(sha(p)==h for p in paths);save('shader.json',dict(sha256=h,bytes=len(shader),offset=offset,generated=[str(p) for p in paths]))
example='reactivity/crates/gpui/examples/zgx_native_lab.rs';assert (w/example).read_bytes()==(Path('/home/user/gpui-mask-quad-native-lab')/example).read_bytes()
for initial in [0,190]:shutil.copy2(Path(f'/home/user/gpui-mask-quad-native-evidence/preflight/candidate/capture-{initial}/native.png'),r/f'oracle-{initial}.png')
save('environment.json',dict(uname=subprocess.check_output(['uname','-a'],text=True),display=':94',driver='llvmpipe LLVM20.1.2/Mesa25.2.8',threads=4,free_bytes=shutil.disk_usage('/home/user').free,scope='Instrumented diagnostic; no timing/performance comparison.'))
files={str(p.relative_to(r)):sha(p) for p in r.rglob('*') if p.is_file() and '__pycache__' not in str(p) and p.name not in ['freeze.out','freeze.log']}
envpaths=[Path('/usr/lib/x86_64-linux-gnu/libvulkan_lvp.so'),Path('/usr/lib/x86_64-linux-gnu/libvulkan.so.1').resolve(),Path('/usr/share/vulkan/icd.d/lvp_icd.json'),Path('/home/user/zgx-native-profile-lab/comparisons/fonts/DejaVuSans.ttf')]
save('timing-inputs.json',dict(files=files,sources=dict(candidate=dict(worktree=str(w),compiled_source=source,current_source=source)),environment_files={str(p):sha(p) for p in envpaths},frozen_utc=datetime.datetime.now(datetime.timezone.utc).isoformat()));print('Frozen diagnostic',len(files),'inputs; generated/embedded shader exact')
