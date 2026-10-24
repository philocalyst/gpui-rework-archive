from pathlib import Path
import argparse,hashlib,json,mmap
p=argparse.ArgumentParser();p.add_argument('--build',type=Path,required=True);p.add_argument('--out',type=Path,required=True);a=p.parse_args()
assert json.loads((a.build/'result.json').read_text())['exit']==0
rows=[json.loads(x) for x in (a.build/'stdout.log').read_text().splitlines()]
generated=[r for r in rows if r.get('reason')=='build-script-executed' and '#gpui_gpu@' in r.get('package_id','')];assert len(generated)==1,generated
shader=Path(generated[0]['out_dir'])/'ui.wgsl';data=shader.read_bytes();digest=hashlib.sha256(data).hexdigest()
control_rows=[json.loads(x) for x in Path('/tmp/gpui-clips-gradient-root-final-build/stdout.log').read_text().splitlines()]
control=[r for r in control_rows if r.get('reason')=='build-script-executed' and '#gpui_gpu@' in r.get('package_id','')];assert len(control)==1
control_shader=Path(control[0]['out_dir'])/'ui.wgsl';assert data==control_shader.read_bytes()
proofs=[]
for row in rows:
 if row.get('reason')!='compiler-artifact' or not row.get('executable') or not row['profile']['test'] or not (row['target']['name']=='gpui' or (row['target']['name']=='render' and '#gpui_gpu@' in row['package_id'])):continue
 binary=Path(row['executable'])
 with binary.open('rb') as f:
  with mmap.mmap(f.fileno(),0,access=mmap.ACCESS_READ) as mapping:assert mapping.find(data)>=0, binary
 with binary.open('rb') as f:elfhash=hashlib.file_digest(f,'sha256').hexdigest()
 proofs.append({'ELF':str(binary),'target':row['target']['name'],'sha256':elfhash,'complete_generated_WGSL_in_ELF':True})
assert len(proofs)>=1
report={'source':json.loads((a.build/'result.json').read_text())['source'],'shader':str(shader),'wgsl_sha256':digest,'wgsl_bytes':len(data),'matches_frozen_root_d3e6885_generated_shader':True,'artifacts':proofs}
a.out.write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report),flush=True)
