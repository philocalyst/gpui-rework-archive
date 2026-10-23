from pathlib import Path
import importlib.util,json,os,subprocess
root=Path('/tmp/gpui-inspector-pointer-codegen');source=(root/'elf.py').read_text().replace("'::inspector_pick_in_sheet'","'::inspector_pick'")
namespace={'__name__':'analyzer'};exec(compile(source,str(root/'elf.py'),'exec'),namespace)
variants={'6021':root/'baseline-frozen','a2':root/'candidate-frozen','plain_inline':Path('/tmp/gpui-inspector-pointer-codegen-inline/candidate-frozen'),'split':Path('/tmp/gpui-inspector-pointer-codegen-split/candidate-frozen'),'local':Path('/tmp/gpui-inspector-pointer-codegen-local/candidate-frozen'),'d0bd':Path('/tmp/gpui-inspector-pointer-codegen-optin/candidate-frozen')}
summary={}
for name,binary in variants.items():
 result=namespace['inspect'](binary);summary[name]=result
 binary.with_suffix('.final-elf.json').write_text(json.dumps(result,indent=2)+'\n')
 with binary.with_suffix('.selected.asm').open('w')as output:
  for frame in result['selected_frames']:
   output.write('\n'+frame['normalized_name']+' bytes='+str(frame['code_bytes'])+' stack='+str(frame['stack_bytes'])+'\n')
   subprocess.run(['objdump','-d','--no-show-raw-insn','--start-address='+str(frame['address']),'--stop-address='+str(frame['address']+frame['code_bytes']),str(binary)],stdout=output,check=True)
Path('/tmp/gpui-inspector-pointer-codegen-summary.json').write_text(json.dumps(summary,indent=2)+'\n')
for name,result in summary.items():
 print(name,result['sections']['.text'],[(f['normalized_name'],f['code_bytes'],f['stack_bytes'])for f in result['selected_frames'] if 'inspector_pick' in f['normalized_name']])
