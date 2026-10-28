from pathlib import Path
import json,hashlib,subprocess,shutil,csv
root=Path('/root/gpui-cephal-hidden-marker'); cap=Path('/tmp/gpui-cephal-hidden-captures');cap.mkdir(exist_ok=True);old=Path('/tmp/gpui-cephal-hidden-control')
h=lambda p:hashlib.sha256(Path(p).read_bytes()).hexdigest()
base=json.loads((old/'pins.json').read_text())
for p,v in base['binary_hashes'].items():assert h(p)==v
for p,v in base['sources'].items():
 if '/tmp/gpui-cephal-hidden-driver/' in p or p.endswith('/tests/layout/hidden.rs'):assert h(p)==v,p
shipping=['reactivity/crates/core/src/layout.rs','reactivity/crates/core/tests/layout/hidden.rs','reactivity/vendor/cephal/src/tree/traits.rs','reactivity/vendor/cephal/src/compute/mod.rs','reactivity/vendor/cephal/src/tree/cache/mod.rs','reactivity/vendor/cephal/GPUI-PROVENANCE.json','reactivity/Cargo.lock']
sources={str(root/p):h(root/p) for p in shipping}
for p in shipping:assert h(root/p)==hashlib.sha256(subprocess.check_output(['git','show','63d2327b68:'+p],cwd=root)).hexdigest(),p
artifacts=[]
for line in (cap/'build.jsonl').read_text().splitlines():
 try:a=json.loads(line)
 except ValueError:continue
 if a.get('reason')!='compiler-artifact':continue
 if a['target']['name'] in ['cephal','gpui_reactivity_core','gpui-cephal-hidden-driver']:
  artifacts.append(a)
  assert 'verify-cache' not in a['features']
  for f in a['filenames']:
   p=Path(f)
   if p.suffix=='.rlib':shutil.copy2(p,cap/p.name)
 if a.get('executable'):shutil.copy2(a['executable'],cap/'driver')
sourceguards={**sources,**{p:v for p,v in base['sources'].items() if '/tmp/gpui-cephal-hidden-driver/' in p}}
binaries={str(p):h(p) for p in cap.iterdir() if p.name=='driver' or p.suffix=='.rlib'};binaries.update(base['binary_hashes'])
def guard():
 for p,v in {**sourceguards,**binaries}.items():assert h(p)==v,p
rows=[]
for rep in range(3):
 for mode in ['empty','ordinary','hidden','warm-hide']:
  for variant in (['baseline','flags'] if rep%2==0 else ['flags','baseline']):
   guard(); exe=old/'driver' if variant=='baseline' else cap/'driver';prefix=cap/f'{rep}-{mode}-{variant}'
   with prefix.with_suffix('.csv').open('wb') as out,prefix.with_suffix('.stderr').open('wb') as err:subprocess.run([str(exe),mode],stdout=out,stderr=err,check=True)
   guard()
   for r in csv.DictReader(prefix.with_suffix('.csv').open()):rows.append(dict(rep=rep,mode=mode,variant=variant,stage=r.pop('stage'),**{k:int(v) for k,v in r.items()}))
for row in [r for r in rows if r['variant']=='flags']:
 control=next(r for r in rows if r['variant']=='baseline' and all(r[k]==row[k] for k in ['rep','mode','stage']))
 for key in ['computed','cached','measured','changed']:assert row[key]==control[key],(key,row,control)
 if row['mode']!='hidden' or row['stage']=='construct':
  for key in ['retained','total','peak','calls','caches','cache_heap']:assert row[key]==control[key],(key,row,control)
 if row['mode']=='hidden' and row['stage']=='compute':
  for key in ['retained','total','cache_heap']:assert row[key]-control[key]==-360000,(key,row,control)
  for key in ['calls','caches']:assert row[key]-control[key]==-1000,(key,row,control)
guard()
(cap/'results.json').write_text(json.dumps({'source_commit':'63d2327b68','base_commit':base['base_commit'],'sources':sourceguards,'binaries':binaries,'artifacts':artifacts,'rows':rows,'guards_passed':True,'work_equal':True,'empty_ordinary_warm_hide_allocation_equal':True,'hidden_compute_payload_delta':-360000,'hidden_compute_call_delta':-1000,'hidden_compute_peak_deltas':[r['peak']-next(b['peak'] for b in rows if b['variant']=='baseline' and b['mode']=='hidden' and b['stage']=='compute' and b['rep']==r['rep']) for r in rows if r['variant']=='flags' and r['mode']=='hidden' and r['stage']=='compute']},indent=2)+'\n')
print('24freshprocesses, allcoldoracles, workequality andallocationassertionspassed')
for r in rows:
 if r['rep']==0 and r['mode']=='hidden':print(r)
