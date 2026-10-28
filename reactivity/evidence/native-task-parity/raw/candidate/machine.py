from pathlib import Path
import json,hashlib,subprocess,re
r=Path(__file__).parent;rows={}
for stage in ['build','minimal-build']:
 a=json.loads((r/'first'/(stage+'-artifacts.json')).read_text())[0];b=Path(a['preserved']);assert hashlib.sha256(b.read_bytes()).hexdigest()==a['sha256'];symbols=subprocess.check_output(['nm','-S','--size-sort','-C',str(b)],text=True);found=[]
 for line in symbols.splitlines():
  m=re.match(r'^([0-9a-f]+) ([0-9a-f]+) [tT] (.+)$',line)
  if not m:continue
  addr,size,name=m.groups()
  if 'zgx_native_lab' not in name or not any(x in name for x in ['::Lab>::control','::Lab>::poll_controls','::Lab>::apply_control','::Controls>::schedule']):continue
  start=int(addr,16);length=int(size,16);asm=subprocess.check_output(['objdump','-d','--no-show-raw-insn','-Mintel','--start-address='+str(start),'--stop-address='+str(start+min(length,128)),str(b)],text=True);stack=[int(x,16) for x in re.findall(r'sub\s+rsp,0x([0-9a-f]+)',asm)];found.append(dict(name=name,bytes=length,local_stack=stack,assembly=asm))
 rows[stage]=dict(artifact=a,functions=found,sections=subprocess.check_output(['size','-A',str(b)],text=True))
(r/'machine.json').write_text(json.dumps(rows,indent=2));print({s:len(v['functions']) for s,v in rows.items()})
