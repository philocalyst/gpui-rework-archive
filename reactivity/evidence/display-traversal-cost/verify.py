from pathlib import Path
import json,hashlib,subprocess,sys,tempfile,statistics,math
h=Path(__file__).resolve().parent
def sha(p):
 with p.open('rb') as f:return hashlib.file_digest(f,'sha256').hexdigest()
def read(p):return json.loads(p.read_text())
m=read(h/'MANIFEST.json')
for n,s in m.items():assert sha(h/n)==s,n
r=h/'raw';b=r/'initial';t=r/'six-rounds'
assert read(b/'guard.json')==read(t/'guard.json')==[]
assert (b/'source.txt').read_text().strip()==read(t/'source.json')['source']=='e5720235ea0952c160eb803de99f4ee15faac795'
for x in b.glob('*.status.json'):assert read(x)['exit']==0
preflights=list(b.glob('preflight-*/result.json'));assert len(preflights)==45
for p in preflights:
 d=read(p);assert len(d['preflight'])==12 and d['all_fenced_heap_allocations_released'] and d['ledger']['index_steady_work']=={}
assert read(t/'dataset-before.json')==read(t/'dataset-after.json')==read(b/'public-digests.json')
for n,s in read(t/'dataset-before.json').items():assert sha(b/'public'/n)==s
artifacts=read(b/'artifacts.json')
for x in artifacts.values():assert sha(Path(x['preserved']))==x['sha256']
elf=Path(artifacts['cost_worker']['preserved']).read_bytes()
for n,x in read(b/'shaders.json').items():
 shader=(h/'frozen/src'/f'{n}.wgsl').read_bytes();assert hashlib.sha256(shader).hexdigest()==x['sha256'] and elf[x['elf_offset']:x['elf_offset']+len(shader)]==shader
for line in (b/'build.out').read_text().splitlines():
 d=json.loads(line)
 if d.get('reason')=='compiler-artifact' and '/reactivity/crates/' in d.get('manifest_path',''):assert not d['fresh']
with tempfile.TemporaryDirectory(prefix='traversal-cost-verify-') as tmp:
 p=Path(tmp)/'a.json';subprocess.run([sys.executable,str(r/'analyze.py'),str(t),str(p)],check=True,stdout=subprocess.DEVNULL);assert read(p)==read(r/'analysis.json')
a=read(r/'analysis.json');assert a['measured_samples']==138240 and a['primary_sparse_median_gate_pass'] and not a['regression_median_gate_pass'] and not a['cost_admitted'];assert len(a['regression_violations'])==4
for row in a['rows']:
 ratios=[];raw_ratios=[]
 for i in range(6):
  p={}
  for role in ['indexed','control','raw']:
   d=read(t/f"r{i}-{row['scene']}-{row['n']}-{role}/result.json");v=sorted(x['round_trip_ns'] for x in d['samples']);assert len(v)==512;p[role]=v[math.ceil(.95*len(v))-1]
   if row['n']<=32:assert d['ledger']['spatial'] is None
  ratios.append(p['indexed']/p['control']);raw_ratios.append(p['raw']/p['indexed'])
 assert ratios==row['primary_p95_ratios'] and raw_ratios==row['raw_vs_indexed_p95_ratios']
 assert statistics.median(ratios)==row['median_primary_p95_ratio'] and statistics.median(raw_ratios)==row['median_raw_vs_indexed_p95_ratio']
print(json.dumps(dict(files=len(m),processes=270,samples=138240,preflights=45,all_guards=True,overall_cost_admitted=False,verified=True)))
