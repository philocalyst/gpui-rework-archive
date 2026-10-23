import pathlib,re,json
root=pathlib.Path('/tmp/gpui-hummingbird-browser-allocation-evidence');out=root/'known-qualification'
ledger=json.loads((out/'constructor-ledger.json').read_text())
p=pathlib.Path('/root/gpui-hummingbird-browser-allocation-sol/reactivity/ports/hummingbird/qualification/collection-browser/constructor-probe/control-9f.log')
rows=[]
for line in p.read_text().splitlines():
    if not line.startswith('COHORT '):continue
    header,phase=line.split(' spawn=',1)
    row={'cohort':int(header.split()[1]),'headers':{key:int(v) for key,v in re.findall(r'(\w+)=(\d+)',header)}}
    for label,body in re.findall(r'(spawn|connected|mounted)=AllocationInfo \{([^}]+)\}', 'spawn='+phase):row[label]={k:int(v) for k,v in re.findall(r'(\w+): (-?\d+)',body)}
    rows.append(row)
assert len(rows)==4
ledger['variants']['historical-9f']={'log':str(p),'scope':'Sealed earlier application feature control; retains its original separate-tree qualification, not recaptured as same-path here.','rows':rows}

def summary(row):
    result={key:sum(row[phase][key] for phase in ['spawn','connected','mounted']) for key in ['count_total','count_current','bytes_total','bytes_current']}
    result['ui_current_plus_inline']=row['headers']['ui_current_plus_inline']
    result['phase_maxima']={phase:{k:row[phase][k] for k in ['count_max','bytes_max']} for phase in ['spawn','connected','mounted']}
    return result
selected=ledger['variants']['known-width']['rows'];comparisons={}
for name,variant in ledger['variants'].items():
    comparisons[name]=[]
    for candidate,control in zip(selected,variant['rows']):
        now,old=summary(candidate),summary(control)
        row={'cohort':candidate['cohort'],'candidate':now,'control':old,'deltas':{key:now[key]-old[key] for key in now if key!='phase_maxima'},'phase_maximum_deltas':{phase:{k:now['phase_maxima'][phase][k]-old['phase_maxima'][phase][k] for k in ['count_max','bytes_max']} for phase in now['phase_maxima']}}
        comparisons[name].append(row)
result={'scope':ledger['scope'],'historical_9f_note':ledger['variants']['historical-9f']['scope'],'comparisons':comparisons}
(out/'constructor-deltas.json').write_text(json.dumps(result,indent=2)+'\n')
print('saved all cohort/phase deltas; no sum of phase peaks or overlapping headers')
