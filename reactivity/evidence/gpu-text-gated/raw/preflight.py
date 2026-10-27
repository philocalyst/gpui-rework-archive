from pathlib import Path
import subprocess,json,os,hashlib,sys
root=Path(__file__).resolve().parent;variant=sys.argv[1];phase=root/variant;out=phase/'preflight';out.mkdir(exist_ok=False);a=json.loads((phase/'artifact.json').read_text());binary=Path(a['path']);assert hashlib.sha256(binary.read_bytes()).hexdigest()==a['sha256'];env={**os.environ,'XDG_RUNTIME_DIR':'/home/user/gpui-xdg','VK_ICD_FILENAMES':'/usr/share/vulkan/icd.d/lvp_icd.json','LP_NUM_THREADS':'4'}
(out/'SCOPE.txt').write_text('Correctness-only preflight. All durations excluded from performance qualification. Other work may run concurrently.\n')
for labels,fields,mode in [(0,2,'exact'),(1000,4,'exact'),(25,1,'stream'),(1000,4,'full')]:
 stem=f'{labels}-{fields}-{mode}';cmd=[str(binary),str(labels),str(fields),mode,'/home/user/zgx-reference-local/comparisons/fonts/DejaVuSans.ttf',str(out/stem)]
 with (out/(stem+'.out')).open('w') as o,(out/(stem+'.log')).open('w') as e:r=subprocess.run(cmd,env=env,stdout=o,stderr=e)
 (out/(stem+'.status.json')).write_text(json.dumps({'command':cmd,'exit':r.returncode}));print(variant,stem,r.returncode,flush=True);assert r.returncode==0
assert hashlib.sha256(binary.read_bytes()).hexdigest()==a['sha256']
