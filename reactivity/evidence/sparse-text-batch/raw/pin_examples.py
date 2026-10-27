from pathlib import Path
import os,sys,json,subprocess,hashlib
trial,stem=sys.argv[1:];wt=Path('/home/user/gpui-'+trial+'-lab');target=Path('/home/user/gpui-'+trial+'-target');out=Path('/home/user/gpui-'+trial+'-evidence/artifact-pin');out.mkdir(exist_ok=False)
def inputs():
 paths=subprocess.check_output(['git','ls-files','-z','reactivity','.cargo','clippy.toml'],cwd=wt).decode().split('\0')
 return {p:hashlib.sha256((wt/p).read_bytes()).hexdigest() for p in paths if p and (wt/p).is_file()}
assert not subprocess.check_output(['git','status','--porcelain'],cwd=wt).strip()
before=inputs();(out/'inputs.json').write_text(json.dumps(before));(out/'source.txt').write_bytes(subprocess.check_output(['git','rev-parse','HEAD'],cwd=wt))
cmd=['cargo','+nightly-2026-10-23','-Z','checksum-freshness','--config','build.fingerprint="content"','build','--locked','--offline','--release','-p','gpui','--example',stem+'_cost','--example',stem+'_allocations','--message-format=json']
with (out/'build.out').open('w') as a,(out/'build.log').open('w') as b:r=subprocess.run(cmd,cwd=wt/'reactivity',env={**os.environ,'CARGO_TARGET_DIR':str(target)},stdout=a,stderr=b)
(out/'build.status.json').write_text(json.dumps({'command':cmd,'exit':r.returncode}));after=inputs();changes=[p for p in set(before)|set(after) if before.get(p)!=after.get(p)];(out/'guard-after.json').write_text(json.dumps(changes));assert r.returncode==0 and not changes
for suffix in ['cost','allocations']:
 name=stem+'_'+suffix;binary=target/'release/examples'/name;digest=hashlib.sha256(binary.read_bytes()).hexdigest();stable=[]
 for p in (target/'release/build/gpui').glob('*/out/'+name):
  if p.stat().st_size==binary.stat().st_size and hashlib.sha256(p.read_bytes()).hexdigest()==digest:stable.append(p)
 assert len(stable)==1
 fp=stable[0].parent.parent/'fingerprint'/('example-'+name+'.json');fingerprint=json.loads(fp.read_text());assert json.loads(fingerprint['features'])==['default','simd']
 (out/(suffix+'-artifact.json')).write_text(json.dumps({'path':str(stable[0]),'sha256':digest,'bytes':binary.stat().st_size,'features':['default','simd'],'fingerprint':fingerprint},indent=2))
 print(trial,suffix,stable[0],digest,flush=True)
