from pathlib import Path
import subprocess,json
root=Path(__file__).resolve().parent;out=root/'preflight';out.mkdir(exist_ok=False)
binary='/home/user/gpui-sparse-batch-target/release/build/gpui/7d7527a5a336fc72/out/source_batch_cost'
for n,mode in [(2,'exact'),(4,'exact'),(4,'owner'),(4,'opaque')]:
 stem=f'{n}-{mode}';cmd=[binary,'0',str(n),mode,'/home/user/zgx-reference-local/comparisons/fonts/DejaVuSans.ttf']
 with (out/(stem+'.csv')).open('w') as a,(out/(stem+'.log')).open('w') as b:r=subprocess.run(cmd,stdout=a,stderr=b)
 (out/(stem+'.status.json')).write_text(json.dumps({'command':cmd,'exit':r.returncode,'timing_excluded':True}));assert r.returncode==0
print('four correctness preflights pass',flush=True)
