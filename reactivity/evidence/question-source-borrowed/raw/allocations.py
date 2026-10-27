from pathlib import Path
import subprocess,json,hashlib
root=Path(__file__).resolve().parent;out=root/'allocations';out.mkdir(exist_ok=False)
font=Path('/home/user/zgx-reference-local/comparisons/fonts/DejaVuSans.ttf');cases=[(r,n,m) for r in [0,1,40] for m in ['unrelated','dependent'] for n in [1,2,4]]+[(r,4,m) for r in [0,1,40] for m in ['owner','opaque']];records=[];finals={};artifacts={}
for name,target in [('candidate','gpui-question-source-borrowed-target'),('control','gpui-question-source-control-target')]:
 binary=Path(f'/home/user/{target}/release/examples/question_source_allocations');artifacts[name]={'path':str(binary),'sha256':hashlib.sha256(binary.read_bytes()).hexdigest(),'bytes':binary.stat().st_size}
 for rows,n,mode in cases:
  stem=f'{name}-{rows}-{n}-{mode}';cmd=[str(binary),str(rows),str(n),mode,str(font)]
  with (out/(stem+'.out')).open('w') as a,(out/(stem+'.log')).open('w') as b:r=subprocess.run(cmd,stdout=a,stderr=b)
  (out/(stem+'.status.json')).write_text(json.dumps({'command':cmd,'exit':r.returncode}));assert r.returncode==0,stem
  data={'variant':name,'rows':rows,'fields':n,'mode':mode}
  for line in (out/(stem+'.log')).read_text().splitlines():
   if line.startswith(('ALLOC,','COLD_ALLOC,','LAYOUT,','FINAL,','TASKS,')):
    key,*parts=line.split(',');data[key]={k:int(v) for k,v in (s.split('=') for s in parts)}
  assert data['FINAL']==finals.setdefault((rows,n,mode),data['FINAL']);records.append(data)
(out/'summary.json').write_text(json.dumps({'artifacts':artifacts,'font_sha256':hashlib.sha256(font.read_bytes()).hexdigest(),'runs':records},indent=2));print('48 complete allocation probes pass')
