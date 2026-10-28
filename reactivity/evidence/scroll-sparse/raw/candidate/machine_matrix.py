from pathlib import Path
import subprocess,json,re,hashlib
root=Path(__file__).resolve().parent;out=root/'machine-five-way-complete';out.mkdir(exist_ok=False)
refs=json.loads((root/'matrix-artifacts.json').read_text());allrows={}
for name,ref in refs.items():
 a=ref['native_artifact'];p=Path(a.get('preserved',a['path']));assert hashlib.sha256(p.read_bytes()).hexdigest()==a['sha256'];syms=subprocess.check_output(['nm','-S','--size-sort','-C',str(p)],text=True);rows=[]
 (out/(name+'-sections.txt')).write_text(subprocess.check_output(['size','-A',str(p)],text=True))
 for line in syms.splitlines():
  m=re.match(r'^([0-9a-f]+) ([0-9a-f]+) ([tT]) (.+)$',line)
  if not m:continue
  addr,size,_,symbol=m.groups()
  if not any(part in symbol for part in ['try_sparse_text','try_patch_text','DamageRegions','TextRepair','text_geometry','with_paint_scene','present_walk','RetainedRenderer>::render','GpuContext>::submit','RendererState>::render_observed','RegionalOutput','Submission','gpui_canvas::canvas::scroll','ScrollOutput','ScrollTransition','scroll_copy_proposal','Backing>::prepare_scroll','Backing>::scroll']):continue
  if ('closure' in symbol and not symbol.startswith('<gpui_gpu::renderer::RendererState>::render_observed::')) or symbol.startswith('<core::'):continue
  start=int(addr,16);length=int(size,16);asm=subprocess.check_output(['objdump','-d','--no-show-raw-insn','-Mintel','--start-address='+str(start),'--stop-address='+str(start+min(length,128)),str(p)],text=True)
  stack=re.findall(r'sub\s+rsp,0x([0-9a-f]+)',asm);rows.append({'symbol':symbol,'address':addr,'bytes':length,'local_sub_rsp_prologue':[int(x,16) for x in stack],'assembly':asm})
 (out/(name+'-functions.json')).write_text(json.dumps(rows,indent=2));allrows[name]={'artifact':a,'functions':[{k:v for k,v in r.items() if k!='assembly'} for r in rows]}
(out/'limits.txt').write_text('Local prologue reservations only; not whole call-chain, driver or GPU stack. Inlined work need not appear as a separate symbol. Native repository-default release ELFs, not the later matched fat-LTO native profile.\n')
(out/'summary.json').write_text(json.dumps(allrows,indent=2));print({k:{'ELF_bytes':v['artifact']['bytes'],'functions':len(v['functions'])} for k,v in allrows.items()})
