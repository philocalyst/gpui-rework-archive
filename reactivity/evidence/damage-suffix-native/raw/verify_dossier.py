from pathlib import Path
import json,hashlib,re,statistics,random
root=Path(__file__).resolve().parent;r=root/'raw'
def sha(p):return hashlib.file_digest(p.open('rb'),'sha256').hexdigest()
manifest=json.loads((root/'manifest.json').read_text());assert set(manifest)=={str(p.relative_to(root)) for p in root.rglob('*') if p.is_file() and p.name!='manifest.json'}
for p,h in manifest.items():assert sha(root/p)==h,p
f=json.loads((r/'timing-inputs.json').read_text())
for p,h in f['files'].items():assert sha(r/p)==h,p
for p,h in f['environment_files'].items():assert sha(Path(p))==h
for p in ['guard-before-timing.json','guard-after-timing.json','guard-analysis.json']:assert json.loads((r/p).read_text())==[]
a=json.loads((r/'analysis.json').read_text());artifacts=json.loads((r/'artifacts.json').read_text())
for v in artifacts.values():assert sha(Path(v['preserved']))==v['sha256']
profiles=json.loads((r/'profiles.json').read_text());assert profiles['baseline']==profiles['candidate']
assert profiles['candidate']['CARGO_PROFILE_RELEASE_LTO']=='fat' and profiles['candidate']['CARGO_PROFILE_RELEASE_CODEGEN_UNITS']=='1'
for name in ['baseline','candidate']:
 d=r/('build-'+name);assert json.loads((d/'guard-after.json').read_text())==[]
 assert '17 passed; 0 failed' in (d/'test.out').read_text()
 for stage in ['build','test']:assert json.loads((d/(stage+'.status.json')).read_text())['exit']==0
 for stage in ['capture','exact','owner']:
  s=json.loads((r/'preflight'/name/stage/'status.json').read_text());assert s['exit']==0 and s['failure'] is None
assert json.loads((r/'image-comparison.json').read_text())=={'exit':0,'stdout':'','stderr':'0'}
for sh in json.loads((r/'shaders.json').read_text()):
 data=Path(artifacts['candidate']['preserved']).read_bytes();assert hashlib.sha256(data[sh['elf_offset']:sh['elf_offset']+sh['bytes']]).hexdigest()==sh['sha256']=='ea6e71d3da2bdb23d4971a14f0f55db389dbb45f9b2e9c05c85d4dc6363eb4d1'
orders=[]
for route in ['exact','owner']:
 for group in range(8):orders.append(dict(route=route,group=group,order=['baseline','candidate'] if group%2==0 else ['candidate','baseline']))
random.Random(20261109).shuffle(orders);assert json.loads((r/'PROCESS_ORDER.json').read_text())==orders
expected={(g['route'],g['group'],n) for g in orders for n in g['order']};rows={(x['route'],x['group'],x['name']):x for x in a['rows']};assert len(a['rows'])==32 and set(rows)==expected
for key,row in rows.items():
 route,group,name=key;p=r/'timing'/route/str(group)/name;status=json.loads((p/'status.json').read_text());assert status==row['status']
 if not (p/'summary.json').exists():assert row['summary'] is None and not row['gate_pass'] and not row['execution_pass'];continue
 s=json.loads((p/'summary.json').read_text());assert s==row['summary']
 assert s['route']==route and s['name']==name and s['initial']==0 and s['mode']=='stream'
 log=(p/'app.log').read_text();matches=re.findall(r'workload_ticks=(\d+) admitted_ticks=(\d+) workload_scroll_offset=([^\n]+)',log);assert len(matches)==1;total,ticks,offset=matches[0];assert int(total)==int(ticks)==s['ticks'] and float(offset)==0
 env=json.loads((p/'environment.json').read_text());assert env['ZGX_SECONDS']=='8' and env['ZGX_INITIAL_TICKS']=='0' and env['GPUI_LAB_TRACE']=='1' and (env.get('GPUI_LAB_INGRESS')=='owner')==(route=='owner')
 assert f'source_ingress={route}' in log
 ack=[dict(source_epoch=int(x),presentation_epoch=int(y),at_ns=int(z)) for x,y,z in re.findall(r'^GPUI_ACK,(\d+),(\d+),(\d+)$',log,re.M)];assert ack==json.loads((p/'acks.json').read_text());assert len(ack)==s['native_acknowledgements']==int(re.findall(r'native_acknowledgements=(\d+)',log)[0])
 pairs=[(b['at_ns']/1e9,(b['at_ns']-a['at_ns'])/1e6) for a,b in zip(ack,ack[1:])];assert all(d>=0 for t,d in pairs);first=sum(t<1 and d>25 for t,d in pairs);assert first==s['first_second_gaps_over25ms'] and s['total_gaps_over25ms']==sum(d>25 for t,d in pairs)
 assert s['cadence_pass']==(464<=s['ticks']<=488) and s['gap_gate_pass']==(first<=2)
 samples=json.loads((p/'samples.json').read_text());interval=[x for x in samples if s['visible_seconds']+1<=x['at']<=s['visible_seconds']+6 and x['state']!='Z'];dt=interval[-1]['at']-interval[0]['at'];cpu=interval[-1]['cpu_seconds']-interval[0]['cpu_seconds'];assert dt>=4.8
 assert (s['interval_start'],s['interval_end'],s['interval_seconds'],s['cpu_seconds'],s['cpu_cores'])==(interval[0]['at'],interval[-1]['at'],dt,cpu,cpu/dt)
 assert s['mean_rss_bytes']==statistics.mean(x['rss_bytes'] for x in interval) and s['max_rss_bytes']==max(x['rss_bytes'] for x in interval)
 gate_failure=repr(AssertionError(('unequal/insufficient admitted work',s['ticks']))) if not s['cadence_pass'] else repr(AssertionError(('first-second ACK gap gate',first))) if not s['gap_gate_pass'] else None
 execution=status['exit']==0 and (status['failure'] is None or (name=='candidate' and status['failure']==gate_failure));gate=status['exit']==0 and status['failure'] is None and s['cadence_pass'] and s['gap_gate_pass'];assert execution==row['execution_pass'] and gate==row['gate_pass']
for route,variants in a['aggregates'].items():
 for name,values in variants.items():
  group=[x for x in a['rows'] if x['route']==route and x['name']==name];summaries=[x['summary'] for x in group if x['summary'] is not None];assert values['observations']==8 and values['execution_passes']==sum(x['execution_pass'] for x in group) and values['gate_passes']==sum(x['gate_pass'] for x in group)
  for k in ['ticks','first_second_gaps_over25ms','total_gaps_over25ms']:assert values[k]==[s[k] for s in summaries]
  if len(summaries)==8:assert values['cpu_cores_median']==statistics.median(s['cpu_cores'] for s in summaries) and values['mean_rss_bytes_median']==statistics.median(s['mean_rss_bytes'] for s in summaries)
passed=all(x['execution_pass'] for x in a['rows']) and all(x['gate_pass'] for x in a['rows'] if x['name']=='candidate');assert a['candidate_passes']==passed
print('verified',len(manifest),'files;32 fixed observations;34 app tests;6 preflights;2 exact executable identities; candidate startup gate',passed,'; no ZGX/hardware victory')
