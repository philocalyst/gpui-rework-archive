#!/usr/bin/env python3
import pathlib,subprocess,hashlib,json,csv,statistics,os,time,platform
root=pathlib.Path(__file__).resolve().parent;out=root/'paired';out.mkdir(exist_ok=False)
bins={'control':'/home/user/gpui-pixel-uniform-control-target/release/examples/pixel_uniform','candidate':'/home/user/gpui-pixel-uniform-target/release/examples/pixel_uniform'}
env={**os.environ,'XDG_RUNTIME_DIR':'/home/user/gpui-xdg','VK_ICD_FILENAMES':'/usr/share/vulkan/icd.d/lvp_icd.json','LP_NUM_THREADS':'4'}
cases=['flat','stripes','text-stripes','quarter-stripes','hdr-stripes'];records=[]
meta={'binaries':bins,'hashes':{k:hashlib.sha256(pathlib.Path(v).read_bytes()).hexdigest() for k,v in bins.items()},'frames':60,'warmup':10,'repetitions':5,'cases':cases,'production_sources':{'control':'a0684a2b3498821129453c8c929ecf6c5f6ba810','candidate':'f813187f98c4428f64567b702b4fa425d79fdbb8'},'qualified_candidate_source':'f813187f98c4428f64567b702b4fa425d79fdbb8','compiler':subprocess.check_output(['rustc','+nightly-2026-10-23','-Vv'],text=True),'platform':platform.platform(),'started':time.time(),'environment':{k:env[k] for k in ['XDG_RUNTIME_DIR','VK_ICD_FILENAMES','LP_NUM_THREADS']}}
(out/'metadata.json').write_text(json.dumps(meta,indent=2))
for repeat in range(5):
 for variant in (['control','candidate'] if repeat%2==0 else ['candidate','control']):
  stem=f'{repeat}-{variant}';images=out/(stem+'-images');images.mkdir()
  command=['/usr/bin/time','-v','-o',str(out/(stem+'.time')),bins[variant],'60']
  with (out/(stem+'.csv')).open('w') as a,(out/(stem+'.log')).open('w') as b:r=subprocess.run(command,env={**env,'GPU_DRAW_OUTPUT':str(images)},stdout=a,stderr=b)
  (out/(stem+'.status.json')).write_text(json.dumps({'command':command,'exit':r.returncode}));assert r.returncode==0,(stem,r.returncode)
  rows=list(csv.DictReader((out/(stem+'.csv')).open()));assert len(rows)==300
  for case in cases:
   cell=[r for r in rows if r['case']==case];assert [int(r['frame']) for r in cell]==list(range(60));record={'repeat':repeat,'variant':variant,'case':case}
   for clock in ['host','complete']:
    vals=sorted(float(r[clock+'_us']) for r in cell);record[clock]={str(q):vals[round(59*q)] for q in [.5,.95,.99]}
   initial=(images/(case+'-initial.rgba')).read_bytes();final=(images/(case+'-final.rgba')).read_bytes();assert initial==final;assert len(initial)==960*720*(8 if case=='hdr-stripes' else 4);record['pixels_sha256']=hashlib.sha256(final).hexdigest();records.append(record)
  print(stem,{r['case']:r['complete']['0.5'] for r in records if r['repeat']==repeat and r['variant']==variant},flush=True)
ratios={}
for case in cases:
 ratios[case]={}
 for clock in ['host','complete']:
  values=[]
  for repeat in range(5):
   c={r['variant']:r for r in records if r['case']==case and r['repeat']==repeat};assert c['control']['pixels_sha256']==c['candidate']['pixels_sha256'],(case,repeat,'pixel parity');values.append(c['candidate'][clock]['0.5']/c['control'][clock]['0.5'])
  ratios[case][clock]={'paired_ratios':values,'median':statistics.median(values),'range':[min(values),max(values)]}
assert all(hashlib.sha256(pathlib.Path(v).read_bytes()).hexdigest()==meta['hashes'][k] for k,v in bins.items())
(out/'summary.json').write_text(json.dumps({'runs':records,'ratios':ratios},indent=2));print(json.dumps(ratios,indent=2),flush=True)
