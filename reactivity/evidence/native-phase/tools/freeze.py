from pathlib import Path
import json,hashlib,subprocess,datetime,shutil
r=Path(__file__).parent;w=Path('/home/user/gpui-native-phase-lab');d=w/'reactivity/evidence/native-phase'
def sha(p):return hashlib.file_digest(p.open('rb'),'sha256').hexdigest()
assert not (r/'runs').exists() and not (r/'freeze.json').exists()
assert not any(x in subprocess.check_output(['ps','-eo','comm='],text=True).splitlines() for x in ['cargo','rustc'])
assert not subprocess.check_output(['git','status','--porcelain'],cwd=w).strip()
guards={};artifacts=json.loads((r/'artifacts.json').read_text())
for name,a in artifacts.items():
 sw=Path(a['source_worktree']);paths=['reactivity/crates','reactivity/vendor','reactivity/Cargo.toml','reactivity/Cargo.lock','reactivity/rust-toolchain.toml','.cargo','clippy.toml'] if name=='candidate' else ['.']
 assert not subprocess.check_output(['git','status','--porcelain'],cwd=sw).strip()
 assert not subprocess.check_output(['git','diff','--name-only',a['source'],'HEAD','--',*paths],cwd=sw).strip()
 assert sha(Path(a['artifact']['preserved']))==a['artifact']['sha256']
 guards[name]={'worktree':str(sw),'frozen_source':a['source'],'current_source':subprocess.check_output(['git','rev-parse','HEAD'],cwd=sw,text=True).strip(),'paths':paths}
 for sh in a['shaders']:
  if sh.get('embedded_whole'):
   data=Path(a['artifact']['preserved']).read_bytes();part=data[sh['elf_offset']:sh['elf_offset']+sh['bytes']];assert hashlib.sha256(part).hexdigest()==sh['sha256']
paths=['reactivity/crates','reactivity/vendor','reactivity/Cargo.toml','reactivity/Cargo.lock','reactivity/rust-toolchain.toml','.cargo','clippy.toml']
assert not subprocess.check_output(['git','diff','--name-only','41a67473a0177fbb17df1f7b8e2f2f36dd6940f6','HEAD','--',*paths],cwd=w).strip()
guards['diagnostic']={'worktree':str(w),'frozen_source':'41a67473a0177fbb17df1f7b8e2f2f36dd6940f6','current_source':subprocess.check_output(['git','rev-parse','HEAD'],cwd=w,text=True).strip(),'paths':paths}
old=Path('/home/user/gpui-native-workspace-evidence');dest=r/'qualification';dest.mkdir()
for name,gate in [('candidate','build-candidate-qualified'),('zgx','build-zgx')]:shutil.copytree(old/gate,dest/name)
for p in ['device.json','cpuinfo.txt','composition.json','candidate-ui.wgsl']:shutil.copy2(old/'frozen'/p,dest/p)
for p in ['PROTOCOL.md','PROCESS_ORDER.json']:shutil.copy2(d/p,r/p)
inputs={str(p.relative_to(r)):sha(p) for p in r.rglob('*') if p.is_file() and '__pycache__' not in str(p)}
files=[Path('/usr/lib/x86_64-linux-gnu/libvulkan_lvp.so'),Path('/usr/lib/x86_64-linux-gnu/libvulkan.so.1').resolve(),Path('/home/user/zgx-native-profile-lab/comparisons/fonts/DejaVuSans.ttf')]
(r/'freeze.json').write_text(json.dumps({'utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'source_guards':guards,'inputs':inputs,'driver_files':{str(p):sha(p) for p in files}},indent=2));print('frozen',len(inputs),'inputs',guards['diagnostic']['current_source'])
