from pathlib import Path
import json,subprocess,re,hashlib
r=Path(__file__).parent;out=r/'machine-costs';out.mkdir(exist_ok=False)
old=json.loads(Path('/home/user/gpui-damage-suffix-evidence/full-native-initial/artifact.json').read_text());new=json.loads((r/'full-native-initial/artifact.json').read_text());allrows={}
for name,a in [('baseline',old),('candidate',new)]:
 p=Path(a['preserved']);assert hashlib.file_digest(p.open('rb'),'sha256').hexdigest()==a['sha256'];syms=subprocess.check_output(['nm','-S','--size-sort','-C',str(p)],text=True);rows=[]
 (out/(name+'-sections.txt')).write_text(subprocess.check_output(['size','-A',str(p)],text=True))
 for line in syms.splitlines():
  m=re.match(r'^([0-9a-f]+) ([0-9a-f]+) ([tT]) (.+)$',line)
  if not m:continue
  addr,size,_,symbol=m.groups()
  if not any(x in symbol for x in ['damage_from','lowered_mask_rect','present_walk','try_sparse_text','RetainedRenderer>::render','RendererState>::render_observed','GpuContext>::submit']):continue
  if 'closure' in symbol and 'RendererState>::render_observed::' not in symbol:continue
  start=int(addr,16);length=int(size,16);asm=subprocess.check_output(['objdump','-d','--no-show-raw-insn','-Mintel','--start-address='+str(start),'--stop-address='+str(start+min(length,128)),str(p)],text=True)
  rows.append(dict(symbol=symbol,bytes=length,address=addr,local_sub_rsp_prologue=[int(x,16) for x in re.findall(r'sub\s+rsp,0x([0-9a-f]+)',asm)],assembly=asm))
 allrows[name]=dict(artifact=a,functions=rows)
shipping=json.loads((r/'shipping-lines-candidate.json').read_text());base=json.loads(Path('/home/user/gpui-damage-suffix-evidence/shipping-lines-candidate.json').read_text())
(out/'summary.json').write_text(json.dumps(dict(variants=allrows,shipping_lines=dict(candidate=shipping['core_non_test_code_lines'],baseline=base['core_non_test_code_lines']),scope='Actual repository-default release native ELFs. Local prologue reservations exclude callees, register saves and driver/GPU stacks. No new retained storage; typed shader changes. Timing gates remain outstanding.'),indent=2))
print('native ELFs',old['bytes'],new['bytes'],'delta',new['bytes']-old['bytes'])
for name,x in allrows.items():
 for f in x['functions']:
  if 'damage_from' in f['symbol'] or 'present_walk' in f['symbol']:print(name,f['symbol'],f['bytes'],f['local_sub_rsp_prologue'])
