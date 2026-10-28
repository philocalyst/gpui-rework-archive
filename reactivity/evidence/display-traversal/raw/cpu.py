from pathlib import Path
import subprocess,hashlib,json,sys,time
w=Path('/home/user/gpui-display-traversal-lab');r=Path(__file__).parent/sys.argv[1];r.mkdir(exist_ok=False)
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def guard():return {n:sha(w/n) for n in subprocess.check_output(['git','ls-files','-z'],cwd=w).decode().split('\0') if n and (w/n).is_file()}
assert not subprocess.check_output(['git','status','--porcelain'],cwd=w).strip()
before=guard();(r/'inputs-before.json').write_text(json.dumps(before,indent=2));(r/'source.txt').write_bytes(subprocess.check_output(['git','rev-parse','HEAD'],cwd=w))
start=time.time()
with (r/'model.out').open('wb') as out,(r/'model.err').open('wb') as err:p=subprocess.run(['python3',str(w/'reactivity/crates/display-span-lab/model/spatial_checks.py'),str(r/'model')],stdout=out,stderr=err)
(r/'status.json').write_text(json.dumps(dict(exit=p.returncode,elapsed_seconds=time.time()-start),indent=2));after=guard();(r/'guard.json').write_text(json.dumps([n for n in before.keys()|after.keys() if before.get(n)!=after.get(n)]));assert before==after;print('spatial-cpu',p.returncode);sys.exit(p.returncode)
