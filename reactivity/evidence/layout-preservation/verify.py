from pathlib import Path
import json,hashlib,shutil,subprocess,tempfile
r=Path(__file__).parent
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
m=json.loads((r/'MANIFEST.json').read_text())
assert set(m)=={p.relative_to(r).as_posix() for p in r.rglob('*') if p.is_file() and p.name!='MANIFEST.json'}
for n,h in m.items():assert sha(r/n)==h,n
for cohort, gates in [('core-first',['build','tests','clippy']),('integration-third',['build','tests','clippy'])]:
 b=r/'raw'/cohort
 for g in gates:assert json.loads((b/(g+'.status.json')).read_text())['exit']==0
 assert json.loads((b/'guard.json').read_text())==[]
 a=json.loads((b/'artifact.json').read_text());elf=Path(a['preserved']).read_bytes();assert hashlib.sha256(elf).hexdigest()==a['sha256'] and len(elf)==a['bytes'] and not a['cargo_fresh']
b=r/'raw/integration-third'
a=json.loads((b/'artifact.json').read_text());elf=Path(a['preserved']).read_bytes();shader=(b/'ui.wgsl').read_bytes()
for s in json.loads((b/'shaders.json').read_text()).values():assert hashlib.sha256(shader).hexdigest()==s['sha256'] and elf[s['elf_offset']:s['elf_offset']+s['bytes']]==shader
for cohort,driver in [('core-first','core-gate.py'),('integration-first','integration-gate.py'),('integration-second','integration-second-gate.py'),('integration-third','integration-third-gate.py')]:
 d=r/'raw'/cohort;assert json.loads((d/'guard.json').read_text())==[];assert json.loads((d/'driver.json').read_text())['sha256']==sha(r/'raw'/driver)
assert json.loads((r/'raw/integration-first/build.status.json').read_text())['exit']==101
assert json.loads((r/'raw/integration-second/tests.status.json').read_text())['exit']==101
assert (r/'source.txt').read_bytes()==(b/'source.txt').read_bytes()
inputs=json.loads((b/'inputs-before.json').read_text())
for p in (r/'frozen').rglob('*'):
 if p.is_file():assert sha(p)==inputs[p.relative_to(r/'frozen').as_posix()]
for case in json.loads((b/'live/trace.json').read_text()):
 for step in sorted({f['step'] for f in case['frames']}):
  frames=[(b/'live'/f"{case['case']}-{mode}-{step}.rgba").read_bytes() for mode in ['Automatic','Ordered','Append','Forced']]
  assert all(len(x)==16384 and x==frames[0] for x in frames)
with tempfile.TemporaryDirectory(prefix='gpui-layout-preserve-verify-') as t:
 t=Path(t);shutil.copy2(r/'raw/analyze.py',t/'analyze.py');subprocess.run(['python3',str(t/'analyze.py'),str(b)],check=True)
 assert (t/'analysis.json').read_bytes()==(r/'raw/analysis.json').read_bytes()
assert json.loads((r/'raw/core-lines.json').read_text())['core_non_test_code_lines']==38710
print(f'verified {len(m)} files; core and 84 CPU layout/pixel frames plus authority/routing gates PASS; no adoption/timing/GPU parity claim')
