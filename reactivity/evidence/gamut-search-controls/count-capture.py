from pathlib import Path
import subprocess,os,json,hashlib
for label in ['fixed','lattice','adaptive']:
 p=Path('/tmp/gpui-gamut-count-'+label)
 def guard():return {str(f):hashlib.sha256(f.read_bytes()).hexdigest() for f in [p/'Cargo.toml',p/'Cargo.lock']+list((p/'src').rglob('*.rs'))}
 before=guard();(p/'before.json').write_text(json.dumps(before,indent=2)+'\n');env=dict(os.environ,CARGO_BUILD_JOBS='2',CARGO_TARGET_DIR='/tmp/gpui-gamut-count-'+label+'-target')
 with (p/'build.jsonl').open('w') as out,(p/'build.stderr').open('w') as err:subprocess.run(['cargo','build','--release','--offline','--locked','--manifest-path',str(p/'Cargo.toml'),'--message-format=json'],env=env,stdout=out,stderr=err,check=True)
 binary=Path('/tmp/gpui-gamut-count-'+label+'-frozen');assert binary.read_bytes()==(Path(env['CARGO_TARGET_DIR'])/'release/gamut_count').read_bytes();bh=hashlib.sha256(binary.read_bytes()).hexdigest()
 captured=subprocess.check_output([str(binary)]);assert captured==Path('/tmp/gpui-gamut-count-'+label+'.csv').read_bytes();assert before==guard();assert hashlib.sha256(binary.read_bytes()).hexdigest()==bh
 (p/'after.json').write_text(json.dumps(guard(),indent=2)+'\n');(p/'binary-pins.json').write_text(json.dumps(dict(path=str(binary),sha256=bh,instrumentation='Thread-local source-level Polynomial.evaluate counter; no timing/codegen comparison from this binary'),indent=2)+'\n')
