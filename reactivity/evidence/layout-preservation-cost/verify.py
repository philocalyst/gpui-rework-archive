from pathlib import Path
import json,hashlib,shutil,subprocess,tempfile
r=Path(__file__).parent;sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
m=json.loads((r/'MANIFEST.json').read_text());assert set(m)=={p.relative_to(r).as_posix() for p in r.rglob('*') if p.is_file() and p.name!='MANIFEST.json'}
for n,h in m.items():assert sha(r/n)==h,n
b=r/'raw/build-first';c=r/'raw/campaign'
for g in ['build','clippy']:assert json.loads((b/(g+'.status.json')).read_text())['exit']==0
for d in [b,c]:assert json.loads((d/'guard.json').read_text())==[]
a=json.loads((b/'artifact.json').read_text());assert json.loads((c/'artifact.json').read_text())==a
elf=Path(a['preserved']).read_bytes();assert hashlib.sha256(elf).hexdigest()==a['sha256'] and len(elf)==a['bytes'] and not a['cargo_fresh']
shader=(b/'ui.wgsl').read_bytes()
for s in json.loads((b/'shaders.json').read_text()).values():assert hashlib.sha256(shader).hexdigest()==s['sha256'] and elf[s['elf_offset']:s['elf_offset']+s['bytes']]==shader
assert json.loads((b/'driver.json').read_text())['sha256']==sha(r/'build.py')
d=json.loads((c/'driver.json').read_text());assert d['sha256']==sha(r/'run.py') and d['analysis_sha256']==sha(r/'analyze.py')
inputs=json.loads((b/'inputs-before.json').read_text());after=json.loads((c/'inputs-before.json').read_text());assert all(after.get(n)==h for n,h in inputs.items())
for p in (r/'frozen').rglob('*'):
 if p.is_file():assert sha(p)==inputs[p.relative_to(r/'frozen').as_posix()]
assert (r/'source.txt').read_bytes()==(b/'source.txt').read_bytes()
assert json.loads((c/'overall.json').read_text())=={'decision':'COMPLETE; evaluate frozen gates separately','failed':[],'processes':288}
with tempfile.TemporaryDirectory(prefix='gpui-layout-cost-verify-') as t:
 out=Path(t)/'analysis.json';subprocess.run(['python3',str(r/'analyze.py'),str(c),str(out)],check=True);assert out.read_bytes()==(r/'raw/analysis.json').read_bytes()
a=json.loads((r/'raw/analysis.json').read_text());assert a['results']['ordered']['verdict']==a['results']['append']['verdict']=='NOT ADMITTED';assert len(a['results']['ordered']['failures'])==10 and len(a['results']['append']['failures'])==15
assert json.loads((r/'raw/core-lines.json').read_text())['core_non_test_code_lines']==38710
print(f'verified {len(m)} files, 288 processes/110592 measured updates; Ordered and Append NOT ADMITTED; raw retained')
