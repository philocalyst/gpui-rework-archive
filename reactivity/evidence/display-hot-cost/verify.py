from pathlib import Path
import json,hashlib,subprocess,sys,tempfile,math,statistics
here=Path(__file__).resolve().parent

def sha(p):
 with p.open('rb') as f:return hashlib.file_digest(f,'sha256').hexdigest()
def read(p):return json.loads(p.read_text())
m=read(here/'MANIFEST.json')
for n,h in m.items():assert sha(here/n)==h,n
raw=here/'raw';initial=raw/'initial';timing=raw/'six-rounds'
assert read(initial/'guard.json')==read(timing/'guard.json')==[]
artifacts=read(initial/'artifacts.json')
for item in artifacts.values():assert sha(Path(item['preserved']))==item['sha256']
elf=Path(artifacts['cost_worker']['preserved']).read_bytes()
for name,meta in read(initial/'shaders.json').items():
 shader=(here/'frozen'/f'{name}.wgsl').read_bytes();assert hashlib.sha256(shader).hexdigest()==meta['sha256'];assert elf[meta['elf_offset']:meta['elf_offset']+len(shader)]==shader
assert read(initial/'clippy.status.json')['exit']==0
preflights=list(initial.glob('preflight-*/result.json'))+list(timing.glob('logging-preflight-*/result.json'));assert len(preflights)==33
for p in preflights:
 d=read(p);assert d['mode']=='preflight' and len(d['preflight'])==12 and d['all_fenced_heap_allocations_released']
for name,entry in read(raw/'post-timing-inputs.json')['generated_public_inputs'].items():
 assert sha(raw/name)==entry['sha256'];assert max(entry['mtime_ns'],entry['ctime_ns'])/1e9<read(raw/'post-timing-inputs.json')['timing_first_start_unix']
for p in initial.glob('*.status.json'):assert read(p)['exit']==0
with tempfile.TemporaryDirectory(prefix='hot-cost-verify-') as t:
 out=Path(t)/'analysis.json';subprocess.run([sys.executable,str(raw/'analyze.py'),str(timing),str(out)],check=True,stdout=subprocess.DEVNULL)
 assert read(out)==read(raw/'analysis.json')
a=read(raw/'analysis.json');assert a['measured_samples']==92160 and a['primary_sparse_median_gate_pass'] and a['median_regression_reading_pass'] and not a['per_round_regression_reading_pass'];assert len(a['regression_violations'])==3
# Separate direct percentile reconstruction from the capture's analysis script.
for row in a['rows']:
 ratios=[]
 for i in range(6):
  p=[]
  for role in ['hot','control']:
   values=sorted(x['round_trip_ns'] for x in read(timing/f"r{i}-{row['scene']}-{row['n']}-{role}/result.json")['samples']);p.append(values[486])
  ratios.append(p[0]/p[1])
 assert ratios==row['primary_p95_ratios'];assert statistics.median(ratios)==row['median_primary_p95_ratio']
print(json.dumps(dict(files=len(m),processes=180,samples=92160,endpoint_preflights=33,source_guards=True,primary_targets_pass=True,conservative_cost_admission=False,verified=True)))
