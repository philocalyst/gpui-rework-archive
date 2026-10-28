from pathlib import Path
import json,hashlib,statistics,re
from guard import check
r=Path(__file__).parent
check('guard-analysis.json')
orders=json.loads((r/'order.json').read_text());rows=[];failures=[];modules={}
def sha(p):return hashlib.file_digest(p.open('rb'),'sha256').hexdigest()
def gaps(seq):
 values=[x['gap_ms'] for x in seq];return {'count':len(values),'median_ms':statistics.median(values) if values else None,'max_ms':max(values) if values else None,'over25ms':sum(v>25 for v in values)}
for group in orders:
 for label in group['order']:
  p=r/'runs'/group['mode']/str(group['group'])/label;s=json.loads((p/'status.json').read_text())
  if s['exit']!=0 or s['failure'] is not None:failures.append({'mode':group['mode'],'group':group['group'],'label':label,'status':s});continue
  summary=json.loads((p/'summary.json').read_text());raw=json.loads((p/'tasks.json').read_text());obs=[o for o in raw['observations'] if summary['interval_start']<=o['at']<=summary['interval_end']];assert len(obs)>2
  hz=raw['clock_ticks_per_second'];last={};charges={};births=[];disappeared=set();previous=set()
  for index,o in enumerate(obs):
   present=set()
   for t in o['tasks']:
    key=f"{t['tid']}:{t['started']}";present.add(key)
    if index and key not in last:births.append(key)
    delta=t['cpu_ticks']-last.get(key,t['cpu_ticks'] if index==0 else 0);assert delta>=0
    kind='main' if t['main'] else 'raster' if t['name'].startswith('llvmpipe-') else 'other'
    charge=charges.setdefault(key,{'name':t['name'],'kind':kind,'cpu_ticks':0});assert charge['kind']==kind;charge['cpu_ticks']+=delta;last[key]=t['cpu_ticks']
   disappeared|=previous-present;previous=present
  duration=summary['interval_seconds'];seconds={k:sum(t['cpu_ticks']/hz for t in charges.values() if t['kind']==k) for k in ['main','raster','other']};rates={k:v/duration for k,v in seconds.items()}
  acks=[{'source_epoch':int(a),'presentation_epoch':int(b),'at_ns':int(c)} for a,b,c in re.findall(r'^GPUI_ACK,(\d+),(\d+),(\d+)$',(p/'app.log').read_text(),re.M)]
  assert all(b['at_ns']>=a['at_ns'] for a,b in zip(acks,acks[1:]))
  intervals=[{'at_seconds':b['at_ns']/1e9,'gap_ms':(b['at_ns']-a['at_ns'])/1e6} for a,b in zip(acks,acks[1:])]
  phase={f'{lo}-{hi}':gaps([a for a in intervals if lo<=a['at_seconds']<hi]) for lo,hi in [(0,1),(1,2),(2,4),(4,6)]}
  if summary['name']=='candidate':assert acks and len(acks)==summary['native_acknowledgements']
  row={'mode':group['mode'],'group':group['group'],'label':label,'summary':summary,'task_seconds':seconds,'task_cores':rates,'residual_seconds':summary['cpu_seconds']-sum(seconds.values()),'new_tasks':births,'disappeared_tasks':sorted(disappeared),'tasks':charges,'ack_records':acks,'ack_gaps':gaps(intervals),'ack_phases':phase};rows.append(row)
  for line in (p/'maps.txt').read_text().splitlines():
   parts=line.split(None,5)
   if len(parts)==6 and parts[5].startswith('/') and any(x in parts[5] for x in ['libvulkan','libLLVM','libEGL','libGLX','libgallium']):modules.setdefault(parts[5],{'sha256':sha(Path(parts[5])),'observed':[]})['observed'].append(f"{group['mode']}/{group['group']}/{label}")
aggregates={}
for mode in ['stream','scroll','both']:
 aggregates[mode]={}
 for label in dict.fromkeys(l for o in orders if o['mode']==mode for l in o['order']):
  selected=[x for x in rows if x['mode']==mode and x['label']==label];expected=sum(label in o['order'] for o in orders if o['mode']==mode)
  item={'expected':expected,'observed':len(selected),'ticks':[x['summary']['ticks'] for x in selected]}
  if len(selected)==expected:
   item.update({'task_cores_median':{k:statistics.median(x['task_cores'][k] for x in selected) for k in ['main','raster','other']},'process_cores_median':statistics.median(x['summary']['cpu_cores'] for x in selected),'residual_seconds':[x['residual_seconds'] for x in selected],'ack_phase_over25ms':{k:[x['ack_phases'][k]['over25ms'] for x in selected] for k in ['0-1','1-2','2-4','4-6']}})
  aggregates[mode][label]=item
(r/'analysis.json').write_text(json.dumps({'rows':rows,'failures':failures,'aggregates':aggregates,'note':'Diagnostic only; no performance acceptance or passing-subset inference'},indent=2));(r/'loaded-modules.json').write_text(json.dumps(modules,indent=2))
for mode,items in aggregates.items():
 for label,item in items.items():print(mode,label,json.dumps(item))
