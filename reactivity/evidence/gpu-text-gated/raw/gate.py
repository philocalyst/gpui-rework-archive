from pathlib import Path
import os,sys,json,subprocess,hashlib
root=Path(__file__).resolve().parent;variant=sys.argv[1];suffix='-control' if variant=='control' else '';wt=Path('/home/user/gpui-gpu-text-gated'+suffix+'-lab');target=Path('/home/user/gpui-gpu-text-gated'+suffix+'-target');out=root/variant;out.mkdir(exist_ok=False)
def inputs():
 paths=subprocess.check_output(['git','ls-files','-z','reactivity','.cargo','clippy.toml'],cwd=wt).decode().split('\0')
 return {p:hashlib.sha256((wt/p).read_bytes()).hexdigest() for p in paths if p and (wt/p).is_file()}
assert not subprocess.check_output(['git','status','--porcelain'],cwd=wt).strip();before=inputs();(out/'inputs.json').write_text(json.dumps(before));(out/'source.txt').write_bytes(subprocess.check_output(['git','rev-parse','HEAD'],cwd=wt))
base=['cargo','+nightly-2026-10-23','-Z','checksum-freshness','--config','build.fingerprint="content"'];common=['--locked','--offline','--release','-p','gpui_gpu','--features','vulkan-tests'];env={**os.environ,'CARGO_TARGET_DIR':str(target),'CARGO_BUILD_JOBS':'6','XDG_RUNTIME_DIR':'/home/user/gpui-xdg','VK_ICD_FILENAMES':'/usr/share/vulkan/icd.d/lvp_icd.json','LP_NUM_THREADS':'4'}
cmds=[('build',base+['build']+common+['--example','text_packet','--message-format=json']),('test',base+['test']+common+['--','--test-threads=1']),('clippy',base+['clippy']+common+['--all-targets','--','-D','warnings'])]
failed=False
for name,cmd in cmds:
 with (out/(name+'.out')).open('w') as a,(out/(name+'.log')).open('w') as b:r=subprocess.run(cmd,cwd=wt/'reactivity',env=env,stdout=a,stderr=b)
 (out/(name+'.status.json')).write_text(json.dumps({'command':cmd,'exit':r.returncode}));print(variant,name,r.returncode,flush=True)
 if r.returncode:failed=True;break
 if name=='build':
  p=target/'release/examples/text_packet';digest=hashlib.sha256(p.read_bytes()).hexdigest();matches=[p2 for p2 in (target/'release/build/gpui_gpu').glob('*/out/text_packet') if p2.stat().st_size==p.stat().st_size and hashlib.sha256(p2.read_bytes()).hexdigest()==digest];assert len(matches)==1
  fp=json.loads((matches[0].parent.parent/'fingerprint/example-text_packet.json').read_text());(out/'artifact.json').write_text(json.dumps({'path':str(matches[0]),'sha256':digest,'bytes':p.stat().st_size,'fingerprint':fp},indent=2))
after=inputs();changes=[p for p in set(before)|set(after) if before.get(p)!=after.get(p)];(out/'guard-after.json').write_text(json.dumps(changes));assert not changes and not failed
