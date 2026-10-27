from pathlib import Path
import json,hashlib,re
root=Path(__file__).resolve().parent;raw=root/'raw'
manifest=json.loads((root/'manifest.json').read_text())
for name,h in manifest.items():assert hashlib.sha256((root/name).read_bytes()).hexdigest()==h,name
for p in raw.rglob('guard-after.json'):assert json.loads(p.read_text())==[],str(p)
for name,count,ignored in [('corrected-default',991,13),('corrected-native',1065,44)]:
 for stage in ['test','clippy']:assert json.loads((raw/name/(stage+'.status.json')).read_text())['exit']==0
 rows=re.findall(r'test result: ok\. (\d+) passed; (\d+) failed; (\d+) ignored',(raw/name/'test.out').read_text());assert [sum(int(a[i]) for a in rows) for i in range(3)]==[count,0,ignored],(name,rows)
assert '10 passed; 0 failed' in (raw/'corrected-native/port.out').read_text()
assert json.loads((raw/'corrected-native/build.status.json').read_text())['exit']==0
for stage in ['test','clippy']:assert json.loads((raw/'corrected-first'/(stage+'.status.json')).read_text())['exit']==0
assert '2 passed; 0 failed' in (raw/'corrected-first/test.out').read_text()
assert json.loads((raw/'baseline-first/test.status.json').read_text())['exit']==101
assert '0 passed; 2 failed' in (raw/'baseline-first/test.out').read_text()
assert 'first differing byte (index, actual, expected)' in (raw/'baseline-first/test.log').read_text()
statuses=list((raw/'native-checks').glob('*.status.json'));assert len(statuses)==11
for s in statuses:assert json.loads(s.read_text())['exit']==0
assert json.loads((raw/'core-lines-candidate.json').read_text())['core_non_test_code_lines']==36962
seen=set()
for stage in ['baseline-first','corrected-first','corrected-default','corrected-native']:
 for a in json.loads((raw/stage/'artifacts.json').read_text()):
  if a['sha256'] in seen:continue
  assert hashlib.sha256(Path(a['preserved']).read_bytes()).hexdigest()==a['sha256'];seen.add(a['sha256'])
a=json.loads((raw/'corrected-native/artifact.json').read_text());assert hashlib.sha256(Path(a['preserved']).read_bytes()).hexdigest()==a['sha256']
print(f'verified {len(manifest)} files; baseline pixel failure; 991 default/1065 X11 tests, 10 port tests, 11 actual native scripts; {len(seen)} distinct preserved test ELFs')
