from pathlib import Path
import hashlib,json,shutil,subprocess,sys
label,source_pin=sys.argv[1:]
root=Path('/tmp/gpui-coverage-integration-evidence');build=root/(label+'-build')
assert json.loads((build/'result.json').read_text())['exit']==0
assert json.loads((root/(label+'-build-dependencies')/'result.json').read_text())['guards_match']
rows=[json.loads(line) for line in (build/'stdout.log').read_text().splitlines()]
executables=[row for row in rows if row.get('reason')=='compiler-artifact' and row.get('executable')]
assert len(executables)==1 and not executables[0]['fresh']
original=Path(executables[0]['executable']);frozen=root/(label+'-oracle-frozen')
assert not frozen.exists();shutil.copy2(original,frozen);frozen.chmod(0o555)
def digest(path):
    with path.open('rb') as handle:return hashlib.file_digest(handle,'sha256').hexdigest()
identity={'canvas_source':source_pin,'fixture':'35fdf80a1a5d45d6769ca0e5fc8f1c64b3595eb0','original_path':str(original),'frozen_path':str(frozen),'bytes':frozen.stat().st_size,'sha256':digest(frozen)}
(root/(label+'-binary.json')).write_text(json.dumps(identity,indent=2)+'\n')
command=[sys.executable,'/tmp/gpui-freeze-dependencies-root.py','--out',str(root/(label+'-run-dependencies')),'--dependency','/tmp/gpui-coverage-integration-root','--',sys.executable,'/tmp/gpui-run-frozen-gate-root.py','--source','/tmp/gpui-coverage-text-oracle-root','--pin',identity['fixture'],'--out',str(root/(label+'-run')),'--timeout','120','--',str(frozen)]
subprocess.run(command,check=True)
assert digest(frozen)==identity['sha256']
old=Path('/tmp/gpui-hummingbird-browser-allocation-evidence/same-path-control/oracle-baseline-output.txt')
expected_hash='5f17488c73478c4d7271d39f783a8e15cb72c60a8e32ee18a72bf444923f7c39'
assert digest(old)==expected_hash
output=root/(label+'-run')/'stdout.log'
cases=[];metrics=0
with output.open() as handle:
    for line in handle:
        if line.startswith('CASE '):cases.append(int(line.split()[1]))
        if line.startswith('METRIC '):metrics+=1
report={'canvas_source':source_pin,'fixture':identity['fixture'],'old_sha256':expected_hash,'actual_sha256':digest(output),'bytes':output.stat().st_size,'cases':len(cases),'shape_or_error_records':metrics,'stdout_byte_equal':digest(output)==expected_hash,'scope':'Existing shape and interactive layout/error/selection oracle only; no new measurement API, timing or GPU result.'}
(root/(label+'-comparison.json')).write_text(json.dumps(report,indent=2)+'\n')
assert cases==list(range(1120)) and metrics==2240 and report['stdout_byte_equal']
print(json.dumps(report),flush=True)
