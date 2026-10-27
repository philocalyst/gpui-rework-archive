from pathlib import Path
import os,sys,json,subprocess,hashlib
root=Path(__file__).resolve().parent;variant=sys.argv[1];suffix='-control' if variant=='control' else '';wt=Path('/home/user/gpui-gpu-text-gated'+suffix+'-lab');target=Path('/home/user/gpui-gpu-text-gated'+suffix+'-target');out=root/(variant+'-allocation');out.mkdir(exist_ok=False)
def inputs():
 return {p:hashlib.sha256((wt/p).read_bytes()).hexdigest() for p in subprocess.check_output(['git','ls-files','-z','reactivity','.cargo','clippy.toml'],cwd=wt).decode().split('\0') if p and (wt/p).is_file()}
assert not subprocess.check_output(['git','status','--porcelain'],cwd=wt).strip();before=inputs();(out/'inputs.json').write_text(json.dumps(before));(out/'source.txt').write_bytes(subprocess.check_output(['git','rev-parse','HEAD'],cwd=wt))
base=['cargo','+nightly-2026-10-23','-Z','checksum-freshness','--config','build.fingerprint="content"'];common=['--locked','--offline','--release','-p','gpui_gpu','--features','vulkan-tests','--example','text_packet_allocations'];failed=False
for name,cmd in [('build',base+['build']+common+['--message-format=json']),('clippy',base+['clippy']+common+['--','-D','warnings'])]:
 with (out/(name+'.out')).open('w') as o,(out/(name+'.log')).open('w') as e:r=subprocess.run(cmd,cwd=wt/'reactivity',env={**os.environ,'CARGO_TARGET_DIR':str(target),'CARGO_BUILD_JOBS':'6'},stdout=o,stderr=e)
 (out/(name+'.status.json')).write_text(json.dumps({'command':cmd,'exit':r.returncode}));print(variant,name,r.returncode,flush=True)
 if r.returncode:failed=True;break
 if name=='build':
  p=target/'release/examples/text_packet_allocations';digest=hashlib.sha256(p.read_bytes()).hexdigest();matches=[f for f in (target/'release/build/gpui_gpu').glob('*/out/text_packet_allocations') if f.stat().st_size==p.stat().st_size and hashlib.sha256(f.read_bytes()).hexdigest()==digest];assert len(matches)==1
  fp=json.loads((matches[0].parent.parent/'fingerprint/example-text_packet_allocations.json').read_text());(out/'artifact.json').write_text(json.dumps({'path':str(matches[0]),'sha256':digest,'bytes':p.stat().st_size,'fingerprint':fp},indent=2))
after=inputs();changes=[p for p in set(before)|set(after) if before.get(p)!=after.get(p)];(out/'guard-after.json').write_text(json.dumps(changes));assert not changes and not failed
