from pathlib import Path
import json,hashlib,subprocess,shutil,tempfile
r=Path(__file__).parent
m=json.loads((r/'MANIFEST.json').read_text())
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
assert set(m)=={p.relative_to(r).as_posix() for p in r.rglob('*') if p.is_file() and p.name!='MANIFEST.json'}
for n,h in m.items():assert sha(r/n)==h,n
b=r/'raw/first'
for gate in ['build','trace','clippy']:assert json.loads((b/(gate+'.status.json')).read_text())['exit']==0
assert json.loads((b/'guard.json').read_text())==[];assert json.loads((b/'overall.json').read_text())['decision'].startswith('PASSED')
a=json.loads((b/'artifact.json').read_text());elf=Path(a['preserved']).read_bytes();assert hashlib.sha256(elf).hexdigest()==a['sha256'] and len(elf)==a['bytes'] and not a['cargo_fresh']
shader=(b/'ui.wgsl').read_bytes()
for s in json.loads((b/'shaders.json').read_text()).values():assert hashlib.sha256(shader).hexdigest()==s['sha256'] and elf[s['elf_offset']:s['elf_offset']+s['bytes']]==shader
assert json.loads((b/'driver.json').read_text())['sha256']==sha(r/'raw/gate.py')
assert (r/'source.txt').read_bytes()==(b/'source.txt').read_bytes()
inputs=json.loads((b/'inputs-before.json').read_text())
for p in (r/'frozen').rglob('*'):
 if p.is_file():assert sha(p)==inputs[p.relative_to(r/'frozen').as_posix()]
with tempfile.TemporaryDirectory(prefix='gpui-layout-seam-verify-') as t:
 t=Path(t);shutil.copy2(r/'raw/analyze.py',t/'analyze.py')
 subprocess.run(['python3',str(t/'analyze.py'),str(b)],check=True)
 assert (t/'analysis.json').read_bytes()==(r/'raw/analysis.json').read_bytes()
assert json.loads((r/'raw/core-lines.json').read_text())['core_non_test_code_lines']==38145
print(f'verified {len(m)} files; 18 original/fresh CPU frames, layout-handle/cache/dependency trace only; inherited GPU parity FAILED; no adoption or timing')
