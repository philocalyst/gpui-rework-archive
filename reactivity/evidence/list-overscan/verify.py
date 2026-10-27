from pathlib import Path
import json,hashlib,re,subprocess
root=Path(__file__).resolve().parent;raw=root/'raw'
def digest(p):return hashlib.sha256(p.read_bytes()).hexdigest()
manifest=json.loads((root/'manifest.json').read_text())
for name,h in manifest.items():assert digest(root/name)==h,name
def counts(path):
 rows=re.findall(r'test result: (?:ok|FAILED)\. (\d+) passed; (\d+) failed; (\d+) ignored;',path.read_text())
 assert rows,path
 return tuple(sum(int(x[i]) for x in rows) for i in range(3))
def status(path,code=0):assert json.loads(path.read_text())['exit']==code,path
for name,expected,code in [('focused-first',(21,2,0),101),('focused-diagnostic',(21,2,0),101),('focused-clipping',(23,0,0),0),('full-first',(529,1,7),101),('full-qualified',(974,0,13),0),('native-first',(1048,0,43),0),('final-ledger',(1,0,0),0)]:
 assert counts(raw/name/'test.out')==expected,(name,counts(raw/name/'test.out'))
 status(raw/name/'test.status.json',code)
for name in ['full-qualified','native-first','final-ledger']:status(raw/name/'clippy.status.json')
for name in ['build','port']:status(raw/'native-first'/(name+'.status.json'))
assert counts(raw/'native-first/port.out')==(8,0,0)
for p in raw.rglob('guard-after.json'):assert json.loads(p.read_text())==[],p
checks=list((raw/'native-checks').glob('*.status.json'));assert len(checks)==10
for p in checks:status(p);assert counts(p.with_name(p.name.replace('.status.json','.out')))==(1,0,0)
# The same wrong-key mutant passes images, but fails authority and keyed bounds.
status(raw/'negative/test.status.json');assert counts(raw/'negative/test.out')==(1,0,0)
negative=list((raw/'negative-authority').glob('*.status.json'));assert len(negative)==2
for p in negative:
 status(p,101);assert counts(p.with_name(p.name.replace('.status.json','.out')))==(0,1,0)
 assert 'assertion `left == right` failed' in p.with_name(p.name.replace('.status.json','.log')).read_text()
for p in (raw/'ledgers').glob('*.status.json'):status(p);assert counts(p.with_name(p.name.replace('.status.json','.out')))==(1,0,0)
preserved=json.loads((raw/'native-unit-preservation.json').read_text())
def artifact(a):
 p=Path(a['path'])
 if not p.is_file() or digest(p)!=a['sha256']:
  assert a['sha256']==preserved['original']['sha256'],p
  p=Path(preserved['preserved'])
 assert digest(p)==a['sha256'] and p.stat().st_size==a['bytes'],p
 return p
for p in [raw/'native-first/artifact.json',raw/'native-checks/artifact.json',raw/'negative-authority/artifact.json',*list((raw/'ledgers').glob('*-artifact.json'))]:artifact(json.loads(p.read_text()))
machine=json.loads((raw/'machine-final/summary.json').read_text())
for name,row in machine.items():
 p=artifact(row['artifact']);nm=subprocess.check_output(['nm','-S','-C',str(p)],text=True)
 for f in row['functions']:
  assert any(line.split(maxsplit=3)[-1]==f['symbol'] and int(line.split()[1],16)==f['bytes'] for line in nm.splitlines() if len(line.split(maxsplit=3))==4),f
candidate=machine['candidate'];assert candidate['artifact']['bytes']==26281296
assert next(f for f in candidate['functions'] if f['symbol']=='gpui::runtime::list::plan')['bytes']==2178
inventory=json.loads((raw/'final-core-lines.json').read_text());assert inventory['source_commit'].startswith('f760f319d9') and inventory['core_non_test_code_lines']==36699
ledger=(raw/'final-ledger/test.out').read_text();assert 'ListSpec=56 AnnotationDraft=56 ListPlan=136 ListDraft=176' in ledger
assert 'ListRow=32' in ledger and 'Extra=64' in ledger
print(f'verified {len(manifest)} files, 974 default/1048 X11 tests, ten actual native scripts, same-binary negative authority witnesses, costs and source guards')
