from pathlib import Path
import subprocess,gzip,json,hashlib
root=Path(__file__).resolve().parent
for name,phase,target in [('candidate','qualified','gpui-question-source-set-target'),('control','control-qualified','gpui-question-source-control-target')]:
 binary=Path(f'/home/user/{target}/release/examples/question_source_cost');out=root/phase;receipt=json.loads((out/'artifact.json').read_text());assert hashlib.sha256(binary.read_bytes()).hexdigest()==receipt['sha256']
 nm=subprocess.check_output(['nm','-S','--size-sort','-C',str(binary)],text=True);(out/'symbols.txt.gz').write_bytes(gzip.compress(nm.encode()));selected=[];assembly=[]
 for line in nm.splitlines():
  fields=line.split(None,3)
  if len(fields)==4 and any(key in fields[3] for key in ['::deliver_ready','::refresh_self','::question_change']):
   addr,size=int(fields[0],16),int(fields[1],16);selected.append({'address':addr,'bytes':size,'symbol':fields[3]});assembly.append(subprocess.check_output(['objdump','-d','-C',f'--start-address={addr}',f'--stop-address={addr+size}',str(binary)]))
 (out/'routing-assembly.txt.gz').write_bytes(gzip.compress(b'\n'.join(assembly)));(out/'routing-symbols.json').write_text(json.dumps(selected,indent=2));print(name,'ELF',binary.stat().st_size,'selected sizes',[x['bytes'] for x in selected])
