from pathlib import Path
import json,subprocess,hashlib,re
r=Path(__file__).parent;out=r/'headers';out.mkdir(exist_ok=False)
a=json.loads((r/'full-native-initial/unit-artifact.json').read_text());old=json.loads(Path('/home/user/gpui-patch-workspace-evidence/matrix-artifacts.json').read_text())['candidate'];rows={}
for name,artifact in [('baseline',old),('candidate',a)]:
 p=Path(artifact['preserved']);assert hashlib.file_digest(p.open('rb'),'sha256').hexdigest()==artifact['sha256'];values={}
 for i,test in enumerate(['runtime::damage_header_ledger::runtime_damage_headers','runtime::semantic_storage_ledger::sparse_metadata_storage_and_cold_allocation_ledger','native::tests::packet_gpu_header_ledger','runtime::patch_workspace_tests::workspace_reuses_allocation_retires_payload_and_is_reclaimed_with_text']):
  cmd=[str(p),test,'--exact','--nocapture','--test-threads=1'];q=subprocess.run(cmd,capture_output=True,text=True);stem=out/f'{name}-{i}';stem.with_suffix('.out').write_text(q.stdout);stem.with_suffix('.log').write_text(q.stderr);stem.with_suffix('.status.json').write_text(json.dumps(dict(command=cmd,exit=q.returncode,sha256=artifact['sha256'])));assert q.returncode==0 and '1 passed; 0 failed' in q.stdout
  values.update({k:int(v) for k,v in re.findall(r'([A-Za-z_]+)=(\d+)',q.stdout+q.stderr)})
 rows[name]=values
for key in ['RuntimeUnit','Prepared','TextPatch','TextResources','SceneDamage']:assert rows['baseline'][key]==rows['candidate'][key],key
(out/'summary.json').write_text(json.dumps(rows,indent=2));print({k:rows['candidate'][k] for k in ['RuntimeUnit','Prepared','TextPatch','TextResources','SceneDamage']})
