import pathlib,struct,subprocess,json,hashlib,sys,re,collections
source=pathlib.Path(sys.argv[1]); out=pathlib.Path(sys.argv[2]);out.mkdir(exist_ok=False)
manifest=json.loads(source.with_suffix('.json').read_text())

def sections(data):
    if data[:4]!=b'\x7fELF': return None
    wide=data[4]==2;order='<' if data[5]==1 else '>'
    shoff=struct.unpack_from(order+('Q' if wide else 'I'),data,40 if wide else 32)[0]
    stride,count,strings=struct.unpack_from(order+'HHH',data,58 if wide else 46)
    fmt=order+('IIQQQQIIQQ' if wide else 'IIIIIIIIII')
    def sec(i):return struct.unpack_from(fmt,data,shoff+i*stride)
    first=sec(0)
    if count==0:count=first[5]
    if strings==0xffff:strings=first[6]
    names=sec(strings);names=data[names[4]:names[4]+names[5]]
    result=[]
    for i in range(1,count):
        s=sec(i);end=names.find(b'\0',s[0]);name=names[s[0]:end].decode('utf8')
        result.append((name,s[5],s[2]))
    return result

bills={}
for name,entry in manifest.items():
    file=source/name
    data=file.read_bytes();assert hashlib.sha256(data).hexdigest()==entry['sha256']
    all_sections=[];skipped=[];objects=[]
    if file.suffix=='.rlib':
        members=subprocess.check_output(['ar','t',str(file)],text=True).splitlines()
        for member in members:
            payload=subprocess.check_output(['ar','p',str(file),member]);values=sections(payload)
            if values is None:skipped.append({'member':member,'bytes':len(payload)})
            else:all_sections.extend(values);objects.append(member)
    else:all_sections=sections(data);assert all_sections is not None
    totals=collections.Counter();allocated=collections.Counter()
    for section,size,flags in all_sections:
        totals[section]+=size
        if flags&2:allocated[section]+=size
    categories={}
    for category in ['.text','.rodata','.data','.bss','.eh_frame','.gcc_except_table']:
        categories[category]=sum(size for s,size in allocated.items() if s==category or s.startswith(category+'.'))
    bills[name]={'artifact':entry,'file_bytes':len(data),'elf_objects':objects,'non_elf_members':skipped,'allocated_section_bytes':sum(allocated.values()),'categories':categories,'all_allocated_sections':dict(sorted(allocated.items())),'all_sections':dict(sorted(totals.items()))}
    command=['nm','-S','--defined-only','--demangle',str(file)]
    got=subprocess.run(command,stdout=subprocess.PIPE,stderr=subprocess.PIPE);(out/(name+'.nm')).write_bytes(got.stdout);(out/(name+'.nm.stderr')).write_bytes(got.stderr)
    bills[name]['nm_exit']=got.returncode
    if entry['target'] in ['gpui_reactivity_core','gpui_canvas','gpui']:
        cmd=['objdump','-drC','--no-show-raw-insn',str(file)]
        got=subprocess.run(cmd,stdout=subprocess.PIPE,stderr=subprocess.PIPE)
        (out/(name+'.disassembly.stderr')).write_bytes(got.stderr)
        # Retain full functions selected by semantic identity, including aliases.
        # Whole section totals above never sum symbol aliases.
        functions=[];current=[];keep=False
        for line in got.stdout.decode().splitlines(keepends=True):
            header=re.match(r'^[0-9a-fA-F]+ <(.+)>:\n$',line)
            if header:
                if keep: functions.extend(current)
                current=[]
                function=header.group(1)
                keep=any(t in function for t in ['compute_with','compute_inner<','compute_inner::','layout::Engine','TextShaper','text::planner::Planner','TextSite','WidthMeasureInput'])
            if keep:current.append(line)
        if keep:functions.extend(current)
        (out/(name+'.selected.asm')).write_text(''.join(functions))
        bills[name]['objdump_exit']=got.returncode
(out/'bill.json').write_text(json.dumps(bills,indent=2))
print(json.dumps({k:{'file_bytes':v['file_bytes'],'categories':v['categories']} for k,v in bills.items()},indent=2))
