from pathlib import Path
import subprocess,json,re,hashlib
r=Path(__file__).parent;out=r/'machine-candidate';out.mkdir(exist_ok=False);a=json.loads((r/'full-native/artifact.json').read_text());p=Path(a['preserved']);assert hashlib.sha256(p.read_bytes()).hexdigest()==a['sha256'];rows=[]
(out/'sections.txt').write_text(subprocess.check_output(['size','-A',str(p)],text=True));syms=subprocess.check_output(['nm','-S','--size-sort','-C',str(p)],text=True)
for l in syms.splitlines():
 m=re.match(r'^([0-9a-f]+) ([0-9a-f]+) ([tT]) (.+)$',l)
 if not m:continue
 addr,size,_,sym=m.groups()
 if not sym.startswith('<gpui_gpu::') and not sym.startswith('gpui_gpu::'):continue
 if not any(x in sym for x in ['RegionBatch','scene_layout','RendererState>::render_observed','GpuContext>::submit','RetainedRenderer>::render','Backing>::new']):continue
 if 'closure' in sym and not sym.startswith('<gpui_gpu::renderer::RendererState>::render_observed::'):continue
 start=int(addr,16);length=int(size,16);asm=subprocess.check_output(['objdump','-d','--no-show-raw-insn','-Mintel',f'--start-address={start}',f'--stop-address={start+min(length,160)}',str(p)],text=True)
 rows.append({'symbol':sym,'address':addr,'bytes':length,'local_sub_rsp_prologue':[int(x,16) for x in re.findall(r'sub\s+rsp,0x([0-9a-f]+)',asm)],'assembly':asm})
(out/'receipt.json').write_text(json.dumps({'artifact':a,'functions':rows,'limitations':'Local prologue reservations only, not whole call-chain or driver stack; inlined/outlined work is not necessarily a separate symbol. Native release ELF with repository default profile, not the matched fat-LTO native benchmark profile.'},indent=2));print(json.dumps({'ELF_bytes':a['bytes'],'functions':[{k:v for k,v in row.items() if k!='assembly'} for row in rows]},indent=2))
