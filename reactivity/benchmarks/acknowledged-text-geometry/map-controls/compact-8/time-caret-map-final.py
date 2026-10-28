from pathlib import Path
import csv,hashlib,json,os,subprocess,time
base=Path('/tmp/gpui-text-map-query-final');manifest=json.loads((base/'artifacts.json').read_text())
roots={'24trim':Path('/root/gpui-text-map-capacity'),'12reuse':Path('/root/gpui-text-map-12-line-reuse'),'8fused':Path('/root/gpui-text-map-8-fused')}
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def guard():
 for variant,item in manifest.items():
  assert sha(item['binary'])==item['sha256'],variant
  root=roots[variant];assert subprocess.check_output(['git','rev-parse','HEAD'],cwd=root,text=True).strip()==item['source']
  for file,digest in item['source_files_sha256'].items():assert sha(root/file)==digest,(variant,file)
for file in ['reactivity/Cargo.lock','reactivity/crates/canvas/examples/selection_queries.rs']:
 assert len({item['source_files_sha256'][file] for item in manifest.values()})==1
for variant,item in manifest.items():
 fingerprints=list((Path(item['target'])/'release/.fingerprint').glob('gpui_canvas-*/example-selection_queries.json'))
 assert len(fingerprints)==1,(variant,fingerprints)
 cfg=json.loads(fingerprints[0].read_text());assert cfg['rustflags']==[],(variant,cfg['rustflags']);item['fingerprint']=cfg
(base/'artifacts.json').write_text(json.dumps(manifest,indent=2)+'\n')
cpu=min(os.sched_getaffinity(0));rows=[];begin=time.monotonic();guard();variants=list(manifest)
for paragraphs,rounds in [(1,30000),(1800,300)]:
 for pair in range(7):
  outputs={};order=variants[pair%3:]+variants[:pair%3]
  if pair%2:order=order[::-1]
  for variant in order:
   guard();output=subprocess.check_output(['taskset','-c',str(cpu),manifest[variant]['binary'],str(rounds),str(paragraphs)],text=True)
   parsed=list(csv.DictReader(output.splitlines()));outputs[variant]={r['case']:tuple(r[k] for k in ['bytes','lines','rounds','signature']) for r in parsed}
   for row in parsed:rows.append({'variant':variant,'pair':pair,'paragraphs':paragraphs,'cpu':cpu,**row})
  assert all(value==outputs['24trim'] for value in outputs.values()),outputs
 guard()
with (base/'queries.csv').open('w') as file:
 writer=csv.DictWriter(file,fieldnames=list(rows[0]));writer.writeheader();writer.writerows(rows)
print(f'END {len(rows)} records, CPU{cpu}, {time.monotonic()-begin:.3f}s; all source/binary/flags/signature guards pass')
