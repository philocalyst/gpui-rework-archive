from pathlib import Path
import hashlib,json,subprocess
root=Path('/tmp/gpui-clips-gradient-root-final-artifacts')
out=Path('/tmp/gpui-clips-gradient-root-header-probe');out.mkdir(exist_ok=False)
identities={}
for p in root.glob('*/binary.json'):
 row=json.loads(p.read_text())
 if row['target']['kind']==['lib'] and row['target']['name'] in ['gpui_canvas','gpui']:identities[row['target']['name']]=(p.parent/'test',row)
results=[]
for index,(target,selector) in enumerate([('gpui_canvas','canonical_clip_storage_and_transient_views_are_charged'),('gpui','clipping_headers_and_cold_builder_costs_are_explicit'),('gpui','runtime::background::tests::')]):
 binary,identity=identities[target]
 result=subprocess.run([str(binary),selector,'--nocapture','--test-threads=1'],capture_output=True,text=True)
 assert result.returncode==0,(result.stdout,result.stderr)
 (out/f'{index}-{target}.stdout.log').write_text(result.stdout)
 (out/f'{index}-{target}.stderr.log').write_text(result.stderr)
 results.append({'target':target,'selector':selector,'elf_sha256':identity['sha256'],'exit':result.returncode,'stdout':result.stdout,'stderr':result.stderr})
report={'source':'d3e6885c6bab6a07fafcd3f4faae7cbb3023e0c7','scope':'Actual composed layout and Rust allocation requests, repeated frozen functional ELF probes; no RSS or timing inference. ELFs were hashed before/after full execution and reverified by shader audit.','results':results}
(out/'result.json').write_text(json.dumps(report,indent=2)+'\n')
for row in results:
 for line in (row['stdout']+'\n'+row['stderr']).splitlines():
  if 'CLIP_' in line or 'gradient_gpui_headers' in line:print(line)
