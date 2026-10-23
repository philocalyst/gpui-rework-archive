from pathlib import Path
import gzip
import hashlib
import json
import re
import shutil
import subprocess

source=Path('/tmp/gpui-short-text-root')
pin='3d6bbcde4b67b9e99fe35b23db3bf216a79835f8'
git=['git','-c',f'safe.directory={source}','-C',str(source)]
assert subprocess.check_output(git+['rev-parse','HEAD'],text=True).strip()==pin
assert not subprocess.check_output(git+['status','--porcelain'],text=True).strip()
destination=Path('/root/gpui-ce3/reactivity/evidence/word-text')
assert not destination.exists()
qualification=Path('/tmp/gpui-short-text-qualification-3d6')
miri=Path('/tmp/gpui-short-text-miri-3d6')
for directory in [qualification,miri]:
    assert json.loads((directory/'before.json').read_text())==json.loads((directory/'after.json').read_text())
    for name,expected in json.loads((directory/'before.json').read_text()).items():
        assert hashlib.sha256(Path(name).read_bytes()).hexdigest()==expected,name
    results=json.loads((directory/'results.json').read_text())
    assert all(row['exit']==0 for row in results)
for target in ['x86_64','i686','s390x']:
    for model in ['stacked','tree']:
        data=(miri/f'{target}-{model}.log').read_text()
        rows=re.findall(r'test result: ok\. (\d+) passed; (\d+) failed; (\d+) ignored;',data)
        assert sum(int(row[0]) for row in rows)==2 and all(row[1:] == ('0','0') for row in rows)
negative=[]
for name,fault,diagnostic in [
    ('drop','66bbf8fb42e55d56d7936b8bd821ce5d7ba579b1','has been freed'),
    ('address','693dd7493e5ff930e3fbb6199d981844fb916311','has no provenance'),
]:
    directory=Path('/tmp/gpui-short-text-negative-evidence')/name
    report=json.loads((directory/'result.json').read_text())
    assert report['source']==fault and report['exit']==1 and report['guards_match']
    assert diagnostic in (directory/'stderr.log').read_text()
    assert 'Undefined Behavior' in (directory/'stderr.log').read_text()
    before=json.loads((directory/'before.json').read_text())
    after=json.loads((directory/'after.json').read_text())
    assert before==after
    tree=Path(f'/tmp/gpui-short-text-{name}-negative')
    for path,expected in before.items():
        assert hashlib.sha256((tree/path).read_bytes()).hexdigest()==expected
    negative.append({'name':name,'source':fault,'exit':1,'diagnostic':diagnostic})

destination.mkdir(parents=True)
payloads={}
def copy_file(original,relative):
    raw=original.read_bytes()
    compressed=len(raw)>=20000
    target=destination/(relative+'.gz' if compressed else relative)
    target.parent.mkdir(parents=True,exist_ok=True)
    target.write_bytes(gzip.compress(raw,mtime=0) if compressed else raw)
    assert (gzip.decompress(target.read_bytes()) if compressed else target.read_bytes())==raw
    payloads[str(target.relative_to(destination))]={'original':str(original),'bytes':len(raw),'sha256':hashlib.sha256(raw).hexdigest(),'stored_sha256':hashlib.sha256(target.read_bytes()).hexdigest(),'compression':'gzip mtime=0' if compressed else None}

for name in subprocess.check_output(git+['ls-files'],text=True).splitlines():
    copy_file(source/name,'source/'+name)
for label,directory in [('nightly',qualification),('miri',miri),('negative',Path('/tmp/gpui-short-text-negative-evidence'))]:
    for path in sorted(directory.rglob('*')):
        if path.is_file():copy_file(path,label+'/'+str(path.relative_to(directory)))
for name,fault,_ in [('drop','66bbf8fb42e55d56d7936b8bd821ce5d7ba579b1',None),('address','693dd7493e5ff930e3fbb6199d981844fb916311',None)]:
    patch=subprocess.check_output(git+['diff','--binary',pin,fault])
    target=destination/'negative'/f'{name}.patch'
    target.write_bytes(patch)
    payloads[str(target.relative_to(destination))]={'bytes':len(patch),'sha256':hashlib.sha256(patch).hexdigest(),'stored_sha256':hashlib.sha256(patch).hexdigest(),'compression':None}
for name in ['verified-download.json','nix-adaptation.json','fetch.log','install.log']:
    copy_file(Path('/tmp/gpui-shorttext-miri-provision')/name,'toolchain/'+name)
for path in ['/tmp/gpui-qualify-shorttext-root.py','/tmp/gpui-shorttext-miri-runs-root.py','/tmp/gpui-run-frozen-gate-root.py','/tmp/gpui-provision-shorttext-miri.py','/tmp/gpui-resume-shorttext-miri-tools.py','/tmp/gpui-resume-shorttext-miri-tools-v2.py','/tmp/gpui-shorttext-miri-provision-root.log','/tmp/gpui-shorttext-miri-tools-resume.log','/tmp/gpui-shorttext-miri-tools-resume-v2.log','/tmp/gpui-short-text-first-test.log']:
    copy_file(Path(path),'support/'+Path(path).name)
copy_file(Path('/tmp/gpui-short-text-luna/findings.md'),'adversarial-review.md')
copy_file(Path(__file__),'verify-and-archive-root.py')
external=[]
for path in ['/tmp/gpui-shorttext-miri-tools/bin/miri','/tmp/gpui-shorttext-miri-tools/bin/cargo-miri','/tmp/gpui-nightly-2026-10-23/bin/rustc','/tmp/gpui-nightly-2026-10-23/bin/cargo','/tmp/gpui-shorttext-miri-provision/miri-nightly-x86_64-unknown-linux-gnu.tar.xz']:
    file=Path(path)
    with file.open('rb') as stream:digest=hashlib.file_digest(stream,'sha256').hexdigest()
    external.append({'path':path,'bytes':file.stat().st_size,'sha256':digest})
(destination/'payloads.json').write_text(json.dumps(payloads,indent=2)+'\n')
(destination/'external-files.json').write_text(json.dumps(external,indent=2)+'\n')
report={'source':pin,'genuine_nightly':'1.101.0-nightly 7189d39d9','bootstrap':False,'normal_tests':3,'strict_exit':0,'miri_targets':['x86_64-unknown-linux-gnu','i686-unknown-linux-gnu','s390x-unknown-linux-gnu'],'borrowing_models':['Stacked Borrows','Tree Borrows'],'miri_tests_per_target_model':2,'strict_provenance':True,'symbolic_alignment':True,'negative_controls':negative,'payload_files':len(payloads),'external_files':len(external),'production_adopted':False,'blockers':['Target-byte representation whitelist/fallback not implemented','Heap clone equality pointer shortcut missing','Matched whole-code/application costs and timing absent']}
(destination/'root-verification.json').write_text(json.dumps(report,indent=2)+'\n')
print(json.dumps(report,indent=2),flush=True)
