from pathlib import Path
import subprocess,json,hashlib,datetime
r=Path(__file__).parent;artifacts=json.loads((r/'artifacts.json').read_text());guards={}
def sha(p):return hashlib.file_digest(p.open('rb'),'sha256').hexdigest()
for n,a in artifacts.items():
 w=Path('/home/user/'+('gpui-native-profile-'+n+'-lab' if n!='zgx' else 'zgx-native-profile-lab'));assert not subprocess.check_output(['git','status','--porcelain'],cwd=w).strip()
 paths=['reactivity/crates','reactivity/Cargo.toml','reactivity/Cargo.lock','reactivity/rust-toolchain.toml','.cargo','clippy.toml'] if n!='zgx' else ['.']
 diff=subprocess.check_output(['git','diff','--name-only',a['source'],'HEAD','--',*paths],cwd=w,text=True);assert not diff
 assert sha(Path(a['artifact']['preserved']))==a['artifact']['sha256'];guards[n]={'frozen_source':a['source'],'current_source':subprocess.check_output(['git','rev-parse','HEAD'],cwd=w,text=True).strip(),'changed_build_paths':diff.splitlines()}
assert not any(x in subprocess.check_output(['ps','-eo','comm='],text=True).splitlines() for x in ['cargo','rustc'])
files=[Path('/usr/lib/x86_64-linux-gnu/libvulkan_lvp.so'),Path('/usr/lib/x86_64-linux-gnu/libvulkan.so.1').resolve()]
(r/'freeze.json').write_text(json.dumps({'utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'source_guards':guards,'scripts':{p.name:sha(p) for p in r.glob('*.py')},'driver_files':{str(p):sha(p) for p in files}},indent=2));print('Attribution inputs frozen')
