from pathlib import Path
import subprocess,json,hashlib,os,shutil
root=Path(__file__).resolve().parent;out=root/'negative';out.mkdir(exist_ok=False);wt=Path('/home/user/gpui-list-overscan-negative-lab');target=Path('/home/user/gpui-list-overscan-negative-target')
paths=subprocess.check_output(['git','ls-files','-z','reactivity','.cargo','clippy.toml'],cwd=wt).decode().split('\0')
def inputs():return {p:hashlib.sha256((wt/p).read_bytes()).hexdigest() for p in paths if p and (wt/p).is_file()}
assert not subprocess.check_output(['git','status','--porcelain'],cwd=wt).strip();before=inputs();(out/'inputs.json').write_text(json.dumps(before));(out/'source.txt').write_bytes(subprocess.check_output(['git','rev-parse','HEAD'],cwd=wt));assert shutil.disk_usage('/home/user').free>8*1024**3
cmd=['cargo','+nightly-2026-10-23','-Z','checksum-freshness','--config','build.fingerprint="content"','test','--locked','--offline','--release','-p','gpui','--test','lists','overscan_pixels_match_independently_materialized_eager_rows','--','--exact','--nocapture']
with (out/'test.out').open('w') as a,(out/'test.log').open('w') as b:r=subprocess.run(cmd,cwd=wt/'reactivity',env={**os.environ,'CARGO_TARGET_DIR':str(target),'CARGO_BUILD_JOBS':'2'},stdout=a,stderr=b)
(out/'test.status.json').write_text(json.dumps({'command':cmd,'exit':r.returncode}));after=inputs();changes=[p for p in set(before)|set(after) if before.get(p)!=after.get(p)];(out/'guard-after.json').write_text(json.dumps(changes));assert not changes;assert r.returncode==101 and '0 passed; 1 failed' in (out/'test.out').read_text();print('realized-key start mutant failed public image oracle as expected',flush=True)
