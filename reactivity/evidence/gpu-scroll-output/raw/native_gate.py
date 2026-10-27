from pathlib import Path
import os,json,subprocess,hashlib,sys,shutil
r=Path(__file__).resolve().parent;w=Path('/home/user/gpui-scroll-output-lab');target=Path('/home/user/gpui-scroll-output-target');out=r/sys.argv[1];out.mkdir(exist_ok=False)
def inputs():
 paths=subprocess.check_output(['git','ls-files','-z','reactivity','.cargo','clippy.toml'],cwd=w).decode().split('\0')
 return {p:hashlib.sha256((w/p).read_bytes()).hexdigest() for p in paths if p and (w/p).is_file()}
assert not subprocess.check_output(['git','status','--porcelain'],cwd=w).strip();before=inputs();(out/'inputs.json').write_text(json.dumps(before));(out/'source.txt').write_bytes(subprocess.check_output(['git','rev-parse','HEAD'],cwd=w))
base=['cargo','+nightly-2026-10-23','-Z','checksum-freshness','--config','build.fingerprint="content"'];common=['--locked','--offline','--release','-p','gpui','--features','x11'];failed=False
for name,cmd in [('test',base+['test']+common+['--lib','native::paint_tests::scroll_copy_tests::public_list_scroll_certifies_exact_tokens_and_discards_pending_or_fractional_proposals','--','--exact','--nocapture']),('clippy',base+['clippy']+common+['--all-targets','--','-D','warnings'])]:
 assert shutil.disk_usage('/home/user').free>8*1024**3
 with (out/(name+'.out')).open('w') as a,(out/(name+'.log')).open('w') as b:q=subprocess.run(cmd,cwd=w/'reactivity',env={**os.environ,'CARGO_TARGET_DIR':str(target),'CARGO_BUILD_JOBS':'6'},stdout=a,stderr=b)
 (out/(name+'.status.json')).write_text(json.dumps({'command':cmd,'exit':q.returncode}));print(name,q.returncode,flush=True)
 if q.returncode:failed=True;break
after=inputs();changes=[p for p in set(before)|set(after) if before.get(p)!=after.get(p)];(out/'guard-after.json').write_text(json.dumps(changes));assert not changes and not failed
