from pathlib import Path
import json,subprocess,hashlib,shutil
r=Path(__file__).parent;w=Path('/home/user/gpui-mask-lattice-oracle-lab');target=Path('/home/user/gpui-mask-lattice-oracle-target');checkpoint=Path('/home/user/gpui-mask-lattice-checkpoint-lab');seal='c505416efdbb5a94e471a6c8d5ab08a8b932a05f'
def sha(p):return hashlib.file_digest(p.open('rb'),'sha256').hexdigest()
assert subprocess.check_output(['git','rev-parse','HEAD'],cwd=checkpoint,text=True).strip()==seal
assert not subprocess.check_output(['git','status','--porcelain'],cwd=checkpoint).strip()
d=checkpoint/'reactivity/evidence/mask-lattice-checkpoint'
for p,h in json.loads((d/'manifest.json').read_text()).items():assert sha(d/p)==h
assert subprocess.check_output(['git','rev-parse','HEAD'],cwd=w,text=True).strip()=='6faae98aa7391ede8f07f9325e63f044f1de9adf'
assert not subprocess.check_output(['git','status','--porcelain'],cwd=w).strip()
procs=subprocess.check_output(['ps','-eo','comm=,args='],text=True).splitlines()
assert not any(line.split()[0] in ['cargo','rustc','clippy-driver'] and ('/home/user/gpui-mask-lattice-oracle-' in line) for line in procs)
for a in json.loads((r/'oracle-gpu-initial/test-artifacts.json').read_text()):assert sha(Path(a['preserved']))==a['sha256']
files=[p for p in target.rglob('*') if p.is_file() and not p.is_symlink() and p.suffix in ['.rlib','.rmeta']]
rows=[dict(path=str(p),bytes=p.stat().st_size,sha256=sha(p)) for p in files]
(r/'oracle-library-cleanup-plan.json').write_text(json.dumps(rows,indent=2));before=shutil.disk_usage('/home/user').free
for p,row in zip(files,rows):assert sha(p)==row['sha256'];p.unlink()
(r/'oracle-library-cleanup.json').write_text(json.dumps(dict(checkpoint=seal,files=len(rows),bytes=sum(x['bytes'] for x in rows),free_before=before,free_after=shutil.disk_usage('/home/user').free,scope='Only inactive regenerable oracle libraries after verified evidence checkpoint. All executed ELF bytes, source, inputs, shaders, fingerprints and readbacks preserved.'),indent=2));print('Removed',len(rows),'inactive oracle libraries; free',shutil.disk_usage('/home/user').free)
