import hashlib,json,os,pathlib,subprocess,time
out=pathlib.Path('/tmp/gpui-layout-route-measure');out.mkdir(exist_ok=True)
cpu=sorted(os.sched_getaffinity(0))[7]
os.sched_setaffinity(0,{cpu})
cases=[('styles','',[]),('none','-text',['10000','0','recording']),('sparse','-text',['10000','100','recording']),('sparse_cpu','-text',['10000','100','cpu']),('dense','-text',['10000','1','recording']),('dense_cpu','-text',['10000','1','cpu']),('virtual','-list',['virtual','250000']),('eager','-list',['eager','1000'])]
meta={'baseline_source':'067eebce12','candidate_patch_sha256':hashlib.sha256(pathlib.Path('/tmp/gpui-layout-route.patch').read_bytes()).hexdigest(),'cpu_affinity':[cpu],'rounds':11,'order':'alternate AB/BA per round; alternating case order','platform':list(os.uname()),'binaries':{}}
for label in ['baseline','candidate']:
 for suffix in ['', '-text','-list']:
  path=pathlib.Path(('/tmp/gpui-layout-route' if label=='candidate' else '/tmp/gpui-dimensions-baseline')+suffix)
  meta['binaries'][str(path)]={'sha256':hashlib.sha256(path.read_bytes()).hexdigest(),'bytes':path.stat().st_size}
(out/'metadata.json').write_text(json.dumps(meta,indent=2)+'\n')
start=time.monotonic()
for r in range(11):
 for case,suffix,args in cases if r%2==0 else reversed(cases):
  for label in ['baseline','candidate'] if r%2==0 else ['candidate','baseline']:
   p=subprocess.run([('/tmp/gpui-layout-route' if label=='candidate' else '/tmp/gpui-dimensions-baseline')+suffix,*args],capture_output=True,text=True,check=True)
   (out/f'{r:02}-{case}-{label}.csv').write_text(p.stdout)
 print('round',r,'elapsed',round(time.monotonic()-start,2),flush=True)
meta['elapsed_seconds']=time.monotonic()-start
(out/'metadata.json').write_text(json.dumps(meta,indent=2)+'\n')
