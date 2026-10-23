import pathlib,re,json,struct
root=pathlib.Path('/tmp/gpui-hummingbird-browser-allocation-evidence');out=root/'known-qualification'
variants={'dfc4':root/'normal.log','width-contract':root/'width-contract-first.log','metrics-only':root/'metrics-first.log','broad-finite':root/'vacant-first.log','known-width':root/'known-first.log'}
result={'scope':'Original four calling-thread Rust constructor phase counters, excluding worker/C/OS/device/RSS; inline public headers overlap and must not be summed. Preliminary debug allocation captures; final guarded release capture compared separately.','variants':{}}
for name,path in variants.items():
    rows=[]
    for line in path.read_text().splitlines():
        if not line.startswith('COHORT '):continue
        header,phase=line.split(' spawn=',1)
        row={'cohort':int(header.split()[1]),'headers':{key:int(v) for key,v in re.findall(r'(\w+)=(\d+)',header)}}
        for label,body in re.findall(r'(spawn|connected|mounted)=AllocationInfo \{([^}]+)\}', 'spawn='+phase):row[label]={k:int(v) for k,v in re.findall(r'(\w+): (-?\d+)',body)}
        assert len(row)==5;rows.append(row)
    assert len(rows)==4;result['variants'][name]={'log':str(path),'rows':rows}
(out/'constructor-ledger.json').write_text(json.dumps(result,indent=2)+'\n')
progress={}
for status in sorted(out.glob('*.exit')):
    name=status.stem;log=out/(name+'.log')
    if not log.exists():continue
    matches=re.findall(r'test result: ok\. (\d+) passed; (\d+) failed; (\d+) ignored;',log.read_text())
    if matches:
        progress[name]={'exit':int(status.read_text()),'harness_result_groups':len(matches),'passed':sum(int(a) for a,b,c in matches),'failed':sum(int(b) for a,b,c in matches),'ignored':sum(int(c) for a,b,c in matches)}
(out/'functional-progress.json').write_text(json.dumps(progress,indent=2)+'\n')
operands=[]
for cohort in json.loads((root/'known-calls/counts.json').read_text()):
    row=[]
    for line in cohort['details']:
        match=re.fullmatch(r'PLAN materialize=(true|false) interactive=(true|false) text=(.*) size=(\d+) width=(None|Some\((\d+)\))',line);assert match
        size=int(match[4]);width=int(match[6]) if match[6] else None
        decode=lambda bits:struct.unpack('<f',struct.pack('<I',bits))[0]
        row.append({'materialize':match[1]=='true','interactive':match[2]=='true','text_rust_debug':match[3],'size_bits':size,'size':decode(size),'width_bits':width,'width':decode(width) if width is not None else None})
    operands.append(row)
(root/'known-calls/decoded-operands.json').write_text(json.dumps(operands,indent=2)+'\n')
print('saved constructor ledger, functional progress and exact decoded operands')
