from pathlib import Path
import subprocess,re,json
bin='/tmp/gpui-monotonic-control-bin/stream-final'
base='/nix/store/m59w5gavjx8db0ay3m1yzbw02l54109b-clang-wrapper-21.1.8/bin/'
nm=subprocess.check_output([base+'nm','--print-size','--size-sort','--demangle',bin],text=True)
Path('/tmp/gpui-monotonic-final-symbols.txt').write_text(nm)
section=subprocess.check_output([base+'objdump','-h',bin],text=True);Path('/tmp/gpui-monotonic-final-sections.txt').write_text(section)
queries={'stream':lambda n:'>>::try_for_each_pair::' in n,'logical':lambda n:'try_for_each_cluster::<core::ops::control_flow::ControlFlow' in n,'rtl':lambda n:'try_for_each_cluster::<gpui_canvas::Error' in n,'cursor':lambda n:n.endswith('<parley::layout::run::Clusters<()>>::advance_cursor'),'constructor':lambda n:n.endswith('<parley::layout::run::Clusters<()>>::new'),'pair':lambda n:'parley::editing::geometry::pair_from_entries::<()>'==n,'shape':lambda n:n.endswith('<gpui_canvas::text::planner::Planner>::shape')}
rows={}
for k,q in queries.items():
 matches=[]
 for line in nm.splitlines():
  fields=line.split(maxsplit=3)
  if len(fields)==4 and q(fields[3]):matches.append(fields)
 assert len(matches)==1,(k,matches)
 addr,size,_,symbol=matches[0];addr=int(addr,16);size=int(size,16)
 asm=subprocess.check_output([base+'objdump','-d','--demangle',f'--start-address={addr}',f'--stop-address={addr+size}',bin],text=True)
 Path('/tmp/gpui-monotonic-final-'+k+'.asm').write_text(asm)
 rows[k]=dict(bytes=size,symbol=symbol,stack_subtractions=re.findall(r'sub\s+\$0x([0-9a-f]+),%rsp',asm),memcpy_lines=[l.strip() for l in asm.splitlines() if 'memcpy' in l])
rows['text_section']=next(l.strip() for l in section.splitlines() if re.search(r'\s\.text\s',l))
Path('/tmp/gpui-monotonic-final-code.json').write_text(json.dumps(rows,indent=2)+'\n')
print(json.dumps(rows,indent=2))
a=json.loads(Path('/tmp/gpui-monotonic-final-allocation.json').read_text());b=json.loads(Path('/tmp/gpui-monotonic-borrowed-shaper-allocations.json').read_text())['rows'];assert a==b
print('Final 14 allocator rows byte-equal to frozen 0cbd borrowed control')
