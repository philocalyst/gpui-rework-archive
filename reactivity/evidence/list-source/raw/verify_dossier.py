from pathlib import Path
import hashlib,json,re
root=Path(__file__).resolve().parent;raw=root/'raw'
manifest=json.loads((root/'manifest.json').read_text())
for name,h in manifest.items():assert hashlib.sha256((root/name).read_bytes()).hexdigest()==h,name
for name,count,ignored in [('full-final',989,13),('native-final',1063,44)]:
 d=raw/name
 for stage in ['test','clippy']:
  assert json.loads((d/f'{stage}.status.json').read_text())['exit']==0
 s=(d/'test.out').read_text();assert sum(map(int,re.findall(r'(\d+) passed',s)))==count
 assert sum(map(int,re.findall(r'(\d+) ignored',s)))==ignored
 assert json.loads((d/'guard-after.json').read_text())==[]
assert '8 passed; 0 failed' in (raw/'native-final/port.out').read_text()
assert json.loads((raw/'native-final/build.status.json').read_text())['exit']==0
for stage in ['unit-build','clippy']:assert json.loads((raw/f'native-pointer-corrected/{stage}.status.json').read_text())['exit']==0
for name in ['native-checks-pointer-corrected','native-checks-corrected']:
 d=raw/name;statuses=list(d.glob('*.status.json'));assert len(statuses)==(11 if 'pointer' in name else 5)
 for p in statuses:assert json.loads(p.read_text())['exit']==0
 assert json.loads((d/'guard-after.json').read_text())==[]
for p in raw.rglob('guard-after.json'):assert json.loads(p.read_text())==[],str(p)
assert json.loads((raw/'epoch-before/test.status.json').read_text())['exit']==101
assert 'left: 2\n right: 1' in (raw/'epoch-before/test.log').read_text()
assert '0 passed; 1 failed' in (raw/'negative/test.out').read_text()
assert json.loads((raw/'core-lines-final.json').read_text())['core_non_test_code_lines']==36962
assert 'ListState=120' in (raw/'ledgers/candidate-viewport.out').read_text()
assert 'Extra=56' in (raw/'ledgers/candidate-metadata.out').read_text()
for i in range(4):assert json.loads((raw/f'list-allocation-ledgers/mode-{i}.status.json').read_text())['exit']==0
# Executed negative, final allocation and native executables must remain exact.
for name in ['epoch-before/artifact.json','list-allocation-ledgers/artifact.json','negative/artifact.json']:
 a=json.loads((raw/name).read_text());assert hashlib.sha256(Path(a['path']).read_bytes()).hexdigest()==a['sha256']
for p in raw.glob('*unit-preservation.json'):
 a=json.loads(p.read_text());assert hashlib.sha256(Path(a['preserved']).read_bytes()).hexdigest()==a['original']['sha256']
a=json.loads((raw/'native-final-example-preservation.json').read_text());assert hashlib.sha256(Path(a['preserved']).read_bytes()).hexdigest()==a['original']['sha256']
print(f'verified {len(manifest)} files; correctness/cost qualification only, no speed verdict')
