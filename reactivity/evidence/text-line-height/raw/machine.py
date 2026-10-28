from pathlib import Path
import subprocess,json,re,hashlib
root=Path(__file__).resolve().parent;out=root/'machine-final';out.mkdir(exist_ok=False)
refs={'candidate':root/'native-first/artifact.json','control':Path('/home/user/gpui-native-parity-evidence/exact-source-qualified/artifact.json')};allrows={}
for name,ref in refs.items():
 a=json.loads(ref.read_text());p=Path(a['path']);assert hashlib.sha256(p.read_bytes()).hexdigest()==a['sha256'];syms=subprocess.check_output(['nm','-S','--size-sort','-C',str(p)],text=True);rows=[]
 (out/(name+'-sections.txt')).write_text(subprocess.check_output(['size','-A',str(p)],text=True))
 for line in syms.splitlines():
  m=re.match(r'^([0-9a-f]+) ([0-9a-f]+) ([tT]) (.+)$',line)
  if not m:continue
  addr,size,_,symbol=m.groups()
  if not any(part in symbol for part in ['<gpui::runtime::TextSite>::shape_text','<gpui_canvas::text::planner::Planner>::shape','<gpui_canvas::text::planner::Planner>::measure','try_sparse_text','<gpui_canvas::text::TextShaper>::measure','<gpui_canvas::text::TextShaper>::shape_mode']):continue
  if 'closure' in symbol or symbol.startswith('<core::'):continue
  start=int(addr,16);length=int(size,16);asm=subprocess.check_output(['objdump','-d','--no-show-raw-insn','-Mintel','--start-address='+str(start),'--stop-address='+str(start+min(length,128)),str(p)],text=True)
  stack=re.findall(r'sub\s+rsp,0x([0-9a-f]+)',asm);rows.append({'symbol':symbol,'address':addr,'bytes':length,'local_sub_rsp_prologue':[int(x,16) for x in stack],'assembly':asm})
 (out/(name+'-functions.json')).write_text(json.dumps(rows,indent=2));allrows[name]={'artifact':a,'functions':[{k:v for k,v in r.items() if k!='assembly'} for r in rows]}
(out/'summary.json').write_text(json.dumps(allrows,indent=2));print(json.dumps({k:{'ELF_bytes':v['artifact']['bytes'],'functions':v['functions']} for k,v in allrows.items()},indent=2))
