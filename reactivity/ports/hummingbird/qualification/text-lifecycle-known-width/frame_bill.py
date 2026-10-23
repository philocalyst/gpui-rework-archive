import pathlib,re,json,sys,bisect,collections
root=pathlib.Path(sys.argv[1]);binary_name=sys.argv[2]
frames=[];current=None
for line in (root/(binary_name+'.frames')).read_text().splitlines():
    match=re.search(r'FDE cie=.* pc=([0-9a-f]+)\.\.([0-9a-f]+)',line)
    if match:
        current={'start':int(match[1],16),'end':int(match[2],16),'cfa_rows':[]};frames.append(current)
    elif ' CIE' in line:current=None
    elif current is not None:
        row=re.match(r'^([0-9a-f]{16})\s+(\S+)',line)
        if row:current['cfa_rows'].append({'address':int(row[1],16),'cfa':row[2]})
frames.sort(key=lambda row:row['start']);starts=[r['start'] for r in frames]
rows=[];aliases=collections.defaultdict(list)
for line in (root/(binary_name+'.nm')).read_text().splitlines():
    match=re.match(r'^([0-9a-f]+)\s+([0-9a-f]+)\s+(\w)\s+(.+)$',line)
    if not match:continue
    address,size,kind,name=int(match[1],16),int(match[2],16),match[3],match[4]
    if kind not in 'tTwW' or not any(s in name for s in ['compute_with','layout::LayoutTree>::compute_inner','layout::Engine','TextShaper','text::planner::Planner','runtime::TextSite']):continue
    index=bisect.bisect_right(starts,address)-1;fde=frames[index] if index>=0 and frames[index]['start']<=address<frames[index]['end'] else None
    offsets=[];bases=[]
    if fde:
        for row in fde['cfa_rows']:
            bases.append(row['cfa'])
            value=re.fullmatch(r'rsp\+(\d+)',row['cfa'])
            if value:offsets.append(int(value[1]))
    row={'name':name,'address':address,'symbol_bytes':size,'symbol_type':kind,'fde':fde,'max_observed_rsp_cfa_offset':max(offsets) if offsets else None,'cfa_forms':sorted(set(bases))}
    rows.append(row);aliases[address,size].append(name)
result={'scope':'Linked ELF symbol aliases and DWARF unwind CFA observations, not whole call-stack or dynamic-stack bounds. CFA includes return-address/callee-save offsets. No symbol-size sums across aliases. Null FDE/offset means unavailable, not zero.','symbols':rows,'alias_groups':[{'address':a,'symbol_bytes':s,'names':names} for (a,s),names in aliases.items() if len(names)>1]}
(root/(binary_name+'.frames.json')).write_text(json.dumps(result,indent=2))
print(json.dumps({'selected_symbol_records':len(rows),'alias_groups':len(result['alias_groups'])}))
