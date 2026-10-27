from pathlib import Path
import os,sys,json,subprocess,hashlib
root=Path(__file__).resolve().parent;wt=Path('/home/user/gpui-gpu-text-gated-lab');target=Path('/home/user/gpui-gpu-text-gated-target');mode=sys.argv[1];out=root/mode;out.mkdir(exist_ok=False)
def inputs():
 paths=subprocess.check_output(['git','ls-files','-z','reactivity','.cargo','clippy.toml'],cwd=wt).decode().split('\0')
 return {p:hashlib.sha256((wt/p).read_bytes()).hexdigest() for p in paths if p and (wt/p).is_file()}
assert not subprocess.check_output(['git','status','--porcelain'],cwd=wt).strip();before=inputs();(out/'inputs.json').write_text(json.dumps(before));(out/'source.txt').write_bytes(subprocess.check_output(['git','rev-parse','HEAD'],cwd=wt))
base=['cargo','+nightly-2026-10-23','-Z','checksum-freshness','--config','build.fingerprint="content"'];common=['--locked','--offline','--release','-p','gpui','-p','gpui_canvas']
if mode=='full':cmds=[('build',base+['build','--locked','--offline','--release','-p','gpui','--example','source_batch_cost','--example','source_batch_allocations','--message-format=json']),('test',base+['test']+common),('clippy',base+['clippy']+common+['--all-targets','--','-D','warnings'])]
elif mode=='composed':cmds=[('test',base+['test']+common+['--features','gpui/x11']),('clippy',base+['clippy']+common+['--features','gpui/x11','--lib','--tests','--','-D','warnings'])]
else:raise ValueError(mode)
failed=False
for name,cmd in cmds:
 with (out/(name+'.out')).open('w') as a,(out/(name+'.log')).open('w') as b:r=subprocess.run(cmd,cwd=wt/'reactivity',env={**os.environ,'CARGO_TARGET_DIR':str(target),'CARGO_BUILD_JOBS':'6'},stdout=a,stderr=b)
 (out/(name+'.status.json')).write_text(json.dumps({'command':cmd,'exit':r.returncode}));print(mode,name,r.returncode,flush=True)
 if r.returncode:failed=True;break
 if name=='build':
  for suffix in ['cost','allocations']:
   name2='source_batch_'+suffix;p=target/'release/examples'/name2;digest=hashlib.sha256(p.read_bytes()).hexdigest();matches=[p2 for p2 in (target/'release/build/gpui').glob('*/out/'+name2) if p2.stat().st_size==p.stat().st_size and hashlib.sha256(p2.read_bytes()).hexdigest()==digest];assert len(matches)==1
   fp=json.loads((matches[0].parent.parent/'fingerprint'/('example-'+name2+'.json')).read_text());assert json.loads(fp['features'])==['default','simd']
   (out/(suffix+'-artifact.json')).write_text(json.dumps({'path':str(matches[0]),'sha256':digest,'bytes':p.stat().st_size,'features':['default','simd'],'fingerprint':fp},indent=2))
after=inputs();changes=[p for p in set(before)|set(after) if before.get(p)!=after.get(p)];(out/'guard-after.json').write_text(json.dumps(changes));assert not changes and not failed
