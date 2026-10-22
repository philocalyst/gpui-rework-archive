from pathlib import Path
import csv,hashlib,json,os,subprocess,time
base=Path('/tmp/gpui-text-map-query-controls');manifest=json.loads((base/'artifacts.json').read_text())
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def guard():
 for variant,item in manifest.items():
  assert sha(item['binary'])==item['sha256'],variant
  root=Path('/root/gpui-text-map-capacity' if variant=='24trim' else '/root/gpui-text-map-12')
  assert subprocess.check_output(['git','rev-parse','HEAD'],cwd=root,text=True).strip()==item['source']
  for file,digest in item['source_files_sha256'].items():assert sha(root/file)==digest,(variant,file)
assert manifest['24trim']['sha256']!=manifest['12trim']['sha256']
assert manifest['24trim']['source_files_sha256']['reactivity/crates/canvas/examples/selection_queries.rs']==manifest['12trim']['source_files_sha256']['reactivity/crates/canvas/examples/selection_queries.rs']
assert manifest['24trim']['source_files_sha256']['reactivity/Cargo.lock']==manifest['12trim']['source_files_sha256']['reactivity/Cargo.lock']
cpu=min(os.sched_getaffinity(0));rows=[];begin=time.monotonic();guard()
for paragraphs,rounds in [(1,30000),(1800,300)]:
 for pair in range(7):
  outputs={}
  for variant in (['24trim','12trim'] if pair%2==0 else ['12trim','24trim']):
   guard()
   output=subprocess.check_output(['taskset','-c',str(cpu),manifest[variant]['binary'],str(rounds),str(paragraphs)],text=True)
   parsed=list(csv.DictReader(output.splitlines()));outputs[variant]={row['case']:tuple(row[key] for key in ['bytes','lines','rounds','signature']) for row in parsed}
   for row in parsed:rows.append({'variant':variant,'pair':pair,'paragraphs':paragraphs,'cpu':cpu,**row})
  assert outputs['24trim']==outputs['12trim'],outputs
 guard()
with (base/'queries.csv').open('w') as file:
 writer=csv.DictWriter(file,fieldnames=list(rows[0]));writer.writeheader();writer.writerows(rows)
print(f'END {len(rows)} records, CPU{cpu}, {time.monotonic()-begin:.3f}s; all source/binary/signature guards pass')
