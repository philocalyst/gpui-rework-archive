from pathlib import Path
import json,hashlib,statistics,re,random
root=Path(__file__).resolve().parent;r=root/'raw'
def sha(p):return hashlib.file_digest(p.open('rb'),'sha256').hexdigest()
manifest=json.loads((root/'manifest.json').read_text())
assert set(manifest)=={str(p.relative_to(root)) for p in root.rglob('*') if p.is_file() and p.name!='manifest.json'}
for p,h in manifest.items():assert sha(root/p)==h,p
f=json.loads((r/'freeze.json').read_text())
for p,h in f['inputs'].items():assert sha(r/p)==h,p
for p,h in f['driver_files'].items():assert sha(Path(p))==h
for a in json.loads((r/'artifacts.json').read_text()).values():assert sha(Path(a['artifact']['preserved']))==a['artifact']['sha256']
for p in ['guard-before.json','guard-after.json','guard-analysis.json']:assert json.loads((r/p).read_text())==[]
variants=json.loads((r/'variants.json').read_text());names=['exact-0','exact-190','owner-0','owner-190','zgx-0','zgx-190'];assert list(variants)==names
base=[0,1,5,2,4,3];orders=[{'mode':'stream','group':g,'order':[names[(x+g)%6] for x in base]} for g in range(6)]
for mode in ['scroll','both']:
 for group in range(4):orders.append({'mode':mode,'group':group,'order':['exact-0','zgx-0'] if group%2==0 else ['zgx-0','exact-0']})
random.Random(20261108).shuffle(orders);assert json.loads((r/'order.json').read_text())==orders
assert (r/'order.json').read_bytes()==(root/'PROCESS_ORDER.json').read_bytes()
a=json.loads((r/'analysis.json').read_text());expected={(o['mode'],o['group'],l) for o in orders for l in o['order']};assert len(expected)==52
rows={(x['mode'],x['group'],x['label']):x for x in a['rows']};failures={(x['mode'],x['group'],x['label']):x for x in a['failures']};assert set(rows).isdisjoint(failures) and set(rows)|set(failures)==expected
for mode,g,label in expected:
 p=r/'runs'/mode/str(g)/label;status=json.loads((p/'status.json').read_text())
 if (mode,g,label) in failures:assert status==failures[mode,g,label]['status'] and (status['exit']!=0 or status['failure']);continue
 assert status['exit']==0 and status['failure'] is None
 row=rows[mode,g,label];s=json.loads((p/'summary.json').read_text());assert s==row['summary'];v=variants[label];assert s['initial_ticks']==v['initial'] and s['route']==v['route'] and s['name']==v['name'] and s['mode']==mode
 samples=json.loads((p/'samples.json').read_text());obs=[x for x in samples if s['visible_seconds']+1<=x['at']<=s['visible_seconds']+4 and x['state']!='Z'];duration=obs[-1]['at']-obs[0]['at'];cpu=obs[-1]['cpu_seconds']-obs[0]['cpu_seconds'];assert duration>=2.8
 assert (s['interval_start'],s['interval_end'],s['interval_seconds'],s['cpu_seconds'],s['cpu_cores'])==(obs[0]['at'],obs[-1]['at'],duration,cpu,cpu/duration)
 assert s['mean_rss_bytes']==statistics.mean(x['rss_bytes'] for x in obs) and s['max_rss_bytes']==max(x['rss_bytes'] for x in obs)
 log=(p/'app.log').read_text();env=json.loads((p/'environment.json').read_text());assert env['ZGX_INITIAL_TICKS']==str(v['initial']) and env['ZGX_SECONDS']=='6' and env['ZGX_MODE']==mode
 if v['name']=='candidate':
  assert env['GPUI_LAB_TRACE']=='1' and (env.get('GPUI_LAB_INGRESS')=='owner')==(v['route']=='owner')
  total,ticks,offset=re.findall(r'workload_ticks=(\d+) admitted_ticks=(\d+) workload_scroll_offset=([^\n]+)',log)[0];assert int(ticks)==s['ticks'] and int(total)==s['ticks']+v['initial']
  assert int(re.findall(r'native_acknowledgements=(\d+)',log)[0])==s['native_acknowledgements']
 else:
  final=[json.loads(x) for x in (p/'app.out').read_text().splitlines() if x.startswith('{') and '"adapter":"components"' in x];assert len(final)==1 and final[0]['ticks']-v['initial']==s['ticks']
 raw=json.loads((p/'tasks.json').read_text());obs=[o for o in raw['observations'] if s['interval_start']<=o['at']<=s['interval_end']];last={};totals={'main':0,'raster':0,'other':0};births=[];disappeared=set();previous=set()
 for i,o in enumerate(obs):
  present=set()
  for t in o['tasks']:
   key=f"{t['tid']}:{t['started']}";present.add(key)
   if i and key not in last:births.append(key)
   old=last.get(key,t['cpu_ticks'] if i==0 else 0);delta=t['cpu_ticks']-old;assert delta>=0;last[key]=t['cpu_ticks'];kind='main' if t['main'] else 'raster' if t['name'].startswith('llvmpipe-') else 'other';totals[kind]+=delta
  disappeared|=previous-present;previous=present
 seconds={k:v/raw['clock_ticks_per_second'] for k,v in totals.items()}
 for k,v in seconds.items():assert abs(v-row['task_seconds'][k])<1e-12 and abs(v/duration-row['task_cores'][k])<1e-12
 assert abs(cpu-sum(seconds.values())-row['residual_seconds'])<1e-12 and births==row['new_tasks'] and sorted(disappeared)==row['disappeared_tasks']
 acks=[{'source_epoch':int(x),'presentation_epoch':int(y),'at_ns':int(z)} for x,y,z in re.findall(r'^GPUI_ACK,(\d+),(\d+),(\d+)$',log,re.M)];assert row['ack_records']==acks
 pairs=[(q['at_ns']/1e9,(q['at_ns']-p['at_ns'])/1e6) for p,q in zip(acks,acks[1:])]
 for key,lo,hi in [('all',-1,float('inf')),('0-1',0,1),('1-2',1,2),('2-4',2,4),('4-6',4,6)]:
  values=[d for t,d in pairs if lo<=t<hi];actual={'count':len(values),'median_ms':statistics.median(values) if values else None,'max_ms':max(values) if values else None,'over25ms':sum(v>25 for v in values)};assert actual==(row['ack_gaps'] if key=='all' else row['ack_phases'][key])
for mode,items in a['aggregates'].items():
 for label,item in items.items():
  selected=[x for x in a['rows'] if x['mode']==mode and x['label']==label];n=sum(label in o['order'] for o in orders if o['mode']==mode);assert item['expected']==n and item['observed']==len(selected) and item['ticks']==[x['summary']['ticks'] for x in selected]
  if n==len(selected):
   for k in ['main','raster','other']:assert item['task_cores_median'][k]==statistics.median(x['task_cores'][k] for x in selected)
   assert item['process_cores_median']==statistics.median(x['summary']['cpu_cores'] for x in selected)
for p,item in json.loads((r/'loaded-modules.json').read_text()).items():assert sha(Path(p))==item['sha256']
print('verified',len(manifest),'files;',len(rows),'complete observations;',len(failures),'failures; two immutable executables; raw process/task/ACK attribution; diagnostic only')
