from pathlib import Path
import hashlib,json,re,struct,subprocess,sys

def inspect(path):
    data=path.read_bytes()
    assert data[:6]==b'\x7fELF\x02\x01'
    header=struct.unpack_from('<16sHHIQQQIHHHHHH',data)
    sections=[struct.unpack_from('<IIQQQQIIQQ',data,header[6]+index*header[11]) for index in range(header[12])]
    def content(section): return data[section[4]:section[4]+section[5]]
    strings=content(sections[header[13]])
    def string(table,start): return table[start:table.index(0,start)].decode()
    byname={string(strings,s[0]):s for s in sections}
    symtab=byname['.symtab'];names=content(sections[symtab[6]])
    functions=[]
    for offset in range(symtab[4],symtab[4]+symtab[5],symtab[9]):
        name,info,other,index,value,size=struct.unpack_from('<IBBHQQ',data,offset)
        if info&15==2 and index and value:
            functions.append({'address':value,'code_bytes':size,'mangled':string(names,name)})
    decoded=subprocess.check_output(['c++filt','--format=rust'],input='\n'.join(f['mangled'] for f in functions).encode()).decode().splitlines()
    lookup={}
    for function,name in zip(functions,decoded):
        function['name']=name;function['normalized_name']=re.sub(r'\[[0-9a-f]+\]', '', name);lookup.setdefault(function['address'],[]).append(function)
    stack=content(byname['.stack_sizes']);cursor=0;frames=[]
    while cursor<len(stack):
        address=struct.unpack_from('<Q',stack,cursor)[0];cursor+=8
        size=0;shift=0
        while True:
            byte=stack[cursor];cursor+=1;size|=(byte&127)<<shift
            if byte<128:break
            shift+=7
        for function in lookup.get(address,[]):frames.append({**function,'stack_bytes':size})
    needles=('pointer_linked_control::', '::pointer_event','::inspector_focus_hit', 'PointerSession::position')
    selected=[f for f in frames if f['normalized_name'].startswith('text_column_public_control::') or ('gpui::runtime' in f['normalized_name'] and any(n in f['normalized_name'] for n in ('::hit', '::pointer', '::present_inner', '::acknowledge', '::visit', '::contains_point', '::query::Context', '::text_geometry::append', '::text_geometry::TextResources::entry')))]
    return {'binary':str(path),'bytes':len(data),'sha256':hashlib.sha256(data).hexdigest(),
            'sections':{name:section[5] for name,section in byname.items() if name in ('.text','.rodata','.data.rel.ro','.eh_frame','.stack_sizes')},
            'selected_frames':selected,'metadata_functions':len(frames),'limits':'Compiler stack-size metadata for control and all dependency crates; not summed call depth, dynamic stack or dependency frames. Selected linked functions/sections, no timings.'}
if __name__=='__main__':
    for filename in sys.argv[1:]:
        path=Path(filename);output=path.with_suffix('.elf.json');output.write_text(json.dumps(inspect(path),indent=2)+'\n');print(output)
