from pathlib import Path
import subprocess,json
root=Path(__file__).resolve().parent;out=root/'preflight';out.mkdir(exist_ok=False)
cases=[(r,n,m) for r in [0,1,40] for m in ['unrelated','dependent'] for n in [1,2,4]]+[(r,4,m) for r in [0,1,40] for m in ['owner','opaque']]
finals={}
for variant,target in [('candidate','gpui-question-source-set-target'),('control','gpui-question-source-control-target')]:
 for r,n,m in cases:
  stem=f'{variant}-{r}-{n}-{m}';cmd=[f'/home/user/{target}/release/examples/question_source_cost',str(r),str(n),m,'/home/user/zgx-reference-local/comparisons/fonts/DejaVuSans.ttf']
  with (out/(stem+'.out')).open('w') as a,(out/(stem+'.log')).open('w') as b:p=subprocess.run(cmd,stdout=a,stderr=b)
  (out/(stem+'.status.json')).write_text(json.dumps({'command':cmd,'exit':p.returncode,'timing_excluded':'correctness preflight concurrent with compiler'}));assert p.returncode==0,stem
  lines=(out/(stem+'.log')).read_text().splitlines();final=next(s for s in lines if s.startswith('FINAL,'));assert final==finals.setdefault((r,n,m),final),stem
  tasks=next(s for s in lines if s.startswith('TASKS,'));count=0 if m=='unrelated' and (n==1 or variant=='candidate') else 4000
  assert tasks==f'TASKS,frozen={count},dispatched={count},accepted={count}',(stem,tasks,count)
  print(stem,tasks,flush=True)
