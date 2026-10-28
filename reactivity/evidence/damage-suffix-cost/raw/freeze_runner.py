from pathlib import Path
import json,shutil,subprocess
from guard import sha,guard
r=Path(__file__).parent
for v,a in json.loads((r/'matrix-artifacts.json').read_text()).items():
 dest=r/'reference'/v;dest.mkdir(parents=True,exist_ok=False)
 for name in ['inputs.json','source.txt','guard-after.json','build.status.json','test.status.json','environment.json','unit-artifact.json','artifact.json']:shutil.copyfile(Path(a['gate'])/name,dest/name)
 shutil.copyfile(Path(a['worktree'])/'reactivity/crates/gpui/examples/zgx_native_lab.rs',dest/'zgx_native_lab.rs')
 (dest/'source-production-diff.txt').write_bytes(subprocess.check_output(['git','diff',a['source'],a['current_source'],'--','reactivity/crates','reactivity/vendor','.cargo','reactivity/Cargo.toml','reactivity/Cargo.lock'],cwd=a['worktree']))
assert not guard()
files=[p for p in r.iterdir() if p.is_file() and p.suffix in ['.py','.json','.rs']]
files += [p for p in (r/'reference').rglob('*') if p.is_file()]
value={'files':{str(p.relative_to(r)):sha(p) for p in files},'preregistered_commit':'64e90ba23d','qualification_seal':'380db598cdbed2dd81c5a41745473c40a876f148','startup_seal':'bea6c4cf9135f494925ccd80b05f584e20fe7ff4','before_any_cost_observations':True}
assert not (r/'runner-receipt.json').exists();(r/'runner-receipt.json').write_text(json.dumps(value,indent=2));print('Frozen',len(value['files']),'inputs before observations')
