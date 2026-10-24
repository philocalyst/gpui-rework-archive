import subprocess,pathlib,re,json,sys
nm='/nix/store/ddk8rvjihg4vhh1k6x9rc65y1zb1kx34-binutils-2.46/bin/nm'
od='/nix/store/ddk8rvjihg4vhh1k6x9rc65y1zb1kx34-binutils-2.46/bin/objdump'
binary=pathlib.Path(sys.argv[1]); out=pathlib.Path(sys.argv[2]); out.mkdir(parents=True,exist_ok=True)
syms=subprocess.check_output([nm,'-SC',str(binary)],text=True)
rows=[]
for line in syms.splitlines():
 m=re.match(r'([0-9a-f]+) ([0-9a-f]+) \w (.*)',line)
 if not m: continue
 start,size,name=int(m[1],16),int(m[2],16),m[3]
 if not (('draw_text_working' in name) or ('RasterScratch' in name and 'prepare' in name) or ('render_band_impl' in name and 'BgrxEncoder' in name) or ('DisplayList' in name and '>::get' in name) or ('PreparedGroup' in name and 'placements' in name) or (name.startswith('<gpui_gpu::renderer::RendererState>::') and ('>::render' in name or '>::prepare_atlas' in name))): continue
 asm=subprocess.check_output([od,'-d','-C','--no-show-raw-insn',f'--start-address={start}',f'--stop-address={start+size}',str(binary)],text=True)
 index=len(rows); (out/f'{index}.asm').write_text(asm)
 mn={}
 for ins in re.findall(r'^\s*[0-9a-f]+:\s+([a-z][a-z0-9.]*)',asm,re.M): mn[ins]=mn.get(ins,0)+1
 rows.append({'name':name,'bytes':size,'mnemonics':mn,'asm':f'{index}.asm'})
(out/'result.json').write_text(json.dumps(rows,indent=2)+'\n')
print(json.dumps([{k:v for k,v in r.items() if k!='mnemonics'} for r in rows],indent=2))
