from pathlib import Path
import hashlib,json,os,subprocess
from elf import inspect
out=Path(__file__).parent
meta=json.loads((out/'build-metadata.json').read_text());assert meta.get('preflight_equal')
summary={}
for label in ['baseline','candidate']:
 binary=out/f'codegen-{label}-frozen';r=inspect(binary);summary[label]=r
 (out/f'{label}-elf.json').write_text(json.dumps(r,indent=2)+'\n')
 with (out/f'{label}-selected.asm').open('w') as stream:
  seen=set()
  for frame in r['selected_frames']:
   if frame['address'] in seen:continue
   seen.add(frame['address'])
   stream.write('\n'+frame['normalized_name']+' code='+str(frame['code_bytes'])+' fixed_stack='+str(frame['stack_bytes'])+'\n');stream.flush()
   subprocess.run(['objdump','-d','--demangle=rust','--no-show-raw-insn','--start-address='+str(frame['address']),'--stop-address='+str(frame['address']+frame['code_bytes']),str(binary)],stdout=stream,check=True)
 print(label,r['sections'])
 for f in r['selected_frames']:
  if f['normalized_name'].startswith('text_column_public_control::') or any(n in f['normalized_name'] for n in ['::present_inner','::acknowledge','::text_geometry::append']):print(f['normalized_name'],f['code_bytes'],f['stack_bytes'])
(out/'codegen-summary.json').write_text(json.dumps(summary,indent=2)+'\n')
# No allocator probe in either ordinary executable.
for label in ['baseline','candidate']:
 binary=out/f'normal-{label}-frozen'
 text=subprocess.check_output(['nm','--demangle=rust',str(binary)],text=True)
 assert 'allocation_counter' not in text
 (out/f'normal-{label}-allocator-symbol-check.txt').write_text('No allocation_counter symbol; normal Cargo graph also excludes the dependency.\n')
