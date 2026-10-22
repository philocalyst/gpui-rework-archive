"""Preserved native release entry inspection; no timing claim."""
import gzip,hashlib,json,subprocess
from pathlib import Path
OUT=Path(__file__).resolve().parent
rows={}
for label in ['numeric','lease']:
 binary=Path('/tmp/gpui-layout-identity-controls')/label/'owned'
 symbols=subprocess.check_output(['nm','-S','-C',binary],text=True)
 (OUT/label/'gpu-symbols.txt').write_text('\n'.join(l for l in symbols.splitlines() if 'gpui_gpu::renderer' in l)+'\n')
 rows[label]={'sha256':hashlib.sha256(binary.read_bytes()).hexdigest(),'entries':{}}
 for method in ['render','redraw']:
  name=f'<gpui_gpu::renderer::RendererState>::{method}'
  matches=[l for l in symbols.splitlines() if l.endswith(name)];assert len(matches)==1,(name,matches)
  addr,size,*_=matches[0].split(maxsplit=3)
  asm=subprocess.check_output(['objdump','-d','-C',f'--start-address=0x{addr}',f'--stop-address=0x{int(addr,16)+int(size,16):x}',binary],text=True)
  (OUT/label/f'{method}.asm.gz').write_bytes(gzip.compress(asm.encode(),mtime=0))
  (OUT/label/f'{method}-entry.asm.gz').write_bytes(gzip.compress(('\n'.join(asm.splitlines()[:75])+'\n').encode(),mtime=0))
  rows[label]['entries'][method]={'bytes':int(size,16),'entry_lock_instructions':[l for l in asm.splitlines()[:75] if 'lock ' in l]}
 rows[label]['owned_render_forwarder_symbol']=any(l.endswith('<gpui_gpu::renderer::Renderer>::render') for l in symbols.splitlines())
(OUT/'asm-summary.json').write_text(json.dumps(rows,indent=2)+'\n')
