from pathlib import Path
import json,subprocess,hashlib
root=Path(__file__).resolve().parent;out=root/'ledgers';out.mkdir(exist_ok=False)
preserve=json.loads((root/'native-unit-preservation.json').read_text());candidate={**preserve['original'],'path':preserve['preserved']};control=json.loads(Path('/home/user/gpui-line-height-evidence/native-checks/artifact.json').read_text())
for name,a in [('candidate',candidate),('control',control)]:
 p=Path(a['path']);assert hashlib.sha256(p.read_bytes()).hexdigest()==a['sha256'];(out/(name+'-artifact.json')).write_text(json.dumps(a,indent=2))
 for label,test,ignored in [('metadata','runtime::semantic_storage_ledger::sparse_metadata_storage_and_cold_allocation_ledger',False),('viewport','runtime::scroll::tests::viewport_storage_and_allocation_ledger',True)]:
  cmd=[str(p),test,'--exact','--nocapture','--test-threads=1']+(['--ignored'] if ignored else []);r=subprocess.run(cmd,capture_output=True,text=True);(out/(name+'-'+label+'.out')).write_text(r.stdout);(out/(name+'-'+label+'.log')).write_text(r.stderr);(out/(name+'-'+label+'.status.json')).write_text(json.dumps({'command':cmd,'exit':r.returncode}));assert r.returncode==0 and '1 passed; 0 failed' in r.stdout
 assert hashlib.sha256(p.read_bytes()).hexdigest()==a['sha256']
print('four complete allocation/header ledgers passed')
