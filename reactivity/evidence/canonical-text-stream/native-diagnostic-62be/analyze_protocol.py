from pathlib import Path
import collections,hashlib,json,re,subprocess
base=Path(__file__).parent
r=json.loads((base/'results/resolved-registration.json').read_text())
summary={}
for label in ['baseline','candidate']:
    out=base/'results'/label
    lines=(out/'dbus-monitor.log').read_text().splitlines()
    messages=[]
    for line in lines:
        if re.match(r'^(method call|method return|signal|error) time=',line):messages.append({'header':line,'body':[]})
        elif messages:messages[-1]['body'].append(line)
    def field(header,name):
        match=re.search(r'(?:^| )'+re.escape(name)+r'=([^ ;]+)',header)
        return match.group(1) if match else None
    calls={};text=[]
    for index,message in enumerate(messages):
        header=message['header']
        if header.startswith('method call'):
            key=field(header,'sender'),field(header,'serial');calls[key]=message
            if field(header,'interface')=='org.a11y.atspi.Text':
                message['message_index']=index;message['member']=field(header,'member');text.append(message)
        elif header.startswith(('method return','error')):
            key=field(header,'destination'),field(header,'reply_serial')
            if key in calls:
                calls[key]['reply']=message
    counts=collections.Counter(message['member'] for message in text)
    assert counts['SetSelection']==128
    selected=[message for message in text if message['member']=='SetSelection']
    for index,message in enumerate(selected):
        assert 'reply' in message and message['reply']['header'].startswith('method return')
        assert '   boolean true' in message['reply']['body']
        values=[int(line.strip().split()[1]) for line in message['body'] if line.strip().startswith('int32 ')]
        assert values==[0,index%2,index%2+1]
    assert all('reply' in message for message in text)
    assert all(message['reply']['header'].startswith('method return') for message in text)
    assert counts['GetText']==3 and counts['GetCharacterExtents']==4 and counts['GetOffsetAtPoint']==2
    assert counts['GetSelection']>=129
    for index,message in enumerate(text):
        if message['member']=='SetSelection':
            assert index+1<len(text) and text[index+1]['member']=='GetSelection'
    waits={name:[] for name in ['futex','epoll_wait','epoll_pwait','poll','ppoll']}
    traces=sorted(out.glob('syscall.*'))
    exits=[]
    for path in traces:
        raw=path.read_text()
        exits.append({'file':path.name,'exited0':'+++ exited with 0 +++' in raw,'sha256':hashlib.sha256(path.read_bytes()).hexdigest()})
        for name in waits:
            if re.search(r'\b'+name+r'\(',raw):waits[name].append(path.name)
    state=json.loads((out/'metadata.json').read_text())
    assert state['native_exit']==0 and not state.get('forced_cleanup') and len(state['native_json'])==1
    value=state['native_json'][0]
    assert value['checksum']==18002357812456519237 and value['source_epoch_before_close']==258
    summary[label]={'native_exit':state['native_exit'],'clock_arrays_empty':value['elapsed_ns']==value['host_ack_elapsed_ns']==[],
                    'text_method_counts':dict(counts),'all_text_calls_replied_successfully':True,
                    'selection_requests_alternate_actual_ranges':True,'final_ack_epoch':258,
                    'failed_prepare_old_p_checked':value['failed_prepare_old_p_checked'],
                    'normal_close_completed':True,'forced_cleanup':False,'wait_syscall_files':waits,'thread_trace_exits':exits,
                    'last_text_method':text[-1]['member'],'raw_startup_same_token_duplicates':len(value['ack_epochs'])-len(set(map(tuple,value['ack_epochs'])))}
    (out/'text-protocol.json').write_text(json.dumps(text,indent=2)+'\n')
original=Path(r['campaign_registration_path'])
campaign=json.loads(original.read_text())
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
assert sha(original)==r['campaign_registration_sha256']
for modes in campaign['binaries'].values():
    for binaries in modes.values():
        for value in binaries.values():assert sha(Path(value['path']))==value['sha256']
root=Path(campaign['source_path']);fixture=Path(campaign['fixture_path'])
assert all(sha(root/name)==digest for name,digest in campaign['candidate_source_files'].items())
assert {str(p.relative_to(fixture)):sha(p) for p in fixture.rglob('*') if p.is_file()}==campaign['fixture_sha256']
assert not subprocess.check_output(['git','-c',f'safe.directory={root}','-C',str(root),'status','--porcelain'],text=True)
assert subprocess.check_output(['git','-c',f'safe.directory={root}','-C',str(root),'rev-parse','HEAD'],text=True).strip()==campaign['source_pins']['candidate']
result={'status':'TWO authorized NON-TIMING diagnostic executions completed; original timeout NOT reproduced or explained; no performance inference',
        'resolved_registration_sha256':sha(base/'results/resolved-registration.json'),
        'campaign_unchanged':True,'all_eight_binary_guards_pass':True,'all_source_and_fixture_guards_pass':True,
        'cases':summary,'limitation':'Clock-disabled oracle plus monitoring/ptrace changes scheduling and timing-observation branches. Success cannot attribute or clear original untraced clock-enabled failure. No additional native execution authorized by this analysis.'}
(base/'results/protocol-analysis.json').write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps(result,indent=2))
