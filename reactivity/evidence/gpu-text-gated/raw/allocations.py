from pathlib import Path
import subprocess,json,csv,hashlib,os,gzip,re,statistics
root=Path(__file__).resolve().parent;out=root/'allocations';out.mkdir(exist_ok=False);cases=[(r,n,m) for r in [0,25,1000] for m in ['exact','full'] for n in [1,2,4]]+[(r,1,'stream') for r in [0,25,1000]];env={**os.environ,'XDG_RUNTIME_DIR':'/home/user/gpui-xdg','VK_ICD_FILENAMES':'/usr/share/vulkan/icd.d/lvp_icd.json','LP_NUM_THREADS':'4'};runs=[];artifacts={};font=Path('/home/user/zgx-reference-local/comparisons/fonts/DejaVuSans.ttf');images={}
for name,suffix in [('control','-control'),('candidate','')]:
 phase=root/(name+'-allocation');a=json.loads((phase/'artifact.json').read_text());binary=Path(a['path']);assert hashlib.sha256(binary.read_bytes()).hexdigest()==a['sha256'];artifacts[name]=a;wt=Path('/home/user/gpui-gpu-text-packet-control-lab') if name=='control' else Path('/home/user/gpui-gpu-text-gated-lab');before=json.loads((phase/'inputs.json').read_text())
 for labels,fields,mode in cases:
  case=f'{labels}-{fields}-{mode}';stem=f'{name}-{case}';cmd=[str(binary),str(labels),str(fields),mode,str(font),str(out/stem)]
  with (out/(stem+'.out')).open('w') as o,(out/(stem+'.log')).open('w') as e:r=subprocess.run(cmd,env=env,stdout=o,stderr=e)
  (out/(stem+'.status.json')).write_text(json.dumps({'command':cmd,'exit':r.returncode}));assert r.returncode==0,stem
  log=(out/(stem+'.log')).read_text().splitlines();records=[]
  for line in log:
   if line.startswith('ALLOC,'):records.append({k:int(v) for k,v in (p.split('=') for p in line.split(',')[1:])})
  assert len(records)==60 and [v['frame'] for v in records]==list(range(60));layout={k:int(v) for k,v in (p.split('=') for p in next(v for v in log if v.startswith('LAYOUT,')).split(',')[1:])};final=next(v for v in log if v.startswith('FINAL,'));hashes={}
  for phase_name in ['initial','final']:
   file=out/(stem+'.'+phase_name+'.rgba');data=file.read_bytes();digest=hashlib.sha256(data).hexdigest();assert digest==images.setdefault((case,phase_name),digest);hashes[phase_name]=digest;file.with_suffix(file.suffix+'.gz').write_bytes(gzip.compress(data,compresslevel=1,mtime=0));file.unlink()
  repairs=[{k:int(v) for k,v in (p.split('=') for p in line.split(',')[1:])} for line in log if line.startswith('REPAIR,')];assert len(repairs)==(60 if name=='candidate' else 0)
  summary={key:{'median':statistics.median(v[key] for v in records),'range':[min(v[key] for v in records),max(v[key] for v in records)]} for key in records[0] if key!='frame'};runs.append({'variant':name,'case':case,'layout':layout,'allocations':records,'repairs':repairs,'summary':summary,'images':hashes,'final':final});print(stem,'passed',flush=True)
 changes=[p for p,h in before.items() if not (wt/p).is_file() or hashlib.sha256((wt/p).read_bytes()).hexdigest()!=h];(out/(name+'-guard-after.json')).write_text(json.dumps(changes));assert not changes;assert hashlib.sha256(binary.read_bytes()).hexdigest()==a['sha256']
(out/'summary.json').write_text(json.dumps({'scope':'Caller-thread Rust allocator only; driver/foreign allocations and worker-thread allocations are excluded. Whole-process RSS and explicit GPU buffers are separate evidence.','artifacts':artifacts,'font_sha256':hashlib.sha256(font.read_bytes()).hexdigest(),'runs':runs},indent=2))
