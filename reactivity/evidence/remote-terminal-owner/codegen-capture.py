from pathlib import Path
import subprocess, json, hashlib
base=Path('/tmp/gpui-intent-transport-codegen')
probe=base/'probe.rs'
variants=[('control-headless','/root/gpui-hummingbird-transport-control-sol',[]),('candidate-headless','/root/gpui-hummingbird-library-intent-sol',[]),('candidate-native','/root/gpui-hummingbird-library-intent-sol',['--features','x11-minimal'])]
records=[]
for name,root,features in variants:
 out=base/name
 out.mkdir(exist_ok=True)
 command=['cargo','build','--offline','--locked','-p','gpui','--lib','--message-format=json',*features]
 record={'name':name,'root':root,'commit':subprocess.check_output(['git','rev-parse','HEAD'],cwd=root,text=True).strip(),'build':command,'probe_sha256':hashlib.sha256(probe.read_bytes()).hexdigest()}
 with (out/'build.jsonl').open('w') as stdout,(out/'build.log').open('w') as stderr:
  record['build_exit']=subprocess.run(command,cwd=Path(root)/'reactivity',stdout=stdout,stderr=stderr).returncode
 assert record['build_exit']==0,record
 library=None
 for line in (out/'build.jsonl').read_text().splitlines():
  item=json.loads(line)
  if item.get('reason')=='compiler-artifact' and item['target']['name']=='gpui':
   for path in item['filenames']:
    if path.endswith('.rlib'):library=path
 assert library
 record['library']=library
 record['library_sha256']=hashlib.sha256(Path(library).read_bytes()).hexdigest()
 command=['rustc','--edition','2024','--crate-name','remote_probe','--crate-type','lib','-C','opt-level=3','-C','codegen-units=1','--emit=asm,obj',str(probe),'--extern','gpui='+library,'-L','dependency=/tmp/gpui-hummingbird-audio-target/debug/deps','--out-dir',str(out)]
 record['probe']=command
 with (out/'probe.log').open('w') as log:record['probe_exit']=subprocess.run(command,stdout=log,stderr=subprocess.STDOUT).returncode
 records.append(record)
 (base/'records.json').write_text(json.dumps(records,indent=2)+'\n')
 print(name,record['build_exit'],record['probe_exit'],flush=True)
 assert record['probe_exit']==0,record
print('DONE',flush=True)
