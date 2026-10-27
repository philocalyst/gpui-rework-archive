from pathlib import Path
import os,json,subprocess,hashlib,sys,shutil
root=Path(__file__).resolve().parent;wt=Path('/home/user/gpui-native-parity-lab');target=Path('/home/user/gpui-native-parity-target');out=root/sys.argv[1];out.mkdir(exist_ok=False)
def inputs():
 paths=subprocess.check_output(['git','ls-files','-z','reactivity','.cargo','clippy.toml'],cwd=wt).decode().split('\0')
 return {p:hashlib.sha256((wt/p).read_bytes()).hexdigest() for p in paths if p and (wt/p).is_file()}
assert not subprocess.check_output(['git','status','--porcelain'],cwd=wt).strip();before=inputs();(out/'inputs.json').write_text(json.dumps(before));(out/'source.txt').write_bytes(subprocess.check_output(['git','rev-parse','HEAD'],cwd=wt))
base=['cargo','+nightly-2026-10-23','-Z','checksum-freshness','--config','build.fingerprint="content"'];common=['--locked','--offline','--release','-p','gpui','--features','x11','--example','zgx_native_lab']
failed=False
for name,cmd in [('build',base+['build']+common+['--message-format=json']),('test',base+['test']+common),('clippy',base+['clippy']+common+['--','-D','warnings'])]:
 assert shutil.disk_usage('/home/user').free>8*1024**3
 with (out/(name+'.out')).open('w') as a,(out/(name+'.log')).open('w') as b:r=subprocess.run(cmd,cwd=wt/'reactivity',env={**os.environ,'CARGO_TARGET_DIR':str(target),'CARGO_BUILD_JOBS':'6'},stdout=a,stderr=b)
 (out/(name+'.status.json')).write_text(json.dumps({'command':cmd,'exit':r.returncode}));print(name,r.returncode,flush=True)
 if r.returncode:failed=True;break
 if name=='build':
  p=target/'release/examples/zgx_native_lab';digest=hashlib.sha256(p.read_bytes()).hexdigest();matches=[p2 for p2 in (target/'release/build/gpui').glob('*/out/zgx_native_lab') if p2.stat().st_size==p.stat().st_size and hashlib.sha256(p2.read_bytes()).hexdigest()==digest];assert len(matches)==1
  fp=json.loads((matches[0].parent.parent/'fingerprint/example-zgx_native_lab.json').read_text());assert 'x11' in json.loads(fp['features'])
  (out/'artifact.json').write_text(json.dumps({'path':str(matches[0]),'sha256':digest,'bytes':p.stat().st_size,'fingerprint':fp},indent=2))
after=inputs();changes=[p for p in set(before)|set(after) if before.get(p)!=after.get(p)];(out/'guard-after.json').write_text(json.dumps(changes));assert not changes and not failed
