from pathlib import Path
import subprocess,json,hashlib,re
r=Path(__file__).parent;out=r/'headers';out.mkdir(exist_ok=False)
refs=json.loads((r/'matrix-artifacts.json').read_text());rows={}
for label,a in refs.items():
 p=Path(a['preserved']);assert hashlib.file_digest(p.open('rb'),'sha256').hexdigest()==a['sha256']
 names=['runtime::damage_header_ledger::runtime_damage_headers','runtime::semantic_storage_ledger::sparse_metadata_storage_and_cold_allocation_ledger','native::tests::packet_gpu_header_ledger']
 if label=='candidate':names.append('runtime::patch_workspace_tests::workspace_reuses_allocation_retires_payload_and_is_reclaimed_with_text')
 values={}
 for i,name in enumerate(names):
  cmd=[str(p),name,'--exact','--nocapture','--test-threads=1'];q=subprocess.run(cmd,capture_output=True,text=True)
  stem=out/f'{label}-{i}';stem.with_suffix('.out').write_text(q.stdout);stem.with_suffix('.log').write_text(q.stderr)
  stem.with_suffix('.status.json').write_text(json.dumps(dict(command=cmd,exit=q.returncode,sha256=a['sha256'])))
  assert q.returncode==0 and '1 passed; 0 failed' in q.stdout
  values.update({k:int(v) for k,v in re.findall(r'([A-Za-z_]+)=(\d+)',q.stdout+q.stderr)})
 rows[label]=values
spec=json.loads((r/'cost-definition.json').read_text())
for name,expected in spec['header_gates'].items():
 if name=='TextPatch_without_native':continue
 key='TextPatch' if name=='TextPatch_native' else name
 assert rows['candidate'][key]==expected,(key,rows['candidate'])
(out/'summary.json').write_text(json.dumps(rows,indent=2));print(rows['candidate'])
