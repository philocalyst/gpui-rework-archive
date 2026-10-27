from pathlib import Path
import subprocess,json,hashlib,gzip,re
root=Path(__file__).resolve().parent;out=root/'machine';out.mkdir(exist_ok=False);summary={}
for name,phase in [('control','control'),('candidate','corrected')]:
 a=json.loads((root/phase/'artifact.json').read_text());p=Path(a['path']);assert hashlib.sha256(p.read_bytes()).hexdigest()==a['sha256'];nm=subprocess.check_output(['nm','-S','-C','--size-sort',str(p)]);(out/(name+'-symbols.txt.gz')).write_bytes(gzip.compress(nm,mtime=0));symbols=[];assembly=[]
 for line in nm.decode().splitlines():
  if re.search(r'(RetainedRenderer>::(?:render|patch_texts)|text_packet::patch|RendererState>::(?:render_observed|bindings)|GpuContext>::(?:submit|submit_regions)|text_packet::append_region)',line):
   parts=line.split(None,3)
   if len(parts)!=4:continue
   address,size=int(parts[0],16),int(parts[1],16);symbols.append({'name':parts[3],'bytes':size,'address':address});assembly.append(subprocess.check_output(['objdump','-d','-C','--start-address='+str(address),'--stop-address='+str(address+size),str(p)]))
 (out/(name+'-assembly.txt.gz')).write_bytes(gzip.compress(b'\n'.join(assembly),mtime=0));summary[name]={'artifact':a,'symbols':symbols};print(name,'ELF',a['bytes'],'selected routines',[(s['name'][-100:],s['bytes']) for s in symbols])
(out/'summary.json').write_text(json.dumps(summary,indent=2))
