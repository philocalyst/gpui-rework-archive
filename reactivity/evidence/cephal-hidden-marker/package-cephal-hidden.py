from pathlib import Path
import json,hashlib,gzip,shutil
root=Path('/root/gpui-cephal-hidden-marker');out=root/'reactivity/evidence/cephal-hidden-marker';out.mkdir(exist_ok=True)
def cp(p,name):
 p=Path(p);q=out/name;q.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(p,q)
def gz(p,name=None):
 p=Path(p);q=out/(name or (p.name+'.gz'));q.parent.mkdir(parents=True,exist_ok=True)
 with p.open('rb') as f,gzip.open(q,'wb',compresslevel=1) as g:shutil.copyfileobj(f,g)
for name,location in [('baseline','/tmp/gpui-cephal-hidden-control'),('candidate','/tmp/gpui-cephal-hidden-captures'),('peak-assumption-failure','/tmp/gpui-cephal-hidden-peak-assumption-failure')]:
 for p in Path(location).iterdir():
  if p.suffix in ['.csv','.stderr','.json','.txt','.log','.py']:
   cp(p,name+'/'+p.name)
  elif p.suffix=='.jsonl':gz(p,name+'/'+p.name+'.gz')
for p in Path('/tmp').glob('gpui-cephal-hidden-*.log'):gz(p,'gates/'+p.name+'.gz')
for name in ['capture-cephal-hidden.py','freeze-cephal-hidden-control.py','package-cephal-hidden.py']:cp(Path('/tmp')/name,name)
for f in ['Cargo.toml','Cargo.lock','src/main.rs']:cp(Path('/tmp/gpui-cephal-hidden-driver')/f,'driver/'+f)
cp('/tmp/gpui-native-env.sh','native-env.sh')
